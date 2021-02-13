defmodule Paapi5 do
  @moduledoc """
  Documentation for `Paapi5`.
  """

  @service "ProductAdvertisingAPI"

  defmodule Request do
    defstruct [:method, :url, :body, :headers]
  end

  def request(access_key, secret_key, partner_tag, _marketplace, operation, payload) do
    host = "webservices.amazon.it"
    region = "eu-west-1"

    endpoint = "https://#{host}/paapi5/searchitems"
    headers = %{
      # "host" => @host,
      # "content-type" => "application/json; charset=UTF-8",
      "x-amz-target" => "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.SearchItems",
      "content-encoding" => "amz-1.0",
    }

    payload = %{
      "PartnerTag" => partner_tag,
      "PartnerType" => "Associates",
      "Marketplace" => "www.amazon.it",
      "Operation" => operation
    } |> Map.merge(payload)

    current_time = DateTime.utc_now() |> DateTime.to_naive()
    encoded_payload = Jason.encode!(payload)

    signed_header =
      Paapi5.Auth.sign(
        access_key,
        secret_key,
        "POST",
        endpoint,
        region,
        @service,
        encoded_payload,
        headers,
        current_time
      )

    headers = [{"content-type", "application/json; charset=UTF-8"} | signed_header]

    %Request{
      method: "POST",
      url: endpoint,
      body: encoded_payload,
      headers: headers
    }
  end
end

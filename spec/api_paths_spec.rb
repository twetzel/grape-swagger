require 'spec_helper'

describe 'simple api with prefix' do

  before :all do
    class ApiWithPrefix < Grape::API
      prefix :api

      desc 'This gets apitest'
      get '/apitest' do
        { test: 'something' }
      end
    end

    class SimpleApiWithPrefix < Grape::API
      mount ApiWithPrefix
      add_swagger_documentation
    end

  end

  def app
    SimpleApiWithPrefix
  end

  it 'should not raise TypeError exception' do
  end

  it 'retrieves swagger-documentation on /swagger_doc that contains apitest' do
    get '/swagger_doc.json'
    expect(JSON.parse(last_response.body)).to eq(
      'apiVersion' => '0.1',
      'swaggerVersion' => '1.2',
      'info' => {},
      'produces' => Grape::ContentTypes::CONTENT_TYPES.values.uniq,
      'apis' => [
        { 'path' => '/apitest.{format}', 'description' => 'Operations about apitests' },
        { 'path' => '/swagger_doc.{format}', 'description' => 'Operations about swagger_docs' }
      ]
    )
  end

  context 'retrieves the documentation for apitest that' do
    it 'contains returns something in URL' do
      get '/swagger_doc/apitest.json'
      expect(JSON.parse(last_response.body)).to eq(
        'apiVersion' => '0.1',
        'swaggerVersion' => '1.2',
        'basePath' => 'http://example.org',
        'resourcePath' => '/apitest',
        'produces' => Grape::ContentTypes::CONTENT_TYPES.values.uniq,
        'apis' => [{
          'path' => '/api/apitest.{format}',
          'operations' => [{
            'notes' => '',
            'summary' => 'This gets apitest',
            'nickname' => 'GET-api-apitest---format-',
            'method' => 'GET',
            'parameters' => [],
            'type' => 'void'
          }]
        }]
      )
    end
  end

end

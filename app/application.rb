class Application

  @@items = [ 
    {name: "Figs", price: 3.42},
    {name: "Pears", price: 0.99}
  ]

  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      req_item = req.path.split("/items/").last
      found_item = @@items.find do |item|
        req_item == item.name
      end
      if found_item
        resp.write found_item.price
      else
        resp.write "Item not found"
        resp.status = 400
      end
    elsif req.path.match(/add/)
      added_item = req.params["item"]
      resp.write handle_add(added_item)
    elsif req.path.match(/cart/)
      if @@cart.length == 0
        resp.write "Your cart is empty\n"
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Route not found"
      resp.status = 404
    end

    resp.finish
  end

  def handle_add(added_item)
    if @@items.include?(added_item)
      @@cart << added_item
      return "added #{added_item}"
    else
      return "We don't have that item"
    end
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end

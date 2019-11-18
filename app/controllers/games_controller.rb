class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    @split_letters = @letters.split(' ').sort
    @split_word = @word.split('').sort
    from_grid = from_grid?(@split_word, @split_letters)
    word_found = word_found?(@word)
    @score = calculate_score(word_found, from_grid, @word)
    @from_grid_message = from_grid_message(from_grid)
    @word_found_message = word_found_message(word_found)
    session[:score] = 0 if session[:score].nil?
    session[:score] += @score
  end

  def from_grid?(split_word, split_letters)
    split_word.each do |w|
      split_letters.include?(w)
    end
  end

  def from_grid_message(grid)
    grid ? 'is in the grid' : 'is not in the grid'
  end

  def word_found?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end

  def word_found_message(word)
    if word
      'is a word!'
    else
      'is not an English word!'
    end
  end

  def calculate_score(word_found, grid, word)
    word.length * 3 if word_found && grid
  end
end

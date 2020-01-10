class UsersController < ApplicationController
    before_action :authorize_login, :only => [:login, :new]
    before_action :authorize_logout, :only => [:dashboard, :profile, :projects, :create_project, :show, :logout]
    def index
        @user = User.new
    end

    def login
        @user = User.new
    end

    def submit_login
        # render plain: user_params.inspect
        @user = User.find_by_email(user_params[:email])
        if @user and @user.authenticate(user_params[:password])
            session[:logged_in] = true
            session[:email] = user_params[:email]
            session[:userid] = @user[:userid]
            session[:id] = @user[:id]
            # render plain: @user[:id]
            redirect_to dashboard_users_path, :flash => { :success => "You are logged in successfully as #{session[:email]}" }
        else
            # render plain: user_params
            if user_params[:email] == "" and user_params[:password] == ""
                flash[:error] = "Please Provide Email And Password"
            elsif user_params[:email] == ""
                flash[:error] = "Please Provide Email Address"
            elsif user_params[:password] == ""
                flash[:error] = "Please Provide Password"
            elsif @user == nil
                flash[:error] = "Incorrect Email Provided"
            elsif @user != nil and @user[:email] != ""
                flash[:error] = "Incorrect Password Provided"
            else
                flash[:error] = "Please Provide Correct Email And Password"
            end

            render 'login'
        end
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user[:userid] = SecureRandom.uuid
        # render plain: @user.inspect
        if (@user.save)
            redirect_to login_users_path, :flash => { :success => "You have successfully signed up. Please login now" }
        else
            render 'new'
        end
    end

    def dashboard
    end

    def profile
    end

    def update
        # render plain: user_params.inspect
        # @user = User.find_by_email(user_params)
    end

    def submit_profile
        @user = User.find_by_email(session[:email])
        if user_params[:email] == ""
            flash[:error] = "Please Provide A Valid Email Address"
            render 'profile'
        elsif user_params[:fullname] == ""
            flash[:error] = "Please Provide Your Full Name"
            render 'profile'
        else
            if (@user.update(user_params))
                flash[:success] = "Profile Updated Successfully"
                redirect_to profile_users_path
            else
                flash[:error] = "Profile Not Updated"
                render 'profile'
            end
        end
    end

    def projects
        # @projects = @user.projects
        # render plain: @projects.inspect
    end

    def create_project
        @user = User.find_by_email(session[:email])
        # render plain: @user.inspect
    end

    def edit_project
        render plain: "Right Here Now"
    end

    def show
        @active = "profile"
    end

    def logout
        session[:logged_in] = session[:id] = session[:userid] = session[:email] = nil
        flash[:error] = "You have logged out successfuly! Please login again"
        redirect_to login_users_path
    end

    private
        def user_params
            params.require(:user).permit(:fullname, :email, :password)
        end

end
FROM fluent/fluentd-kubernetes-daemonset:v1.3-debian-cloudwatch-1

# Use root account to use apt
USER root

# install splunk-hec plugin
COPY Gemfile* /fluentd/
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && gem install bundler --version 1.16.2 \
    && bundle config silence_root_warning true \
    && bundle install --gemfile=/fluentd/Gemfile --path=/fluentd/vendor/bundle \
  && sudo gem sources --clear-all \
  && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
            /home/fluent/.gem/ruby/2.3.0/cache/*.gem

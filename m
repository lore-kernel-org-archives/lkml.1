Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZBJMyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZBJMyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZBJMyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:54:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBJMyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:54:40 -0500
Date: Tue, 10 Feb 2009 10:54:24 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210125424.GC12820@ghostprotocols.net>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990fdb7.0e0f660a.1d27.5399@mx.google.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 10, 2009 at 04:43:30AM +0100, Frederic Weisbecker escreveu:
> Add the missing pair tracing_{start,stop}_record_cmdline() to record well
> the cmdline associated with pid.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

This is another thing that I think begs for a TRACE_INIT_CMDLINE in
struct trace->flags so that just before calling ->init we call
tracing_start_cmdline_record? no?

Another thing I noticed is that even we having a ->stop most of the time
this semantic action is done thru ->reset :-\

- Arnaldo

>  kernel/trace/trace_sysprof.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
> index 84ca9d8..9902c15 100644
> --- a/kernel/trace/trace_sysprof.c
> +++ b/kernel/trace/trace_sysprof.c
> @@ -238,6 +238,8 @@ static int stack_trace_init(struct trace_array *tr)
>  {
>  	sysprof_trace = tr;
>  
> +	tracing_start_cmdline_record();
> +
>  	mutex_lock(&sample_timer_lock);
>  	start_stack_timers();
>  	tracer_enabled = 1;
> @@ -247,6 +249,7 @@ static int stack_trace_init(struct trace_array *tr)
>  
>  static void stack_trace_reset(struct trace_array *tr)
>  {
> +	tracing_stop_cmdline_record();
>  	stop_stack_trace(tr);
>  }

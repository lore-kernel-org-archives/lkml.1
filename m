Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZDQFpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZDQFpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZDQFox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:44:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33753 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZDQFow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MR4/SEIjH8xh7Mm50u3GmsZTWif04VJ1r2kMqDvDXErwCXDKrrOkEsAVavT5Uw08F+
         0It9vTE3IsERzZN3FSDgUZ+JsAQ8MxqJFk3WW68DTEksAwlwRmATnel8UaAZBC5hdbVd
         l8fzONR0c94PzwqD27fwlLblZI7syY+8bRdYo=
Date: Fri, 17 Apr 2009 07:44:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix file mode of trace and README
Message-ID: <20090417054447.GA6020@nowhere>
References: <49E7EAB6.4070605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E7EAB6.4070605@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:34:30AM +0800, Li Zefan wrote:
> trace is read-write and README is read-only.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 031c46f..f681f64 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4002,7 +4002,7 @@ static __init int tracer_init_debugfs(void)
>  	trace_create_file("available_tracers", 0444, d_tracer,
>  			&global_trace, &show_traces_fops);
>  
> -	trace_create_file("current_tracer", 0444, d_tracer,
> +	trace_create_file("current_tracer", 0644, d_tracer,
>  			&global_trace, &set_tracer_fops);



Oh!
I wonder how much time we ran with this false permission.
It clearly shows a bug in debugfs permission (or something
near this this layer), we have be running with this file
for a while and I've never seen any issue while writing into it.

And we have seen several patches with 0444 permissions for the
tracing tree containing writeable files, showing that the authors
ran them whithout problems.

Adding Greg in Cc.



>  
>  	trace_create_file("tracing_max_latency", 0644, d_tracer,
> @@ -4011,7 +4011,7 @@ static __init int tracer_init_debugfs(void)
>  	trace_create_file("tracing_thresh", 0644, d_tracer,
>  			&tracing_thresh, &tracing_max_lat_fops);
>  
> -	trace_create_file("README", 0644, d_tracer,
> +	trace_create_file("README", 0444, d_tracer,
>  			NULL, &tracing_readme_fops);



At least this one was harmless, but still it fixes the correctness.

Thanks,
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



>  	trace_create_file("trace_pipe", 0444, d_tracer,
> -- 
> 1.5.4.rc3
> 


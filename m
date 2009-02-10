Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZBJPGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZBJPGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZBJPGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:06:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBJPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c/jc5tHoFtfeRhDJnV6/faevCsC82mxvxDkndEtcD9QRqqjNGU5ajpJaGGXKe51PhQ
         Z3aC7X9ML4JUh2VyCr/qXAJE1nUVnm+HTKVPyiZCXofK6Z9h7w0xhGySsF3xpHtiI7qu
         kqRM/Da2AvtOMHqeFHY2t1274T4Sh0KYypEmQ=
Date: Tue, 10 Feb 2009 16:06:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] trace: provide correct return value after
	outputting the event.
Message-ID: <20090210150624.GG5836@nowhere>
References: <1234245785-14526-1-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234245785-14526-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:03:05AM -0500, Wenji Huang wrote:
> This patch is to make the function early return once failure and give
> correct return value in case of success.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_functions_graph.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 782ec0f..519a0ca 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -186,30 +186,30 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
>  	ret = trace_seq_printf(s,
>  		" ------------------------------------------\n");
>  	if (!ret)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	ret = print_graph_cpu(s, cpu);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	ret = print_graph_proc(s, prev_pid);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	ret = trace_seq_printf(s, " => ");
>  	if (!ret)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	ret = print_graph_proc(s, pid);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	ret = trace_seq_printf(s,
>  		"\n ------------------------------------------\n\n");
>  	if (!ret)
> -		TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return ret;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static struct ftrace_graph_ret_entry *
> -- 
> 1.5.6
> 

How could I have forgotten the return statements here...?

Anyway, the three patches look good.
Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


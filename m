Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbZKXOPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbZKXOPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbZKXOPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:15:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbZKXOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:15:17 -0500
Subject: Re: [tip:tracing/core] tracing, function tracer: Clean up
 strstrip() usage
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <tip-457dc928f586f3f4b930206965e6db270034e97e@git.kernel.org>
References: <new-submission>
	 <tip-457dc928f586f3f4b930206965e6db270034e97e@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 09:15:19 -0500
Message-Id: <1259072119.22249.1064.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Not sure if you noticed, but this was the first change in the git pull I
sent earlier. It was from Javier Martinez Canillas which he first posted
back on October 31st.

-- Steve

On Mon, 2009-11-23 at 11:53 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  457dc928f586f3f4b930206965e6db270034e97e
> Gitweb:     http://git.kernel.org/tip/457dc928f586f3f4b930206965e6db270034e97e
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 23 Nov 2009 11:03:28 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Nov 2009 11:04:07 +0100
> 
> tracing, function tracer: Clean up strstrip() usage
> 
> Clean up strstrip() usage - which also addresses this build warning:
> 
>   kernel/trace/ftrace.c: In function 'ftrace_pid_write':
>   kernel/trace/ftrace.c:3004: warning: ignoring return value of 'strstrip', declared with attribute warn_unused_result
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/ftrace.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7f9b51e..1dc101d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2985,7 +2985,7 @@ static ssize_t
>  ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
> -	char buf[64];
> +	char buf[64], *tmp;
>  	long val;
>  	int ret;
>  
> @@ -3001,11 +3001,11 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
>  	 * Allow "echo > set_ftrace_pid" or "echo -n '' > set_ftrace_pid"
>  	 * to clean the filter quietly.
>  	 */
> -	strstrip(buf);
> -	if (strlen(buf) == 0)
> +	tmp = strstrip(buf);
> +	if (strlen(tmp) == 0)
>  		return 1;
>  
> -	ret = strict_strtol(buf, 10, &val);
> +	ret = strict_strtol(tmp, 10, &val);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3391,4 +3391,3 @@ void ftrace_graph_stop(void)
>  	ftrace_stop();
>  }
>  #endif
> -


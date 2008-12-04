Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYLDXSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYLDXSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYLDXSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:18:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYLDXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:18:16 -0500
Date: Thu, 4 Dec 2008 18:18:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: fix the check of ftrace_trace_task
In-Reply-To: <49385E8B.7070900@gmail.com>
Message-ID: <alpine.DEB.1.10.0812041801480.32726@gandalf.stny.rr.com>
References: <49385E8B.7070900@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Frederic Weisbecker wrote:

> Impact: fix default empty traces on function-graph-tracer
> 
> The actual ftrace_trace_task() checks if ftrace_pid_trace is allocated
> and return 1 if it is true.
> If it is NULL, it will check the bit of pid tracing flag for the current
> task (which are not set by default).
> So by default, a task is not traced.
> Actually all tasks should be traced by default and filter_by_pid when
> ftrace_pid_trace is allocated.

Heh, I thought my output look funny. The function tracer does not use it 
since it registers a different function. But because the graph tracer
only shows the current task on switch (I did not look into trace options)
I could not really test it well.

-- Steve

Acked-by: Steven Rostedt <srostedt@redhat.com>

> 
> The appropriate condition should be to return 1 if filter_by_pid is
> set.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index a71bbe0..5ac6970 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -551,7 +551,7 @@ extern struct pid *ftrace_pid_trace;
>  
>  static inline int ftrace_trace_task(struct task_struct *task)
>  {
> -	if (ftrace_pid_trace)
> +	if (!ftrace_pid_trace)
>  		return 1;
>  
>  	return test_tsk_trace_trace(task);
> -- 
> 1.5.6.3
> 
> 
> 

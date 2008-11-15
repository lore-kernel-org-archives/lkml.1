Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYKOBsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYKOBsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 20:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYKOBsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 20:48:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYKOBsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 20:48:43 -0500
Date: Fri, 14 Nov 2008 20:48:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] tracing/function-return-tracer: Add a barrier to ensure
 return stack index is incremented in memory
In-Reply-To: <491E27E8.7050401@gmail.com>
Message-ID: <alpine.DEB.1.10.0811142046550.4873@gandalf.stny.rr.com>
References: <491E27E8.7050401@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 15 Nov 2008, Frederic Weisbecker wrote:

> Impact: Fix possible race condition in ftrace function return tracer
> 
> This fixes a possible race condition if index incrementation
> is not immediately flushed in memory.
> 
> Thanks for Andi Kleen and Steven Rostedt for pointing out this issue
> and give me this solution.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Andi Kleen <andi@firstfloor.org>
> ---
>  arch/x86/kernel/ftrace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index fe83273..db25236 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -56,6 +56,7 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
>  		return -EBUSY;
>  
>  	index = ++ti->curr_ret_stack;
> +	barrier();
>  	ti->ret_stack[index].ret = ret;
>  	ti->ret_stack[index].func = func;
>  	ti->ret_stack[index].calltime = time;


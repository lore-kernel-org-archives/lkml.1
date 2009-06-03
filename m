Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZFCOAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZFCOAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZFCN76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:59:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFCN75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:59:57 -0400
Date: Wed, 3 Jun 2009 09:59:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing/trace_stack: fix the number of entries in
 the header
In-Reply-To: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.2.00.0906030959310.14994@gandalf.stny.rr.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Jun 2009, walimis wrote:

> The last entry in the stack_dump_trace is ULONG_MAX, which is not
> a valid entry, but max_stack_trace.nr_entries has accounted for it.
> So when printing the header, we should decrease it by one.
> Before fix, print as following, for example:
> 
> 	Depth    Size   Location    (53 entries)	<--- should be 52
> 	-----    ----   --------
>   0)     3264     108   update_wall_time+0x4d5/0x9a0
>   ...
>  51)       80      80   syscall_call+0x7/0xb
>  ^^^
>    it's correct.
> 
> Signed-off-by: walimis <walimisdev@gmail.com>

This is one of those bugs I've been meaning to fix for a long time, but 
never got around to actually doing it. Thanks!

I'll queue this up.

-- Steve

> ---
>  kernel/trace/trace_stack.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
> index 1796f00..2d7aebd 100644
> --- a/kernel/trace/trace_stack.c
> +++ b/kernel/trace/trace_stack.c
> @@ -265,7 +265,7 @@ static int t_show(struct seq_file *m, void *v)
>  		seq_printf(m, "        Depth    Size   Location"
>  			   "    (%d entries)\n"
>  			   "        -----    ----   --------\n",
> -			   max_stack_trace.nr_entries);
> +			   max_stack_trace.nr_entries - 1);
>  
>  		if (!stack_tracer_enabled && !max_stack_size)
>  			print_disabled(m);
> -- 
> 1.6.0.3
> 
> 

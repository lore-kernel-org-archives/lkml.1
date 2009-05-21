Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZEUQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZEUQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZEUQOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:14:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZEUQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:14:15 -0400
Date: Thu, 21 May 2009 12:14:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, williams <williams@redhat.com>,
       tglx <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 ,v3] ftrace: fix typo in ftrace.txt file
In-Reply-To: <1242884365.31161.78.camel@centos51>
Message-ID: <alpine.DEB.2.00.0905211213520.4632@gandalf.stny.rr.com>
References: <1242884365.31161.78.camel@centos51>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 May 2009, GeunSik Lim wrote:

> 
> -- 
> 
> commit 16d92cb2334b19751db851d221aab814cd9da1af
> Author: GeunSik,Lim <leemgs1@gmail.com>
> Date:   Thu May 21 14:31:17 2009 +0900
> 
>             ftrace: fix typo in ftrace.txt file.
>     
>             Fix typo about chart to map the kernel priority to
>             user land priorities.
>     
>             * About sched_setscheduler(2)
>               Processes scheduled under SCHED_FIFO or SCHED_RR
>               can have a (user-space) static priority in the range 1 to 99.
>               (reference: http://www.kernel.org/doc/man-pages/online/pages/
>                           man2/sched_setscheduler.2.html)
>     
>             * From: Steven Rostedt
>               0 to 98 - maps to RT tasks 99 to 1 (SCHED_RR or SCHED_FIFO)
>     
>               99 - maps to internal kernel threads that want to be lower than RT tasks
>               but higher than SCHED_OTHER tasks. Although I'm not sure if any
>               kernel thread actually uses this. I'm not even sure how this can be
>               set, because the internal sched_setscheduler function does not allow
>               for it.
>     
>               100 to 139 - maps nice levels -20 to 19. These are not set via
>               sched_setscheduler, but are set via the nice system call.
>     
>               140 - reserved for idle tasks.
>     
>                 Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index fd9a3e6..e362f50 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -518,9 +518,18 @@ priority with zero (0) being the highest priority and the nice
>  values starting at 100 (nice -20). Below is a quick chart to map
>  the kernel priority to user land priorities.
>  
> -  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
> -  Kernel priority: 100 to 139 ==> user nice -20 to 19
> -  Kernel priority: 140        ==> idle task priority
> +   Kernel Space                     User Space
> + ===============================================================
> +   0(high) to  98(low)     user RT priority 99(high) to 1(low)
> +                           with SCHED_RR or SCHED_FIFO
> + ---------------------------------------------------------------
> +  99                       sched_priority is not used in scheduling
> +                           decisions(it must be specified as 0)
> + ---------------------------------------------------------------
> + 100(high) to 139(low)     user nice -20(high) to 19(low)
> + ---------------------------------------------------------------
> + 140                       idle task priority
> + ---------------------------------------------------------------
>  
>  The task states are:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks,

-- Steve


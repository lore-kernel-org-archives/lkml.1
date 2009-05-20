Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZETCAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZETCAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZETCAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:00:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZETCAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:00:06 -0400
Date: Tue, 19 May 2009 22:00:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: fix typo in ftrace.txt file
In-Reply-To: <1242783692.31161.56.camel@centos51>
Message-ID: <alpine.DEB.2.00.0905192153080.7816@gandalf.stny.rr.com>
References: <1242783692.31161.56.camel@centos51>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 May 2009, GeunSik Lim wrote:

> 
> 
> commit 43bf3fdddfd6b0ac65ef59bec3c79d9f9064e8bd
> Author: GeunSik,Lim <leemgs1@gmail.com>
> Date:   Thu May 14 13:39:18 2009 +0900
> 
>     ftrace: fix typo in ftrace.txt file.
>     
>     Fix typo about chart to map the kernel priority to
>     user land priorities.
>     
>     About sched_setscheduler(2)
>     Processes scheduled under SCHED_FIFO or SCHED_RR
>     can have a static priority in the range 1 to 99.
>     
>         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index fd9a3e6..0e17632 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -518,9 +518,14 @@ priority with zero (0) being the highest priority and the nice
>  values starting at 100 (nice -20). Below is a quick chart to map
>  the kernel priority to user land priorities.
>  
> -  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
> -  Kernel priority: 100 to 139 ==> user nice -20 to 19
> -  Kernel priority: 140        ==> idle task priority
> + Kernel priority: 0(high) to 99(low)    ==> user RT priority 99(high) to 1(low)

Shouldn't that be:

 Kernel priority: 0(high) to 98(low)    ==> user RT priority 99(high) to 1(low)

100 items does not map to 99. Which begs the question, what can have 
internal kernel priority 99?

> + Kernel priority: 100(high) to 139(low) ==> user nice -20(high) to 19(low)
> + Kernel priority: 140                   ==> idle task priority
> +
> +Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
> +the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR 

This line is confusing. "static priorty 0" really has no meaning here. 
Those now enter the "nice" priorities, and this statement does not 
represent what is shown in the ftrace output.

> +can have a static priority in the range 1 to 99. 
> + (reference: $> man 2 sched_setscheduler)
>  

-- Steve


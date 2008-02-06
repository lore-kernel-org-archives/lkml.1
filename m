Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYBFGhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYBFGhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYBFGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:37:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYBFGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:37:05 -0500
Subject: Re: RT scheduler config, suggestions and questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A8F328.5070107@qualcomm.com>
References: <47A8F328.5070107@qualcomm.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 07:36:55 +0100
Message-Id: <1202279815.19243.34.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 15:37 -0800, Max Krasnyanskiy wrote:
> Folks,
> 
> I just realized that in latest Linus' tree following sysctls are under SCHED_DEBUG:
> 	sched_rt_period
> 	sched_rt_ratio
> 
> I do not believe that is correct. I know that we do not want to expose scheduler knobs
> in general but theses are not the heuristic kind of knobs. There is no way the scheduler 
> can magically figure out what the correct setting should be here.

Yeah, since fixed.

> Also shouldn't those new RT features that recently went be configurable and _disabled_ 
> by default ? For example "RT watchdog" and "RT throttling" actually seem very questionable. 
> SCHED_FIFO is clearly defined as
> "
>   A SCHED_FIFO process runs until either it is blocked by an I/O request, it is preempted 
>   by a higher priority process, or it calls sched_yield(2).
> "

The watchdog is disabled by default, the bandwidth is .95s every 1s,
which is mainly a safe-guard against run-away real-time tasks. As long
as real-time usage stays within those limits nothing happens. If you
don't like it set sched_rt_runtime [*] to -1.

[*] provided in the interface changes posted a few days ago.

> Both the watchdog and the throttling are clearly braking that rule. I think it's good to have 
> those features but not enabled by default and certainly not with sysctls that disable them 
> hidden under debugging.
> How about this:
> - We introduce Kconfig options for them ?

I don't see why this would be needed.

> - Expose all rt sysctls outside of #ifdef DEBUG

Already did this somewhere along the line.

> btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
> But's it gotta be per thread.

It is.

> Single setting per user is not enough. Unless a use has a single RT task.

?


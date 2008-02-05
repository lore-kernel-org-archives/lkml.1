Return-Path: <linux-kernel-owner+w=401wt.eu-S1763247AbYBEXiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763247AbYBEXiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYBEXiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:38:16 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:56189 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYBEXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:38:16 -0500
Message-ID: <47A8F328.5070107@qualcomm.com>
Date: Tue, 05 Feb 2008 15:37:12 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RT scheduler config, suggestions and questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I just realized that in latest Linus' tree following sysctls are under SCHED_DEBUG:
	sched_rt_period
	sched_rt_ratio

I do not believe that is correct. I know that we do not want to expose scheduler knobs
in general but theses are not the heuristic kind of knobs. There is no way the scheduler 
can magically figure out what the correct setting should be here.

Also shouldn't those new RT features that recently went be configurable and _disabled_ 
by default ? For example "RT watchdog" and "RT throttling" actually seem very questionable. 
SCHED_FIFO is clearly defined as
"
  A SCHED_FIFO process runs until either it is blocked by an I/O request, it is preempted 
  by a higher priority process, or it calls sched_yield(2).
"

Both the watchdog and the throttling are clearly braking that rule. I think it's good to have 
those features but not enabled by default and certainly not with sysctls that disable them 
hidden under debugging.
How about this:
- We introduce Kconfig options for them ?
- Expose all rt sysctls outside of #ifdef DEBUG

I can kook up some patches if that sounds ok.

----

btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
But's it gotta be per thread. Single setting per user is not enough. Unless a use has a single 
RT task.

Max

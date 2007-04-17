Return-Path: <linux-kernel-owner+w=401wt.eu-S1031305AbXDQXvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031305AbXDQXvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031307AbXDQXvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:51:01 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:49993 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031305AbXDQXvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:51:00 -0400
Message-ID: <46255D5B.3000008@bigpond.net.au>
Date: Wed, 18 Apr 2007 09:50:51 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <4623B0C2.7080806@nortel.com> <46241ABE.5030604@bigpond.net.au> <4624ED3E.3070604@nortel.com>
In-Reply-To: <4624ED3E.3070604@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 23:50:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Peter Williams wrote:
>> Chris Friesen wrote:
>>> Scuse me if I jump in here, but doesn't the load balancer need some 
>>> way to figure out a) when to run, and b) which tasks to pull and 
>>> where to push them?
> 
>> Yes but both of these are independent of the scheduler discipline in 
>> force.
> 
> It is not clear to me that this is always the case, especially once you 
> mix in things like resource groups.
> 
>> If
>> the load balancer manages to keep the weighted (according to static 
>> priority) load and distribution of priorities within the loads on the 
>> CPUs roughly equal and the scheduler does a good job of ensuring 
>> fairness, interactive responsiveness etc. for the tasks within a CPU 
>> then the result will be good system performance within the constraints 
>> set by the sys admins use of real time priorities and nice.
> 
> Suppose I have a really high priority task running.  Another very high 
> priority task wakes up and would normally preempt the first one. 
> However, there happens to be another cpu available.  It seems like it 
> would be a win if we moved one of those tasks to the available cpu 
> immediately so they can both run simultaneously.  This would seem to 
> require some communication between the scheduler and the load balancer.

Not really the load balancer can do this on its own AND the decision 
should be based on the STATIC priority of the task being woken.

> 
> Certainly the above design could introduce a lot of context switching. 
> But if my goal is a scheduler that minimizes latency (even at the cost 
> of throughput) then that's an acceptable price to pay.

It would actually probably reduce context switching as putting the woken 
task on the best CPU at wake up means you don't have to move it later 
on.  The wake up code already does a little bit in this direction when 
it chooses which CPU to put a newly woken task on but could do more -- 
the only real cost would be the cost of looking at more candidate CPUs 
than it currently does.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

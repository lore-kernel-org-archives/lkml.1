Return-Path: <linux-kernel-owner+w=401wt.eu-S1422984AbXDRNAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422984AbXDRNAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422986AbXDRNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:00:30 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:50912 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422984AbXDRNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:00:29 -0400
Message-ID: <46261665.9090902@bigpond.net.au>
Date: Wed, 18 Apr 2007 23:00:21 +1000
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
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <4623B0C2.7080806@nortel.com> <46241ABE.5030604@bigpond.net.au> <4624ED3E.3070604@nortel.com> <46255D5B.3000008@bigpond.net.au> <4625B00A.7050702@nortel.com>
In-Reply-To: <4625B00A.7050702@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Wed, 18 Apr 2007 13:00:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Peter Williams wrote:
>> Chris Friesen wrote:
> 
>>> Suppose I have a really high priority task running.  Another very 
>>> high priority task wakes up and would normally preempt the first one. 
>>> However, there happens to be another cpu available.  It seems like it 
>>> would be a win if we moved one of those tasks to the available cpu 
>>> immediately so they can both run simultaneously.  This would seem to 
>>> require some communication between the scheduler and the load balancer.
>>
>>
>> Not really the load balancer can do this on its own AND the decision 
>> should be based on the STATIC priority of the task being woken.
> 
> I guess I don't follow.  How would the load balancer know that it needs 
> to run?  Running on every task wake-up seems expensive.  Also, static 
> priority isn't everything.  What about the gang-scheduler concept where 
> certain tasks must be scheduled simultaneously on different cpus?  What 
> about a resource-group scenario where you have per-cpu resource limits, 
> so that for good latency/fairness you need to force a high priority task 
> to migrate to another cpu once it has consumed the cpu allocation of 
> that group on the current cpu?
> 
> I can see having a generic load balancer core code, but it seems to me 
> that the scheduler proper needs to have some way of triggering the load 
> balancer to run,

It doesn't have to be closely coupled with the load balancer to does 
this.  It just needs to know where the trigger is.

> and some kind of goodness functions to indicate a) 
> which tasks to move, and b) where to move them.

That's the load balancer's job and even if you use dynamic priority for 
load balancing it still wouldn't need to be closely coupled.  The load 
balancer would just need to know how to find a process's dynamic priority.

In fact, in the current set up, the load balancer decides how much load 
needs to be moved based on the static load on the CPUs but uses dynamic 
priority (to a large degree) to decide which ones to move.  This is due 
more to computational efficiency considerations than any deliberate 
design (I suspect) as the fact that tasks are stored on the runqueue in 
dynamic priority order makes looking at processes in dynamic priority 
order is the most efficient strategy.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

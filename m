Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXDRFoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXDRFoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXDRFoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:44:11 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:52353 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXDRFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:44:10 -0400
Message-ID: <4625B00A.7050702@nortel.com>
Date: Tue, 17 Apr 2007 23:43:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Williams <pwil3058@bigpond.net.au>
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
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <4623B0C2.7080806@nortel.com> <46241ABE.5030604@bigpond.net.au> <4624ED3E.3070604@nortel.com> <46255D5B.3000008@bigpond.net.au>
In-Reply-To: <46255D5B.3000008@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2007 05:43:43.0219 (UTC) FILETIME=[8648BC30:01C7817C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Chris Friesen wrote:

>> Suppose I have a really high priority task running.  Another very high 
>> priority task wakes up and would normally preempt the first one. 
>> However, there happens to be another cpu available.  It seems like it 
>> would be a win if we moved one of those tasks to the available cpu 
>> immediately so they can both run simultaneously.  This would seem to 
>> require some communication between the scheduler and the load balancer.
> 
> 
> Not really the load balancer can do this on its own AND the decision 
> should be based on the STATIC priority of the task being woken.

I guess I don't follow.  How would the load balancer know that it needs 
to run?  Running on every task wake-up seems expensive.  Also, static 
priority isn't everything.  What about the gang-scheduler concept where 
certain tasks must be scheduled simultaneously on different cpus?  What 
about a resource-group scenario where you have per-cpu resource limits, 
so that for good latency/fairness you need to force a high priority task 
to migrate to another cpu once it has consumed the cpu allocation of 
that group on the current cpu?

I can see having a generic load balancer core code, but it seems to me 
that the scheduler proper needs to have some way of triggering the load 
balancer to run, and some kind of goodness functions to indicate a) 
which tasks to move, and b) where to move them.

Chris


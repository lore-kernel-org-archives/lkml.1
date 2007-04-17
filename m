Return-Path: <linux-kernel-owner+w=401wt.eu-S1031040AbXDQPxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031040AbXDQPxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031098AbXDQPxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:53:03 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:35837 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031097AbXDQPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:53:00 -0400
Message-ID: <4624ED3E.3070604@nortel.com>
Date: Tue, 17 Apr 2007 09:52:30 -0600
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
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <4623B0C2.7080806@nortel.com> <46241ABE.5030604@bigpond.net.au>
In-Reply-To: <46241ABE.5030604@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2007 15:52:34.0543 (UTC) FILETIME=[6A3CA7F0:01C78108]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Chris Friesen wrote:
>> Scuse me if I jump in here, but doesn't the load balancer need some 
>> way to figure out a) when to run, and b) which tasks to pull and where 
>> to push them?

> Yes but both of these are independent of the scheduler discipline in force.

It is not clear to me that this is always the case, especially once you 
mix in things like resource groups.

> If
> the load balancer manages to keep the weighted (according to static 
> priority) load and distribution of priorities within the loads on the 
> CPUs roughly equal and the scheduler does a good job of ensuring 
> fairness, interactive responsiveness etc. for the tasks within a CPU 
> then the result will be good system performance within the constraints 
> set by the sys admins use of real time priorities and nice.

Suppose I have a really high priority task running.  Another very high 
priority task wakes up and would normally preempt the first one. 
However, there happens to be another cpu available.  It seems like it 
would be a win if we moved one of those tasks to the available cpu 
immediately so they can both run simultaneously.  This would seem to 
require some communication between the scheduler and the load balancer.

Certainly the above design could introduce a lot of context switching. 
But if my goal is a scheduler that minimizes latency (even at the cost 
of throughput) then that's an acceptable price to pay.

Chris

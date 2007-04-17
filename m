Return-Path: <linux-kernel-owner+w=401wt.eu-S1031046AbXDQAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046AbXDQAyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031043AbXDQAyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:54:31 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:55887 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031046AbXDQAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:54:30 -0400
Message-ID: <46241ABE.5030604@bigpond.net.au>
Date: Tue, 17 Apr 2007 10:54:22 +1000
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
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <4623B0C2.7080806@nortel.com>
In-Reply-To: <4623B0C2.7080806@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 00:54:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Peter Williams wrote:
> 
>> To my mind scheduling and load balancing are orthogonal and keeping 
>> them that way simplifies things.
> 
> Scuse me if I jump in here, but doesn't the load balancer need some way 
> to figure out a) when to run, and b) which tasks to pull and where to 
> push them?

Yes but both of these are independent of the scheduler discipline in force.

> 
> I suppose you could abstract this into a per-scheduler API, but to me at 
> least these are the hard parts of the load balancer...

Load balancing needs to be based on the static priorities (i.e. nice or 
real time priority) of the runnable tasks not the dynamic priorities. 
If the load balancer manages to keep the weighted (according to static 
priority) load and distribution of priorities within the loads on the 
CPUs roughly equal and the scheduler does a good job of ensuring 
fairness, interactive responsiveness etc. for the tasks within a CPU 
then the result will be good system performance within the constraints 
set by the sys admins use of real time priorities and nice.

The smpnice modifications to the load balancer were meant to give it the 
appropriate behaviour and what we need to fix now is the intra CPU 
scheduling.

Even if the load balancer isn't yet perfect perfecting it can be done 
separately to fixing the scheduler preferably with as little 
interdependency as possible.  Probably the only contribution to load 
balancing that the scheduler really needs to make is the calculating of 
the average weighted load on each of the CPUs (or run queues if there's 
more than one CPU per runqueue).

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

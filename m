Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXDUIIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXDUIIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXDUIII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:08:08 -0400
Received: from omta02ps.mx.bigpond.com ([144.140.83.154]:41405 "EHLO
	omta02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192AbXDUIIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:08:06 -0400
Message-ID: <4629C65C.2050309@bigpond.net.au>
Date: Sat, 21 Apr 2007 18:07:56 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Williams <pwil3058@bigpond.net.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420064600.GA24614@elte.hu> <46286CA0.2050409@bigpond.net.au> <4628B1DF.8000400@bigpond.net.au>
In-Reply-To: <4628B1DF.8000400@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Sat, 21 Apr 2007 08:08:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Peter Williams wrote:
>> Ingo Molnar wrote:
>>> your suggestion concentrates on the following scenario: if a task 
>>> happens to schedule in an 'unlucky' way and happens to hit a busy 
>>> period while there are many idle periods. Unless i misunderstood your 
>>> suggestion, that is the main intention behind it, correct?
>>
>> You misunderstand (that's one of my other schedulers :-)).  This one's 
>> based on the premise that if everything happens as the task expects it 
>> will get the amount of CPU bandwidth (over this short period) that 
>> it's entitled to.  In reality, sometimes it will get more and 
>> sometimes less but on average it should get what it deserves. E.g. If 
>> you had two tasks with equal nice and both had demands of 90% of a CPU 
>> you'd expect them each to get about half of the CPU bandwidth.  Now 
>> suppose that one of them uses 5ms of CPU each time it got onto the CPU 
>> and the other uses 10ms.  If these two tasks just round robin with 
>> each other the likely outcome is that the one with the 10ms bursts 
>> will get twice as much CPU as the other but my proposed method should 
>> prevent and cause them to get roughly the same amount of CPU.  (I 
>> believe this was a scenario that caused problems with O(1) and 
>> required a fix at some stage?)

Another advantage of this mechanism is that, all else being equal, it 
will tend to run tasks that use short bursts of CPU ahead of those that 
use long bursts and this tends to reduce the overall time spent waiting 
for CPU by all tasks on the system which is good for throughput.  I.e. 
in general, a task that tends to use short bursts of CPU will make other 
tasks wait less time than will one that tends to use long bursts.

So this means that you were right and it is good in the scenario that 
you suggested even though that wasn't the motivation behind the design.

This means that this scheduler should be good for improving latency on 
servers that aren't fully loaded as well as providing good fairness and 
responsiveness when the system is fully loaded.  (Fingers crossed.)

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

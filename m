Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXDQIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXDQIa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXDQIa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:30:57 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:39452 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXDQIa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:30:56 -0400
Message-ID: <462485B8.8090404@bigpond.net.au>
Date: Tue, 17 Apr 2007 18:30:48 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au> <20070417075146.GM2986@holomorphy.com>
In-Reply-To: <20070417075146.GM2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 08:30:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Ingo Molnar wrote:
>>> this is the second release of the CFS (Completely Fair Scheduler) 
>>> patchset, against v2.6.21-rc7:
>>>    http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
>>> i'd like to thank everyone for the tremendous amount of feedback and 
>>> testing the v1 patch got - i could hardly keep up with just reading the 
>>> mails! Some of the stuff people addressed i couldnt implement yet, i 
>>> mostly concentrated on bugs, regressions and debuggability.
> 
> On Tue, Apr 17, 2007 at 04:46:57PM +1000, Peter Williams wrote:
>> Have you considered using rq->raw_weighted_load instead of 
>> rq->nr_running in calculating fair_clock?  This would take the nice 
>> value (or RT priority) of the other tasks into account when determining 
>> what's fair.
> 
> I suspect you mean (curr->load_weight*delta_exec)/rq->raw_weighted_load
> in update_curr().

Or something like that, yes. :-)

I was trying to make the point that the weighted load stuff provides 
useful data for implementing nice (in a number of ways e.g. see spa_ebs).

Also, now that the old time slices are gone, a simpler more efficient 
function for mapping RT priority or nice (as appropriate) to 
p->load_weight can be used instead of the current one which uses the 
time slice the task would have been allocated as a basis.  I'd suggest 
the function that the current one replaced.  (Because it was mine :-)).

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

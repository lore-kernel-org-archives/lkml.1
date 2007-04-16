Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbXDPDFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbXDPDFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXDPDFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:05:53 -0400
Received: from holomorphy.com ([66.93.40.71]:45310 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXDPDFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:05:52 -0400
Date: Sun, 15 Apr 2007 20:04:05 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416030405.GI8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4622CC30.6030707@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> One of the reasons I never posted my own code is that it never met its
>> own design goals, which absolutely included switching on the fly. I
>> think Peter Williams may have done something about that.
>> It was my hope
>> to be able to do insmod sched_foo.ko until it became clear that the
>> effort it was intended to assist wasn't going to get even the limited
>> hardware access required, at which point I largely stopped working on
>> it.

On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
> I didn't but some students did.
> In a previous life, I did implement a runtime configurable CPU 
> scheduling mechanism (implemented on True64, Solaris and Linux) that 
> allowed schedulers to be loaded as modules at run time.  This was 
> released commercially on True64 and Solaris.  So I know that it can be done.
> I have thought about doing something similar for the SPA schedulers 
> which differ in only small ways from each other but lack motivation.

Driver models for scheduling are not so far out. AFAICS it's largely a
tug-of-war over design goals, e.g. maintaining per-cpu runqueues and
switching out intra-queue policies vs. switching out whole-system
policies, SMP handling and all. Whether this involves load balancing
depends strongly on e.g. whether you have per-cpu runqueues. A 2.4.x
scheduler module, for instance, would not have a load balancer at all,
as it has only one global runqueue. There are other sorts of policies
wanting significant changes to SMP handling vs. the stock load
balancing.


William Lee Irwin III wrote:
>> I'm not sure what happened there. It wasn't a big enough patch to take
>> hits in this area due to getting overwhelmed by the programming burden
>> like some other efforts of mine. Maybe things started getting ugly once
>> on-the-fly switching entered the picture. My guess is that Peter Williams
>> will have to chime in here, since things have diverged enough from my
>> one-time contribution 4 years ago.

On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
> From my POV, the current version of plugsched is considerably simpler 
> than it was when I took the code over from Con as I put considerable 
> effort into minimizing code overlap in the various schedulers.
> I also put considerable effort into minimizing any changes to the load 
> balancing code (something Ingo seems to think is a deficiency) and the 
> result is that plugsched allows "intra run queue" scheduling to be 
> easily modified WITHOUT effecting load balancing.  To my mind scheduling 
> and load balancing are orthogonal and keeping them that way simplifies 
> things.

ISTR rearranging things for con in such a fashion that it no longer
worked out of the box (though that wasn't the intention; restructuring it
to be more suited to his purposes was) and that's what he worked off of
afterward. I don't remember very well what changed there as I clearly
invested less effort there than the prior versions. Now that I think of
it, that may have been where the sample policy demonstrating scheduling
classes was lost.


On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
> As Ingo correctly points out, plugsched does not allow different 
> schedulers to be used per CPU but it would not be difficult to modify it 
> so that they could.  Although I've considered doing this over the years 
> I decided not to as it would just increase the complexity and the amount 
> of work required to keep the patch set going.  About six months ago I 
> decided to reduce the amount of work I was doing on plugsched (as it was 
> obviously never going to be accepted) and now only publish patches 
> against the vanilla kernel's major releases (and the only reason that I 
> kept doing that is that the download figures indicated that about 80 
> users were interested in the experiment).

That's a rather different goal from what I was going on about with it,
so it's all diverged quite a bit. Where I had a significant need for
mucking with the entire concept of how SMP was handled, this is rather
different. At this point I'm questioning the relevance of my own work,
though it was already relatively marginal as it started life as an
attempt at a sort of debug patch to help gang scheduling (which is in
itself a rather marginally relevant feature to most users) code along.


On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
> PS I no longer read LKML (due to time constraints) and would appreciate 
> it if I could be CC'd on any e-mails suggesting scheduler changes.
> PPS I'm just happy to see that Ingo has finally accepted that the 
> vanilla scheduler was badly in need of fixing and don't really care who 
> fixes it.
> PPS Different schedulers for different aims (i.e. server or work 
> station) do make a difference.  E.g. the spa_svr scheduler in plugsched 
> does about 1% better on kernbench than the next best scheduler in the bunch.
> PPPS Con, fairness isn't always best as humans aren't very altruistic 
> and we need to give unfair preference to interactive tasks in order to 
> stop the users flinging their PCs out the window.  But the current 
> scheduler doesn't do this very well and is also not very good at 
> fairness so needs to change.  But the changes need to address 
> interactive response and fairness not just fairness.

Kernel compiles not so useful a benchmark. SDET, OAST, AIM7, etc. are
better ones. I'd not bother citing kernel compile results.

In any event, I'm not sure what to say about different schedulers for
different aims. My intentions with plugsched were not centered around
production usage or intra-queue policy. I'm relatively indifferent to
the notion of having pluggable CPU schedulers, intra-queue or otherwise,
in mainline. I don't see any particular harm in it, but neither am I
particularly motivated to have it in. I had a rather strong sense of
instrumentality about it, and since it became useless to me (at a
conceptual level; the implementation was never finished ot the point of
dynamic loading of scheduler modules) for assisting development on
large systems via reboot avoidance by dint of it becoming clear that
access to such was never going to happen, I've stopped looking at it.


-- wli

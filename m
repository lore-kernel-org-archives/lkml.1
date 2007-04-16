Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXDPBu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXDPBu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 21:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXDPBu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 21:50:29 -0400
Received: from qsrv03ps.mx.bigpond.com ([144.140.82.183]:62528 "EHLO
	qsrv03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXDPBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 21:50:28 -0400
Message-ID: <4622CC30.6030707@bigpond.net.au>
Date: Mon, 16 Apr 2007 11:06:56 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com>
In-Reply-To: <20070415233909.GE2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 01:07:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
>> 2) plugsched did not allow on the fly selection of schedulers, nor did
>>    it allow a per CPU selection of schedulers. IO schedulers you can 
>>    change per disk, on the fly, making them much more useful in
>>    practice. Also, IO schedulers (while definitely not being slow!) are 
>>    alot less performance sensitive than CPU schedulers.
> 
> One of the reasons I never posted my own code is that it never met its
> own design goals, which absolutely included switching on the fly. I
> think Peter Williams may have done something about that.

I didn't but some students did.

In a previous life, I did implement a runtime configurable CPU 
scheduling mechanism (implemented on True64, Solaris and Linux) that 
allowed schedulers to be loaded as modules at run time.  This was 
released commercially on True64 and Solaris.  So I know that it can be done.

I have thought about doing something similar for the SPA schedulers 
which differ in only small ways from each other but lack motivation.

> It was my hope
> to be able to do insmod sched_foo.ko until it became clear that the
> effort it was intended to assist wasn't going to get even the limited
> hardware access required, at which point I largely stopped working on
> it.
> 
> 
> On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
>> 3) I/O schedulers are pretty damn clean code, and plugsched, at least
>>    the last version i saw of it, didnt come even close.
> 
> I'm not sure what happened there. It wasn't a big enough patch to take
> hits in this area due to getting overwhelmed by the programming burden
> like some other efforts of mine. Maybe things started getting ugly once
> on-the-fly switching entered the picture. My guess is that Peter Williams
> will have to chime in here, since things have diverged enough from my
> one-time contribution 4 years ago.

 From my POV, the current version of plugsched is considerably simpler 
than it was when I took the code over from Con as I put considerable 
effort into minimizing code overlap in the various schedulers.

I also put considerable effort into minimizing any changes to the load 
balancing code (something Ingo seems to think is a deficiency) and the 
result is that plugsched allows "intra run queue" scheduling to be 
easily modified WITHOUT effecting load balancing.  To my mind scheduling 
and load balancing are orthogonal and keeping them that way simplifies 
things.

As Ingo correctly points out, plugsched does not allow different 
schedulers to be used per CPU but it would not be difficult to modify it 
so that they could.  Although I've considered doing this over the years 
I decided not to as it would just increase the complexity and the amount 
of work required to keep the patch set going.  About six months ago I 
decided to reduce the amount of work I was doing on plugsched (as it was 
obviously never going to be accepted) and now only publish patches 
against the vanilla kernel's major releases (and the only reason that I 
kept doing that is that the download figures indicated that about 80 
users were interested in the experiment).

Peter
PS I no longer read LKML (due to time constraints) and would appreciate 
it if I could be CC'd on any e-mails suggesting scheduler changes.
PPS I'm just happy to see that Ingo has finally accepted that the 
vanilla scheduler was badly in need of fixing and don't really care who 
fixes it.
PPS Different schedulers for different aims (i.e. server or work 
station) do make a difference.  E.g. the spa_svr scheduler in plugsched 
does about 1% better on kernbench than the next best scheduler in the bunch.
PPPS Con, fairness isn't always best as humans aren't very altruistic 
and we need to give unfair preference to interactive tasks in order to 
stop the users flinging their PCs out the window.  But the current 
scheduler doesn't do this very well and is also not very good at 
fairness so needs to change.  But the changes need to address 
interactive response and fairness not just fairness.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

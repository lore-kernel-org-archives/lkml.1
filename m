Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXDPGsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXDPGsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXDPGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:48:43 -0400
Received: from qsrv02ps.mx.bigpond.com ([144.140.83.182]:38211 "EHLO
	qsrv02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXDPGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:48:42 -0400
Message-ID: <46230950.8000005@bigpond.net.au>
Date: Mon, 16 Apr 2007 15:27:44 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415153933.GB6623@elte.hu>
In-Reply-To: <20070415153933.GB6623@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 05:27:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Willy Tarreau <w@1wt.eu> wrote:
> 
>> Ingo could have publicly spoken with them about his ideas of killing 
>> the O(1) scheduler and replacing it with an rbtree-based one, [...]
> 
> yes, that's precisely what i did, via a patchset :)
> 
> [ I can even tell you when it all started: i was thinking about Mike's
>   throttling patches while watching Manchester United beat the crap out
>   of AS Roma (7 to 1 end result), Thuesday evening. I started coding it
>   Wednesday morning and sent the patch Friday evening. I very much
>   believe in low-latency when it comes to development too ;) ]
> 
> (if this had been done via a comittee then today we'd probably still be 
> trying to find a suitable timeslot for the initial conference call where 
> we'd discuss the election of a chair who would be tasked with writing up 
> an initial document of feature requests, on which we'd take a vote, 
> possibly this year already, because the matter is really urgent you know 
> ;-)
> 
>> [...] and using part of Bill's work to speed up development.
> 
> ok, let me make this absolutely clear: i didnt use any bit of plugsched 
> - in fact the most difficult bits of the modularization was for areas of 
> sched.c that plugsched never even touched AFAIK. (the load-balancer for 
> example.)

This sounds like your new scheduler intends to increase the coupling 
between scheduling and load balancing.  I think that this would be a 
mistake and lead (down the track) to spiralling complexity as you make 
changes to the code to address the corner conditions that it will create.

> 
> Plugsched simply does something else: i modularized scheduling policies 
> in essence that have to cooperate with each other, while plugsched 
> modularized complete schedulers which are compile-time or boot-time 
> selected, with no runtime cooperation between them. (one has to be 
> selected at a time)

You can't really have more than one scheduler operating in the same 
priority range on the same CPU as they will be fighting each other 
trying to achieve their separate and not necessarily compatible (in fact 
highly likely to be incompatible) aims.  Multiple schedulers on the same 
CPU have to have a pecking order just like SCHED_OTHER and real time 
policies.  It wouldn't be hard to prove that SCHED_RR and SCHED_FIFO is 
a problem in waiting if ever someone tried to use them both on a highly 
real time system.

> 
> (and i have no trouble at all with crediting Will's work either: a few 
> years ago i used Will's PID rework concepts for an NPTL related speedup 
> and Will is very much credited for it in today's kernel/pid.c and he 
> continued to contribute to it later on.)
> 
> (the tree walking bits of sched_fair.c were in fact derived from 
> kernel/hrtimer.c, the rbtree code written by Thomas and me :-)
> 
> 	Ingo

Are your new patches available somewhere for easy download or do I have 
to try to dig them out of the mailing list archive?  Or could you mail 
them to me separately?  I'm keen to see how you new scheduler proposal 
works.

Thanks
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

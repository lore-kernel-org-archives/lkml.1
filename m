Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXDOPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXDOPj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXDOPj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:39:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbXDOPj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:39:57 -0400
Date: Sun, 15 Apr 2007 17:39:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415153933.GB6623@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415124527.GP943@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Ingo could have publicly spoken with them about his ideas of killing 
> the O(1) scheduler and replacing it with an rbtree-based one, [...]

yes, that's precisely what i did, via a patchset :)

[ I can even tell you when it all started: i was thinking about Mike's
  throttling patches while watching Manchester United beat the crap out
  of AS Roma (7 to 1 end result), Thuesday evening. I started coding it
  Wednesday morning and sent the patch Friday evening. I very much
  believe in low-latency when it comes to development too ;) ]

(if this had been done via a comittee then today we'd probably still be 
trying to find a suitable timeslot for the initial conference call where 
we'd discuss the election of a chair who would be tasked with writing up 
an initial document of feature requests, on which we'd take a vote, 
possibly this year already, because the matter is really urgent you know 
;-)

> [...] and using part of Bill's work to speed up development.

ok, let me make this absolutely clear: i didnt use any bit of plugsched 
- in fact the most difficult bits of the modularization was for areas of 
sched.c that plugsched never even touched AFAIK. (the load-balancer for 
example.)

Plugsched simply does something else: i modularized scheduling policies 
in essence that have to cooperate with each other, while plugsched 
modularized complete schedulers which are compile-time or boot-time 
selected, with no runtime cooperation between them. (one has to be 
selected at a time)

(and i have no trouble at all with crediting Will's work either: a few 
years ago i used Will's PID rework concepts for an NPTL related speedup 
and Will is very much credited for it in today's kernel/pid.c and he 
continued to contribute to it later on.)

(the tree walking bits of sched_fair.c were in fact derived from 
kernel/hrtimer.c, the rbtree code written by Thomas and me :-)

	Ingo

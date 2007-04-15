Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXDOUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXDOUsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXDOUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:48:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbXDOUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:48:45 -0400
Date: Sun, 15 Apr 2007 22:48:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Con Kolivas <kernel@kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415204824.GA25813@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415200535.GC11166@waste.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> Look at what happened with I/O scheduling. Opening things up to some 
> new ideas by making it possible to select your I/O scheduler took us 
> from 10 years of stagnation to healthy, competitive development, which 
> gave us a substantially better I/O scheduler.

actually, 2-3 years ago we already had IO schedulers, and my opinion 
against plugsched back then (also shared by Nick and Linus) was very 
much considering them. There are at least 4 reasons why I/O schedulers 
are different from CPU schedulers:

1) CPUs are a non-persistent resource shared by _all_ tasks and 
   workloads in the system. Disks are _persistent_ resources very much 
   attached to specific workloads. (If tasks had to be 'persistent' to
   the CPU they were started on we'd have much different scheduling
   technology, and there would be much less complexity.) More analogous 
   to CPU schedulers would perhaps be VM/MM schedulers, and those tend 
   to be hard to modularize in a technologically sane way too. (and 
   unlike disks there's no good generic way to attach VM/MM schedulers 
   to particular workloads.) So it's apples to oranges.

   in practice it comes down to having one good scheduler that runs all 
   workloads on a system reasonably well. And given that a very large 
   portion of system runs mixed workloads, the demand for one good 
   scheduler is pretty high. While i can run with mixed IO schedulers 
   just fine.

2) plugsched did not allow on the fly selection of schedulers, nor did
   it allow a per CPU selection of schedulers. IO schedulers you can 
   change per disk, on the fly, making them much more useful in
   practice. Also, IO schedulers (while definitely not being slow!) are 
   alot less performance sensitive than CPU schedulers.

3) I/O schedulers are pretty damn clean code, and plugsched, at least
   the last version i saw of it, didnt come even close.

4) the good thing that happened to I/O, after years of stagnation isnt
   I/O schedulers. The good thing that happened to I/O is called Jens
   Axboe. If you care about the I/O subystem then print that name out 
   and hang it on the wall. That and only that is what mattered.

all in one, while there are definitely uses (embedded would like to have 
a smaller/different scheduler, etc.), the technical case for 
modularization for the sake of selectability is alot lower for CPU 
schedulers than it is for I/O schedulers.

nor was the non-modularity of some piece of code ever an impediment to 
competition. May i remind you of the pretty competitive SLAB allocator 
landscape, resulting in things like the SLOB allocator, written by 
yourself? ;-)

	Ingo

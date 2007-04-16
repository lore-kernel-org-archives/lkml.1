Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbXDPDD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbXDPDD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXDPDD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:03:56 -0400
Received: from ns.suse.de ([195.135.220.2]:36426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbXDPDDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:03:55 -0400
Date: Mon, 16 Apr 2007 05:03:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416030349.GB13626@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415213153.GW11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415213153.GW11115@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 04:31:54PM -0500, Matt Mackall wrote:
> On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
>  
> > 4) the good thing that happened to I/O, after years of stagnation isnt
> >    I/O schedulers. The good thing that happened to I/O is called Jens
> >    Axboe. If you care about the I/O subystem then print that name out 
> >    and hang it on the wall. That and only that is what mattered.
> 
> Disagree. Things didn't actually get interesting until Nick showed up
> with AS and got it in-tree to demonstrate the huge amount of room we
> had for improvement. It took several iterations of AS and CFQ (with a
> couple complete rewrites) before CFQ began to look like the winner.
> The resulting time-sliced CFQ was fairly heavily influenced by the
> ideas in AS.

Well to be fair, Jens had just implemented deadline, which got me
interested ;)

Actually, I would still like to be able to deprecate deadline for
AS, because AS has a tunable that you can switch to turn off read
anticipation and revert to deadline behaviour (or very close to).

It would have been nice if CFQ were then a layer on top of AS that
implemented priorities (or vice versa). And then AS could be
deprecated and we'd be back to 1 primary scheduler.

Well CFQ seems to be going in the right direction with that, however
some large users still find AS faster for some reason...

Anyway, moral of the story is that I think it would have been nice
if we hadn't proliferated IO schedulers, however in practice it
isn't easy to just layer features on top of each other, and also
keeping deadline helped a lot to be able to debug and examine
performance regressions and actually get code upstream. And this
was true even when it was globally boottine switchable only.

I'd prefer if we kept a single CPU scheduler in mainline, because I
think that simplifies analysis and focuses testing. I think we can
have one that is good enough for everyone. But if the only other
option for progress is that Linus or Andrew just pull one out of a
hat, then I would rather merge all of them. Yes I think Con's
scheduler should get a fair go, ditto for Ingo's, mine, and anyone
else's.


> > nor was the non-modularity of some piece of code ever an impediment to 
> > competition. May i remind you of the pretty competitive SLAB allocator 
> > landscape, resulting in things like the SLOB allocator, written by 
> > yourself? ;-)
> 
> Thankfully no one came out and said "we don't want to balkanize the
> allocator landscape" when I submitted it or I probably would have just
> dropped it, rather than painfully dragging it along out of tree for
> years. I'm not nearly the glutton for punishment that Con is. :-P

I don't think this is a fault of the people or the code involved.
We just didn't have much collective drive to replace the scheduler,
and even less an idea of how to decide between any two of them.

I've kept nicksched around since 2003 or so and no hard feelings ;)


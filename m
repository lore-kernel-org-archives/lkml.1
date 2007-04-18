Return-Path: <linux-kernel-owner+w=401wt.eu-S2992960AbXDRSC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992960AbXDRSC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992974AbXDRSC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:02:28 -0400
Received: from holomorphy.com ([66.93.40.71]:50676 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992960AbXDRSC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:02:27 -0400
Date: Wed, 18 Apr 2007 11:02:03 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418180203.GC31925@holomorphy.com>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 10:22:59AM -0700, Linus Torvalds wrote:
> So I claim that anything that cannot be fair by user ID is actually really 
> REALLY unfair. I think it's absolutely humongously STUPID to call 
> something the "Completely Fair Scheduler", and then just be fair on a 
> thread level. That's not fair AT ALL! It's the anti-thesis of being fair!
> So if you have 2 users on a machine running CPU hogs, you should *first* 
> try to be fair among users. If one user then runs 5 programs, and the 
> other one runs just 1, then the *one* program should get 50% of the CPU 
> time (the users fair share), and the five programs should get 10% of CPU 
> time each. And if one of them uses two threads, each thread should get 5%.
> So you should see one thread get 50& CPU (single thread of one user), 4 
> threads get 10% CPU (their fair share of that users time), and 2 threads 
> get 5% CPU (the fair share within that thread group!).
> Any scheduling argument that just considers the above to be "7 threads 
> total" and gives each thread 14% of CPU time "fairly" is *anything* but 
> fair. It's a joke if that kind of scheduler then calls itself CFS!

I don't think it's completely fair [sic] to come down on it that hard.
It does largely achieve the sort of fairness it set out for itself as
its design goal. One should also note that the queueing mechanism is
more than flexible enough to handle prioritization by a number of
different methods, and the large precision of its priorities is useful
there. So a rather broad variety of policies can be implemented by
changing the ->fair_key calculations.

In some respects, the vast priority space and very high clock precision
are two of its most crucial advantages.


On Wed, Apr 18, 2007 at 10:22:59AM -0700, Linus Torvalds wrote:
> And yes, that's largely what the current scheduler will do, but at least 
> the current scheduler doesn't claim to be fair! So the current scheduler 
> is a lot *better* if only in the sense that it doesn't make ridiculous 
> claims that aren't true!

The name chosen was somewhat buzzwordy. I'd have named it something more
descriptive of the algorithm, though what's implemented in the current
dynamic priority (i.e. ->fair_key) calculations are somewhat difficult
to precisely categorize.


-- wli

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXDRGJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXDRGJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbXDRGJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:09:14 -0400
Received: from waste.org ([66.93.16.53]:43754 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbXDRGJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:09:13 -0400
Date: Wed, 18 Apr 2007 00:55:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418055525.GS11115@waste.org>
References: <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418050024.GF18452@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:00:24AM +0200, Nick Piggin wrote:
> > It's also not yet clear that a scheduler can't be taught to do the
> > right thing with X without fiddling with nice levels.
> 
> Being fair doesn't prevent that. Implicit unfairness is wrong though,
> because it will bite people.
> 
> What's wrong with allowing X to get more than it's fair share of CPU
> time by "fiddling with nice levels"? That's what they're there for.

Why is X special? Because it does work on behalf of other processes?
Lots of things do this. Perhaps a scheduler should focus entirely on
the implicit and directed wakeup matrix and optimizing that
instead[1].

Why are processes special? Should user A be able to get more CPU time
for his job than user B by splitting it into N parallel jobs? Should
we be fair per process, per user, per thread group, per session, per
controlling terminal? Some weighted combination of the preceding?[2]

Why is the measure CPU time? I can imagine a scheduler that weighed
memory bandwidth in the equation. Or power consumption. Or execution
unit usage.

Fairness is nice. It's simple, it's obvious, it's predictable. But
it's just not clear that it's optimal. If the question is (and it
was!) "what should the basic requirements for the scheduler be?" it's
not clear that fairness is a requirement or even how to pick a metric
for fairness that's obviously and uniquely superior.

It's instead much easier to try to recognize and rule out really bad
behaviour with bounded latencies, minimum service guarantees, etc.

[1] That's basically how Google decides to prioritize webpages, which
it seems to do moderately well. And how a number of other optimization
problems are solved.

[2] It's trivial to construct two or more perfectly reasonable and
desirable definitions of fairness that are mutually incompatible.
-- 
Mathematics is the supreme nostalgia of our time.

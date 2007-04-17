Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXDQHCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXDQHCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXDQHCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:02:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXDQHCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:02:03 -0400
Date: Tue, 17 Apr 2007 09:01:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417070155.GF1057@wotan.suse.de>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417062621.GL2986@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:26:21PM -0700, William Lee Irwin III wrote:
> On Mon, Apr 16, 2007 at 11:09:55PM -0700, William Lee Irwin III wrote:
> >> All things are not equal; they all have different properties. I like
> 
> On Tue, Apr 17, 2007 at 08:15:03AM +0200, Nick Piggin wrote:
> > Exactly. So we have to explore those properties and evaluate performance
> > (in all meanings of the word). That's only logical.
> 
> Any chance you'd be willing to put down a few thoughts on what sorts
> of standards you'd like to set for both correctness (i.e. the bare
> minimum a scheduler implementation must do to be considered valid
> beyond not oopsing) and performance metrics (i.e. things that produce
> numbers for each scheduler you can compare to say "this scheduler is
> better than this other scheduler at this.").

Yeah I guess that's the hard part :)

For correctness, I guess fairness is an easy one. I think that unfairness
is basically a bug and that it would be very unfortunate to merge something
unfair. But this is just within the context of a single runqueue... for
better or worse, we allow some unfairness in multiprocessors for performance
reasons of course.

Latency. Given N tasks in the system, an arbitrary task should get
onto the CPU in a bounded amount of time (excluding events like freak
IRQ holdoffs and such, obviously -- ie. just considering the context
of the scheduler's state machine).

I wouldn't like to see a significant drop in any micro or macro
benchmarks or even worse real workloads, but I could accept some if it
means haaving a fair scheduler by default.

Now it isn't actually too hard to achieve the above, I think. The hard bit
is trying to compare interactivity. Ideally, we'd be able to get scripted
dumps of login sessions, and measure scheduling latencies of key proceses
(sh/X/wm/xmms/firefox/etc).  People would send a dump if they were having
problems with any scheduler, and we could compare all of them against it.
Wishful thinking!

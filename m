Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXDQIXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXDQIXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDQIXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:23:31 -0400
Received: from holomorphy.com ([66.93.40.71]:48488 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXDQIXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:23:30 -0400
Date: Tue, 17 Apr 2007 01:23:23 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417082323.GS8915@holomorphy.com>
References: <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417070155.GF1057@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:26:21PM -0700, William Lee Irwin III wrote:
>> Any chance you'd be willing to put down a few thoughts on what sorts
>> of standards you'd like to set for both correctness (i.e. the bare
>> minimum a scheduler implementation must do to be considered valid
>> beyond not oopsing) and performance metrics (i.e. things that produce
>> numbers for each scheduler you can compare to say "this scheduler is
>> better than this other scheduler at this.").

On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> Yeah I guess that's the hard part :)
> For correctness, I guess fairness is an easy one. I think that unfairness
> is basically a bug and that it would be very unfortunate to merge something
> unfair. But this is just within the context of a single runqueue... for
> better or worse, we allow some unfairness in multiprocessors for performance
> reasons of course.

Requiring that identical tasks be allocated equal shares of CPU
bandwidth is the easy part here. ringtest.c exercises another aspect
of fairness that is extremely important. Generalizing ringtest.c is
a good idea for fairness testing.

But another aspect of fairness is that "controlled unfairness" is also
intended to exist, in no small part by virtue of nice levels, but also
in the form of favoring tasks that are considered interactive somehow.
Testing various forms of controlled unfairness to ensure that they are
indeed controlled and otherwise have the semantics intended is IMHO the
more difficult aspect of fairness testing.


On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> Latency. Given N tasks in the system, an arbitrary task should get
> onto the CPU in a bounded amount of time (excluding events like freak
> IRQ holdoffs and such, obviously -- ie. just considering the context
> of the scheduler's state machine).

ISTR Davide Libenzi having a scheduling latency test a number of years
ago. Resurrecting that and tuning it to the needs of this kind of
testing sounds relevant here. The test suite Peter Willliams mentioned
would also help.


On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> I wouldn't like to see a significant drop in any micro or macro
> benchmarks or even worse real workloads, but I could accept some if it
> means haaving a fair scheduler by default.

On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> Now it isn't actually too hard to achieve the above, I think. The hard bit
> is trying to compare interactivity. Ideally, we'd be able to get scripted
> dumps of login sessions, and measure scheduling latencies of key proceses
> (sh/X/wm/xmms/firefox/etc).  People would send a dump if they were having
> problems with any scheduler, and we could compare all of them against it.
> Wishful thinking!

That's a pretty good idea. I'll queue up writing something of that form
as well.


-- wli

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030955AbXDRDPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030955AbXDRDPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030862AbXDRDPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:15:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:38273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030955AbXDRDPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:15:40 -0400
Date: Wed, 18 Apr 2007 05:15:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
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
Message-ID: <20070418031511.GA18452@wotan.suse.de>
References: <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417213954.GE11166@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 04:39:54PM -0500, Matt Mackall wrote:
> On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> > On Mon, Apr 16, 2007 at 11:26:21PM -0700, William Lee Irwin III wrote:
> > > On Mon, Apr 16, 2007 at 11:09:55PM -0700, William Lee Irwin III wrote:
> > > >> All things are not equal; they all have different properties. I like
> > > 
> > > On Tue, Apr 17, 2007 at 08:15:03AM +0200, Nick Piggin wrote:
> > > > Exactly. So we have to explore those properties and evaluate performance
> > > > (in all meanings of the word). That's only logical.
> > > 
> > > Any chance you'd be willing to put down a few thoughts on what sorts
> > > of standards you'd like to set for both correctness (i.e. the bare
> > > minimum a scheduler implementation must do to be considered valid
> > > beyond not oopsing) and performance metrics (i.e. things that produce
> > > numbers for each scheduler you can compare to say "this scheduler is
> > > better than this other scheduler at this.").
> > 
> > Yeah I guess that's the hard part :)
> > 
> > For correctness, I guess fairness is an easy one. I think that unfairness
> > is basically a bug and that it would be very unfortunate to merge something
> > unfair. But this is just within the context of a single runqueue... for
> > better or worse, we allow some unfairness in multiprocessors for performance
> > reasons of course.
> 
> I'm a big fan of fairness, but I think it's a bit early to declare it
> a mandatory feature. Bounded unfairness is probably something we can
> agree on, ie "if we decide to be unfair, no process suffers more than
> a factor of x".

I don't know why this would be a useful feature (of course I'm talking
about processes at the same nice level). One of the big problems with
the current scheduler is that it is unfair in some corner cases. It
works OK for most people, but when it breaks down it really hurts. At
least if you start with a fair scheduler, you can alter priorities
until it satisfies your need... with an unfair one your guess is as
good as mine.

So on what basis would you allow unfairness? On the basis that it doesn't
seem to harm anyone? It doesn't seem to harm testers?

I think we should aim for something better.


> > Latency. Given N tasks in the system, an arbitrary task should get
> > onto the CPU in a bounded amount of time (excluding events like freak
> > IRQ holdoffs and such, obviously -- ie. just considering the context
> > of the scheduler's state machine).
> 
> This is a slightly stronger statement than starvation-free (which is
> obviously mandatory). I think you're looking for something like
> "worst-case scheduling latency is proportional to the number of
> runnable tasks". Which I think is quite a reasonable requirement.

Yes, bounded and proportional to.


> I'm pretty sure the stock scheduler falls short of both of these
> guarantees though.

And I think that's what its main problems are. It's interactivity
obviously can't be too bad for most people. It's performance seems to
be pretty good.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbXDREw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbXDREw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXDREw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:52:58 -0400
Received: from waste.org ([66.93.16.53]:59614 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXDREw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:52:57 -0400
Date: Tue, 17 Apr 2007 23:38:31 -0500
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
Message-ID: <20070418043831.GR11115@waste.org>
References: <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418031511.GA18452@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 05:15:11AM +0200, Nick Piggin wrote:
> On Tue, Apr 17, 2007 at 04:39:54PM -0500, Matt Mackall wrote:
> > On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> > > On Mon, Apr 16, 2007 at 11:26:21PM -0700, William Lee Irwin III wrote:
> > > > On Mon, Apr 16, 2007 at 11:09:55PM -0700, William Lee Irwin III wrote:
> > > > >> All things are not equal; they all have different properties. I like
> > > > 
> > > > On Tue, Apr 17, 2007 at 08:15:03AM +0200, Nick Piggin wrote:
> > > > > Exactly. So we have to explore those properties and evaluate performance
> > > > > (in all meanings of the word). That's only logical.
> > > > 
> > > > Any chance you'd be willing to put down a few thoughts on what sorts
> > > > of standards you'd like to set for both correctness (i.e. the bare
> > > > minimum a scheduler implementation must do to be considered valid
> > > > beyond not oopsing) and performance metrics (i.e. things that produce
> > > > numbers for each scheduler you can compare to say "this scheduler is
> > > > better than this other scheduler at this.").
> > > 
> > > Yeah I guess that's the hard part :)
> > > 
> > > For correctness, I guess fairness is an easy one. I think that unfairness
> > > is basically a bug and that it would be very unfortunate to merge something
> > > unfair. But this is just within the context of a single runqueue... for
> > > better or worse, we allow some unfairness in multiprocessors for performance
> > > reasons of course.
> > 
> > I'm a big fan of fairness, but I think it's a bit early to declare it
> > a mandatory feature. Bounded unfairness is probably something we can
> > agree on, ie "if we decide to be unfair, no process suffers more than
> > a factor of x".
> 
> I don't know why this would be a useful feature (of course I'm talking
> about processes at the same nice level). One of the big problems with
> the current scheduler is that it is unfair in some corner cases. It
> works OK for most people, but when it breaks down it really hurts. At
> least if you start with a fair scheduler, you can alter priorities
> until it satisfies your need... with an unfair one your guess is as
> good as mine.
> 
> So on what basis would you allow unfairness? On the basis that it doesn't
> seem to harm anyone? It doesn't seem to harm testers?

On the basis that there's only anecdotal evidence thus far that
fairness is the right approach.

It's not yet clear that a fair scheduler can do the right thing with X,
with various kernel threads, etc. without fiddling with nice levels.
Which makes it no longer "completely fair".

It's also not yet clear that a scheduler can't be taught to do the
right thing with X without fiddling with nice levels.

So I'm just not yet willing to completely rule out systems that aren't
"completely fair".

But I think we should rule out schedulers that don't have rigid bounds on
that unfairness. That's where the really ugly behavior lies.

-- 
Mathematics is the supreme nostalgia of our time.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDRFAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDRFAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXDRFAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:00:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:42136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXDRFAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:00:40 -0400
Date: Wed, 18 Apr 2007 07:00:24 +0200
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
Message-ID: <20070418050024.GF18452@wotan.suse.de>
References: <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418043831.GR11115@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:38:31PM -0500, Matt Mackall wrote:
> On Wed, Apr 18, 2007 at 05:15:11AM +0200, Nick Piggin wrote:
> > 
> > I don't know why this would be a useful feature (of course I'm talking
> > about processes at the same nice level). One of the big problems with
> > the current scheduler is that it is unfair in some corner cases. It
> > works OK for most people, but when it breaks down it really hurts. At
> > least if you start with a fair scheduler, you can alter priorities
> > until it satisfies your need... with an unfair one your guess is as
> > good as mine.
> > 
> > So on what basis would you allow unfairness? On the basis that it doesn't
> > seem to harm anyone? It doesn't seem to harm testers?
> 
> On the basis that there's only anecdotal evidence thus far that
> fairness is the right approach.
> 
> It's not yet clear that a fair scheduler can do the right thing with X,
> with various kernel threads, etc. without fiddling with nice levels.
> Which makes it no longer "completely fair".

Of course I mean SCHED_OTHER tasks at the same nice level. Otherwise
I would be arguing to make nice basically a noop.


> It's also not yet clear that a scheduler can't be taught to do the
> right thing with X without fiddling with nice levels.

Being fair doesn't prevent that. Implicit unfairness is wrong though,
because it will bite people.

What's wrong with allowing X to get more than it's fair share of CPU
time by "fiddling with nice levels"? That's what they're there for.


> So I'm just not yet willing to completely rule out systems that aren't
> "completely fair".
> 
> But I think we should rule out schedulers that don't have rigid bounds on
> that unfairness. That's where the really ugly behavior lies.

Been a while since I really looked at the mainline scheduler, but I
don't think it can permanently starve something, so I don't know what
your bounded unfairness would help with.

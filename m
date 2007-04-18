Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXDRHY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXDRHY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXDRHY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:24:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXDRHY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:24:28 -0400
Date: Wed, 18 Apr 2007 09:24:07 +0200
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
Message-ID: <20070418072407.GI18452@wotan.suse.de>
References: <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <20070418063711.GH18452@wotan.suse.de> <20070418065534.GT11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418065534.GT11115@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 01:55:34AM -0500, Matt Mackall wrote:
> On Wed, Apr 18, 2007 at 08:37:11AM +0200, Nick Piggin wrote:
> > I don't know how that supports your argument for unfairness,
> 
> I never had such an argument. I like fairness.
> 
> My argument is that -you- don't have an argument for making fairness a
> -requirement-.

It seems easy enough that there is no point accepting unfair
behaviour like the old scheduler if we're going to go to all
this trouble to replace it. The old scheduler seems to have
bounded unfairness and bounded starvation, so let the good times
roll.


> > processes are special only because that's how we've always done
> > scheduling.  I'm not precluding other groupings for fairness, though.
> 
> If you make one form of fairness a -requirement- for all acceptable
> algorithms, your -are- precluding most other forms of fairness.
> 
> If you refuse to define what "fairness" means when specifying your
> requirement, what's the point of requiring it?

I don't refuse. I'm talking about per-process CPU time fairness.
My paragraph above was pointing out that subsequent work to
add other classes of fairness are not excluded as configurable
features, but this basic type of fairness should be included.


> > What do you mean optimal? If your criteria is fairness, then of course
> > it is optimal. If your criteria is throughput, then it probably isn't.
> 
> I don't know what optimal behavior is. And neither do you. It may or
> may not be fair. It very likely includes small deviations from fair.

You misunderstand me. There is no single "optimal" when you're talking
about fairness (or most other scheduler things). So pondering whether
fairness is optimal or not doesn't really make sense.

I'm saying it should be a basic axiom, not that it is quantitively
better. It isn't a refutable argument. I state it because that it is
what users and programs expect.

You can reject that, and fine. I guess if a scheduler comes along that
does exactly the right thing for everyone, then it is better than any
fair scheduler. So OK, while we're talking theoretical, I won't dismiss
an unfair scheduler out of hand.


> > > [2] It's trivial to construct two or more perfectly reasonable and
> > > desirable definitions of fairness that are mutually incompatible.
> > 
> > Probably not if you use common sense, and in the context of a replacement
> > for the 2.6 scheduler.
> 
> Ok, trivial example. You cannot allocate equal CPU time to
> processes/tasks and simultaneously allocate equal time to thread
> groups. Is it common sense that a heavily-threaded app should be able
> to get hugely more CPU than a well-written app? No. I don't want Joe's
> stupid Java app to make my compile crawl.
> 
> On the other hand, if my heavily threaded app is, say, a voicemail
> server serving 30 customers, I probably want it to get 30x the CPU of
> my gzip job.

So that might be a nice addition, but the base funcionality is threads
simply because that's what we've always done. Just common sense.


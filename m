Return-Path: <linux-kernel-owner+w=401wt.eu-S1031095AbXDSDS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031095AbXDSDS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 23:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031094AbXDSDS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 23:18:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:57796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031095AbXDSDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 23:18:56 -0400
Date: Thu, 19 Apr 2007 05:18:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419031807.GA24512@wotan.suse.de>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:48:21AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 18 Apr 2007, Matt Mackall wrote:
> > 
> > Why is X special? Because it does work on behalf of other processes?
> > Lots of things do this. Perhaps a scheduler should focus entirely on
> > the implicit and directed wakeup matrix and optimizing that
> > instead[1].
> 
> I 100% agree - the perfect scheduler would indeed take into account where 
> the wakeups come from, and try to "weigh" processes that help other 
> processes make progress more. That would naturally give server processes 
> more CPU power, because they help others
> 
> I don't believe for a second that "fairness" means "give everybody the 
> same amount of CPU". That's a totally illogical measure of fairness. All 
> processes are _not_ created equal.

I believe that unless the kernel is told of these inequalities, then it
must schedule fairly.

And yes, by fairly, I mean fairly among all threads as a base resource
class, because that's what Linux has always done (and if you aggregate
into higher classes, you still need that per-thread scheduling).

So I'm not excluding extra scheduling classes like per-process, per-user,
but among any class of equal schedulable entities, fair scheduling is the
only option because the alternative of unfairness is just insane.


> That said, even trying to do "fairness by effective user ID" would 
> probably already do a lot. In a desktop environment, X would get as much 
> CPU time as the user processes, simply because it's in a different 
> protection domain (and that's really what "effective user ID" means: it's 
> not about "users", it's really about "protection domains").
> 
> And "fairness by euid" is probably a hell of a lot easier to do than 
> trying to figure out the wakeup matrix.

Well my X server has an euid of root, which would mean my X clients can
cause X to do work and eat into root's resources. Or as Ingo said, X
may not be running as root. Seems like just another hack to try to
implicitly solve the X problem and probably create a lot of others
along the way.

All fairness issues aside, in the context of keeping a very heavily
loaded desktop interactive, X is special. That you are trying to think
up funny rules that would implicitly give X better priority is kind of
indicative of that.


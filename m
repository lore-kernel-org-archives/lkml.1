Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZKXTuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZKXTuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbZKXTuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:50:05 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39187 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbZKXTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:50:03 -0500
Date: Tue, 24 Nov 2009 11:50:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       cl@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
Message-ID: <20091124195007.GI6831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4B067816.6070304@cs.helsinki.fi> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259090615.17871.696.camel@calx>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 01:23:35PM -0600, Matt Mackall wrote:
> On Tue, 2009-11-24 at 19:14 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-11-24 at 11:12 -0600, Matt Mackall wrote:
> > > On Tue, 2009-11-24 at 09:00 -0800, Paul E. McKenney wrote:
> > > > On Tue, Nov 24, 2009 at 05:33:26PM +0100, Peter Zijlstra wrote:
> > > > > On Mon, 2009-11-23 at 21:13 +0200, Pekka Enberg wrote:
> > > > > > Matt Mackall wrote:
> > > > > > > This seems like a lot of work to paper over a lockdep false positive in
> > > > > > > code that should be firmly in the maintenance end of its lifecycle? I'd
> > > > > > > rather the fix or papering over happen in lockdep.
> > > > > > 
> > > > > > True that. Is __raw_spin_lock() out of question, Peter?-) Passing the 
> > > > > > state is pretty invasive because of the kmem_cache_free() call in 
> > > > > > slab_destroy(). We re-enter the slab allocator from the outer edges 
> > > > > > which makes spin_lock_nested() very inconvenient.
> > > > > 
> > > > > I'm perfectly fine with letting the thing be as it is, its apparently
> > > > > not something that triggers very often, and since slab will be killed
> > > > > off soon, who cares.
> > > > 
> > > > Which of the alternatives to slab should I be testing with, then?
> > > 
> > > I'm guessing your system is in the minority that has more than $10 worth
> > > of RAM, which means you should probably be evaluating SLUB.
> > 
> > Well, I was rather hoping that'd die too ;-)
> > 
> > Weren't we going to go with SLQB?
> 
> News to me. Perhaps it was discussed at KS.
> 
> My understanding of the current state of play is:
> 
> SLUB: default allocator

Not on all architectures, it appears.

> SLAB: deep maintenance, will be removed if SLUB ever covers remaining
> performance regressions

;-)

> SLOB: useful for low-end (but high-volume!) embedded 

And unfortunately also depends on CONFIG_EMBEDDED, making it difficult
for me to test on the available machines.  My usual workaround is to
patch Kconfig to remove the dependency.

> SLQB: sitting in slab.git#for-next for months, has some ground to cover

I will hold off testing this until it hits mainline, especially if it is
where KS decided to go.

> SLQB and SLUB have pretty similar target audiences, so I agree we should
> eventually have only one of them. But I strongly expect performance
> results to be mixed, just as they have been comparing SLUB/SLAB.
> Similarly, SLQB still has of room for tuning left compared to SLUB, as
> SLUB did compared to SLAB when it first emerged. It might be a while
> before a clear winner emerges.

Those how live by the heuristic, die by the heuristic!!!  ;-)

							Thanx, Paul

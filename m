Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbZKXSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbZKXSZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbZKXSZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:25:03 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45405 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbZKXSZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:25:01 -0500
Date: Tue, 24 Nov 2009 10:25:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, cl@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
Message-ID: <20091124182506.GG6831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259086459.4531.1752.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 07:14:19PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 11:12 -0600, Matt Mackall wrote:
> > On Tue, 2009-11-24 at 09:00 -0800, Paul E. McKenney wrote:
> > > On Tue, Nov 24, 2009 at 05:33:26PM +0100, Peter Zijlstra wrote:
> > > > On Mon, 2009-11-23 at 21:13 +0200, Pekka Enberg wrote:
> > > > > Matt Mackall wrote:
> > > > > > This seems like a lot of work to paper over a lockdep false positive in
> > > > > > code that should be firmly in the maintenance end of its lifecycle? I'd
> > > > > > rather the fix or papering over happen in lockdep.
> > > > > 
> > > > > True that. Is __raw_spin_lock() out of question, Peter?-) Passing the 
> > > > > state is pretty invasive because of the kmem_cache_free() call in 
> > > > > slab_destroy(). We re-enter the slab allocator from the outer edges 
> > > > > which makes spin_lock_nested() very inconvenient.
> > > > 
> > > > I'm perfectly fine with letting the thing be as it is, its apparently
> > > > not something that triggers very often, and since slab will be killed
> > > > off soon, who cares.
> > > 
> > > Which of the alternatives to slab should I be testing with, then?
> > 
> > I'm guessing your system is in the minority that has more than $10 worth
> > of RAM, which means you should probably be evaluating SLUB.
> 
> Well, I was rather hoping that'd die too ;-)
> 
> Weren't we going to go with SLQB?

Well, I suppose I could make my scripts randomly choose the memory
allocator, but I would rather not.  ;-)

More seriously, I do have a number of configurations that I test, and I
suppose I can chose different allocators for the different configurations.

							Thanx, Paul

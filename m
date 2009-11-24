Return-Path: <linux-kernel-owner+w=401wt.eu-S933561AbZKXRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbZKXRN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbZKXRN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:13:57 -0500
Received: from waste.org ([173.11.57.241]:38863 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383AbZKXRN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:13:57 -0500
Subject: Re: lockdep complaints in slab allocator
From: Matt Mackall <mpm@selenic.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       cl@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20091124170032.GC6831@linux.vnet.ibm.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
	 <1259080406.4531.1645.camel@laptop>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 11:12:36 -0600
Message-ID: <1259082756.17871.607.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:00 -0800, Paul E. McKenney wrote:
> On Tue, Nov 24, 2009 at 05:33:26PM +0100, Peter Zijlstra wrote:
> > On Mon, 2009-11-23 at 21:13 +0200, Pekka Enberg wrote:
> > > Matt Mackall wrote:
> > > > This seems like a lot of work to paper over a lockdep false positive in
> > > > code that should be firmly in the maintenance end of its lifecycle? I'd
> > > > rather the fix or papering over happen in lockdep.
> > > 
> > > True that. Is __raw_spin_lock() out of question, Peter?-) Passing the 
> > > state is pretty invasive because of the kmem_cache_free() call in 
> > > slab_destroy(). We re-enter the slab allocator from the outer edges 
> > > which makes spin_lock_nested() very inconvenient.
> > 
> > I'm perfectly fine with letting the thing be as it is, its apparently
> > not something that triggers very often, and since slab will be killed
> > off soon, who cares.
> 
> Which of the alternatives to slab should I be testing with, then?

I'm guessing your system is in the minority that has more than $10 worth
of RAM, which means you should probably be evaluating SLUB.

-- 
http://selenic.com : development and support for Mercurial and Linux



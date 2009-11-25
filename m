Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbZKYXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbZKYXKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbZKYXKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:10:54 -0500
Received: from waste.org ([173.11.57.241]:58880 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759505AbZKYXKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:10:53 -0500
Subject: Re: lockdep complaints in slab allocator
From: Matt Mackall <mpm@selenic.com>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
	 <1259080406.4531.1645.camel@laptop>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
	 <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>
	 <1259090615.17871.696.camel@calx>
	 <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com>
	 <1259103315.17871.895.camel@calx>
	 <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 17:06:47 -0600
Message-ID: <1259190407.2858.61.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 13:59 -0800, David Rientjes wrote:
> On Tue, 24 Nov 2009, Matt Mackall wrote:
> 
> > I'm afraid I have only anecdotal reports from SLOB users, and embedded
> > folks are notorious for lack of feedback, but I only need a few people
> > to tell me they're shipping 100k units/mo to be confident that SLOB is
> > in use in millions of devices.
> > 
> 
> It's much more popular than I had expected; do you think it would be 
> possible to merge slob's core into another allocator or will it require 
> seperation forever?

Probably not. It's actually a completely different kind of allocator
than the rest as it doesn't actually use "slabs" at all. It's instead a
slab-like interface on a traditional heap allocator. SLAB/SLUB/SLQB have
much more in common - their biggest differences are about their approach
to scalability/locking issues.

On the upside, SLOB is easily the simplest of the bunch.

-- 
http://selenic.com : development and support for Mercurial and Linux



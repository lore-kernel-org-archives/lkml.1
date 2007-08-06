Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXHFUSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXHFUSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXHFUSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:18:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbXHFUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:18:14 -0400
Date: Mon, 6 Aug 2007 22:18:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
Message-ID: <20070806201812.GA23635@one.firstfloor.org>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl> <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com> <p73r6mglaog.fsf@bingen.suse.de> <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com> <1186426079.11797.88.camel@lappy> <20070806185926.GB22499@one.firstfloor.org> <20070806121053.baed9691.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806121053.baed9691.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 12:10:53PM -0700, Andrew Morton wrote:
> On Mon, 6 Aug 2007 20:59:26 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > precious page flag
> > 
> > I always cringe when I hear that. It's really more than node/sparsemem
> > use too many bits. If we get rid of 32bit NUMA that problem would be
> > gone for the node at least because it could be moved into the mostly
> > unused upper 32bit part on 64bit architectures.
> 
> Removing 32-bit NUMA is attractive - NUMAQ we can probably live without,
> not sure about summit.  But superh is starting to use NUMA now, due to
> varying access times of various sorts of memory, and one can envisage other
> embedded setups doing that.

They can just use phys_to_nid() or equivalent instead. Putting the node
into the page flags is just a very minor optimization.  I doubt
actually you could benchmark the difference. While in theory the
hash lookup could be another cache miss in practice this should
be already hot since it's used elsewhere.

> Plus I don't think there are many flags left in the upper 32-bits.  ia64
> swooped in and gobbled lots of them, although it's not immediately clear
> how many were consumed.

Really?  They forgot to document it then.

Anyways, if they don't have enough bits left they can always just
use the hash table and drop the node completely. Shouldn't make too much 
difference and IA64 has gobs of cache anyways.

I'm actually thinking about a PG_arch_2 on x86_64 too. arch_1 is already
used now but another one would be useful in c_p_a().

-Andi

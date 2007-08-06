Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbXHFTjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbXHFTjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbXHFTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:38:43 -0400
Received: from waste.org ([66.93.16.53]:45271 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761645AbXHFTim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:38:42 -0400
Date: Mon, 6 Aug 2007 14:38:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
Message-ID: <20070806193842.GB11115@waste.org>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl> <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com> <p73r6mglaog.fsf@bingen.suse.de> <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com> <1186426079.11797.88.camel@lappy> <20070806185926.GB22499@one.firstfloor.org> <20070806121053.baed9691.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806121053.baed9691.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
> 
> Plus I don't think there are many flags left in the upper 32-bits.  ia64
> swooped in and gobbled lots of them, although it's not immediately clear
> how many were consumed.
> 
> > The alternative would be to investigate again what it does to the
> > kernel to just use different lookup methods for this.
> 
> That's cringeworthy too, I expect.

Perhaps the node info could be pulled out into a parallel and
effectively read-only array of shorts.

-- 
Mathematics is the supreme nostalgia of our time.

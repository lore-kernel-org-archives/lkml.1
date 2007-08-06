Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXHFStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXHFStz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbXHFStr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:49:47 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33482 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXHFStq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:49:46 -0400
Subject: Re: [PATCH 03/10] mm: tag reseve pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.356795000@chello.nl>
	 <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
	 <p73r6mglaog.fsf@bingen.suse.de>
	 <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:47:59 +0200
Message-Id: <1186426079.11797.88.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 11:43 -0700, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Andi Kleen wrote:
> 
> > > >  		pgoff_t index;		/* Our offset within mapping. */
> > > >  		void *freelist;		/* SLUB: freelist req. slab lock */
> > > > +		int reserve;		/* page_alloc: page is a reserve page */
> > > 
> > > Extending page struct ???
> > 
> > Note it's an union.
> 
> Ok. Then under what conditions can we use reserve? Right after alloc?

Yes, its usually only observed right after alloc. Its basically an extra
return value.

Daniel suggested it was about saving page flags, _maybe_. The value is
1) rare and 2) usually only interesting right after alloc. So wasting a
precious page flag which would keep this state for the duration of the
whole allocation seemed like a waste.


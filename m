Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbXHFTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbXHFTxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbXHFTx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:53:28 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:44931
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757983AbXHFTx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:53:27 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
Date: Mon, 6 Aug 2007 12:53:19 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <200708061231.04982.phillips@phunq.net> <1186429018.11797.100.camel@lappy>
In-Reply-To: <1186429018.11797.100.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061253.20149.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 12:36, Peter Zijlstra wrote:
> On Mon, 2007-08-06 at 12:31 -0700, Daniel Phillips wrote:
> > On Monday 06 August 2007 11:17, Peter Zijlstra wrote:
> > > And how do we know a page was taken out of the reserves?
> >
> > Why not return that in the low bit of the page address?  This is a
> > little more cache efficient, does not leave that odd footprint in
> > the page union and forces the caller to examine the
> > alloc_pages(...P_MEMALLOC) return, making it harder to overlook the
> > fact that it got a page out of reserve and forget to put one back
> > later.
>
> This would require auditing all page allocation sites to ensure they
> ever happen under PF_MEMALLOC or the like. Because if an allocator
> ever fails to check the low bit and assumes its a valid struct page
> *, stuff will go *bang*.

But is that not exactly what we want?  If somebody sets __GFP_MEMALLOC 
then they had better be prepared to deal with the result.

OK, I see there are cases where the the gfp flags are blindly passed 
down level after level (tending to indicate a design flaw anyway) but 
they usually also get passed back up the chain without examination.  
Yes, an audit would be needed, but since when has that ever stood in 
the way of a miniscule optimization?  And if we miss a case it 
helpfully goes bang on us, no need to play games with new function 
names or the like.

Regards,

Daniel

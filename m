Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbXHFTjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbXHFTjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760390AbXHFTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:38:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50745 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbXHFTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:38:36 -0400
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <200708061231.04982.phillips@phunq.net>
References: <20070806102922.907530000@chello.nl>
	 <200708061035.18742.phillips@phunq.net> <1186424248.11797.66.camel@lappy>
	 <200708061231.04982.phillips@phunq.net>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 21:36:58 +0200
Message-Id: <1186429018.11797.100.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 12:31 -0700, Daniel Phillips wrote:
> On Monday 06 August 2007 11:17, Peter Zijlstra wrote:
> > And how do we know a page was taken out of the reserves?
> 
> Why not return that in the low bit of the page address?  This is a 
> little more cache efficient, does not leave that odd footprint in the 
> page union and forces the caller to examine the 
> alloc_pages(...P_MEMALLOC) return, making it harder to overlook the 
> fact that it got a page out of reserve and forget to put one back 
> later.

This would require auditing all page allocation sites to ensure they
ever happen under PF_MEMALLOC or the like. Because if an allocator ever
fails to check the low bit and assumes its a valid struct page *, stuff
will go *bang*.




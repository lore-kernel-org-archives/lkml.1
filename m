Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbXHXRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbXHXRxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760421AbXHXRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:53:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:37283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760356AbXHXRxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:53:40 -0400
Date: Fri, 24 Aug 2007 19:53:39 +0200
From: Andi Kleen <ak@suse.de>
To: Mel Gorman <mel@skynet.ie>
Cc: Andi Kleen <ak@suse.de>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824175339.GD16227@bingen.suse.de>
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de> <46CF0CCF.7010702@shadowen.org> <20070824170744.GB16227@bingen.suse.de> <20070824172626.GE26374@skynet.ie> <20070824173816.GC16227@bingen.suse.de> <20070824174438.GG26374@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824174438.GG26374@skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 06:44:38PM +0100, Mel Gorman wrote:
> On (24/08/07 19:38), Andi Kleen didst pronounce:
> > > Other than the fact that the memmap must be PMD aligned to use hugepage
> > > entries for the memmap. 
> > 
> > Why is that so?  mem_map should be just part of lowmem anyways.
> > 
> 
> Not in this case. memmap is allocated node local and mapped in the virtual
> memory area normally occupied by the end of low memory. The objective was
> to have memmap for the struct pages node-local. Hence, portions of
> memmap are really in highmem.

Ok, but that still doesn't mean it has to be PMD aligned, 
as long as illegal virtual aliases are prevent in the overlap
(which is not very hard) 

> > > It could be mapped with small pages in corner cases
> > > but the complexity worth it?
> > 
> > You don't need to map it with small pages in the normal case,
> > the only requirement is that c_p_a() is aware of it so it can
> > split it if needed.
> > 
> > > I can't see this type of lifting being done any time soon. As SPARSEMEM works
> > > and there is hope with the vmemmap work that DISCONTIG will finally go away,
> > > it may not be the best investment of time.
> > 
> > It's a trivial change, probably less code than your original patch.
> > 
> 
> I'll have to take your word for it because I haven't looked closely
> enough. I'll try and find time to look at it but the earliest I'll get around
> to it is post kernel-summit. In the meantime, SPARSEMEM works.

Ok, so we disable DISCONTIG i386 NUMA because there's nobody willing
to maintain it?

I'll take your word SPARSEMEM works, although I was told DISCONTIG NUMA
works too and then my testing told a quite different story.

-Andi


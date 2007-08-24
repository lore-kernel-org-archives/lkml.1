Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXHXSCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXHXSCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762275AbXHXSC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:02:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34420 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760017AbXHXSC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:02:27 -0400
Date: Fri, 24 Aug 2007 19:02:25 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824180225.GI26374@skynet.ie>
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de> <46CF0CCF.7010702@shadowen.org> <20070824170744.GB16227@bingen.suse.de> <20070824172626.GE26374@skynet.ie> <20070824173816.GC16227@bingen.suse.de> <20070824174438.GG26374@skynet.ie> <20070824175339.GD16227@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070824175339.GD16227@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/08/07 19:53), Andi Kleen didst pronounce:
> On Fri, Aug 24, 2007 at 06:44:38PM +0100, Mel Gorman wrote:
> > On (24/08/07 19:38), Andi Kleen didst pronounce:
> > > > Other than the fact that the memmap must be PMD aligned to use hugepage
> > > > entries for the memmap. 
> > > 
> > > Why is that so?  mem_map should be just part of lowmem anyways.
> > > 
> > 
> > Not in this case. memmap is allocated node local and mapped in the virtual
> > memory area normally occupied by the end of low memory. The objective was
> > to have memmap for the struct pages node-local. Hence, portions of
> > memmap are really in highmem.
> 
> Ok, but that still doesn't mean it has to be PMD aligned, 

Indeed, only the huge mappings require that.

> as long as illegal virtual aliases are prevent in the overlap
> (which is not very hard) 
> 
> > > > It could be mapped with small pages in corner cases
> > > > but the complexity worth it?
> > > 
> > > You don't need to map it with small pages in the normal case,
> > > the only requirement is that c_p_a() is aware of it so it can
> > > split it if needed.
> > > 
> > > > I can't see this type of lifting being done any time soon. As SPARSEMEM works
> > > > and there is hope with the vmemmap work that DISCONTIG will finally go away,
> > > > it may not be the best investment of time.
> > > 
> > > It's a trivial change, probably less code than your original patch.
> > > 
> > 
> > I'll have to take your word for it because I haven't looked closely
> > enough. I'll try and find time to look at it but the earliest I'll get around
> > to it is post kernel-summit. In the meantime, SPARSEMEM works.
> 
> Ok, so we disable DISCONTIG i386 NUMA because there's nobody willing
> to maintain it?
> 

That is a bit of an over-reaction. A problem was reported, a fix was
suggested. I'm simply stating that it'll be post kernel-summit before I can
revisit this issue as there are more pressing bugs right now.

Disabling i386 DISCONTIG on NUMA is drastically overkill because it works on
NUMA machines where the node ends are PMD aligned or this would have shown
up on test.kernel.org a long time ago. Maybe it would fail on a real NUMA
machine with less than 1GB of RAM, I don't know but it's a possibility.

> I'll take your word SPARSEMEM works, although I was told DISCONTIG NUMA
> works too and then my testing told a quite different story.
> 

SPARSEMEM booted on a plain old laptop and looked ok in qemu. I didn't
extensively test it, just plain boot.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

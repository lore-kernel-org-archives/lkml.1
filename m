Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbXHXR0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbXHXR0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXHXR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:26:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60061 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbXHXR02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:26:28 -0400
Date: Fri, 24 Aug 2007 18:26:26 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824172626.GE26374@skynet.ie>
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de> <46CF0CCF.7010702@shadowen.org> <20070824170744.GB16227@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070824170744.GB16227@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/08/07 19:07), Andi Kleen didst pronounce:
> On Fri, Aug 24, 2007 at 05:52:31PM +0100, Andy Whitcroft wrote:
> > Andi Kleen wrote:
> > >> This reserved portion of the KVA must be PMD aligned. 
> > > 
> > > Why do they need to be PMD aligned?  
> > 
> > That comes from the fact that the KVA in x86 has traditionally been
> 
> Where does this KVA acronym come from?  In Linux this is traditionally
> called direct or linear mapping. KVA sounds foreign.
> 

The KVA acronym is being used in the x86 discontig code. The terms direct
or linear mappings are not perfectly accurate either because the direct
mappings are being altered in a way that pages that would normally be in
highmem are now directly mapped for the lifetime of the system.

> > mapped with huge pages where at all possible, for performance reasons.
> 
> It was partly a rhetorical question.
> 
> My point is that we don't make any effort to PMD align end_pfn,
> so there is also no reason to PMD align any of the other boundaries.
> 

Other than the fact that the memmap must be PMD aligned to use hugepage
entries for the memmap. It could be mapped with small pages in corner cases
but the complexity worth it?

> The only reason in theory is to avoid virtual aliases with
> uncached areas, but there are no uncached areas in highmem
> so this shouldn't be a concern.
> 
> There might be overlap into the PCI hole though which is uncached
> and needs care rgarding virtual aliases, but that could be handled
> by teaching change_page_attr() to handle the overlap too.
> 
> I think that would be a better fix -- do that and then 
> drop that PMD align requirement. Essentially you need a 
> end_pfn_map like x86_64 has and use that in change_page_attr().
> 

I can't see this type of lifting being done any time soon. As SPARSEMEM works
and there is hope with the vmemmap work that DISCONTIG will finally go away,
it may not be the best investment of time.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

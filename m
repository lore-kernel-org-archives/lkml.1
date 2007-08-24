Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXHXRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXHXRHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbXHXRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:07:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:54229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbXHXRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:07:46 -0400
Date: Fri, 24 Aug 2007 19:07:44 +0200
From: Andi Kleen <ak@suse.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824170744.GB16227@bingen.suse.de>
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de> <46CF0CCF.7010702@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CF0CCF.7010702@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:52:31PM +0100, Andy Whitcroft wrote:
> Andi Kleen wrote:
> >> This reserved portion of the KVA must be PMD aligned. 
> > 
> > Why do they need to be PMD aligned?  
> 
> That comes from the fact that the KVA in x86 has traditionally been

Where does this KVA acronym come from?  In Linux this is traditionally
called direct or linear mapping. KVA sounds foreign.

> mapped with huge pages where at all possible, for performance reasons.

It was partly a rhetorical question.

My point is that we don't make any effort to PMD align end_pfn,
so there is also no reason to PMD align any of the other boundaries.

The only reason in theory is to avoid virtual aliases with
uncached areas, but there are no uncached areas in highmem
so this shouldn't be a concern.

There might be overlap into the PCI hole though which is uncached
and needs care rgarding virtual aliases, but that could be handled
by teaching change_page_attr() to handle the overlap too.

I think that would be a better fix -- do that and then 
drop that PMD align requirement. Essentially you need a 
end_pfn_map like x86_64 has and use that in change_page_attr().

-Andi


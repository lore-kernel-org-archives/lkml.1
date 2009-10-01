Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZJAPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZJAPQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZJAPQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:16:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43144 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZJAPQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:16:50 -0400
Date: Thu, 1 Oct 2009 16:16:57 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a kmem_cache_cpu
Message-ID: <20091001151657.GH21906@csn.ul.ie>
References: <84144f020909221154x820b287r2996480225692fad@mail.gmail.com> <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie> <alpine.DEB.1.10.0909301053550.9450@gentwo.org> <20090930220541.GA31530@csn.ul.ie> <alpine.DEB.1.10.0909301941570.11850@gentwo.org> <20091001104046.GA21906@csn.ul.ie> <alpine.DEB.1.10.0910011028380.3911@gentwo.org> <20091001150346.GD21906@csn.ul.ie> <alpine.DEB.1.10.0910011101390.3911@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910011101390.3911@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 11:03:16AM -0400, Christoph Lameter wrote:
> On Thu, 1 Oct 2009, Mel Gorman wrote:
> 
> > True, it might have been improved more if SLUB knew what local hugepage it
> > resided within as the kernel portion of the address space is backed by huge
> > TLB entries. Note that SLQB could have an advantage here early in boot as
> > the page allocator will tend to give it back pages within a single huge TLB
> > entry. It loses the advantage when the system has been running for a very long
> > time but it might be enough to skew benchmark results on cold-booted systems.
> 
> The page allocator serves pages aligned to huge page boundaries as far as
> I can remember.

You're right, it does, particularly early in boot. It loses the advantage
when the system has been running a long time and memory is mostly full but
the same will apply to SLQB.

> You can actually use huge pages in slub if you set the max
> order to 9. So a page obtained from the page allocator is always aligned
> properly.
> 

Fair point.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

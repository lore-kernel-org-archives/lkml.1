Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYIJQaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYIJQaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYIJQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:30:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:58837 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYIJQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:30:09 -0400
Date: Thu, 11 Sep 2008 01:29:54 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910152918.GD24392@amd.com>
References: <20080910145249.GB24392@amd.com>
	<20080911000936R.fujita.tomonori@lab.ntt.co.jp>
	<20080910152918.GD24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080911012932D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 17:29:18 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Sep 11, 2008 at 12:09:43AM +0900, FUJITA Tomonori wrote:
> > On Wed, 10 Sep 2008 16:52:49 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Wed, Sep 10, 2008 at 11:39:00PM +0900, FUJITA Tomonori wrote:
> > >  
> > > > btw, in tip/x86/iommu, GART's alloc_coherent always does virtual
> > > > mappings to allocate a size-aligned memory (as DMA-mapping.txt
> > > > defines).
> > > > 
> > > > Because someone strongly insisted, I modified GART's alloc_coherent to
> > > > do so but as I said again and again, it's completely meaningless (only
> > > > POWER IOMMU does it and drivers don't depend on such requirement).
> > > > 
> > > > I guess that it would be better to do virtual mappings only when
> > > > necessary as the current mainline does since GART I/O space is
> > > > precious in some systems. But I don't care much. What's your opinion
> > > > (as a AMD developer)?
> > > 
> > > Very true. My original rewrite did the mapping only when necessary too.
> > > What were the reasons to do the mapping always?
> > 
> > As I said above, it's for allocating a size-aligned memory. Look at
> > the description of pci_alloc_consistent in DMA-mapping.txt:
> > 
> > The cpu return address and the DMA bus master address are both
> > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > is greater than or equal to the requested size.  This invariant
> > exists (for example) to guarantee that if you allocate a chunk
> > which is smaller than or equal to 64 kilobytes, the extent of the
> > buffer you receive will not cross a 64K boundary.
> > 
> > You can't do this with __get_free_pages easily (you need some hacks to
> > do this). You can do this via iommu_area_alloc() for free.
> 
> What hacks do you need with __get_free_pages? The memory it returns is
> _always_ aligned at its size.

Is it guaranteed (documented somewhere) ?

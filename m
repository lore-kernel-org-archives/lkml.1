Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYHQPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYHQPzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYHQPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:55:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:57738 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYHQPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:55:22 -0400
Date: Mon, 18 Aug 2008 00:54:54 +0900
To: fujita.tomonori@lab.ntt.co.jp
Cc: mingo@elte.hu, prarit@redhat.com, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080818004844G.fujita.tomonori@lab.ntt.co.jp>
References: <20080818003648M.fujita.tomonori@lab.ntt.co.jp>
	<20080817154213.GB6411@elte.hu>
	<20080818004844G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080818005517X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 00:48:05 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Sun, 17 Aug 2008 17:42:13 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > The above commit log of Prarit's patch is completely wrong (so I wrote 
> > > this patch). To avoid misunderstanding, can you apply this patch with 
> > > a proper description like this:
> > 
> > sure, i've created the commit below - is that fine?
> > 
> > 	Ingo
> 
> I think that 'v2' in the subject is unnecessary. The rest looks fine.
> 
> Thanks,
> 
> 
> > --------------->
> > From 3f18931be15856db01a216995670412e4421f3c9 Mon Sep 17 00:00:00 2001
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Mon, 18 Aug 2008 00:36:18 +0900
> > Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent, v2
> > 
> > This patch changes GART IOMMU to return a size aligned address wrt
> > dma_alloc_coherent, as DMA-mapping.txt defines:
> > 
> > The cpu return address and the DMA bus master address are both
> > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > is greater than or equal to the requested size.  This invariant
> > exists (for example) to guarantee that if you allocate a chunk
> > which is smaller than or equal to 64 kilobytes, the extent of the
> > buffer you receive will not cross a 64K boundary.

Ops, can you remove the following part? I confused
segment_boundary_mask with max_segment_size. A device needs to set
segment_boundary_mask properly if it doesn't want a buffer that
crosses a 64K boundary. We set the default boundary to 4G.


> > But it is very unlikely that this matters. As DMA-mapping.txt
> > explains, This invariant is to avoid the boundary problem (such as
> > 64K). Now the majority of IOMMUs including GART (except for Intel
> > IOMMU) don't allocate a buffer that crosses a 64K boundary wrt all the
> > DMA mapping interfaces (dma_alloc_coherent, dma_map_sg, and
> > dma_map_single) because of segment_boundary_mask in struct
> > device_dma_parameters.


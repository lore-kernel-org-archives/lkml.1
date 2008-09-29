Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYI2NU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYI2NU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYI2NUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:20:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:54214 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYI2NUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:20:48 -0400
Date: Mon, 29 Sep 2008 22:16:44 +0900
To: joro@8bytes.org
Cc: muli@il.ibm.com, joerg.roedel@amd.com, amit.shah@redhat.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080929093652.GQ27426@8bytes.org>
References: <20080928191333.GC26563@8bytes.org>
	<20080929093044.GB6931@il.ibm.com>
	<20080929093652.GQ27426@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929221640X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 11:36:52 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Sep 29, 2008 at 12:30:44PM +0300, Muli Ben-Yehuda wrote:
> > On Sun, Sep 28, 2008 at 09:13:33PM +0200, Joerg Roedel wrote:
> > 
> > > I think we should try to build a paravirtualized IOMMU for KVM
> > > guests.  It should work this way: We reserve a configurable amount
> > > of contiguous guest physical memory and map it dma contiguous using
> > > some kind of hardware IOMMU. This is possible with all hardare
> > > IOMMUs we have in the field by now, also Calgary and GART. The guest
> > > does dma_coherent allocations from this memory directly and is done.
> > > For map_single and map_sg 
> > > the guest can do bounce buffering. We avoid nearly all pvdma hypercalls
> > > with this approach, keep guest swapping working and solve also the
> > > problems with device dma_masks and guest memory that is not contigous on
> > > the host side.
> > 
> > I'm not sure I follow, but if I understand correctly with this
> > approach the guest could only DMA into buffers that fall within the
> > range you allocated for DMA and mapped. Isn't that a pretty nasty
> > limitation?  The guest would need to bounce-bufer every frame that
> > happened to not fall inside that range, with the resulting loss of
> > performance.
> 
> The bounce buffering is needed for map_single/map_sg allocations. For
> dma_alloc_coherent we can directly allocate from that range. The
> performance loss of the bounce buffering may be lower than the
> hypercalls we need as the alternative (we need hypercalls for map, unmap
> and sync).

Nobody cares about the performance of dma_alloc_coherent. Only the
performance of map_single/map_sg matters.

I'm not sure how expensive the hypercalls are, but they are more
expensive than bounce buffering coping lots of data for every I/Os?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYIPXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYIPXyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYIPXyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:54:06 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44328 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYIPXyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:54:05 -0400
Date: Wed, 17 Sep 2008 08:53:42 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080916175824.GF25711@one.firstfloor.org>
References: <20080916134335.GC25711@one.firstfloor.org>
	<20080917021319O.fujita.tomonori@lab.ntt.co.jp>
	<20080916175824.GF25711@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080917085335F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 19:58:24 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > > Those always are handled elsewhere in the block layer (using the bounce_pfn
> > > mechanism)
> > 
> > I don't think that the bounce guarantees that dma_alloc_coherent()
> > returns an address that a device can access to.
> 
> dma_alloc_coherent() is not used for block IO data. And dma_alloc_coherent()
> does handle masks > 24bit < 32bits just fine.

What do you mean? For example, some aacraid cards have 31bit dma
mask. What guarantees that IOMMUs's dma_alloc_coherent don't return a
virtual address > 31bit < 32bit?


> > I'm not familiar with what the networking does, for example, seems
> > that b44 sets dev->dma_mask to DMA_30BIT_MASK and b44_start_xmit()
> > does:
> > 
> 
> b44 (and related designs like the bcm wireless chipset) 
> has its own bouncing scheme. IT doesn't need any hacks in map_sg
>  
> > IOMMUs can try to return an address that the NIC can access to.
> 
> It's not worth to handle this strange case. The drivers do anyways.
> These are very cheap devices which are only rarely used in systems
> with >2GB and for those cases the existing bouncing setup works fine.

I think that the patch is a pretty straightforward, it just the same
thing that IOMMUs with > 32bits virtual address space do. We can do
better with the simple patch. But I'm ok with dropping the patch for
GART since we can live without the patch, as you said.

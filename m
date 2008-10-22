Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYJVNUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYJVNUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYJVNUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:20:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:43486 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbYJVNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:20:05 -0400
Date: Wed, 22 Oct 2008 22:19:33 +0900
To: fujita.tomonori@lab.ntt.co.jp
Cc: tiwai@suse.de, svens@stackframe.org, joerg.roedel@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: swiotlb_alloc_coherent: allocated memory is out of range for
 device
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081022221321J.fujita.tomonori@lab.ntt.co.jp>
References: <20081022202809M.fujita.tomonori@lab.ntt.co.jp>
	<s5hmygwn89z.wl%tiwai@suse.de>
	<20081022221321J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081022222003Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 22:13:39 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > > > So, even adding GFP_DMA works mostly, it has still potentially
> > > > breakage when you can't get the page and fall back to iotlb pages,
> > > > just like the panic above.
> > > > 
> > > > Also, the removal of GFP_DMA hack is a bad idea.  For example, if a
> > > > device requires 28bit DMA mask, it doesn't set always GFP_DMA for
> > > > allocation because pages in ZONE_NORMAL may be inside that DMA mask.
> > > > Normal allocators allow this behavior but swiotlb allocator doesn't.
> > > > (Correct me if I'm wrong here -- I haven't followed much the recent
> > > >  changes.)
> > > 
> > > 28bit DMA mask is supposed to be handled properly. Firstly, we try
> > > with DMA_32BIT_MASK and if an allocated address is not fit for 28bit
> > > mask, we try GFP_DMA again.
> > 
> > Yep, dma_generic_alloc_coherent() works like that for ages.
> > My point is about swiotlb_alloc_coherent(), and I don't see the
> > relevant code there...
> 
> Oops, you are right. swiotlb doesn't try again with GFP_DMA now. Joerg
> changed the GFP_DMA retry mechanism work only for pci-nommu.c It broke
> GART IOMMU and x86's swiotlb. I modified dma_generic_alloc_coherent to
> work with pci-nommu and GART. I promised Ingo to fix swiotlb too but I
> forgot about it.
> 
> Sorry, I'll fix this soon but your case (28bit mask) is supposed to

Oops, I meant, 24bit mask, as you know.


> work without the GFP_DMA retry mechanism. As I wrote above, I suspect
> that dma flag is not set correctly.

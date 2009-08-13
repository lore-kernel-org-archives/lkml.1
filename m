Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZHMIgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZHMIgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZHMIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:36:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:46932 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbZHMIgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:36:11 -0400
Date: Thu, 13 Aug 2009 17:35:56 +0900
To: dwmw2@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, luming.yu@gmail.com, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
 failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1250151972.29180.193.camel@macbook.infradead.org>
References: <20090813121444W.fujita.tomonori@lab.ntt.co.jp>
	<20090813121727W.fujita.tomonori@lab.ntt.co.jp>
	<1250151972.29180.193.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813173447J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 17:35:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 09:26:12 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2009-08-13 at 12:18 +0900, FUJITA Tomonori wrote:
> > > Duh, yeah, intel_iommu_init() fails, it doesn't work.
> > > 
> > > X86 falls back into nommu_dam_ops but IA64 has nothing.
> > > 
> > > pci_swiotlb_init() can't set swiotlb to 1 or overwrite dma_ops? If it
> > > sets swiotlb to 1, intel_iommu_init() fails.
> > > 
> > > A quick fix could be something like this:
> > 
> > Oops, here's a good one.
> 
> Closer, but don't we still want to free the swiotlb buffers if the iommu
> init _does_ actually work?

If we want to fix this right now, this should be applied:

http://marc.info/?l=linux-kernel&m=125014640502047&w=2

It allocates swiotlb buffer only if we actually use it.

But seems that this is not an urgent issue so I'll work on the IA64
and X86 dma bootup code again for 2.6.32 or 33.

> And we want the same on x86 too -- we want swiotlb, not nommu.


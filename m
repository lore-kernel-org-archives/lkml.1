Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZA2JSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZA2JSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZA2JSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:18:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:50574 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZA2JS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:18:29 -0500
Date: Thu, 29 Jan 2009 18:18:13 +0900
To: ink@jurassic.park.msu.ru
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, rth@twiddle.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: compile fixes
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090129074101.GA13020@jurassic.park.msu.ru>
References: <20090127083823.GB15452@jurassic.park.msu.ru>
	<20090128115403R.fujita.tomonori@lab.ntt.co.jp>
	<20090129074101.GA13020@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090129181854K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jan 2009 18:18:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 10:41:01 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Wed, Jan 28, 2009 at 11:53:45AM +0900, FUJITA Tomonori wrote:
> > A patch to change Alpha to handle two dma mapping implementations
> > (pci-noop and the IOMMU) in the standard way (like X86, POWER, IA64,
> > etc do) is acceptable?
> > 
> > pci-noop has something like struct dma_map_ops nommu_dma_ops (similar
> > to pci-nommu.c in arch/x86/kernel/pci-nommu.c) and pci_iommu.c has
> > struct dma_map_ops iommu_dma_ops. Then at startup, the kernel properly
> > sets dma_ops pointer to nommu_dma_ops or iommu_dma_ops.
> > 
> > Then we can handle the dma mapping operations in the consistent way,
> > e.g., dma_map_sg can be just `return ops->map_sg(dev, sg, nents,
> > dir)`.
> 
> I don't think that we need this. In GENERIC kernel, alpha dma-mapping
> functions work universally, Jensen included. The only reason pci-noop.c
> is there is an optimization for kernel built specifically for Jensen,
> which is the only non-PCI alpha - we simply don't compile useless stuff in.

That's exactly what IA64 does. The generic kernel works for all IA64
architectures. If you build an architecture specific IA64 kernel (such
as IA64_DIG), IA64 uses ifdef and macro magics for dma mapping
operations.

The ifdef and macro magics makes the code unreadable. I rewrote IA64
dma operation code to use the standard way to handle multiple dma
mapping operation sets so that non everyone can understand the code
easily.

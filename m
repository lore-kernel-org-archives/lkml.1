Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZA2HlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZA2HlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZA2Hk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:40:59 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:57929 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZA2Hk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:40:58 -0500
Date: Thu, 29 Jan 2009 10:41:01 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: compile fixes
Message-ID: <20090129074101.GA13020@jurassic.park.msu.ru>
References: <20090127083823.GB15452@jurassic.park.msu.ru> <20090128115403R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128115403R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:53:45AM +0900, FUJITA Tomonori wrote:
> A patch to change Alpha to handle two dma mapping implementations
> (pci-noop and the IOMMU) in the standard way (like X86, POWER, IA64,
> etc do) is acceptable?
> 
> pci-noop has something like struct dma_map_ops nommu_dma_ops (similar
> to pci-nommu.c in arch/x86/kernel/pci-nommu.c) and pci_iommu.c has
> struct dma_map_ops iommu_dma_ops. Then at startup, the kernel properly
> sets dma_ops pointer to nommu_dma_ops or iommu_dma_ops.
> 
> Then we can handle the dma mapping operations in the consistent way,
> e.g., dma_map_sg can be just `return ops->map_sg(dev, sg, nents,
> dir)`.

I don't think that we need this. In GENERIC kernel, alpha dma-mapping
functions work universally, Jensen included. The only reason pci-noop.c
is there is an optimization for kernel built specifically for Jensen,
which is the only non-PCI alpha - we simply don't compile useless stuff in.

Ivan.

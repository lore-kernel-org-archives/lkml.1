Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZFBWO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZFBWO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFBWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:14:18 -0400
Received: from www.tglx.de ([62.245.132.106]:40887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZFBWOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:14:18 -0400
Date: Wed, 3 Jun 2009 00:08:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <ian.campbell@citrix.com>
cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org
Subject: Re: [PATCH 05/11] x86: use dma_map_range when allocating PCI GART
 memory
In-Reply-To: <1243870383-12954-6-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.LFD.2.00.0906030007370.3419@localhost.localdomain>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com> <1243870383-12954-6-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Ian Campbell wrote:

> This function is intended to replaces is_buffer_dma_capable with a
> more generic interface.

Another instance of copied and not updated changelog.
 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: x86@kernel.org
> ---
>  arch/x86/kernel/pci-gart_64.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 1e8920d..eb043bd 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -190,14 +190,16 @@ static void iommu_full(struct device *dev, size_t size, int dir)
>  static inline int
>  need_iommu(struct device *dev, unsigned long addr, size_t size)
>  {
> +	dma_addr_t dma_addr;
>  	return force_iommu ||
> -		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
> +	       !dma_map_range(dev, *dev->dma_mask, addr, size, &dma_addr);
>  }
>  
>  static inline int
>  nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
>  {
> -	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
> +	dma_addr_t dma_addr;
> +	return !dma_map_range(dev, *dev->dma_mask, addr, size, &dma_addr);
>  }
>  
>  /* Map a single continuous physical area into the IOMMU.
> -- 
> 1.5.6.5
> 

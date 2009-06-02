Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZFBWNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZFBWNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZFBWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:13:45 -0400
Received: from www.tglx.de ([62.245.132.106]:56833 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFBWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:13:44 -0400
Date: Wed, 3 Jun 2009 00:07:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <ian.campbell@citrix.com>
cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org
Subject: Re: [PATCH 03/11] x86: use dma_map_range when allocating PCI DMA
 memory
In-Reply-To: <1243870383-12954-4-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.LFD.2.00.0906030000410.3419@localhost.localdomain>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com> <1243870383-12954-4-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Ian Campbell wrote:

> This function is intended to replaces is_buffer_dma_capable with a
> more generic interface.

-ENOPARSE

Which function ? What means "is intended to replaces" ? Is it intended
or does it replace something ? What is the "more generic interface" ?

dma_map_range() has been introduced in patch 2/11 so it would be nice
to have a reference to that change and take the existance of
dma_map_range() as granted. There is no intention. We replace function
A with function B and the blurb about intention and more generic
interface is useless and confusing.

Thanks,

	tglx

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: x86@kernel.org
> ---
>  arch/x86/kernel/pci-dma.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index f4c1b03..458b7b5 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -160,7 +160,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>  {
>  	unsigned long dma_mask;
>  	struct page *page;
> -	dma_addr_t addr;
>  
>  	dma_mask = dma_alloc_coherent_mask(dev, flag);
>  
> @@ -170,8 +169,7 @@ again:
>  	if (!page)
>  		return NULL;
>  
> -	addr = page_to_phys(page);
> -	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
> +	if (!dma_map_range(dev, dma_mask, page_to_phys(page), size, dma_addr)) {
>  		__free_pages(page, get_order(size));
>  
>  		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
> @@ -182,7 +180,6 @@ again:
>  		return NULL;
>  	}
>  
> -	*dma_addr = addr;
>  	return page_address(page);
>  }
>  
> -- 
> 1.5.6.5
> 

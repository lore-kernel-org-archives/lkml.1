Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZEUKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZEUKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZEUKkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:40:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:37264 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZEUKkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:40:40 -0400
Date: Thu, 21 May 2009 19:39:00 +0900
To: ijc@hellion.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de,
       beckyb@kernel.crashing.org
Subject: Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242901733.22654.138.camel@zakaz.uk.xensource.com>
References: <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
	<1242901630.22654.135.camel@zakaz.uk.xensource.com>
	<1242901733.22654.138.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090521193910W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 21 May 2009 19:39:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 11:28:53 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> On Thu, 2009-05-21 at 11:27 +0100, Ian Campbell wrote:
> > The corresponding the Xen updates will...
> ...follow.
> 
> Subject:swiotlb/xen: add implementation of swiotlb_range_needs_mapping hook
> 
> This function is now implemented via asm/dma-mapping.h rather than as
> a weak hook in swiotlb.c
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> 
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> index a80139a..ed51bd1 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -315,9 +315,15 @@ static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
>  	return addr + size <= mask;
>  }
>  
> +#ifdef CONFIG_PCI_XEN
> +extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
> +#else
> +static inline int xen_range_needs_mapping(phys_addr_t paddr, size_t size) { return 0; }
> +#endif

I know Xen can do something like this but you think that this is
clean?

In addition, you also the similar hack in
arch/ia64/include/asm/dma-mapping.h for ia64's dom0 support, I think.


IMO, your patch just moves the ugly hacks from lib/swiotlb.c to
arch/{x86|ia64}/include/asm/dma-mapping.h.

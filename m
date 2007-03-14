Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXCNJnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXCNJnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXCNJnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:43:12 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36974 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030820AbXCNJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:43:10 -0400
Date: Wed, 14 Mar 2007 10:41:20 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] sparc: have dma-mapping.h include generic/dma-mapping-broken in non-PCI case
Message-ID: <20070314094120.GA8479@osiris.boeblingen.de.ibm.com>
References: <E1HRPbA-0003Fz-P0@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HRPbA-0003Fz-P0@ZenIV.linux.org.uk>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 09:16:44AM +0000, Al Viro wrote:
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/asm-sparc/dma-mapping.h |   15 +--------------
>  1 files changed, 1 insertions(+), 14 deletions(-)
> 
> diff --git a/include/asm-sparc/dma-mapping.h b/include/asm-sparc/dma-mapping.h
> index 6db83dc..f3a641e 100644
> --- a/include/asm-sparc/dma-mapping.h
> +++ b/include/asm-sparc/dma-mapping.h
> @@ -5,20 +5,7 @@
>  #ifdef CONFIG_PCI
>  #include <asm-generic/dma-mapping.h>
>  #else
> -
> -static inline void *dma_alloc_coherent(struct device *dev, size_t size,
> -			 dma_addr_t *dma_handle, gfp_t flag)
> -{
> -	BUG();
> -	return NULL;
> -}
> -
> -static inline void dma_free_coherent(struct device *dev, size_t size,
> -		       void *vaddr, dma_addr_t dma_handle)
> -{
> -	BUG();
> -}
> -
> +#include <asm-generic/dma-mapping-broken.h>
>  #endif /* PCI */
> 
>  #endif /* _ASM_SPARC_DMA_MAPPING_H */

This one is in -mm : http://lkml.org/lkml/2007/2/26/107
So maybe you don't need to add another reference to dma-mapping-broken.h?

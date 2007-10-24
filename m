Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXJWQ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXJWQ41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWQ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:56:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:39333 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXJWQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=b5KxvlNOmYit9cKm79aB1s4IK5j1eI6CCa7jGdVjrHnZnuSDNvGXb92eNPxo72v9nDSvBTh2zyqjtWHnBsSYL7TIpT0UUcTFavDgPQYDzUwPF5jd0H5QiKG5d5OCDA3f73XU4DPabl6ayg1zenOG8g72bUyyCdKfkyuMPtHAjcs=
Date: Tue, 23 Oct 2007 18:55:59 -0700
To: Emil Medve <Emilian.Medve@Freescale.com>
Cc: axboe@kernel.dk, paulus@samba.org, chris@zankel.net,
       grundler@parisc-linux.org, kyle@parisc-linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk, torvalds@linux-foundation.org,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, parisc-linux@lists.parisc-linux.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the new sg_page() helper
Message-Id: <20071023185559.ae15a263.Kristoffer.ericson@gmail.com>
In-Reply-To: <1193156092-11819-1-git-send-email-Emilian.Medve@Freescale.com>
References: <1193156092-11819-1-git-send-email-Emilian.Medve@Freescale.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Great, :D 
Just dropped a bug report about this 5mins ago. Hope it gets commited shortly.


On Tue, 23 Oct 2007 11:14:52 -0500
Emil Medve <Emilian.Medve@Freescale.com> wrote:

> Fix build error messages such as this:
> 
> In file included from include/linux/dma-mapping.h:52,
>                  from include/linux/dmaengine.h:29,
>                  from include/linux/skbuff.h:29,
>                  from include/linux/netlink.h:155,
>                  from include/linux/genetlink.h:4,
>                  from include/net/genetlink.h:4,
>                  from include/linux/taskstats_kern.h:12,
>                  from init/main.c:46:
> include/asm/dma-mapping.h: In function 'dma_map_sg':
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:290: error: 'struct scatterlist' has no member named 'page'
> 
> This change in the struct scatterlist was introduced by this commit: 18dabf473e15850c0dbc8ff13ac1e2806d542c15
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> ---
> 
> linux-2.6> scripts/checkpatch.pl 0001-Use-the-new-sg_page-helper.patch 
> Your patch has no obvious style problems and is ready for submission.
> 
>  drivers/mmc/host/mmci.h           |    4 ++--
>  drivers/pci/intel-iommu.c         |    2 +-
>  include/asm-arm/dma-mapping.h     |    8 ++++----
>  include/asm-parisc/scatterlist.h  |    3 ++-
>  include/asm-powerpc/dma-mapping.h |   10 +++++-----
>  include/asm-xtensa/dma-mapping.h  |   10 +++++-----
>  6 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
> index 000e6a9..de3c223 100644
> --- a/drivers/mmc/host/mmci.h
> +++ b/drivers/mmc/host/mmci.h
> @@ -112,7 +112,7 @@
>   * The size of the FIFO in bytes.
>   */
>  #define MCI_FIFOSIZE	(16*4)
> -	
> +
>  #define MCI_FIFOHALFSIZE (MCI_FIFOSIZE / 2)
>  
>  #define NR_SG		16
> @@ -169,7 +169,7 @@ static inline char *mmci_kmap_atomic(struct mmci_host *host, unsigned long *flag
>  	struct scatterlist *sg = host->sg_ptr;
>  
>  	local_irq_save(*flags);
> -	return kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
> +	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
>  }
>  
>  static inline void mmci_kunmap_atomic(struct mmci_host *host, void *buffer, unsigned long *flags)
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..347948c 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -2010,7 +2010,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
>  	struct scatterlist *sg;
>  
>  	for_each_sg(sglist, sg, nelems, i) {
> -		BUG_ON(!sg->page);
> +		BUG_ON(!sg_page(sg));
>  		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
>  		sg->dma_length = sg->length;
>  	}
> diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
> index 1eb8aac..08afd5a 100644
> --- a/include/asm-arm/dma-mapping.h
> +++ b/include/asm-arm/dma-mapping.h
> @@ -274,8 +274,8 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  	for (i = 0; i < nents; i++, sg++) {
>  		char *virt;
>  
> -		sg->dma_address = page_to_dma(dev, sg->page) + sg->offset;
> -		virt = page_address(sg->page) + sg->offset;
> +		sg->dma_address = page_to_dma(dev, sg_page(sg)) + sg->offset;
> +		virt = page_address(sg_page(sg)) + sg->offset;
>  
>  		if (!arch_is_coherent())
>  			dma_cache_maint(virt, sg->length, dir);
> @@ -371,7 +371,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
>  	int i;
>  
>  	for (i = 0; i < nents; i++, sg++) {
> -		char *virt = page_address(sg->page) + sg->offset;
> +		char *virt = page_address(sg_page(sg)) + sg->offset;
>  		if (!arch_is_coherent())
>  			dma_cache_maint(virt, sg->length, dir);
>  	}
> @@ -384,7 +384,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents,
>  	int i;
>  
>  	for (i = 0; i < nents; i++, sg++) {
> -		char *virt = page_address(sg->page) + sg->offset;
> +		char *virt = page_address(sg_page(sg)) + sg->offset;
>  		if (!arch_is_coherent())
>  			dma_cache_maint(virt, sg->length, dir);
>  	}
> diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
> index cd3cfdf..3c79a2a 100644
> --- a/include/asm-parisc/scatterlist.h
> +++ b/include/asm-parisc/scatterlist.h
> @@ -18,7 +18,8 @@ struct scatterlist {
>  	__u32      iova_length; /* bytes mapped */
>  };
>  
> -#define sg_virt_addr(sg) ((unsigned long)(page_address(sg->page) + sg->offset))
> +#define sg_virt_addr(sg) \
> +		((unsigned long)(page_address(sg_page(sg)) + sg->offset))
>  #define sg_dma_address(sg) ((sg)->iova)
>  #define sg_dma_len(sg)     ((sg)->iova_length)
>  
> diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
> index 65be95d..ff52013 100644
> --- a/include/asm-powerpc/dma-mapping.h
> +++ b/include/asm-powerpc/dma-mapping.h
> @@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>  	BUG_ON(direction == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nents, i) {
> -		BUG_ON(!sg->page);
> -		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
> -		sg->dma_address = page_to_bus(sg->page) + sg->offset;
> +		BUG_ON(!sg_page(sg));
> +		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
> +		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
>  	}
>  
>  	return nents;
> @@ -328,7 +328,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
>  	BUG_ON(direction == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nents, i)
> -		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
> +		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
>  }
>  
>  static inline void dma_sync_sg_for_device(struct device *dev,
> @@ -341,7 +341,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
>  	BUG_ON(direction == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nents, i)
> -		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
> +		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
>  }
>  
>  static inline int dma_mapping_error(dma_addr_t dma_addr)
> diff --git a/include/asm-xtensa/dma-mapping.h b/include/asm-xtensa/dma-mapping.h
> index 82b03b3..2b3e975 100644
> --- a/include/asm-xtensa/dma-mapping.h
> +++ b/include/asm-xtensa/dma-mapping.h
> @@ -58,10 +58,10 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  	BUG_ON(direction == DMA_NONE);
>  
>  	for (i = 0; i < nents; i++, sg++ ) {
> -		BUG_ON(!sg->page);
> +		BUG_ON(!sg_page(sg));
>  
> -		sg->dma_address = page_to_phys(sg->page) + sg->offset;
> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,
>  				sg->length, direction);
>  	}
>  
> @@ -128,7 +128,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
>  {
>  	int i;
>  	for (i = 0; i < nelems; i++, sg++)
> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,
>  				sg->length, dir);
>  }
>  
> @@ -138,7 +138,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
>  {
>  	int i;
>  	for (i = 0; i < nelems; i++, sg++)
> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,
>  				sg->length, dir);
>  }
>  static inline int
> -- 
> 1.5.3.GIT
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

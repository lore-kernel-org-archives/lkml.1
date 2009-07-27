Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZG0VEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZG0VEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZG0VEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:04:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:36542 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbZG0VEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:04:30 -0400
Cc: linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-Id: <215D9D75-5F14-4877-9659-F376DE03B5A4@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1248405855-15546-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 2/5] powerpc: remove swiotlb_pci_dma_ops
Date: Mon, 27 Jul 2009 16:02:42 -0500
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1248405855-15546-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2009, at 10:24 PM, FUJITA Tomonori wrote:

> Now swiotlb_pci_dma_ops is identical to swiotlb_dma_ops; we can use
> swiotlb_dma_ops with any devices. This removes swiotlb_pci_dma_ops.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Becky Bruce <beckyb@kernel.crashing.org>

>
> ---
> arch/powerpc/include/asm/swiotlb.h         |    1 -
> arch/powerpc/kernel/dma-swiotlb.c          |   14 --------------
> arch/powerpc/platforms/85xx/mpc8536_ds.c   |    2 +-
> arch/powerpc/platforms/85xx/mpc85xx_ds.c   |    2 +-
> arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
> arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
> 6 files changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/ 
> include/asm/swiotlb.h
> index 31e0e43..21ce0a3 100644
> --- a/arch/powerpc/include/asm/swiotlb.h
> +++ b/arch/powerpc/include/asm/swiotlb.h
> @@ -14,7 +14,6 @@
> #include <linux/swiotlb.h>
>
> extern struct dma_mapping_ops swiotlb_dma_ops;
> -extern struct dma_mapping_ops swiotlb_pci_dma_ops;
>
> static inline void dma_mark_clean(void *addr, size_t size) {}
>
> diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/ 
> dma-swiotlb.c
> index c9f6a30..ca141e1 100644
> --- a/arch/powerpc/kernel/dma-swiotlb.c
> +++ b/arch/powerpc/kernel/dma-swiotlb.c
> @@ -45,20 +45,6 @@ struct dma_mapping_ops swiotlb_dma_ops = {
> 	.sync_sg_for_device = swiotlb_sync_sg_for_device
> };
>
> -struct dma_mapping_ops swiotlb_pci_dma_ops = {
> -	.alloc_coherent = dma_direct_alloc_coherent,
> -	.free_coherent = dma_direct_free_coherent,
> -	.map_sg = swiotlb_map_sg_attrs,
> -	.unmap_sg = swiotlb_unmap_sg_attrs,
> -	.dma_supported = swiotlb_dma_supported,
> -	.map_page = swiotlb_map_page,
> -	.unmap_page = swiotlb_unmap_page,
> -	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
> -	.sync_single_range_for_device =  
> swiotlb_sync_single_range_for_device,
> -	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
> -	.sync_sg_for_device = swiotlb_sync_sg_for_device
> -};
> -
> void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev)
> {
> 	struct pci_controller *hose;
> diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/ 
> platforms/85xx/mpc8536_ds.c
> index bf052c0..004b7d3 100644
> --- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
> +++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
> @@ -96,7 +96,7 @@ static void __init mpc8536_ds_setup_arch(void)
> #ifdef CONFIG_SWIOTLB
> 	if (lmb_end_of_DRAM() > max) {
> 		ppc_swiotlb_enable = 1;
> -		set_pci_dma_ops(&swiotlb_pci_dma_ops);
> +		set_pci_dma_ops(&swiotlb_dma_ops);
> 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> 	}
> #endif
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/ 
> platforms/85xx/mpc85xx_ds.c
> index c6f92cc..544011a 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> @@ -192,7 +192,7 @@ static void __init mpc85xx_ds_setup_arch(void)
> #ifdef CONFIG_SWIOTLB
> 	if (lmb_end_of_DRAM() > max) {
> 		ppc_swiotlb_enable = 1;
> -		set_pci_dma_ops(&swiotlb_pci_dma_ops);
> +		set_pci_dma_ops(&swiotlb_dma_ops);
> 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> 	}
> #endif
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/ 
> powerpc/platforms/85xx/mpc85xx_mds.c
> index 8b8e5f9..c4961ed 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> @@ -241,7 +241,7 @@ static void __init mpc85xx_mds_setup_arch(void)
> #ifdef CONFIG_SWIOTLB
> 	if (lmb_end_of_DRAM() > max) {
> 		ppc_swiotlb_enable = 1;
> -		set_pci_dma_ops(&swiotlb_pci_dma_ops);
> +		set_pci_dma_ops(&swiotlb_dma_ops);
> 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> 	}
> #endif
> diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/ 
> powerpc/platforms/86xx/mpc86xx_hpcn.c
> index 8032301..2aa69a6 100644
> --- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> +++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> @@ -105,7 +105,7 @@ mpc86xx_hpcn_setup_arch(void)
> #ifdef CONFIG_SWIOTLB
> 	if (lmb_end_of_DRAM() > max) {
> 		ppc_swiotlb_enable = 1;
> -		set_pci_dma_ops(&swiotlb_pci_dma_ops);
> +		set_pci_dma_ops(&swiotlb_dma_ops);
> 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> 	}
> #endif
> -- 
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


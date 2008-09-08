Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYIHMBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYIHMBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIHMBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:01:33 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:64196 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYIHMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:01:32 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K6VLDY-03-DFO-01
Date: Mon, 8 Sep 2008 14:01:10 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 2/5] x86: move pci-nommu's dma_mask check to common code
Message-ID: <20080908120110.GJ3189@amd.com>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Sep 2008 12:01:10.0409 (UTC) FILETIME=[95526F90:01C911AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 06:10:11PM +0900, FUJITA Tomonori wrote:
> The check to see if dev->dma_mask is NULL in pci-nommu is more
> appropriate for dma_alloc_coherent().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-nommu.c   |    3 ---
>  include/asm-x86/dma-mapping.h |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 73853d3..0f51883 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -80,9 +80,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
>  	int node;
>  	struct page *page;
>  
> -	if (hwdev->dma_mask == NULL)
> -		return NULL;
> -
>  	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
>  	gfp |= __GFP_ZERO;
>  
> diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
> index bc6c8df..39d3641 100644
> --- a/include/asm-x86/dma-mapping.h
> +++ b/include/asm-x86/dma-mapping.h
> @@ -256,6 +256,9 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  		gfp |= GFP_DMA;
>  	}
>  
> +	if (!dev->dma_mask)
> +		return NULL;
> +
>  	if (ops->alloc_coherent)
>  		return ops->alloc_coherent(dev, size,
>  				dma_handle, gfp);
> -- 
> 1.5.5.GIT
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


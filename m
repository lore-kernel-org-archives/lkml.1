Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYJAQaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYJAQaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYJAQaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:30:22 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21018 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJAQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:30:22 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K82J65-03-A6P-01
Date: Wed, 1 Oct 2008 18:30:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: use iommu_device_max_index
Message-ID: <20081001163008.GC30173@amd.com>
References: <20080929000525E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080929000525E.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Oct 2008 16:30:08.0682 (UTC) FILETIME=[F7FBB8A0:01C923E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

can you please apply this patch to your x86/iommu directly? For a single
patch it makes no sense to go through my tree.

Joerg

On Mon, Sep 29, 2008 at 12:06:36AM +0900, FUJITA Tomonori wrote:
> This is against tip/iommu.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] AMD IOMMU: use iommu_device_max_index
> 
> AMD IOMMU can use iommu_device_max_index() instead of the homegrown
> function.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/amd_iommu.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 2028810..34e4d11 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -480,10 +480,6 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
>   * efficient allocator.
>   *
>   ****************************************************************************/
> -static unsigned long dma_mask_to_pages(unsigned long mask)
> -{
> -	return PAGE_ALIGN(mask) >> PAGE_SHIFT;
> -}
>  
>  /*
>   * The address allocator core function.
> @@ -496,14 +492,14 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
>  					     unsigned long align_mask,
>  					     u64 dma_mask)
>  {
> -	unsigned long limit = dma_mask_to_pages(dma_mask);
> +	unsigned long limit;
>  	unsigned long address;
> -	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
>  	unsigned long boundary_size;
>  
>  	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
>  			PAGE_SIZE) >> PAGE_SHIFT;
> -	limit = limit < size ? limit : size;
> +	limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
> +				       dma_mask >> PAGE_SHIFT);
>  
>  	if (dom->next_bit >= limit) {
>  		dom->next_bit = 0;
> -- 
> 1.5.4.2
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


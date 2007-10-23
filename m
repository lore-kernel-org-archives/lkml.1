Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbXJWFEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbXJWFEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXJWFEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:04:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26406 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbXJWFEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:04:30 -0400
Date: Tue, 23 Oct 2007 07:04:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, anil.s.keshavamurthy@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix sg_page()
Message-ID: <20071023050426.GJ16425@kernel.dk>
References: <20071023135926A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023135926A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> drivers/pci/intel-iommu.c: In function 'intel_unmap_sg':
> drivers/pci/intel-iommu.c:1987: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c: In function 'intel_nontranslate_map_sg':
> drivers/pci/intel-iommu.c:2013: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c:2014: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c: In function 'intel_map_sg':
> drivers/pci/intel-iommu.c:2044: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c:2068: error: 'struct scatterlist' has no member named 'page'
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/pci/intel-iommu.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..0f6e528 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1962,7 +1962,6 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
>  	free_pages((unsigned long)vaddr, order);
>  }
>  
> -#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)

Thanks, though I preferred to just do the one-liner for the conversions.
Funny that I missed this file - ah seems it was merged yesterday as
well, it didn't exist in the current tree I was working against.

-- 
Jens Axboe


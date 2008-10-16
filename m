Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYJPPAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYJPPAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYJPO76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:59:58 -0400
Received: from 8bytes.org ([88.198.83.132]:39553 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbYJPO76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:59:58 -0400
Date: Thu, 16 Oct 2008 16:59:56 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] x86: amd_iommu: fix nasty bug that caused ILLEGAL_DEVICE_TABLE_ENTRY errors
Message-ID: <20081016145956.GA29705@8bytes.org>
References: <20081016142736.GN4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016142736.GN4706@alberich.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. Very stupid bug. This explains why it worked on my system with 1G
RAM and failed on some others with more. Thanks for the fix. I also CC
stable@kernel.org.

On Thu, Oct 16, 2008 at 04:27:36PM +0200, Andreas Herrmann wrote:
> We are on 64-bit so better use u64 instead of u32 to deal with
> addresses:
> 
> static void __init iommu_set_device_table(struct amd_iommu *iommu)
> {
>         u64 entry;
>   ...
>         entry = virt_to_phys(amd_iommu_dev_table);
>   ...
> 
> (I am wondering why gcc 4.2.x did not warn about the assignment
> between u32 and unsigned long.)
> 
> Cc: iommu@lists.linux-foundation.org
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

> 
> ---
>  arch/x86/kernel/amd_iommu_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Patch is against today's tip/x86/amd-iommu
> Joerg is on vacation. That is why I post this patch
> directly to you.
> 
> Regards,
> 
> Andreas
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index a69cc0f..bccd0ef 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -210,7 +210,7 @@ static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
>  /* Programs the physical address of the device table into the IOMMU hardware */
>  static void __init iommu_set_device_table(struct amd_iommu *iommu)
>  {
> -	u32 entry;
> +	u64 entry;
>  
>  	BUG_ON(iommu->mmio_base == NULL);
>  
> -- 
> 1.6.0.2
> 
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu

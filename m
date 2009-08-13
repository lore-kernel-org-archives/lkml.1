Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZHMD0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZHMD0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZHMD0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:26:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:41263 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZHMD0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:26:23 -0400
Date: Thu, 13 Aug 2009 12:25:39 +0900
To: luming.yu@gmail.com
Cc: dwmw2@infradead.org, fenghua.yu@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] clean up swiotlb check in intel_iommu_init
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
References: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813122456P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 12:25:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 11:11:27 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> Hi there,
> 
> Since swiotlb is an fall back option that might have
> initialized. We don't need to stop intel_iommu_init
> because of swiotlb..

I think that this doesn't work on X86; breaks "soft" boot option.


> Please review. If make sense, please apply.
> 
> **The patch is enclosed in text attachment*
> **Using web client to send the patch* *
> **below is for review, please apply attached  patch*/
> 
> Thanks,
> Luming
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  intel-iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 2314ad7..246acb9 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -3194,7 +3194,7 @@ int __init intel_iommu_init(void)
>  	 * Check the need for DMA-remapping initialization now.
>  	 * Above initialization will also be used by Interrupt-remapping.
>  	 */
> -	if (no_iommu || (swiotlb && !iommu_pass_through) || dmar_disabled)
> +	if (no_iommu || dmar_disabled)
>  		return -ENODEV;
> 
>  	iommu_init_mempool();

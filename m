Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYGYNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYGYNQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYGYNQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:16:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:48250 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYGYNQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:16:10 -0400
Date: Fri, 25 Jul 2008 22:15:06 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1216990680-1227-2-git-send-email-joerg.roedel@amd.com>
References: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
	<1216990680-1227-2-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080725221553Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 14:57:58 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Calculating the number of pages from given address and length numbers is a task
> required in multiple IOMMU implementations. So implement this as a generic
> function into the IOMMU helper code.
> 
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/linux/iommu-helper.h |    1 +
>  lib/iommu-helper.c           |    8 ++++++++
>  2 files changed, 9 insertions(+), 0 deletions(-)

Thanks. I planed to work on this after rc1. You beat me. :)

 
> diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
> index c975caf..f8598f5 100644
> --- a/include/linux/iommu-helper.h
> +++ b/include/linux/iommu-helper.h
> @@ -8,3 +8,4 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
>  				      unsigned long align_mask);
>  extern void iommu_area_free(unsigned long *map, unsigned long start,
>  			    unsigned int nr);
> +extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> index a3b8d4c..889ddce 100644
> --- a/lib/iommu-helper.c
> +++ b/lib/iommu-helper.c
> @@ -80,3 +80,11 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
>  	}
>  }
>  EXPORT_SYMBOL(iommu_area_free);
> +
> +unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
> +{
> +	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
> +
> +	return size >> PAGE_SHIFT;
> +}
> +EXPORT_SYMBOL(iommu_num_pages);

This doesn't work since PAGE_SIZE != IOMMU_PAGE_SIZE on the majority
of architectures.


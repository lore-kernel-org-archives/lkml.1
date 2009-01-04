Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZADKas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZADKas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZADKai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:30:38 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27134 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZADKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:30:38 -0500
X-BigFish: VPS-46(z21eW5edJz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KCXZUI-03-6QZ-01
Date: Sun, 4 Jan 2009 11:30:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joro@8bytes.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [GIT PULL] various IOMMU updates for 2.6.29
Message-ID: <20090104103016.GB25848@amd.com>
References: <20090103173130.GB6103@amd.com> <20090103220611.GA4389@elte.hu> <20090103221135.GA14298@8bytes.org> <20090103225627.GA21841@amd.com> <20090104100511.GC12938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090104100511.GC12938@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Jan 2009 10:30:16.0728 (UTC) FILETIME=[6F6B4180:01C96E57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:05:11AM +0100, Ingo Molnar wrote:
> See the patch below - i have queued it up in tip/core/urgent.
> 
> 	Ingo
> 
> ----------------------------->
> From c66b9906f863696159e05890bb7123269bb9a9de Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 4 Jan 2009 10:55:02 +0100
> Subject: [PATCH] intel-iommu: fix build error with INTR_REMAP=y and DMAR=n
> 
> dmar.o can be built in the CONFIG_INTR_REMAP=y case but
> iommu_calculate_agaw() is only available if VT-d is built as well.
> 
> So create an inline version of iommu_calculate_agaw() for the
> !CONFIG_DMAR case. The iommu->agaw value wont be used in this
> case, but the code is cleaner (has less #ifdefs) if we have it around
> unconditionally.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/dma_remapping.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
> index 136f170..af1dab4 100644
> --- a/include/linux/dma_remapping.h
> +++ b/include/linux/dma_remapping.h
> @@ -17,7 +17,15 @@ struct dmar_domain;
>  struct root_entry;
>  
>  extern void free_dmar_iommu(struct intel_iommu *iommu);
> +
> +#ifdef CONFIG_DMAR
>  extern int iommu_calculate_agaw(struct intel_iommu *iommu);
> +#else
> +static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
> +{
> +	return 0;
> +}
> +#endif
>  
>  extern int dmar_disabled;

Yeah, thats indeed better. Thanks.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


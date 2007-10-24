Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbXJXXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbXJXXeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXJXXeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:34:16 -0400
Received: from mga07.intel.com ([143.182.124.22]:58186 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754851AbXJXXeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:34:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,326,1188802800"; 
   d="scan'208";a="304919273"
Date: Wed, 24 Oct 2007 16:30:37 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       anil.s.keshavamurthy@intel.com
Subject: Re: [PATCH] intel-iommu: Fix array overflow
Message-ID: <20071024233037.GA18079@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <s5htzoirywg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5htzoirywg.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:57:51AM +0200, Takashi Iwai wrote:
> Fix possible array overflow:
> 
> drivers/pci/intel-iommu.c: In function ‘dmar_get_fault_reason’:
> drivers/pci/intel-iommu.c:753: warning: array subscript is above array bounds
> drivers/pci/intel-iommu.c: In function ‘iommu_page_fault’:
> drivers/pci/intel-iommu.c:753: warning: array subscript is above array bounds
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
>  drivers/pci/intel-iommu.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..e4b0a0d 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -749,8 +749,8 @@ static char *fault_reason_strings[] =
>  
>  char *dmar_get_fault_reason(u8 fault_reason)
>  {
> -	if (fault_reason > MAX_FAULT_REASON_IDX)
> -		return fault_reason_strings[MAX_FAULT_REASON_IDX];
> +	if (fault_reason >= MAX_FAULT_REASON_IDX)
> +		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];

This looks like what the code meant to implement.  I guess future
hardware may be able to generate more types of faults, otherwise I'd put
a BUG here.

--mgross


>  	else
>  		return fault_reason_strings[fault_reason];
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZLUGqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZLUGqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 01:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZLUGqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 01:46:11 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39759 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZLUGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 01:46:11 -0500
Date: Mon, 21 Dec 2009 17:46:07 +1100
From: Simon Horman <horms@verge.net.au>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Youquan Song <youquan.song@intel.com>
Subject: Re: [PATCH] Fix dmar_ir_support() section mismatch
Message-ID: <20091221064607.GC21782@verge.net.au>
References: <1259976692-389-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259976692-389-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 10:31:32PM -0300, Alberto Bertogli wrote:
> dmar_ir_support() uses the static dmar_tbl variable, which is annotated as
> __initdata. This causes a section mismatch because the function is not
> annotated as __init.
> 
> Since it is only used by (__init) intr_remapping_supported(), fix the
> mismatch by annotating it with __init.
> 
> The code was introduced by commit 074835f0, Sep 9 2009.
> 
> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>

This patch still seems to be necessary, am I missing something?

Tested-by: Simon Horman <horms@verge.net.au>

> ---
>  drivers/pci/dmar.c          |    2 +-
>  include/linux/intel-iommu.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index b952ebc..e6aa94e 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -1370,7 +1370,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
>  /*
>   * Check interrupt remapping support in DMAR table description.
>   */
> -int dmar_ir_support(void)
> +int __init dmar_ir_support(void)
>  {
>  	struct acpi_table_dmar *dmar;
>  	dmar = (struct acpi_table_dmar *)dmar_tbl;
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 4f0a72a..46d2c21 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -360,6 +360,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
>  
>  extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
>  
> -extern int dmar_ir_support(void);
> +extern int __init dmar_ir_support(void);
>  
>  #endif
> -- 
> 1.6.5.2.372.gc0502
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZIIVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZIIVnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZIIVnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:43:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:14915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZIIVng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,360,1249282800"; 
   d="scan'208";a="725475946"
Subject: Re: [PATCH] interrupt remapping: Disallow interrupt remapping if
 not all ioapic under interrupt remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Song, Youquan" <youquan.song@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
In-Reply-To: <20090907145807.GA30942@youquan-linux.bj.intel.com>
References: <20090907145807.GA30942@youquan-linux.bj.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 09 Sep 2009 14:42:55 -0700
Message-Id: <1252532575.2767.32.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 07:58 -0700, Song, Youquan wrote:
> Current kernel enable interrupt remapping only when all the vt-d unit support
> interrupt remapping. So it is reasonable we should also disallow enabling
> intr-remapping if there any io-apics that are not listed under vt-d units. 
> Otherwise we can run into issues.
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index 7b287cb..a8a4383 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -570,9 +570,6 @@ int __init dmar_table_init(void)
>  		printk(KERN_INFO PREFIX "No ATSR found\n");
>  #endif
>  
> -#ifdef CONFIG_INTR_REMAP
> -	parse_ioapics_under_ir();
> -#endif
>  	return 0;
>  }
>  
> diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
> index 4f5b871..ebfa47b 100644
> --- a/drivers/pci/intr_remapping.c
> +++ b/drivers/pci/intr_remapping.c
> @@ -626,6 +626,11 @@ int __init enable_intr_remapping(int eim)
>  	struct dmar_drhd_unit *drhd;
>  	int setup = 0;
>  
> +	if (parse_ioapics_under_ir() != 1) {
> +		printk(KERN_INFO "Not enable interrupt remapping\n");
> +		return -1;
> +	}
> +
>  	for_each_drhd_unit(drhd) {
>  		struct intel_iommu *iommu = drhd->iommu;
>  

David, Can you also pick this up please?

thanks,
suresh


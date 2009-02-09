Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBIGsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBIGsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZBIGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:47:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZBIGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:47:56 -0500
Message-ID: <498FD193.60506@jp.fujitsu.com>
Date: Mon, 09 Feb 2009 15:47:47 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: Re: [PATCHv3] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498C0198.3020408@suse.de>
In-Reply-To: <498C0198.3020408@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the updated patch.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thanks,
Kenji Kaneshige


Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the pci subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/pci/hotplug/pciehp.h |   10 +++++-----
>  drivers/pci/hotplug/shpchp.h |   10 +++++-----
>  drivers/pci/intel-iommu.c    |    2 +-
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1960,7 +1960,7 @@ static inline void iommu_prepare_isa(voi
>  	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
>  
>  	if (ret)
> -		printk("IOMMU: Failed to create 0-64M identity map, "
> +		printk(KERN_ERR "IOMMU: Failed to create 0-64M identity map, "
>  			"floppy might not work\n");
>  
>  }
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -46,10 +46,10 @@ extern int pciehp_force;
>  extern struct workqueue_struct *pciehp_wq;
>  
>  #define dbg(format, arg...)						\
> -	do {								\
> -		if (pciehp_debug)					\
> -			printk("%s: " format, MY_NAME , ## arg);	\
> -	} while (0)
> +do {									\
> +	if (pciehp_debug)						\
> +		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
> +} while (0)
>  #define err(format, arg...)						\
>  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
>  #define info(format, arg...)						\
> @@ -60,7 +60,7 @@ extern struct workqueue_struct *pciehp_w
>  #define ctrl_dbg(ctrl, format, arg...)					\
>  	do {								\
>  		if (pciehp_debug)					\
> -			dev_printk(, &ctrl->pcie->device,		\
> +			dev_printk(KERN_DEBUG, &ctrl->pcie->device,	\
>  					format, ## arg);		\
>  	} while (0)
>  #define ctrl_err(ctrl, format, arg...)					\
> --- a/drivers/pci/hotplug/shpchp.h
> +++ b/drivers/pci/hotplug/shpchp.h
> @@ -48,10 +48,10 @@ extern int shpchp_debug;
>  extern struct workqueue_struct *shpchp_wq;
>  
>  #define dbg(format, arg...)						\
> -	do {								\
> -		if (shpchp_debug)					\
> -			printk("%s: " format, MY_NAME , ## arg);	\
> -	} while (0)
> +do {									\
> +	if (shpchp_debug)						\
> +		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
> +} while (0)
>  #define err(format, arg...)						\
>  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
>  #define info(format, arg...)						\
> @@ -62,7 +62,7 @@ extern struct workqueue_struct *shpchp_w
>  #define ctrl_dbg(ctrl, format, arg...)					\
>  	do {								\
>  		if (shpchp_debug)					\
> -			dev_printk(, &ctrl->pci_dev->dev,		\
> +			dev_printk(KERN_DEBUG, &ctrl->pci_dev->dev,	\
>  					format, ## arg);		\
>  	} while (0)
>  #define ctrl_err(ctrl, format, arg...)					\
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



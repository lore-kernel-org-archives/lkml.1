Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZBFJBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZBFJBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZBFJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:01:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44271 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbZBFJBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:01:31 -0500
Message-ID: <498BFC67.6030701@jp.fujitsu.com>
Date: Fri, 06 Feb 2009 18:01:27 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de>
In-Reply-To: <498B29CC.2030000@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the pci subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/pci/hotplug/pciehp.h |    3 ++-
>  drivers/pci/hotplug/shpchp.h |    3 ++-
>  drivers/pci/intel-iommu.c    |    2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)
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
> @@ -48,7 +48,8 @@ extern struct workqueue_struct *pciehp_w
>  #define dbg(format, arg...)						\
>  	do {								\
>  		if (pciehp_debug)					\
> -			printk("%s: " format, MY_NAME , ## arg);	\
> +			printk(KERN_DEBUG "%s: " format, MY_NAME ,	\
> +			       ## arg);					\
>  	} while (0)
>  #define err(format, arg...)						\
>  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)

  Why didn't you retouch the following dev_printk ?

#define ctrl_dbg(ctrl, format, arg...)                                  \
        do {                                                            \
                if (pciehp_debug)                                       \
                        dev_printk(, &ctrl->pcie->device,               \
                                        format, ## arg);                \
        } while (0)

> --- a/drivers/pci/hotplug/shpchp.h
> +++ b/drivers/pci/hotplug/shpchp.h
> @@ -50,7 +50,8 @@ extern struct workqueue_struct *shpchp_w
>  #define dbg(format, arg...)						\
>  	do {								\
>  		if (shpchp_debug)					\
> -			printk("%s: " format, MY_NAME , ## arg);	\
> +			printk(KERN_DEBUG "%s: " format, MY_NAME ,	\
> +			       ## arg);					\
>  	} while (0)
>  #define err(format, arg...)						\
>  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Best regards,
Taku Izumi


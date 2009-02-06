Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZBFIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZBFIEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZBFIEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:04:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40591 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZBFIEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:04:12 -0500
Message-ID: <498BEEF6.2040803@jp.fujitsu.com>
Date: Fri, 06 Feb 2009 17:04:06 +0900
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
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de>
In-Reply-To: <498B29CC.2030000@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some minor comments below.

Frank Seidel wrote:
(snip.)
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

How about below. I think we can write printk in one line.

#define dbg(format, arg...)						\
do {									\
	if (pciehp_debug)						\
		printk(KERN_DEBUG "%s: " format, MY_NAME, ## arg);	\
} while (0)

>  #define err(format, arg...)						\
>  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
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

Ditto.

Thanks,
Kenji Kaneshige



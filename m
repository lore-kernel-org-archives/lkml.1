Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZBFKXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZBFKXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZBFKXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:23:21 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65144 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752863AbZBFKXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:23:20 -0500
Date: Fri, 6 Feb 2009 11:23:18 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, greg@kroah.com, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>
Subject: Re: [PATCHv2] PCI: add missing KERN_* constants to printks
In-Reply-To: <498BFC67.6030701@jp.fujitsu.com>
Message-ID: <alpine.LRH.2.00.0902061122090.26894@vixen.sonytel.be>
References: <498B2116.6010707@suse.de> <498B29CC.2030000@suse.de> <498BFC67.6030701@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Taku Izumi wrote:
> Frank Seidel wrote:
> > From: Frank Seidel <frank@f-seidel.de>
> > 
> > According to kerneljanitors todo list all printk calls (beginning
> > a new line) should have an according KERN_* constant.
> > Those are the missing pieces here for the pci subsystem.
> > 
> > Signed-off-by: Frank Seidel <frank@f-seidel.de>
> > ---
> >  drivers/pci/hotplug/pciehp.h |    3 ++-
> >  drivers/pci/hotplug/shpchp.h |    3 ++-
> >  drivers/pci/intel-iommu.c    |    2 +-
> >  3 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > --- a/drivers/pci/intel-iommu.c
> > +++ b/drivers/pci/intel-iommu.c
> > @@ -1960,7 +1960,7 @@ static inline void iommu_prepare_isa(voi
> >  	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
> >  
> >  	if (ret)
> > -		printk("IOMMU: Failed to create 0-64M identity map, "
> > +		printk(KERN_ERR "IOMMU: Failed to create 0-64M identity map, "
> >  			"floppy might not work\n");
> >  
> >  }
> > --- a/drivers/pci/hotplug/pciehp.h
> > +++ b/drivers/pci/hotplug/pciehp.h
> > @@ -48,7 +48,8 @@ extern struct workqueue_struct *pciehp_w
> >  #define dbg(format, arg...)						\
> >  	do {								\
> >  		if (pciehp_debug)					\
> > -			printk("%s: " format, MY_NAME , ## arg);	\
> > +			printk(KERN_DEBUG "%s: " format, MY_NAME ,	\
> > +			       ## arg);					\
> >  	} while (0)
> >  #define err(format, arg...)						\
> >  	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
> 
>   Why didn't you retouch the following dev_printk ?
> 
> #define ctrl_dbg(ctrl, format, arg...)                                  \
>         do {                                                            \
>                 if (pciehp_debug)                                       \
>                         dev_printk(, &ctrl->pcie->device,               \
>                                         format, ## arg);                \
>         } while (0)

That's almost the same as dev_dbg(), except for the test for pciehp_debug,
for which you can probably get an alternative using
CONFIG_DYNAMIC_PRINTK_DEBUG.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

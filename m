Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZFATdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZFATdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZFATd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:33:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55692 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZFATdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:33:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
Date: Mon, 1 Jun 2009 21:33:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se> <200906012047.59726.rjw@sisk.pl>
In-Reply-To: <200906012047.59726.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012133.32074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Rafael J. Wysocki wrote:
> On Monday 01 June 2009, Magnus Damm wrote:
> > From: Magnus Damm <damm@igel.co.jp>
> > 
> > Allow architecture specific data in struct platform_device V2.
> > The structure pdev_archdata is added to struct platform_device,
> > similar to struct dev_archdata in struct device.
> > 
> > Useful for architecture code that needs to keep extra data
> > associated with each platform device. This data shall not
> > be accessed by platform drivers, only architecture code.
> > 
> > Needed for platform device runtime PM.
> 
> What exactly do you need this data for?

Anyway, I think you can introduce something like:

struct <your arch>_platform_device {
    struct platform_device dev;
    <some type> <your arch data>;
    ...
};

define your platform devices using the struct above and pass its dev member to
the functions that need 'struct platform_device' as an argument.

Then you won't need to add arch members to 'struct platform_device' itself.

Best,
Rafael

 
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > ---
> > 
> >  Applies to next-20090529.
> > 
> >  Changes since V1:
> >  - post to lkml, keep linux-pm cc:ed
> >  - add struct pdev_archdata to asm-generic
> >  - add struct pdev_archdata to non-generic architectures
> >  - drop Kconfig bits
> > 
> >  arch/arm/include/asm/device.h        |    3 +++
> >  arch/ia64/include/asm/device.h       |    3 +++
> >  arch/microblaze/include/asm/device.h |    3 +++
> >  arch/powerpc/include/asm/device.h    |    3 +++
> >  arch/sparc/include/asm/device.h      |    3 +++
> >  arch/x86/include/asm/device.h        |    3 +++
> >  include/asm-generic/device.h         |    3 +++
> >  include/linux/platform_device.h      |    3 +++
> >  8 files changed, 24 insertions(+)
> > 
> > --- 0001/arch/arm/include/asm/device.h
> > +++ work/arch/arm/include/asm/device.h	2009-06-01 12:19:51.000000000 +0900
> > @@ -12,4 +12,7 @@ struct dev_archdata {
> >  #endif
> >  };
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif
> > --- 0001/arch/ia64/include/asm/device.h
> > +++ work/arch/ia64/include/asm/device.h	2009-06-01 12:18:11.000000000 +0900
> > @@ -15,4 +15,7 @@ struct dev_archdata {
> >  #endif
> >  };
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_IA64_DEVICE_H */
> > --- 0001/arch/microblaze/include/asm/device.h
> > +++ work/arch/microblaze/include/asm/device.h	2009-06-01 12:19:32.000000000 +0900
> > @@ -16,6 +16,9 @@ struct dev_archdata {
> >  	struct device_node	*of_node;
> >  };
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_MICROBLAZE_DEVICE_H */
> >  
> >  
> > --- 0001/arch/powerpc/include/asm/device.h
> > +++ work/arch/powerpc/include/asm/device.h	2009-06-01 12:16:28.000000000 +0900
> > @@ -30,4 +30,7 @@ dev_archdata_get_node(const struct dev_a
> >  	return ad->of_node;
> >  }
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_POWERPC_DEVICE_H */
> > --- 0001/arch/sparc/include/asm/device.h
> > +++ work/arch/sparc/include/asm/device.h	2009-06-01 12:18:57.000000000 +0900
> > @@ -32,4 +32,7 @@ dev_archdata_get_node(const struct dev_a
> >  	return ad->prom_node;
> >  }
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_SPARC_DEVICE_H */
> > --- 0001/arch/x86/include/asm/device.h
> > +++ work/arch/x86/include/asm/device.h	2009-06-01 12:17:28.000000000 +0900
> > @@ -13,4 +13,7 @@ struct dma_map_ops *dma_ops;
> >  #endif
> >  };
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_X86_DEVICE_H */
> > --- 0001/include/asm-generic/device.h
> > +++ work/include/asm-generic/device.h	2009-06-01 12:16:20.000000000 +0900
> > @@ -9,4 +9,7 @@
> >  struct dev_archdata {
> >  };
> >  
> > +struct pdev_archdata {
> > +};
> > +
> >  #endif /* _ASM_GENERIC_DEVICE_H */
> > --- 0001/include/linux/platform_device.h
> > +++ work/include/linux/platform_device.h	2009-06-01 12:14:43.000000000 +0900
> > @@ -22,6 +22,9 @@ struct platform_device {
> >  	struct resource	* resource;
> >  
> >  	struct platform_device_id	*id_entry;
> > +
> > +	/* arch specific additions */
> > +	struct pdev_archdata	archdata;
> >  };
> >  
> >  #define platform_get_device_id(pdev)	((pdev)->id_entry)
> > 
> > 
> --

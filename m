Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZFYOfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZFYOfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZFYOfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:35:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZFYOfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:35:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>, gregkh@suse.de
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
Date: Thu, 25 Jun 2009 16:35:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       paul@pwsan.com, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se> <87r5xhqzr4.fsf@deeprootsystems.com>
In-Reply-To: <87r5xhqzr4.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906251635.44787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 June 2009, Kevin Hilman wrote:
> Magnus Damm <magnus.damm@gmail.com> writes:
> 
> > From: Magnus Damm <damm@igel.co.jp>
> >
> > Allow architecture specific data in struct platform_device V3.
> >
> > With this patch struct pdev_archdata is added to struct
> > platform_device, similar to struct dev_archdata in found in
> > struct device. Useful for architecture code that needs to
> > keep extra data associated with each platform device.
> >
> > Struct pdev_archdata is different from dev.platform_data, the
> > convention is that dev.platform_data points to driver-specific
> > data. It may or may not be required by the driver. The format
> > of this depends on driver but is the same across architectures.
> >
> > The structure pdev_archdata is a place for architecture specific
> > data. This data is handled by architecture specific code (for
> > example runtime PM), and since it is architecture specific it
> > should _never_ be touched by device driver code. Exactly like
> > struct dev_archdata but for platform devices.
> >
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> 
> Since there is no 'Feature-desired-by:' tag, I'll addd
> 
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
> 
> For PM on ARM in general, and OMAP in particular we definitely need a
> generic way to handle arch-specific data per platform_device.

Greg, is this patch fine with you?

Best,
Rafael


> >  Applies to next-20090610.
> >
> >  Changes since V2:
> >  - updated commit message, thanks to Rafael for feedback
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

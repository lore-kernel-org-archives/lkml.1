Return-Path: <linux-kernel-owner+w=401wt.eu-S1767369AbXECEOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767369AbXECEOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767370AbXECEOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:14:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52815 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767369AbXECEOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:14:51 -0400
Date: Thu, 3 May 2007 06:15:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 6/6] firewire: add it all to kbuild
Message-ID: <20070503041543.GA12644@uranus.ravnborg.org>
References: <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <tkrat.abd13e310a4516c7@s5r6.in-berlin.de> <20070502194442.GE1248@infradead.org> <46391834.2050209@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46391834.2050209@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 01:01:08AM +0200, Stefan Richter wrote:
> Christoph Hellwig wrote:
> >> +fw-core-objs := fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
> >> +	fw-device.o fw-cdev.o
> > 
> > fw-core-y += ..
> > 
> 
> Like such?
Yes - the latter is much more readable.

	Sam

> 
> --- linux.orig/drivers/usb/core/Makefile
> +++ linux/drivers/usb/core/Makefile
> @@ -2,17 +2,12 @@
>  # Makefile for USB Core files and filesystem
>  #
> 
> -usbcore-objs	:= usb.o hub.o hcd.o urb.o message.o driver.o \
> +usbcore-y	+= usb.o hub.o hcd.o urb.o message.o driver.o \
>  			config.o file.o buffer.o sysfs.o endpoint.o \
>  			devio.o notify.o generic.o quirks.o
> 
> -ifeq ($(CONFIG_PCI),y)
> -	usbcore-objs	+= hcd-pci.o
> -endif
> -
> -ifeq ($(CONFIG_USB_DEVICEFS),y)
> -	usbcore-objs	+= inode.o devices.o
> -endif
> +usbcore-$(CONFIG_PCI)		+= hcd-pci.o
> +usbcore-$(CONFIG_USB_DEVICEFS)	+= inode.o devices.o
> 
>  obj-$(CONFIG_USB)	+= usbcore.o
> 
> 
> -- 
> Stefan Richter
> -=====-=-=== -=-= ---==
> http://arcgraph.de/sr/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

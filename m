Return-Path: <linux-kernel-owner+w=401wt.eu-S969566AbXEID6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969566AbXEID6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965975AbXEID5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:57:54 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:48923 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754076AbXEID5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:57:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZoL/SEUPk9tArCfP00UyIegA3yOEOpnWhoa6+wVQIbV/MTJXnEWAhNkysvoqeNxw+hz5r0WNZfFjfCviWc1RDGJ54ICBKEjPeXX2+EBZWZZCJ4EyjkSSG06KspfsYl6PiThEu+6f4VkkcIWL/tt6r2qYQiCpgkC8jUokJzH88qs=  ;
X-YMail-OSG: C7spC1AVM1nEVqORix6X0giuz.oRgLqRcBP5AvHRQEX1i.c7vg3ZUzJZVMZUwywSiPVjSs8cq_w9.g1UqGSVCUX3yZn9OiLGzaX9ON45Ve2A6VurIZdAK58sr4w7IA--
From: David Brownell <david-b@pacbell.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [linux-usb-devel] dead CONFIG_ variables:  drivers/usb/
Date: Tue, 8 May 2007 20:57:48 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0705030554060.30212@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705030554060.30212@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082057.48724.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Robert P. J. Day wrote:
> 
> $ ../dead_config.sh drivers/usb

I'm ignoring the USB serial stuff here.

Most of the "gadget_chips.h" symbols are not dead, they're just
constants reserved for drivers that are currently not in the
kernel.org tree.  The role is much the same as symbols generated
from the arch/arm/tools/mach-types file.

That said, I think Montavista has a few drivers it's not even
tried to push, ditto handhelds.org ... see comments below.


Thanks for sanity checking this stuff, by the way.


> ========== MACH_OMAP_H4_OTG ==========
> drivers/usb/gadget/omap_udc.c:2159:#ifndef CONFIG_MACH_OMAP_H4_OTG

This is set in some of the OMAP patches that haven't yet merged.


> ========== USB_GADGETFS_PXA2XX ==========
> drivers/usb/gadget/inode.c:1508:#ifndef CONFIG_USB_GADGETFS_PXA2XX

Hmm... should be "_GADGET_" not "_GADGETFS_".  Fixed in a patch
that I'll submit.


> ========== USB_GADGET_HUSB2DEV ==========
> drivers/usb/gadget/gadget_chips.h:78:#ifdef CONFIG_USB_GADGET_HUSB2DEV
> drivers/usb/gadget/ether.c:281:#ifdef CONFIG_USB_GADGET_HUSB2DEV

This is Atmel's AVR32 AT32ap700x USB code (high speed),
available but (like many AVR32 drivers) not yet submitted.


> ========== USB_GADGET_IMX ==========
> drivers/usb/gadget/gadget_chips.h:96:#ifdef CONFIG_USB_GADGET_IMX

Not sure what the story is with this one.  Freescale's support
for IMX family seems kind of spotty.

I'm sure I saw a driver for this at one point, but it's clearly
not been submitted and I don't know where it'd be now.


> ========== USB_GADGET_MPC8272 ==========
> drivers/usb/gadget/gadget_chips.h:122:#ifdef CONFIG_USB_GADGET_MPC8272

ISTR this is a Montavista driver; currently available with
one of their kernels, but not yet pushed upstream.


> ========== USB_GADGET_MQ11XX ==========
> drivers/usb/gadget/gadget_chips.h:54:#ifdef CONFIG_USB_GADGET_MQ11XX
> drivers/usb/gadget/ether.c:249:#ifdef CONFIG_USB_GADGET_MQ11XX

Last I heard, this driver was sitting in the hh.org tree ...


> ========== USB_GADGET_MUSB_HDRC ==========
> drivers/usb/gadget/gadget_chips.h:116:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
> drivers/usb/gadget/ether.c:277:#ifdef CONFIG_USB_GADGET_MUSB_HDRC

This is in the OMAP tree; probably nearly ready to go upstream.
(HDRC == Highspeed Dual-Role Controller ... quite complex.)


> ========== USB_GADGET_MUSBHSFC ==========
> drivers/usb/gadget/gadget_chips.h:109:#ifdef CONFIG_USB_GADGET_MUSBHSFC
> drivers/usb/gadget/ether.c:273:#ifdef CONFIG_USB_GADGET_MUSBHSFC

Another Montavista driver, not yet submitted.


> ========== USB_GADGET_N9604 ==========
> drivers/usb/gadget/gadget_chips.h:66:#ifdef CONFIG_USB_GADGET_N9604
> drivers/usb/gadget/ether.c:257:#ifdef CONFIG_USB_GADGET_N9604

Driver evidently not yet ported from Linux 2.4 (uClinux).

It's one of the few discrete (non-SOC) controllers I've come
across which doesn't use PCI and isn't OTG-capable; seems that
most vendors just want to integrate USB into their SOCs.


> ========== USB_GADGET_PXA27X ==========
> drivers/usb/gadget/gadget_chips.h:72:#ifdef CONFIG_USB_GADGET_PXA27X
> drivers/usb/gadget/ether.c:261:#ifdef CONFIG_USB_GADGET_PXA27X

Various versions of this are available.  So far as I know, none
is yet mergeable ... I've suggested that folk just stop trying
to use the broken-by-design config management stuff and instead
use it just like the PXA 25x silicon.  A long and painful saga.


> ========== USB_GADGET_S3C2410 ==========
> drivers/usb/gadget/gadget_chips.h:84:#ifdef CONFIG_USB_GADGET_S3C2410
> drivers/usb/gadget/ether.c:265:#ifdef CONFIG_USB_GADGET_S3C2410

Recently submitted ... the driver's been in use since 2005 or so.
So I'm glad to see that it's starting to move upstream!


> ========== USB_GADGET_SA1100 ==========
> drivers/usb/gadget/gadget_chips.h:42:#ifdef CONFIG_USB_GADGET_SA1100
> drivers/usb/gadget/ether.c:300:#ifdef CONFIG_USB_GADGET_SA1100

I don't think that driver has been finished; the hardware
is excessively buggy, and most of its users are on 2.4 still.
There was one partial success report on 2.6; having this work
would let the original Zaurus models upgrade to 2.6 kernels.


> ========== USB_GADGET_SH ==========
> drivers/usb/gadget/ether.c:296:#ifdef CONFIG_USB_GADGET_SH
> ========== USB_GADGET_SUPERH ==========
> drivers/usb/gadget/gadget_chips.h:36:#ifdef CONFIG_USB_GADGET_SUPERH

The _SH is a bug, should be SUPERH.  Not sure what happend to the
SH3 UDC ... it seems not to have been ported from 2.4 kernel yet.
(And I could be wrong, but I think SH3 is kind of old now.)

- Dave

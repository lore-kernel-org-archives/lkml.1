Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYE2Vdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYE2Vdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYE2Vdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:33:31 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:45023 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYE2Vdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:33:31 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 17:33:30 EDT
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Date: Thu, 29 May 2008 23:27:45 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <20080529212110.GA2870@suse.de>
In-Reply-To: <20080529212110.GA2870@suse.de>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805292327.45561.laurent.pinchart@skynet.be>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thursday 29 May 2008, Greg KH wrote:
> Here are some USB patches for your 2.6.25-git tree.
>
> They include:
> 	- bugfixes
> 	- new driver for the isight webcam device to drop firmware into
> 	  it to make it work.  It's very tiny and self-contained.
> 	- new device ids.  Lots of them.  They overshadow the new
> 	  driver, which is pretty funny.
> 	- usb quirks
> 	- usb-storage quirks
>
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>
> All of these patches have been in the -mm tree for a while, as well as
> -next.
>
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.
>
> thanks,
>
> greg k-h
>
> ------------
>
>  drivers/usb/core/generic.c         |    5 -
>  drivers/usb/core/hcd.h             |    2 +
>  drivers/usb/core/hub.c             |   15 ++-
>  drivers/usb/core/quirks.c          |    4 +
>  drivers/usb/core/sysfs.c           |   44 +++---
>  drivers/usb/gadget/fsl_usb2_udc.c  |    2 +
>  drivers/usb/host/ehci-au1xxx.c     |    1 +
>  drivers/usb/host/ehci-fsl.c        |    7 +-
>  drivers/usb/host/ehci-hcd.c        |    3 +-
>  drivers/usb/host/ehci-hub.c        |   16 ++-
>  drivers/usb/host/ehci-ixp4xx.c     |    4 +-
>  drivers/usb/host/ehci-orion.c      |    8 +-
>  drivers/usb/host/ehci-pci.c        |    4 +-
>  drivers/usb/host/ehci-ppc-of.c     |    2 +
>  drivers/usb/host/ehci-ppc-soc.c    |    1 +
>  drivers/usb/host/ehci-ps3.c        |    1 +
>  drivers/usb/host/ehci-q.c          |   15 +-
>  drivers/usb/host/ehci-sched.c      |   67 ++++++---
>  drivers/usb/host/ehci.h            |    5 +-
>  drivers/usb/misc/Kconfig           |   11 ++
>  drivers/usb/misc/Makefile          |    1 +
>  drivers/usb/misc/isight_firmware.c |  131 ++++++++++++++++++
>  drivers/usb/serial/ftdi_sio.c      |  264
> +++++++++++++++++++++++++++++++++++- drivers/usb/serial/ftdi_sio.h      | 
> 265 +++++++++++++++++++++++++++++++++++- drivers/usb/serial/option.c       
> |   34 +++---
>  drivers/usb/serial/pl2303.c        |    1 +
>  drivers/usb/serial/pl2303.h        |    1 +
>  drivers/usb/storage/unusual_devs.h |   10 +-
>  28 files changed, 821 insertions(+), 103 deletions(-)
>  create mode 100644 drivers/usb/misc/isight_firmware.c
>
> ---------------
>
> Alan Stern (8):
>       USB: fix possible deadlock involving sysfs attributes
>       USB: add all configs to the "descriptors" attribute
>       USB: EHCI: fix up root-hub TT mess
>       USB: EHCI: suppress unwanted error messages
>       USB: EHCI: fix remote-wakeup regression
>       USB: EHCI: fix bug in Iso scheduling
>       USB: EHCI: fix performance regression
>       USB: usb-storage: unusual_devs update for Cypress ATACB
>
> Javier Smaldone (1):
>       USB: Add support for ROKR W5 in unusual_devs.h
>
> Li Yang (1):
>       USB: fsl_usb2_udc: fix recursive lock
>
> Matthew Garrett (1):
>       USB: Firmware loader driver for USB Apple iSight camera

Sorry not to have spotted this sooner, but I don't like this one. Why do we 
need a specific kernel driver when a userspace tool (fxload) exists to 
perform the same task, especially when the tool handles udev integration 
nicely ? The Apple iSight uses an EZ-USB chipset. If we really want a kernel 
driver for that it should probably be made more generic to handle all 
EZ-USB-based devices.

> Michael Karcher (1):
>       USB: usb-serial: option: Don't match Huawei driver CD images
>
> Phil Dibowitz (1):
>       USB: Fix M600i unusual_devs entry
>
> Ray Molenkamp (1):
>       USB: FTDI_SIO : Add support for Matrix Orbital PID Range
>
> René Rebe (1):
>       USB: add another scanner quirk
>
> Steve Murphy (1):
>       USB: pl2303: another product ID

Best regards,

Laurent Pinchart

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZA0Xw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZA0Xw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZA0Xv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:51:58 -0500
Received: from kroah.org ([198.145.64.141]:48567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752700AbZA0Xv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:51:57 -0500
Date: Tue, 27 Jan 2009 15:49:56 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090127234956.GA10673@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6-git tree.

The largest thing here is a new driver, that was held up on the -rc1
merge due to a dependancy on some code that had to go into the ARM tree
first.  That code is now in mainline, so the driver is now being added.
It's stand-alone, so there should not be any issues.

Other than that, the series includes:
	- lots of new quirks and device ids for various USB devices.
	- USB suspend/resume bugfixes, resolving some reported
	  regressions
	- USB gadget driver bugfixes, especially some long-standing musb
	  build issues.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 arch/arm/mach-davinci/usb.c           |   23 -
 drivers/usb/Makefile                  |    1 +
 drivers/usb/class/cdc-acm.c           |    9 +
 drivers/usb/class/usblp.c             |    1 +
 drivers/usb/core/devio.c              |   20 +-
 drivers/usb/core/driver.c             |    2 +-
 drivers/usb/core/hcd-pci.c            |  117 +----
 drivers/usb/core/hcd.h                |    1 -
 drivers/usb/core/hub.c                |    4 +-
 drivers/usb/core/inode.c              |    1 -
 drivers/usb/core/message.c            |   40 +-
 drivers/usb/core/usb.h                |    6 +-
 drivers/usb/gadget/composite.c        |    9 +-
 drivers/usb/gadget/imx_udc.c          |    2 +-
 drivers/usb/host/Kconfig              |   18 +
 drivers/usb/host/Makefile             |    6 +
 drivers/usb/host/ehci-pci.c           |    3 +-
 drivers/usb/host/fhci-dbg.c           |  139 +++++
 drivers/usb/host/fhci-hcd.c           |  836 +++++++++++++++++++++++++++++++
 drivers/usb/host/fhci-hub.c           |  345 +++++++++++++
 drivers/usb/host/fhci-mem.c           |  113 +++++
 drivers/usb/host/fhci-q.c             |  284 +++++++++++
 drivers/usb/host/fhci-sched.c         |  888 +++++++++++++++++++++++++++++++++
 drivers/usb/host/fhci-tds.c           |  626 +++++++++++++++++++++++
 drivers/usb/host/fhci.h               |  607 ++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c           |    8 +-
 drivers/usb/host/ohci-pci.c           |    1 -
 drivers/usb/host/uhci-hcd.c           |    1 -
 drivers/usb/misc/ldusb.c              |    2 -
 drivers/usb/mon/mon_bin.c             |  105 +++--
 drivers/usb/musb/Kconfig              |    3 +-
 drivers/usb/musb/cppi_dma.c           |   10 +-
 drivers/usb/musb/davinci.c            |   13 +-
 drivers/usb/musb/musb_core.c          |    5 +-
 drivers/usb/musb/musb_gadget.c        |    6 +-
 drivers/usb/musb/musb_host.c          |    4 +-
 drivers/usb/musb/tusb6010_omap.c      |    4 +-
 drivers/usb/otg/Kconfig               |    4 +-
 drivers/usb/serial/cp2101.c           |    2 +
 drivers/usb/serial/ftdi_sio.c         |    2 +
 drivers/usb/serial/ftdi_sio.h         |    9 +
 drivers/usb/serial/option.c           |   14 +-
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +
 drivers/usb/serial/ti_usb_3410_5052.h |    2 +
 drivers/usb/storage/unusual_devs.h    |   36 +-
 include/linux/usb.h                   |    2 +
 46 files changed, 4105 insertions(+), 232 deletions(-)
 create mode 100644 drivers/usb/host/fhci-dbg.c
 create mode 100644 drivers/usb/host/fhci-hcd.c
 create mode 100644 drivers/usb/host/fhci-hub.c
 create mode 100644 drivers/usb/host/fhci-mem.c
 create mode 100644 drivers/usb/host/fhci-q.c
 create mode 100644 drivers/usb/host/fhci-sched.c
 create mode 100644 drivers/usb/host/fhci-tds.c
 create mode 100644 drivers/usb/host/fhci.h

---------------

Ajay Kumar Gupta (1):
      USB: musb free_irq bugfix

Alan Cox (1):
      USB: cdc-acm: Add another conexant modem to the quirks

Alan Stern (3):
      USB: fix toggle mismatch in disable_endpoint paths
      USB: don't enable wakeup by default for PCI host controllers
      USB: fix char-device disconnect handling

Alex.Cheng@quantatw.com (1):
      USB: option: add QUANTA HSDPA Data Card device ids

Andrew Lunn (1):
      USB: CDC-ACM quirk for MTK GPS

Anton Vorontsov (1):
      USB: Driver for Freescale QUICC Engine USB Host Controller

Brandon Philips (1):
      USB: usblp.c: add USBLP_QUIRK_BIDIR to Brother HL-1440

Bryan Wu (2):
      USB: composite: Fix bug: should test set_alt function pointer before use it
      USB: composite: Fix bug: low byte of w_index is the usb interface number not the whole 2 bytes of w_index

David Brownell (4):
      USB: omap1 ohci buildfix (otg related)
      USB: musb davinci buildfix
      USB: musb_hdrc: another davinci buildfix (otg related)
      USB: musb: Kconfig fix

Hugo Villeneuve (1):
      USB: musb cppi bugfixes

Inaky Perez-Gonzalez (1):
      USB: add kernel-doc for wusb_dev in struct usb_device

James A. Treacy (1):
      USB: cdc-acm: support some gps data loggers

Jean-Baptiste Onofre (1):
      USB: storage: support of Dane-Elec MediaTouch USB device

Julia Lawall (1):
      USB: musb uses endpoint functions

Kalle Valo (1):
      USB: musb: tusb6010 buildfix

Marcel Sebek (1):
      USB: 'option' driver - onda device MT503HS has wrong id

Mhayk Whandson (1):
      USB: ftdi_sio driver support of bar code scanner from Diebold

Oliver Neukum (2):
      USB: storage: add unusual devs entry
      USB: new id for ti_usb_3410_5052 driver

Pete Zaitcev (1):
      USB: usbmon: Implement compat_ioctl

Phil Dibowitz (3):
      USB: Remove ZTE modem from unusual_devices
      USB: unusual_dev: usb-storage needs to ignore a device
      USB: storage: Add another unusual_dev for off-by-one bug

Rafael J. Wysocki (1):
      USB: Fix suspend-resume of PCI USB controllers

Robie Basak (1):
      USB: ftdi_sio: added Alti-2 VID and Neptune 3 PID

Roel Kluin (1):
      USB: GADGET: fix !x & y

Swaminathan S (1):
      USB: musb cppi dma fix

Tomasz K (1):
      USB: cp2101 device

Wolfgang Glas (1):
      USB: cp2101: add fasttrax GPS evaluation kit vendor/product ID

sware (1):
      USB: remove vernier labpro from ldusb


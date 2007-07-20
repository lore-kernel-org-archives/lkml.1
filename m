Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXGTDpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXGTDpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbXGTDpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:45:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44025 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbXGTDpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:45:38 -0400
Date: Thu, 19 Jul 2007 20:44:56 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] more USB patches for 2.6.22
Message-ID: <20070720034456.GA5826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more USB patches and fixes against your 2.6.22 git tree.

They add a new usb gadget driver, more urb->status cleanups, a new sysfs
attribute to get the raw config of the usb device, and some bugfixes and
documentation updates.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 MAINTAINERS                            |    6 +
 drivers/usb/atm/cxacru.c               |    3 +-
 drivers/usb/atm/speedtch.c             |    7 +-
 drivers/usb/atm/ueagle-atm.c           |    6 +-
 drivers/usb/atm/usbatm.c               |   11 +-
 drivers/usb/class/cdc-acm.c            |   18 +-
 drivers/usb/class/usblp.c              |   27 +-
 drivers/usb/core/hcd.c                 |  131 +-
 drivers/usb/core/hub.c                 |   10 +-
 drivers/usb/core/message.c             |   34 +-
 drivers/usb/core/sysfs.c               |   53 +
 drivers/usb/core/urb.c                 |   88 +-
 drivers/usb/gadget/Kconfig             |   57 +-
 drivers/usb/gadget/Makefile            |    1 +
 drivers/usb/gadget/amd5536udc.c        | 3454 ++++++++++++++++++++++++++++++++
 drivers/usb/gadget/amd5536udc.h        |  626 ++++++
 drivers/usb/gadget/ether.c             |    4 +
 drivers/usb/gadget/gadget_chips.h      |   10 +-
 drivers/usb/gadget/m66592-udc.c        |  255 ++--
 drivers/usb/gadget/m66592-udc.h        |  610 +++---
 drivers/usb/gadget/serial.c            |   25 +-
 drivers/usb/host/isp116x-hcd.c         |  187 +-
 drivers/usb/host/r8a66597-hcd.c        |  110 +-
 drivers/usb/host/r8a66597.h            |   87 +-
 drivers/usb/host/u132-hcd.c            |   17 +-
 drivers/usb/host/uhci-q.c              |   59 +-
 drivers/usb/image/mdc800.c             |   45 +-
 drivers/usb/image/microtek.c           |   19 +-
 drivers/usb/misc/adutux.c              |   59 +-
 drivers/usb/misc/appledisplay.c        |    9 +-
 drivers/usb/misc/auerswald.c           |   25 +-
 drivers/usb/misc/ftdi-elan.c           |   21 +-
 drivers/usb/misc/iowarrior.c           |   21 +-
 drivers/usb/misc/ldusb.c               |   20 +-
 drivers/usb/misc/legousbtower.c        |   28 +-
 drivers/usb/misc/phidgetkit.c          |   13 +-
 drivers/usb/misc/phidgetmotorcontrol.c |   13 +-
 drivers/usb/misc/usblcd.c              |   11 +-
 drivers/usb/misc/usbtest.c             |    4 +-
 drivers/usb/misc/uss720.c              |    5 +-
 drivers/usb/serial/io_ti.c             |   10 +-
 drivers/usb/serial/mos7720.c           |    5 -
 drivers/usb/serial/mos7840.c           |   19 -
 drivers/usb/serial/sierra.c            |  119 +-
 drivers/usb/storage/dpcm.c             |   56 +-
 drivers/usb/storage/onetouch.c         |   13 +-
 drivers/usb/storage/unusual_devs.h     |   18 +
 47 files changed, 5350 insertions(+), 1079 deletions(-)
 create mode 100644 drivers/usb/gadget/amd5536udc.c
 create mode 100644 drivers/usb/gadget/amd5536udc.h

---------------

Alan Stern (8):
      isp116x-hcd: prepare for urb->status
      USB: add "descriptors" binary sysfs attribute
      USB: fix warning caused by autosuspend counter going negative
      UHCI: short control URBs get a status stage
      USB: documentation update for usb_unlink_urb
      USB: usb-storage: unusual_devs entry for Nikon D100
      USB: move routines in hcd.c
      USB: change name of spinlock in hcd.c

Florin Malita (1):
      USB: mos7720, mos7840: remove redundant urb check

Greg Kroah-Hartman (22):
      USB: atm: cxacru: clean up urb->status usage
      USB: atm: speedtch: clean up urb->status usage
      USB: atm: ueagle-atm: clean up urb->status usage
      USB: atm: usbatm: clean up urb->status usage
      USB: class: cdc-acm: clean up urb->status usage
      USB: class: usblp: clean up urb->status usage
      USB: storage: onetouch: clean up urb->status usage
      USB: image: mdc800: clean up urb->status usage
      USB: image: microtek: clean up urb->status usage
      USB: core: message: clean up urb->status usage
      USB: misc: adtux: clean up urb->status usage
      USB: misc: appledisplay: clean up urb->status usage
      USB: misc: auerswald: clean up urb->status usage
      USB: misc: ftdi-elan: clean up urb->status usage
      USB: misc: iowarrior: clean up urb->status usage
      USB: misc: ldusb: clean up urb->status usage
      USB: misc: legousbtower: clean up urb->status usage
      USB: misc: phidgetkit: clean up urb->status usage
      USB: misc: phidgetmotorcontrol: clean up urb->status usage
      USB: misc: usblcd: clean up urb->status usage
      USB: misc: usbtest: clean up urb->status usage
      USB: misc: uss720: clean up urb->status usage

Jesper Juhl (1):
      USB: Remove pointless conditional in drivers/usb/serial/io_ti.c::edge_shutdown()

Kevin Lloyd (2):
      USB: sierra: Add TRU-Install (c) Support
      USB: sierra: Add new devices

Matthias Kaehlcke (4):
      USB: use mutex instead of semaphore in the USB gadget serial driver
      USB: use mutex instead of semaphore in the ELAN U132 adapter driver
      USB: use mutex instead of semaphore in the Adutux driver
      USB: use mutex instead of semaphore in the FTDI ELAN driver

Pete Zaitcev (1):
      USB: usblp: "Big cleanup" breaks O_NONBLOCK

S.Caglar Onur (1):
      USB: drivers/usb/storage/dpcm.c whitespace cleanup

Thomas Dahlmann (2):
      USB: amd5536 UDC driver (in GEODE southbridge)
      USB: MAINTAINERS entry for amd5536udc

Yoshihiro Shimoda (2):
      USB: m66592-udc: fixes some problems
      USB: r8a66597-hcd: fixes some problem


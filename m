Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab0BQACp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:02:45 -0500
Received: from kroah.org ([198.145.64.141]:38511 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab0BQACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:02:42 -0500
Date: Tue, 16 Feb 2010 16:02:01 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.33-rc8
Message-ID: <20100217000201.GA31137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for the 2.6.33-rc8 tree.

They consist of a number of bug fixes, and some new device ids.

There is also a kfifo fix in here that was required by one of the USB
drivers (FHCI) to work properly after the recent kfifo changeover.  That
fix has been acked by the kfifo developer, as well as a sparse fix so
that everyone doesn't send in the same fix as they currently have
been.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/devio.c            |   48 +++++++++++++++++++++-------------
 drivers/usb/gadget/f_eem.c          |    3 +-
 drivers/usb/gadget/multi.c          |    2 +-
 drivers/usb/gadget/r8a66597-udc.c   |    1 +
 drivers/usb/gadget/s3c-hsotg.c      |    1 +
 drivers/usb/host/ehci-hub.c         |   13 ++++++---
 drivers/usb/host/fhci-tds.c         |    6 ++--
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 drivers/usb/otg/Kconfig             |    1 +
 drivers/usb/serial/ftdi_sio.c       |   25 ++++++++++++++++--
 drivers/usb/serial/ftdi_sio_ids.h   |   18 +++++++++++++
 drivers/usb/serial/sierra.c         |    1 +
 drivers/usb/storage/unusual_devs.h  |    2 +-
 include/linux/kfifo.h               |    2 +-
 kernel/kfifo.c                      |    3 +-
 15 files changed, 92 insertions(+), 35 deletions(-)

---------------

Alek Du (1):
      USB: ehci: phy low power mode bug fixing

Andreas Mohr (1):
      USB: ftdi_sio: add device IDs (several ELV, one Mindstorms NXT)

Anton Vorontsov (3):
      kfifo: Make kfifo_initialized work after kfifo_free
      USB: FHCI: Fix build after kfifo rework
      kfifo: Don't use integer as NULL pointer

Brian Niebuhr (1):
      USB: gadget: fix EEM gadget CRC usage

Greg Kroah-Hartman (1):
      USB: usbfs: only copy the actual data received

Linus Torvalds (1):
      USB: usbfs: properly clean up the as structure on error paths

Mark Brown (2):
      USB: r8a66597-udc: Prototype IS_ERR() and PTR_ERR()
      USB: s3c-hsotg: Export usb_gadget_register_driver()

Michal Nazarewicz (1):
      USB: g_multi: fix CONFIG_USB_G_MULTI_RNDIS usage

Phil Dibowitz (1):
      USB: storage: Remove unneeded SC/PR from unusual_devs.h

Radek Liboska (1):
      USB: ftdi_sio: new device id for papouch AD4USB

Richard Farina (1):
      USB: serial: add usbid for dell wwan card to sierra.c

Tanaka Akira (1):
      USB: SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor USB20SVGA-MB-PLUS

Valentin Longchamp (1):
      USB: otg Kconfig: let USB_OTG_UTILS select USB_ULPI option


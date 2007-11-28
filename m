Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbXK1Wtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbXK1Wtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbXK1WtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:49:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55025 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbXK1WtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:49:01 -0500
Date: Wed, 28 Nov 2007 14:48:00 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.24-rc3
Message-ID: <20071128224800.GC28410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and changes against your 2.6.24-rc3 git tree.

These are all a bunch of minor fixes and new device ids being added, as
well as some documentation fixes.  The largest being a big locking
cleanup of the adutux driver, and a usb-storage bugfix for a whole range
of devices that people are starting to have problems with.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/power-management.txt |    8 +
 MAINTAINERS                            |  101 +++++--------
 drivers/usb/README                     |    6 +-
 drivers/usb/core/driver.c              |   11 --
 drivers/usb/core/hcd.c                 |    3 +-
 drivers/usb/core/hub.c                 |    2 +-
 drivers/usb/core/message.c             |   36 +----
 drivers/usb/core/sysfs.c               |    6 +
 drivers/usb/core/usb.c                 |   25 +++
 drivers/usb/gadget/omap_udc.c          |    6 +-
 drivers/usb/gadget/s3c2410_udc.c       |   16 ++-
 drivers/usb/host/Kconfig               |    2 +-
 drivers/usb/host/ehci-hcd.c            |    5 +-
 drivers/usb/image/microtek.c           |    2 +-
 drivers/usb/misc/adutux.c              |  262 +++++++++++++++++---------------
 drivers/usb/misc/usbled.c              |    4 +-
 drivers/usb/serial/generic.c           |    5 +-
 drivers/usb/serial/mos7840.c           |    2 +-
 drivers/usb/serial/pl2303.c            |    1 +
 drivers/usb/serial/pl2303.h            |    3 +
 drivers/usb/serial/sierra.c            |    2 +
 drivers/usb/storage/scsiglue.c         |    4 +
 drivers/usb/storage/unusual_devs.h     |   17 ++-
 include/linux/usb.h                    |    1 +
 include/linux/usbdevice_fs.h           |    3 +-
 25 files changed, 272 insertions(+), 261 deletions(-)

---------------

Adrian Bunk (1):
      USB: fix USB_OHCI_HCD_SSB dependencies

Alan Stern (5):
      USB: power-management documenation update
      USB HCD: avoid duplicate local_irq_disable()
      USB: keep track of whether interface sysfs files exist
      USB: uevent environment key fix
      USB: usb-storage: unusual_devs entry for JetFlash TS1GJF2A

Ben Dooks (3):
      USB: s3c2410 gadget: Header move fixups
      USB: s3c2410 gadget: allow sharing of vbus irq
      USB: s3c2410 gadget: ensure vbus pin in input mode during read

Borislav Petkov (1):
      usbserial: fix inconsistent lock state

David Brownell (3):
      USB: omap_udc build fix
      USB: remove USB HUB entry from MAINTAINERS
      USB: fix up EHCI startup synchronization

Dirk Hohndel (1):
      USB: fix directory references in usb/README

Greg Kroah-Hartman (1):
      USB: mailing lists have changed

Magnus Damm (1):
      USB: pl2303: add support for Corega CG-USBRS232R

Mauro Carvalho Chehab (1):
      usb-storage: always set the allow_restart flag

Mike Pagano (1):
      USB: add support for an older firmware revision for the Nikon D200

Oliver Neukum (2):
      USB: fix usbled disconnect read race #2
      USB: make the microtek driver and HAL cooperate

Pete Zaitcev (1):
      USB: FIx locks and urb->status in adutux (updated)

Phil Endecott (1):
      USB: Fix signr comment in usbdevice_fs.h

Roel Kluin (2):
      USB: Fix priority mistakes in drivers/usb/core/hub.c
      USB: free memory when writing fails in usb/serial/mos7840.c

agilmore@wirelessbeehive.com (1):
      USB: sierra: new product id


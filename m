Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYHURdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYHURdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHURdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:33:35 -0400
Received: from mail.suse.de ([195.135.220.2]:47433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbYHURde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:33:34 -0400
Date: Thu, 21 Aug 2008 10:30:27 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.27-rc4
Message-ID: <20080821173027.GA7974@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.26-git tree.

The majority of this patch is removing a file from the recently added
musb driver, as we shouldn't be adding new proc files for drivers,
debugfs is much better for that.

Other than that, the rest are:
	- usb suspend bugfixes
	- add back a patch you reverted at the very end of 2.6.26
	- usb driver bugfixes
	- device id updates

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c         |    5 +-
 drivers/usb/core/driver.c           |   96 ++--
 drivers/usb/core/hcd.c              |    9 -
 drivers/usb/core/hcd.h              |    4 -
 drivers/usb/core/hub.c              |    9 -
 drivers/usb/core/urb.c              |    9 +-
 drivers/usb/core/usb.c              |   73 +++-
 drivers/usb/core/usb.h              |    3 +
 drivers/usb/gadget/pxa27x_udc.c     |    2 +-
 drivers/usb/host/isp1760-hcd.c      |    2 +-
 drivers/usb/host/ohci-at91.c        |    1 -
 drivers/usb/host/ohci-au1xxx.c      |    1 -
 drivers/usb/host/ohci-ep93xx.c      |    1 -
 drivers/usb/host/ohci-hub.c         |   53 ++-
 drivers/usb/host/ohci-lh7a404.c     |    1 -
 drivers/usb/host/ohci-omap.c        |    1 -
 drivers/usb/host/ohci-pci.c         |    1 -
 drivers/usb/host/ohci-pnx4008.c     |    1 -
 drivers/usb/host/ohci-pnx8550.c     |    1 -
 drivers/usb/host/ohci-ppc-of.c      |    1 -
 drivers/usb/host/ohci-ppc-soc.c     |    1 -
 drivers/usb/host/ohci-ps3.c         |    1 -
 drivers/usb/host/ohci-pxa27x.c      |    1 -
 drivers/usb/host/ohci-s3c2410.c     |    1 -
 drivers/usb/host/ohci-sa1111.c      |    1 -
 drivers/usb/host/ohci-sh.c          |    1 -
 drivers/usb/host/ohci-sm501.c       |    1 -
 drivers/usb/host/ohci-ssb.c         |    1 -
 drivers/usb/host/u132-hcd.c         |   11 -
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 drivers/usb/musb/Kconfig            |   13 +-
 drivers/usb/musb/Makefile           |   21 +-
 drivers/usb/musb/musb_core.c        |   38 +-
 drivers/usb/musb/musb_core.h        |   19 -
 drivers/usb/musb/musb_debug.h       |    4 -
 drivers/usb/musb/musb_gadget_ep0.c  |    2 +
 drivers/usb/musb/musb_procfs.c      |  830 -----------------------------------
 drivers/usb/serial/option.c         |    2 +
 include/linux/usb.h                 |    3 +
 39 files changed, 194 insertions(+), 1032 deletions(-)
 delete mode 100644 drivers/usb/musb/musb_procfs.c

---------------

Alan Stern (5):
      USB: Add udev argument to interface suspend/resume functions
      USB: Defer Set-Interface for suspended devices
      USB: Add new PM callback methods for USB
      USB: Don't rebind before "complete" callback
      USB: automatically enable RHSC interrupts

Alexey Dobriyan (1):
      USB: cdc-acm: don't unlock acm->mutex on error path

Anand Gadiyar (1):
      MUSB: Fix index register corruption seen with g_ether and Windows host

Enrico Scholz (1):
      USB: ISP1760: fixed trivial math in comment

Eric Sandeen (1):
      USB: cdc-acm: quirk for Conexant CX93010 USB modem

Felipe Balbi (2):
      usb: musb: get rid of procfs entry
      usb: musb: get rid of MUSB_LOGLEVEL and use parameter

Hiroshi Miura (1):
      usb-serial: option support HSDPA modem A2502

Oliver Neukum (1):
      USB: fix bug in usb_unlink_anchored_urbs()

Robert Jarzmik (1):
      USB: Fix pxa27x_udc usb speed handling.

Stefan Lippers-Hollmann (1):
      USB: sisusbvga: add USB ID for 0711:0918 Magic Control Technology Corp.


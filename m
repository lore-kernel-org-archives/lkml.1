Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZDQTEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZDQTEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZDQTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:04:40 -0400
Received: from kroah.org ([198.145.64.141]:34571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753843AbZDQTEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:04:39 -0400
Date: Fri, 17 Apr 2009 12:01:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.31-rc2
Message-ID: <20090417190139.GA3548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a number of USB fixes for your 2.6.31-rc2 tree.

Lots of little bugfixes, with the majority being in the musb driver,
which has had a lot of patches queued up for it for quite some time now.

It also cleans up the ch341 commit that Alan Cox pointed out was
incorrect in the last USB merge.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/block/ub.c                        |   20 +-
 drivers/isdn/hisax/st5481_usb.c           |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    1 -
 drivers/usb/class/cdc-wdm.c               |    2 +-
 drivers/usb/core/devio.c                  |    2 +-
 drivers/usb/core/hcd.c                    |   26 ++
 drivers/usb/core/hcd.h                    |   14 +
 drivers/usb/core/message.c                |   58 +++--
 drivers/usb/core/usb.c                    |    2 +-
 drivers/usb/gadget/u_ether.c              |    8 +-
 drivers/usb/host/whci/asl.c               |   15 +-
 drivers/usb/host/whci/hcd.c               |   23 ++
 drivers/usb/host/whci/pzl.c               |   16 +-
 drivers/usb/host/whci/qset.c              |   24 ++-
 drivers/usb/host/whci/whcd.h              |    1 +
 drivers/usb/host/whci/whci-hc.h           |    1 +
 drivers/usb/musb/cppi_dma.c               |   23 +--
 drivers/usb/musb/musb_core.c              |   12 +-
 drivers/usb/musb/musb_gadget.c            |   33 ++-
 drivers/usb/musb/musb_host.c              |  406 ++++++++++++++++-------------
 drivers/usb/musb/musbhsdma.c              |   66 +++--
 drivers/usb/serial/ftdi_sio.c             |    1 +
 drivers/usb/serial/ftdi_sio.h             |    7 +
 drivers/usb/serial/moto_modem.c           |    1 +
 drivers/usb/serial/option.c               |    5 +
 drivers/usb/serial/qcserial.c             |   21 ++
 drivers/usb/storage/Makefile              |    3 +-
 drivers/usb/storage/transport.c           |    4 +-
 drivers/usb/storage/unusual_devs.h        |   14 +-
 drivers/usb/wusbcore/devconnect.c         |   21 +-
 drivers/usb/wusbcore/wusbhc.c             |   32 ++--
 include/linux/usb.h                       |    9 +-
 32 files changed, 532 insertions(+), 348 deletions(-)

---------------

Alan Stern (2):
      USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab
      usb-storage: fix mistake in Makefile

David Brownell (2):
      USB: musb_host, minor enqueue locking fix (v2)
      USB: musb_host, fix ep0 fifo flushing

David Vrabel (6):
      USB: add reset endpoint operations
      USB: whci-hcd: provide a endpoint_reset method
      USB: whci-hcd: check return value of usb_hcd_link_urb_to_ep()
      WUSB: disconnect all devices when stopping a WUSB HCD
      WUSB: fix oops when completing URBs for disconnected devices
      WUSB: correct format of wusb_chid sysfs file

Dr. Greg Wettstein (1):
      USB device codes for Motorola phone.

Greg Kroah-Hartman (1):
      Revert USB: usb-serial ch341: support for DTR/RTS/CTS

Jonathan McDowell (1):
      usb gadget: fix ethernet link reports to ethtool

Kim Kyuwon (1):
      USB: musb: fix possible panic while resuming

Matthew Garrett (1):
      USB: qcserial: Add extra device IDs

Oliver Neukum (1):
      USB: fix oops in cdc-wdm in case of malformed descriptors

Pascal Terjan (1):
      USB: option: Add ids for D-Link DWM-652 3.5G modem

Peter Korsgaard (1):
      USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer

Sergei Shtylyov (3):
      USB: musb: bugfixes for multi-packet TXDMA support
      USB: musb: sanitize clearing TXCSR DMA bits (take 2)
      USB: musb: fix isochronous TXDMA (take 2)

Werner Cornelius (1):
      USB: usb-serial ch341: support for DTR/RTS/CTS


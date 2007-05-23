Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXEWGvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXEWGvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbXEWGvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:51:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbXEWGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:51:13 -0400
Date: Tue, 22 May 2007 23:50:26 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.22-rc2
Message-ID: <20070523065026.GA2414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.22-rc2 tree.

They fix a number of minor and semi-major issues (suspend to ram should
now work properly for everyone that was hitting the "USB can't suspend"
error) and add a number of new device ids to various USB drivers.

All of these, except for the new device ids, have been in the -mm
releses for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/DocBook/gadget.tmpl  |    2 +-
 Documentation/DocBook/usb.tmpl     |   28 ++++++++++++------------
 drivers/net/usb/cdc_ether.c        |   16 ++++++++++++++
 drivers/net/usb/rndis_host.c       |    1 +
 drivers/net/usb/usbnet.c           |   25 +++++++++++++---------
 drivers/net/usb/usbnet.h           |    1 +
 drivers/usb/class/usblp.c          |    2 +-
 drivers/usb/core/config.c          |   10 +++++---
 drivers/usb/core/driver.c          |   18 ++++++++++++---
 drivers/usb/core/hcd.c             |    6 +----
 drivers/usb/core/hub.c             |   21 +++++++-----------
 drivers/usb/core/message.c         |    9 +------
 drivers/usb/core/sysfs.c           |    7 ++++++
 drivers/usb/core/usb.c             |    6 ++++-
 drivers/usb/gadget/fsl_usb2_udc.c  |    8 ++++--
 drivers/usb/host/ohci-pci.c        |    2 +-
 drivers/usb/host/pci-quirks.c      |    9 ++++++++
 drivers/usb/host/u132-hcd.c        |   12 ++++++----
 drivers/usb/misc/auerswald.c       |   10 +-------
 drivers/usb/misc/ftdi-elan.c       |   12 +++++++---
 drivers/usb/misc/ldusb.c           |   35 +++++++++++++++++++++++++++---
 drivers/usb/serial/ark3116.c       |    3 +-
 drivers/usb/serial/ftdi_sio.c      |   40 ++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h      |   12 ++++++++++
 drivers/usb/serial/mos7840.c       |    5 ----
 drivers/usb/serial/omninet.c       |    2 -
 drivers/usb/serial/option.c        |    1 -
 drivers/usb/serial/sierra.c        |    2 +
 drivers/usb/storage/onetouch.c     |    9 ++++---
 drivers/usb/storage/unusual_devs.h |   10 +++++++-
 30 files changed, 222 insertions(+), 102 deletions(-)

---------------

Alan Stern (9):
      EHCI: fix problem with BIOS handoff
      USB: more autosuspend timer stuff
      USB: remove unneeded WARN_ON
      USB: set the correct Interrupt interval in usb_bulk_msg
      USB: remove short initial timeout for device descriptor fetch
      USB: don't try to kzalloc 0 bytes
      USB: make the autosuspend workqueue thread freezable
      USB: handle errors in power/level attribute
      USB: fix ratelimit call semantics

Andrew Morton (1):
      USB: auerswald: fix file release handler

Andrey Borzenkov (1):
      USB: Fix USB OHCI Subvendor for Toshiba Portege 4000

Ben Collins (1):
      USB: Remove duplicate IDs from option card driver

Danny Budik (1):
      USB: Add support for Sierra Wireless Aircard 595U

David Brownell (3):
      USB: fix more ftdi-elan/u132-hcd #include lossage
      USB: handle more rndis_host oddities
      USB: remove usb DocBook warnings

Dmitry Torokhov (1):
      USB: Onetouch - switch to using input_dev->dev.parent

Guido Scholz (1):
      USB: ftdi_sio: Add USB Product Id for OpenDCC

Jan Engelhardt (1):
      USB: Fix debug output of ark3116

Li Yang (1):
      USB: fsl_usb2_udc: Fix UMTI_WIDE support and a compile warning

Matthew Davidson (1):
      usb-storage: ignore Sitecom WL-117 USB-WLAN

Neil \"Superna\" ARMSTRONG (1):
      USB: New device PID for ftdi_sio driver

Oliver Neukum (4):
      USB: fix omninet memory leak found by coverity
      USB: remove useless check in mos7840 found by coverity
      USB: address FIXME in usbnet w.r.t drivers claiming multiple interfaces
      USB: ldusb bugfix

Pete Zaitcev (2):
      USB: Deref URB after usbmon is done with it
      USB: usblp: Use correct DMA address in case of probe error

Tony Lindgren (1):
      USB: Add support for Olimex arm-usb-ocd JTAG interface serial port


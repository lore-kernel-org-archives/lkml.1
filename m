Return-Path: <linux-kernel-owner+w=401wt.eu-S1031033AbXFIADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031033AbXFIADY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbXFIADQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:03:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40818 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbXFIADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:03:15 -0400
Date: Fri, 8 Jun 2007 17:03:12 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.22-rc4
Message-ID: <20070609000312.GA17574@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.22-rc4 tree.

They fix a number of minor things and update some documentation and add
some usb-storage quirks, and make the config option a default that has
been tripping up some usbfs users with older udev configurations.

All of these have been in the -mm releases for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/networking/00-INDEX   |    2 +
 Documentation/networking/cxacru.txt |   84 +++++++++++++++++++++++++++++++++++
 drivers/usb/atm/cxacru.c            |   52 +++++++++++-----------
 drivers/usb/class/usblp.c           |    5 +-
 drivers/usb/core/Kconfig            |   22 +++++----
 drivers/usb/core/config.c           |   42 +++++++++++++++++-
 drivers/usb/gadget/epautoconf.c     |    2 +-
 drivers/usb/gadget/inode.c          |    8 ++--
 drivers/usb/gadget/net2280.c        |    6 +-
 drivers/usb/gadget/omap_udc.c       |    6 +-
 drivers/usb/gadget/rndis.c          |   35 +++++++++-----
 drivers/usb/host/ohci-hub.c         |    2 +
 drivers/usb/storage/unusual_devs.h  |   21 ++++++++-
 13 files changed, 222 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/networking/cxacru.txt

---------------

Alan Stern (2):
      USB: Fix up bogus bInterval values in endpoint descriptors
      OHCI: Fix machine check in ohci_hub_status_data

Ben Collins (1):
      USB: UNUSUAL_DEV: Sync up some reported devices from Ubuntu

David Brownell (1):
      USB: usb gadgets avoid le{16,32}_to_cpup()

Kay Sievers (1):
      USB: set default y for CONFIG_USB_DEVICE_CLASS

Pete Zaitcev (1):
      usblp: Don't let suspend to kill ->used

Simon Arlott (3):
      USB: cxacru: add Documentation file
      USB: cxacru: create sysfs attributes in atm_start instead of bind
      USB: cxacru: ignore error trying to start ADSL in atm_start


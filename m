Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbXBWXQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbXBWXQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933262AbXBWXQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:16:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:35163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933258AbXBWXQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:16:05 -0500
Date: Fri, 23 Feb 2007 15:14:36 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.21-rc1
Message-ID: <20070223231436.GB20498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches against 2.6.21-rc1.

It contains two new drivers, and a bunch of fixes for autosuspend issues
which are showing up for a variety of different devices and people.
There are a few new device ids, and other minor bugfixes in here too.

There is a sysfs patch in here too, as the usb suspend changes require
it.  It's here so that everything builds properly using git bisect.

Most of these have been in the -mm releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/kernel-parameters.txt |    7 +
 MAINTAINERS                         |    7 +
 drivers/usb/core/Makefile           |    2 +-
 drivers/usb/core/driver.c           |   69 ++-
 drivers/usb/core/hub.c              |    3 +
 drivers/usb/core/message.c          |    6 +-
 drivers/usb/core/quirks.c           |   77 +++
 drivers/usb/core/sysfs.c            |  111 ++++-
 drivers/usb/core/usb.c              |   12 +
 drivers/usb/core/usb.h              |    9 +-
 drivers/usb/gadget/inode.c          |    5 +-
 drivers/usb/host/uhci-debug.c       |   57 ++-
 drivers/usb/host/uhci-hcd.c         |   58 +--
 drivers/usb/host/uhci-hcd.h         |   82 ++--
 drivers/usb/host/uhci-q.c           |  219 +++++++--
 drivers/usb/input/usbkbd.c          |    4 +-
 drivers/usb/input/usbmouse.c        |    4 +-
 drivers/usb/input/wacom_wac.c       |  103 +++--
 drivers/usb/input/wacom_wac.h       |    1 +
 drivers/usb/misc/Kconfig            |   14 +
 drivers/usb/misc/Makefile           |    1 +
 drivers/usb/misc/iowarrior.c        |  925 +++++++++++++++++++++++++++++++++++
 drivers/usb/mon/mon_bin.c           |    2 +-
 drivers/usb/mon/mon_text.c          |    2 +-
 drivers/usb/mon/usb_mon.h           |    4 +-
 drivers/usb/net/Kconfig             |    9 +
 drivers/usb/net/Makefile            |    1 +
 drivers/usb/net/asix.c              |   14 +-
 drivers/usb/net/dm9601.c            |  606 +++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio.c       |    1 +
 drivers/usb/serial/ftdi_sio.h       |    6 +
 drivers/usb/serial/option.c         |  117 +++--
 fs/sysfs/file.c                     |   44 ++
 include/linux/sysfs.h               |   17 +
 include/linux/usb.h                 |    4 +
 include/linux/usb/ch9.h             |   22 +-
 include/linux/usb/iowarrior.h       |   33 ++
 include/linux/usb/quirks.h          |   11 +
 38 files changed, 2393 insertions(+), 276 deletions(-)
 create mode 100644 drivers/usb/core/quirks.c
 create mode 100644 drivers/usb/misc/iowarrior.c
 create mode 100644 drivers/usb/net/dm9601.c
 create mode 100644 include/linux/usb/iowarrior.h
 create mode 100644 include/linux/usb/quirks.h

---------------

Alan Stern (6):
      UHCI: Add macros for computing DMA values
      UHCI: Eliminate asynchronous skeleton Queue Headers
      USB: minor cleanups for sysfs.c
      USB: make autosuspend delay a module parameter
      sysfs: allow attributes to be added to groups
      USB: export autosuspend delay in sysfs

David Hollis (1):
      USB: asix.c - Add JVC-PRX1 ids

Greg Kroah-Hartman (4):
      USB: option: remove duplicate device id table
      USB: option: add a bunch of new device ids
      USB: add driver for iowarrior devices.
      USB: refactor usb device matching and create usb_device_match

Inaky Perez-Gonzalez (1):
      USB: add rationale on why usb descriptor structures have to be packed

Michael Opdenacker (1):
      USB: Use USB defines in usbmouse.c and usbkbd.c

Micke Prag (1):
      USB: ftdi_sio: Adding VID and PID for Tellstick

Oliver Neukum (1):
      USB: add a blacklist for devices that can't handle some things we throw at them.

Pete Zaitcev (1):
      usbmon: Remove erroneous __exit

Peter Korsgaard (1):
      USB: Davicom DM9601 usbnet driver

Ping Cheng (1):
      USB: Wacom driver updates

Sarah Bailey (1):
      gadgetfs: Fixed bug in ep_aio_read_retry.


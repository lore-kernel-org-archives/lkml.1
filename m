Return-Path: <linux-kernel-owner+w=401wt.eu-S1946294AbXBPXgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946294AbXBPXgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946296AbXBPXgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:36:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:51720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946294AbXBPXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:36:52 -0500
Date: Fri, 16 Feb 2007 15:35:33 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] more USB patches for 2.6.20
Message-ID: <20070216233533.GA14708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more USB patches against 2.6.20-git

There's a tiny driver to charge blackberry devices, and lots of device
ids and bugfixes.

All of these have been in the -mm releases for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h

 drivers/scsi/sd.c                  |   11 +++-
 drivers/usb/Makefile               |    1 +
 drivers/usb/atm/ueagle-atm.c       |    1 +
 drivers/usb/class/cdc-acm.c        |   33 ++++++---
 drivers/usb/core/devices.c         |    9 ++-
 drivers/usb/core/devio.c           |    4 +-
 drivers/usb/core/driver.c          |    1 +
 drivers/usb/core/endpoint.c        |    2 +-
 drivers/usb/core/generic.c         |    2 +-
 drivers/usb/core/hub.c             |   31 ++++----
 drivers/usb/core/message.c         |   22 +++++-
 drivers/usb/core/otg_whitelist.h   |    2 +-
 drivers/usb/core/sysfs.c           |    2 +-
 drivers/usb/gadget/at91_udc.c      |   15 ++--
 drivers/usb/gadget/serial.c        |    1 +
 drivers/usb/host/ehci-hcd.c        |   36 ++++++++--
 drivers/usb/host/ehci-hub.c        |    2 +
 drivers/usb/host/isp116x-hcd.c     |    2 +-
 drivers/usb/host/ohci-at91.c       |   50 +++++++++-----
 drivers/usb/host/ohci-hcd.c        |   18 ++++--
 drivers/usb/input/hid-core.c       |    8 +--
 drivers/usb/misc/Kconfig           |   11 +++
 drivers/usb/misc/Makefile          |    1 +
 drivers/usb/misc/berry_charge.c    |  140 ++++++++++++++++++++++++++++++++++++
 drivers/usb/net/Kconfig            |   11 +++-
 drivers/usb/net/asix.c             |    2 +
 drivers/usb/net/cdc_subset.c       |   21 +++++-
 drivers/usb/net/usbnet.c           |   29 ++++----
 drivers/usb/serial/airprime.c      |   35 ++-------
 drivers/usb/serial/cp2101.c        |    1 +
 drivers/usb/serial/generic.c       |  102 +++++++++++++++++++++-----
 drivers/usb/serial/option.c        |    4 -
 drivers/usb/serial/pl2303.c        |    1 +
 drivers/usb/serial/pl2303.h        |    5 ++
 drivers/usb/storage/scsiglue.c     |    6 ++
 drivers/usb/storage/unusual_devs.h |   26 ++++++-
 drivers/usb/usb-skeleton.c         |   10 ++-
 include/linux/usb.h                |    2 +-
 include/linux/usb/cdc.h            |    7 ++
 include/linux/usb/ch9.h            |   20 +++---
 include/linux/usb/serial.h         |    6 ++
 include/linux/usb_usual.h          |    4 +-
 include/linux/usbdevice_fs.h       |    4 +-
 include/scsi/scsi_device.h         |    1 +
 44 files changed, 532 insertions(+), 170 deletions(-)
 create mode 100644 drivers/usb/misc/berry_charge.c

---------------

Adrian Bunk (1):
      USB: USB_RTL8150 must select MII

Alan Stern (6):
      EHCI: turn off remote wakeup during shutdown
      USB: unusual_devs update for Sony P990i phone
      usbcore: small changes to hub driver's suspend method
      EHCI: add debugging message to ehci_bus_suspend
      USB: fix concurrent buffer access in the hub driver
      USB: unconfigure devices which have config 0

Andrew Victor (1):
      USB: at91-ohci, handle extra at91sam9261 ahb clock

Bryan O'Donoghue (1):
      USB: fix g_serial small error

David Brownell (4):
      usbnet: recognize SiteCom CN-124
      usbnet: init fault (oops) cleanup, whitespace fixes
      usbnet: add missing Kconfig for KC2190 cables
      USB: at91_udc, shrink runtime footprint

David Hollis (1):
      USB: asix - Fix endian issues in asix_tx_fixup()

Dylan Taft (1):
      USB Storage: US_FL_IGNORE_RESIDUE needed for Aiptek MP3 Player

Greg Kroah-Hartman (1):
      USB: Driver to charge USB blackberry devices

Inaky Perez-Gonzalez (1):
      USB: descriptor structures have to be packed

Ishizaki Kou (1):
      USB: ps3: don't call ps3_system_bus_driver_register on other platforms

Jeremy Roberson (1):
      USB: hid-core.c: Removes GTCO CalComp Interwrite IPanel PIDs from blacklist

Joris van Rantwijk (1):
      USB: add flow control to usb-serial generic driver.

Josh Triplett (1):
      USB: In init_endpoint_class, use PTR_ERR to obtain an errno value, not IS_ERR

Kevin Lloyd (1):
      usb: Remove Airprime device from option.c

Mike Frysinger (1):
      USB: use __u32 rather than u32 in userspace ioctls in usbdevice_fs.h

Oliver Neukum (5):
      USB: fix needless failure under certain conditions
      USB: fix autosuspend race in skeleton driver
      USB Storage: indistinguishable devices with broken and unbroken firmware
      USB: cdc-acm: fix incorrect throtteling, make set_control optional
      USB: quirky device for cdc-acm

Pete Zaitcev (2):
      USB: Fix error cleanup path in airprime
      USB: make usb_iso_packet_descriptor.status signed

Pozsar Balazs (1):
      USB: another id for cp2101 driver

Prarit Bhargava (1):
      USB: change __init to __devinit for isp116x_probe

Randy Dunlap (2):
      USB: kernel-doc fixes
      USB: ueagle-atm.c needs sched.h

Robert P. J. Day (2):
      USB: Fix apparent typo CONFIG_USB_CDCETHER.
      USB: Fix misspelled "USBNET_MII" kernel config option.

Thomas Bächler (1):
      USB: Teac HD-35PU patch to unusual_devs.h

YOSHIFUJI Hideaki (1):
      USB: PL2303: Willcom WS002IN Support.

Zheng XiaoJun (1):
      USB: input: HID: add CIDC USB device to HID blacklist


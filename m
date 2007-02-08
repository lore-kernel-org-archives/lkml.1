Return-Path: <linux-kernel-owner+w=401wt.eu-S1422849AbXBHAbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422849AbXBHAbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422846AbXBHAao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:30:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:56302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422839AbXBHAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:30:32 -0500
Date: Wed, 7 Feb 2007 16:29:22 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.20
Message-ID: <20070208002922.GB4796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of USB patches against 2.6.20-git

They include some new drivers (including PS3 support), some new features
(dynamic id support for usb-serial drivers), and loads of other stuff.

All of these have been in the -mm releases for quite some time.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/usb/proc_usb_info.txt        |   21 +-
 Documentation/usb/usbmon.txt               |  152 ++++-
 arch/powerpc/Kconfig                       |    5 +
 drivers/i2c/chips/isp1301_omap.c           |    2 +-
 drivers/media/video/zc0301/zc0301_sensor.h |    1 -
 drivers/usb/atm/speedtch.c                 |    2 +-
 drivers/usb/class/usblp.c                  |   16 +-
 drivers/usb/core/Kconfig                   |   13 -
 drivers/usb/core/buffer.c                  |   36 +-
 drivers/usb/core/devices.c                 |   22 +-
 drivers/usb/core/devio.c                   |   25 +-
 drivers/usb/core/driver.c                  |   35 +-
 drivers/usb/core/file.c                    |   13 +-
 drivers/usb/core/generic.c                 |   28 +-
 drivers/usb/core/hcd.c                     |  137 ----
 drivers/usb/core/hcd.h                     |    6 -
 drivers/usb/core/hub.c                     |   64 +-
 drivers/usb/core/message.c                 |    6 +-
 drivers/usb/core/sysfs.c                   |   98 ++--
 drivers/usb/core/urb.c                     |   21 +-
 drivers/usb/core/usb.c                     |   96 ++--
 drivers/usb/gadget/at91_udc.c              |   21 +-
 drivers/usb/gadget/at91_udc.h              |    1 +
 drivers/usb/gadget/config.c                |    2 +-
 drivers/usb/gadget/epautoconf.c            |    2 +-
 drivers/usb/gadget/ether.c                 |  148 +++-
 drivers/usb/gadget/file_storage.c          |   33 +-
 drivers/usb/gadget/gadget_chips.h          |    8 +
 drivers/usb/gadget/gmidi.c                 |    2 +-
 drivers/usb/gadget/goku_udc.c              |    2 +-
 drivers/usb/gadget/inode.c                 |  240 +++----
 drivers/usb/gadget/lh7a40x_udc.h           |    2 +-
 drivers/usb/gadget/net2280.c               |    2 +-
 drivers/usb/gadget/omap_udc.c              |    2 +-
 drivers/usb/gadget/pxa2xx_udc.c            |    2 +-
 drivers/usb/gadget/serial.c                |    2 +-
 drivers/usb/gadget/usbstring.c             |    2 +-
 drivers/usb/gadget/zero.c                  |    2 +-
 drivers/usb/host/Kconfig                   |   38 +-
 drivers/usb/host/ehci-dbg.c                |   24 +-
 drivers/usb/host/ehci-fsl.c                |    8 +-
 drivers/usb/host/ehci-hcd.c                |  127 ++-
 drivers/usb/host/ehci-hub.c                |  324 ++++++---
 drivers/usb/host/ehci-pci.c                |   38 +-
 drivers/usb/host/ehci-ps3.c                |  193 +++++
 drivers/usb/host/ehci-q.c                  |   16 +-
 drivers/usb/host/ehci-sched.c              |   22 +-
 drivers/usb/host/ehci.h                    |   46 ++-
 drivers/usb/host/ohci-at91.c               |   23 +-
 drivers/usb/host/ohci-au1xxx.c             |   16 -
 drivers/usb/host/ohci-ep93xx.c             |   12 -
 drivers/usb/host/ohci-hcd.c                |  128 +++-
 drivers/usb/host/ohci-lh7a404.c            |   16 -
 drivers/usb/host/ohci-omap.c               |   19 -
 drivers/usb/host/ohci-pci.c                |  219 ++++--
 drivers/usb/host/ohci-pnx4008.c            |   12 -
 drivers/usb/host/ohci-pnx8550.c            |   16 -
 drivers/usb/host/ohci-ppc-of.c             |  232 ++++++
 drivers/usb/host/ohci-ppc-soc.c            |   18 +-
 drivers/usb/host/ohci-ps3.c                |  196 +++++
 drivers/usb/host/ohci-pxa27x.c             |   16 -
 drivers/usb/host/ohci-s3c2410.c            |   12 -
 drivers/usb/host/ohci-sa1111.c             |   16 -
 drivers/usb/host/ohci.h                    |  155 +++--
 drivers/usb/host/uhci-debug.c              |   71 ++-
 drivers/usb/host/uhci-hcd.c                |   51 +-
 drivers/usb/host/uhci-hcd.h                |    8 +
 drivers/usb/host/uhci-q.c                  |  258 +++++--
 drivers/usb/image/mdc800.c                 |    4 +
 drivers/usb/input/Kconfig                  |   12 +
 drivers/usb/input/Makefile                 |    1 +
 drivers/usb/input/gtco.c                   | 1104 ++++++++++++++++++++++++++
 drivers/usb/input/hid-core.c               |   35 +
 drivers/usb/misc/idmouse.c                 |   10 +-
 drivers/usb/misc/rio500.c                  |   54 +-
 drivers/usb/mon/Makefile                   |    2 +-
 drivers/usb/mon/mon_bin.c                  | 1172 ++++++++++++++++++++++++++++
 drivers/usb/mon/mon_dma.c                  |   39 +-
 drivers/usb/mon/mon_main.c                 |   97 ++--
 drivers/usb/mon/mon_text.c                 |   67 ++-
 drivers/usb/mon/usb_mon.h                  |   30 +-
 drivers/usb/net/Kconfig                    |    6 +-
 drivers/usb/net/cdc_ether.c                |   60 ++-
 drivers/usb/net/kaweth.c                   |   37 +-
 drivers/usb/net/rndis_host.c               |   81 ++-
 drivers/usb/serial/aircable.c              |   21 +-
 drivers/usb/serial/airprime.c              |    1 +
 drivers/usb/serial/ark3116.c               |    2 +
 drivers/usb/serial/belkin_sa.c             |    1 +
 drivers/usb/serial/bus.c                   |   45 ++
 drivers/usb/serial/cp2101.c                |    1 +
 drivers/usb/serial/cyberjack.c             |    3 +-
 drivers/usb/serial/cypress_m8.c            |    3 +
 drivers/usb/serial/digi_acceleport.c       |    2 +
 drivers/usb/serial/empeg.c                 |    1 +
 drivers/usb/serial/ftdi_sio.c              |    2 +-
 drivers/usb/serial/ftdi_sio.h              |    1 -
 drivers/usb/serial/funsoft.c               |    1 +
 drivers/usb/serial/garmin_gps.c            |    1 +
 drivers/usb/serial/generic.c               |   35 +-
 drivers/usb/serial/hp4x.c                  |    1 +
 drivers/usb/serial/io_edgeport.c           |  417 ++++++++---
 drivers/usb/serial/io_edgeport.h           |    6 +-
 drivers/usb/serial/io_tables.h             |   61 ++
 drivers/usb/serial/io_ti.c                 |    2 +
 drivers/usb/serial/io_usbvend.h            |    5 +
 drivers/usb/serial/ipaq.c                  |    1 +
 drivers/usb/serial/ipw.c                   |    1 +
 drivers/usb/serial/ir-usb.c                |    1 +
 drivers/usb/serial/keyspan.c               |   49 ++-
 drivers/usb/serial/keyspan.h               |    7 +-
 drivers/usb/serial/keyspan_pda.c           |    3 +
 drivers/usb/serial/kl5kusb105.c            |    1 +
 drivers/usb/serial/kobil_sct.c             |    1 +
 drivers/usb/serial/mct_u232.c              |    1 +
 drivers/usb/serial/mos7720.c               |   16 +-
 drivers/usb/serial/mos7840.c               |   16 +-
 drivers/usb/serial/navman.c                |    1 +
 drivers/usb/serial/omninet.c               |    1 +
 drivers/usb/serial/option.c                |    1 +
 drivers/usb/serial/pl2303.c                |    1 +
 drivers/usb/serial/safe_serial.c           |    1 +
 drivers/usb/serial/sierra.c                |   29 +-
 drivers/usb/serial/ti_usb_3410_5052.c      |    2 +
 drivers/usb/serial/usb-serial.c            |  102 ++-
 drivers/usb/serial/visor.c                 |    6 +-
 drivers/usb/serial/visor.h                 |    1 -
 drivers/usb/serial/whiteheat.c             |    2 +
 drivers/usb/storage/onetouch.c             |    1 -
 drivers/usb/storage/scsiglue.c             |   31 +-
 drivers/usb/storage/unusual_devs.h         |    9 +-
 drivers/usb/storage/usb.c                  |   23 +-
 include/linux/Kbuild                       |    2 +-
 include/linux/hid.h                        |    1 +
 include/linux/usb.h                        |   34 +-
 include/linux/usb/Kbuild                   |    5 +
 include/linux/{usb_ch9.h => usb/ch9.h}     |    1 +
 include/linux/usb/serial.h                 |    5 +
 include/linux/usb_gadgetfs.h               |    2 +-
 139 files changed, 5820 insertions(+), 1563 deletions(-)
 create mode 100644 drivers/usb/host/ehci-ps3.c
 create mode 100644 drivers/usb/host/ohci-ppc-of.c
 create mode 100644 drivers/usb/host/ohci-ps3.c
 create mode 100644 drivers/usb/input/gtco.c
 create mode 100644 drivers/usb/mon/mon_bin.c
 create mode 100644 include/linux/usb/Kbuild
 rename include/linux/{usb_ch9.h => usb/ch9.h} (100%)

---------------

Alan Stern (12):
      usbcore: remove unneeded error check
      UHCI: improved debugging checks for the frame list
      UHCI: no dummy TDs for Iso QHs
      usb-storage: SCSI level fixes
      UHCI: fix bandwidth allocation
      usbcore: remove unused bandwith-related code
      EHCI: local variable for port status register
      EHCI: don't hide ports owned by the companion
      EHCI: force high-speed devices to run at full speed
      USB: gadgetfs AIO tweaks
      EHCI: fix interrupt-driven remote wakeup
      usb-storage: use first bulk endpoints, not last

Benjamin Herrenschmidt (6):
      USB: Rework the OHCI quirk mecanism as suggested by David
      USB: Implement support for "split" endian OHCI
      USB: Implement support for EHCI with big endian MMIO
      USB: Fix OHCI warning
      USB: Fix EHCI warning
      USB: ohci error handling cleanup

Dan Carpenter (1):
      USB: devio.c add missing INIT_LIST_HEAD()

David Brownell (10):
      USB: <linux/usb_ch9.h> becomes <linux/usb/ch9.h>
      USB: define USB_CLASS_MISC in <linux/usb/ch9.h>
      USB: indicate active altsetting in proc/bus/usb/devices file
      USB: ethernet gadget interop with MCCI Windows driver
      usb: gadgetfs whitespace cleanup
      USB: at91_udc wakeup event updates
      USB: gadgetfs cleanups
      USB: gadgetfs simplifications
      USB: gadgetfs race fix
      USB: gadgetfs behaves better on userspace init bug

Geoff Levand (3):
      USB: ps3 ehci bus glue
      USB: ps3 controller hid quirk
      USB: ps3 ohci bus glue

Greg Kroah-Hartman (9):
      USB: add EPIC support to the io_edgeport driver
      USB: move usb_device_class class devices to be real devices
      USB: convert usb class devices to real devices
      USB serial: add dynamic id support to usb-serial core
      USB: remove duplicate device id from visor
      USB: remove duplicate device id from ftdi_sio
      USB: remove duplicate device id from keyspan
      USB: remove duplicate device id from usb_storage
      USB: remove duplicate device id from zc0301

Håvard Skinnemoen (2):
      USB: list atmel husb2_udc gadget controller
      USB: usb ethernet gadget recognizes HUSB2DEV

Jeremy Roberson (1):
      USB Input: Added kernel module to support all GTCO CalComp USB InterWrite School products

Johannes HÃ¶lzl (2):
      USB serial: add driver pointer to all usb-serial drivers
      USB: Bugfix for aircable: Add module and name to usb_serial_driver

John Daiker (1):
      USB Gadget file_storage.c: remove unnecessary casts

Kevin Lloyd (1):
      USB: Sierra Wireless auto set D0

Luiz Fernando N. Capitulino (1):
      USB: unusual_devs.h for Sony floppy

Marc Pignat (1):
      USB: ohci-at91 refcount fix for irq wake enables

Marcelo Tosatti (1):
      USB: switch ehci-hcd to new polling scheme

Ole Andre Vadla Ravnas (1):
      rndis_host learns ActiveSync basics

Oliver Neukum (11):
      USB: mutexification of rio500
      USB: race on disconnect in mdc800
      USB: power management for kaweth
      USB: better ethtool support for kaweth
      USB: total removal of multithreaded probing in usb
      USB: race fixes for usb-serial step 1
      USB: race fixes for usb-serial, step 2
      USB: race fixes for usb-serial, step 3
      USB: autosuspend for usb printer driver
      usbcore: trivial whitespace fixes
      USB: a bit more coding style cleanup

Pete Zaitcev (1):
      USB: add binary API to usbmon

Phil Endecott (1):
      usb: gadgetfs remove delayed init mode

Rainer Weikusat (1):
      fix for bugzilla #7544 (keyspan USB-to-serial converter)

Sarah Bailey (1):
      USB: Add usb_endpoint_xfer_control to usb.h

Sylvain Munaut (2):
      ohci: Rework bus glue integration to allow several at once
      ohci: Add support for OHCI controller on the of_platform bus

Tobias Klauser (1):
      USB: Remove unneeded void * casts in idmouse.c


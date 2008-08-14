Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYHNArn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYHNArn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYHNAre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:47:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:47869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYHNArd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:47:33 -0400
Date: Wed, 13 Aug 2008 17:44:12 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.27-rc3
Message-ID: <20080814004412.GA17255@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.26-git tree.

The majority of this patch is removing an old driver (auerswald), and
adding a new one (musb, an USB embedded host/device combo on ARM
systems).  musb is totally self-contained, so that causes no problems
with any other patches.

The majority of the other changes are new device ids and bugfixes.

Note, a new file got added for the sierra devices for their wierd
usb-storage-type devices, but that too is self-contained and affects no
one else.

Oh, there are some reworks in the gadget drivers, but they too are
self-contained and seem pretty essential for users of those drivers.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
the -next releases for a few weeks.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/devices.txt              |    3 -
 Documentation/ioctl-number.txt         |    1 -
 Documentation/usb/auerswald.txt        |   30 -
 Documentation/usb/power-management.txt |    7 +-
 MAINTAINERS                            |   12 +-
 arch/arm/mach-omap2/usb-tusb6010.c     |    1 -
 drivers/Makefile                       |    1 +
 drivers/i2c/chips/isp1301_omap.c       |    2 +-
 drivers/usb/Kconfig                    |    6 +-
 drivers/usb/atm/cxacru.c               |    2 +-
 drivers/usb/class/cdc-acm.c            |   86 +-
 drivers/usb/class/cdc-acm.h            |    3 +-
 drivers/usb/core/driver.c              |    5 +-
 drivers/usb/core/message.c             |    2 +-
 drivers/usb/gadget/Kconfig             |   10 +
 drivers/usb/gadget/dummy_hcd.c         |    5 +-
 drivers/usb/gadget/f_acm.c             |  196 +++-
 drivers/usb/gadget/f_ecm.c             |    2 -
 drivers/usb/gadget/f_rndis.c           |    2 -
 drivers/usb/gadget/f_serial.c          |    2 -
 drivers/usb/gadget/f_subset.c          |    2 -
 drivers/usb/gadget/gadget_chips.h      |    6 +
 drivers/usb/gadget/omap_udc.c          |    5 +-
 drivers/usb/gadget/u_serial.c          |  290 +++--
 drivers/usb/gadget/u_serial.h          |   12 +-
 drivers/usb/host/isp1760-hcd.c         |   53 +-
 drivers/usb/host/isp1760-hcd.h         |    5 +
 drivers/usb/host/ohci-hcd.c            |   23 +-
 drivers/usb/host/ohci-hub.c            |   11 +-
 drivers/usb/host/ohci-omap.c           |    3 +-
 drivers/usb/host/ohci-pci.c            |  132 ++
 drivers/usb/host/ohci-q.c              |    6 +
 drivers/usb/host/ohci.h                |   11 +
 drivers/usb/host/r8a66597-hcd.c        |   49 +-
 drivers/usb/misc/Kconfig               |   10 -
 drivers/usb/misc/Makefile              |    1 -
 drivers/usb/misc/auerswald.c           | 2152 ------------------------------
 drivers/usb/musb/Kconfig               |  176 +++
 drivers/usb/musb/Makefile              |   86 ++
 drivers/usb/musb/cppi_dma.c            | 1540 ++++++++++++++++++++++
 drivers/usb/musb/cppi_dma.h            |  133 ++
 drivers/usb/musb/davinci.c             |  462 +++++++
 drivers/usb/musb/davinci.h             |  100 ++
 drivers/usb/musb/musb_core.c           | 2261 ++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.h           |  507 +++++++
 drivers/usb/musb/musb_debug.h          |   66 +
 drivers/usb/musb/musb_dma.h            |  172 +++
 drivers/usb/musb/musb_gadget.c         | 2031 ++++++++++++++++++++++++++++
 drivers/usb/musb/musb_gadget.h         |  108 ++
 drivers/usb/musb/musb_gadget_ep0.c     |  981 ++++++++++++++
 drivers/usb/musb/musb_host.c           | 2170 ++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_host.h           |  110 ++
 drivers/usb/musb/musb_io.h             |  115 ++
 drivers/usb/musb/musb_procfs.c         |  830 ++++++++++++
 drivers/usb/musb/musb_regs.h           |  300 +++++
 drivers/usb/musb/musb_virthub.c        |  425 ++++++
 drivers/usb/musb/musbhsdma.c           |  433 ++++++
 drivers/usb/musb/omap2430.c            |  324 +++++
 drivers/usb/musb/omap2430.h            |   56 +
 drivers/usb/musb/tusb6010.c            | 1151 ++++++++++++++++
 drivers/usb/musb/tusb6010.h            |  233 ++++
 drivers/usb/musb/tusb6010_omap.c       |  719 ++++++++++
 drivers/usb/serial/Kconfig             |    7 +-
 drivers/usb/serial/ftdi_sio.c          |    6 +
 drivers/usb/serial/ftdi_sio.h          |    7 +
 drivers/usb/serial/option.c            |   44 +-
 drivers/usb/serial/pl2303.c            |    1 -
 drivers/usb/serial/pl2303.h            |    4 -
 drivers/usb/serial/sierra.c            |  170 ++--
 drivers/usb/serial/usb-serial.c        |    7 +-
 drivers/usb/storage/Kconfig            |   12 +
 drivers/usb/storage/Makefile           |    1 +
 drivers/usb/storage/sierra_ms.c        |  207 +++
 drivers/usb/storage/sierra_ms.h        |    4 +
 drivers/usb/storage/transport.c        |   17 +-
 drivers/usb/storage/unusual_devs.h     |   40 +-
 drivers/usb/storage/usb.c              |    3 +
 include/linux/usb.h                    |    2 +
 include/linux/usb/musb.h               |   98 ++
 include/linux/usb/serial.h             |    3 +-
 80 files changed, 16723 insertions(+), 2548 deletions(-)
 delete mode 100644 Documentation/usb/auerswald.txt
 delete mode 100644 drivers/usb/misc/auerswald.c
 create mode 100644 drivers/usb/musb/Kconfig
 create mode 100644 drivers/usb/musb/Makefile
 create mode 100644 drivers/usb/musb/cppi_dma.c
 create mode 100644 drivers/usb/musb/cppi_dma.h
 create mode 100644 drivers/usb/musb/davinci.c
 create mode 100644 drivers/usb/musb/davinci.h
 create mode 100644 drivers/usb/musb/musb_core.c
 create mode 100644 drivers/usb/musb/musb_core.h
 create mode 100644 drivers/usb/musb/musb_debug.h
 create mode 100644 drivers/usb/musb/musb_dma.h
 create mode 100644 drivers/usb/musb/musb_gadget.c
 create mode 100644 drivers/usb/musb/musb_gadget.h
 create mode 100644 drivers/usb/musb/musb_gadget_ep0.c
 create mode 100644 drivers/usb/musb/musb_host.c
 create mode 100644 drivers/usb/musb/musb_host.h
 create mode 100644 drivers/usb/musb/musb_io.h
 create mode 100644 drivers/usb/musb/musb_procfs.c
 create mode 100644 drivers/usb/musb/musb_regs.h
 create mode 100644 drivers/usb/musb/musb_virthub.c
 create mode 100644 drivers/usb/musb/musbhsdma.c
 create mode 100644 drivers/usb/musb/omap2430.c
 create mode 100644 drivers/usb/musb/omap2430.h
 create mode 100644 drivers/usb/musb/tusb6010.c
 create mode 100644 drivers/usb/musb/tusb6010.h
 create mode 100644 drivers/usb/musb/tusb6010_omap.c
 create mode 100644 drivers/usb/storage/sierra_ms.c
 create mode 100644 drivers/usb/storage/sierra_ms.h
 create mode 100644 include/linux/usb/musb.h

---------------

Alan Stern (8):
      USB: add missing kerneldoc line for "needs_binding"
      USB: OHCI: fix system hang caused by earlier patch
      usb-serial: don't release unregistered minors
      USB: fix interface unregistration logic
      usb-storage: automatically recognize bad residues
      usb-storage: unusual_devs entries for iRiver T10 and Datafab CF+SM reader
      usb-storage: unusual_devs entry for Nokia 5300
      USB: fix compiler warning fix

Alexander Beregalov (1):
      usb/core/driver: fix warning

André Schenk (1):
      USB: ftdi_sio: Add USB Product Id for ELV HS485

Dave Jones (1):
      USB: usb-storage: quirk around v1.11 firmware on Nikon D4

David Brownell (7):
      USB: fix USB boot crash, ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
      USB: serial gadget: rx path data loss fixes
      usb gadget: remove needless struct members
      usb gadget: issue notifications from ACM function
      usb: cdc-acm: bugfix release()
      usb: cdc-acm: stop dropping tx buffers
      usb: cdc-acm: drain writes on close

Dmitry Baryshkov (4):
      USB: ohci: make distrust_firmware a quirk
      USB: Hook start_hnp into ohci struct
      USB: isp1301: fix compilation
      USB: omap_udc: fix compilation with debug enabled

Enrico Scholz (1):
      usb: ISP1760: improve pre-fetch timing

Felipe Balbi (4):
      usb: gadget: protect gadget_chips.h from been included twice
      USB: Add MUSB and TUSB support
      usb: musb: fix hanging when rmmod gadget driver
      usb: musb: pass configuration specifics via pdata

Frederik Kriewitz (1):
      USB: ftdi_sio: add support for Luminance Stellaris Evaluation/Development Kits

Greg Kroah-Hartman (1):
      USB: serial: remove CONFIG_USB_DEBUG from sierra and option drivers

Jost Diederichs (1):
      USB: usb-storage Motorola Phone Razr v3xx US_FL_FIX_CAPACITY patch

Kevin Lloyd (4):
      USB Serial Sierra: clean-up
      USB Serial Sierra: Dynamic interface detection
      USB Serial Sierra: TRU-Install feature update
      USB Storage Sierra: TRU-Install feature update

Leon Leong (1):
      USB: BandRich BandLuxe C150/C250 HSPA Data Card Driver

Lex Ross (1):
      USB: ftdi_sio: add support for PHI Fisco data cable (FT232BM based, VID/PID 0403:e40b)

Libin Yang (1):
      USB: quirk PLL power down mode

Oliver Martin (1):
      USB: Add vendor/product id of ZTE MF628 to option

Oliver Neukum (1):
      USB: update to Documentation

Sebastian Siewior (2):
      usb: return error code instead of 0 in the enqueue function.
      usb: isp1760: don't be noisy about short packets.

Simon Arlott (2):
      USB: Move usb/mon/ up to misc options in Kconfig
      USB: cxacru: Fix printk format flag in error message

Takashi Iwai (1):
      USB: cdc-acm.c: Fix compile warnings

Tollef Fog Heen (1):
      USB: pl2023: Remove USB id (4348:5523) handled by ch341

Wolfgang Mües (1):
      usb: auerswald: remove driver (obsolete)

Yoshihiro Shimoda (1):
      USB: sh: r8a66597-hcd: fix disconnect regression


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbXGLXnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbXGLXnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXGLXnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:43:04 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53606 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXGLXnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:43:01 -0400
Date: Thu, 12 Jul 2007 16:42:33 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.22
Message-ID: <20070712234233.GA22339@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of USB patches and fixes against your 2.6.22 git tree.

They include a number of new drivers, some cleanups in anticipation of
future API changes, new infrastructure to make writing USB drivers
easier, and a lot of USB suspend work.  There are a lot of minor little
things in here too, see the changelog below for everything.

All of these have been in the -mm releases for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/ABI/testing/sysfs-bus-usb          |   13 +
 Documentation/power/swsusp.txt                   |    3 +
 Documentation/usb/dma.txt                        |   52 +-
 Documentation/usb/persist.txt                    |  156 ++
 MAINTAINERS                                      |    8 +-
 drivers/block/ub.c                               |   12 +-
 drivers/hid/usbhid/hid-core.c                    |    9 +-
 drivers/usb/Kconfig                              |    9 +-
 drivers/usb/Makefile                             |    2 +-
 drivers/usb/atm/cxacru.c                         |   73 +-
 drivers/usb/class/cdc-acm.c                      |    3 +
 drivers/usb/class/usblp.c                        |  618 ++++---
 drivers/usb/core/Kconfig                         |   25 +
 drivers/usb/core/config.c                        |   42 +-
 drivers/usb/core/devices.c                       |   26 +
 drivers/usb/core/driver.c                        |  162 +-
 drivers/usb/core/file.c                          |   29 +-
 drivers/usb/core/generic.c                       |   29 +-
 drivers/usb/core/hcd-pci.c                       |    3 +-
 drivers/usb/core/hcd.c                           |  126 +-
 drivers/usb/core/hcd.h                           |   14 +-
 drivers/usb/core/hub.c                           |  645 +++----
 drivers/usb/core/message.c                       |   38 +-
 drivers/usb/core/quirks.c                        |   18 +
 drivers/usb/core/sysfs.c                         |  109 +-
 drivers/usb/core/urb.c                           |  105 +-
 drivers/usb/core/usb.c                           |   12 +-
 drivers/usb/core/usb.h                           |   14 +-
 drivers/usb/gadget/Kconfig                       |   53 +
 drivers/usb/gadget/Makefile                      |    6 +
 drivers/usb/gadget/at91_udc.c                    |   21 -
 drivers/usb/gadget/dummy_hcd.c                   |   39 +-
 drivers/usb/gadget/ether.c                       |    8 +-
 drivers/usb/gadget/file_storage.c                |   22 +-
 drivers/usb/gadget/fsl_usb2_udc.c                |   99 +-
 drivers/usb/gadget/fsl_usb2_udc.h                |    4 +
 drivers/usb/gadget/gadget_chips.h                |   27 +-
 drivers/usb/gadget/gmidi.c                       |    8 +-
 drivers/usb/gadget/goku_udc.c                    |   84 +-
 drivers/usb/gadget/goku_udc.h                    |   10 +-
 drivers/usb/gadget/inode.c                       |    8 +-
 drivers/usb/gadget/lh7a40x_udc.c                 |   27 -
 drivers/usb/gadget/m66592-udc.c                  | 1653 ++++++++++++++++
 drivers/usb/gadget/m66592-udc.h                  |  577 ++++++
 drivers/usb/gadget/net2280.c                     |   97 -
 drivers/usb/gadget/omap_udc.c                    |  108 --
 drivers/usb/gadget/pxa2xx_udc.c                  |  473 +----
 drivers/usb/gadget/pxa2xx_udc.h                  |   48 +-
 drivers/usb/gadget/rndis.c                       |  164 +-
 drivers/usb/gadget/s3c2410_udc.c                 | 2045 ++++++++++++++++++++
 drivers/usb/gadget/s3c2410_udc.h                 |  110 ++
 drivers/usb/gadget/serial.c                      |   14 +-
 drivers/usb/gadget/zero.c                        |    9 +-
 drivers/usb/host/Kconfig                         |   28 +-
 drivers/usb/host/Makefile                        |    2 +
 drivers/usb/host/ehci-dbg.c                      |  183 +-
 drivers/usb/host/ehci-fsl.c                      |   10 +-
 drivers/usb/host/ehci-hcd.c                      |  118 +-
 drivers/usb/host/ehci-hub.c                      |  122 ++-
 drivers/usb/host/ehci-mem.c                      |   27 +-
 drivers/usb/host/ehci-pci.c                      |    7 +-
 drivers/usb/host/ehci-ppc-soc.c                  |  182 ++
 drivers/usb/host/ehci-ps3.c                      |   86 +-
 drivers/usb/host/ehci-q.c                        |   96 +-
 drivers/usb/host/ehci-sched.c                    |  339 +++-
 drivers/usb/host/ehci.h                          |  234 ++-
 drivers/usb/host/ohci-dbg.c                      |    4 +-
 drivers/usb/host/ohci-hcd.c                      |   92 +-
 drivers/usb/host/ohci-hub.c                      |    5 +-
 drivers/usb/host/ohci-mem.c                      |    1 +
 drivers/usb/host/ohci-pci.c                      |   57 +-
 drivers/usb/host/ohci-pnx4008.c                  |    2 +-
 drivers/usb/host/ohci-ps3.c                      |   87 +-
 drivers/usb/host/ohci.h                          |    2 +
 drivers/usb/host/r8a66597-hcd.c                  | 2244 ++++++++++++++++++++++
 drivers/usb/host/r8a66597.h                      |  634 ++++++
 drivers/usb/host/uhci-hcd.c                      |    5 +-
 drivers/usb/misc/adutux.c                        |   31 +-
 drivers/usb/misc/auerswald.c                     |    6 +-
 drivers/usb/misc/berry_charge.c                  |   35 +
 drivers/usb/misc/idmouse.c                       |   54 +-
 drivers/usb/misc/iowarrior.c                     |   26 +-
 drivers/usb/misc/ldusb.c                         |   33 +-
 drivers/usb/misc/legousbtower.c                  |   24 +-
 drivers/usb/misc/sisusbvga/sisusb.c              |   38 +-
 drivers/usb/misc/sisusbvga/sisusb_con.c          |   25 +-
 drivers/usb/misc/sisusbvga/sisusb_init.h         |    2 -
 drivers/usb/misc/usblcd.c                        |   67 +-
 drivers/usb/mon/mon_bin.c                        |   34 +-
 drivers/usb/mon/mon_main.c                       |   14 +-
 drivers/usb/mon/mon_text.c                       |   29 +-
 drivers/usb/mon/usb_mon.h                        |    7 +-
 drivers/usb/serial/Kconfig                       |   10 +
 drivers/usb/serial/Makefile                      |    1 +
 drivers/usb/serial/aircable.c                    |   16 +-
 drivers/usb/serial/airprime.c                    |   10 +-
 drivers/usb/serial/ark3116.c                     |   61 +-
 drivers/usb/serial/belkin_sa.c                   |   78 +-
 drivers/usb/serial/cyberjack.c                   |   17 +-
 drivers/usb/serial/cypress_m8.c                  |   18 +-
 drivers/usb/serial/digi_acceleport.c             |   99 +-
 drivers/usb/serial/empeg.c                       |   14 +-
 drivers/usb/serial/ftdi_sio.c                    |  119 +-
 drivers/usb/serial/garmin_gps.c                  |   47 +-
 drivers/usb/serial/generic.c                     |   97 +-
 drivers/usb/serial/io_edgeport.c                 |   40 +-
 drivers/usb/serial/io_fw_down3.h                 | 1460 +++++++-------
 drivers/usb/serial/io_ti.c                       |  124 +-
 drivers/usb/serial/io_usbvend.h                  |   12 +-
 drivers/usb/serial/ipaq.c                        |   14 +-
 drivers/usb/serial/ipw.c                         |   12 +-
 drivers/usb/serial/ir-usb.c                      |  154 +-
 drivers/usb/serial/keyspan.c                     |  456 ++++-
 drivers/usb/serial/keyspan.h                     |   74 +-
 drivers/usb/serial/keyspan_pda.c                 |   17 +-
 drivers/usb/serial/keyspan_usa67msg.h            |  254 +++
 drivers/usb/serial/kl5kusb105.c                  |   22 +-
 drivers/usb/serial/kobil_sct.c                   |   26 +-
 drivers/usb/serial/mct_u232.c                    |  149 ++-
 drivers/usb/serial/mct_u232.h                    |   15 +-
 drivers/usb/serial/mos7720.c                     |   43 +-
 drivers/usb/serial/mos7840.c                     |  106 +-
 drivers/usb/serial/navman.c                      |    7 +-
 drivers/usb/serial/omninet.c                     |   20 +-
 drivers/usb/serial/option.c                      |   34 +-
 drivers/usb/serial/oti6858.c                     | 1342 +++++++++++++
 drivers/usb/serial/oti6858.h                     |   15 +
 drivers/usb/serial/pl2303.c                      |   90 +-
 drivers/usb/serial/safe_serial.c                 |    6 +-
 drivers/usb/serial/sierra.c                      |  371 ++--
 drivers/usb/serial/ti_usb_3410_5052.c            |   46 +-
 drivers/usb/serial/usb-serial.c                  |   35 +-
 drivers/usb/serial/visor.c                       |   64 +-
 drivers/usb/serial/whiteheat.c                   |  122 +-
 drivers/usb/storage/scsiglue.c                   |   21 +-
 drivers/usb/storage/unusual_devs.h               |  188 +-
 drivers/usb/storage/usb.c                        |   91 +-
 drivers/usb/storage/usb.h                        |    1 +
 drivers/usb/usb-skeleton.c                       |  151 ++-
 include/asm-arm/arch-ixp4xx/udc.h                |   22 -
 include/asm-arm/arch-pxa/udc.h                   |   33 -
 include/linux/usb.h                              |   69 +-
 include/linux/usb/Kbuild                         |    1 +
 include/linux/{usb_gadgetfs.h => usb/gadgetfs.h} |   24 +-
 include/linux/usb/quirks.h                       |    3 +
 include/linux/usb/serial.h                       |    7 +
 include/linux/usb_gadget.h                       |   48 -
 147 files changed, 14872 insertions(+), 4565 deletions(-)
 create mode 100644 Documentation/usb/persist.txt
 create mode 100644 drivers/usb/gadget/m66592-udc.c
 create mode 100644 drivers/usb/gadget/m66592-udc.h
 create mode 100644 drivers/usb/gadget/s3c2410_udc.c
 create mode 100644 drivers/usb/gadget/s3c2410_udc.h
 create mode 100644 drivers/usb/host/ehci-ppc-soc.c
 create mode 100644 drivers/usb/host/r8a66597-hcd.c
 create mode 100644 drivers/usb/host/r8a66597.h
 create mode 100644 drivers/usb/serial/keyspan_usa67msg.h
 create mode 100644 drivers/usb/serial/oti6858.c
 create mode 100644 drivers/usb/serial/oti6858.h
 rename include/linux/{usb_gadgetfs.h => usb/gadgetfs.h} (74%)

---------------

Al Borchers (1):
      USB: digi_acceleport further buffer clean up

Alan Cox (8):
      USB: serial: ark3116.c: Mixed fixups
      USB: serial: belkin_sa: Various needed fixes
      USB: serial: ir_usb: Clean up the worst of it, remove exciting 'crash on open' feature
      USB: mos7840.c: turn this into a serial driver
      USB: pl2303: remove bogus checks and fix speed support to use tty_get_baud_rate()
      USB: visor and whiteheat: remove bogus termios change checks
      USB: mos7720: remove bogus no termios change check
      USB: io_*: remove bogus termios no change checks

Alan Stern (27):
      USB: interface PM state
      USB: Implement PM FREEZE and PRETHAW
      USB: move bus_suspend and bus_resume method calls
      USB: don't unsuspend for a new connection
      USB: remove references to dev.power.power_state
      USB: remove "locktree" routine from the hub driver
      USB: make hub driver's release more robust
      USB: add USB-Persist facility
      USB: EHCI, OHCI: handover changes
      USB: add RESET_RESUME device quirk
      USB: EHCI: fix handover for designated full-speed ports
      USB: Make device reset stop retrying after disconnect
      USB: prevent char device open/deregister race
      USB: rework C++-style comments
      USB: remove __usb_port_suspend
      USB: separate root and non-root suspend/resume
      USB: remove excess code from hub.c
      USB: add reset_resume method
      USB: unify reset_resume and normal resume
      USB: add power/persist device attribute
      USB: option: fix usage of urb->status abuse
      USB: usb-storage: use kthread_stop() for the control thread
      USB: Handle bogus low-speed Bulk endpoints
      USB: Remove usages of dev->power.power_state
      USB: Don't resume root hub if the controller is suspended
      USB: Fix off-by-1 error in the scatter-gather library
      usb-storage: implement autosuspend

Andrey Arapov (1):
      USB: cdc-acm: add new device id to option driver

Arjan van de Ven (1):
      USB: Patch to align the various USB timers to fire at the same time

Arnaud Patard (1):
      USB Gadget driver for Samsung s3c2410 ARM SoC

Benny Halevy (1):
      synchronization in usb_serial_put

Christian Engelmayer (1):
      ehci-hub: improved over-current recovery

Craig W. Nadler (1):
      USB: add IAD support to usbfs and sysfs

Daniel Drake (1):
      USB: add USB_DEVICE_AND_INTERFACE_INFO for device matching

Dave Platt (1):
      USB: RTS/CTS handshaking support, DTR fixes for MCT U232 serial adapter

David Brownell (11):
      USB: ehci refcounts work on ppc7448
      USB: usb gadget, dead config cleanup
      USB: export <linux/usb_gadgetfs> as <linux/usb/gadgetfs.h>
      USB: usb serial gadget, sparse fixes
      USB: usb host side can be configured given PCMCIA
      USB: usb/dma doc updates
      USB: pxa2xx_udc -- cleanups, mostly removing dma hooks
      usb gadget stack: remove usb_ep_*_buffer(), part 1
      usb gadget stack: remove usb_ep_*_buffer(), part 2
      USB: usb gadget stack can now -DDEBUG with Kconfig
      USB: goku_udc trivial cleanups

David Rientjes (1):
      USB: use function attribute __maybe_unused

Geoff Levand (1):
      USB: PS3: USB system-bus rework

Greg Kroah-Hartman (36):
      USB: fix up license wording on some of my usb-serial drivers
      USB: serial: aircable: clean up urb->status usage
      USB: serial: airprime: clean up urb->status usage
      USB: serial: belkin_sa: clean up urb->status usage
      USB: serial: cyberjack: clean up urb->status usage
      USB: serial: cypress_m8: clean up urb->status usage
      USB: serial: digi_acceleport: clean up urb->status usage
      USB: serial: empeg: clean up urb->status usage
      USB: serial: ftdi_sio: clean up urb->status usage
      USB: serial: garmin_gps: clean up urb->status usage
      USB: serial: generic: clean up urb->status usage
      USB: serial: io_edgeport: clean up urb->status usage
      USB: serial: io_ti: clean up urb->status usage
      USB: serial: ipaq: clean up urb->status usage
      USB: serial: ipw: clean up urb->status usage
      USB: serial: ir-usb: clean up urb->status usage
      USB: serial: keyspan: clean up urb->status usage
      USB: serial: keyspan_pda: clean up urb->status usage
      USB: serial: kl5kusb105: clean up urb->status usage
      USB: serial: kobil_sct: clean up urb->status usage
      USB: serial: mct_u232: clean up urb->status usage
      USB: serial: mos7720: clean up urb->status usage
      USB: serial: mos7840: clean up urb->status usage
      USB: serial: navman: clean up urb->status usage
      USB: serial: omninet: clean up urb->status usage
      USB: serial: option: clean up urb->status usage
      USB: serial: oti6858: clean up urb->status usage
      USB: serial: pl2303: clean up urb->status usage
      USB: serial: safe_serial: clean up urb->status usage
      USB: serial: sierra: clean up urb->status usage
      USB: serial: ti_usb_3410_5052: clean up urb->status usage
      USB: serial: visor: clean up urb->status usage
      USB: serial: whiteheat: clean up urb->status usage
      USB: sierra: remove incorrect usage of the urb status field
      USB: sierra: cleanup the startup and shutdown path
      USB: mos7720: change developer email addresses

Haavard Skinnemoen (1):
      usb gadget: Rename husb2dev -> usba

Jan Engelhardt (2):
      USB: Use menuconfig objects
      USB: fix gregkh-usb-usb-use-menuconfig-objects

Jeremy Katz (2):
      USB: Support Blackberry Pearl with berry_charge
      USB: Don't autosuspend Blackberry devices.

Kees Lemmens (1):
      USB: oti6858 usb-serial driver (in Nokia CA-42 cable)

Laurent Pinchart (1):
      USB: Fix up full-speed bInterval values in high-speed interrupt descriptor

Li Yang (4):
      USB: ehci_fsl update for MPC831x support
      USB: fsl_usb2_udc: replace deprecated irq flag
      USB: fsl_usb2_udc: Get max ep number from DCCPARAMS register
      USB: fsl_usb2_udc: fix bug for portsc bit masking

Lucy McCoy (1):
      USB Serial Keyspan: add support for USA-49WG & USA-28XG

Marcel Holtmann (1):
      USB: Add URB_FREE_BUFFER flag and the logic behind it

Mark Lord (1):
      USB: hub.c loops forever on resume from ram due to bluetooth

Martin K. Petersen (1):
      USB: io_ti: Digi EdgePort update for new devices

Matthias Kaehlcke (1):
      USB: drivers/block/ub.c: use list_for_each_entry()

Michael Hanselmann (1):
      USB: Fix NEC OHCI chip silicon bug

Milan Svoboda (1):
      USB: pxa2xx_udc: use generic gpio layer

Oliver Neukum (15):
      USB: suspend support for usb serial
      USB: visor driver adapted to new tty buffering
      USB: Digi AccelePort adapted to new tty buffering
      USB: generic usb serial to new buffering scheme
      USB: introduce usb_anchor
      USB: usb-skeleton: usb anchor to implement flush
      USB: whiteheat driver update
      USB: io_ti: sleep with spinlock held detected by automatic tool
      USB: usb-skeleton: use anchors in disconnect handling
      USB: usb-skeleton" use anchors in suspend/resume handling
      USB: usb-skeleton: use anchors in pre/post reset
      USB: autosuspend for usblcd
      USB: ftdi_sio: fix oops due to processing workarounds too early
      USB: quirk for samsung printer
      USB: additions to the quirk list

Pete Zaitcev (4):
      usbmon: Add class for binary interface
      usb: free DMA mappings if enqueue fails
      USB: Pete's taking over usblp
      USB: usblp: add dynamic URBs, fix races

Robert P. J. Day (1):
      USB: remove Makefile reference to obsolete OHCI_AT91

S.Caglar Onur (1):
      USB: drivers/usb/storage/unusual_devs.h whitespace cleanup

Simon Arlott (1):
      USB: cxacru: Cleanup sysfs attribute code

Stefan Roese (3):
      USB: EHCI support for big-endian descriptors
      USB: EHCI big endian data structures support (for 440EPx)
      USB: Set CONFIG_USB_EHCI_BIG_ENDIAN_MMIO/_DESC in usb/host/Kconfig

Stepan Moskovchenko (1):
      USB: ftdi_sio.c: Allow setting latency timer on FT232RL

Stuart_Hayes@Dell.com (1):
      USB: EHCI cpufreq fix

Suresh Jayaraman (1):
      USB: ohci-pnx4008: Remove unnecessary cast of return value of kzalloc

Tony Lindgren (1):
      USB: Disable file_storage USB_CONFIG_ATT_WAKEUP

Venki Pallipadi (1):
      USB: Make usb-autosuspend timer 1 sec jiffy aligned

Vikram Pandita (1):
      USB Core: hub.c: prevent re-enumeration on HNP

Vladimir Barinov (1):
      USB: EHCI: Safe endianness for transfer buffers after reset in case of HUB with TT

Yinghai Lu (1):
      USB: make the usb_device numa_node get assigned from controller

Yoshihiro Shimoda (4):
      USB: m66592-udc: peripheral controller driver for M66592
      USB: m66592-udc: fix use old interrupt flags
      USB: r8a66597-hcd: host controller driver for R8A66597
      USB: r8a66597-hcd: fix NULL access

t.sefzick (1):
      USB: flow control fix for pl2303


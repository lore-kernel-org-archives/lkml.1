Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZAGT0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZAGT0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZAGTZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:25:50 -0500
Received: from kroah.org ([198.145.64.141]:38008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbZAGTZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:25:47 -0500
Date: Wed, 7 Jan 2009 11:24:38 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090107192438.GA18146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the set of USB patches for the 2.6.29-rc1 merge.

They also include the wimax patches, because of a dependancy on a change
in the USB core to support one of the wimax drivers.  The wimax patch
set has been acked by the network maintainers already, and they agreed
that it should go through the USB tree to you.

Other than wimax, the patchset includes:
	- some new USB drivers (gadget, host, and serial)
	- USB OTG (on-the-go) device support
	- lots of device id updates
	- renaming in the i2c drivers to move into the proper location
	  in the usb tree
	- usb-storage quirk handling cleaned up and reworked
	- sped up the option wireless usb driver speed.
	- removal of info() and warn() usb macros now that the non-usb
	  portions of the kernel have removed their usage of them.
	- lots of minor tweaks and reworks.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 CREDITS                                       |   17 +
 Documentation/DocBook/networking.tmpl         |    8 +
 Documentation/kernel-parameters.txt           |   36 +
 Documentation/usb/power-management.txt        |   22 +-
 Documentation/wimax/README.i2400m             |  260 ++
 Documentation/wimax/README.wimax              |   81 +
 MAINTAINERS                                   |   17 +
 arch/arm/plat-mxc/include/mach/usb.h          |   23 +
 arch/arm/plat-omap/usb.c                      |   32 -
 arch/powerpc/boot/dts/sequoia.dts             |    2 +-
 drivers/Makefile                              |    1 +
 drivers/block/ub.c                            |   11 +-
 drivers/hid/usbhid/hid-core.c                 |    9 +-
 drivers/i2c/chips/Kconfig                     |   12 -
 drivers/i2c/chips/Makefile                    |    1 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    2 +-
 drivers/net/Kconfig                           |    2 +
 drivers/net/Makefile                          |    1 +
 drivers/net/usb/kaweth.c                      |    6 +-
 drivers/net/usb/pegasus.c                     |   12 +-
 drivers/net/wimax/Kconfig                     |   17 +
 drivers/net/wimax/Makefile                    |    5 +
 drivers/net/wimax/i2400m/Kconfig              |   49 +
 drivers/net/wimax/i2400m/Makefile             |   29 +
 drivers/net/wimax/i2400m/control.c            | 1291 ++++++++
 drivers/net/wimax/i2400m/debug-levels.h       |   45 +
 drivers/net/wimax/i2400m/debugfs.c            |  392 +++
 drivers/net/wimax/i2400m/driver.c             |  728 +++++
 drivers/net/wimax/i2400m/fw.c                 | 1095 +++++++
 drivers/net/wimax/i2400m/i2400m-sdio.h        |  132 +
 drivers/net/wimax/i2400m/i2400m-usb.h         |  264 ++
 drivers/net/wimax/i2400m/i2400m.h             |  755 +++++
 drivers/net/wimax/i2400m/netdev.c             |  524 ++++
 drivers/net/wimax/i2400m/op-rfkill.c          |  207 ++
 drivers/net/wimax/i2400m/rx.c                 |  534 ++++
 drivers/net/wimax/i2400m/sdio-debug-levels.h  |   22 +
 drivers/net/wimax/i2400m/sdio-fw.c            |  224 ++
 drivers/net/wimax/i2400m/sdio-rx.c            |  255 ++
 drivers/net/wimax/i2400m/sdio-tx.c            |  153 +
 drivers/net/wimax/i2400m/sdio.c               |  511 ++++
 drivers/net/wimax/i2400m/tx.c                 |  817 +++++
 drivers/net/wimax/i2400m/usb-debug-levels.h   |   42 +
 drivers/net/wimax/i2400m/usb-fw.c             |  340 +++
 drivers/net/wimax/i2400m/usb-notif.c          |  269 ++
 drivers/net/wimax/i2400m/usb-rx.c             |  417 +++
 drivers/net/wimax/i2400m/usb-tx.c             |  229 ++
 drivers/net/wimax/i2400m/usb.c                |  591 ++++
 drivers/usb/Kconfig                           |    2 +
 drivers/usb/class/cdc-acm.c                   |    2 +-
 drivers/usb/class/cdc-wdm.c                   |    3 +-
 drivers/usb/class/usbtmc.c                    |    9 +-
 drivers/usb/core/devio.c                      |    7 +-
 drivers/usb/core/driver.c                     |  181 +-
 drivers/usb/core/endpoint.c                   |    4 +-
 drivers/usb/core/generic.c                    |   10 +-
 drivers/usb/core/hcd-pci.c                    |  201 +-
 drivers/usb/core/hcd.c                        |   20 +-
 drivers/usb/core/hcd.h                        |   16 +-
 drivers/usb/core/hub.c                        |  142 +-
 drivers/usb/core/message.c                    |  164 +-
 drivers/usb/core/sysfs.c                      |   49 +-
 drivers/usb/core/urb.c                        |   43 +-
 drivers/usb/core/usb.c                        |   79 +-
 drivers/usb/core/usb.h                        |   24 +-
 drivers/usb/gadget/Kconfig                    |   43 +-
 drivers/usb/gadget/Makefile                   |    2 +
 drivers/usb/gadget/ci13xxx_udc.c              | 2830 ++++++++++++++++++
 drivers/usb/gadget/ci13xxx_udc.h              |  195 ++
 drivers/usb/gadget/epautoconf.c               |    2 +-
 drivers/usb/gadget/file_storage.c             |  177 +-
 drivers/usb/gadget/fsl_qe_udc.c               |   12 +-
 drivers/usb/gadget/gadget_chips.h             |    8 +-
 drivers/usb/gadget/goku_udc.c                 |    2 +-
 drivers/usb/gadget/imx_udc.c                  | 1516 ++++++++++
 drivers/usb/gadget/imx_udc.h                  |  344 +++
 drivers/usb/gadget/m66592-udc.c               |    9 +-
 drivers/usb/gadget/net2280.c                  |    2 +-
 drivers/usb/gadget/omap_udc.c                 |    4 +-
 drivers/usb/gadget/pxa25x_udc.c               |    2 +-
 drivers/usb/gadget/pxa27x_udc.c               |    2 -
 drivers/usb/gadget/s3c2410_udc.c              |   34 +-
 drivers/usb/host/Kconfig                      |   13 +
 drivers/usb/host/Makefile                     |    1 +
 drivers/usb/host/ehci-dbg.c                   |    8 +-
 drivers/usb/host/ehci-hub.c                   |   27 +-
 drivers/usb/host/ehci-pci.c                   |   12 +-
 drivers/usb/host/ehci-ppc-of.c                |   45 +-
 drivers/usb/host/ehci.h                       |   34 +
 drivers/usb/host/isp1760-hcd.c                |   13 +-
 drivers/usb/host/isp1760-hcd.h                |    1 -
 drivers/usb/host/isp1760-if.c                 |  116 +-
 drivers/usb/host/ohci-hcd.c                   |   12 +-
 drivers/usb/host/ohci-pci.c                   |    6 +-
 drivers/usb/host/ohci-pnx4008.c               |   85 +-
 drivers/usb/host/ohci-ppc-of.c                |   25 +
 drivers/usb/host/ohci-tmio.c                  |    2 +-
 drivers/usb/host/oxu210hp-hcd.c               | 3985 +++++++++++++++++++++++++
 drivers/usb/host/oxu210hp.h                   |  447 +++
 drivers/usb/host/pci-quirks.c                 |   14 +-
 drivers/usb/host/r8a66597-hcd.c               |    8 +-
 drivers/usb/host/uhci-hcd.c                   |    2 +
 drivers/usb/image/microtek.c                  |   11 +-
 drivers/usb/misc/berry_charge.c               |    5 +
 drivers/usb/misc/emi26.c                      |    2 +-
 drivers/usb/misc/usbtest.c                    |    2 -
 drivers/usb/mon/Kconfig                       |   13 +-
 drivers/usb/mon/Makefile                      |    3 +-
 drivers/usb/musb/Kconfig                      |   12 +-
 drivers/usb/musb/Makefile                     |    8 +
 drivers/usb/musb/blackfin.c                   |  320 ++
 drivers/usb/musb/blackfin.h                   |   52 +
 drivers/usb/musb/davinci.c                    |   18 +-
 drivers/usb/musb/musb_core.c                  |   84 +-
 drivers/usb/musb/musb_core.h                  |   73 +-
 drivers/usb/musb/musb_gadget.c                |    2 +-
 drivers/usb/musb/musb_host.c                  |   45 +-
 drivers/usb/musb/musb_io.h                    |   26 +-
 drivers/usb/musb/musb_regs.h                  |  397 ++-
 drivers/usb/musb/musbhsdma.c                  |   84 +-
 drivers/usb/musb/musbhsdma.h                  |  149 +
 drivers/usb/musb/omap2430.c                   |   15 +-
 drivers/usb/musb/tusb6010.c                   |    7 +-
 drivers/usb/otg/Kconfig                       |   54 +
 drivers/usb/otg/Makefile                      |   15 +
 drivers/usb/otg/gpio_vbus.c                   |  335 +++
 drivers/{i2c/chips => usb/otg}/isp1301_omap.c |    0
 drivers/usb/otg/otg.c                         |   65 +
 drivers/usb/otg/twl4030-usb.c                 |  721 +++++
 drivers/usb/serial/Kconfig                    |   17 +
 drivers/usb/serial/Makefile                   |    2 +
 drivers/usb/serial/digi_acceleport.c          |   28 +-
 drivers/usb/serial/garmin_gps.c               |    2 +-
 drivers/usb/serial/ipw.c                      |    4 +-
 drivers/usb/serial/iuu_phoenix.c              |   38 +-
 drivers/usb/serial/mos7840.c                  |   38 +-
 drivers/usb/serial/opticon.c                  |  358 +++
 drivers/usb/serial/option.c                   |   11 +-
 drivers/usb/serial/siemens_mpi.c              |   77 +
 drivers/usb/serial/spcp8x5.c                  |   20 +-
 drivers/usb/serial/usb_debug.c                |    2 +-
 drivers/usb/storage/Kconfig                   |   11 +-
 drivers/usb/storage/Makefile                  |    3 +-
 drivers/usb/storage/dpcm.c                    |   86 -
 drivers/usb/storage/dpcm.h                    |   32 -
 drivers/usb/storage/libusual.c                |    7 +
 drivers/usb/storage/option_ms.c               |  147 +
 drivers/usb/storage/option_ms.h               |    4 +
 drivers/usb/storage/protocol.c                |   24 +-
 drivers/usb/storage/protocol.h                |    3 +-
 drivers/usb/storage/scsiglue.c                |   43 +
 drivers/usb/storage/sddr09.c                  |   43 +
 drivers/usb/storage/sddr09.h                  |    5 +-
 drivers/usb/storage/transport.c               |  219 +-
 drivers/usb/storage/transport.h               |    2 -
 drivers/usb/storage/unusual_devs.h            |  354 +--
 drivers/usb/storage/usb.c                     |  106 +-
 drivers/usb/storage/usb.h                     |    5 +-
 drivers/usb/wusbcore/rh.c                     |    2 +-
 fs/debugfs/file.c                             |   32 +
 include/linux/Kbuild                          |    2 +
 include/linux/debugfs.h                       |    2 +
 include/linux/oxu210hp.h                      |    7 +
 include/linux/usb.h                           |   30 +-
 include/linux/usb/association.h               |   22 +-
 include/linux/usb/gpio_vbus.h                 |   30 +
 include/linux/usb/musb.h                      |    5 +
 include/linux/usb/otg.h                       |    1 +
 include/linux/usb_usual.h                     |    7 +-
 include/linux/wimax.h                         |  234 ++
 include/linux/wimax/Kbuild                    |    1 +
 include/linux/wimax/debug.h                   |  453 +++
 include/linux/wimax/i2400m.h                  |  512 ++++
 include/net/wimax.h                           |  520 ++++
 net/Kconfig                                   |    2 +
 net/Makefile                                  |    1 +
 net/netlink/genetlink.c                       |    1 +
 net/wimax/Kconfig                             |   38 +
 net/wimax/Makefile                            |   13 +
 net/wimax/debug-levels.h                      |   42 +
 net/wimax/debugfs.c                           |   90 +
 net/wimax/id-table.c                          |  142 +
 net/wimax/op-msg.c                            |  421 +++
 net/wimax/op-reset.c                          |  143 +
 net/wimax/op-rfkill.c                         |  532 ++++
 net/wimax/stack.c                             |  599 ++++
 net/wimax/wimax-internal.h                    |   91 +
 186 files changed, 28282 insertions(+), 1390 deletions(-)
 create mode 100644 Documentation/wimax/README.i2400m
 create mode 100644 Documentation/wimax/README.wimax
 create mode 100644 arch/arm/plat-mxc/include/mach/usb.h
 create mode 100644 drivers/net/wimax/Kconfig
 create mode 100644 drivers/net/wimax/Makefile
 create mode 100644 drivers/net/wimax/i2400m/Kconfig
 create mode 100644 drivers/net/wimax/i2400m/Makefile
 create mode 100644 drivers/net/wimax/i2400m/control.c
 create mode 100644 drivers/net/wimax/i2400m/debug-levels.h
 create mode 100644 drivers/net/wimax/i2400m/debugfs.c
 create mode 100644 drivers/net/wimax/i2400m/driver.c
 create mode 100644 drivers/net/wimax/i2400m/fw.c
 create mode 100644 drivers/net/wimax/i2400m/i2400m-sdio.h
 create mode 100644 drivers/net/wimax/i2400m/i2400m-usb.h
 create mode 100644 drivers/net/wimax/i2400m/i2400m.h
 create mode 100644 drivers/net/wimax/i2400m/netdev.c
 create mode 100644 drivers/net/wimax/i2400m/op-rfkill.c
 create mode 100644 drivers/net/wimax/i2400m/rx.c
 create mode 100644 drivers/net/wimax/i2400m/sdio-debug-levels.h
 create mode 100644 drivers/net/wimax/i2400m/sdio-fw.c
 create mode 100644 drivers/net/wimax/i2400m/sdio-rx.c
 create mode 100644 drivers/net/wimax/i2400m/sdio-tx.c
 create mode 100644 drivers/net/wimax/i2400m/sdio.c
 create mode 100644 drivers/net/wimax/i2400m/tx.c
 create mode 100644 drivers/net/wimax/i2400m/usb-debug-levels.h
 create mode 100644 drivers/net/wimax/i2400m/usb-fw.c
 create mode 100644 drivers/net/wimax/i2400m/usb-notif.c
 create mode 100644 drivers/net/wimax/i2400m/usb-rx.c
 create mode 100644 drivers/net/wimax/i2400m/usb-tx.c
 create mode 100644 drivers/net/wimax/i2400m/usb.c
 create mode 100644 drivers/usb/gadget/ci13xxx_udc.c
 create mode 100644 drivers/usb/gadget/ci13xxx_udc.h
 create mode 100644 drivers/usb/gadget/imx_udc.c
 create mode 100644 drivers/usb/gadget/imx_udc.h
 create mode 100644 drivers/usb/host/oxu210hp-hcd.c
 create mode 100644 drivers/usb/host/oxu210hp.h
 create mode 100644 drivers/usb/musb/blackfin.c
 create mode 100644 drivers/usb/musb/blackfin.h
 create mode 100644 drivers/usb/musb/musbhsdma.h
 create mode 100644 drivers/usb/otg/Kconfig
 create mode 100644 drivers/usb/otg/Makefile
 create mode 100644 drivers/usb/otg/gpio_vbus.c
 rename drivers/{i2c/chips => usb/otg}/isp1301_omap.c (100%)
 create mode 100644 drivers/usb/otg/otg.c
 create mode 100644 drivers/usb/otg/twl4030-usb.c
 create mode 100644 drivers/usb/serial/opticon.c
 create mode 100644 drivers/usb/serial/siemens_mpi.c
 delete mode 100644 drivers/usb/storage/dpcm.c
 delete mode 100644 drivers/usb/storage/dpcm.h
 create mode 100644 drivers/usb/storage/option_ms.c
 create mode 100644 drivers/usb/storage/option_ms.h
 create mode 100644 include/linux/oxu210hp.h
 create mode 100644 include/linux/usb/gpio_vbus.h
 create mode 100644 include/linux/wimax.h
 create mode 100644 include/linux/wimax/Kbuild
 create mode 100644 include/linux/wimax/debug.h
 create mode 100644 include/linux/wimax/i2400m.h
 create mode 100644 include/net/wimax.h
 create mode 100644 net/wimax/Kconfig
 create mode 100644 net/wimax/Makefile
 create mode 100644 net/wimax/debug-levels.h
 create mode 100644 net/wimax/debugfs.c
 create mode 100644 net/wimax/id-table.c
 create mode 100644 net/wimax/op-msg.c
 create mode 100644 net/wimax/op-reset.c
 create mode 100644 net/wimax/op-rfkill.c
 create mode 100644 net/wimax/stack.c
 create mode 100644 net/wimax/wimax-internal.h

---------------

Alan Stern (22):
      USB: straighten out inline code in sysfs.c
      USB: change interface to usb_lock_device_for_reset()
      USB: usb-storage: add "quirks=" module parameter
      USB: add asynchronous autosuspend/autoresume support
      USB: announce new devices earlier
      usb-storage: clean up unusual_devs.h
      USB: usb-storage: remove us->sensebuf
      USB: g_file_storage: add CD-ROM emulation
      USB: usb-storage: merge CB and CBI transport routines
      USB: usb-storage: merge ATAPI and QIC-157 protocol routines
      USB: storage: set bounce limit for non-DMA-capable host controllers
      USB: utilize round_jiffies_up_relative()
      USB: Enhance usage of pm_message_t
      USB: usb-storage: merge DPCM support into SDDR09
      USB: utilize the bus notifiers
      USB: storage: add last-sector hacks
      USB: storage: make the "quirks=" module parameter writable
      USB: storage: set CAPACITY_HEURISTICS flag for bad vendors
      USB: fix up suspend and resume for PCI host controllers
      USB: automatically enable wakeup for PCI host controllers
      USB: cancel pending Set-Config requests if userspace gets there first
      USB: re-enable interface after driver unbinds

Anton Vorontsov (2):
      USB: protect hcd.h from multiple inclusions
      USB: fsl_qe_udc: Check for muram allocation errors

Arjan van de Ven (1):
      USB: use pci_ioremap_bar() in drivers/usb

Ben Dooks (1):
      USB: gadget: s3c2410_udc uses standard GPIO calls

Ben Efros (2):
      USB: storage devices and SAT
      USB: storage: Flag devices known to support SANE_SENSE

Bryan Wu (8):
      USB: musb: use new platform data interface of musb to replace old one
      USB: musb: add Blackfin driver to MUSB framework (v2)
      USB: musb: add Blackfin version low level register accessing helper functions
      USB: musb: enable low level DMA operation for Blackfin
      USB: musb: add Blackfin specific configuration to MUSB
      USB: musb: add Blackfin Kconfig options and Makefile
      USB: musb: Blackfin provides read/write I/O accessor in header files
      USB: musb: Kill some compiling warning in musb Blackfin part

Dan Williams (1):
      USB: unusual dev for Option N.V. ZeroCD modems

Daniel Drake (1):
      USB: unusual_devs.h additions for Pentax K10D

Darius Augulis (1):
      USB: add imx udc gadget driver

David Brownell (6):
      USB: musb: sysfs mode updates
      USB: musb: minor locking fix
      USB: musb: host side diagnostics tweaks
      USB: gadget: pxa25x_udc vbus sense initialization
      USB: move isp1301_omap to drivers/usb/otg
      USB: otg: twl4030 transceiver driver

David Lopo (1):
      USB: gadget: MIPS ci13xxx_udc

Felipe Balbi (3):
      USB: musb: Add musb git tree to maintainers entry
      USB: musb: check if set_irq_wake succeded and remember it
      USB: gadget: don't wait for completion twice

Greg Kroah-Hartman (6):
      USB: serial: fix up urb->status usage
      USB: option: increase outgoing buffer size and number
      USB: add new opticon serial driver
      USB: add siemens_mpi usb-serial "stub" driver
      USB: remove warn() macro from usb.h
      USB: remove info() macro from usb.h

Harvey Harrison (2):
      USB: avoid needless address-taking of function parameters
      USB: wusb: annotate association types withe proper endianness

Ilpo Järvinen (1):
      USB: usbtmc: indent & braces disagree, something else is desired

Inaky Perez-Gonzalez (30):
      USB: Introduce usb_queue_reset() to do resets from atomic contexts
      debugfs: add helpers for exporting a size_t simple value
      wimax: documentation for the stack
      wimax: headers for kernel API and user space interaction
      wimax: internal API for the kernel space WiMAX stack
      wimax: debug macros and debug settings for the WiMAX stack
      wimax: generic device management (registration, deregistration, lookup)
      genetlink: export genl_unregister_mc_group()
      wimax: basic API: kernel/user messaging, rfkill and reset
      wimax: debugfs controls
      wimax: Makefile, Kconfig and docbook linkage for the stack
      i2400m: documentation and instructions for usage
      i2400m: host/device procotol and core driver definitions
      i2400m: Generic probe/disconnect, reset and message passing
      i2400m: linkage to the networking stack
      i2400m: firmware loading and bootrom initialization
      i2400m: RX and TX data/control paths
      i2400m: various functions for device management
      i2400m: debugfs controls
      i2400m/USB: header for the USB bus driver
      i2400m/USB: probe/disconnect, dev init/shutdown and reset backends
      i2400m/USB: firmware upload backend
      i2400m/USB: TX and RX path backends
      i2400m/SDIO: header for the SDIO subdriver
      i2400m/SDIO: probe/disconnect, dev init/shutdown and reset backends
      i2400m/SDIO: firmware upload backend
      i2400m/SDIO: TX and RX path backends
      i2400m: Makefile and Kconfig
      wimax: export linux/wimax.h and linux/wimax/i2400m.h with headers_install
      wimax/i2400m: add CREDITS and MAINTAINERS entries

Jean Delvare (1):
      USB: Convert ohci-pnx4008 to a new-style i2c driver

Julia Lawall (1):
      USB: gadget: change simple_strtol to simple_strtoul

Karl Bongers (1):
      USB: isp1760: Fix probe in PCI glue code

Kay Sievers (2):
      usb: struct device - replace bus_id with dev_name(), dev_set_name()
      oxu210hp-hcd.c: struct device - replace bus_id with dev_name(), dev_set_name()

Kevin Hilman (1):
      USB: musb: build fixes for DaVinci

Magnus Damm (1):
      USB: m66592 and r8a66597 resource changes

Marcin Slusarz (1):
      USB: emi26: fix oops on load

Mark Lord (1):
      USB: fix minor nit in usbfs checking

Ming Lei (1):
      USB: mark "reject" field of struct urb as atomic_t

Nguyen Anh Quynh (1):
      USB: another unusual_devs entry for another bad Argosy storage device

Oliver Neukum (3):
      USB: storage: extend unusual range for 067b:3507
      USB: power availability check for berry_charge
      USB: extension of anchor API to unpoison an anchor

Paulo Afonso Graner Fessel (1):
      USB: storage: recognizing and enabling Nokia 5200 cell phoes

Pete Zaitcev (1):
      USB: Allow usbmon as a module even if usbcore is builtin

Phil Endecott (1):
      USB: Remove restrictions on signal numbers in devio.c

Philipp Zabel (2):
      USB: otg: gpio_vbus transceiver stub
      USB: otg: add otg_put_transceiver()

Qinghuang Feng (2):
      USB: gadget: pxa27x_udc.c: cleanup kernel-doc
      USB: serial: ipw.c: mark {__init|__exit} for usb_ipw_{init|exit}

Robin Getz (1):
      USB: musb: Make sure we program the correct values in only when necessary.

Rodolfo Giometti (1):
      usb host: Oxford OXU210HP HCD driver.

Roel Kluin (1):
      USB: serial: usb_debug: Make static

Rusty Russell (1):
      USB: Don't use __module_param_call; use core_param.

SangSu Park (1):
      USB: Fix goku_udc usb speed handling

Sebastian Andrzej Siewior (1):
      USB: isp1760: use a specific PLX bridge instead of any bdridge

Sergey Ovcharenko (1):
      USB: storage: unusual_devs.h additions for Macpower MasterBox

Steven Noonan (1):
      USB: EHCI pci-quirks.c: don't wait so long for BIOS handoff

Thomas Hommel (1):
      USB: isp1760: don't auto disable Port1 on ISP1761

Tony Lindgren (1):
      USB: otg: sharable otg transceiver ops

Vikram Pandita (1):
      USB: Avoid 20ms delay in EHCI resume

Vitaly Bordug (1):
      USB: powerpc: Workaround for the PPC440EPX USBH_23 errata [take 3]

Wu Fengguang (1):
      USB: make printk messages more searchable

roel kluin (1):
      USB: clean up redundant tests on unsigned


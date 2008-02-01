Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYBAXOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYBAXOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbYBAXNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:13:45 -0500
Received: from ns.suse.de ([195.135.220.2]:44042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688AbYBAXNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:13:41 -0500
Date: Fri, 1 Feb 2008 15:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.24
Message-ID: <20080201231153.GB18174@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a lot of USB fixes and new drivers against your 2.6.24 git tree.

Full details are below, nothing radical here, just some new drivers,
more device ids, and some general improvements in a variety of places.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm trees for quite a while.

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-usb    |   33 +
 Documentation/feature-removal-schedule.txt |   16 -
 Documentation/usb/gadget_printer.txt       |  510 +++++++++
 Documentation/usb/iuu_phoenix.txt          |   84 ++
 arch/arm/mach-pxa/tosa.c                   |    9 +-
 drivers/block/ub.c                         |   23 -
 drivers/usb/Kconfig                        |    5 +
 drivers/usb/atm/Kconfig                    |    9 +-
 drivers/usb/atm/ueagle-atm.c               |    6 +-
 drivers/usb/class/cdc-acm.c                |   94 ++-
 drivers/usb/class/cdc-acm.h                |    2 +
 drivers/usb/core/Kconfig                   |   15 +
 drivers/usb/core/buffer.c                  |   20 +-
 drivers/usb/core/config.c                  |   14 +-
 drivers/usb/core/devices.c                 |  154 ++--
 drivers/usb/core/devio.c                   |  359 ++++---
 drivers/usb/core/driver.c                  |   44 +-
 drivers/usb/core/file.c                    |    4 +-
 drivers/usb/core/hcd-pci.c                 |  145 ++--
 drivers/usb/core/hcd.c                     |  216 +++-
 drivers/usb/core/hcd.h                     |   92 +-
 drivers/usb/core/hub.c                     |   88 +-
 drivers/usb/core/hub.h                     |   18 +-
 drivers/usb/core/inode.c                   |   42 +-
 drivers/usb/core/message.c                 |  430 ++++----
 drivers/usb/core/notify.c                  |    2 +-
 drivers/usb/core/otg_whitelist.h           |    6 +-
 drivers/usb/core/sysfs.c                   |   69 +-
 drivers/usb/core/urb.c                     |   37 +-
 drivers/usb/core/usb.c                     |  117 +--
 drivers/usb/core/usb.h                     |   21 +-
 drivers/usb/gadget/Kconfig                 |   33 +-
 drivers/usb/gadget/Makefile                |    3 +
 drivers/usb/gadget/amd5536udc.c            |    3 +-
 drivers/usb/gadget/at91_udc.c              |   87 ++-
 drivers/usb/gadget/at91_udc.h              |   17 +-
 drivers/usb/gadget/atmel_usba_udc.c        |   11 +-
 drivers/usb/gadget/atmel_usba_udc.h        |    7 +-
 drivers/usb/gadget/dummy_hcd.c             |   38 +-
 drivers/usb/gadget/ether.c                 |    6 +-
 drivers/usb/gadget/file_storage.c          |   14 +-
 drivers/usb/gadget/fsl_usb2_udc.c          |    4 +-
 drivers/usb/gadget/fsl_usb2_udc.h          |    6 +-
 drivers/usb/gadget/gmidi.c                 |    6 +-
 drivers/usb/gadget/goku_udc.c              |    1 +
 drivers/usb/gadget/inode.c                 |    2 +-
 drivers/usb/gadget/lh7a40x_udc.c           |    1 +
 drivers/usb/gadget/m66592-udc.c            |  104 ++-
 drivers/usb/gadget/m66592-udc.h            |   54 +
 drivers/usb/gadget/net2280.c               |    2 +-
 drivers/usb/gadget/omap_udc.c              |   73 +-
 drivers/usb/gadget/omap_udc.h              |   13 +-
 drivers/usb/gadget/printer.c               | 1592 ++++++++++++++++++++++++++++
 drivers/usb/gadget/pxa2xx_udc.c            |  141 ++--
 drivers/usb/gadget/pxa2xx_udc.h            |   25 +-
 drivers/usb/gadget/rndis.c                 |   20 +-
 drivers/usb/gadget/s3c2410_udc.c           |    4 +-
 drivers/usb/gadget/serial.c                |  153 ++--
 drivers/usb/gadget/zero.c                  |    4 +-
 drivers/usb/host/Kconfig                   |   22 +-
 drivers/usb/host/ehci-au1xxx.c             |    1 +
 drivers/usb/host/ehci-dbg.c                |  231 ++++-
 drivers/usb/host/ehci-fsl.c                |    3 +-
 drivers/usb/host/ehci-hcd.c                |  159 ++-
 drivers/usb/host/ehci-hub.c                |   98 ++-
 drivers/usb/host/ehci-ixp4xx.c             |  152 +++
 drivers/usb/host/ehci-orion.c              |  272 +++++
 drivers/usb/host/ehci-pci.c                |    3 +-
 drivers/usb/host/ehci-ppc-of.c             |  238 +++++
 drivers/usb/host/ehci-ppc-soc.c            |    1 +
 drivers/usb/host/ehci-ps3.c                |    1 +
 drivers/usb/host/ehci-q.c                  |   25 +-
 drivers/usb/host/ehci-sched.c              |  152 ++--
 drivers/usb/host/ehci.h                    |   40 +-
 drivers/usb/host/isp116x-hcd.c             |    1 -
 drivers/usb/host/ohci-at91.c               |   31 +
 drivers/usb/host/ohci-dbg.c                |  213 ++++-
 drivers/usb/host/ohci-hcd.c                |   34 +-
 drivers/usb/host/ohci-sh.c                 |  143 +++
 drivers/usb/host/ohci-sm501.c              |  264 +++++
 drivers/usb/host/ohci.h                    |    7 +
 drivers/usb/host/r8a66597.h                |    2 +-
 drivers/usb/image/mdc800.c                 |    2 -
 drivers/usb/misc/cypress_cy7c63.c          |    7 +-
 drivers/usb/misc/iowarrior.c               |    2 +-
 drivers/usb/misc/legousbtower.c            |   30 +-
 drivers/usb/misc/sisusbvga/sisusb.c        |   29 +-
 drivers/usb/misc/sisusbvga/sisusb.h        |    3 -
 drivers/usb/misc/usbtest.c                 |   20 +-
 drivers/usb/mon/mon_bin.c                  |   22 +-
 drivers/usb/serial/Kconfig                 |   37 +-
 drivers/usb/serial/Makefile                |    1 +
 drivers/usb/serial/airprime.c              |    5 +-
 drivers/usb/serial/ark3116.c               |    4 +-
 drivers/usb/serial/belkin_sa.c             |   37 +-
 drivers/usb/serial/console.c               |   90 +-
 drivers/usb/serial/cp2101.c                |   11 +-
 drivers/usb/serial/cyberjack.c             |    1 -
 drivers/usb/serial/cypress_m8.c            |   25 +-
 drivers/usb/serial/digi_acceleport.c       |   13 +-
 drivers/usb/serial/ezusb.c                 |    4 +-
 drivers/usb/serial/ftdi_sio.c              |  293 +-----
 drivers/usb/serial/ftdi_sio.h              |   15 +
 drivers/usb/serial/garmin_gps.c            |   17 +-
 drivers/usb/serial/generic.c               |    8 +
 drivers/usb/serial/io_edgeport.c           |    8 +-
 drivers/usb/serial/io_ti.c                 |   47 +-
 drivers/usb/serial/iuu_phoenix.c           | 1217 +++++++++++++++++++++
 drivers/usb/serial/iuu_phoenix.h           |  122 +++
 drivers/usb/serial/keyspan.c               |    2 +-
 drivers/usb/serial/keyspan_pda.c           |   38 +-
 drivers/usb/serial/kl5kusb105.c            |   26 +-
 drivers/usb/serial/kobil_sct.c             |    1 +
 drivers/usb/serial/mct_u232.c              |   43 +-
 drivers/usb/serial/mct_u232.h              |    2 +-
 drivers/usb/serial/mos7720.c               |   61 +-
 drivers/usb/serial/mos7840.c               |    8 +-
 drivers/usb/serial/option.c                |    6 +-
 drivers/usb/serial/oti6858.c               |  131 +--
 drivers/usb/serial/pl2303.c                |  112 +-
 drivers/usb/serial/pl2303.h                |   13 +-
 drivers/usb/serial/sierra.c                |  227 +++--
 drivers/usb/serial/ti_usb_3410_5052.c      |   75 +-
 drivers/usb/serial/usb-serial.c            |   42 +-
 drivers/usb/serial/visor.c                 |   22 +-
 drivers/usb/serial/whiteheat.c             |   10 +-
 drivers/usb/storage/initializers.c         |    3 +-
 drivers/usb/storage/isd200.c               |   29 +-
 drivers/usb/storage/unusual_devs.h         |    8 +
 drivers/video/sis/sis.h                    |    8 -
 drivers/video/sis/sis_main.c               |   48 -
 include/asm-arm/arch-at91/board.h          |    3 +-
 include/asm-arm/mach/udc_pxa2xx.h          |    2 +
 include/linux/usb.h                        |  209 ++--
 include/linux/usb/Kbuild                   |   11 +-
 include/linux/usb/audio.h                  |   14 +-
 include/linux/usb/cdc.h                    |   16 +-
 include/linux/usb/g_printer.h              |   31 +
 include/linux/usb/gadget.h                 |  123 +--
 include/linux/usb/gadgetfs.h               |   27 +-
 include/linux/usb/iowarrior.h              |   25 +-
 include/linux/usb/isp116x.h                |    2 +-
 include/linux/usb/midi.h                   |   26 +-
 include/linux/usb/net2280.h                |   32 +-
 include/linux/usb/otg.h                    |    2 +-
 include/linux/usb/serial.h                 |  160 ++--
 include/linux/usb/sl811.h                  |    6 +-
 include/linux/usb_usual.h                  |    5 +-
 include/linux/usbdevice_fs.h               |    2 +-
 scripts/mod/file2alias.c                   |    2 +-
 150 files changed, 8200 insertions(+), 2684 deletions(-)
 create mode 100644 Documentation/usb/gadget_printer.txt
 create mode 100644 Documentation/usb/iuu_phoenix.txt
 create mode 100644 drivers/usb/gadget/printer.c
 create mode 100644 drivers/usb/host/ehci-ixp4xx.c
 create mode 100644 drivers/usb/host/ehci-orion.c
 create mode 100644 drivers/usb/host/ehci-ppc-of.c
 create mode 100644 drivers/usb/host/ohci-sh.c
 create mode 100644 drivers/usb/host/ohci-sm501.c
 create mode 100644 drivers/usb/serial/iuu_phoenix.c
 create mode 100644 drivers/usb/serial/iuu_phoenix.h
 create mode 100644 include/linux/usb/g_printer.h

---------------

Adrian Bunk (1):
      USB: usb/mon/mon_bin.c: cleanups

Akira Tsukamoto (1):
      USB: pl2303: add support for RATOC REX-USB60F

Alain Degreffe (1):
      USB: add iuu_phoenix driver

Alan Cox (8):
      USB: keyspan: Fix oops
      USB: belkin_sa: clean up for new style termios and speed handling, plus style
      USB: keyspan_pda: clean up speed handling
      USB: mct232: speed, new termios and compliance cleanups
      USB: mos7720: clean up termios
      USB: ti_usb: termios cleanups
      USB: io_ti: clean up termios handling
      USB: oti6858: cleanup

Alan Stern (11):
      USB: usb-storage: new "lockable" subclass 0x07
      USB: make ksuspend_usbd thread non-freezable
      USB: don't change HC power state for a FREEZE
      USB: dummy_hcd: don't register drivers on the platform bus
      USB: repair USBDEVFS_CONNECT ioctl
      USB: updates to usb_reset_composite_device()
      USB: add usbfs stubs for suspend and resume
      USB: EHCI: add separate IAA watchdog timer
      USB: dummy_hcd: change the default power budget
      USB: EHCI: move del_timer_sync calls outside spinlocked region
      USB: EHCI: add a short delay to the bus_suspend routine

Andre Haupt (1):
      USB: cyberjack: remove a unnecessary variable.

Andrew Morton (1):
      USB: testing driver: don't free a locked mutex

Aristeu Rozanski (3):
      USB: usb_serial_console: fix command line parsing
      USB: usb_serial: clean tty reference in the last close
      USB: usb_serial_console: allocate fake tty and termios before calling driver open() method

Balaji Rao (1):
      USB: force handover port to companion when hub_port_connect_change fails

Bartlomiej Zolnierkiewicz (1):
      USB: isd200: don't include <linux/ide.h>

Benjamin Herrenschmidt (1):
      usb: Remove OHCI useless masking/unmasking of WDH interrupt

Bruno Redondi (1):
      USB: sierra: add support for Onda H600/Zte MF330 datacard to USB Driver for Sierra Wireless

Craig Shelley (1):
      USB: CP2101 New Device IDs

Craig W. Nadler (1):
      USB: add Printer Gadget Driver

Damien Stuart (1):
      USB: Adding YC Cable USB Serial device to pl2303

Daniel Kozák (1):
      USB: remove duplicate entry in Option driver and Pl2303 driver for Huawei modem

Daniel Walker (1):
      USB: misc: legousbtower: semaphore to mutex

David Brownell (12):
      USB: gadget code switches to pr_err() and friends
      USB: PS3: Fix EHCI ISO transfer bug
      USB: ehci potential oops fix on ARC/TDI cores
      USB: gadget: ethernet error path potential oops fix
      USB: gadget: at91_udc minor fix (there is no number six)
      USB: fix HCD Kconfig goofage
      USB: ohci-at91 uses generic GPIO calls
      USB: at91_udc uses generic GPIO calls; minor cleanup
      USB: ehci: minor ISO updates, always support split ISO
      USB: ehci completes high speed ISO URBs sooner
      usb: ehci, remove false clear-reset path
      usb: ehci should use u16 for isochronous intervals

Denis Cheng (1):
      USB: Use menuconfig objects

Dmitry Baryshkov (3):
      USB: gadget: pxa2xx_udc supports inverted vbus
      USB: tosa_udc_use_gpio_vbus.patch
      USB: pxa2xx_udc: use debugfs not procfs

Ed Beroset (1):
      USB: ftdi driver - add support for optical probe device

Fernando Luis Vazquez Cao (1):
      USB: sis FB driver: *_ioctl32_conversion functions do not exist in recent kernels

Fernando Luis Vázquez Cao (1):
      USB: sisusb: *_ioctl32_conversion functions do not exist in recent kernels

Franco Lanza (1):
      USB: ftdi-sio: Patch to add vendor/device id for ATK_16IC CCD

Grant Grundler (1):
      USB: storage: Add unusual_dev for HP r707

Greg Kroah-Hartman (13):
      USB: handle idVendor of 0x0000
      USB: always announce a device has been added to the system
      USB: ftdi_sio: remove very old changelog entries from the file.
      USB: use a real vendor and product id for root hubs
      USB: mark USB drivers as being GPL only
      USB: fix codingstyle issues in include/linux/usb.h
      USB: fix codingstyle issues in include/linux/usb/
      USB: fix codingstyle issues in drivers/usb/core/*.h
      USB: fix codingstyle issues in drivers/usb/core/devices.c
      USB: fix codingstyle issues in drivers/usb/core/devio.c
      USB: fix codingstyle issues in drivers/usb/core/hcd-pci.c
      USB: fix codingstyle issues in drivers/usb/core/message.c
      USB: fix codingstyle issues in drivers/usb/core/*.c

Harald Welte (1):
      USB: ftdi_sio: Support for more JTAG adaptors

Jan Andersson (1):
      usb: fix usbtest halt check on big endian systems

Jan Engelhardt (1):
      USB: constify function pointer tables

Jeff Garzik (1):
      USB: s3c2410_udc: minor irq handler cleanups

Jessica L. Blank (1):
      USB: Sierra - Add support for Aircard 881U

Joe Perches (2):
      USB: Add missing "space" to printk messages
      USB: Spelling fixes

Julia Lawall (1):
      USB: Drop unnecessary continue in a few drivers

Karsten Wiese (1):
      USB: ehci saves some memory in ISO transfer descriptors

Kevin Lloyd (2):
      USB: sierra driver - add devices
      USB: sierra driver - add update dtr logic

Kyungmin Park (1):
      USB: device DMA support on OMAP2

Li Yang (1):
      usb gadget: fix fsl_usb2_udc potential OOPS

Magnus Damm (2):
      usb: dma bounce buffer support
      usb: ohci-sm501 driver

Manish Katiyar (1):
      USB : correct comments in usb/core/notify.c

Marcin Slusarz (3):
      USB: usb/storage/initializers.c: fix signedness difference
      USB: usbdevfs_urb: __user annotation
      USB: ehci-hcd: fix sparse warning about shadowing 'status' symbol

Matthias Kaehlcke (3):
      USB: TI 3410/5052 USB Serial: convert td_open_close_lock to mutex
      USB: Edgeport USB Serial Converter: convert es_sem to mutex
      USB: testing driver: convert dev->sem to mutex

Miklos Szeredi (1):
      USB: mount options: fix usbfs

Nate Carlson (1):
      USB: Variant of the Dell Wireless 5520 driver

Nick Piggin (1):
      USB: mon nopage

Oliver Bock (1):
      USB: cypress_cy7c63: updated contact/usage information

Oliver Neukum (10):
      USB: use GFP_NOIO in reset path
      USB: autosuspend for cdc-acm
      USB: fix NULL pointer dereference on drivers/usb/serial/whiteheat.c
      USB: stop io performed by mos7720 upon close()
      USB: stop abuse of intfdata in cypress_m8
      USB: fix memleak in ark3116 serial driver
      USB: make sure usb serial drivers don't flush to logically disconnected devices
      USB: more serial drivers writing after disconnect
      USB: kl5kusb105 don't flush to logically disconnected devices
      USB: last abuses of intfdata in close for usb-serial drivers

Patrik Sevallius (1):
      USB: usb peripheral controller driver oops avoidance

Paul Chavent (1):
      USB: usbserial: provide ezusb functions for an external module.

Pete Zaitcev (2):
      USB: Remove unnecessary zeroing from ub
      USB: usbfs: struct async is a fixed size structure

Peter Stark (1):
      USB: ftdi_sio - enabling multiple ELV devices, adding EM1010PC

Piotr Roszatycki (1):
      USB: add support for 4348:5523 WinChipHead USB->RS 232 adapter

Robert P. J. Day (1):
      USB: linux/usb/Kbuild needs only "header-y", not "unifdef-y"

Sarah Sharp (6):
      USB: Prepare serial core for autosuspend.
      USB: pl2303: Cleanup FISH and SOUP macros in pl2303 driver.
      USB: pl2303: Move pl2303 vendor specific init to probe function.
      USB: pl2303: Add autosuspend support to pl2303 usb serial converter.
      USB: Export suspend statistics
      USB: Add documentation for USB suspend statistics.

Stefan Bader (1):
      USB: Fix usb_serial_driver structure for Kobil cardreader driver.

Tony Jones (3):
      USB: Convert from class_device to device for USB core
      USB: convert ohci debug files to use debugfs instead of sysfs
      USB: convert ehci debug files to use debugfs instead of sysfs

Tzachi Perelstein (1):
      USB: add Marvell Orion USB host support

Valentine Barshak (1):
      USB: add ehci-ppc-of bus glue (device-tree aware)

Vladimir Barinov (1):
      USB: add ehci-ixp bus glue

Yoshihiro Shimoda (2):
      USB: m66592-udc: Add support for SH7722 USBF
      USB: add support for SuperH OHCI


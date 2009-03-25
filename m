Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZCYAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZCYAZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZCYAZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:25:12 -0400
Received: from kroah.org ([198.145.64.141]:47201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbZCYAZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:25:09 -0400
Date: Tue, 24 Mar 2009 17:17:07 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.30 merge window
Message-ID: <20090325001707.GA22469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the main batch of USB patches for the 2.6.30 merge window.

Lots of little things in here, some new drivers, rework of the
usb-storage drivers to be separate modules now, and lots of gadget work.

The phidget drivers have been deleted, as there is an opensource
userspace library that supports them much easier and in more detail (the
kernel drivers were quite limited.)  This also resolves the dynamic
power management issues these drivers had posed, so Oliver will be happy :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/usbmon.txt                       |   27 +-
 arch/arm/mach-s3c2410/usb-simtec.c                 |    3 +-
 .../mach => plat-s3c/include/plat}/usb-control.h   |    6 +-
 drivers/block/ub.c                                 |   11 +-
 drivers/usb/Makefile                               |    1 +
 drivers/usb/class/usblp.c                          |   11 +-
 drivers/usb/core/devices.c                         |    2 +-
 drivers/usb/core/devio.c                           |   21 +-
 drivers/usb/core/endpoint.c                        |    9 +-
 drivers/usb/core/hcd.c                             |   33 +-
 drivers/usb/core/hub.c                             |   34 +-
 drivers/usb/core/message.c                         |   11 +-
 drivers/usb/core/quirks.c                          |    4 +
 drivers/usb/core/sysfs.c                           |    4 +-
 drivers/usb/core/urb.c                             |    4 +-
 drivers/usb/gadget/Kconfig                         |    1 +
 drivers/usb/gadget/amd5536udc.c                    |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   20 +-
 drivers/usb/gadget/cdc2.c                          |    8 +-
 drivers/usb/gadget/ci13xxx_udc.c                   |    1 -
 drivers/usb/gadget/composite.c                     |   13 +-
 drivers/usb/gadget/dummy_hcd.c                     |    4 +-
 drivers/usb/gadget/epautoconf.c                    |    2 +-
 drivers/usb/gadget/ether.c                         |    8 +-
 drivers/usb/gadget/f_acm.c                         |   10 +-
 drivers/usb/gadget/f_ecm.c                         |   16 +-
 drivers/usb/gadget/f_loopback.c                    |   10 +-
 drivers/usb/gadget/f_obex.c                        |    8 +-
 drivers/usb/gadget/f_phonet.c                      |    8 +-
 drivers/usb/gadget/f_rndis.c                       |   12 +-
 drivers/usb/gadget/f_serial.c                      |    4 +-
 drivers/usb/gadget/f_sourcesink.c                  |   56 +--
 drivers/usb/gadget/f_subset.c                      |   14 +-
 drivers/usb/gadget/file_storage.c                  |   22 +-
 drivers/usb/gadget/fsl_usb2_udc.c                  |    8 +-
 drivers/usb/gadget/g_zero.h                        |    4 +-
 drivers/usb/gadget/gmidi.c                         |   16 +-
 drivers/usb/gadget/goku_udc.c                      |    8 +-
 drivers/usb/gadget/imx_udc.c                       |  244 ++++---
 drivers/usb/gadget/imx_udc.h                       |   49 +-
 drivers/usb/gadget/inode.c                         |    4 +-
 drivers/usb/gadget/lh7a40x_udc.c                   |   16 +-
 drivers/usb/gadget/net2280.c                       |   16 +-
 drivers/usb/gadget/printer.c                       |   18 +-
 drivers/usb/gadget/pxa27x_udc.c                    |  272 ++++++--
 drivers/usb/gadget/pxa27x_udc.h                    |   10 +
 drivers/usb/gadget/serial.c                        |   12 +-
 drivers/usb/gadget/u_serial.c                      |    2 +-
 drivers/usb/gadget/zero.c                          |   78 ++-
 drivers/usb/host/Kconfig                           |    7 +-
 drivers/usb/host/ehci-hcd.c                        |   36 +
 drivers/usb/host/ehci-q.c                          |   32 +
 drivers/usb/host/ehci-sched.c                      |    2 +-
 drivers/usb/host/ehci.h                            |   39 +-
 drivers/usb/host/hwa-hc.c                          |    3 +-
 drivers/usb/host/isp116x-hcd.c                     |    2 +-
 drivers/usb/host/isp116x.h                         |    8 +-
 drivers/usb/host/isp1760-hcd.c                     |   25 +-
 drivers/usb/host/isp1760-hcd.h                     |    7 +-
 drivers/usb/host/isp1760-if.c                      |   95 +++-
 drivers/usb/host/ohci-hcd.c                        |    2 +-
 drivers/usb/host/ohci-s3c2410.c                    |    6 +-
 drivers/usb/host/oxu210hp-hcd.c                    |   24 +-
 drivers/usb/host/oxu210hp.h                        |    8 +-
 drivers/usb/host/pci-quirks.c                      |    2 +-
 drivers/usb/host/r8a66597-hcd.c                    |  118 +++-
 drivers/usb/host/r8a66597.h                        |    2 +
 drivers/usb/host/sl811-hcd.c                       |    4 +-
 drivers/usb/host/uhci-debug.c                      |    4 +-
 drivers/usb/host/uhci-hcd.h                        |   10 +-
 drivers/usb/host/uhci-q.c                          |   21 +-
 drivers/usb/image/mdc800.c                         |    8 +-
 drivers/usb/misc/Kconfig                           |   39 -
 drivers/usb/misc/Makefile                          |    4 -
 drivers/usb/misc/ftdi-elan.c                       |    6 +-
 drivers/usb/misc/phidget.c                         |   43 --
 drivers/usb/misc/phidget.h                         |   12 -
 drivers/usb/misc/phidgetkit.c                      |  740 --------------------
 drivers/usb/misc/phidgetmotorcontrol.c             |  465 ------------
 drivers/usb/misc/phidgetservo.c                    |  375 ----------
 drivers/usb/mon/mon_bin.c                          |  142 +++-
 drivers/usb/musb/Kconfig                           |    6 +-
 drivers/usb/musb/davinci.c                         |   63 ++-
 drivers/usb/musb/davinci.h                         |   23 +-
 drivers/usb/musb/musb_core.c                       |    2 +-
 drivers/usb/musb/musb_core.h                       |    5 +-
 drivers/usb/musb/musb_host.c                       |  140 +++--
 drivers/usb/musb/musb_virthub.c                    |    2 +-
 drivers/usb/otg/Kconfig                            |   10 +-
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/gpio_vbus.c                        |   42 +-
 drivers/usb/otg/nop-usb-xceiv.c                    |  180 +++++
 drivers/usb/otg/twl4030-usb.c                      |   73 ++-
 drivers/usb/serial/Kconfig                         |   28 +-
 drivers/usb/serial/Makefile                        |    4 +-
 drivers/usb/serial/ch341.c                         |  396 +++++++++--
 drivers/usb/serial/{cp2101.c => cp210x.c}          |  161 +++--
 drivers/usb/serial/ftdi_sio.c                      |   29 +-
 drivers/usb/serial/generic.c                       |    9 +-
 drivers/usb/serial/ipaq.c                          |   43 +-
 drivers/usb/serial/keyspan.c                       |    2 +-
 drivers/usb/serial/opticon.c                       |  215 ++++++-
 drivers/usb/serial/option.c                        |   86 +++-
 drivers/usb/serial/qcserial.c                      |  147 ++++
 drivers/usb/serial/symbolserial.c                  |  399 +++++++++++
 drivers/usb/serial/usb-serial.c                    |   20 +-
 drivers/usb/storage/Kconfig                        |   48 +-
 drivers/usb/storage/Makefile                       |   41 +-
 drivers/usb/storage/alauda.c                       |  192 +++++-
 drivers/usb/storage/alauda.h                       |  100 ---
 drivers/usb/storage/cypress_atacb.c                |  106 +++-
 drivers/usb/storage/datafab.c                      |  104 +++-
 drivers/usb/storage/datafab.h                      |   40 --
 drivers/usb/storage/freecom.c                      |   99 +++-
 drivers/usb/storage/isd200.c                       |   97 +++-
 drivers/usb/storage/jumpshot.c                     |  103 +++-
 drivers/usb/storage/jumpshot.h                     |   39 -
 drivers/usb/storage/karma.c                        |  100 +++-
 drivers/usb/storage/karma.h                        |    7 -
 drivers/usb/storage/libusual.c                     |   33 +-
 drivers/usb/storage/onetouch.c                     |   94 +++-
 drivers/usb/storage/onetouch.h                     |    9 -
 drivers/usb/storage/protocol.c                     |    3 +
 drivers/usb/storage/scsiglue.c                     |    8 +-
 drivers/usb/storage/sddr09.c                       |  147 ++++-
 drivers/usb/storage/sddr09.h                       |   38 -
 drivers/usb/storage/sddr55.c                       |   99 +++-
 drivers/usb/storage/shuttle_usbat.c                |  202 +++++-
 drivers/usb/storage/shuttle_usbat.h                |  123 ----
 drivers/usb/storage/transport.c                    |   10 +
 .../usb/storage/{freecom.h => unusual_alauda.h}    |   29 +-
 .../usb/storage/{sddr55.h => unusual_cypress.h}    |   28 +-
 drivers/usb/storage/unusual_datafab.h              |   98 +++
 drivers/usb/storage/unusual_devs.h                 |  307 +--------
 .../storage/{cypress_atacb.h => unusual_freecom.h} |   19 +-
 drivers/usb/storage/unusual_isd200.h               |   57 ++
 .../usb/storage/{sddr55.h => unusual_jumpshot.h}   |   23 +-
 drivers/usb/storage/{isd200.h => unusual_karma.h}  |   21 +-
 .../usb/storage/{sddr55.h => unusual_onetouch.h}   |   30 +-
 drivers/usb/storage/unusual_sddr09.h               |   56 ++
 drivers/usb/storage/unusual_sddr55.h               |   44 ++
 drivers/usb/storage/unusual_usbat.h                |   43 ++
 drivers/usb/storage/usb.c                          |  344 +++------
 drivers/usb/storage/usb.h                          |   21 +
 drivers/usb/storage/usual-tables.c                 |  116 +++
 drivers/usb/usb-skeleton.c                         |    6 +-
 drivers/usb/wusbcore/cbaf.c                        |    3 +-
 drivers/usb/wusbcore/devconnect.c                  |    2 +
 drivers/usb/wusbcore/security.c                    |    2 +
 include/linux/usb.h                                |  184 +-----
 include/linux/usb/ch9.h                            |  183 +++++-
 include/linux/usb/composite.h                      |    8 +
 include/linux/usb/gadget.h                         |    6 +-
 include/linux/usb/otg.h                            |    8 +
 include/linux/usb/quirks.h                         |    3 +
 include/linux/usb/serial.h                         |    3 +-
 include/linux/usb_usual.h                          |   21 +-
 157 files changed, 5188 insertions(+), 3853 deletions(-)
 rename arch/arm/{mach-s3c2410/include/mach => plat-s3c/include/plat}/usb-control.h (84%)
 delete mode 100644 drivers/usb/misc/phidget.c
 delete mode 100644 drivers/usb/misc/phidget.h
 delete mode 100644 drivers/usb/misc/phidgetkit.c
 delete mode 100644 drivers/usb/misc/phidgetmotorcontrol.c
 delete mode 100644 drivers/usb/misc/phidgetservo.c
 create mode 100644 drivers/usb/otg/nop-usb-xceiv.c
 rename drivers/usb/serial/{cp2101.c => cp210x.c} (85%)
 create mode 100644 drivers/usb/serial/qcserial.c
 create mode 100644 drivers/usb/serial/symbolserial.c
 delete mode 100644 drivers/usb/storage/alauda.h
 delete mode 100644 drivers/usb/storage/datafab.h
 delete mode 100644 drivers/usb/storage/jumpshot.h
 delete mode 100644 drivers/usb/storage/karma.h
 delete mode 100644 drivers/usb/storage/onetouch.h
 delete mode 100644 drivers/usb/storage/sddr09.h
 delete mode 100644 drivers/usb/storage/shuttle_usbat.h
 rename drivers/usb/storage/{freecom.h => unusual_alauda.h} (60%)
 copy drivers/usb/storage/{sddr55.h => unusual_cypress.h} (54%)
 create mode 100644 drivers/usb/storage/unusual_datafab.h
 rename drivers/usb/storage/{cypress_atacb.h => unusual_freecom.h} (68%)
 create mode 100644 drivers/usb/storage/unusual_isd200.h
 copy drivers/usb/storage/{sddr55.h => unusual_jumpshot.h} (63%)
 rename drivers/usb/storage/{isd200.h => unusual_karma.h} (63%)
 rename drivers/usb/storage/{sddr55.h => unusual_onetouch.h} (52%)
 create mode 100644 drivers/usb/storage/unusual_sddr09.h
 create mode 100644 drivers/usb/storage/unusual_sddr55.h
 create mode 100644 drivers/usb/storage/unusual_usbat.h
 create mode 100644 drivers/usb/storage/usual-tables.c

---------------

Ajay Kumar Gupta (3):
      USB: otg: adding nop usb transceiver
      USB: musb: NAK timeout scheme on bulk RX endpoint
      USB: musb: only turn off vbus in OTG hosts

Alan Stern (19):
      USB: add quirk to avoid config and interface strings
      USB: usb-storage: increase max_sectors for tape drives
      USB: EHCI: Make timer_action out-of-line
      USB: EHCI: add software retry for transaction errors
      usb-storage: prepare for subdriver separation
      usb-storage: make sddr09 a separate module
      usb-storage: make isd200 a separate module
      usb-storage: make sddr55 a separate module
      usb-storage: make cypress_atacb a separate module
      usb-storage: make shuttle_usbat a separate module
      usb-storage: make freecom a separate module
      usb-storage: make datafab a separate module
      usb-storage: make jumpshot a separate module
      usb-storage: make alauda a separate module
      usb-storage: make karma a separate module
      usb-storage: make onetouch a separate module
      USB: uhci: don't use pseudo negative values
      USB: don't send Set-Interface after reset
      USB: usbfs: remove unneeded "inline" annotations

Alex Stephens (1):
      USB: CP2101 New Device ID

Alexander Shumakovitch (1):
      USB: qcserial: add device id for HP devices

Ben Dooks (4):
      USB: ohci-s3c2410: remove <mach/hardware.h> include
      USB: ohci-s3c2410: fix name of bus clock
      USB: ohci-hcd: Add ARCH_S3C24XX to the ohci-s3c2410.c glue
      USB: S3C: Move usb-control.h to platform include

Boaz Harrosh (1):
      USB: fix USB_STORAGE_CYPRESS_ATACB

Borislav Petkov (1):
      usb_storage: make Kconfig note visible in the console

Catalin Marinas (3):
      USB: Make the isp1760_register function prototype more generic
      USB: Add platform device support for the ISP1760 USB chip
      USB: isp1760: Add a delay before reading the SKIPMAP registers in isp1760-hcd.c

Craig Shelley (2):
      USB: CP2101 Support AN205 baud rates
      USB: CP2101 Reduce Error Logging

D.J. Capelis (1):
      USB: pedantic: spelling correction in comment for ch9.h

Daniel Mack (1):
      USB: allow malformed LANGID descriptors

Darius Augulis (4):
      USB: imx_udc: Fix IMX UDC gadget bugs
      USB: imx_udc: Fix IMX UDC gadget code style
      USB: imx_udc: Fix IMX UDC gadget ep0 irq handling
      USB: imx_udc: Fix IMX UDC gadget general irq handling

Dave Young (1):
      usb-serial: fix usb_serial_register bug when boot with nousb param

David Brownell (5):
      USB: gadget: fix rndis regression
      USB: ftdi_sio: remove pointless syslog spew
      USB: musb: partial DaVinci dm355 support
      USB: gadget: composite device-level suspend/resume hooks
      USB: gadget: gadget zero uses new suspend/resume hooks

David Vrabel (1):
      USB: allow libusb to talk to unauthenticated WUSB devices

Felipe Balbi (1):
      USB: composite: avoid inconsistent lock state

Frank Seidel (1):
      USB: add missing KERN_* constants to printks

Giuseppe GORGOGLIONE (1):
      USB: musb: fix init oops crash with static FIFO config

Greg Kroah-Hartman (9):
      USB: serial: opticon: add write support
      USB: serial: opticon: add serial line ioctls
      USB: serial: add symbol serial driver
      USB: symbolserial: log the ioctl commands
      USB: serial: add qualcomm wireless modem driver
      USB: make transfer_buffer_lengths in struct urb field u32
      USB: make actual_length in struct urb field u32
      USB: remove phidget drivers from kernel tree.
      USB: serial: rename cp2101 driver to cp210x

Hannes Eder (1):
      USB: host: fix sparse warning: Using plain integer as NULL pointer

Harvey Harrison (1):
      USB: replace uses of __constant_{endian}

Huang Weiyi (1):
      USB: gadget: remove duplicated #include

James Woodcock (1):
      USB: serial: refuse to open recently removed USB Serial devices

Johannes Weiner (1):
      USB: use kzfree()

Jouni Hogander (1):
      USB: TWL: disable VUSB regulators when cable unplugged

Julia Lawall (4):
      USB: Move definitions from usb.h to usb/ch9.h
      USB: ub: use USB API functions rather than constants
      USB: Remove redundant test in pxa27x_udc and ftdi_sio
      USB: drivers: use USB API functions rather than constants

Maciej Grela (1):
      USB: usb-storage: added missing MODULE_LICENSE("GPL") for usb-storage ums-* modules

Mark Ellis (1):
      USB: ipaq: handle 4 endpoint devices

Matt Kraai (1):
      USB: skeleton: Use dev_info instead of info

Ming Lei (1):
      USB: ch341 serial: fix port number changed after resume

Oliver Neukum (7):
      USB: suspend/resume support for option driver
      USB: suspend/resume for opticon driver
      USB: serial: introduce a flag into the usb serial layer to tell drivers that their URBs are killed due to suspension
      USB: serial generic resume function fix
      USB: serial: export symbol of usb_serial_generic_resume
      USB: serial: use generic method if no alternative is provided in usb serial layer
      USB: serial: remove recourse to generic method

Pete Zaitcev (2):
      usblp: continuously poll for status
      USB: usbmon: Add binary API v1

Randy Dunlap (1):
      USB: fix ehci printk formats

Robert Jarzmik (5):
      USB: gpio_vbus: add delayed vbus_session calls
      USB: pxa27x_udc: factor pullup code to prepare otg transceiver
      USB: pxa27x_udc: add vbus session handling
      USB: pxa27x_udc: add otg transceiver support
      USB: pxa27x_udc: add vbus_draw callback

Roel Kluin (2):
      USB: count reaches -1, tested 0
      USB: more u32 conversion after transfer_buffer_length and actual_length

Sergei Shtylyov (1):
      USB: musb: rewrite host periodic endpoint allocation

Thierry Vignaud (1):
      usb: kill prehistorical comments about USB_EHCI_HCD

Vernon Sauder (1):
      USB: pxa27x_udc: typo fixes and code cleanups

VomLehn (1):
      USB: Fix cp2101 USB serial device driver termios functions for console use

Werner Cornelius (1):
      USB: usb-serial ch341: support for DTR/RTS/CTS

Yoshihiro Shimoda (1):
      USB: r8a66597-hcd: suspend/resume support


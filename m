Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYJQWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYJQWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYJQWEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:04:16 -0400
Received: from kroah.org ([198.145.64.141]:40158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753757AbYJQWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:04:14 -0400
Date: Fri, 17 Oct 2008 15:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081017220027.GA3659@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big batch of USB patches for your 2.6-git tree.

These paches are:
	- a few new USB drivers.
	- new device ids
	- lots of bugfixes
	- additions to the USB api to make driver writer's lives easier.
	- removals of usb macros that don't make sense to use anymore
	  (warn() and info() should be using dev_warn() and dev_info()).
	- other minor things.

All of these patches have been in the -next and -mm trees for quite a
while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/stable/sysfs-driver-usb-usbtmc   |   62 +
 Documentation/ABI/testing/sysfs-bus-usb            |   16 +
 .../ABI/testing/sysfs-bus-usb-devices-usbsevseg    |   43 +
 Documentation/DocBook/gadget.tmpl                  |    3 +
 Documentation/devices.txt                          |    3 +
 Documentation/ioctl-number.txt                     |    3 +
 Documentation/kernel-parameters.txt                |   19 +
 Documentation/usb/anchors.txt                      |   17 +
 Documentation/usb/misc_usbsevseg.txt               |   46 +
 Documentation/usb/power-management.txt             |    8 +-
 drivers/block/ub.c                                 |    3 -
 drivers/hid/usbhid/hid-core.c                      |    4 +-
 drivers/input/joystick/iforce/iforce-ff.c          |   36 +-
 drivers/input/joystick/iforce/iforce-main.c        |   14 +-
 drivers/input/joystick/iforce/iforce-packets.c     |    8 +-
 drivers/input/joystick/iforce/iforce-usb.c         |    2 +-
 drivers/input/joystick/xpad.c                      |    2 +-
 drivers/input/misc/ati_remote.c                    |   20 +-
 drivers/input/misc/yealink.c                       |    3 +-
 drivers/input/tablet/acecad.c                      |    3 +-
 drivers/input/tablet/aiptek.c                      |   26 +-
 drivers/input/tablet/gtco.c                        |    4 +-
 drivers/input/tablet/kbtab.c                       |    3 +-
 drivers/input/tablet/wacom_sys.c                   |    3 +-
 drivers/media/radio/dsbr100.c                      |   13 +-
 drivers/media/video/dabusb.c                       |    4 +-
 drivers/media/video/ov511.c                        |   19 +-
 drivers/media/video/usbvideo/konicawc.c            |    8 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |   14 +-
 drivers/mtd/nand/alauda.c                          |    4 +-
 drivers/net/irda/kingsun-sir.c                     |    3 +-
 drivers/net/irda/ks959-sir.c                       |    3 +-
 drivers/net/irda/ksdazzle-sir.c                    |    3 +-
 drivers/net/irda/stir4200.c                        |   18 +-
 drivers/net/usb/catc.c                             |    8 +-
 drivers/net/usb/kaweth.c                           |   27 +-
 drivers/net/usb/rtl8150.c                          |   31 +-
 drivers/usb/atm/usbatm.c                           |   10 +-
 drivers/usb/atm/usbatm.h                           |   10 +-
 drivers/usb/atm/xusbatm.c                          |    2 +-
 drivers/usb/class/Kconfig                          |   10 +
 drivers/usb/class/Makefile                         |    1 +
 drivers/usb/class/cdc-acm.c                        |   26 +-
 drivers/usb/class/cdc-wdm.c                        |   48 +-
 drivers/usb/class/usblp.c                          |   25 +-
 drivers/usb/class/usbtmc.c                         | 1087 ++++++++
 drivers/usb/core/Kconfig                           |    2 +-
 drivers/usb/core/devio.c                           |   12 +-
 drivers/usb/core/driver.c                          |    3 +-
 drivers/usb/core/endpoint.c                        |    3 +-
 drivers/usb/core/file.c                            |    5 +-
 drivers/usb/core/hcd.c                             |    4 +
 drivers/usb/core/hcd.h                             |    6 +
 drivers/usb/core/hub.c                             |  102 +-
 drivers/usb/core/inode.c                           |   18 +-
 drivers/usb/core/message.c                         |    3 +-
 drivers/usb/core/sysfs.c                           |   24 +
 drivers/usb/core/urb.c                             |  169 ++-
 drivers/usb/gadget/Kconfig                         |  315 ++-
 drivers/usb/gadget/Makefile                        |    1 +
 drivers/usb/gadget/cdc2.c                          |    1 -
 drivers/usb/gadget/composite.c                     |   68 +-
 drivers/usb/gadget/dummy_hcd.c                     |   33 +-
 drivers/usb/gadget/ether.c                         |    2 -
 drivers/usb/gadget/f_loopback.c                    |    1 -
 drivers/usb/gadget/f_obex.c                        |  493 ++++
 drivers/usb/gadget/f_sourcesink.c                  |    1 -
 drivers/usb/gadget/file_storage.c                  |   23 +-
 drivers/usb/gadget/fsl_qe_udc.c                    | 2760 ++++++++++++++++++++
 drivers/usb/gadget/fsl_qe_udc.h                    |  437 ++++
 drivers/usb/gadget/fsl_usb2_udc.c                  |  176 +-
 drivers/usb/gadget/fsl_usb2_udc.h                  |   21 +-
 drivers/usb/gadget/gadget_chips.h                  |    9 +
 drivers/usb/gadget/gmidi.c                         |    2 +-
 drivers/usb/gadget/net2280.c                       |   40 +-
 drivers/usb/gadget/net2280.h                       |    1 +
 drivers/usb/gadget/omap_udc.c                      |    7 +
 drivers/usb/gadget/printer.c                       |    6 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    1 -
 drivers/usb/gadget/s3c2410_udc.c                   |    2 +-
 drivers/usb/gadget/serial.c                        |   15 +-
 drivers/usb/gadget/u_ether.c                       |    7 +
 drivers/usb/gadget/u_serial.h                      |    1 +
 drivers/usb/host/ehci-dbg.c                        |   56 +-
 drivers/usb/host/ehci-hcd.c                        |   48 +-
 drivers/usb/host/ehci-hub.c                        |   27 +-
 drivers/usb/host/ehci-ppc-soc.c                    |  201 --
 drivers/usb/host/ehci.h                            |   23 +-
 drivers/usb/host/isp116x-hcd.c                     |   13 +-
 drivers/usb/host/isp1760-if.c                      |    7 +-
 drivers/usb/host/ohci-dbg.c                        |    2 +-
 drivers/usb/host/ohci-hcd.c                        |   10 +-
 drivers/usb/host/ohci-hub.c                        |   87 +-
 drivers/usb/host/ohci-omap.c                       |    4 +-
 drivers/usb/host/ohci-pnx4008.c                    |    2 +-
 drivers/usb/host/ohci.h                            |    8 -
 drivers/usb/host/r8a66597-hcd.c                    |  101 +-
 drivers/usb/host/sl811-hcd.c                       |   15 +-
 drivers/usb/host/uhci-hcd.c                        |   10 +-
 drivers/usb/host/uhci-q.c                          |   17 +-
 drivers/usb/image/mdc800.c                         |   61 +-
 drivers/usb/misc/Kconfig                           |   24 +
 drivers/usb/misc/Makefile                          |    2 +
 drivers/usb/misc/adutux.c                          |   22 +-
 drivers/usb/misc/appledisplay.c                    |   26 +-
 drivers/usb/misc/cypress_cy7c63.c                  |    6 +-
 drivers/usb/misc/cytherm.c                         |    9 +-
 drivers/usb/misc/emi26.c                           |   17 +-
 drivers/usb/misc/emi62.c                           |    4 +-
 drivers/usb/misc/ftdi-elan.c                       |   10 +-
 drivers/usb/misc/idmouse.c                         |    5 +-
 drivers/usb/misc/legousbtower.c                    |   23 +-
 drivers/usb/misc/rio500.c                          |   11 +-
 drivers/usb/misc/trancevibrator.c                  |    3 +-
 drivers/usb/misc/usblcd.c                          |   13 +-
 drivers/usb/misc/usbsevseg.c                       |  394 +++
 drivers/usb/misc/uss720.c                          |   19 +-
 drivers/usb/misc/vstusb.c                          |  782 ++++++
 drivers/usb/mon/mon_main.c                         |    2 +-
 drivers/usb/musb/Kconfig                           |    4 -
 drivers/usb/musb/cppi_dma.h                        |    4 +-
 drivers/usb/musb/davinci.c                         |   20 +-
 drivers/usb/musb/musb_core.c                       |   41 +-
 drivers/usb/musb/musb_gadget_ep0.c                 |   24 +-
 drivers/usb/musb/musb_host.c                       |   19 +-
 drivers/usb/musb/musb_io.h                         |    4 +-
 drivers/usb/musb/musbhsdma.c                       |  306 ++--
 drivers/usb/serial/aircable.c                      |    8 +-
 drivers/usb/serial/belkin_sa.c                     |   39 +-
 drivers/usb/serial/cp2101.c                        |    3 +-
 drivers/usb/serial/cyberjack.c                     |   28 +-
 drivers/usb/serial/cypress_m8.c                    |   21 +-
 drivers/usb/serial/digi_acceleport.c               |   68 +-
 drivers/usb/serial/empeg.c                         |   11 +-
 drivers/usb/serial/ezusb.c                         |    3 +-
 drivers/usb/serial/ftdi_sio.c                      |   82 +-
 drivers/usb/serial/ftdi_sio.h                      |    5 +
 drivers/usb/serial/garmin_gps.c                    |    3 +-
 drivers/usb/serial/hp4x.c                          |    3 +-
 drivers/usb/serial/io_edgeport.c                   |   19 +-
 drivers/usb/serial/io_ti.c                         |    3 +-
 drivers/usb/serial/ipaq.c                          |   30 +-
 drivers/usb/serial/ipw.c                           |    3 +-
 drivers/usb/serial/ir-usb.c                        |    3 +-
 drivers/usb/serial/iuu_phoenix.c                   |    3 +-
 drivers/usb/serial/keyspan.c                       |    3 +-
 drivers/usb/serial/keyspan_pda.c                   |   17 +-
 drivers/usb/serial/kl5kusb105.c                    |   69 +-
 drivers/usb/serial/kobil_sct.c                     |    4 +-
 drivers/usb/serial/mct_u232.c                      |   42 +-
 drivers/usb/serial/mos7720.c                       |   22 +-
 drivers/usb/serial/mos7840.c                       |   29 +-
 drivers/usb/serial/omninet.c                       |   22 +-
 drivers/usb/serial/option.c                        |   42 +-
 drivers/usb/serial/pl2303.c                        |    2 +-
 drivers/usb/serial/safe_serial.c                   |   28 +-
 drivers/usb/serial/sierra.c                        |   72 +-
 drivers/usb/serial/spcp8x5.c                       |   10 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |    4 +-
 drivers/usb/serial/usb-serial.c                    |   26 +-
 drivers/usb/serial/visor.c                         |   17 +-
 drivers/usb/serial/whiteheat.c                     |  121 +-
 drivers/usb/storage/onetouch.c                     |    9 +-
 drivers/usb/storage/transport.c                    |    2 +-
 include/linux/usb.h                                |    7 +
 include/linux/usb/Kbuild                           |    3 +-
 include/linux/usb/cdc.h                            |    9 +
 include/linux/usb/composite.h                      |   11 +-
 include/linux/usb/serial.h                         |    2 +-
 include/linux/usb/tmc.h                            |   43 +
 include/linux/usb/vstusb.h                         |   71 +
 171 files changed, 8474 insertions(+), 1533 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-usb-usbtmc
 create mode 100644 Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
 create mode 100644 Documentation/usb/misc_usbsevseg.txt
 create mode 100644 drivers/usb/class/usbtmc.c
 create mode 100644 drivers/usb/gadget/f_obex.c
 create mode 100644 drivers/usb/gadget/fsl_qe_udc.c
 create mode 100644 drivers/usb/gadget/fsl_qe_udc.h
 delete mode 100644 drivers/usb/host/ehci-ppc-soc.c
 create mode 100644 drivers/usb/misc/usbsevseg.c
 create mode 100644 drivers/usb/misc/vstusb.c
 create mode 100644 include/linux/usb/tmc.h
 create mode 100644 include/linux/usb/vstusb.h

---------------

Ajay Kumar Gupta (2):
      OMAP:MUSB: Fixes the TT programming.
      OMAP:MUSB: Corrects urb unlink function path

Alan Stern (11):
      USB: gadget: dummy_hcd: implement set_wedge
      USB: gadget: net2280: implement set_wedge
      usb-storage: report underflow with no sense data
      OHCI: Allow broken controllers to auto-stop
      USB: change hub initialization sleeps to delayed_work
      USB: UHCI: improve scheduling of interrupt URBs
      USB: EHCI, OHCI, UHCI: remove version numbers
      USB: EHCI: log a warning if ehci-hcd is not loaded first
      USB: snoop processes opening usbfs device files
      USB: EHCI: fix remote-wakeup support for ARC/TDI core
      USB: OHCI: fix endless polling behavior

Arjan van de Ven (1):
      usbmon: fix tiny race exposed by the fastboot patches

Bryan Wu (1):
      usb: musb: do not mess up count number and CSR0 register value

Dan Williams (2):
      USB: option: add Ericsson F3507g and Dell 5530
      USB: option: add Pantech cards

David Brownell (6):
      usb: gadget Kconfig cleanup
      usb gadget: function activation/deactivation
      usb gadget: defer obex enumeration
      usb gadget: USB_GADGET_VBUS_DRAW Kconfig option
      usb: musb_hdrc build fixes
      usb gadget: cdc ethernet notification bugfix

Denis Joseph Barrow (1):
      USB: option.c remove duplicate device ids now supported in hso.c

Felipe Balbi (5):
      usb gadget: cdc obex glue
      usb: gadget: workaround storage command size issues
      musb: io: only define read/write stubs if they're not defined yet
      usb: musb: general cleanup to musbhsdma.c
      usb: musb: remove dead code from procfs

Geoff Levand (2):
      USB: Fix doc for usb_autopm_enable
      USB: Fix spelling in usb/serial.h

Greg Kroah-Hartman (17):
      USB: add USB test and measurement class driver
      USB: remove warn() macro from usb input drivers
      USB: remove warn() macro from usb media drivers
      USB: remove warn() macro from usb net drivers
      USB: remove warn() macro from usb drivers
      USB: remove warn macro from HID core
      USB: remove info() macro from usb/serial drivers
      USB: remove info() macro from usb/misc drivers
      USB: remove info() macro from remaining usb drivers
      USB: remove info() macro from usb network drivers
      USB: remove info() macro from usb input drivers
      USB: remove info() macro from usb mtd drivers
      USB: remove use of err() in drivers/usb/serial
      USB: remove err() macro from usb class drivers
      USB: remove err() macro from usb core code
      USB: remove err() macro from usb misc drivers
      USB: remove err() macro from more usb drivers

Harrison Metzger (1):
      USB: Added driver for a Delcom USB 7-segment LED Display

Huang Weiyi (2):
      USB: remove unused #include <version.h>
      USB: ti_usb_3410_5052: removed duplicated include

Jaroslav Kysela (1):
      USB: hub.c: Add initial_descriptor_timeout module parameter for usbcore

Jon K Hellan (1):
      USB: Option / AnyData new modem, same ID

Julia Lawall (1):
      drivers/usb/class/usblp.c: adjust error handling code

Julien Brunel (2):
      USB: drivers/usb/misc: Use an IS_ERR test rather than a NULL test
      USB: isp1760: Use an IS_ERR test rather than a NULL test

Kevin Hilman (1):
      MUSB: Add sanity check for maximum number of endpoints

Kevin Lloyd (1):
      USB Serial: Sierra: debug message fix

Kumar Gala (1):
      usb: remove code associated with !CONFIG_PPC_MERGE

Li Yang (3):
      usb: add Freescale QE/CPM USB peripheral controller driver
      usb/fsl_qe_udc: fix response to get status request
      usb/fsl_qe_udc: clear data toggle on clear halt request

Marc Zyngier (1):
      USB: Let some USB host controllers get IRQ flags from resource

Ming Lei (2):
      USB: ehci-dbg: increase debug buffer size for periodic file
      USB: ehci-dbg: fix reading less content of periodic file

Oliver Neukum (5):
      USB: kill URBs permanently
      USB: extend poisoning to anchors
      USB: Documentation/usb/anchors.txt #2
      USB: RESET_RESUME needs to block autosuspend when remote wakeup is needed
      USB: anchor API changes needed for btusb

Paulius Zaleckas (1):
      USB: ftdi_sio: fix 'product' parameter description

Pete Zaitcev (1):
      ub: remove sg_stat

Peter Korsgaard (1):
      usb core: fix USB_OTG_BLACKLIST_HUB typo

SangSu Park (1):
      USB: g_printer: fix handling zero-length packet

Sarah Sharp (2):
      USB: ftdi-elan: Always pass usb_bulk_msg() a timeout in milliseconds.
      USB: Export if an interface driver supports autosuspend.

Stephen Ware (2):
      usb: vstusb.c : new driver for spectrometers used by Vernier Software & Technology, Inc.
      USB: fix up problems in the vtusb driver

Tony Lindgren (2):
      USB: ohci-omap: handle other omap15xx chips
      USB: omap_udc: sync with OMAP tree

Vladimir Vukicevic (1):
      USB: Add Oceanic product ID to ftdi_sio

Will Newton (11):
      fsl_usb2_udc: Make dr_ep_setup function static.
      fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
      fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
      fsl_usb2_udc: Clean up whitespace in errors and warnings.
      fsl_usb2_udc: Clean up whitespace in /proc debugging output.
      fsl_usb2_udc: Initialize spinlock earlier.
      fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
      fsl_usb2_udc: Uninline udc_reset_ep_queue.
      fsl_usb2_udc: Make fsl_queue_td return type void.
      fsl_usb2_udc: Add a wmb before priming endpoint.
      fsl_usb2_udc: Fix oops on probe failure.

Yauhen Kharuzhy (1):
      USB: Fix s3c2410_udc usb speed handling

Yi Yang (1):
      USB: improve ehci_watchdog's side effect in CPU power management


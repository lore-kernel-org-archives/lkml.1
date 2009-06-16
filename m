Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZFPFSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZFPFSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZFPFSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:18:02 -0400
Received: from kroah.org ([198.145.64.141]:34229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZFPFR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:17:57 -0400
Date: Mon, 15 Jun 2009 22:13:56 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.30-git
Message-ID: <20090616051356.GB23627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB patch queue for your kernel tree.

Stuff in here:
  - USB 3.0 support!
  - various new drivers
  - utf-8 bugfixes and proper handling by the usb core now (that makes
    up the majority of the non-usb patches in the diffstat below)
  - USB power management work
  - USB core cleanups for debugging code and other minor stuff
  - various bugfixes that were too big to go into .30

All of the non-USB related patches (like the PCI core one which the USB
core needs) have been acked by the respective subsystem maintainer to be
sent through this tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 MAINTAINERS                                        |    6 +
 .../arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h |   50 +
 arch/arm/plat-s3c/include/plat/regs-usb-hsotg.h    |  377 +++
 drivers/pci/pci.c                                  |    5 +
 drivers/staging/uc2322/aten2011.c                  |    4 +-
 drivers/usb/Kconfig                                |    1 +
 drivers/usb/Makefile                               |    1 +
 drivers/usb/class/cdc-acm.c                        |   71 +-
 drivers/usb/class/cdc-acm.h                        |    2 +
 drivers/usb/class/usbtmc.c                         |    6 +
 drivers/usb/core/Kconfig                           |   16 +-
 drivers/usb/core/Makefile                          |    4 +-
 drivers/usb/core/config.c                          |  192 ++-
 drivers/usb/core/driver.c                          |   56 +-
 drivers/usb/core/endpoint.c                        |  160 +-
 drivers/usb/core/hcd-pci.c                         |  244 +-
 drivers/usb/core/hcd.c                             |  220 ++-
 drivers/usb/core/hcd.h                             |   55 +-
 drivers/usb/core/hub.c                             |  134 +-
 drivers/usb/core/hub.h                             |    3 +
 drivers/usb/core/message.c                         |  194 +-
 drivers/usb/core/sysfs.c                           |   12 +-
 drivers/usb/core/urb.c                             |   12 +
 drivers/usb/core/usb.c                             |   76 +-
 drivers/usb/core/usb.h                             |   13 +-
 drivers/usb/gadget/Kconfig                         |   53 +-
 drivers/usb/gadget/Makefile                        |    8 +
 drivers/usb/gadget/at91_udc.c                      |    4 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   20 +-
 drivers/usb/gadget/audio.c                         |  302 ++
 drivers/usb/gadget/ci13xxx_udc.c                   |    6 +-
 drivers/usb/gadget/f_audio.c                       |  707 ++++
 drivers/usb/gadget/f_rndis.c                       |    4 +-
 drivers/usb/gadget/file_storage.c                  |   93 +-
 drivers/usb/gadget/fsl_mx3_udc.c                   |   95 +
 .../usb/gadget/{fsl_usb2_udc.c => fsl_udc_core.c}  |   69 +-
 drivers/usb/gadget/fsl_usb2_udc.h                  |   18 +
 drivers/usb/gadget/gadget_chips.h                  |    8 +
 drivers/usb/gadget/goku_udc.c                      |    6 +-
 drivers/usb/gadget/imx_udc.c                       |   14 +-
 drivers/usb/gadget/inode.c                         |   14 +-
 drivers/usb/gadget/langwell_udc.c                  | 3373 ++++++++++++++++++++
 drivers/usb/gadget/langwell_udc.h                  |  228 ++
 drivers/usb/gadget/pxa27x_udc.c                    |   71 +-
 drivers/usb/gadget/pxa27x_udc.h                    |    2 +
 drivers/usb/gadget/s3c-hsotg.c                     | 3269 +++++++++++++++++++
 drivers/usb/gadget/u_audio.c                       |  319 ++
 drivers/usb/gadget/u_audio.h                       |   56 +
 drivers/usb/gadget/u_serial.c                      |    1 +
 drivers/usb/host/Kconfig                           |   20 +
 drivers/usb/host/Makefile                          |    2 +
 drivers/usb/host/ehci-au1xxx.c                     |    1 +
 drivers/usb/host/ehci-fsl.c                        |    1 +
 drivers/usb/host/ehci-hcd.c                        |   47 +-
 drivers/usb/host/ehci-hub.c                        |    4 +-
 drivers/usb/host/ehci-ixp4xx.c                     |    1 +
 drivers/usb/host/ehci-orion.c                      |    3 +-
 drivers/usb/host/ehci-pci.c                        |   27 +-
 drivers/usb/host/ehci-ppc-of.c                     |    1 +
 drivers/usb/host/ehci-ps3.c                        |    1 +
 drivers/usb/host/ehci-q.c                          |   19 +-
 drivers/usb/host/ehci-sched.c                      |    8 +-
 drivers/usb/host/ehci.h                            |    1 +
 drivers/usb/host/fhci-dbg.c                        |    2 +-
 drivers/usb/host/hwa-hc.c                          |   21 -
 drivers/usb/host/ohci-dbg.c                        |   31 +-
 drivers/usb/host/ohci-hcd.c                        |   38 +-
 drivers/usb/host/ohci-pci.c                        |   24 +-
 drivers/usb/host/pci-quirks.c                      |  123 +
 drivers/usb/host/r8a66597-hcd.c                    |   62 +-
 drivers/usb/host/r8a66597.h                        |   38 +-
 drivers/usb/host/uhci-hcd.c                        |   23 +-
 drivers/usb/host/uhci-q.c                          |    2 +-
 drivers/usb/host/xhci-dbg.c                        |  485 +++
 drivers/usb/host/xhci-ext-caps.h                   |  145 +
 drivers/usb/host/xhci-hcd.c                        | 1274 ++++++++
 drivers/usb/host/xhci-hub.c                        |  308 ++
 drivers/usb/host/xhci-mem.c                        |  769 +++++
 drivers/usb/host/xhci-pci.c                        |  166 +
 drivers/usb/host/xhci-ring.c                       | 1648 ++++++++++
 drivers/usb/host/xhci.h                            | 1157 +++++++
 drivers/usb/misc/sisusbvga/Kconfig                 |    2 +-
 drivers/usb/misc/usbtest.c                         |   39 +-
 drivers/usb/mon/mon_text.c                         |    2 +-
 drivers/usb/musb/Kconfig                           |    2 +
 drivers/usb/musb/blackfin.c                        |   11 +-
 drivers/usb/musb/cppi_dma.c                        |   34 +-
 drivers/usb/musb/cppi_dma.h                        |    6 +-
 drivers/usb/musb/davinci.c                         |   54 +-
 drivers/usb/musb/musb_core.c                       |  228 +-
 drivers/usb/musb/musb_core.h                       |   22 +-
 drivers/usb/musb/musb_gadget.c                     |   45 +-
 drivers/usb/musb/musb_gadget_ep0.c                 |   45 +-
 drivers/usb/musb/musb_host.c                       |  273 +-
 drivers/usb/musb/musb_host.h                       |    1 +
 drivers/usb/musb/musb_virthub.c                    |   35 +-
 drivers/usb/musb/omap2430.c                        |   71 +-
 drivers/usb/musb/tusb6010.c                        |   70 +-
 drivers/usb/otg/Kconfig                            |   14 +
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/langwell_otg.c                     | 1915 +++++++++++
 drivers/usb/otg/nop-usb-xceiv.c                    |   25 +-
 drivers/usb/otg/twl4030-usb.c                      |   28 +-
 drivers/usb/serial/aircable.c                      |    5 +-
 drivers/usb/serial/belkin_sa.c                     |    7 +-
 drivers/usb/serial/bus.c                           |   27 +-
 drivers/usb/serial/cp210x.c                        |    6 +-
 drivers/usb/serial/cyberjack.c                     |   20 +-
 drivers/usb/serial/cypress_m8.c                    |   11 +-
 drivers/usb/serial/digi_acceleport.c               |   20 +-
 drivers/usb/serial/empeg.c                         |    8 -
 drivers/usb/serial/ftdi_sio.c                      |  179 +-
 drivers/usb/serial/ftdi_sio.h                      |   13 +-
 drivers/usb/serial/garmin_gps.c                    |  214 +-
 drivers/usb/serial/generic.c                       |  186 +-
 drivers/usb/serial/io_edgeport.c                   |   29 +-
 drivers/usb/serial/io_tables.h                     |   12 +-
 drivers/usb/serial/io_ti.c                         |   22 +-
 drivers/usb/serial/ipaq.c                          |    7 -
 drivers/usb/serial/iuu_phoenix.c                   |    6 +-
 drivers/usb/serial/keyspan.c                       |   13 +-
 drivers/usb/serial/keyspan.h                       |   12 +-
 drivers/usb/serial/keyspan_pda.c                   |    4 +-
 drivers/usb/serial/kl5kusb105.c                    |   39 +-
 drivers/usb/serial/kobil_sct.c                     |   12 +-
 drivers/usb/serial/mct_u232.c                      |   13 +-
 drivers/usb/serial/mos7720.c                       |    9 +-
 drivers/usb/serial/mos7840.c                       |  358 ++-
 drivers/usb/serial/omninet.c                       |   19 +-
 drivers/usb/serial/opticon.c                       |   14 +-
 drivers/usb/serial/option.c                        |   41 +-
 drivers/usb/serial/oti6858.c                       |    7 +-
 drivers/usb/serial/pl2303.c                        |   10 +-
 drivers/usb/serial/sierra.c                        |  185 +-
 drivers/usb/serial/spcp8x5.c                       |    5 +-
 drivers/usb/serial/symbolserial.c                  |   14 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 +-
 drivers/usb/serial/usb-serial.c                    |   53 +-
 drivers/usb/serial/usb_debug.c                     |   41 +
 drivers/usb/serial/visor.c                         |   13 +-
 drivers/usb/serial/whiteheat.c                     |    6 +-
 drivers/usb/storage/initializers.c                 |   14 +-
 drivers/usb/storage/option_ms.c                    |  124 +-
 drivers/usb/storage/sierra_ms.c                    |    2 +-
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 fs/befs/linuxvfs.c                                 |   20 +-
 fs/fat/dir.c                                       |   29 +-
 fs/fat/namei_vfat.c                                |    4 +-
 fs/isofs/joliet.c                                  |   36 +-
 fs/ncpfs/ncplib_kernel.c                           |    8 +-
 fs/nls/nls_base.c                                  |  166 +-
 fs/nls/nls_utf8.c                                  |   13 +-
 include/linux/nls.h                                |   35 +-
 include/linux/pci.h                                |    8 +
 include/linux/pci_ids.h                            |    1 +
 include/linux/usb.h                                |   34 +-
 include/linux/usb/audio.h                          |  265 ++-
 include/linux/usb/ch9.h                            |   17 +
 include/linux/usb/composite.h                      |    3 +
 include/linux/usb/langwell_otg.h                   |  177 +
 include/linux/usb/langwell_udc.h                   |  310 ++
 include/linux/usb/otg.h                            |    4 +-
 include/linux/usb/r8a66597.h                       |   44 +
 include/linux/usb/serial.h                         |   32 +-
 164 files changed, 20947 insertions(+), 2080 deletions(-)
 create mode 100644 arch/arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h
 create mode 100644 arch/arm/plat-s3c/include/plat/regs-usb-hsotg.h
 create mode 100644 drivers/usb/gadget/audio.c
 create mode 100644 drivers/usb/gadget/f_audio.c
 create mode 100644 drivers/usb/gadget/fsl_mx3_udc.c
 rename drivers/usb/gadget/{fsl_usb2_udc.c => fsl_udc_core.c} (99%)
 create mode 100644 drivers/usb/gadget/langwell_udc.c
 create mode 100644 drivers/usb/gadget/langwell_udc.h
 create mode 100644 drivers/usb/gadget/s3c-hsotg.c
 create mode 100644 drivers/usb/gadget/u_audio.c
 create mode 100644 drivers/usb/gadget/u_audio.h
 create mode 100644 drivers/usb/host/xhci-dbg.c
 create mode 100644 drivers/usb/host/xhci-ext-caps.h
 create mode 100644 drivers/usb/host/xhci-hcd.c
 create mode 100644 drivers/usb/host/xhci-hub.c
 create mode 100644 drivers/usb/host/xhci-mem.c
 create mode 100644 drivers/usb/host/xhci-pci.c
 create mode 100644 drivers/usb/host/xhci-ring.c
 create mode 100644 drivers/usb/host/xhci.h
 create mode 100644 drivers/usb/otg/langwell_otg.c
 create mode 100644 include/linux/usb/langwell_otg.h
 create mode 100644 include/linux/usb/langwell_udc.h
 create mode 100644 include/linux/usb/r8a66597.h

---------------

Ajay Kumar Gupta (1):
      musb: add high bandwidth ISO support

Alan Stern (11):
      USB: consolidate usb_unbind_interface and usb_driver_release_interface
      NLS: update handling of Unicode
      USB: g_file_storage: use the "unaligned" accessors
      PCI: add power-state name strings
      USB: move PCI host controllers to new PM framework
      USB: new flag for resume-from-hibernation
      USB: usb-storage: fix return values from init functions
      USB: EHCI: stagger frames for interrupt transfers
      USB: EHCI: update toggle state for linked QHs
      USB: usb-serial: call port_probe and port_remove at the right times
      USB: usb-serial: replace shutdown with disconnect, release

Anand Gadiyar (1):
      musb: use dma mode 1 for TX if transfer size equals maxpacket (v2)

Andrew Morton (1):
      + drivers-usb-serial-sierrac-fix-printk-warning.patch added to -mm tree

Ben Dooks (1):
      USB: Gadget driver for Samsung HS/OtG block

Bryan Wu (3):
      usb: misc: SiS usbvga dangle: accept MUSB_HDRC as a fast enough host controller
      USB: audio: add USB audio class definitions
      USB: gadget: add USB Audio Gadget driver

Clemens Ladisch (3):
      nls: utf8_wcstombs: use correct buffer size in error case
      nls: utf8_wcstombs: fix buffer overflow
      usb: return device strings in UTF-8

Daniel Glöckner (2):
      USB: gadget: g_serial: append zlp when tx buffer becomes empty
      USB: gadget: imx_udc: don't queue more data when zlp is to be sent

Daniel Mack (1):
      USB: imx_udc: fix leak in imx_ep_alloc_request()

Daniel Suchy (1):
      USB: FTDI-SIO new device ids

David Brownell (7):
      USB: twl4030-usb: fix minor reporting goofage
      USB: nop-usb-xceiv: behave when linked as a module
      musb: proper hookup to transceiver drivers
      musb: otg timer cleanup
      musb: make initial HNP roleswitch work (v2)
      musb: support disconnect after HNP roleswitch
      USB: pxa27x_udc: introduce pxa27x_clear_otgph()

Elina Pasheva (7):
      USB: serial: sierra driver performance improvements
      USB: serial: sierra driver debug info visibility improvement
      USB: serial: sierra driver write path improvements
      USB: serial: sierra driver read path bug fix
      USB: serial: sierra driver zero length packet fix
      USB: serial: sierra driver interrupt urb resubmit fix
      USB: serial: sierra driver sierra_calc_num_ports() fix

FUJITA Tomonori (1):
      USB: replace dma_sync_single and dma_sync_sg with dma_sync_single_for_cpu and dma_sync_sg_for_cpu

Frans Pop (1):
      USB: Avoid PM error messages during resume if a device was disconnected

Greg Kroah-Hartman (13):
      USB: add usb debugfs directory
      USB: EHCI: use the new usb debugfs directory
      USB: FHCI: use the new usb debugfs directory
      USB: OHCI: use the new usb debugfs directory
      USB: UHCI: use the new usb debugfs directory
      USB: usbmon: use the new usb debugfs directory
      USB: add the usbfs devices file to debugfs
      USB: OHCI: use the ohci structure directly in debugfs files.
      USB: EHCI: create sysfs companion files directly in the controller device
      USB: remove unused usb_host class
      USB: usbtmc: fix switch statment
      USB: xhci: fix lots of compiler warnings.
      USB: xhci: fix some compiler warnings in xhci.h

Guennadi Liakhovetski (1):
      USB: gadget: Add i.MX3x support to the fsl_usb2_udc driver

H Hartley Sweeten (3):
      USB: core/sysfs: fix sparse warnings
      USB: host/ohci-hcd.c: fix sparse warnings
      USB: hub.c: fix sparse warnings

Hao Wu (1):
      USB: Add Intel Langwell USB OTG Transceiver Drive

Hermann Kneissel (1):
      USB: garmin_gps: removes usb_reset_device from garmin_close

Jason Wessel (6):
      USB: usb_debug, usb_generic_serial: implement multi urb write
      USB: serial: ftd_sio usb: move status check
      USB: serial: usb_debug,usb_generic_serial: implement sysrq and serial break
      USB: serial: ftd_sio: implement sysrq handling on break
      USB: pl2303 usb_serial: implement sysrq handling on break
      USB: usb_serial: only allow sysrq on a console port

Josua Dietze (1):
      USB: usb-storage: add filter to "option_ms" to leave unrecognized devices alone

Kay Sievers (1):
      usb: convert endpoint devices to bus-less childs of the usb interface

Kir Kolyshkin (1):
      USB: cdc-acm: quirk for Alcatel OT-I650

Mark Adamson (2):
      USB: serial: FTDI: add high speed device support
      USB: ftdi_sio: fix hi-speed device packet size calculation

Martin Fuzzey (1):
      USB: usbtest fix endless loop in unlink tests.

Matthias Kaehlcke (6):
      USB: ci13xxx_udc: use helper functions to determine endpoint type and direction
      USB: atmel_usba_udc: use helper functions to determine endpoint type and direction
      USB: at91_udc: use helper functions to determine endpoint type and direction
      USB: Goku-S: use helper functions to determine endpoint type and direction
      USB: gadgetfs: use helper functions to determine endpoint type and direction
      USB: UHCI queue: use usb_endpoint_type()

Maulik Mankad (1):
      USB: gadget : Fix RNDIS code to pass USB Compliance tests (USBCV) with g_ether

Michele Valzelli (1):
      USB: option.c: add Toshiba 3G HSDPA SM-Bus Minicard device id

Nicolas Ferre (1):
      USB: atmel_usba_udc: change way of specifying bias function

Niilo Minkkinen (1):
      usb: musb: disable OTG AUTOIDLE only with omap3430

Oliver Neukum (1):
      USB: support for cdc-acm of single interface devices

Pascal Terjan (1):
      USB: Ignore storage device in modem mode on DWN-652

Paul Mundt (2):
      wusb: hwa-hc: Drop unused pci_suspend/resume hooks.
      USB: xhci depends on PCI.

Pete Zaitcev (1):
      USB: janitor storage initializers

Randy Dunlap (2):
      USB: composite.h: mark private struct members as private:
      USB: usb.h: change private: kernel-doc for new format requirement

Richard Laager (1):
      USB: Identify Novatel MC760 in option driver

Robert Jarzmik (2):
      USB: pxa27x_udc: compatibility with pxa320 SoC
      USB: pxa27x_udc: single-thread setup requests

Sarah Sharp (34):
      USB: xhci: Support xHCI host controllers and USB 3.0 devices.
      USB: xhci: BIOS handoff and HW initialization.
      USB: xhci: Ring allocation and initialization.
      USB: xhci: Device context array allocation.
      USB: xhci: No-op command queueing and irq handler.
      USB: Add SuperSpeed to the list of USB device speeds.
      USB: Add USB 3.0 roothub support to USB core.
      USB: Don't reset USB 3.0 devices on port change detection.
      USB: Add route string to struct usb_device.
      USB: xhci: Root hub support.
      USB: Support for addressing a USB device under xHCI
      USB: xhci: Allocate and address USB devices
      USB: Support for submitting control URBs under xHCI.
      USB: xhci: Control transfer support.
      USB: Parse and store the SuperSpeed endpoint companion descriptors.
      USB: Support for bandwidth allocation.
      USB: xhci: Bandwidth allocation support
      USB: xhci: Bulk transfer support
      USB: Push scatter gather lists down to host controller drivers.
      USB: xhci: Scatter gather list support for bulk transfers.
      USB: xhci: URB cancellation support.
      USB: xhci: Fix register write order.
      USB: xhci: Fix Link TRB handoff bit twiddling.
      USB: xhci: Avoid global namespace pollution.
      USB: xhci: Clean up xhci_irq() function.
      USB: xhci: Avoid compiler reordering in Link TRB giveback.
      USB: Change names of SuperSpeed ep companion descriptor structs.
      USB: xhci: drop spinlock in xhci_urb_enqueue() error path.
      USB: xhci: Make xhci-mem.c include linux/dmapool.h
      usb; xhci: Fix TRB offset calculations.
      USB: xhci: Remove packed attribute from structures.
      USB: xHCI: Fix interrupt moderation.
      USB: xhci: Respect critical sections.
      USB: xhci: Add Makefile, MAINTAINERS, and Kconfig entries.

Scott James Remnant (1):
      USB: usbfs: deprecate and hide option for !embedded

Sergei Shtylyov (8):
      musb_gadget: fix unhandled endpoint 0 IRQs
      musb_gadget: suppress "parasitic" TX interrupts with CPPI
      musb_host: refactor musb_save_toggle() (take 2)
      musb_host: factor out musb_ep_{get|set}_qh()
      musb_host: simplify check for active URB
      musb_host: streamline musb_cleanup_urb() calls
      musb_host: refactor URB giveback
      musb: split out CPPI interrupt handler

Stephen Rothwell (1):
      USB: xhci: use xhci_handle_event instead of handle_event

Tony Cook (1):
      USB: mos7840: fix debug log messages

Uwe Kleine-König (3):
      USB: move twl4030_usb's probe function to .devinit.text
      USB: move r8a66597_hcd's probe function to .devinit.text
      USB: move orion-ehci's probe function to .devinit.text

Viral Mehta (1):
      USB: xhci: replace if-elseif-else with switch-case

Xiaochen Shen (1):
      USB: Add Intel Langwell USB Device Controller driver

Yoshihiro Shimoda (1):
      USB: r8a66597-hcd: use platform_data instead of module_param


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0CBXKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:10:20 -0500
Received: from kroah.org ([198.145.64.141]:34474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab0CBXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:10:15 -0500
Date: Tue, 2 Mar 2010 15:09:48 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.33-git
Message-ID: <20100302230948.GB32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB patchset for the .34 merge window.

There are a few tty patches in here, as they made more sense to go
through here due to the usb-serial drivers they were changing.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-usb       |   11 +
 Documentation/ioctl/ioctl-number.txt          |    1 -
 Documentation/networking/00-INDEX             |    2 +
 Documentation/networking/cxacru-cf.py         |   48 +
 Documentation/networking/cxacru.txt           |   16 +
 Documentation/usb/error-codes.txt             |    6 +-
 Documentation/usb/power-management.txt        |  235 ++--
 arch/arm/configs/rx51_defconfig               |   11 +-
 arch/arm/mach-mx2/devices.c                   |   80 +-
 arch/arm/mach-mx2/devices.h                   |    1 +
 arch/arm/plat-mxc/include/mach/mx21-usbhost.h |   38 +
 arch/avr32/mach-at32ap/at32ap700x.c           |    7 +-
 drivers/char/tty_buffer.c                     |   11 +-
 drivers/hid/usbhid/hiddev.c                   |    7 +-
 drivers/media/video/dabusb.c                  |    8 +-
 drivers/staging/usbip/vhci_sysfs.c            |    2 +-
 drivers/usb/Kconfig                           |    2 +
 drivers/usb/Makefile                          |    1 +
 drivers/usb/atm/cxacru.c                      |  192 ++-
 drivers/usb/atm/usbatm.c                      |    3 +-
 drivers/usb/atm/usbatm.h                      |   15 +
 drivers/usb/c67x00/c67x00-drv.c               |    8 +-
 drivers/usb/class/cdc-acm.c                   |   82 +-
 drivers/usb/class/cdc-acm.h                   |    2 +-
 drivers/usb/class/cdc-wdm.c                   |    2 +-
 drivers/usb/class/usblp.c                     |   22 +-
 drivers/usb/class/usbtmc.c                    |    2 +-
 drivers/usb/core/Kconfig                      |    4 +-
 drivers/usb/core/devices.c                    |   32 +-
 drivers/usb/core/devio.c                      |  127 ++-
 drivers/usb/core/driver.c                     |  918 ++++++-------
 drivers/usb/core/file.c                       |    2 -
 drivers/usb/core/hcd.c                        |   27 +-
 drivers/usb/core/hcd.h                        |   13 +-
 drivers/usb/core/hub.c                        |  120 +-
 drivers/usb/core/message.c                    |    5 +-
 drivers/usb/core/quirks.c                     |   18 +-
 drivers/usb/core/sysfs.c                      |   85 +-
 drivers/usb/core/urb.c                        |   13 +-
 drivers/usb/core/usb.c                        |   38 +-
 drivers/usb/core/usb.h                        |   43 +-
 drivers/usb/early/ehci-dbgp.c                 |   68 +-
 drivers/usb/gadget/Kconfig                    |   10 +
 drivers/usb/gadget/Makefile                   |    2 +
 drivers/usb/gadget/at91_udc.c                 |   10 +-
 drivers/usb/gadget/atmel_usba_udc.c           |    9 +-
 drivers/usb/gadget/atmel_usba_udc.h           |    1 +
 drivers/usb/gadget/epautoconf.c               |   24 +-
 drivers/usb/gadget/ether.c                    |    2 +-
 drivers/usb/gadget/f_acm.c                    |    8 -
 drivers/usb/gadget/f_ecm.c                    |    7 +-
 drivers/usb/gadget/f_mass_storage.c           |   50 +-
 drivers/usb/gadget/f_rndis.c                  |    4 -
 drivers/usb/gadget/file_storage.c             |    8 +-
 drivers/usb/gadget/fsl_qe_udc.c               |    2 +-
 drivers/usb/gadget/gadget_chips.h             |   59 -
 drivers/usb/gadget/gmidi.c                    |    5 -
 drivers/usb/gadget/goku_udc.c                 |    2 +-
 drivers/usb/gadget/inode.c                    |   39 +-
 drivers/usb/gadget/mass_storage.c             |    8 +-
 drivers/usb/gadget/nokia.c                    |  259 ++++
 drivers/usb/gadget/printer.c                  |   18 -
 drivers/usb/gadget/pxa27x_udc.c               |  135 ++-
 drivers/usb/gadget/pxa27x_udc.h               |    6 +
 drivers/usb/gadget/s3c-hsotg.c                |   11 +-
 drivers/usb/gadget/u_ether.c                  |    5 +
 drivers/usb/gadget/u_ether.h                  |    7 -
 drivers/usb/gadget/zero.c                     |    6 +-
 drivers/usb/host/Kconfig                      |   11 +
 drivers/usb/host/Makefile                     |    2 +
 drivers/usb/host/ehci-atmel.c                 |    2 +-
 drivers/usb/host/ehci-au1xxx.c                |    6 +-
 drivers/usb/host/ehci-fsl.c                   |   97 ++-
 drivers/usb/host/ehci-mxc.c                   |   23 +-
 drivers/usb/host/ehci-omap.c                  |   47 +-
 drivers/usb/host/ehci-orion.c                 |    8 +-
 drivers/usb/host/ehci-ppc-of.c                |   14 +-
 drivers/usb/host/ehci-sched.c                 |   12 +-
 drivers/usb/host/ehci-xilinx-of.c             |    8 +-
 drivers/usb/host/fhci-hcd.c                   |    4 +-
 drivers/usb/host/imx21-dbg.c                  |  527 ++++++++
 drivers/usb/host/imx21-hcd.c                  | 1789 +++++++++++++++++++++++++
 drivers/usb/host/imx21-hcd.h                  |  436 ++++++
 drivers/usb/host/isp1362-hcd.c                |   15 +-
 drivers/usb/host/isp1760-hcd.c                |   10 +
 drivers/usb/host/isp1760-if.c                 |    2 +-
 drivers/usb/host/ohci-da8xx.c                 |  456 +++++++
 drivers/usb/host/ohci-dbg.c                   |    4 +-
 drivers/usb/host/ohci-hcd.c                   |    5 +
 drivers/usb/host/ohci-lh7a404.c               |   11 +-
 drivers/usb/host/ohci-pnx4008.c               |    6 +-
 drivers/usb/host/ohci-ppc-of.c                |   10 +-
 drivers/usb/host/ohci-ppc-soc.c               |    8 +-
 drivers/usb/host/ohci-sa1111.c                |    8 +-
 drivers/usb/host/sl811-hcd.c                  |    5 +-
 drivers/usb/host/uhci-hcd.c                   |    1 +
 drivers/usb/host/xhci-dbg.c                   |   19 +
 drivers/usb/host/xhci-ext-caps.h              |    7 +-
 drivers/usb/host/xhci-hcd.c                   |  150 ++-
 drivers/usb/host/xhci-hub.c                   |   65 +-
 drivers/usb/host/xhci-mem.c                   |   47 +-
 drivers/usb/host/xhci-pci.c                   |    1 +
 drivers/usb/host/xhci-ring.c                  |   41 +-
 drivers/usb/host/xhci.h                       |   11 +-
 drivers/usb/image/mdc800.c                    |    2 +-
 drivers/usb/image/microtek.c                  |    4 +-
 drivers/usb/misc/Kconfig                      |   25 -
 drivers/usb/misc/Makefile                     |    2 -
 drivers/usb/misc/adutux.c                     |    8 +-
 drivers/usb/misc/appledisplay.c               |    5 +-
 drivers/usb/misc/berry_charge.c               |  183 ---
 drivers/usb/misc/cypress_cy7c63.c             |    2 +-
 drivers/usb/misc/cytherm.c                    |    2 +-
 drivers/usb/misc/emi26.c                      |    2 +-
 drivers/usb/misc/emi62.c                      |    2 +-
 drivers/usb/misc/ftdi-elan.c                  |   11 +-
 drivers/usb/misc/idmouse.c                    |    2 +-
 drivers/usb/misc/iowarrior.c                  |    6 +-
 drivers/usb/misc/isight_firmware.c            |    4 +-
 drivers/usb/misc/ldusb.c                      |    4 +-
 drivers/usb/misc/legousbtower.c               |   13 +-
 drivers/usb/misc/rio500.c                     |   11 +-
 drivers/usb/misc/sisusbvga/sisusb.c           |   20 +-
 drivers/usb/misc/trancevibrator.c             |    2 +-
 drivers/usb/misc/usblcd.c                     |    7 +-
 drivers/usb/misc/usbled.c                     |    2 +-
 drivers/usb/misc/usbsevseg.c                  |    2 +-
 drivers/usb/misc/usbtest.c                    |    6 +-
 drivers/usb/misc/uss720.c                     |    2 +-
 drivers/usb/misc/vstusb.c                     |  783 -----------
 drivers/usb/mon/mon_bin.c                     |    7 +-
 drivers/usb/mon/mon_text.c                    |    6 +-
 drivers/usb/musb/blackfin.c                   |   28 +-
 drivers/usb/musb/cppi_dma.c                   |   33 +-
 drivers/usb/musb/musb_core.c                  |  562 +++++---
 drivers/usb/musb/musb_core.h                  |   72 +-
 drivers/usb/musb/musb_gadget.c                |   20 +-
 drivers/usb/musb/musb_host.c                  |   34 +-
 drivers/usb/musb/musb_regs.h                  |  101 ++-
 drivers/usb/musb/musbhsdma.c                  |   25 +-
 drivers/usb/musb/musbhsdma.h                  |   17 +
 drivers/usb/musb/omap2430.c                   |   48 +-
 drivers/usb/musb/omap2430.h                   |   32 +-
 drivers/usb/musb/tusb6010.c                   |    2 +-
 drivers/usb/musb/tusb6010_omap.c              |    2 +-
 drivers/usb/otg/twl4030-usb.c                 |   45 +-
 drivers/usb/serial/Kconfig                    |   19 +
 drivers/usb/serial/Makefile                   |    2 +
 drivers/usb/serial/aircable.c                 |   36 +-
 drivers/usb/serial/ark3116.c                  |    3 +-
 drivers/usb/serial/belkin_sa.c                |    2 +-
 drivers/usb/serial/ch341.c                    |   27 +-
 drivers/usb/serial/cp210x.c                   |    7 +-
 drivers/usb/serial/cyberjack.c                |    5 +-
 drivers/usb/serial/cypress_m8.c               |   82 +-
 drivers/usb/serial/digi_acceleport.c          |   38 +-
 drivers/usb/serial/empeg.c                    |    3 +-
 drivers/usb/serial/ftdi_sio.c                 |  195 ++--
 drivers/usb/serial/ftdi_sio.h                 |    6 +-
 drivers/usb/serial/ftdi_sio_ids.h             |   39 +-
 drivers/usb/serial/funsoft.c                  |    2 +-
 drivers/usb/serial/garmin_gps.c               |    3 +-
 drivers/usb/serial/generic.c                  |    7 +-
 drivers/usb/serial/hp4x.c                     |    2 +-
 drivers/usb/serial/io_edgeport.c              |   69 +-
 drivers/usb/serial/io_tables.h                |   10 +-
 drivers/usb/serial/io_ti.c                    |   75 +-
 drivers/usb/serial/ipaq.c                     |    1 -
 drivers/usb/serial/ipw.c                      |    3 +-
 drivers/usb/serial/ir-usb.c                   |   13 +-
 drivers/usb/serial/iuu_phoenix.c              |    2 +-
 drivers/usb/serial/keyspan.c                  |   57 +-
 drivers/usb/serial/keyspan.h                  |   10 +-
 drivers/usb/serial/keyspan_pda.c              |   53 +-
 drivers/usb/serial/kl5kusb105.c               |   66 +-
 drivers/usb/serial/kobil_sct.c                |   25 +-
 drivers/usb/serial/mct_u232.c                 |   57 +-
 drivers/usb/serial/mct_u232.h                 |    2 +
 drivers/usb/serial/mos7720.c                  |  185 +++-
 drivers/usb/serial/mos7840.c                  |   27 +-
 drivers/usb/serial/moto_modem.c               |    2 +-
 drivers/usb/serial/navman.c                   |    3 +-
 drivers/usb/serial/omninet.c                  |    8 +-
 drivers/usb/serial/opticon.c                  |   17 +-
 drivers/usb/serial/option.c                   |   71 +-
 drivers/usb/serial/oti6858.c                  |   36 +-
 drivers/usb/serial/pl2303.c                   |   38 +-
 drivers/usb/serial/qcaux.c                    |   96 ++
 drivers/usb/serial/qcserial.c                 |    2 +-
 drivers/usb/serial/siemens_mpi.c              |    2 +-
 drivers/usb/serial/sierra.c                   |   59 +-
 drivers/usb/serial/spcp8x5.c                  |   27 +-
 drivers/usb/serial/symbolserial.c             |   12 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |    3 +-
 drivers/usb/serial/usb-serial.c               |   15 +-
 drivers/usb/serial/usb_debug.c                |    2 +-
 drivers/usb/serial/visor.c                    |   40 +-
 drivers/usb/serial/vivopay-serial.c           |   76 ++
 drivers/usb/serial/whiteheat.c                |   24 +-
 drivers/usb/storage/onetouch.c                |    2 +-
 drivers/usb/storage/scsiglue.c                |   10 +-
 drivers/usb/storage/shuttle_usbat.c           |   15 +-
 drivers/usb/storage/transport.c               |    6 +
 drivers/usb/storage/unusual_devs.h            |   88 ++-
 drivers/usb/usb-skeleton.c                    |    2 +-
 drivers/usb/wusbcore/cbaf.c                   |    2 +-
 drivers/usb/wusbcore/devconnect.c             |    2 +-
 drivers/usb/wusbcore/mmc.c                    |    2 +-
 include/linux/tty_flip.h                      |    7 +-
 include/linux/usb.h                           |   53 +-
 include/linux/usb/Kbuild                      |    1 -
 include/linux/usb/atmel_usba_udc.h            |    1 +
 include/linux/usb/ch9.h                       |    2 +-
 include/linux/usb/musb.h                      |   23 +-
 include/linux/usb/otg.h                       |   25 +
 include/linux/usb/quirks.h                    |    3 +
 include/linux/usb/serial.h                    |   13 +-
 include/linux/usb/vstusb.h                    |   71 -
 218 files changed, 7396 insertions(+), 3637 deletions(-)
 create mode 100644 Documentation/networking/cxacru-cf.py
 create mode 100644 arch/arm/plat-mxc/include/mach/mx21-usbhost.h
 create mode 100644 drivers/usb/gadget/nokia.c
 create mode 100644 drivers/usb/host/imx21-dbg.c
 create mode 100644 drivers/usb/host/imx21-hcd.c
 create mode 100644 drivers/usb/host/imx21-hcd.h
 create mode 100644 drivers/usb/host/ohci-da8xx.c
 delete mode 100644 drivers/usb/misc/berry_charge.c
 delete mode 100644 drivers/usb/misc/vstusb.c
 create mode 100644 drivers/usb/serial/qcaux.c
 create mode 100644 drivers/usb/serial/vivopay-serial.c
 delete mode 100644 include/linux/usb/vstusb.h

---------------

Ajay Kumar Gupta (6):
      USB: musb: Add new fifo table for a OMAP3 errata
      usb: musb: save dynfifo in musb struct
      usb: musb: Add 'extvbus' in musb_hdrc_platform_data
      usb: host: ehci: fix missing kfree in remove path also
      usb: host: ehci: adding regulator framework in ehci-omap.c driver.
      usb: musb: Add context save and restore support

Alan Cox (6):
      USB: cp210x: Add 81E8 (Zephyr Bioharness)
      tty: Fix various bogus WARN checks in the usb serial layer
      USB: tty: sort out the request_room handling for whiteheat
      USB: tty: kill request_room for USB ACM class
      USB: tty: Add a function to insert a string of characters with the same flag
      USB: tty: Prune uses of tty_request_room in the USB layer

Alan Stern (13):
      USB: check the endpoint type against the pipe type
      USB: rearrange code in usb_probe_interface
      USB: change locking for device-level autosuspend
      USB: consolidate remote wakeup routines
      USB: use the device lock for persist_enabled
      USB: implement usb_enable_autosuspend
      USB: change handling of negative autosuspend delays
      USB: rearrange functions in driver.c
      USB: convert to the runtime PM framework
      USB: remove debugging message for uevent constructions
      usb-storage: use max_hw_sectors instead of max_sectors
      USB: fix the idProduct value for USB-3.0 root hubs
      USB: remove references to port->port.count from the serial drivers

Alessio Igor Bogani (1):
      USB: ftdi_sio: Replace BKL with a mutex

Anand Gadiyar (5):
      usb: musb: hsdma: add wrapper for reading DMA count
      usb: musb: workaround MUSB DMA_INTR sometimes reads zero
      USB: omap: ehci: kill 2 compile warnings
      USB: ehci: omap: use default interrupt threshold
      USB: ehci: omap: Update TODO list in comments

Andreas Mohr (2):
      USB: ftdi_sio: correct spelling in header files
      USB: ftdi_sio: correct spelling in implementation file

Anton Vorontsov (2):
      USB: ehci-fsl: Fix sparse warnings
      USB: ehci-fsl: Add power management support

Arnaud Mandy (1):
      usb: musb: handle irqs in the order dictated by programming guide

Ben Hutchings (1):
      USB: isight-firmware: declare MODULE_FIRMWARE

Bruno Prémont (1):
      USB: backlight, appledisplay: fix incomplete registration failure handling

Bryan Wu (2):
      USB: gadget: use ep5 for bulk-in and ep6 for bulk-out for Blackfin MUSB
      usb: musb: clean up commit 'workaround Blackfin FIFO anomalies'

Catalin Marinas (1):
      USB: isp1760: Flush the D-cache for the pipe-in transfer buffers

Chris Frey (1):
      USB: usbfs_snoop: add data logging back in

Christoph Egger (2):
      USB: remove obsolete config in kernel source (USB_HCD_DMA)
      USB: Remove unsupported usb gadget drivers

Cliff Cai (3):
      USB: gadget: add INT support for Blackfin musb
      USB: musb: set version of Blackfin version
      USB: musb: disable double buffering for older RTL versions

Dan Carpenter (2):
      USB: serial: fix DMA buffers on stack for io_edgeport.c
      USB: io_edgeport: eliminate get_string()

Dan Streetman (1):
      USB: retain USB device power/wakeup setting across reconfiguration

Dan Williams (2):
      USB: option: add Longcheer/Longsung vendor ID
      USB: qcaux: driver for auxiliary serial ports on Qualcomm devices

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Dennis O'Brien (1):
      USB: vstusb.c: removal of driver for Vernier Software & Technology, Inc., devices and spectrometers

Dmitri Epshtein (2):
      USB: ehci: add call of free_cached_itd_list() function in disable_periodic()
      USB: ehci: fix audio record functionality for some Full speed sound blaster devices

Edward Shao (1):
      USB: xhci: Fix finding extended capabilities registers

Eirik Aanonsen (1):
      USB: atmel uaba: Adding invert vbus_pin

Elina Pasheva (2):
      USB: serial: sierra driver adding reset_resume function
      USB: serial: sierra driver indat_callback fix

Enrico Scholz (1):
      USB: pxa27x_udc: avoid compiler warnings and misbehavior on buggy hardware

FUJITA Tomonori (1):
      USB: s3c-hsotg: replace deprecated dma_sync_single()

Felipe Balbi (15):
      USB: otg: add notifier support
      USB: otg: twl4030: add support for notifier
      USB: musb: use resource_size()
      USB: musb: move two printk to dev_err
      USB: musb: move to sysfs_groups
      USB: musb: remove some of the never defined defines
      usb: otg: twl4030: move to request_threaded_irq
      USB: gadget: introduce g_nokia gadget driver
      arm: defconfig: rx51: enable phonet and g_nokia
      USB: musb: get rid of omap_readl/writel
      USB: musb: we already tested for dyn_fifo
      USB: musb: deprecate what we don't use
      USB: musb: tusb6010: use resource_size
      USB: musb: unmap base if we can't probe
      USB: musb: only print info message if probe() is successful

Forest Bond (1):
      USB: serial: Add support for ViVOtech ViVOpay devices.

Francesco Lavra (1):
      cdc_acm: add reset_resume method

Gernot Hillier (3):
      USB: serial: option.c: Add chipset information for 4G W14
      USB: serial: option.c: Add blacklisting infrastructure for special device handling
      USB: serial: option.c: Add 4G W14 stick to blacklist for option_send_setup

Greg Kroah-Hartman (2):
      USB: rename USB_SPEED_VARIABLE to USB_SPEED_WIRELESS
      USB: remove the berry_charge driver

H Hartley Sweeten (6):
      USB: pxa27x_udc.c: use resource_size()
      USB: atmel_usba_udc.c: use resource_size()
      USB: at91_udc.c: use resource_size()
      USB: ehci-orion.c: use resource_size()
      USB: ehci-atmel.c: use resource_size()
      USB: ehci-au1xxx.c: use platform_get_resource() and resource_size()

Herbert Xu (1):
      USB: Move hcd free_dev call into usb_disconnect to fix oops

Jan Dumon (1):
      USB: unusual_devs: Add support for multiple Option 3G sticks

Jason Wessel (1):
      USB: ehci-dbgp: split PID register updates for IN and OUT pipes

Joe Perches (3):
      USB: serial: Remove unnecessary \n's from dbg uses
      USB: Convert concatenated __FILE__ to %s, __FILE__
      USB: Extend and neaten dbg macros

Johan Hovold (27):
      USB: ftdi_sio: fix error message on close
      USB: ftdi_sio: remove obsolete comment
      USB: serial: fix typo in debug message
      USB: ftdi_sio: fix initialisation of latency timeout
      USB: ftdi_sio: use error code from usb stack in read_latency_timer
      USB: ftdi_sio: fix latency-timeout endianess bug
      USB: ftdi_sio: fix DMA buffers on stack
      USB: ftdi_sio: clean up modem status handling
      USB: ftdi_sio: remove unnecessary initialisations
      USB: ch341: replace printk warnings with dev_err
      USB: ch341: fix DMA buffer on stack
      USB: ch341: use le16_to_cpup to be explicit about endianess
      USB: cypress_m8: fix DMA buffer on stack
      USB: cypress_m8: fix endianess bug
      USB: io_ti: fix DMA buffers on stack
      USB: keyspan_pda: fix DMA buffers on stack
      USB: kl5kusb105: fix DMA buffers on stack
      USB: mos7720: fix DMA buffers on stack and clean up send_mos_cmd
      USB: mos7840: fix DMA buffers on stack and endianess bugs
      USB: oti6858: fix DMA buffer on stack
      USB: visor: fix DMA buffers on stack
      USB: kobil_sct: clean up kobil_set_termios
      USB: ch341: use get_unaligned_le16 in break_ctl
      USB: cypress_m8: use put_unaligned_le32() where necessary
      USB: ftdi_sio: remove unused tx_bytes counter
      USB: ftdi_sio: remove obsolete check in unthrottle
      USB: pl2303: remove unnecessary reset of usb_device in urbs

John Tsiombikas (1):
      USB: pl2303: initial TIOCGSERIAL support

Julia Lawall (4):
      USB: wusb: check CHID is all zeros before stopping the host
      USB: isp1362: Use kzalloc for allocating only one thing
      USB: FHCI: Correct the size argument to kzalloc
      USB: serial: Eliminate useless code

Julian Calaby (2):
      USB: cdc_acm: Add support for pbLua console port
      USB: cdc_acm: Silence "It is not a modem." error for pbLua devices

Luotao Fu (1):
      USB: fix I2C API usage in ohci-pnx4008.

Marcel Holtmann (1):
      USB: gadget: Add DEVTYPE support for Ethernet functions

Mark Adamson (1):
      USB: ftdi_sio: remove support for 5 and 6 data bits

Mark Brown (1):
      USB: s3c-hsotg: Staticise non-exported functions

Martin Fuzzey (3):
      USB: MXC: Add i.MX21 specific USB host controller driver.
      USB: MXC: use DMA_BIT_MASK macro rather than hardcoded constants.
      USB: MXC: add platform resources for i.MX21 USB host controller.

Michael Hennerich (2):
      USB: host: SL811: fix unaligned accesses
      USB: host: SL811: allow the hcd on Blackfin systems

Michal Nazarewicz (3):
      USB: mass_storage: eject LUNs on thread exit
      USB: g_mass_storage: superfluous and missing packets fixed
      USB: g_mass_storage: min(...) warning fixed

Mike Dunn (1):
      USB: serial: add support for serial port on the moschip 7715

Mike Frysinger (3):
      USB: cypress_m8: stop using USB debug driver config
      USB: cypress_m8: unify confusing new baudrate check
      USB: cypress_m8: allow unstable baud rates

Mitchell Solomon (1):
      USB: add new ftdi_sio device ids

Németh Márton (9):
      USB skeleton: make USB device id constant
      USB class: make USB device id constant
      USB serial: make USB device id constant
      USB image: make USB device id constant
      USB misc: make USB device id constant
      USB hub: make USB device id constant
      USB host: make Open Firmware device id constant
      USB gadget: make Open Firmware device id constant
      USB goku_udc: make PCI device id constant

Oliver Neukum (27):
      USB: cdc-acm: Update to new autopm API
      USB: xhci: No GFP_KERNEL in block error handling
      USB: storage: Never reset devices that will morph to an old mode
      USB: Export QUIRK_RESET_MORPHS through sysfs
      USB: usblp: Remove checks no longer needed with the new runtime PM system
      USB: Remove BKL from poll()
      USB: Remove BKL from usbdev_open()
      USB: Remove BKL from lseek implementations
      USB: Push BKL on open down into the drivers
      USB: Reduce scope of BKL in usb ioctl handling
      usb: BKL removal: usblp
      USB: BKL removal: usb-skeleton
      USB: BKL removal: usbtmc
      USB: BKL removal: cdc-wdm
      USB: BKL removal: mdc800
      USB: BKL removal: rio500
      USB: BKL removal: idmouse
      USB: BKL removal: adutux
      USB: BKL removal: ftdi-elan
      USB: BKL removal: ldusb
      USB: BKL removal: legousbtower
      USB: BKL removal: vstusb
      USB: BKL removal: frontier
      USB: BKL removal from ioctl path of usbfs
      USB: cdc-acm: fix possible deadlock with multiple openers
      USB: storage: onetouch: unnecessary GFP_ATOMIC
      USB: sisusbvga: no unnecessary GFP_ATOMIC

Pete Zaitcev (4):
      USB: serial mct_usb232: move DMA buffers to heap
      usbmon: add bus number to text API
      USB: fix crash in uhci_scan_schedule
      USB: usbmon: mask seconds properly in text API

Peter Korsgaard (1):
      USB: f_mass_storage: fix crash on bind() error

Robert Jarzmik (1):
      USB: pxa27x_udc: Fix deadlocks on request queueing

Robert P. J. Day (1):
      USB: Correct CONFIG variable typo.

Roel Kluin (4):
      USB: musb: don't dereference NULL tusb_dma in dma_controller_destroy()
      USB: musb: test always evaluates to false
      USB: storage: fix misplaced parenthesis
      USB: don't read past config->interface[] if usb_control_msg() fails in usb_reset_configuration()

Sarah Sharp (10):
      USB: xhci: Fix error path when configuring endpoints.
      USB: xhci: Refactor code to free or cache endpoint rings.
      USB: xhci: Allow allocation of commands without input contexts.
      USB: xhci: Refactor test for vendor-specific completion codes.
      USB: xhci: Refactor code to clear port change bits.
      USB: xhci: Allow roothub ports to be disabled.
      USB: xhci: Notify the xHC when a device is reset.
      USB: Add call to notify xHC of a device reset.
      USB: xhci: Fix compile issues with xhci_get_slot_state()
      USB: Use bInterfaceNumber in bandwidth allocations.

Sergei Shtylyov (1):
      USB: OHCI: DA8xx/OMAP-L1x glue layer

Simon Arlott (8):
      USB: cxacru: return an empty value for modulation if there is no connection
      USB: cxacru: check data length is not negative
      USB: cxacru: check device isn't being removed during sysfs calls
      USB: cxacru: document how to interact with the flash memory
      USB: cxacru: firmware writes on OHCI are slow, log progress
      USB: cxacru: add write-only sysfs attribute for modem configuration
      USB: cxacru: remove cxacru-cf.bin loader
      USB: cxacru: increment driver version

Swaminathan S (2):
      usb: musb: workaround toggle bug when doing bulk transfer after isoc
      usb: musb: Fix cppi_channel_abort() function to handle Tx abort correctly

Thadeu Lima de Souza Cascardo (1):
      USB: trivial: missing newline in usb core warning message

Thiago Farina (2):
      USB: c67x00: use resource_size().
      USB: atm: Use FIELD_SIZEOF, trivial cleanup.

Thomas Gleixner (1):
      usb: gadgetfs: Convert semaphore to mutex

Valentin Longchamp (1):
      USB: fix occasional ULPI timeouts with ehci-mxc


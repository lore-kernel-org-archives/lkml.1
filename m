Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZIWN4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZIWN4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZIWN4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:56:23 -0400
Received: from kroah.org ([198.145.64.141]:41464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZIWN4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:56:19 -0400
Date: Wed, 23 Sep 2009 06:55:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.31-git
Message-ID: <20090923135539.GA6542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB merge for your 2.6.31-git tree.

Lots of usb stuff all over the map here.  For details see the
shortlog below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm trees for quite
a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt |    2 +-
 Documentation/usb/authorization.txt |   10 +-
 Documentation/usb/usbmon.txt        |    8 +-
 Documentation/x86/earlyprintk.txt   |   39 +-
 MAINTAINERS                         |    4 +-
 arch/x86/kernel/early_printk.c      |  780 +---------
 drivers/net/usb/cdc_eem.c           |   17 +-
 drivers/usb/Kconfig                 |    3 +
 drivers/usb/Makefile                |    2 +
 drivers/usb/class/cdc-acm.c         |    2 +
 drivers/usb/class/cdc-wdm.c         |   30 +-
 drivers/usb/class/usbtmc.c          |   84 +-
 drivers/usb/core/config.c           |    2 +-
 drivers/usb/core/devio.c            |  247 +++-
 drivers/usb/core/driver.c           |   75 +-
 drivers/usb/core/generic.c          |    4 +-
 drivers/usb/core/hcd.c              |  113 +-
 drivers/usb/core/hcd.h              |    5 +
 drivers/usb/core/hub.c              |  126 ++-
 drivers/usb/core/message.c          |   32 +-
 drivers/usb/core/usb.c              |   13 +-
 drivers/usb/core/usb.h              |    7 +
 drivers/usb/early/Makefile          |    5 +
 drivers/usb/early/ehci-dbgp.c       |  996 ++++++++++++
 drivers/usb/gadget/Kconfig          |   31 +-
 drivers/usb/gadget/amd5536udc.c     |   56 +-
 drivers/usb/gadget/at91_udc.c       |    1 -
 drivers/usb/gadget/audio.c          |   24 +-
 drivers/usb/gadget/composite.c      |    2 +-
 drivers/usb/gadget/dummy_hcd.c      |    5 -
 drivers/usb/gadget/ether.c          |   31 +-
 drivers/usb/gadget/f_audio.c        |   97 +-
 drivers/usb/gadget/f_eem.c          |  562 +++++++
 drivers/usb/gadget/f_rndis.c        |   15 +-
 drivers/usb/gadget/fsl_qe_udc.c     |    4 +
 drivers/usb/gadget/gmidi.c          |    8 +-
 drivers/usb/gadget/pxa25x_udc.c     |   49 +-
 drivers/usb/gadget/pxa25x_udc.h     |    1 +
 drivers/usb/gadget/rndis.c          |   13 +-
 drivers/usb/gadget/rndis.h          |    3 +-
 drivers/usb/gadget/s3c-hsotg.c      |    6 +-
 drivers/usb/gadget/s3c2410_udc.c    |    3 +-
 drivers/usb/gadget/u_audio.c        |   10 +-
 drivers/usb/gadget/u_ether.c        |   85 +-
 drivers/usb/gadget/u_ether.h        |   12 +-
 drivers/usb/gadget/u_serial.c       |    1 -
 drivers/usb/host/Kconfig            |   18 +
 drivers/usb/host/Makefile           |    1 +
 drivers/usb/host/ehci-atmel.c       |  230 +++
 drivers/usb/host/ehci-au1xxx.c      |   29 +-
 drivers/usb/host/ehci-dbg.c         |   46 +-
 drivers/usb/host/ehci-hcd.c         |   89 +-
 drivers/usb/host/ehci-hub.c         |   84 +-
 drivers/usb/host/ehci-mem.c         |   26 +-
 drivers/usb/host/ehci-pci.c         |   42 +-
 drivers/usb/host/ehci-q.c           |   95 +-
 drivers/usb/host/ehci-sched.c       |  100 +-
 drivers/usb/host/ehci-w90x900.c     |  181 +++
 drivers/usb/host/ehci.h             |   14 +-
 drivers/usb/host/isp1362-hcd.c      | 2909 +++++++++++++++++++++++++++++++++++
 drivers/usb/host/isp1362.h          | 1079 +++++++++++++
 drivers/usb/host/isp1760-hcd.c      |    4 +
 drivers/usb/host/isp1760-hcd.h      |    2 +
 drivers/usb/host/isp1760-if.c       |   21 +-
 drivers/usb/host/ohci-at91.c        |    2 +-
 drivers/usb/host/ohci-au1xxx.c      |   27 +-
 drivers/usb/host/ohci-ep93xx.c      |    1 -
 drivers/usb/host/ohci-hcd.c         |    1 -
 drivers/usb/host/ohci-pxa27x.c      |    4 +
 drivers/usb/host/oxu210hp-hcd.c     |    1 -
 drivers/usb/host/pci-quirks.c       |    2 +-
 drivers/usb/host/sl811-hcd.c        |    8 +-
 drivers/usb/host/uhci-q.c           |    1 -
 drivers/usb/host/whci/asl.c         |   12 +-
 drivers/usb/host/whci/hcd.c         |    8 +-
 drivers/usb/host/whci/pzl.c         |   12 +-
 drivers/usb/host/whci/qset.c        |    4 +-
 drivers/usb/host/whci/whci-hc.h     |    1 +
 drivers/usb/host/xhci-dbg.c         |    5 +-
 drivers/usb/host/xhci-hcd.c         |  530 ++++++--
 drivers/usb/host/xhci-mem.c         |  140 ++-
 drivers/usb/host/xhci-pci.c         |   16 +
 drivers/usb/host/xhci-ring.c        |  377 ++++-
 drivers/usb/host/xhci.h             |  111 ++-
 drivers/usb/image/microtek.c        |   37 -
 drivers/usb/misc/idmouse.c          |   21 +
 drivers/usb/misc/ldusb.c            |    6 +
 drivers/usb/misc/legousbtower.c     |    6 +
 drivers/usb/misc/sisusbvga/sisusb.c |   53 +-
 drivers/usb/misc/sisusbvga/sisusb.h |    2 -
 drivers/usb/misc/usbsevseg.c        |   69 +-
 drivers/usb/mon/Kconfig             |    4 +-
 drivers/usb/mon/Makefile            |    2 +-
 drivers/usb/mon/mon_bin.c           |   12 +-
 drivers/usb/mon/mon_dma.c           |   95 --
 drivers/usb/mon/mon_main.c          |    1 -
 drivers/usb/mon/mon_text.c          |   14 -
 drivers/usb/mon/usb_mon.h           |   14 -
 drivers/usb/musb/musb_core.c        |    8 +-
 drivers/usb/otg/isp1301_omap.c      |   23 +-
 drivers/usb/serial/ark3116.c        |   24 +-
 drivers/usb/serial/ch341.c          |   52 +
 drivers/usb/serial/ftdi_sio.c       |    7 +
 drivers/usb/serial/ftdi_sio.h       |   10 +
 drivers/usb/serial/generic.c        |  206 ++-
 drivers/usb/serial/iuu_phoenix.c    |  115 ++-
 drivers/usb/serial/moto_modem.c     |    2 +-
 drivers/usb/serial/option.c         |  138 ++-
 drivers/usb/serial/pl2303.c         |   71 +-
 drivers/usb/serial/pl2303.h         |    4 +
 drivers/usb/serial/sierra.c         |  157 ++-
 drivers/usb/serial/usb-serial.c     |   23 +-
 drivers/usb/storage/datafab.c       |    4 +-
 drivers/usb/storage/initializers.c  |    2 +-
 drivers/usb/storage/jumpshot.c      |    2 +-
 drivers/usb/storage/onetouch.c      |    2 +-
 drivers/usb/storage/unusual_devs.h  |   22 +-
 drivers/usb/usb-skeleton.c          |  252 +++-
 include/linux/usb.h                 |   25 +-
 include/linux/usb/audio.h           |  287 ++--
 include/linux/usb/ch9.h             |    8 +
 include/linux/usb/ehci_def.h        |   35 +
 include/linux/usb/isp1362.h         |   46 +
 include/linux/usb/isp1760.h         |   18 +
 include/linux/usb/serial.h          |    2 +
 include/linux/usbdevice_fs.h        |    3 +
 126 files changed, 9604 insertions(+), 2138 deletions(-)
 create mode 100644 drivers/usb/early/Makefile
 create mode 100644 drivers/usb/early/ehci-dbgp.c
 create mode 100644 drivers/usb/gadget/f_eem.c
 create mode 100644 drivers/usb/host/ehci-atmel.c
 create mode 100644 drivers/usb/host/ehci-w90x900.c
 create mode 100644 drivers/usb/host/isp1362-hcd.c
 create mode 100644 drivers/usb/host/isp1362.h
 delete mode 100644 drivers/usb/mon/mon_dma.c
 create mode 100644 include/linux/usb/isp1362.h
 create mode 100644 include/linux/usb/isp1760.h

---------------

Ajay Kumar Gupta (1):
      USB: musb: fix put_device() call sequence

Alan Stern (10):
      USB: add API for userspace drivers to "claim" ports
      USB: make intf.pm_usage an atomic_t
      USB: make the "usbfs_snoop" log more pertinent
      USB: check for hub driver not bound to root hub device
      USB: don't lose mode switch events on suspended devices
      USB: dummy-hcd: accept mismatch between wLength and transfer length
      USB: s3c2410: unregister should call unbind, not disconnect
      USB: EHCI: rescan the queue after an unlink
      USB: EHCI: change deschedule logic for interrupt QHs
      USB: usbfs: add USBDEVFS_URB_BULK_CONTINUATION flag

Alek Du (3):
      USB: EHCI: add need_io_watchdog flag to ehci_hcd
      USB: EHCI: split ehci_qh into hw and sw parts
      USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and support phy low power mode

Anand Gadiyar (2):
      USB: EHCI: OHCI: Remove unnecessary includes of reboot.h
      USB: OMAP: ISP1301: Compile fix

Anton Vorontsov (1):
      USB: fsl_qe_udc: Add fsl,mpc8323-qe-usb compatible entry

Aric Blumer (1):
      USB: ohci-pxa27x: Allow NOCP and OCPM to be cleared

Bob Liu (1):
      USB: uhci: rm repeatedly evaluation for urbp->qh

Brian Niebuhr (2):
      USB: Fix CDC EEM host driver 'sentinel' CRC validation
      USB: gadget: Add EEM gadget driver

David VomLehn (1):
      USB: use kfifo to buffer usb-generic serial writes

David Vrabel (1):
      USB: whci-hcd: make endpoint_reset method async

David Woodhouse (1):
      USB: Work around BIOS bugs by quiescing USB controllers earlier

Figo.zhang (1):
      USB: ehci-dbg.c: no need for checking it before call vfree

Frank Schaefer (3):
      USB-serial: pl2303: fix baud rate handling in case of unsupported values
      USB-serial: pl2303: add space/mark parity
      USB-serial: pl2303: use 1.5 instead of 2 stop bits with 5 data bits

George Spelvin (1):
      USB: Clean up root hub string descriptors

Gergely Imreh (1):
      USB: fix USBTMC get_capabilities success handling

Greg Kroah-Hartman (1):
      USB: skeleton: fix coding style issues.

Guus Sliepen (1):
      USB: usbtmc: sanity checks for DEV_DEP_MSG_IN urbs

H Hartley Sweeten (1):
      USB: ohci-ep93xx.c: remove unused variable

Hennerich, Michael (1):
      USB: sl811-hcd: Fix device disconnect:

Huzaifa Sidhpurwala (1):
      USB: option.c Add support for ZTE AC2726 EVDO modem

Jason Wessel (11):
      USB: ehci,dbgp,early_printk: split ehci debug driver from early_printk.c
      USB: dbgp: insert cr prior to nl as needed
      USB: ehci-dbgp: Execute early BIOS hand off
      USB: dbgp: EHCI debug controller initialization delays
      early_printk: Allow more than one early console
      USB: ehci-dbgp: stability improvements and external re-init
      USB: ehci-dbgp,ehci: Allow early or late use of the dbgp device
      USB: ehci-dbgp: errata for EHCI debug controller initialization
      USB: ehci-dbgp: errata for EHCI debug/host controller synchronization
      USB: ehci-dbgp,documentation: Documentation updates for ehci-dbgp
      USB: ehci-dbgp,ehci: Allow dbpg to work with suspend/resume

Jean Delvare (1):
      USB: Fix sysfs paths in documentation

Jiri Slaby (2):
      USB: usb-serial, remove unused variables
      USB: make usb_buffer_map_sg consistent with doc

Jon Hunter (1):
      USB: EHCI: ensure all watchdog timer events are deleted when suspending usb

Julia Lawall (3):
      USB: gadget: Drop NULL test on list_entry result
      USB: storage: Drop an unneeded a NULL test
      USB: isp1362: Correct use of ! and &

Ken MacLeod (1):
      USB: isp1362: fix pulldown register defines and conf logic

Laurent Pinchart (4):
      USB: Move endpoint sync type definitions from usb/audio.h to usb/ch9.h
      USB: Move vendor subclass definition from usb/audio.h to usb/ch9.h
      USB audio gadget: Prefix all macro definitions with UAC_ in linux/usb/audio.h
      USB audio gadget: Un-inline generic_[gs]et_cmd

Li Yang (1):
      USB: gadget: Update Freescale UDC entry in MAINTAINERS

Lothar Wassmann (1):
      USB: NXP ISP1362 USB host driver

Manuel Lauss (2):
      USB: option: TELIT UC864G support
      USB: au1xxx: add dev_pm_ops

Markus Rechberger (1):
      USB: increase usbdevfs max isoc buffer size

Maxin John (1):
      USB: serial: Spelling correction in Motorola USB Phone driver

Michael Hennerich (2):
      USB: serial: ftdi: handle gnICE+ JTAG adaptors
      USB: isp1760: allow platform devices to customize devflags

Michael S. Tsirkin (1):
      USB: audio: guard kernel-only code with __KERNEL__

Ming Lei (1):
      USB: otg: twl4030-usb.c: mark .init as subsys_initcall_sync

Nicolas Ferre (3):
      USB: at91: Add USB EHCI driver for at91sam9g45 series
      USB: at91: Add USB gadget driver selection for at91sam9g45 series
      USB: at91: modify OHCI driver to allow shared interrupts

Oliver Neukum (17):
      USB: storage: fix a resume path GFP_NOIO must be used
      USB: CDC WDM driver doesn't support non-blocking reads
      USB: fix cdc-acm regression in open
      USB: serial: full autosuspend support for the option driver
      USB: usbtmc can do IO to device after disconnect
      USB: suspend/resume support for usbtmc
      USB: legousbtower: make poll notice disconnect
      USB: ldusb should signal an error in poll if the device is disconnected
      USB: full power management support for the idmouse driver
      USB: full autosuspend and power management support for usbsevseg
      USB: fix wrong order of events in usb serial suspension
      USB: remove unneeded printks from microtek driver
      USB: support for autosuspend in sierra while online
      USB: fix missing error check in probing
      USB: skel_read really sucks royally
      USB: make usb-skeleton honor O_NONBLOCK in write path
      USB: O_NONBLOCK in read path of skeleton

Olivier Bornet (5):
      USB: iuu_phoenix: Don't reset the device at close
      USB: iuu_phoenix: clean-up parameter's descriptions
      USB: iuu_phoenix: add support for changing VCC
      USB: iuu_phoenix: increment version number
      USB: iuu_phoenix: add a way to select the default VCC

Ondrej Zary (1):
      USB: ark3116: add IrDA support for Gembird UIR-22

Pawel Ludwikow (2):
      USB: serial: ftdi_sio: new hardware support - hameg power supply
      USB: serial: pl2303: new hardware support - sanwa multimeter

Pete Zaitcev (6):
      USB: sisusbvga: drop usb_buffer_alloc
      USB: usbmon: drop Kconfig defaults
      USB: usbmon: touch up the documentation
      USB: usbmon: end ugly tricks with DMA peeking
      USB: Let usb_sg_init to set transfer_buffer more often
      USB: unusual_devs.h: drop some unneeded floppy entries

Philipp Zabel (1):
      USB: gadget: pxa25x: basic transceiver support

Randy Dunlap (3):
      USB: usbtmc: fix printk format warnings
      USB: otg: fix twl4030-usb build
      USB: gadget: ether needs to select CRC32

Robin Callender (1):
      USB: gadget: audio driver seg-fault fix

Roel Kluin (4):
      USB: gadget: s3c-hsotg: missing parentheses
      USB: gadget: Read buffer overflow
      USB: double put_tty_driver(gs_tty_driver) in gserial_setup()
      USB: gadget: double free_irq() in at91udc_probe()

Rogério Brito (1):
      USB: fix paths in usbmon documentation

Sarah Sharp (23):
      USB: xhci: Work around for chain bit in link TRBs.
      USB: xhci: Fix slot and endpoint context debugging.
      USB: xhci: Configure endpoint code refactoring.
      USB: xhci: Set correct max packet size for HS/FS control endpoints.
      USB: xhci: Support full speed devices.
      USB: xhci: Handle stalled control endpoints.
      USB: xhci: Add quirk for Fresco Logic xHCI hardware.
      USB: xhci: Make TRB completion code comparison readable.
      USB: xhci: Handle babbling endpoints correctly.
      USB: xhci: Don't touch xhci_td after it's freed.
      USB: xhci: Check URB's actual transfer buffer size.
      USB: xhci: Check URB_SHORT_NOT_OK before setting short packet status.
      USB: xhci: Set -EREMOTEIO when xHC gives bad transfer length.
      USB: xhci: Support interrupt transfers.
      USB: Fix SS endpoint companion descriptor parsing.
      USB: xhci: Endpoint representation refactoring.
      USB: xhci: Refactor input device context setup.
      USB: xhci: Change how xHCI commands are handled.
      USB: xhci: Fix command wait list handling.
      USB: xhci: Set route string for all devices.
      USB: xhci: Set multi-TT field for LS/FS devices under hubs.
      USB: xhci: Support USB hubs.
      USB: Add hub descriptor update hook for xHCI

Steve Holland (3):
      USB: usbtmc: Fix short reads in usbtmc_read()
      USB: usbtmc: inhibit corruption
      USB: usbtmc: correct termination condition for reads.

Tim Small (1):
      USb: Break support for WinChipHead CH341 340 USB->Serial "chip"

Wan ZongShun (1):
      USB: Add nuvoton Ehci driver for w90p910 platform

fangxiaozhi (1):
      USB: usb-storage fails to attach to Huawei Datacard cdrom device

mail@rainerkeller.de (1):
      USB: add PIDs for FTDI based OpenDCC hardware


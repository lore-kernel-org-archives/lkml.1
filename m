Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYDYEr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYDYEr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYDYErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:47:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:49912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYDYErQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:47:16 -0400
Date: Thu, 24 Apr 2008 21:53:03 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.25-git
Message-ID: <20080425045303.GA4906@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a set of USB patches against your current git tree.

They do a lot of different things, mostly all new driver updates and
powermanagement changes for the USB layer.  The shortlog below has all
the details.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and -mm tree for quite
some time.

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/usb/anchors.txt          |   50 +
 Documentation/usb/callbacks.txt        |  132 +
 Documentation/usb/persist.txt          |   43 +-
 Documentation/usb/usb-serial.txt       |    7 +-
 drivers/input/joystick/xpad.c          |   20 +-
 drivers/usb/atm/cxacru.c               |    2 +-
 drivers/usb/atm/ueagle-atm.c           |    6 +-
 drivers/usb/atm/usbatm.c               |   27 +-
 drivers/usb/atm/usbatm.h               |    2 +-
 drivers/usb/class/cdc-acm.c            |   98 +-
 drivers/usb/class/cdc-acm.h            |    7 +-
 drivers/usb/core/Kconfig               |   42 +-
 drivers/usb/core/config.c              |   17 +
 drivers/usb/core/devio.c               |   73 +-
 drivers/usb/core/driver.c              |   52 +-
 drivers/usb/core/hcd-pci.c             |   15 +-
 drivers/usb/core/hcd.c                 |   25 +-
 drivers/usb/core/hcd.h                 |    9 +-
 drivers/usb/core/hub.c                 |  396 ++-
 drivers/usb/core/hub.h                 |    9 +-
 drivers/usb/core/inode.c               |    4 +-
 drivers/usb/core/message.c             |   17 +-
 drivers/usb/core/quirks.c              |   14 +
 drivers/usb/core/sysfs.c               |   22 +-
 drivers/usb/core/urb.c                 |   26 +-
 drivers/usb/core/usb.h                 |    2 -
 drivers/usb/gadget/Kconfig             |   18 +-
 drivers/usb/gadget/amd5536udc.c        |   10 +
 drivers/usb/gadget/at91_udc.c          |    9 +-
 drivers/usb/gadget/dummy_hcd.c         |   98 +-
 drivers/usb/gadget/epautoconf.c        |   12 +-
 drivers/usb/gadget/ether.c             |   18 +-
 drivers/usb/gadget/file_storage.c      |   36 +-
 drivers/usb/gadget/fsl_usb2_udc.c      |    4 +-
 drivers/usb/gadget/fsl_usb2_udc.h      |    2 +-
 drivers/usb/gadget/gmidi.c             |    2 +-
 drivers/usb/gadget/goku_udc.c          |   20 +-
 drivers/usb/gadget/inode.c             |   18 +-
 drivers/usb/gadget/lh7a40x_udc.c       |  132 +-
 drivers/usb/gadget/m66592-udc.h        |    2 +-
 drivers/usb/gadget/net2280.h           |    2 +-
 drivers/usb/gadget/omap_udc.c          |   20 +-
 drivers/usb/gadget/printer.c           |   92 +-
 drivers/usb/gadget/pxa2xx_udc.c        |   26 +-
 drivers/usb/gadget/rndis.c             |  148 +-
 drivers/usb/gadget/serial.c            |    3 +-
 drivers/usb/host/Kconfig               |   10 +-
 drivers/usb/host/ehci-au1xxx.c         |    5 +-
 drivers/usb/host/ehci-dbg.c            |    4 +-
 drivers/usb/host/ehci-fsl.c            |    9 +-
 drivers/usb/host/ehci-hcd.c            |  113 +-
 drivers/usb/host/ehci-hub.c            |   34 +-
 drivers/usb/host/ehci-ixp4xx.c         |    3 +-
 drivers/usb/host/ehci-pci.c            |    9 +-
 drivers/usb/host/ehci-ppc-soc.c        |    5 +-
 drivers/usb/host/ehci-ps3.c            |    1 -
 drivers/usb/host/ehci-q.c              |  104 +-
 drivers/usb/host/ehci-sched.c          |   46 +-
 drivers/usb/host/isp116x-hcd.c         |   14 +-
 drivers/usb/host/ohci-at91.c           |    2 +-
 drivers/usb/host/ohci-au1xxx.c         |    1 -
 drivers/usb/host/ohci-dbg.c            |    2 +-
 drivers/usb/host/ohci-ep93xx.c         |    5 +-
 drivers/usb/host/ohci-hub.c            |  128 +-
 drivers/usb/host/ohci-lh7a404.c        |    1 -
 drivers/usb/host/ohci-omap.c           |    8 +-
 drivers/usb/host/ohci-pci.c            |   47 +-
 drivers/usb/host/ohci-pnx4008.c        |    1 -
 drivers/usb/host/ohci-pnx8550.c        |    1 -
 drivers/usb/host/ohci-ppc-of.c         |    1 -
 drivers/usb/host/ohci-ppc-soc.c        |    1 -
 drivers/usb/host/ohci-ps3.c            |    2 -
 drivers/usb/host/ohci-pxa27x.c         |    6 +-
 drivers/usb/host/ohci-s3c2410.c        |    1 -
 drivers/usb/host/ohci-sa1111.c         |    1 -
 drivers/usb/host/ohci-sh.c             |    1 -
 drivers/usb/host/ohci-sm501.c          |   16 +-
 drivers/usb/host/ohci-ssb.c            |   37 +-
 drivers/usb/host/pci-quirks.c          |    6 +-
 drivers/usb/host/r8a66597-hcd.c        |  256 ++-
 drivers/usb/host/r8a66597.h            |   51 +-
 drivers/usb/host/sl811-hcd.c           |   12 +-
 drivers/usb/host/u132-hcd.c            | 5124 ++++++++++++++++----------------
 drivers/usb/host/uhci-hcd.c            |   35 +-
 drivers/usb/host/uhci-q.c              |    2 +-
 drivers/usb/image/Kconfig              |    4 +-
 drivers/usb/image/microtek.c           |    3 +-
 drivers/usb/image/microtek.h           |    1 -
 drivers/usb/misc/Kconfig               |   20 +-
 drivers/usb/misc/adutux.c              |  120 +-
 drivers/usb/misc/appledisplay.c        |    6 +-
 drivers/usb/misc/auerswald.c           |  135 +-
 drivers/usb/misc/emi26.c               |   30 +-
 drivers/usb/misc/emi62.c               |   32 +-
 drivers/usb/misc/ftdi-elan.c           |    2 +-
 drivers/usb/misc/iowarrior.c           |   10 +-
 drivers/usb/misc/ldusb.c               |   10 +-
 drivers/usb/misc/legousbtower.c        |   92 +-
 drivers/usb/misc/phidgetkit.c          |    6 +-
 drivers/usb/misc/phidgetmotorcontrol.c |    2 +-
 drivers/usb/misc/phidgetservo.c        |    6 +-
 drivers/usb/misc/usblcd.c              |    8 +-
 drivers/usb/misc/usbtest.c             |   13 +-
 drivers/usb/mon/Makefile               |    2 +-
 drivers/usb/mon/mon_bin.c              |    9 +-
 drivers/usb/mon/mon_main.c             |    3 +-
 drivers/usb/mon/mon_stat.c             |    3 +
 drivers/usb/serial/Kconfig             |   76 +-
 drivers/usb/serial/Makefile            |    3 +-
 drivers/usb/serial/aircable.c          |   52 +-
 drivers/usb/serial/airprime.c          |   37 +-
 drivers/usb/serial/ark3116.c           |   10 +-
 drivers/usb/serial/belkin_sa.c         |   23 +-
 drivers/usb/serial/ch341.c             |    3 -
 drivers/usb/serial/console.c           |   10 +-
 drivers/usb/serial/cp2101.c            |  114 +-
 drivers/usb/serial/cyberjack.c         |  112 +-
 drivers/usb/serial/cypress_m8.c        |  579 ++--
 drivers/usb/serial/digi_acceleport.c   |   50 +-
 drivers/usb/serial/empeg.c             |   59 +-
 drivers/usb/serial/ezusb.c             |    8 +-
 drivers/usb/serial/ftdi_sio.c          |  171 +-
 drivers/usb/serial/funsoft.c           |    3 -
 drivers/usb/serial/garmin_gps.c        |  115 +-
 drivers/usb/serial/generic.c           |   56 +-
 drivers/usb/serial/hp4x.c              |    3 -
 drivers/usb/serial/io_edgeport.c       |  326 +-
 drivers/usb/serial/io_tables.h         |   12 -
 drivers/usb/serial/io_ti.c             |  398 ++--
 drivers/usb/serial/ipaq.c              |   53 +-
 drivers/usb/serial/ipw.c               |   51 +-
 drivers/usb/serial/ir-usb.c            |   53 +-
 drivers/usb/serial/iuu_phoenix.c       |  165 +-
 drivers/usb/serial/keyspan.c           |  281 +-
 drivers/usb/serial/keyspan.h           |   16 -
 drivers/usb/serial/keyspan_pda.c       |   42 +-
 drivers/usb/serial/kl5kusb105.c        |  124 +-
 drivers/usb/serial/kobil_sct.c         |   75 +-
 drivers/usb/serial/mct_u232.c          |   41 +-
 drivers/usb/serial/mos7720.c           |  122 +-
 drivers/usb/serial/mos7840.c           |  164 +-
 drivers/usb/serial/navman.c            |   31 +-
 drivers/usb/serial/omninet.c           |   42 +-
 drivers/usb/serial/option.c            |   92 +-
 drivers/usb/serial/oti6858.c           |  121 +-
 drivers/usb/serial/pl2303.c            |  117 +-
 drivers/usb/serial/safe_serial.c       |   60 +-
 drivers/usb/serial/sierra.c            |  129 +-
 drivers/usb/serial/spcp8x5.c           | 1072 +++++++
 drivers/usb/serial/ti_usb_3410_5052.c  |  211 +-
 drivers/usb/serial/usb-serial.c        |  107 +-
 drivers/usb/serial/usb_debug.c         |    3 -
 drivers/usb/serial/visor.c             |  103 +-
 drivers/usb/serial/whiteheat.c         |  118 +-
 drivers/usb/storage/Kconfig            |   39 +-
 drivers/usb/storage/Makefile           |    1 +
 drivers/usb/storage/cypress_atacb.c    |  200 ++
 drivers/usb/storage/cypress_atacb.h    |   25 +
 drivers/usb/storage/libusual.c         |   14 +-
 drivers/usb/storage/scsiglue.c         |   26 +-
 drivers/usb/storage/transport.c        |   23 +-
 drivers/usb/storage/unusual_devs.h     |    8 +
 drivers/usb/storage/usb.c              |   26 +-
 drivers/usb/usb-skeleton.c             |    8 +-
 include/linux/usb.h                    |  196 +-
 include/linux/usb/audio.h              |    2 +-
 include/linux/usb/cdc.h                |    4 +
 include/linux/usb/ch9.h                |   17 +-
 include/linux/usb/g_printer.h          |    4 +
 include/linux/usb/gadget.h             |    2 +-
 include/linux/usb/gadgetfs.h           |   16 +-
 include/linux/usb/input.h              |    8 +-
 include/linux/usb/iowarrior.h          |    6 +-
 include/linux/usb/isp116x.h            |    6 +-
 include/linux/usb/midi.h               |    2 +-
 include/linux/usb/net2280.h            |    9 +-
 include/linux/usb/otg.h                |    6 +-
 include/linux/usb/quirks.h             |    5 +
 include/linux/usb/rndis_host.h         |    9 +-
 include/linux/usb/serial.h             |   21 +-
 include/linux/usb/sl811.h              |    5 +-
 include/linux/usb/usbnet.h             |    8 +-
 include/linux/usb_usual.h              |    1 +
 include/linux/usbdevice_fs.h           |    7 +-
 scripts/checkpatch.pl                  |    7 +
 185 files changed, 8195 insertions(+), 6540 deletions(-)
 create mode 100644 Documentation/usb/anchors.txt
 create mode 100644 Documentation/usb/callbacks.txt
 create mode 100644 drivers/usb/serial/spcp8x5.c
 create mode 100644 drivers/usb/storage/cypress_atacb.c
 create mode 100644 drivers/usb/storage/cypress_atacb.h

---------------

Adrian Bunk (1):
      USB: make USB_STORAGE_ONETOUCH available with PM

Alan Cox (9):
      USB: usb-serial: Prepare for BKL push down
      USB: ftdi_sio: Note missing locking
      USB: serial: Note mos7480 and option don't lock modem status
      USB: iuu_phoenix: lock priv->tiostatus properly
      USB: kobil_sct: Get rid of unneeded priv->line_state
      USB: ti_usb_3410_5052: Extend locking to msr and shadow mcr
      USB: io_ti: lock mcr and msr shadows properly
      USB: cypress_m8: Speed handling
      usb serial: more fixes and groundwork for tty changes

Alan Stern (21):
      USB: EHCI: carry out port handover during each root-hub resume
      USB: reorganize code in hub.c
      USB: make USB-PERSIST work after every system sleep
      USB: remove CONFIG_USB_PERSIST setting
      USB: check serial-number string after device reset
      USB: enable USB-PERSIST by default
      USB: remove dev->power.power_state
      USB: usb-storage: use adaptive DMA mask
      USB: OHCI: fix bug in controller resume
      USB: root hubs don't lie about their number of TTs
      USB: clarify usage of hcd->suspend/resume methods
      USB: OHCI: host-controller resumes leave root hub suspended
      USB: rework sysfs removal of interface files
      USB: dummy-hcd: use dynamic allocation for platform_devices
      USB: log an error message when USB enumeration fails
      USB: g_file_storage: ignore bulk-out data after invalid CBW
      USB: HCDs use the do_remote_wakeup flag
      USB: OHCI: turn off RD when remote wakeup is disabled
      USB: don't explicitly reenable root-hub status interrupts
      USB: fix compile problems in ehci-hcd
      USB: usbfs: export the URB_NO_INTERRUPT flag to userspace

Andrew Morton (3):
      USB: usb-ohci-sm501-driver: use the conventional convention for suspend and resume
      USB: io_ti.c: remove pointless eye-candy in debug statements
      drivers/usb/core/devio.c: suppress warning with 64k PAGE_SIZE

Chris Collins (1):
      USB: option.c: correct DTR behaviour

Craig Shelley (1):
      USB: CP2101 Add new device IDs

Craig W. Nadler (1):
      USB: g_printer bugfixes

Daniel Walker (4):
      USB: microtek: remove unused semaphore
      USB: libusual: locking cleanup
      usb: u132-hcd driver style clean up
      usb: u132-hcd driver: semaphore to mutex

David Brownell (12):
      USB: defines for USB "Link Power Management" (LPM) ECN
      USB: ehci: minor cleanups
      USB: ohci: port reset paranoia timeout
      USB: ehci tolerates some buggy devices
      USB: ehci minor SOC bus glue fixes
      USB: ehci: remove obsolete workaround for bogus IRQs
      USB: ehci: paranoia, reject large control transfers
      USB: gadget section fixes
      USB: at91_udc can prefetch data
      USB: ehci: qh/qtd cleanup comments
      USB: cdc-acm: signedness fix
      USB: ehci: qh_completions cleanup and bugfix

David Engraf (2):
      USB: cdc-acm tell tty layer not to split things up.
      USB: increase cdc-acm write throughput

David Vrabel (1):
      usb: don't update devnum for wusb devices

Greg Kroah-Hartman (5):
      checkpatch: usb_free_urb() can take NULL
      USB: add USB_DT_CS_RADIO_CONTROL define to ch9.h
      USB: add usb-serial spcp8x5 driver
      USB: serial: remove unneeded number endpoints settings
      USB: serial: remove endpoints setting checks from core and header

Harvey Harrison (2):
      usb: replace remaining __PRETTY_FUNCTION__ occurrences
      USB: replace remaining __FUNCTION__ occurrences

Inaky Perez-Gonzalez (5):
      wusb: add authenticathed bit to usb_dev
      wusb: add link wusb-usb device
      wusb: teach choose_address() about wireless devices
      wusb: devices dont use a set address
      wusb: make ep0_reinit available for modules

Ingo van Lil (1):
      USB: gadget: dummy_hcd.c: fix nested switch statements

Jesper Juhl (2):
      USB: test for NULL return from platform_get_resource() in ohci_hcd_sm501_drv_remove()
      USB: mem leak fixes for AMD 5536 UDC high/full speed USB device controller driver

Julia Lawall (1):
      USB: use DIV_ROUND_UP

Karsten Wiese (2):
      USB: EHCI: Refactor "if (handshake()) state = HC_STATE_HALT"
      USB: minor ehci xITD simplifications

Kevin Lloyd (3):
      USB: Serial: Sierra: Clean up
      USB: Serial: Sierra: C597 fix
      usb/usb-serial-sierra-add-new-dev-group

Matthias Geissert (1):
      USB: ipaq: fix devices having more than one endpoint

Matthieu CASTET (1):
      USB: mass storage: emulation of sat scsi_pass_thru with ATACB

Matti Linnanvuori (1):
      USB: serial: Remove obsolete contact addresses

Mike Isely (5):
      USB: cypress_m8: Feature buffer fixes
      USB: cypress_m8: Packet format is separate from characteristic size
      USB: cypress_m8: Don't issue GET_CONFIG for certain devices
      USB: cypress_m8: Get rid of pointless NULL check
      USB: cypress_m8: Limit baud rate to <=4800 for USB low speed devices

Ming Lei (3):
      USB: Fix memory leak in mon_stat_release
      USB: fix comments of 2 functions in hcd.c
      USB: remove unnecessary type casting of urb->context

Oliver Neukum (5):
      USB: convert away from urb->status in xpad driver
      USB: add extension of anchor API, usb_unlink_anchored_urbs
      USB: update comments about usb driver's header
      USB: add Documentation about usb_anchor
      USB: add documentation about callbacks

Paul Mundt (1):
      USB: m66592-udc: reduce size of data structure.

Paulius Zaleckas (1):
      USB: oti6858: fix TCFLSH ioctl handling

Pavel Emelyanov (1):
      USB: usbatm: convert heavy init dances to kthread API

Pete Zaitcev (1):
      usbmon: restore mmap

Randy Dunlap (1):
      USB: convert usb.h struct usb_device to kernel-doc

Ray Lee (1):
      USB: io_ti.c: remove unneeded null tty check

Robert P. J. Day (10):
      USB: Standardize inclusion protection and add where missing.
      USB: Remove EXPERIMENTAL designation from USB storage Kconfig entries.
      USB: Remove EXPERIMENTAL tags from some USB gadget Kconfig entries.
      USB: Remove EXPERIMENTAL designation from USB misc/ Kconfig entries
      USB: Remove EXPERIMENTAL designation from USB serial/ Kconfig entries
      USB: Remove EXPERIMENTAL designation from USB MDC800 support.
      USB: Remove EXPERIMENTAL from dynamic USB minor allocation.
      USB: Remove EXPERIMENTAL designation from USB_EHCI_ROOT_HUB_TT.
      USB: Fix "cut and paste" booboo in usbmon Makefile.
      USB: Remove superfluous "depends on USB_SERIAL" from Kconfig.

Robin Getz (1):
      USB: partial USB embedded host support

Sarah Sharp (1):
      USB: ehci shutdown refactored

Savin Zlobec (1):
      USB: gadget: Hangup tty on g_serial disconnect

Stefan Seyfried (1):
      USB: Add HP hs2300 Broadband Wireless Module to sierra.c

Tilman Schmidt (1):
      USB: usb.h: reduce syslog clutter [v3]

Yoshihiro Shimoda (3):
      USB: r8a66597-hcd: fix interrupt transfer interval
      USB: r8a66597-hcd: fix usb device connection timing
      USB: r8a66597-hcd: Add support for SH7366 USB host

matthias@kaehlcke.net (3):
      USB: auerswald: Convert stats_sem in a mutex
      USB: auerswald: Convert ccp->readmutex in a mutex
      USB: auerswald: Convert ccp->mutex in a mutex


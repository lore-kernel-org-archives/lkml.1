Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbXJLWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbXJLWRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXJLWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:16:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46892 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbXJLWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:16:39 -0400
Date: Fri, 12 Oct 2007 15:12:45 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.23
Message-ID: <20071012221245.GA4559@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches against your 2.6.23 git tree.

They do a lot of different things, suspend issues, new drivers,
cleanups, authorization features, etc.  See my summary last week for the
specific details, and the shortlog below for the highlights.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 Documentation/usb/authorization.txt             |   92 +
 Documentation/usb/power-management.txt          |  517 ++++++
 Documentation/usb/usb-serial.txt                |   11 +
 Documentation/usb/usbmon.txt                    |    9 +-
 MAINTAINERS                                     |    7 +
 arch/blackfin/mach-bf537/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 drivers/usb/Makefile                            |   22 +-
 drivers/usb/atm/cxacru.c                        |   43 +-
 drivers/usb/atm/speedtch.c                      |    3 +-
 drivers/usb/atm/ueagle-atm.c                    | 1384 ++++++++++++---
 drivers/usb/class/usblp.c                       |  116 +-
 drivers/usb/core/config.c                       |   24 +-
 drivers/usb/core/devio.c                        |   77 +-
 drivers/usb/core/driver.c                       |   90 +-
 drivers/usb/core/endpoint.c                     |    1 -
 drivers/usb/core/generic.c                      |   26 +-
 drivers/usb/core/hcd.c                          |  718 +++++----
 drivers/usb/core/hcd.h                          |   46 +-
 drivers/usb/core/hub.c                          |  276 +++-
 drivers/usb/core/message.c                      |   50 +-
 drivers/usb/core/quirks.c                       |   81 +-
 drivers/usb/core/sysfs.c                        |   50 +
 drivers/usb/core/urb.c                          |  106 +-
 drivers/usb/core/usb.c                          |   41 +-
 drivers/usb/core/usb.h                          |    5 +
 drivers/usb/gadget/Kconfig                      |   26 +-
 drivers/usb/gadget/Makefile                     |    1 +
 drivers/usb/gadget/amd5536udc.c                 |    9 +-
 drivers/usb/gadget/at91_udc.c                   |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c             | 2077 +++++++++++++++++++++++
 drivers/usb/gadget/atmel_usba_udc.h             |  352 ++++
 drivers/usb/gadget/config.c                     |    2 +-
 drivers/usb/gadget/dummy_hcd.c                  |   93 +-
 drivers/usb/gadget/epautoconf.c                 |    2 +-
 drivers/usb/gadget/ether.c                      |  155 +-
 drivers/usb/gadget/file_storage.c               |  249 ++--
 drivers/usb/gadget/fsl_usb2_udc.c               |   13 +-
 drivers/usb/gadget/gmidi.c                      |   82 +-
 drivers/usb/gadget/goku_udc.c                   |    2 +-
 drivers/usb/gadget/inode.c                      |   46 +-
 drivers/usb/gadget/lh7a40x_udc.h                |    2 +-
 drivers/usb/gadget/m66592-udc.c                 |    2 +-
 drivers/usb/gadget/net2280.c                    |    2 +-
 drivers/usb/gadget/omap_udc.c                   |   12 +-
 drivers/usb/gadget/pxa2xx_udc.c                 |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                |    2 +-
 drivers/usb/gadget/serial.c                     |  174 +-
 drivers/usb/gadget/usbstring.c                  |    2 +-
 drivers/usb/gadget/zero.c                       |  239 ++--
 drivers/usb/host/Kconfig                        |   13 +
 drivers/usb/host/ehci-au1xxx.c                  |    6 +-
 drivers/usb/host/ehci-hcd.c                     |   22 +-
 drivers/usb/host/ehci-pci.c                     |    5 +-
 drivers/usb/host/ehci-ppc-soc.c                 |    6 +-
 drivers/usb/host/ehci-ps3.c                     |    2 +-
 drivers/usb/host/ehci-q.c                       |   99 +-
 drivers/usb/host/ehci-sched.c                   |   47 +-
 drivers/usb/host/isp116x-hcd.c                  |   61 +-
 drivers/usb/host/ohci-dbg.c                     |    8 +-
 drivers/usb/host/ohci-hcd.c                     |  234 ++-
 drivers/usb/host/ohci-mem.c                     |    1 -
 drivers/usb/host/ohci-pci.c                     |   22 +-
 drivers/usb/host/ohci-ppc-of.c                  |    5 +-
 drivers/usb/host/ohci-ppc-soc.c                 |    5 +
 drivers/usb/host/ohci-q.c                       |  187 +-
 drivers/usb/host/ohci-ssb.c                     |  247 +++
 drivers/usb/host/ohci.h                         |   39 +-
 drivers/usb/host/r8a66597-hcd.c                 |  172 +-
 drivers/usb/host/sl811-hcd.c                    |   74 +-
 drivers/usb/host/u132-hcd.c                     |  370 +++--
 drivers/usb/host/uhci-debug.c                   |    4 +-
 drivers/usb/host/uhci-hcd.h                     |   16 -
 drivers/usb/host/uhci-q.c                       |   70 +-
 drivers/usb/misc/adutux.c                       |    3 +-
 drivers/usb/misc/berry_charge.c                 |    7 +-
 drivers/usb/misc/ftdi-elan.c                    |    8 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |  200 +--
 drivers/usb/misc/sisusbvga/sisusb.h             |  130 +-
 drivers/usb/misc/sisusbvga/sisusb_con.c         |   60 +-
 drivers/usb/misc/sisusbvga/sisusb_init.c        |  354 ++---
 drivers/usb/misc/sisusbvga/sisusb_init.h        | 1315 +++++++-------
 drivers/usb/misc/sisusbvga/sisusb_struct.h      |  144 +-
 drivers/usb/mon/mon_bin.c                       |   42 +-
 drivers/usb/mon/mon_main.c                      |   25 +-
 drivers/usb/mon/mon_text.c                      |   72 +-
 drivers/usb/mon/usb_mon.h                       |    2 +-
 drivers/usb/serial/Kconfig                      |   10 +
 drivers/usb/serial/Makefile                     |    1 +
 drivers/usb/serial/ark3116.c                    |    5 -
 drivers/usb/serial/bus.c                        |   16 +
 drivers/usb/serial/ch341.c                      |  354 ++++
 drivers/usb/serial/cp2101.c                     |    3 +-
 drivers/usb/serial/ftdi_sio.c                   |    5 +-
 drivers/usb/serial/funsoft.c                    |   21 -
 drivers/usb/serial/ipaq.c                       |    3 +
 drivers/usb/serial/kl5kusb105.c                 |   28 +-
 drivers/usb/serial/kobil_sct.c                  |  144 +-
 drivers/usb/serial/mct_u232.c                   |   28 +-
 drivers/usb/serial/oti6858.c                    |    2 +-
 drivers/usb/serial/pl2303.c                     |    1 +
 drivers/usb/serial/pl2303.h                     |    1 +
 drivers/usb/serial/safe_serial.c                |   11 -
 drivers/usb/serial/usb-serial.c                 |   42 +-
 drivers/usb/serial/visor.c                      |   64 -
 drivers/usb/storage/initializers.c              |   14 +
 drivers/usb/storage/initializers.h              |    3 +
 drivers/usb/storage/shuttle_usbat.c             |    3 -
 drivers/usb/storage/unusual_devs.h              |   34 +-
 drivers/usb/storage/usb.c                       |    4 +
 drivers/usb/usb-skeleton.c                      |    1 +
 include/linux/usb.h                             |   79 +-
 include/linux/{usb_gadget.h => usb/gadget.h}    |   97 +-
 include/linux/usb/quirks.h                      |    7 +-
 include/linux/usb/serial.h                      |   20 +-
 include/linux/usb_sl811.h                       |   26 -
 117 files changed, 8610 insertions(+), 3843 deletions(-)
 create mode 100644 Documentation/usb/authorization.txt
 create mode 100644 Documentation/usb/power-management.txt
 create mode 100644 drivers/usb/gadget/atmel_usba_udc.c
 create mode 100644 drivers/usb/gadget/atmel_usba_udc.h
 create mode 100644 drivers/usb/host/ohci-ssb.c
 create mode 100644 drivers/usb/serial/ch341.c
 rename include/linux/{usb_gadget.h => usb/gadget.h} (92%)
 delete mode 100644 include/linux/usb_sl811.h

---------------

Adrian Bunk (4):
      USB: Storage: usbat_check_status(): fix check-after-use
      USB: ark3116.c: fix check-after-use
      USB: always visit drivers/usb/misc/
      USB: usb/serial/ch341.c: make 4 functions static

Alan Cox (5):
      USB: kl5kusb105: witch to new speed API
      USB: cp2101: Coding style police
      USB: kobil_sct: Rework driver
      USB: visor: termios bits
      USB: funsoft: Fix termios

Alan Stern (44):
      USB: add urb->ep
      USB: add ep->enable
      USB: add direction bit to urb->transfer_flags
      USB: avoid using urb->pipe in usbcore
      USB: address-0 handling during device initialization
      USB: avoid urb->pipe in usbfs
      USB: avoid urb->pipe in usbmon
      USB: cleanup for previous patches
      USB: update spinlock usage for root-hub URBs
      USB: separate out endpoint queue management and DMA mapping routines
      USB: make HCDs responsible for managing endpoint queues
      USB: don't touch sysfs stuff when altsetting is unchanged
      USB: cleanups for g_file_storage
      USB: remove unnecessary tests in isp116x and sl811
      USB: minor fixes for r8a66597 driver
      USB: remove Iso status value in uhci-hcd
      USB: centralize -EREMOTEIO handling
      USB: add urb->unlinked field
      USB: fix mistake in usb_hcd_giveback_urb
      USB: avoid the donelist after an error in ohci-hcd
      USB: less-restrictive command checking in g-file-storage
      USB: reorganize urb->status use in dummy-hcd
      USB: reorganize urb->status use in ehci-hcd
      USB: reorganize urb->status use in ohci-hcd
      USB: reorganize urb->status use in sl811-hcd
      USB: reorganize urb->status use in r8a66597-hcd
      USB: reorganize urb->status use in usbmon
      USB: Eliminate urb->status usage!
      USB: get rid of urb->lock
      USB: remove traces of urb->status from usbcore
      USB: fix location of statement label in dummy-hcd
      USB: Get rid of annoying endpoint-release message
      USB: move decision to ignore FREEZE events
      USB: break apart flush_endpoint and disable_endpoint
      USB: flush outstanding URBs when suspending
      USB: unusual_devs update for Nokia 6131
      USB: don't propagate FREEZE or PRETHAW suspends
      USB: remove USB_QUIRK_NO_AUTOSUSPEND
      USB: unusual_devs entry for Nikon DSC D2Xs
      USB: mutual exclusion for EHCI init and port resets
      USB: skip autosuspended devices during system resume
      USB: documentation for USB power management
      USB: serial core should respect driver requirements
      USB: fix race in autosuspend reschedule

Andreas Loibl (1):
      usb: serial/pl2303: support for BenQ Siemens Mobile Phone EF81

Andrew M. Bishop (1):
      USB: ftdi_sio: Handle FT232RL devices like FT232BM devices

Andrew Morton (2):
      USB: mct_u232-convert-to-proper-speed-handling-api-fix
      USB: fix gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros

Auke Kok (1):
      USB: AMD5536: use pdev->revision

Benedikt Spranger (1):
      usb-gadget-ether: prevent oops caused by error interrupt race

David Brownell (10):
      USB: usb_gadget.h whitespace fixes
      USB: gadget: gadget_is_{dualspeed,otg} predicates and cleanup
      USB: gadget: ethernet gadget cleanups, shrinkage
      USB: gadget: gmidi cleanups
      USB: gadget: serial gadget cleanups
      USB: gadget: file storage gadget cleanups
      USB: gadget: gadget zero cleanups
      USB: move <linux/usb_gadget.h> to <linux/usb/gadget.h>
      USB: re-remove <linux/usb_sl811.h>
      USB: ehci build fixes on au1xxx, ppc-soc

Edouard Lafargue (1):
      USB: cp2101.c: add additional device ID

Felipe Balbi (8):
      USB: SisUSB2VGA: Whitespace Cleanups
      USB: SisUSB2VGA: Remove if 0'ed code
      USB: SisUSB2VGA: Mis-spelled word
      USB: SisUSB2VGA: Lindent drivers/usb/misc/sisusbvga/sisusb.h
      USB: SisUSB2VGA: Lindent drivers/usb/misc/sisusbvga/sisusb_init.c
      USB: SisUSB2VGA: Lindent drivers/usb/misc/sisusbvga/sisusb_init.h
      USB: SisUSB2VGA: Lindent drivers/usb/misc/sisusbvga/sisusb_struct.h
      USB: SisUSB2VGA: Convert printk to dev_* macros

Frank A Kingswood (1):
      USB: Driver for CH341 USB-serial adaptor

Greg Kroah-Hartman (3):
      USB: rename choose_configuration
      USB: make usb_release_interface static
      USB: fix memory leak in berry_charge driver

Haavard Skinnemoen (2):
      USB: add atmel_usba_udc driver
      atmel_usba_udc: Keep track of the device status

Inaky Perez-Gonzalez (12):
      usb: introduce usb_device authorization bits
      usb: add the concept of default authorization to USB hosts
      usb: cleanup usb_register_bus() and hook up sysfs group
      usb: initialize authorization and wusb bits in USB devices
      usb: usb_set_configuration() obeys authorization
      usb: usb_get_configuration() obeys authorization
      usb: usb_probe_interface() obeys authorization
      usb: usb_generic_probe() obeys authorization
      usb: split usb_new_device for clarity and refactoring
      usb: introduce usb_authorize/deauthorize()
      usb: hook up device authorization to sysfs
      usb: document device authorization

Jesper Juhl (2):
      USB: Clean up duplicate includes in drivers/usb/
      usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver

Johann Wilhelm (1):
      USB: usb-storage: Initialize Huawei E220 properly

Marcelo Tosatti (1):
      USB: EHCI restart speedup

Mariusz Kozlowski (2):
      USB: ftdi-elan.c: kmalloc + memset conversion to kzalloc
      usb: remove redundant memset from amd5536udc

Mark Gross (1):
      USB: usb-skeleton leaking locks on open

Matthias Kaehlcke (1):
      USB: ELAN U132 Host Controller Driver: convert sw_lock to mutex

Micah Gruber (1):
      USB: Remove unneeded pointer intf from speedtch_upload_firmware()

Michael Buesch (1):
      USB: ohci SSB bus glue

Mike Nuss (1):
      USB: OHCI handles more ZFMicro quirks

Nico Erfurth (1):
      USB: Add drivers/usb/misc/iowarrior.c to the Makefile

Nobuhiro Iwamatsu (1):
      USB: Adding support for SHARP WS011SH to ipaq.c

Oliver Neukum (3):
      USB: missing test for ESHUTDOWN in adutux driver
      USB: fix errornous assumption in the usb serial framework revealed by iuu_phoenix
      USB: fix double frees in error code paths of ipaq driver

Ortwin Glück (1):
      USB: Nikon D40X unusual_devs entry

Paolo 'Blaisorblade' Giarrusso (1):
      USB: usbmon doc update - mention new wildcard ('0') bus

Pete Zaitcev (8):
      usblp: Implement the ENOSPC convention
      usblp: Make use of URB_FREE_BUFFER
      usblp: mutex in usblp_check_status
      usblp: Cosmetics
      usbmon: Update pipe removal to suit my taste
      usbmon: Drop DMA mapping for setup packet
      usbmon: Smooth the core code
      usblp: Fix a double kfree

Phil Dibowitz (1):
      USB: unusual_devs modification for Nikon D200

Richard Sharpe (1):
      USB: allow usbstorage to have LUNS greater than 2Tb

Robert P. J. Day (1):
      USB: Remove dead references to "SAFE_SERIAL" CONFIG variables.

Roman Kagan (1):
      usb-serial: show port number in sysfs

Sarah Sharp (1):
      USB: Export URB statistics for powertop

Satyam Sharma (1):
      USB: sisusbvga: Fix bug

Simon Arlott (1):
      USB: cxacru: Use appropriate logging for errors

Stanislaw Gruszka (6):
      UEAGLE: Eagle IV chipset support
      UEAGLE: Devolo and Elsa chipsets support
      UEAGLE: Allow user to choose input interface alternate setting
      UEAGLE: Avoid keyboard driver blocking
      UEAGLE: Do not sleep when device is disconnected
      UEAGLE: Cosmetic

Valentine Barshak (1):
      USB: add runtime frame_no quirk for big-endian OHCI

Vitaly Bordug (1):
      USB: serial gadget: Disable endpoints on unload

WANG Cong (1):
      USB: drivers/usb/misc/sisusbvga/sisusb.c: kill two unused variables

Yoshihiro Shimoda (3):
      USB: r8a66597-hcd: fix Class or Vendor Request
      USB: r8a66597-hcd: fix endian problem
      USB: r8a66597-hcd: fix driver removing

jidong xiao (1):
      USB: fix limited_power setting mistake in hub.c


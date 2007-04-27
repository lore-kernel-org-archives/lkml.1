Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXD0Ugl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXD0Ugl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXD0Ugl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:36:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:40776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbXD0Ugj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:36:39 -0400
Date: Fri, 27 Apr 2007 13:34:17 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.21
Message-ID: <20070427203417.GA3981@suse.de>
References: <20070427185422.GA17509@kroah.com> <20070427185646.GA17578@kroah.com> <alpine.LFD.0.98.0704271300050.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704271300050.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:01:42PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 27 Apr 2007, Greg KH wrote:
> > 
> > Ugh, I just realized that this mite break people using 'git bisect' and
> > diving down into this usb branch.  If you want, I can just redo this
> > whole tree after you pull the driver patches so this doesn't happen.
> 
> Let's do that. I pushed out my pull of the device core, and you can rebase 
> (or whatever) on top of that to make it buildable along the whole series.

Great, I've now done that, there should not be any breakage at all now


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

thanks,

greg k-h


 CREDITS                                 |    8 +
 Documentation/ABI/testing/sysfs-bus-usb |   41 +
 Documentation/kernel-parameters.txt     |    2 +-
 Documentation/usb/usbmon.txt            |   80 +-
 MAINTAINERS                             |   12 +
 drivers/block/ub.c                      |   11 +-
 drivers/usb/Makefile                    |    1 -
 drivers/usb/atm/cxacru.c                |  411 +++-
 drivers/usb/atm/usbatm.c                |   17 +-
 drivers/usb/class/cdc-acm.c             |   81 +-
 drivers/usb/class/cdc-acm.h             |    3 +
 drivers/usb/core/Kconfig                |   25 +-
 drivers/usb/core/devio.c                |   96 +-
 drivers/usb/core/driver.c               |  255 ++-
 drivers/usb/core/hcd.c                  |   34 +-
 drivers/usb/core/hcd.h                  |    3 +
 drivers/usb/core/hub.c                  |   25 +-
 drivers/usb/core/inode.c                |    2 +-
 drivers/usb/core/message.c              |   81 +-
 drivers/usb/core/quirks.c               |    2 +-
 drivers/usb/core/sysfs.c                |  102 +-
 drivers/usb/core/usb.c                  |   46 +-
 drivers/usb/core/usb.h                  |   26 +-
 drivers/usb/gadget/Kconfig              |   22 +
 drivers/usb/gadget/Makefile             |    1 +
 drivers/usb/gadget/ether.c              |    6 +-
 drivers/usb/gadget/fsl_usb2_udc.c       | 2500 +++++++++++++++++
 drivers/usb/gadget/fsl_usb2_udc.h       |  579 ++++
 drivers/usb/gadget/gadget_chips.h       |    8 +
 drivers/usb/gadget/pxa2xx_udc.c         |   98 +-
 drivers/usb/gadget/rndis.h              |    2 +-
 drivers/usb/host/Makefile               |    1 -
 drivers/usb/host/ehci-fsl.h             |    4 +-
 drivers/usb/host/ehci-hub.c             |    4 +
 drivers/usb/host/hc_crisv10.c           | 4550 -------------------------------
 drivers/usb/host/hc_crisv10.h           |  289 --
 drivers/usb/host/ohci-pci.c             |   32 +-
 drivers/usb/host/uhci-q.c               |   16 +-
 drivers/usb/input/ati_remote2.c         |   89 +-
 drivers/usb/input/gtco.c                |    5 +-
 drivers/usb/misc/adutux.c               |   48 +-
 drivers/usb/misc/cypress_cy7c63.c       |    4 +-
 drivers/usb/misc/ftdi-elan.c            |   19 +-
 drivers/usb/misc/iowarrior.c            |   20 +-
 drivers/usb/misc/ldusb.c                |    3 +
 drivers/usb/misc/usblcd.c               |    7 +-
 drivers/usb/mon/mon_bin.c               |   14 +-
 drivers/usb/mon/mon_main.c              |  158 +-
 drivers/usb/mon/mon_text.c              |  315 ++-
 drivers/usb/mon/usb_mon.h               |    6 +-
 drivers/usb/net/catc.c                  |   27 +-
 drivers/usb/net/dm9601.c                |    5 +-
 drivers/usb/net/rndis_host.c            |  112 +-
 drivers/usb/net/usbnet.c                |    8 +-
 drivers/usb/net/usbnet.h                |    1 +
 drivers/usb/serial/Kconfig              |    6 +-
 drivers/usb/serial/aircable.c           |    7 +-
 drivers/usb/serial/ark3116.c            |    3 +-
 drivers/usb/serial/cp2101.c             |    2 +
 drivers/usb/serial/ftdi_sio.c           |   23 +-
 drivers/usb/serial/ftdi_sio.h           |    1 +
 drivers/usb/serial/io_edgeport.c        |  139 +-
 drivers/usb/serial/io_edgeport.h        |    6 -
 drivers/usb/serial/ipaq.c               |    1 +
 drivers/usb/serial/kl5kusb105.c         |   28 +-
 drivers/usb/serial/mct_u232.c           |   12 +-
 drivers/usb/serial/mos7720.c            |   34 +-
 drivers/usb/serial/mos7840.c            |  233 +-
 drivers/usb/serial/omninet.c            |   40 +-
 drivers/usb/serial/option.c             |   23 +-
 drivers/usb/serial/sierra.c             |   25 +-
 drivers/usb/serial/visor.c              |   22 +-
 drivers/usb/serial/whiteheat.c          |    8 +-
 drivers/usb/serial/whiteheat.h          |    4 -
 drivers/usb/storage/libusual.c          |    3 +-
 drivers/usb/storage/unusual_devs.h      |    9 -
 drivers/usb/usb-skeleton.c              |   41 +-
 include/linux/usb.h                     |   22 +-
 include/linux/usb/cdc.h                 |   11 +
 include/linux/usb/ch9.h                 |   15 +-
 80 files changed, 5355 insertions(+), 5680 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-usb
 create mode 100644 drivers/usb/gadget/fsl_usb2_udc.c
 create mode 100644 drivers/usb/gadget/fsl_usb2_udc.h
 delete mode 100644 drivers/usb/host/hc_crisv10.c
 delete mode 100644 drivers/usb/host/hc_crisv10.h

---------------

Adrian Bunk (1):
      USB: gtco.c: fix a use-before-check

Alan Stern (10):
      usbcore: move usb_autosuspend_work
      USB: fix race in HCD removal
      USB: separate autosuspend from external suspend
      USB: Allow autosuspend delay to equal 0
      EHCI: add delay to bus_resume before accessing ports
      UHCI: Add some WARN_ON()s
      USB: add power/level sysfs attribute
      USB: add "last_busy" field for use in autosuspend
      USB: fix signed jiffies issue in autosuspend logic
      USB: add "busnum" attribute for USB devices

Christian Engelmayer (1):
      ehci-fsl: change SI_CTRL, PRI_CTRL register offsets according to errata

Craig Shelley (1):
      USB: CP2101 New Device IDs

Cyrill Gorcunov (1):
      USB Elan FTDI: check for driver registration status

David Brownell (6):
      pxa2xx_udc: cleanups, use platform_get_irq
      USB: <linux/usb/ch9.h> minor doc update
      USB: rndis_host, various cleanups
      USB: usbnet reports minidriver name through ethtool
      USB: add an ohci board-specific quirk
      USB: remove ancient/broken CRIS hcd

Eberhard Fahle (1):
      USB: iowarrior.c: timeouts too small in usb_control_msg calls

Erik Hovland (1):
      usb ethernet gadget, workaround network stack API glitch

Greg Kroah-Hartman (1):
      USB: sierra: add more checks on shutdown

Hans Engelen (1):
      USB: dell device id for option.c

Jelle Foks (1):
      USB: ftdi_sio: Add USB ID of ADSTech USBX-707

Joey Goncalves (1):
      USB: add picdem device to ldusb

Kay Sievers (1):
      USB: make usbdevices export their device nodes instead of using a separate class

Leon Leong (1):
      USB: BandRich BandLuxe HSDPA Data Card Driver

Li Yang (3):
      USB: add Freescale high-speed USB SOC device controller driver
      USB: update gadget files for fsl_usb2_udc driver
      USB: update MAINAINERS and CREDITS for Freescale USB driver

Milan Svoboda (1):
      USB: pxa2xx_udc: fix hardcoded irq number

Norihiko Tomiyama (1):
      Adding PID of SHARP S01SH for ipaq.c

Oliver Neukum (26):
      USB: fix skeleton driver
      USB: kill BKL in skeleton driver
      USB: kill BKL in usblcd
      USB: additional structure from cdc spec
      USB: cdc-acm: export parsed capabilities through sysfs
      USB: unnecessary GFP_ATOMIC in mos7720 driver
      mos7720 update
      USB: help text for mos 7720 driver
      USB: io_edgeport race condition in counters
      USB: overhaul of mos7840 driver
      USB: iowarrior.c: fix NULL dereference
      USB: fix endianness in mos7720
      USB: omninet memory leak in error case
      USB: option close race
      USB: sierra close race
      USB: aircable cleanup
      USB: fix race in visor_write
      USB: fix race in ftdio_write
      USB: fix ark3116 memory leak
      USB: cypress_cy7c63: race disconnect/sysfs read-write leading to following NULL pointer
      USB: fix catc error handling
      USB: fix error handling in kl5kusb
      USB: fix error handling for mct_u232
      USB: fix omninet write vs. close race
      USB: cleanup ofd adutux
      usbfs micro optimitation

Pete Zaitcev (4):
      usbmon: Extended text API
      ub: Bind to first endpoint, not to last
      libusual: change block scope variable to function scope
      usbmon: bus zero

Peter Stokes (1):
      USB: ati_remote2: Add channel support

Phil Dibowitz (1):
      USB: Remove Huawei unusual_devs entry

Randy Dunlap (2):
      USB: dm9601: fix sparse NULL warnings
      USB: gadget-storage needs BLOCK

Raphael Assenat (1):
      USB: quirk for broken suspend of IT8152F/G

Richard Knutsson (2):
      USB: io_edgeport: Convert to generic boolean
      USB: whiteheat: Convert to generic boolean

S.Caglar Onur (1):
      USB: Remove duplicate define of OHCI_QUIRK_ZFMICRO

Simon Arlott (5):
      usbatm: create sysfs link "device" from atm class device to usb interface
      USB: cxacru: export detailed device info through sysfs
      USB: MAINTAINERS: cxacru
      usbatm: Detect usb device shutdown and ignore failed urbs
      USB: cxacru: ADSL state management

Tony Lindgren (1):
      USB: Allow transfer_buffer with transfer_dma

Wu, Bryan (1):
      USB gadget rndis: fix struct rndis_packet_msg_type unaligned bug


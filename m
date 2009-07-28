Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZG1Vjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZG1Vjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZG1Vjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:39:35 -0400
Received: from kroah.org ([198.145.64.141]:44372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbZG1Vje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:39:34 -0400
Date: Tue, 28 Jul 2009 14:38:13 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.31-rc4-git
Message-ID: <20090728213813.GA13090@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your kernel tree.

The majority of these are fixes for the USB 3.0 controller driver, xhci,
which is new in the .31 tree, so there's no chance of regressions here.

The rest are minor things:
	- build fixes
	- new device ids
	- musb bugfixes
	- Kconfig fixes
	- other minor bugfixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/config.c          |   48 +++---
 drivers/usb/host/ehci-orion.c      |    2 +-
 drivers/usb/host/ohci-omap.c       |    1 +
 drivers/usb/host/xhci-dbg.c        |  199 ++++++++++++++---------
 drivers/usb/host/xhci-hcd.c        |  290 +++++++++++++++++++++++-----------
 drivers/usb/host/xhci-mem.c        |  300 ++++++++++++++++++++++++++---------
 drivers/usb/host/xhci-pci.c        |    1 +
 drivers/usb/host/xhci-ring.c       |  305 +++++++++++++++++++++++++----------
 drivers/usb/host/xhci.h            |  148 +++++++++++++-----
 drivers/usb/misc/Kconfig           |    2 +-
 drivers/usb/musb/musb_core.c       |    3 +-
 drivers/usb/musb/musb_gadget_ep0.c |    2 +-
 drivers/usb/musb/musb_regs.h       |    1 +
 drivers/usb/serial/cp210x.c        |    3 +
 drivers/usb/serial/ftdi_sio.c      |    1 +
 drivers/usb/serial/ftdi_sio.h      |    7 +
 drivers/usb/serial/mos7840.c       |    9 +-
 drivers/usb/serial/option.c        |  133 ++++++++++------
 drivers/usb/storage/transport.c    |    2 +-
 19 files changed, 1012 insertions(+), 445 deletions(-)

---------------

Ajay Kumar Gupta (1):
      USB: musb: fix CONFIGDATA register read issue

Alan Stern (1):
      USB: usbtest: no need for USB_DEVICEFS

Amit Kucheria (1):
      USB: musb: Refer to musb_otg_timer_func under correct #ifdef

Anand Gadiyar (1):
      USB: OMAP: OHCI: hc_driver's stop method should call ohci_stop

Carlos R. Mafra (1):
      USB: option: Remove unused variable

Craig Shelley (1):
      USB: CP210x Add new device IDs

Giacomo Lozito (1):
      USB: storage: raise timeout in usb_stor_Bulk_max_lun

Herton Ronaldo Krzesinski (1):
      USB: option: add ZTE device ids and remove ONDA ids

Javier Martin (1):
      USB: option.c to support Alcatel X060S/X200 broadband modems

John Youn (2):
      USB: xhci: Scratchpad buffer allocation
      USB: xhci: Support for 64-byte contexts

Oliver Neukum (1):
      USB: let the option driver compile without CONFIG_PM

Peng Huang (1):
      USB: serial: option: Add ZTE AC8710 usb modem device.

Roel Kluin (1):
      USB: xhci: fix less- and greater than confusion

Russell Lang (1):
      USB: aten uc2324 is really a moschip 7840

Sarah Sharp (15):
      USB: xhci: Set TD size in transfer TRB.
      USB: xhci: Deal with stalled endpoints.
      USB: xhci: Use GFP_ATOMIC while holding spinlocks.
      USB: xhci: Represent 64-bit addresses with one u64.
      USB: xhci: Handle short control packets correctly.
      USB: xhci: Correct Event Handler Busy flag usage.
      USB: xhci: Make debugging more verbose.
      USB: xhci: Don't oops if the host doesn't halt.
      USB: xhci: Check if the host controller died in IRQ handler.
      USB: xhci: Setup HW retries correctly.
      USB: xhci: Handle babble errors on transfers.
      USB: xhci: Fail gracefully if there's no SS ep companion descriptor.
      USB: Fix parsing of SuperSpeed Endpoint Companion descriptor.
      USB: xhci: Always align output device contexts to 64 bytes.
      USB: xhci: Stall handling bug fixes.

Sergei Shtylyov (1):
      USB: musb_gadget_ep0: fix typo in service_zero_data_request()

Simon Kagstrom (1):
      USB: ehci-orion: Call ehci_reset before ehci_halt

Tim Gardner (1):
      USB: option: Add USB ID for Novatel MC727/U727/USB727 refresh

Ville Sundberg (1):
      USB: ftdi_sio: Add support for GN Otometrics Aurical USB Audiometer


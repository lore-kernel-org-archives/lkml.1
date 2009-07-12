Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZGLWkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZGLWkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZGLWjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:39:55 -0400
Received: from kroah.org ([198.145.64.141]:34685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZGLWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:39:54 -0400
Date: Sun, 12 Jul 2009 15:37:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.31-rc2-git
Message-ID: <20090712223711.GA16600@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your kernel tree.

They do:
  - 2 reverts, one making usbfs easier to configure in, fixing a problem
    on Red Hat machines, and the other removing a driver that should not
    have been added yet, due to no infrastructure using/needing it yet.
    The latter one dominates the diffstat.
  - lots of bugfixes
  - new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c           |   31 +-
 drivers/usb/class/usbtmc.c            |   10 +-
 drivers/usb/core/Kconfig              |    2 +-
 drivers/usb/core/devices.c            |   10 +-
 drivers/usb/core/devio.c              |   78 +-
 drivers/usb/core/hcd.h                |    4 +
 drivers/usb/core/hub.c                |   40 +-
 drivers/usb/core/hub.h                |    6 +-
 drivers/usb/core/message.c            |   63 +-
 drivers/usb/gadget/Kconfig            |   43 +-
 drivers/usb/gadget/audio.c            |    6 +-
 drivers/usb/gadget/ether.c            |   11 +-
 drivers/usb/gadget/pxa25x_udc.c       |   24 +-
 drivers/usb/gadget/rndis.c            |    2 +
 drivers/usb/host/Kconfig              |   29 +-
 drivers/usb/host/ehci-au1xxx.c        |    2 +
 drivers/usb/host/ehci-fsl.c           |    2 +
 drivers/usb/host/ehci-hcd.c           |   37 +-
 drivers/usb/host/ehci-ixp4xx.c        |    2 +
 drivers/usb/host/ehci-orion.c         |    2 +
 drivers/usb/host/ehci-pci.c           |    2 +
 drivers/usb/host/ehci-ppc-of.c        |    2 +
 drivers/usb/host/ehci-ps3.c           |    2 +
 drivers/usb/host/ehci-q.c             |  140 ++-
 drivers/usb/host/ehci-sched.c         |   12 +-
 drivers/usb/host/ehci.h               |    2 +
 drivers/usb/host/fhci-sched.c         |    8 +-
 drivers/usb/host/isp1760-if.c         |    2 +-
 drivers/usb/musb/davinci.c            |   32 +-
 drivers/usb/musb/musb_host.c          |   27 +-
 drivers/usb/otg/Kconfig               |   14 -
 drivers/usb/otg/Makefile              |    1 -
 drivers/usb/otg/langwell_otg.c        | 1915 ---------------------------------
 drivers/usb/otg/nop-usb-xceiv.c       |    1 +
 drivers/usb/serial/console.c          |   13 +-
 drivers/usb/serial/cp210x.c           |    2 +
 drivers/usb/serial/cypress_m8.c       |    4 +-
 drivers/usb/serial/ftdi_sio.c         |   67 ++-
 drivers/usb/serial/ftdi_sio.h         |   18 +-
 drivers/usb/serial/option.c           |   45 +-
 drivers/usb/serial/pl2303.c           |    1 +
 drivers/usb/serial/pl2303.h           |    4 +
 drivers/usb/serial/sierra.c           |   51 +-
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +-
 drivers/usb/serial/usb-serial.c       |    3 +-
 drivers/usb/storage/option_ms.c       |    3 +
 include/linux/usb.h                   |    6 +-
 include/linux/usb/langwell_otg.h      |  177 ---
 48 files changed, 578 insertions(+), 2383 deletions(-)
 delete mode 100644 drivers/usb/otg/langwell_otg.c
 delete mode 100644 include/linux/usb/langwell_otg.h

---------------

Ajay Kumar Gupta (1):
      USB: otg: fix module reinsert issue

Alan Stern (9):
      USB: EHCI: update toggle state for linked QHs
      USB: fix the clear_tt_buffer interface
      USB: EHCI: use the new clear_tt_buffer interface
      USB: EHCI: check for STALL before other errors
      USB: Sierra: fix oops upon device close
      USB: cypress_m8: remove invalid Clear-Halt
      USB: option: remove unnecessary and erroneous code
      USB: EHCI: report actual_length for iso transfers
      USB: handle zero-length usbfs submissions correctly

Amit Kucheria (1):
      USB: Serial: Add support for Arkham Technology adapters

Anssi Hannula (1):
      USB: option.c: add A-Link 3GU device id

Arnd Bergmann (1):
      USB: buildfix ppc randconfig

Arseniy Lartsev (1):
      USB: cdc-acm: work around some broken devices

Brad Lu (1):
      USB: option.c to support Qisda H21/H20 usb modem

Dan Williams (1):
      USB: option: add Novatel Ovation MC760

Daniel Mack (1):
      USB: fix LANGID=0 regression

David Brownell (4):
      USB: musb: davinci dm355 updates (remainder)
      USB: gadget: pxa25x compiler warning fix
      USB: musb: silence "suspend as a_wait_vrise is_active" msgs
      USB: RNDIS gadget, fix issues talking from PXA

Elina Pasheva (1):
      USB: serial: sierra driver id_table additions

Folkert van Heusden (1):
      USB: serial: FTDI with product code FB80 and vendor id 0403

Frans Pop (1):
      USB: add missing class descriptions used in usb/devices file

Gianpaolo Cugola (1):
      USB: pl2303: New vendor and product id for the prolific driver

Greg Kroah-Hartman (4):
      Revert "USB: Add Intel Langwell USB OTG Transceiver Drive"
      USB: gadget: audio: provide correct device id
      USB: ti_usb_3410_5052: fix duplicate device ids.
      Revert USB: usbfs: deprecate and hide option for !embedded

Jan Capek (1):
      USB: ftdi_sio - product ID's for CCS PIC programmers

Jason Wessel (1):
      USB: console: Fix regression in usb console on kernel boot

Jonathan McDowell (1):
      USB: Fix option_ms regression in 2.6.31-rc2

Kai Engert (1):
      USB: option.c: add Qualcomm/Option iCON 210 modem

Kevin Hilman (1):
      USB: musb: davinci dm6446evm GPIO renumbering

Krzysztof Halasa (1):
      USB serial: Add ID for Turtelizer, an FT2232L-based JTAG/RS-232 adapter.

Martin Geleynse (1):
      USB: ftdi: support NDI devices

Mike Frysinger (1):
      USB: isp1760: use __devexit_p() for remove function

Oliver Neukum (4):
      USB: fix memory leak in usbtmc
      USB: fix uninitialised variable in ti_do_download
      USB: fix memleak in usbfs
      USB: fix race leading to a write after kfree in usbfs

Paulius Zaleckas (1):
      USB: gadget: fix imx_udc entry in Kconfig

Philipp Zabel (1):
      USB: gadget: pxa25x uses gpio_is_valid

Qiuping Chen (1):
      USB: gadget: rndis conformance tweak

Randy Dunlap (2):
      USB: usb.h: fix kernel-doc notation
      USB: gadget audio: select SND_PCM

Roel Kluin (1):
      USB: fhci: mutually exclusive port_status

Sergei Shtylyov (1):
      USB: musb_host: undo incorrect change in musb_advance_schedule()


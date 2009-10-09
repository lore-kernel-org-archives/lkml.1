Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbZJIVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbZJIVGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbZJIVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:06:00 -0400
Received: from kroah.org ([198.145.64.141]:55127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbZJIVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:05:59 -0400
Date: Fri, 9 Oct 2009 14:02:41 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bugfixes for 2.6.32-git
Message-ID: <20091009210241.GA4348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of bugfixes for your 2.6.32-git tree.

It contains a big ftdi_sio driver update, hopefully fixing all of the
nasty problems that people have found in this driver recently.  Many
thanks to Johan for taking this work on.

There's lots of other little bugfixes, all over the usb tree, for
details, see the shortlog below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/usbtmc.c           |    2 +-
 drivers/usb/gadget/imx_udc.c         |    8 +-
 drivers/usb/host/ehci-sched.c        |    1 +
 drivers/usb/host/isp1362-hcd.c       |   18 +-
 drivers/usb/host/isp1362.h           |   12 +-
 drivers/usb/host/xhci-hcd.c          |   29 +++-
 drivers/usb/misc/usblcd.c            |    3 +-
 drivers/usb/musb/Kconfig             |    2 +-
 drivers/usb/musb/blackfin.c          |    1 -
 drivers/usb/musb/musb_core.h         |    7 +
 drivers/usb/musb/musb_regs.h         |    9 -
 drivers/usb/serial/aircable.c        |   10 +-
 drivers/usb/serial/cp210x.c          |    1 +
 drivers/usb/serial/cypress_m8.c      |   12 +-
 drivers/usb/serial/digi_acceleport.c |    8 +-
 drivers/usb/serial/empeg.c           |    2 +-
 drivers/usb/serial/ftdi_sio.c        |  422 +++++++++++-----------------------
 drivers/usb/serial/garmin_gps.c      |   12 +-
 drivers/usb/serial/generic.c         |    2 +-
 drivers/usb/serial/ipaq.c            |    9 +
 drivers/usb/serial/keyspan_pda.c     |    2 +-
 drivers/usb/serial/kl5kusb105.c      |    2 +-
 drivers/usb/serial/mct_u232.c        |   14 +-
 drivers/usb/serial/opticon.c         |   13 +-
 drivers/usb/serial/option.c          |    4 +
 drivers/usb/serial/oti6858.c         |    6 +-
 drivers/usb/serial/pl2303.c          |    8 +-
 drivers/usb/serial/sierra.c          |    2 +-
 drivers/usb/serial/symbolserial.c    |   22 +-
 drivers/usb/serial/usb-serial.c      |   10 +-
 drivers/usb/serial/visor.c           |   28 ++-
 drivers/usb/serial/whiteheat.c       |   10 +-
 drivers/usb/storage/transport.c      |   29 ++-
 drivers/usb/storage/unusual_devs.h   |    7 +
 include/linux/usb/serial.h           |    1 +
 35 files changed, 316 insertions(+), 412 deletions(-)

---------------

Alan Stern (3):
      USB: serial: don't call release without attach
      USB: ipaq: fix oops when device is plugged in
      USB: storage: When a device returns no sense data, call it a Hardware Error

Elina Pasheva (1):
      USB: serial: sierra driver version change to 1.3.8

Gergely Imreh (1):
      USB: usbtmc: fix timeout increase

Jiri Slaby (1):
      USB: usblcd, fix memory leak

Johan Hovold (6):
      USB: ftdi_sio: remove tty->low_latency
      USB: ftdi_sio: remove unused rx_byte counter
      USB: ftdi_sio: clean up read completion handler
      USB: ftdi_sio: re-implement read processing
      USB: pl2303: fix error characters not being reported to ldisc
      USB: digi_acceleport: Fix broken unthrottle.

Joris van Rantwijk (1):
      USB: Fix throttling in generic usbserial driver

Mike Frysinger (2):
      USB: musb: make HAVE_CLK support optional
      USB: isp1362: fix build warnings on 64-bit systems

Oliver Neukum (7):
      USB: visor: fix trivial accounting bug in visor driver
      USB: small fix in error case of suspend in generic usbserial code
      USB: serial: fix race between unthrottle and completion handler in opticon
      USB: serial: fix race between unthrottle and completion handler in symbolserial
      USB: serial: fix assumption that throttle/unthrottle cannot sleep
      USB: serial: fix race between unthrottle and completion handler in visor
      USB: serial: no unnecessary GFP_ATOMIC in oti6858

Peter Magdina (1):
      USB: option: Toshiba G450 device id

Ronnie Furuskog (1):
      USB: option: Patch for Huawei Mobile Broadband E270+ Modem

Sarah Sharp (5):
      USB: xhci: Stop debugging polling loop when HC dies.
      USB: xhci: Handle canceled URBs when HC dies.
      USB: xhci: Don't wait for a disable slot cmd when HC dies.
      USB: xhci: Fix dropping endpoints from the xHC schedule.
      USB: ehci: Fix isoc scheduling boundary checking.

Sergey Pinaev (1):
      USB: storage: iRiver P7 UNUSUAL_DEV patch

Tobias Klauser (1):
      USB: gadget: imx_udc: Use resource size

Éric Piel (1):
      USB: cp210x: Add support for the DW700 UART


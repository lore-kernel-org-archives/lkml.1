Return-Path: <linux-kernel-owner+w=401wt.eu-S965833AbXCJEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833AbXCJEF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXCJEF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:05:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbXCJEF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:05:27 -0500
Date: Fri, 9 Mar 2007 20:03:46 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.21-rc3
Message-ID: <20070310040346.GA30638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and new device ids against 2.6.21-rc3.

These patches contain a number of fixes that lots of people have
reported with regards to usb-serial devices oopsing and providing
incorrect minor numbers.  They also add a number of new device ids and
some other minor fixes.

All of these have been in the -mm releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/class/cdc-acm.c        |    8 ++--
 drivers/usb/core/devio.c           |   13 ++---
 drivers/usb/core/hub.c             |    9 +---
 drivers/usb/core/message.c         |    9 +++-
 drivers/usb/gadget/at91_udc.c      |    6 +-
 drivers/usb/gadget/goku_udc.c      |   29 ------------
 drivers/usb/gadget/pxa2xx_udc.c    |    2 +-
 drivers/usb/host/ehci-hub.c        |    3 +-
 drivers/usb/host/uhci-hub.c        |   11 +++--
 drivers/usb/misc/ftdi-elan.c       |   18 ++++++-
 drivers/usb/net/dm9601.c           |    4 ++
 drivers/usb/serial/airprime.c      |   47 +++++++++++++++++++
 drivers/usb/serial/cp2101.c        |    2 +
 drivers/usb/serial/ftdi_sio.c      |   90 ++++++++++++++++++-----------------
 drivers/usb/serial/ftdi_sio.h      |   21 ++++++++
 drivers/usb/serial/ipaq.c          |    2 +
 drivers/usb/serial/usb-serial.c    |   22 ++++----
 drivers/usb/storage/unusual_devs.h |   17 +++----
 18 files changed, 186 insertions(+), 127 deletions(-)

---------------

Alan Stern (2):
      USB: set the correct interval for interrupt URBs
      UHCI: fix port resume problem

Andre Spahlinger (1):
      USB: ipaq.c: Additional devices

Andrew Nayenko (1):
      USB storage: Nokia 6288 unusual_devs entry

Cyrill Gorcunov (1):
      USB Elan FTDI: check for workqueue creation

David Brownell (1):
      USB: at91_udc, fix more modpost bogosity (rename driver struct)

Gard Spreemann (1):
      USB: Product ID for FT232RL in ftdi_sio

Jim Radford (2):
      usb-serial: fix shutdown / device_unregister order
      USB: ftdi_sio: use port_probe / port_remove thereby fixing access to the latency_timer

Jon K Hellan (1):
      USB: New device IDs for cp2101 driver

Martin Schiller (1):
      USB: RTS/DTR signal patch for airprime driver

Max Dmitrichenko (1):
      USB: fix Unaligned access in EHCI driver

Michael Olberg (1):
      USB: add QL355P power supply ids to fdti_sio

Milan Svoboda (1):
      USB: pxa2xx_udc: fix hardcoded irq number

Oliver Neukum (5):
      USB: ratelimit debounce error messages
      USB: kill dead code from hub.c
      USB: fix usb-serial device naming bug
      USB: further fix for usb-serial
      USB: fix spinlock recursion in cdc-acm.c

Phil Dibowitz (1):
      USB storage: Removed duplicate supertop unusual_dev entry

Ralf Baechle (1):
      USB: goku_udc: Remove crude cache coherency code

Thomas Schleusener (1):
      USB: add Additional PIDs in ftdi_sio

YOSHIFUJI Hideaki (1):
      USBNET: DM9501: Add Corega FEther USB-TXC support.


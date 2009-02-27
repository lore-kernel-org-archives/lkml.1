Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZB0WsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZB0WsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZB0Wr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:47:58 -0500
Received: from kroah.org ([198.145.64.141]:50780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753602AbZB0Wr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:47:57 -0500
Date: Fri, 27 Feb 2009 14:45:50 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090227224550.GA19545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your 2.6-git tree.

Mostly musb driver bugfixes here, but there are some device id updates
and a ehci fix that some v4l drivers need, as well as other minor fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 arch/arm/mach-davinci/board-evm.c  |    6 +-
 arch/arm/mach-davinci/clock.c      |    5 ++
 arch/arm/mach-davinci/usb.c        |    1 +
 drivers/usb/class/cdc-acm.c        |    9 ++++
 drivers/usb/core/message.c         |   11 +++-
 drivers/usb/gadget/Kconfig         |    1 +
 drivers/usb/gadget/f_obex.c        |    4 +-
 drivers/usb/gadget/file_storage.c  |    6 ++-
 drivers/usb/gadget/fsl_usb2_udc.c  |    3 +
 drivers/usb/host/ehci-hcd.c        |    2 +
 drivers/usb/host/ehci-mem.c        |    1 +
 drivers/usb/host/ehci-sched.c      |   56 ++++++++++++++++++---
 drivers/usb/host/ehci.h            |    6 ++
 drivers/usb/musb/davinci.c         |   15 ++----
 drivers/usb/musb/musb_core.c       |   13 +++--
 drivers/usb/musb/musb_gadget.c     |    4 +-
 drivers/usb/musb/musb_host.c       |   93 ++++++++++++++++++++++-------------
 drivers/usb/serial/option.c        |   11 ++++-
 drivers/usb/storage/unusual_devs.h |    4 +-
 19 files changed, 176 insertions(+), 75 deletions(-)

---------------

Adam Richter (1):
      USB: Quirk for Hummingbird huc56s / Conexant ACM modem

Alan Stern (3):
      USB: usb-storage: add IGNORE_RESIDUE flag for Genesys Logic adapters
      USB: g_file_storage: automatically disable stalls under Atmel
      USB: usb_get_string should check the descriptor type

Anand Gadiyar (1):
      USB: musb: resume suspended root hub on disconnect

David Brownell (2):
      USB: gadget: fix build error in omap_apollon_2420_defconfig
      usb: musb: make Davinci *work* in mainline

Dmitriy Taychenachev (1):
      USB: cdc-acm: add usb id for motomagx phones

Dmitry Krivoschekov (1):
      USB: musb: fix musb_host_tx() for shared endpoint FIFO

Felipe Balbi (2):
      usb: gadget: obex: select correct ep descriptors
      USB: musb: be careful with 64K+ transfer lengths (gadget side)

Jesse Sung (1):
      USB: option: add BenQ 3g modem information

Karsten Wiese (1):
      USB: EHCI: slow down ITD reuse

Li Yang (1):
      USB: fsl_usb2_udc: fix potential queue head corruption

Patrik Kullman (1):
      USB: serial: add support for second revision of Ericsson F3507G WWAN card

Sergei Shtylyov (5):
      USB: musb: fix urb_dequeue() method
      USB: musb: host endpoint_disable() oops fixes
      USB: musb: fix data toggle saving with shared FIFO
      USB: musb: be careful with 64K+ transfer lengths, host side
      USB: musb: use right poll limit for low speed devices

Vikram Pandita (1):
      USB: musb: fix srp sysfs entry deletion


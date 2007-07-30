Return-Path: <linux-kernel-owner+w=401wt.eu-S969110AbXG3WJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969110AbXG3WJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbXG3WJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:09:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966163AbXG3WJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:09:18 -0400
Date: Mon, 30 Jul 2007 15:08:23 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.23-rc1
Message-ID: <20070730220823.GA5263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.23-rc1 git tree.

They do the following:
	- usb core fix that you ran into with your broken usb-storage
	  device
	- tty fixes (one fix included a big coding style cleanup by Alan
	  Cox, which dominates the diffstat of this series.)
	- more quirk updates for broken devices.
	- io_edgeport regression fix
	- sparse warning cleanups.
	- other minor fixes.

Some of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/Makefile                 |    1 +
 drivers/usb/core/message.c           |   41 +-
 drivers/usb/core/quirks.c            |   22 +
 drivers/usb/gadget/config.c          |    2 +-
 drivers/usb/gadget/epautoconf.c      |    2 +-
 drivers/usb/gadget/ether.c           |    3 +-
 drivers/usb/gadget/inode.c           |    4 +-
 drivers/usb/gadget/m66592-udc.c      |    2 +-
 drivers/usb/gadget/pxa2xx_udc.c      |   30 -
 drivers/usb/gadget/zero.c            |    6 +-
 drivers/usb/serial/cp2101.c          |   69 +--
 drivers/usb/serial/digi_acceleport.c |  970 ++++++++++++++--------------------
 drivers/usb/serial/io_edgeport.c     |   19 +-
 drivers/usb/serial/mct_u232.c        |   54 +-
 drivers/usb/serial/mct_u232.h        |    2 +-
 drivers/usb/serial/sierra.c          |    7 +-
 drivers/usb/serial/usb-serial.c      |   32 +-
 drivers/usb/storage/unusual_devs.h   |   21 +
 include/linux/usb.h                  |    2 +
 19 files changed, 577 insertions(+), 712 deletions(-)

---------------

Adam Kropelin (1):
      usb-serial: Fix edgeport regression on non-EPiC devices

Adrian Bunk (1):
      USB: drivers/usb/serial/sierra.c: make 3 functions static

Alan Cox (3):
      cp2101: Remove broken termios optimisation, use proper speed API
      digi_acceleport: Drag the driver kicking and screaming into coding style
      USB: mct_u232: Convert to proper speed handling API

Alan Stern (1):
      USB: Fix a bug in usb_start_wait_urb

David Brownell (3):
      USB: fix scatterlist PIO case (IOMMU)
      USB: more pxa2xx_udc dead code removal
      USB: "sparse" cleanups for usb gadgets

Jeremy Katz (1):
      USB: Don't let usb-storage steal Blackberry Pearl

Johann Felix Soden (1):
      USB: Add CanonScan LiDE30 to the quirk list

Juergen Beisert (1):
      USB: devices misc: Trivial patch to build the IOWARRIOR when it is selected in Kconfig

Milinevsky Dmitry (1):
      USB: NIKON D50 is an unusual device

Oliver Neukum (5):
      USB: more quirky devices
      USB: even more quirks
      USB: yet another quirky device
      USB: fix usb_serial_suspend(): buggy code
      USB: fix BUG: sleeping function called from invalid context at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524, in_atomic():1, irqs_disabled():0

Randy Dunlap (1):
      USB: usb.h kernel-doc additions


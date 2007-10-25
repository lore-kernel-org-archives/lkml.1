Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbXJYURE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbXJYURE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXJYUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:16:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48957 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXJYUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:16:53 -0400
Date: Thu, 25 Oct 2007 13:12:50 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB patches for 2.6.24-rc1
Message-ID: <20071025201250.GA4478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and changes against your 2.6.24-rc1 git tree.

The majority of these are termios cleanups and fixes, that needed to
wait to go to your tree until after the changes came in to the serial
and tty core from Andrew's tree.  They are all written by Alan Cox, have
been in -mm for a while, and also include a fix to the serial core that
is needed as well.

The other patches are all small USB ones, bugfixes, compile fixes,
annoying sysfs-warnings at runtime, and new device ids.

The majority of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/serial/serial_core.c         |    3 +-
 drivers/usb/core/message.c           |    8 ++-
 drivers/usb/core/urb.c               |    2 +-
 drivers/usb/gadget/amd5536udc.c      |    2 +-
 drivers/usb/host/Kconfig             |    2 +-
 drivers/usb/host/ohci-hcd.c          |    9 ++-
 drivers/usb/host/uhci-q.c            |   19 ++++--
 drivers/usb/misc/cytherm.c           |    4 +-
 drivers/usb/misc/emi26.c             |    4 +
 drivers/usb/misc/emi62.c             |    4 +
 drivers/usb/misc/ftdi-elan.c         |  130 +++++++++++++++++-----------------
 drivers/usb/misc/idmouse.c           |   45 +++++++-----
 drivers/usb/misc/iowarrior.c         |   11 +++-
 drivers/usb/misc/legousbtower.c      |   14 ++++-
 drivers/usb/misc/rio500.c            |   15 +---
 drivers/usb/misc/usblcd.c            |   11 +++-
 drivers/usb/serial/ark3116.c         |   13 +++-
 drivers/usb/serial/ch341.c           |    8 ++-
 drivers/usb/serial/console.c         |    4 +-
 drivers/usb/serial/cp2101.c          |   48 +++----------
 drivers/usb/serial/digi_acceleport.c |   16 +++--
 drivers/usb/serial/empeg.c           |   23 ++----
 drivers/usb/serial/ftdi_sio.c        |   33 +++++----
 drivers/usb/serial/generic.c         |    7 +-
 drivers/usb/serial/io_edgeport.c     |   18 ++---
 drivers/usb/serial/ir-usb.c          |   11 +--
 drivers/usb/serial/keyspan.c         |   16 +++--
 drivers/usb/serial/kobil_sct.c       |    5 +-
 drivers/usb/serial/mos7840.c         |   23 +------
 drivers/usb/serial/option.c          |    5 +-
 drivers/usb/serial/pl2303.c          |   12 ++--
 drivers/usb/serial/pl2303.h          |    1 +
 drivers/usb/serial/sierra.c          |    2 +-
 drivers/usb/serial/usb-serial.c      |    6 ++-
 drivers/usb/serial/whiteheat.c       |   11 +---
 drivers/usb/storage/Kconfig          |    1 -
 drivers/usb/storage/isd200.c         |  105 +++++++++++++++++++++++++++-
 37 files changed, 397 insertions(+), 254 deletions(-)

---------------

Adrian Bunk (2):
      USB iowarrior.c: fix check-after-use
      USB rio500.c: fix check-after-use

Alan Cox (19):
      serial: stop passing NULL to functions that expect data
      USB: ark3116: update termios handling
      usb serial: kill another case we pass NULL and shouldn't
      USB: ch341: fix termios handling
      USB: digi_acceleport: fix termios and also readability a bit
      USB: empeg: clean up and handle speeds
      USB: ir_usb: termios handling
      USB: keyspan termios tidy
      USB: kobil_sct: termios encoding fixups
      USB: option: termios handling
      USB: sierra: termios
      usb-serial: handle NULL termios methods as "no hardware changing support"
      USB: whiteheat: clean up can't happen checks and encode baud rate
      USB: cp2101: convert to new termios
      USB: ftd_sio: cleanups and updates for new termios work
      USB: io_edgeport: cleanups, and tty speed reporting
      USB: isd200: sort out USB/IDE dependancy mess
      USB: mos7840: Clean up old checks and stuff
      USB: pl2303: remove can't happen checks, set speed properly and report baud rate

Alan Stern (2):
      USB: fix scheduling of Iso URBs in uhci-hcd
      USB: fix interface sysfs file-creation bug

Andrew Morton (1):
      USB: ftd_sio cleanups and updates for new termios work checkpatch fixes

David Brownell (2):
      USB: amd5536udc - remove set_mwi() compiler warning
      USB: remove new OHCI build warnings

Greg Kroah-Hartman (1):
      USB: add new Novatel device ids to option driver

Ingo Molnar (1):
      USB: fix ssb_ohci_probe() build bug

Jiri Kosina (1):
      USB: usbserial - fix potential deadlock between write() and IRQ

Masakazu Mokuno (1):
      usb: serial/pl2303: support for IO Data Device RSAQ5

Matthias Kaehlcke (1):
      USB: FTDI Elan driver: Convert ftdi->u132_lock to mutex

Oliver Neukum (8):
      USB: add URB_FREE_BUFFER to permissible flags
      USB: fix locking in idmouse
      USB: fix read vs. disconnect race in cytherm driver
      USB: missing error check in emi26
      USB: missing error check in emi62
      USB: open disconnect race in iowarrior
      USB: disconnect open race in legousbtower
      USB: open disconnect race in usblcd

Sarah Sharp (1):
      USB: usb_serial_resume bug fix


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZDWV21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZDWV21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZDWV2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:28:18 -0400
Received: from kroah.org ([198.145.64.141]:43430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbZDWV2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:28:17 -0400
Date: Thu, 23 Apr 2009 14:25:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.30-rc3
Message-ID: <20090423212505.GA29901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some USB fixes for your 2.6.30-rc3 tree.

Just a number of new device ids, and bugfixes.  The one patch outside of
the usb tree is for the usb class video driver, and has an ack by the
video maintainer to apply it.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/media/video/pwc/pwc-ctrl.c    |  238 +++++++++++++++++++++++----------
 drivers/usb/class/cdc-wdm.c           |   27 +++--
 drivers/usb/core/buffer.c             |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c      |    5 +-
 drivers/usb/gadget/file_storage.c     |   20 +---
 drivers/usb/gadget/omap_udc.c         |    3 +-
 drivers/usb/host/ehci-sched.c         |    2 +-
 drivers/usb/musb/musb_core.c          |    2 +-
 drivers/usb/musb/omap2430.c           |    1 -
 drivers/usb/musb/tusb6010.c           |    1 -
 drivers/usb/musb/tusb6010.h           |    1 -
 drivers/usb/otg/otg.c                 |    3 +-
 drivers/usb/serial/cyberjack.c        |    7 -
 drivers/usb/serial/cypress_m8.c       |    4 -
 drivers/usb/serial/empeg.c            |    6 -
 drivers/usb/serial/garmin_gps.c       |    8 -
 drivers/usb/serial/generic.c          |    6 -
 drivers/usb/serial/io_edgeport.c      |    8 -
 drivers/usb/serial/io_ti.c            |    8 -
 drivers/usb/serial/ipaq.c             |    6 -
 drivers/usb/serial/ipw.c              |    3 -
 drivers/usb/serial/iuu_phoenix.c      |    1 -
 drivers/usb/serial/kobil_sct.c        |    6 -
 drivers/usb/serial/mos7720.c          |    7 -
 drivers/usb/serial/mos7840.c          |   43 ++++---
 drivers/usb/serial/opticon.c          |    8 -
 drivers/usb/serial/option.c           |    3 -
 drivers/usb/serial/sierra.c           |   24 +++-
 drivers/usb/serial/ti_usb_3410_5052.c |   14 +--
 drivers/usb/serial/usb-serial.c       |  104 ++++++++++-----
 drivers/usb/serial/visor.c            |    8 -
 drivers/usb/storage/unusual_devs.h    |    6 +
 include/linux/usb/musb.h              |    5 +
 33 files changed, 319 insertions(+), 271 deletions(-)

---------------

Alan Stern (2):
      USB: serial: fix lifetime and locking problems
      USB: g_file_storage: fix use-after-free bug when closing files

Alexander Beregalov (1):
      USB: musb: fix build when !CONFIG_PM

Chuck Short (1):
      USB: Unusual Device support for Gold MP3 Player Energy

Dan Streetman (1):
      USB: ehci-sched.c: EHCI SITD scheduling bugfix

David Brownell (1):
      USB: gadget: omap_udc uses platform_driver_probe()

David Lopo (1):
      USB: Gadget: MIPS CI13xxx UDC bugfixes

Elina Pasheva (1):
      USB: serial: sierra driver bug fix for composite interface

Jarkko Nikula (1):
      USB: musb: Remove my email address from few musb related drivers

Johannes Berg (1):
      USB: pass mem_flags to dma_alloc_coherent

Mark A. Greer (1):
      USB: musb: Prevent multiple includes of musb.h

Martin Fuzzey (1):
      USB: pwc : do not pass stack allocated buffers to USB core.

Matthias Kaehlcke (1):
      USB: ci13xxx_udc: fix build error

Oliver Neukum (2):
      USB: removal of tty->low_latency hack dating back to the old serial code
      USB: correct error handling in cdc-wdm

Robert Jarzmik (1):
      USB: otg: Fix bug on remove path without transceiver

Tony Cook (2):
      USB: mos7840: add new device id
      USB: fix mos7840 problem with minor numbers


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZBITdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZBITdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZBITdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:33:40 -0500
Received: from kroah.org ([198.145.64.141]:44443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752285AbZBITdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:33:39 -0500
Date: Mon, 9 Feb 2009 11:31:57 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090209193157.GA2194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6-git tree.

Just a few minor bugfixes and device id updates (one of them is a
regression fix, as we incorrectly grabbed bound the wrong device to the
wrong driver, breaking some people's systems.)

We also disable the WARN_ON() in the usb-storage driver that was causing
a lot of reports.  Turns out there are a lot of broken flash disks out
there in the wild, we hopefully can now handle them properly based on
the information we've gathered from kerneloops.org.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/Makefile                  |    1 +
 drivers/usb/class/cdc-acm.c           |    3 -
 drivers/usb/gadget/fsl_qe_udc.c       |   46 +++++++++++++----
 drivers/usb/serial/aircable.c         |    4 +-
 drivers/usb/serial/ftdi_sio.c         |    5 ++-
 drivers/usb/serial/ftdi_sio.h         |    3 +
 drivers/usb/serial/option.c           |   93 ++++++++++++++++++++-------------
 drivers/usb/serial/ti_usb_3410_5052.c |   10 +++-
 drivers/usb/serial/ti_usb_3410_5052.h |    2 +
 drivers/usb/storage/scsiglue.c        |    2 +
 drivers/usb/storage/transport.c       |   36 +------------
 drivers/usb/storage/unusual_devs.h    |   17 +------
 12 files changed, 117 insertions(+), 105 deletions(-)

---------------

Alan Stern (2):
      USB: usb-storage: remove WARN from last-sector hacks
      USB: usb-storage: add Pentax to the bad-vendor list

Anton Vorontsov (6):
      USB: fsl_qe_udc: Fix oops on QE UDC probe failure
      USB: fsl_qe_udc: Fix recursive locking bug in ch9getstatus()
      USB: fsl_qe_udc: Fix QE USB controller initialization
      USB: fsl_qe_udc: Fix disconnects reporting during bus reset
      USB: fsl_qe_udc: Fix muram corruption by disabled endpoints
      USB: fsl_qe_udc: Fix stalled TX requests bug

Dan Carpenter (1):
      USB: ftdi_sio: unlock_kernel() on error in set_serial_info()

Dave Young (1):
      USB: usb-serial: fix the aircable_init failure path

Dirk De Schepper (1):
      USB: option: New mobile broadband modems to be supported

Greg Kroah-Hartman (1):
      Revert USB: option: add Pantech cards

Ivan Kuten (1):
      USB: Correct Makefile to make isp1760 buildable

James Treacy (1):
      USB: cdc-acm.c: remove duplicate lines for MTK gps support

Nick Holloway (1):
      USB: Storage: Update unusual_devs entry for Datafab KECF-USB

Oliver Neukum (1):
      USB: two more usb ids for ti_usb_3410_5052

Stephane Clerambault (1):
      USB: ftdi_sio: add support for the NDI Polaris system


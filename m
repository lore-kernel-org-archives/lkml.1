Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbYENRJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbYENRJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYENRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:09:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:43760 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760980AbYENRJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:09:24 -0400
Date: Wed, 14 May 2008 10:08:54 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.26-rc2
Message-ID: <20080514170854.GA15059@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your 2.6.25-git tree.

They include:
	- new usb-serial driver for Jeff Garzik's phone
	- new device ids
	- minor bugfixes
	- finally fix the issue of the kevent showing up before the
	  sysfs files for the usb devices are present in sysfs.  This
	  has made userspace programmers much happier now.
	- gadget serial driver rework and fixes (this is the majority of
	  the diff, it's a bit large, but worth it in the end as there
	  have been reports of problems with this code that these fixes
	  address.)
	- new usb header file for things in the published spec

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c         |    3 +
 drivers/usb/core/endpoint.c         |   11 +-
 drivers/usb/core/message.c          |    1 +
 drivers/usb/core/sysfs.c            |  137 ++++---
 drivers/usb/core/usb.c              |    1 +
 drivers/usb/core/usb.h              |    4 +
 drivers/usb/gadget/amd5536udc.c     |   10 +-
 drivers/usb/gadget/atmel_usba_udc.c |   48 ++-
 drivers/usb/gadget/pxa27x_udc.c     |   17 +-
 drivers/usb/gadget/pxa27x_udc.h     |    8 +
 drivers/usb/gadget/serial.c         |  778 +++++++++++++++--------------------
 drivers/usb/host/isp1760-hcd.c      |    4 +-
 drivers/usb/host/isp1760-if.c       |    2 +-
 drivers/usb/host/ohci-sm501.c       |    2 +-
 drivers/usb/misc/ldusb.c            |    4 -
 drivers/usb/misc/usbtest.c          |    5 +
 drivers/usb/serial/Kconfig          |    9 +
 drivers/usb/serial/Makefile         |    1 +
 drivers/usb/serial/moto_modem.c     |   70 ++++
 drivers/usb/serial/option.c         |    9 +-
 drivers/usb/storage/unusual_devs.h  |   71 ++--
 include/linux/usb/association.h     |  150 +++++++
 22 files changed, 777 insertions(+), 568 deletions(-)
 create mode 100644 drivers/usb/serial/moto_modem.c
 create mode 100644 include/linux/usb/association.h

---------------

Alan Stern (1):
      USB: create attributes before sending uevent

Dan Williams (1):
      USB: option: add new Dell 5520 HSDPA variant

David Brownell (5):
      USB: serial gadget: cleanup/reorg
      USB: serial gadget: remove needless data structure
      USB: serial gadget: simplify endpoint handling
      USB: serial gadget: descriptor cleanup
      USB: atmel_usba_udc fixes, mostly disconnect()

Eugeniy Meshcheryakov (1):
      USB: do not handle device 1410:5010 in 'option' driver

Filip Aben (1):
      USB: unusual_devs: Add support for GI 0401 SD-Card interface

Greg Kroah-Hartman (3):
      USB: add new moto_modem driver for some Morotola phones
      USB: add association.h
      USB: add Telstra NextG CDMA id to option driver

Harvey Harrison (1):
      usb: fix integer as NULL pointer warnings found by sparse

Iain McFarlane (1):
      USB: add Zoom Telephonics Model 3095F V.92 USB Mini External modem to cdc-acm

Marcin Slusarz (1):
      usbtest: comment on why this code "expects" negative and positive errnos

Phil Dibowitz (1):
      USB: Fix unusual_devs.h ordering

Randy Dunlap (1):
      USB: isp1760: fix printk format

Robert Jarzmik (1):
      USB: pxa27x_udc: minor fixes

Sebastian Siewior (1):
      usb: fix compile warning in isp1760

Xiaofan Chen (1):
      USB: remove PICDEM FS USB demo (04d8:000c) device from ldusb

andreoli@samba.ing.unimo.it (2):
      USB: Support for the ET502HS HDSPA modem
      USB: Support for the ET502HS HDSPA modem in option driver


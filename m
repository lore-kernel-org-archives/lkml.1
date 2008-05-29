Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbYE2VWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbYE2VWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYE2VWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:22:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:50515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYE2VWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:22:10 -0400
Date: Thu, 29 May 2008 14:21:10 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.26-rc4
Message-ID: <20080529212110.GA2870@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.25-git tree.

They include:
	- bugfixes
	- new driver for the isight webcam device to drop firmware into
	  it to make it work.  It's very tiny and self-contained.
	- new device ids.  Lots of them.  They overshadow the new
	  driver, which is pretty funny.
	- usb quirks
	- usb-storage quirks

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/generic.c         |    5 -
 drivers/usb/core/hcd.h             |    2 +
 drivers/usb/core/hub.c             |   15 ++-
 drivers/usb/core/quirks.c          |    4 +
 drivers/usb/core/sysfs.c           |   44 +++---
 drivers/usb/gadget/fsl_usb2_udc.c  |    2 +
 drivers/usb/host/ehci-au1xxx.c     |    1 +
 drivers/usb/host/ehci-fsl.c        |    7 +-
 drivers/usb/host/ehci-hcd.c        |    3 +-
 drivers/usb/host/ehci-hub.c        |   16 ++-
 drivers/usb/host/ehci-ixp4xx.c     |    4 +-
 drivers/usb/host/ehci-orion.c      |    8 +-
 drivers/usb/host/ehci-pci.c        |    4 +-
 drivers/usb/host/ehci-ppc-of.c     |    2 +
 drivers/usb/host/ehci-ppc-soc.c    |    1 +
 drivers/usb/host/ehci-ps3.c        |    1 +
 drivers/usb/host/ehci-q.c          |   15 +-
 drivers/usb/host/ehci-sched.c      |   67 ++++++---
 drivers/usb/host/ehci.h            |    5 +-
 drivers/usb/misc/Kconfig           |   11 ++
 drivers/usb/misc/Makefile          |    1 +
 drivers/usb/misc/isight_firmware.c |  131 ++++++++++++++++++
 drivers/usb/serial/ftdi_sio.c      |  264 +++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h      |  265 +++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/option.c        |   34 +++---
 drivers/usb/serial/pl2303.c        |    1 +
 drivers/usb/serial/pl2303.h        |    1 +
 drivers/usb/storage/unusual_devs.h |   10 +-
 28 files changed, 821 insertions(+), 103 deletions(-)
 create mode 100644 drivers/usb/misc/isight_firmware.c

---------------

Alan Stern (8):
      USB: fix possible deadlock involving sysfs attributes
      USB: add all configs to the "descriptors" attribute
      USB: EHCI: fix up root-hub TT mess
      USB: EHCI: suppress unwanted error messages
      USB: EHCI: fix remote-wakeup regression
      USB: EHCI: fix bug in Iso scheduling
      USB: EHCI: fix performance regression
      USB: usb-storage: unusual_devs update for Cypress ATACB

Javier Smaldone (1):
      USB: Add support for ROKR W5 in unusual_devs.h

Li Yang (1):
      USB: fsl_usb2_udc: fix recursive lock

Matthew Garrett (1):
      USB: Firmware loader driver for USB Apple iSight camera

Michael Karcher (1):
      USB: usb-serial: option: Don't match Huawei driver CD images

Phil Dibowitz (1):
      USB: Fix M600i unusual_devs entry

Ray Molenkamp (1):
      USB: FTDI_SIO : Add support for Matrix Orbital PID Range

René Rebe (1):
      USB: add another scanner quirk

Steve Murphy (1):
      USB: pl2303: another product ID


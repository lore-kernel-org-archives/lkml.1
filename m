Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZLARrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZLARrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZLARrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:47:12 -0500
Received: from kroah.org ([198.145.64.141]:58555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbZLARrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:47:10 -0500
Date: Tue, 1 Dec 2009 09:43:33 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bugfixes for 2.6.32-git
Message-ID: <20091201174333.GA31972@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bugfixes for your 2.6.32-git tree.

These fix:
	- ehci timeout issue that fixes a well-reported uvc video device
	  problem due to some messed up host controller hardware.
	- musb driver issues
	- gadget driver irq bugs
	- ftdi_sio bugfix.
	- new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/hub.c             |    2 +-
 drivers/usb/gadget/amd5536udc.c    |   49 ++++++++++++++---------
 drivers/usb/host/ehci-hcd.c        |    2 +
 drivers/usb/host/ehci-pci.c        |    4 ++
 drivers/usb/host/ehci-q.c          |   16 ++++++-
 drivers/usb/host/ehci-sched.c      |   12 +++++
 drivers/usb/host/ehci.h            |    2 +
 drivers/usb/musb/cppi_dma.c        |   10 ++--
 drivers/usb/musb/musb_core.c       |    4 +-
 drivers/usb/musb/musb_gadget.c     |   79 +++++++++++++++--------------------
 drivers/usb/musb/musb_gadget_ep0.c |    3 +-
 drivers/usb/musb/musb_host.c       |    5 ++-
 drivers/usb/serial/ftdi_sio.c      |    3 +-
 drivers/usb/serial/option.c        |    5 ++
 14 files changed, 118 insertions(+), 78 deletions(-)

---------------

Ajay Kumar Gupta (2):
      USB: musb: Remove unwanted message in boot log
      USB: musb: fix ISOC Tx programming for CPPI DMAs

Alan Stern (1):
      USB: EHCI: don't send Clear-TT-Buffer following a STALL

Daniel Glöckner (2):
      USB: musb: respect usb_request->zero in control requests
      USB: musb: Fix CPPI IRQs not being signaled

Eric W. Biederman (1):
      USB: ftdi_sio: Keep going when write errors are encountered.

Gernot Hillier (1):
      USB: Add support for Mobilcom Debitel USB UMTS Surf-Stick to option driver

Oliver Neukum (1):
      USB: work around for EHCI with quirky periodic schedules

Sergei Shtylyov (1):
      USB: musb_gadget: fix STALL handling

Thomas Dahlmann (1):
      usb: amd5536udc: fixed shared interrupt bug and warning oops


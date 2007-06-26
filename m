Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXFZGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXFZGtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXFZGtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:49:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34235 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXFZGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:49:14 -0400
Date: Mon, 25 Jun 2007 23:43:20 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.22-rc6
Message-ID: <20070626064320.GA19010@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.22-rc6 tree.

They fix a pretty serious gadget file_storage bug, some minor bugs in
other drivers (although the "suck up all kernel memory in the system" is
pretty nasty...) and adds 2 new device ids.

All of these have been in the -mm releases for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/gadget/file_storage.c     |   12 +++++-------
 drivers/usb/misc/iowarrior.c          |    7 ++++---
 drivers/usb/misc/usblcd.c             |   22 ++++++++++++++++++----
 drivers/usb/serial/ftdi_sio.c         |    1 +
 drivers/usb/serial/ftdi_sio.h         |    1 +
 drivers/usb/serial/io_edgeport.c      |    4 ++--
 drivers/usb/serial/option.c           |    6 ++++--
 drivers/usb/serial/ti_usb_3410_5052.c |    8 +++++---
 8 files changed, 40 insertions(+), 21 deletions(-)

---------------

Alexander Gattin (1):
      USB: add new device id to option driver

Luiz Fernando N. Capitulino (1):
      USB: ftdio_sio: New IPlus device ID

Oleg Nesterov (1):
      USB: g_file_storage: call allow_signal()

Oliver Neukum (4):
      USB: ti serial driver sleeps with spinlock held
      USB: memory leak in iowarrior.c
      USB: usblcd doesn't limit memory consumption during write
      USB: fix race leading to use after free in io_edgeport


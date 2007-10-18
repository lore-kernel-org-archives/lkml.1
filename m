Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXJRTYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXJRTYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758007AbXJRTXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:23:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42235 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752993AbXJRTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:23:51 -0400
Date: Thu, 18 Oct 2007 15:23:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: BUG in: Driver core: convert block from raw kobjects to core devices
Message-ID: <Pine.LNX.4.44L0.0710181515560.2779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1004) fixes a refcounting bug in the development version
of the block-device core.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Kay, you have got to start testing your patches better!  Finding and
fixing refcount errors is _not_ one of my favorite ways to pass the
time.  For example, you could see what happens when you insert and
unplug a USB flash disk a few times.

Greg, you'll probably want to just fold this in with Kay's 
block-device.patch.

Alan Stern


Index: usb-2.6/fs/partitions/check.c
===================================================================
--- usb-2.6.orig/fs/partitions/check.c
+++ usb-2.6/fs/partitions/check.c
@@ -516,5 +516,4 @@ void del_gendisk(struct gendisk *disk)
 	sysfs_remove_link(&block_depr, disk->dev.bus_id);
 #endif
 	device_del(&disk->dev);
-	put_device(&disk->dev);
 }


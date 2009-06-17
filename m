Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZFQQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZFQQAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZFQP7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:59:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44851 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752734AbZFQP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:59:50 -0400
Date: Wed, 17 Jun 2009 11:59:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] driver core: remove unheeded warning about driver methods
Message-ID: <Pine.LNX.4.44L0.0906171158190.2820-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1263) removes a warning which has been present for so
long, and consistently ignored, that it obviously is not doing any
good.  It gets triggered on pretty much every boot by the SCSI disk
and cdrom drivers.  Evidently nobody cares.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/base/driver.c
===================================================================
--- usb-2.6.orig/drivers/base/driver.c
+++ usb-2.6/drivers/base/driver.c
@@ -225,12 +225,6 @@ int driver_register(struct device_driver
 
 	BUG_ON(!drv->bus->p);
 
-	if ((drv->bus->probe && drv->probe) ||
-	    (drv->bus->remove && drv->remove) ||
-	    (drv->bus->shutdown && drv->shutdown))
-		printk(KERN_WARNING "Driver '%s' needs updating - please use "
-			"bus_type methods\n", drv->name);
-
 	other = driver_find(drv->name, drv->bus);
 	if (other) {
 		put_driver(other);


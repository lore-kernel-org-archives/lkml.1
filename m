Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0CHVq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:46:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46267 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755837Ab0CHVqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:46:20 -0500
Date: Mon, 8 Mar 2010 16:46:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] Driver core: don't initialize wakeup flags
Message-ID: <Pine.LNX.4.44L0.1003081645100.1297-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1351) removes an unnecessary and unwanted assignment
from device_initialize().  The wakeup flags are set to 0 along with
everything else when the device structure is allocated, so we don't
need to do it again.  Furthermore, the subsystem might already have
set these flags to their correct values; we don't want to override it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -561,7 +561,6 @@ void device_initialize(struct device *de
 	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
-	device_init_wakeup(dev, 0);
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }


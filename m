Return-Path: <linux-kernel-owner+w=401wt.eu-S964892AbXLTPZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbXLTPZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXLTPV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:21:26 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:61350 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbXLTPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:07 -0500
Message-Id: <20071220152105.572943094@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:37 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/47] cio: Set driver->owner on css, ccw and ccwgroup busses.
Content-Disposition: inline; filename=111-cio-driver-owner.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Set the owner field in the embedded struct device_driver to the
value provided in the {css,ccw,ccwgroup}_driver.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/ccwgroup.c |    1 +
 drivers/s390/cio/css.c      |    1 +
 drivers/s390/cio/css.h      |    1 +
 drivers/s390/cio/device.c   |    2 ++
 4 files changed, 5 insertions(+)

Index: quilt-2.6/drivers/s390/cio/ccwgroup.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ quilt-2.6/drivers/s390/cio/ccwgroup.c
@@ -408,6 +408,7 @@ int ccwgroup_driver_register(struct ccwg
 	/* register our new driver with the core */
 	cdriver->driver.bus = &ccwgroup_bus_type;
 	cdriver->driver.name = cdriver->name;
+	cdriver->driver.owner = cdriver->owner;
 
 	return driver_register(&cdriver->driver);
 }
Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -862,6 +862,7 @@ int css_driver_register(struct css_drive
 {
 	cdrv->drv.name = cdrv->name;
 	cdrv->drv.bus = &css_bus_type;
+	cdrv->drv.owner = cdrv->owner;
 	return driver_register(&cdrv->drv);
 }
 EXPORT_SYMBOL_GPL(css_driver_register);
Index: quilt-2.6/drivers/s390/cio/css.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.h
+++ quilt-2.6/drivers/s390/cio/css.h
@@ -65,6 +65,7 @@ struct pgid {
  */
 struct subchannel;
 struct css_driver {
+	struct module *owner;
 	unsigned int subchannel_type;
 	struct device_driver drv;
 	void (*irq)(struct subchannel *);
Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -125,6 +125,7 @@ static void io_subchannel_ioterm(struct 
 static void io_subchannel_shutdown(struct subchannel *);
 
 static struct css_driver io_subchannel_driver = {
+	.owner = THIS_MODULE,
 	.subchannel_type = SUBCHANNEL_TYPE_IO,
 	.name = "io_subchannel",
 	.irq = io_subchannel_irq,
@@ -1476,6 +1477,7 @@ int ccw_driver_register(struct ccw_drive
 
 	drv->bus = &ccw_bus_type;
 	drv->name = cdriver->name;
+	drv->owner = cdriver->owner;
 
 	return driver_register(drv);
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


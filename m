Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYGKJMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYGKJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYGKJM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:12:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21281 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYGKJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:12:27 -0400
Date: Fri, 11 Jul 2008 11:12:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dev_printk doesn't modify dev
Message-ID: <20080711111216.638d0ad3@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add const markings to dev_name and dev_driver_string to make it clear
that dev_printk doesn't modify dev. This is a prerequisite to adding
more const markings to other functions make it clearer, which
functions can modify dev and which can't.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/base/core.c    |    2 +-
 include/linux/device.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.26-rc9.orig/include/linux/device.h	2008-06-05 12:25:13.000000000 +0200
+++ linux-2.6.26-rc9/include/linux/device.h	2008-07-11 10:47:03.000000000 +0200
@@ -379,7 +379,7 @@ struct device {
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
-static inline const char *dev_name(struct device *dev)
+static inline const char *dev_name(const struct device *dev)
 {
 	/* will be changed into kobject_name(&dev->kobj) in the near future */
 	return dev->bus_id;
@@ -495,7 +495,7 @@ extern void device_shutdown(void);
 extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
-extern const char *dev_driver_string(struct device *dev);
+extern const char *dev_driver_string(const struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
--- linux-2.6.26-rc9.orig/drivers/base/core.c	2008-06-13 16:08:57.000000000 +0200
+++ linux-2.6.26-rc9/drivers/base/core.c	2008-07-11 10:47:37.000000000 +0200
@@ -49,7 +49,7 @@ static inline int device_is_not_partitio
  * it is attached to.  If it is not attached to a bus either, an empty
  * string will be returned.
  */
-const char *dev_driver_string(struct device *dev)
+const char *dev_driver_string(const struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
 			(dev->bus ? dev->bus->name :


-- 
Jean Delvare

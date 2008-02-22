Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbYBVRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbYBVRrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbYBVRqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:46:08 -0500
Received: from serv.smile.org.ua ([193.178.237.153]:2010 "EHLO
	serv.smile.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbYBVRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:46:05 -0500
Date: Fri, 22 Feb 2008 19:46:00 +0200
From: Andy Shevchenko <andy@smile.org.ua>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add SDIO 'type' parameter to sysfs
Message-ID: <20080222174600.GT4909@serv.smile.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
X-Operating-System: Linux 2.4.21-50.EL.aspsmp i586
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Add 'type' attribute of the SDIO device to represent Standard Function
interface code in the human readable form.
---
 drivers/mmc/core/sdio_bus.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 233d0f9..db8990d 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -24,6 +24,35 @@
 #define to_sdio_driver(d)      container_of(d, struct sdio_driver, drv)
 
 /* show configuration fields */
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct sdio_func *func;
+
+	func = dev_to_sdio_func (dev);
+
+	switch (func->class) {
+		case 0x0:
+			return sprintf (buf, "Non-standard");
+		case 0x1:
+			return sprintf (buf, "UART");
+		case 0x2:
+			return sprintf (buf, "Bluetooth (Type-A)");
+		case 0x3:
+			return sprintf (buf, "Bluetooth (Type-B)");
+		case 0x4:
+			return sprintf (buf, "GPS");
+		case 0x5:
+			return sprintf (buf, "Camera");
+		case 0x6:
+			return sprintf (buf, "PHS");
+		case 0x7:
+			return sprintf (buf, "WLAN");
+	}
+	/* 0x08-0x0E Reserved for future */
+	return sprintf (buf, "Reserved");
+}
+
 #define sdio_config_attr(field, format_string)				\
 static ssize_t								\
 field##_show(struct device *dev, struct device_attribute *attr, char *buf)				\
@@ -47,6 +76,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 
 static struct device_attribute sdio_dev_attrs[] = {
+	__ATTR_RO(type),
 	__ATTR_RO(class),
 	__ATTR_RO(vendor),
 	__ATTR_RO(device),
-- 
1.5.2.5

-- 
With best regards,
Andy Shevchenko.      mailto: andy@smile.org.ua



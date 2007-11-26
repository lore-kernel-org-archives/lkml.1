Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbXKZUc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbXKZUc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXKZUcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:32:51 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1558 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXKZUcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:32:51 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] kernel/module.c: make_driver_name() can use kasrpintf()
Date: Mon, 26 Nov 2007 21:32:45 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262132.46615.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	make_driver_name() wants kasprintf(). Compile tested, also boots fine.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 kernel/module.c | 68034 -> 67872 (-162 bytes)
 kernel/module.o | 128520 -> 128328 (-192 bytes)

 kernel/module.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- linux-2.6.24-rc3-mm1-a/kernel/module.c	2007-11-21 17:38:25.000000000 +0100
+++ linux-2.6.24-rc3-mm1-b/kernel/module.c	2007-11-26 20:14:53.000000000 +0100
@@ -2497,15 +2497,7 @@ void print_modules(void)
 #ifdef CONFIG_SYSFS
 static char *make_driver_name(struct device_driver *drv)
 {
-	char *driver_name;
-
-	driver_name = kmalloc(strlen(drv->name) + strlen(drv->bus->name) + 2,
-			      GFP_KERNEL);
-	if (!driver_name)
-		return NULL;
-
-	sprintf(driver_name, "%s:%s", drv->bus->name, drv->name);
-	return driver_name;
+	return kasprintf(GFP_KERNEL, "%s:%s", drv->bus->name, drv->name);
 }

 static void module_create_drivers_dir(struct module_kobject *mk)

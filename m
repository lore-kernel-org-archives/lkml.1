Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZAFWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZAFWWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZAFWNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:46 -0500
Received: from kroah.org ([198.145.64.141]:51247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755548AbZAFWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/60] video: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:45 -0800
Message-Id: <1231279939-32728-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 drivers/video/output.c              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index fab0bc8..0664fc0 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -217,7 +217,7 @@ struct backlight_device *backlight_device_register(const char *name,
 	new_bd->dev.class = backlight_class;
 	new_bd->dev.parent = parent;
 	new_bd->dev.release = bl_device_release;
-	strlcpy(new_bd->dev.bus_id, name, BUS_ID_SIZE);
+	dev_set_name(&new_bd->dev, name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
 	rc = device_register(&new_bd->dev);
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 680e57b..b644947 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -208,7 +208,7 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 	new_ld->dev.class = lcd_class;
 	new_ld->dev.parent = parent;
 	new_ld->dev.release = lcd_device_release;
-	strlcpy(new_ld->dev.bus_id, name, BUS_ID_SIZE);
+	dev_set_name(&new_ld->dev, name);
 	dev_set_drvdata(&new_ld->dev, devdata);
 
 	rc = device_register(&new_ld->dev);
diff --git a/drivers/video/output.c b/drivers/video/output.c
index f2df551..5e6439a 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -96,7 +96,7 @@ struct output_device *video_output_register(const char *name,
 	new_dev->props = op;
 	new_dev->dev.class = &video_output_class;
 	new_dev->dev.parent = dev;
-	strlcpy(new_dev->dev.bus_id,name, BUS_ID_SIZE);
+	dev_set_name(&new_dev->dev, name);
 	dev_set_drvdata(&new_dev->dev, devdata);
 	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
-- 
1.6.0.4


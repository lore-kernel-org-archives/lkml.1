Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYJPRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYJPRU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYJPROV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:21 -0400
Received: from kroah.org ([198.145.64.141]:46951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755440AbYJPROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/46] device create: video: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:14 -0700
Message-Id: <1224177047-11859-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/console/fbcon.c         |    4 ++--
 drivers/video/display/display-sysfs.c |    9 +++------
 drivers/video/fbmem.c                 |    5 ++---
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index da91bb1..0e0ea42 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3573,8 +3573,8 @@ static int __init fb_console_init(void)
 
 	acquire_console_sem();
 	fb_register_client(&fbcon_event_notifier);
-	fbcon_device = device_create_drvdata(fb_class, NULL, MKDEV(0, 0),
-					     NULL, "fbcon");
+	fbcon_device = device_create(fb_class, NULL, MKDEV(0, 0), NULL,
+				     "fbcon");
 
 	if (IS_ERR(fbcon_device)) {
 		printk(KERN_WARNING "Unable to create device "
diff --git a/drivers/video/display/display-sysfs.c b/drivers/video/display/display-sysfs.c
index 6ef800b..4830b1b 100644
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -153,12 +153,9 @@ struct display_device *display_device_register(struct display_driver *driver,
 		mutex_unlock(&allocated_dsp_lock);
 
 		if (!ret) {
-			new_dev->dev = device_create_drvdata(display_class,
-							     parent,
-							     MKDEV(0,0),
-							     new_dev,
-							     "display%d",
-							     new_dev->idx);
+			new_dev->dev = device_create(display_class, parent,
+						     MKDEV(0, 0), new_dev,
+						     "display%d", new_dev->idx);
 			if (!IS_ERR(new_dev->dev)) {
 				new_dev->parent = parent;
 				new_dev->driver = driver;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0737570..61b36ca 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1443,9 +1443,8 @@ register_framebuffer(struct fb_info *fb_info)
 			break;
 	fb_info->node = i;
 
-	fb_info->dev = device_create_drvdata(fb_class, fb_info->device,
-					     MKDEV(FB_MAJOR, i), NULL,
-					     "fb%d", i);
+	fb_info->dev = device_create(fb_class, fb_info->device,
+				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
 	if (IS_ERR(fb_info->dev)) {
 		/* Not fatal */
 		printk(KERN_WARNING "Unable to create device for framebuffer %d; errno = %ld\n", i, PTR_ERR(fb_info->dev));
-- 
1.6.0.2


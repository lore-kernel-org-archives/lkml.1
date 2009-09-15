Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZIOQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZIOQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZIOQUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:20:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56240 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZIOQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:20:08 -0400
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] backlight: Remove old device_register and device_unregister API
Date: Tue, 15 Sep 2009 17:19:43 +0100
Message-Id: <1253031583-11286-3-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1253031583-11286-2-git-send-email-mjg@redhat.com>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com>
 <1253031583-11286-2-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 212.183.134.211
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all the users are transitioned, the old functions can be removed.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/backlight/backlight.c |   48 -----------------------------------
 include/linux/backlight.h           |    3 --
 2 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 9048a28..39ffa86 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -289,38 +289,6 @@ int backlight_register(struct backlight_device *bd)
 EXPORT_SYMBOL(backlight_register);
 
 /**
- * backlight_device_register - create and register a new object of
- *   backlight_device class.
- * @name: the name of the new object(must be the same as the name of the
- *   respective framebuffer device).
- * @parent: a pointer to the parent device
- * @devdata: an optional pointer to be stored for private driver use. The
- *   methods may retrieve it by using bl_get_data(bd).
- * @ops: the backlight operations structure.
- *
- * Creates and registers new backlight device. Returns either an
- * ERR_PTR() or a pointer to the newly allocated device.
- */
-struct backlight_device *backlight_device_register(const char *name,
-		struct device *parent, void *devdata, struct backlight_ops *ops)
-{
-	struct backlight_device *new_bd;
-	int rc;
-
-	new_bd = backlight_alloc(name, parent, devdata, ops);
-
-	if (IS_ERR(new_bd))
-		return new_bd;
-
-	rc = backlight_register(new_bd);
-	if (rc)
-		return ERR_PTR(rc);
-
-	return new_bd;
-}
-EXPORT_SYMBOL(backlight_device_register);
-
-/**
  * backlight_destroy - frees a backlight device object
  * @bd: the backlight device object to be freed.
  *
@@ -359,22 +327,6 @@ void backlight_unregister(struct backlight_device *bd)
 }
 EXPORT_SYMBOL(backlight_unregister);
 
-/**
- * backlight_device_unregister - unregisters a backlight device object.
- * @bd: the backlight device object to be unregistered and freed.
- *
- * Unregisters a previously registered via backlight_device_register object.
- */
-void backlight_device_unregister(struct backlight_device *bd)
-{
-	if (!bd)
-		return;
-
-	backlight_unregister(bd);
-	backlight_destroy(bd);
-}
-EXPORT_SYMBOL(backlight_device_unregister);
-
 static void __exit backlight_class_exit(void)
 {
 	class_destroy(backlight_class);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 9e17ff0..4c21b0b 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -98,13 +98,10 @@ static inline void backlight_update_status(struct backlight_device *bd)
 }
 
 
-extern struct backlight_device *backlight_device_register(const char *name,
-	struct device *dev, void *devdata, struct backlight_ops *ops);
 extern struct backlight_device *backlight_alloc(const char *name,
 	struct device *dev, void *devdata, struct backlight_ops *ops);
 extern int backlight_register(struct backlight_device *bd);
 
-extern void backlight_device_unregister(struct backlight_device *bd);
 extern void backlight_unregister(struct backlight_device *bd);
 extern void backlight_destroy(struct backlight_device *bd);
 
-- 
1.6.2.5


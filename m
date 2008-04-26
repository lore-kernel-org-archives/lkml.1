Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYDZGOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYDZGOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYDZGOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:14:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:34595 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDZGON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C4S0ODim7gp1oK++4FcGzH8gFijhSwgSoJitMBDjNWttnlNsR7UK1v/fWsfrLDQlzJarQQehYF3aLHe2Qe18HVfsGki1HLi8WDLRdoiloV0amCHUXOLwyeZwewHU4HOYAb5RwpgJDRZa4HTXDJSnmtgJ14GB6S3KBwQ5t7Imy9s=
Subject: [BUILDFIX PATCH] au0828: debug is a poor global identifier
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 23:14:15 -0700
Message-Id: <1209190455.14173.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid link-time warnings with debug declared in x86/kernel/entry_32.S

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Otherwise you'll see link time warnings about multiple defintions of
debug. (size 4 here, size 76 in entry_32.S)

 drivers/media/video/au0828/au0828-core.c |   14 +++++++-------
 drivers/media/video/au0828/au0828.h      |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index e65d564..9b7a4d7 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -32,9 +32,9 @@
  * 4 = I2C related
  * 8 = Bridge related
  */
-unsigned int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "enable debug messages");
+unsigned int au0828_debug;
+module_param(au0828_debug, int, 0644);
+MODULE_PARM_DESC(au0828_debug, "enable debug messages");
 
 unsigned int usb_debug;
 module_param(usb_debug, int, 0644);
@@ -229,23 +229,23 @@ static int __init au0828_init(void)
 {
 	int ret;
 
-	if (debug)
+	if (au0828_debug)
 		printk(KERN_INFO "%s() Debugging is enabled\n", __func__);
 
 	if (usb_debug) {
 		printk(KERN_INFO "%s() USB Debugging is enabled\n", __func__);
-		debug |= 2;
+		au0828_debug |= 2;
 	}
 
 	if (i2c_debug) {
 		printk(KERN_INFO "%s() I2C Debugging is enabled\n", __func__);
-		debug |= 4;
+		au0828_debug |= 4;
 	}
 
 	if (bridge_debug) {
 		printk(KERN_INFO "%s() Bridge Debugging is enabled\n",
 		       __func__);
-		debug |= 8;
+		au0828_debug |= 8;
 	}
 
 	printk(KERN_INFO "au0828 driver loaded\n");
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 0200b9f..8344c45 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -96,7 +96,7 @@ struct au0828_buff {
 /* au0828-core.c */
 extern u32 au0828_read(struct au0828_dev *dev, u16 reg);
 extern u32 au0828_write(struct au0828_dev *dev, u16 reg, u32 val);
-extern unsigned int debug;
+extern unsigned int au0828_debug;
 extern unsigned int usb_debug;
 extern unsigned int bridge_debug;
 
@@ -123,6 +123,6 @@ extern int au0828_dvb_register(struct au0828_dev *dev);
 extern void au0828_dvb_unregister(struct au0828_dev *dev);
 
 #define dprintk(level, fmt, arg...)\
-	do { if (debug & level)\
+	do { if (au0828_debug & level)\
 		printk(KERN_DEBUG DRIVER_NAME "/0: " fmt, ## arg);\
 	} while (0)
-- 
1.5.5.1.270.g89765




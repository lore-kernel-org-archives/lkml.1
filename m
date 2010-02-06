Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab0BFCJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 21:09:51 -0500
Received: from mail.perches.com ([173.55.12.10]:1872 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab0BFCJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 21:09:50 -0500
Subject: [PATCH] include/linux/usb: Extend and neaten dbg macros
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 18:09:49 -0800
Message-ID: <1265422189.10226.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add format/argument validation for #ifndef DEBUG dbg macro
Neaten dbg macro definitions

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/usb.h        |   14 +++++++++-----
 include/linux/usb/serial.h |   13 +++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index d7ace1b..c93a720 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1582,14 +1582,18 @@ extern void usb_register_notify(struct notifier_block *nb);
 extern void usb_unregister_notify(struct notifier_block *nb);
 
 #ifdef DEBUG
-#define dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
-	__FILE__ , ## arg)
+#define dbg(format, arg...)						\
+	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (0)								\
+		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg); \
+} while (0)
 #endif
 
-#define err(format, arg...) printk(KERN_ERR KBUILD_MODNAME ": " \
-	format "\n" , ## arg)
+#define err(format, arg...)					\
+	printk(KERN_ERR KBUILD_MODNAME ": " format "\n", ##arg)
 
 /* debugfs stuff */
 extern struct dentry *usb_debug_root;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 1819396..0a458b8 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -351,14 +351,11 @@ static inline void usb_serial_debug_data(int debug,
 
 /* Use our own dbg macro */
 #undef dbg
-#define dbg(format, arg...) \
-	do { \
-		if (debug) \
-			printk(KERN_DEBUG "%s: " format "\n" , __FILE__ , \
-				## arg); \
-	} while (0)
-
-
+#define dbg(format, arg...)						\
+do {									\
+	if (debug)							\
+		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg);	\
+} while (0)
 
 #endif /* __LINUX_USB_SERIAL_H */
 
-- 
1.7.0.rc1.33.g07cf0f




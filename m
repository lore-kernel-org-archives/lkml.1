Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXGPAhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXGPAhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbXGPAhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:37:09 -0400
Received: from smtp.xtech.com.ar ([200.68.115.49]:4752 "EHLO smtp.xtech.com.ar"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbXGPAhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:37:08 -0400
From: Diego Woitasen <diego@woitasen.com.ar>
To: linux-kernel@vger.kernel.org
Cc: Diego Woitasen <diego@woitasen.com.ar>
Subject: [PATCH] Add KERN_* prefix to printks in bug.h
Date: Sun, 15 Jul 2007 21:36:59 -0300
Message-Id: <11845462192199-git-send-email-diego@woitasen.com.ar>
X-Mailer: git-send-email 1.5.2.3
X-Bogosity: No, tests=bogofilter, spamicity=0.000000, version=0.94.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/asm-generic/bug.h |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7f30cce..6e49266 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -8,22 +8,23 @@
 #ifdef CONFIG_GENERIC_BUG
 #ifndef __ASSEMBLY__
 struct bug_entry {
-	unsigned long	bug_addr;
+	unsigned long bug_addr;
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	const char	*file;
-	unsigned short	line;
+	const char *file;
+	unsigned short line;
 #endif
-	unsigned short	flags;
+	unsigned short flags;
 };
-#endif		/* __ASSEMBLY__ */
+#endif				/* __ASSEMBLY__ */
 
 #define BUGFLAG_WARNING	(1<<0)
-#endif	/* CONFIG_GENERIC_BUG */
+#endif				/* CONFIG_GENERIC_BUG */
 
 #ifndef HAVE_ARCH_BUG
-#define BUG() do { \
-	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
-	panic("BUG!"); \
+#define BUG() do { 							\
+	printk(KERN_EMERG "BUG: failure at %s:%d/%s()!\n",		\
+		__FILE__, __LINE__, __FUNCTION__); 			\
+	panic("BUG!"); 							\
 } while (0)
 #endif
 
@@ -35,15 +36,15 @@ struct bug_entry {
 #define WARN_ON(condition) ({						\
 	typeof(condition) __ret_warn_on = (condition);			\
 	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
+		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",		\
+			__FILE__, __LINE__, __FUNCTION__);		\
 		dump_stack();						\
 	}								\
 	unlikely(__ret_warn_on);					\
 })
 #endif
 
-#else /* !CONFIG_BUG */
+#else				/* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
 #endif
-- 
1.5.2.3


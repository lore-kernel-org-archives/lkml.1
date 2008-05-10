Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYEJMhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYEJMhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 08:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYEJMgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 08:36:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56247 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbYEJMgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 08:36:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Date: Sat, 10 May 2008 08:36:46 -0400
User-Agent: KMail/1.9.7
Cc: chris@zankel.net, rth@twiddle.net, ysato@users.sourceforge.jp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805100836.48046.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this because alpha was broken due to the recent bdc807871d58285737. 
Most arches do something like this in their asm/param.h:
#ifdef __KERNEL__
# define HZ CONFIG_HZ
#else
# define HZ 100
#endif
A few arches though (namely alpha/h8300/um/v850/xtensa) either do no set HZ at
all for !__KERNEL__, or they set it wrongly.  This should bring all arches in
line by setting up HZ for userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-alpha/param.h b/include/asm-alpha/param.h
index 0982f1d..d300950 100644
--- a/include/asm-alpha/param.h
+++ b/include/asm-alpha/param.h
@@ -5,8 +5,12 @@
    hardware ignores reprogramming.  We also need userland buy-in to the 
    change in HZ, since this is visible in the wait4 resources etc.  */
 
+#ifdef __KERNEL__
 #define HZ		CONFIG_HZ
 #define USER_HZ		HZ
+#else
+#define HZ		100
+#endif
 
 #define EXEC_PAGESIZE	8192
 
diff --git a/include/asm-h8300/param.h b/include/asm-h8300/param.h
index 04f64f1..1c72fb8 100644
--- a/include/asm-h8300/param.h
+++ b/include/asm-h8300/param.h
@@ -1,14 +1,12 @@
 #ifndef _H8300_PARAM_H
 #define _H8300_PARAM_H
 
-
-#ifndef HZ
-#define HZ CONFIG_HZ
-#endif
-
 #ifdef __KERNEL__
+#define HZ		CONFIG_HZ
 #define	USER_HZ		HZ
 #define	CLOCKS_PER_SEC	(USER_HZ)
+#else
+#define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096
diff --git a/include/asm-um/param.h b/include/asm-um/param.h
index 4cd4a22..e44f4e6 100644
--- a/include/asm-um/param.h
+++ b/include/asm-um/param.h
@@ -13,6 +13,8 @@
 #define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
+#else
+#define HZ 100
 #endif
 
 #endif
diff --git a/include/asm-v850/param.h b/include/asm-v850/param.h
index 2818326..4391f5f 100644
--- a/include/asm-v850/param.h
+++ b/include/asm-v850/param.h
@@ -26,6 +26,8 @@
 # define HZ		CONFIG_HZ
 # define USER_HZ	100
 # define CLOCKS_PER_SEC	USER_HZ
+#else
+# define HZ		100
 #endif
 
 #endif /* __V850_PARAM_H__ */
diff --git a/include/asm-xtensa/param.h b/include/asm-xtensa/param.h
index 82ad34d..ba03d5a 100644
--- a/include/asm-xtensa/param.h
+++ b/include/asm-xtensa/param.h
@@ -15,6 +15,8 @@
 # define HZ		CONFIG_HZ	/* internal timer frequency */
 # define USER_HZ	100		/* for user interfaces in "ticks" */
 # define CLOCKS_PER_SEC (USER_HZ)	/* frequnzy at which times() counts */
+#else
+# define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096

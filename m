Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbYCWI2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbYCWI2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759491AbYCWIJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:35 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2281 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759470AbYCWIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:32 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 098/148] include/asm-x86/posix_types_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:13 -0700
Message-Id: <1206259443-13210-99-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/posix_types_32.h |   47 +++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/include/asm-x86/posix_types_32.h b/include/asm-x86/posix_types_32.h
index 015e539..b031efd 100644
--- a/include/asm-x86/posix_types_32.h
+++ b/include/asm-x86/posix_types_32.h
@@ -45,32 +45,39 @@ typedef struct {
 #if defined(__KERNEL__)
 
 #undef	__FD_SET
-#define __FD_SET(fd,fdsetp) \
-		__asm__ __volatile__("btsl %1,%0": \
-			"+m" (*(__kernel_fd_set *) (fdsetp)):"r" ((int) (fd)))
+#define __FD_SET(fd,fdsetp)					\
+	asm volatile("btsl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int)(fd)))
 
 #undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp) \
-		__asm__ __volatile__("btrl %1,%0": \
-			"+m" (*(__kernel_fd_set *) (fdsetp)):"r" ((int) (fd)))
+#define __FD_CLR(fd,fdsetp)					\
+	asm volatile("btrl %1,%0":				\
+		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
+		     : "r" ((int) (fd)))
 
 #undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp) (__extension__ ({ \
-		unsigned char __result; \
-		__asm__ __volatile__("btl %1,%2 ; setb %0" \
-			:"=q" (__result) :"r" ((int) (fd)), \
-			"m" (*(__kernel_fd_set *) (fdsetp))); \
-		__result; }))
+#define __FD_ISSET(fd,fdsetp)					\
+	(__extension__						\
+	 ({							\
+	 unsigned char __result;				\
+	 asm volatile("btl %1,%2 ; setb %0"			\
+		      : "=q" (__result)				\
+		      : "r" ((int)(fd)),			\
+			"m" (*(__kernel_fd_set *)(fdsetp)));	\
+	 __result;						\
+}))
 
 #undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) \
-do { \
-	int __d0, __d1; \
-	__asm__ __volatile__("cld ; rep ; stosl" \
-			:"=m" (*(__kernel_fd_set *) (fdsetp)), \
-			  "=&c" (__d0), "=&D" (__d1) \
-			:"a" (0), "1" (__FDSET_LONGS), \
-			"2" ((__kernel_fd_set *) (fdsetp)) : "memory"); \
+#define __FD_ZERO(fdsetp)					\
+do {								\
+	int __d0, __d1;						\
+	asm volatile("cld ; rep ; stosl"			\
+		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
+		       "=&c" (__d0), "=&D" (__d1)		\
+		     : "a" (0), "1" (__FDSET_LONGS),		\
+		       "2" ((__kernel_fd_set *)(fdsetp))	\
+		     : "memory");				\
 } while (0)
 
 #endif /* defined(__KERNEL__) */
-- 
1.5.4.rc2


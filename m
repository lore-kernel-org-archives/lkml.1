Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZABHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZABHxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZABHxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:53:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38630 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZABHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:53:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH] asm-sh/posix_types_{32,64}.h: drop __GLIBC__/__USE_ALL usage
Date: Fri,  2 Jan 2009 02:52:57 -0500
Message-Id: <1230882777-9950-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring sh in line with all the other ports.  Not sure how sh missed this
change as all the other arches were being updated ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org
---
 arch/sh/include/asm/posix_types_32.h |    8 ++------
 arch/sh/include/asm/posix_types_64.h |    8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/sh/include/asm/posix_types_32.h b/arch/sh/include/asm/posix_types_32.h
index 0a3d2f5..2172732 100644
--- a/arch/sh/include/asm/posix_types_32.h
+++ b/arch/sh/include/asm/posix_types_32.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -117,6 +113,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __ASM_SH_POSIX_TYPES_H */
diff --git a/arch/sh/include/asm/posix_types_64.h b/arch/sh/include/asm/posix_types_64.h
index 0620317..f83e9bd 100644
--- a/arch/sh/include/asm/posix_types_64.h
+++ b/arch/sh/include/asm/posix_types_64.h
@@ -48,14 +48,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -126,6 +122,6 @@ static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __ASM_SH64_POSIX_TYPES_H */
-- 
1.6.0.6


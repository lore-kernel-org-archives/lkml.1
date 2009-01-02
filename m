Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZABHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZABHxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZABHxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:53:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38653 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbZABHxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:53:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com
Subject: [PATCH] asm-mn10300/posix_types.h: drop __GLIBC__/__USE_ALL usage
Date: Fri,  2 Jan 2009 02:53:06 -0500
Message-Id: <1230882786-10004-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring mn10300 in line with all the other ports.  I think mn10300 missed
this because it was merged while every one else was getting fixed.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: David Howells <dhowells@redhat.com>
CC: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
CC: linux-am33-list@redhat.com
---
 include/asm-mn10300/posix_types.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/asm-mn10300/posix_types.h b/include/asm-mn10300/posix_types.h
index 077567c..df2b6d9 100644
--- a/include/asm-mn10300/posix_types.h
+++ b/include/asm-mn10300/posix_types.h
@@ -49,14 +49,10 @@ typedef long long	__kernel_loff_t;
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
 static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -127,6 +123,6 @@ static inline void __FD_ZERO(__kernel_fd_set *__p)
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* _ASM_POSIX_TYPES_H */
-- 
1.6.0.6


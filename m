Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbZBZADN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbZBZADN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbZBZACI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:02:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760939AbZBZACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:02:07 -0500
Message-Id: <20090225235516.001867692@arndb.de>
References: <20090225235138.062045835@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:51:45 +0100
From: arnd@arndb.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [patch 7/7] remove __KERNEL_STRICT_NAMES
Content-Disposition: inline; filename=0007-remove-__KERNEL_STRICT_NAMES.patch
X-Provags-ID: V01U2FsdGVkX1/lq9CXPk1Vg329j1W1HRvOjAVYRE3c+v0t1sq
 9vvzTWvupoJ+m8RvSKxmbXW7tXuBOzCFwpM1/btTe1yPN+D2D+
 FJl1aIGJsxMckMhc/FJFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the last used of non-strict names gone from the
exported header files, we can remove the old libc5
compatibility cruft from our headers and only export
strict types.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/statfs.h |    5 +++--
 include/linux/types.h        |   13 ++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 6129d68..3b4fb3e 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -1,8 +1,9 @@
 #ifndef _GENERIC_STATFS_H
 #define _GENERIC_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
+#include <linux/types.h>
+
+#ifdef __KERNEL__
 typedef __kernel_fsid_t	fsid_t;
 #endif
 
diff --git a/include/linux/types.h b/include/linux/types.h
index 712ca53..6508ba1 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -11,7 +11,7 @@
 #include <linux/posix_types.h>
 #include <asm/types.h>
 
-#ifndef __KERNEL_STRICT_NAMES
+#ifdef __KERNEL__
 
 typedef __u32 __kernel_dev_t;
 
@@ -29,7 +29,6 @@ typedef __kernel_timer_t	timer_t;
 typedef __kernel_clockid_t	clockid_t;
 typedef __kernel_mqd_t		mqd_t;
 
-#ifdef __KERNEL__
 typedef _Bool			bool;
 
 typedef __kernel_uid32_t	uid_t;
@@ -45,14 +44,6 @@ typedef __kernel_old_uid_t	old_uid_t;
 typedef __kernel_old_gid_t	old_gid_t;
 #endif /* CONFIG_UID16 */
 
-/* libc5 includes this file to define uid_t, thus uid_t can never change
- * when it is included by non-kernel code
- */
-#else
-typedef __kernel_uid_t		uid_t;
-typedef __kernel_gid_t		gid_t;
-#endif /* __KERNEL__ */
-
 #if defined(__GNUC__)
 typedef __kernel_loff_t		loff_t;
 #endif
@@ -154,7 +145,7 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
-#endif /* __KERNEL_STRICT_NAMES */
+#endif /* __KERNEL__ */
 
 /*
  * Below are truly Linux-specific types that should never collide with
-- 
1.5.6.3

-- 


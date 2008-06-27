Return-Path: <linux-kernel-owner+w=401wt.eu-S1765385AbYF0VxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765385AbYF0VxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764525AbYF0Vi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764507AbYF0Viy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:54 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 39/39] define architectural characteristics in uaccess.h
Date: Fri, 27 Jun 2008 18:34:46 -0300
Message-Id: <1214602486-17080-40-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-39-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
 <1214602486-17080-24-git-send-email-gcosta@redhat.com>
 <1214602486-17080-25-git-send-email-gcosta@redhat.com>
 <1214602486-17080-26-git-send-email-gcosta@redhat.com>
 <1214602486-17080-27-git-send-email-gcosta@redhat.com>
 <1214602486-17080-28-git-send-email-gcosta@redhat.com>
 <1214602486-17080-29-git-send-email-gcosta@redhat.com>
 <1214602486-17080-30-git-send-email-gcosta@redhat.com>
 <1214602486-17080-31-git-send-email-gcosta@redhat.com>
 <1214602486-17080-32-git-send-email-gcosta@redhat.com>
 <1214602486-17080-33-git-send-email-gcosta@redhat.com>
 <1214602486-17080-34-git-send-email-gcosta@redhat.com>
 <1214602486-17080-35-git-send-email-gcosta@redhat.com>
 <1214602486-17080-36-git-send-email-gcosta@redhat.com>
 <1214602486-17080-37-git-send-email-gcosta@redhat.com>
 <1214602486-17080-38-git-send-email-gcosta@redhat.com>
 <1214602486-17080-39-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove them from the arch-specific file.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |    3 +++
 include/asm-x86/uaccess_32.h |    2 --
 include/asm-x86/uaccess_64.h |    3 ---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index ddc32fe..a1e8157 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -442,9 +442,12 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
+#define ARCH_HAS_NOCACHE_UACCESS 1
+
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
+# define ARCH_HAS_SEARCH_EXTABLE
 # include "uaccess_64.h"
 #endif
 
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 3467749..6fdef39 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -156,8 +156,6 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 	return __copy_from_user_ll(to, from, n);
 }
 
-#define ARCH_HAS_NOCACHE_UACCESS
-
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
 				const void __user *from, unsigned long n)
 {
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index b5bacd6..4e3ec00 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -9,8 +9,6 @@
 #include <linux/prefetch.h>
 #include <asm/page.h>
 
-#define ARCH_HAS_SEARCH_EXTABLE
-
 /*
  * Copy To/From Userspace
  */
@@ -180,7 +178,6 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 	return copy_user_generic((__force void *)dst, src, size);
 }
 
-#define ARCH_HAS_NOCACHE_UACCESS 1
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
-- 
1.5.5.1


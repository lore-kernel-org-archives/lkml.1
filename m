Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbYF0Vr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbYF0Vr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764321AbYF0ViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763607AbYF0ViK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:10 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 27/39] move __addr_ok to uaccess.h
Date: Fri, 27 Jun 2008 18:34:34 -0300
Message-Id: <1214602486-17080-28-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-27-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take it out of uaccess_32.h. Since it seems that no users
of the x86_64 exists, we simply pick the i386 version.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |    4 ++++
 include/asm-x86/uaccess_32.h |    4 ----
 include/asm-x86/uaccess_64.h |    3 ---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index a06a810..3721513 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -33,6 +33,10 @@
 
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
+#define __addr_ok(addr)					\
+	((unsigned long __force)(addr) <		\
+	 (current_thread_info()->addr_limit.seg))
+
 /*
  * Test whether a block of memory is a valid user space address.
  * Returns 0 if the range is valid, nonzero otherwise.
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 3cc3236..87b1aed 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -20,10 +20,6 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
-#define __addr_ok(addr)					\
-	((unsigned long __force)(addr) <		\
-	 (current_thread_info()->addr_limit.seg))
-
 extern void __put_user_bad(void);
 
 /*
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 4a44b90..8130876 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -9,9 +9,6 @@
 #include <linux/prefetch.h>
 #include <asm/page.h>
 
-#define __addr_ok(addr) (!((unsigned long)(addr) &			\
-			   (current_thread_info()->addr_limit.seg)))
-
 #define ARCH_HAS_SEARCH_EXTABLE
 
 extern void __put_user_1(void);
-- 
1.5.5.1


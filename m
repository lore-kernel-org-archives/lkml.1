Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbYF0Vwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbYF0Vwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764462AbYF0Vis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764431AbYF0Vir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:47 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 38/39] put movsl_mask into uaccess.h
Date: Fri, 27 Jun 2008 18:34:45 -0300
Message-Id: <1214602486-17080-39-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-38-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 does not need it, but it won't have X86_INTEL_USERCOPY
defined either.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |    9 +++++++++
 include/asm-x86/uaccess_32.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 4ebb992..ddc32fe 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -433,6 +433,15 @@ struct __large_struct { unsigned long buf[100]; };
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
+/*
+ * movsl can be slow when source and dest are not both 8-byte aligned
+ */
+#ifdef CONFIG_X86_INTEL_USERCOPY
+extern struct movsl_mask {
+	int mask;
+} ____cacheline_aligned_in_smp movsl_mask;
+#endif
+
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index d3b5bf8..3467749 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -11,15 +11,6 @@
 #include <asm/asm.h>
 #include <asm/page.h>
 
-/*
- * movsl can be slow when source and dest are not both 8-byte aligned
- */
-#ifdef CONFIG_X86_INTEL_USERCOPY
-extern struct movsl_mask {
-	int mask;
-} ____cacheline_aligned_in_smp movsl_mask;
-#endif
-
 unsigned long __must_check __copy_to_user_ll
 		(void __user *to, const void *from, unsigned long n);
 unsigned long __must_check __copy_from_user_ll
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbYKRDjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbYKRDjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYKRDjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:34235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYKRDjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mE4ttZGr8IppVLkAUZgJSdgk5d6LjJ1zhfsqnF9wW8W7jqj9/NBZWnxgVhm1OGVJuk
         48KuqAy6eYBoswLuPniazP7mMwLTCgNRwhaFKMkBjQCEFvWZ4zx13T9skvfXBA5TLqlA
         8VXt+8CJEN3oMsI8WJ6WAVcQbgZGXsUgHNgZY=
Subject: [PATCH-mm 2/7] unaligned: convert arches where unaligned access is
 OK
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:10 -0800
Message-Id: <1226979550.6150.267.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, just use the asm-generic header.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/cris/include/asm/unaligned.h      |    7 ++-----
 arch/m68knommu/include/asm/unaligned.h |   22 +++++-----------------
 arch/powerpc/include/asm/unaligned.h   |    7 ++-----
 arch/s390/include/asm/unaligned.h      |    7 ++-----
 arch/x86/include/asm/unaligned.h       |    8 ++------
 include/asm-m68k/unaligned.h           |    7 ++-----
 include/asm-mn10300/unaligned.h        |   10 +++++-----
 7 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/arch/cris/include/asm/unaligned.h b/arch/cris/include/asm/unaligned.h
index 7b3f3fe..0634570 100644
--- a/arch/cris/include/asm/unaligned.h
+++ b/arch/cris/include/asm/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * CRIS can do unaligned accesses itself. 
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_CRIS_UNALIGNED_H */
diff --git a/arch/m68knommu/include/asm/unaligned.h b/arch/m68knommu/include/asm/unaligned.h
index eb1ea4c..651419e 100644
--- a/arch/m68knommu/include/asm/unaligned.h
+++ b/arch/m68knommu/include/asm/unaligned.h
@@ -1,25 +1,13 @@
 #ifndef _ASM_M68KNOMMU_UNALIGNED_H
 #define _ASM_M68KNOMMU_UNALIGNED_H
 
-
-#ifdef CONFIG_COLDFIRE
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
-#else
 /*
- * The m68k can do unaligned accesses itself. 
+ * The m68k can do unaligned accesses itself.  COLDFIRE can not.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
+#ifndef CONFIG_COLDFIRE
+# define _UNALIGNED_ACCESS_OK
 #endif
 
+#include <asm-generic/unaligned.h>
+
 #endif /* _ASM_M68KNOMMU_UNALIGNED_H */
diff --git a/arch/powerpc/include/asm/unaligned.h b/arch/powerpc/include/asm/unaligned.h
index 5f1b1e3..5fb95fc 100644
--- a/arch/powerpc/include/asm/unaligned.h
+++ b/arch/powerpc/include/asm/unaligned.h
@@ -6,11 +6,8 @@
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff --git a/arch/s390/include/asm/unaligned.h b/arch/s390/include/asm/unaligned.h
index da9627a..69a4088 100644
--- a/arch/s390/include/asm/unaligned.h
+++ b/arch/s390/include/asm/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * The S390 can do unaligned accesses itself. 
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_S390_UNALIGNED_H */
diff --git a/arch/x86/include/asm/unaligned.h b/arch/x86/include/asm/unaligned.h
index a7bd416..1ba0b8a 100644
--- a/arch/x86/include/asm/unaligned.h
+++ b/arch/x86/include/asm/unaligned.h
@@ -4,11 +4,7 @@
 /*
  * The x86 can do unaligned accesses itself.
  */
-
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_X86_UNALIGNED_H */
diff --git a/include/asm-m68k/unaligned.h b/include/asm-m68k/unaligned.h
index 77698f2..2d92d6a 100644
--- a/include/asm-m68k/unaligned.h
+++ b/include/asm-m68k/unaligned.h
@@ -4,10 +4,7 @@
 /*
  * The m68k can do unaligned accesses itself.
  */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_M68K_UNALIGNED_H */
diff --git a/include/asm-mn10300/unaligned.h b/include/asm-mn10300/unaligned.h
index 0df6713..0ab409f 100644
--- a/include/asm-mn10300/unaligned.h
+++ b/include/asm-mn10300/unaligned.h
@@ -11,10 +11,10 @@
 #ifndef _ASM_MN10300_UNALIGNED_H
 #define _ASM_MN10300_UNALIGNED_H
 
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+/*
+ * The MN10300 can do unaligned accesses itself.
+ */
+#define _UNALIGNED_ACCESS_OK
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_MN10300_UNALIGNED_H */
-- 
1.6.0.4.994.g16bd3e



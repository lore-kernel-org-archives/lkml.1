Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYG3BDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYG3BDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYG3A4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:56:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbYG3A4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=X9mC4DTiDLQSVQVD+EvGxEQJVxFVPXZqWawLE/C6O3N+SqXjswHGBMeqrm29W+Si9G
         RgVGSFpk50wv7VDvE7THrvxaIGTsTmG5ToYL0Z7A84Gh4h6zd37LvDPzWZI74mRFq2Ng
         7P8LeuGmhpcrU3BrOc4OeoiXDUClaSegT58yU=
Subject: [PATCH 24/24] kernel: depend on asm/byteorder.h defining the
	machine endianness
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:31 -0700
Message-Id: <1217379332.23389.135.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of the unaligned helpers into generic.h and test
the endianness from asm/byteorder.h, remove it from each asm/unaligned.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/include/asm/unaligned.h    |   12 +++++-------
 arch/sparc/include/asm/unaligned.h |    2 --
 include/asm-alpha/unaligned.h      |    3 ---
 include/asm-arm/unaligned.h        |   11 -----------
 include/asm-avr32/unaligned.h      |    3 ---
 include/asm-blackfin/unaligned.h   |    3 ---
 include/asm-cris/unaligned.h       |    3 ---
 include/asm-frv/unaligned.h        |    3 ---
 include/asm-h8300/unaligned.h      |    3 ---
 include/asm-ia64/unaligned.h       |    3 ---
 include/asm-m32r/unaligned.h       |   12 +++++-------
 include/asm-m68k/unaligned.h       |    3 ---
 include/asm-m68knommu/unaligned.h  |   11 ++---------
 include/asm-mips/unaligned.h       |   16 ++++++----------
 include/asm-mn10300/unaligned.h    |    3 ---
 include/asm-parisc/unaligned.h     |    2 --
 include/asm-powerpc/unaligned.h    |    3 ---
 include/asm-s390/unaligned.h       |    3 ---
 include/asm-x86/unaligned.h        |    4 ----
 include/asm-xtensa/unaligned.h     |   16 ++++++----------
 include/linux/unaligned/generic.h  |   10 ++++++++++
 21 files changed, 34 insertions(+), 95 deletions(-)

diff --git a/arch/sh/include/asm/unaligned.h b/arch/sh/include/asm/unaligned.h
index c1641a0..6a15824 100644
--- a/arch/sh/include/asm/unaligned.h
+++ b/arch/sh/include/asm/unaligned.h
@@ -1,19 +1,17 @@
 #ifndef _ASM_SH_UNALIGNED_H
 #define _ASM_SH_UNALIGNED_H
 
+#include <asm/byteorder.h>
+
 /* SH can't handle unaligned accesses. */
-#ifdef __LITTLE_ENDIAN__
+#ifdef __LITTLE_ENDIAN
 # include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
 #else
 # include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
 #endif
 
+#include <linux/unaligned/generic.h>
+
 #endif /* _ASM_SH_UNALIGNED_H */
diff --git a/arch/sparc/include/asm/unaligned.h b/arch/sparc/include/asm/unaligned.h
index 11d2d5f..77c7cac 100644
--- a/arch/sparc/include/asm/unaligned.h
+++ b/arch/sparc/include/asm/unaligned.h
@@ -4,7 +4,5 @@
 #include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff --git a/include/asm-alpha/unaligned.h b/include/asm-alpha/unaligned.h
index 3787c60..84b08e0 100644
--- a/include/asm-alpha/unaligned.h
+++ b/include/asm-alpha/unaligned.h
@@ -5,7 +5,4 @@
 #include <linux/unaligned/be_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
-
 #endif /* _ASM_ALPHA_UNALIGNED_H */
diff --git a/include/asm-arm/unaligned.h b/include/asm-arm/unaligned.h
index 44593a8..70088d3 100644
--- a/include/asm-arm/unaligned.h
+++ b/include/asm-arm/unaligned.h
@@ -5,15 +5,4 @@
 #include <linux/unaligned/be_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-/*
- * Select endianness
- */
-#ifndef __ARMEB__
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-#else
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-#endif
-
 #endif /* _ASM_ARM_UNALIGNED_H */
diff --git a/include/asm-avr32/unaligned.h b/include/asm-avr32/unaligned.h
index 0418772..a350f4a 100644
--- a/include/asm-avr32/unaligned.h
+++ b/include/asm-avr32/unaligned.h
@@ -15,7 +15,4 @@
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif /* _ASM_AVR32_UNALIGNED_H */
diff --git a/include/asm-blackfin/unaligned.h b/include/asm-blackfin/unaligned.h
index fd8a1d6..0653195 100644
--- a/include/asm-blackfin/unaligned.h
+++ b/include/asm-blackfin/unaligned.h
@@ -5,7 +5,4 @@
 #include <linux/unaligned/be_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-
 #endif /* _ASM_BLACKFIN_UNALIGNED_H */
diff --git a/include/asm-cris/unaligned.h b/include/asm-cris/unaligned.h
index 7b3f3fe..a518cef 100644
--- a/include/asm-cris/unaligned.h
+++ b/include/asm-cris/unaligned.h
@@ -7,7 +7,4 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-
 #endif /* _ASM_CRIS_UNALIGNED_H */
diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 839a2fb..3774d1e 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -16,7 +16,4 @@
 #include <linux/unaligned/be_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif /* _ASM_UNALIGNED_H */
diff --git a/include/asm-h8300/unaligned.h b/include/asm-h8300/unaligned.h
index b8d06c7..2f0c281 100644
--- a/include/asm-h8300/unaligned.h
+++ b/include/asm-h8300/unaligned.h
@@ -5,7 +5,4 @@
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif /* _ASM_H8300_UNALIGNED_H */
diff --git a/include/asm-ia64/unaligned.h b/include/asm-ia64/unaligned.h
index 7bddc7f..3ad9366 100644
--- a/include/asm-ia64/unaligned.h
+++ b/include/asm-ia64/unaligned.h
@@ -5,7 +5,4 @@
 #include <linux/unaligned/be_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-
 #endif /* _ASM_IA64_UNALIGNED_H */
diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index 377eb20..04d4138 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -1,18 +1,16 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-#if defined(__LITTLE_ENDIAN__)
+#include <asm/byteorder.h>
+
+#ifdef __LITTLE_ENDIAN
 # include <linux/unaligned/le_memmove.h>
 # include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
 #else
 # include <linux/unaligned/be_memmove.h>
 # include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
 #endif
 
+#include <linux/unaligned/generic.h>
+
 #endif /* _ASM_M32R_UNALIGNED_H */
diff --git a/include/asm-m68k/unaligned.h b/include/asm-m68k/unaligned.h
index 77698f2..1b909e8 100644
--- a/include/asm-m68k/unaligned.h
+++ b/include/asm-m68k/unaligned.h
@@ -7,7 +7,4 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif /* _ASM_M68K_UNALIGNED_H */
diff --git a/include/asm-m68knommu/unaligned.h b/include/asm-m68knommu/unaligned.h
index eb1ea4c..965b640 100644
--- a/include/asm-m68knommu/unaligned.h
+++ b/include/asm-m68knommu/unaligned.h
@@ -5,21 +5,14 @@
 #ifdef CONFIG_COLDFIRE
 #include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
 
 #else
 /*
  * The m68k can do unaligned accesses itself. 
  */
 #include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif
 
+#include <linux/unaligned/generic.h>
+
 #endif /* _ASM_M68KNOMMU_UNALIGNED_H */
diff --git a/include/asm-mips/unaligned.h b/include/asm-mips/unaligned.h
index 7924049..28412fc 100644
--- a/include/asm-mips/unaligned.h
+++ b/include/asm-mips/unaligned.h
@@ -9,20 +9,16 @@
 #define _ASM_MIPS_UNALIGNED_H
 
 #include <linux/compiler.h>
-#if defined(__MIPSEB__)
+#include <asm/byteorder.h>
+
+#ifdef __BIG_ENDIAN
 # include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#elif defined(__MIPSEL__)
+#else
 # include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
 #endif
 
+#include <linux/unaligned/generic.h>
+
 #endif /* _ASM_MIPS_UNALIGNED_H */
diff --git a/include/asm-mn10300/unaligned.h b/include/asm-mn10300/unaligned.h
index 0df6713..d0cf9b4 100644
--- a/include/asm-mn10300/unaligned.h
+++ b/include/asm-mn10300/unaligned.h
@@ -14,7 +14,4 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-
 #endif /* _ASM_MN10300_UNALIGNED_H */
diff --git a/include/asm-parisc/unaligned.h b/include/asm-parisc/unaligned.h
index dfc5d33..3239de9 100644
--- a/include/asm-parisc/unaligned.h
+++ b/include/asm-parisc/unaligned.h
@@ -4,8 +4,6 @@
 #include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
 
 #ifdef __KERNEL__
 struct pt_regs;
diff --git a/include/asm-powerpc/unaligned.h b/include/asm-powerpc/unaligned.h
index 5f1b1e3..4ba95d5 100644
--- a/include/asm-powerpc/unaligned.h
+++ b/include/asm-powerpc/unaligned.h
@@ -9,8 +9,5 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff --git a/include/asm-s390/unaligned.h b/include/asm-s390/unaligned.h
index da9627a..75d37cb 100644
--- a/include/asm-s390/unaligned.h
+++ b/include/asm-s390/unaligned.h
@@ -7,7 +7,4 @@
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
 #endif /* _ASM_S390_UNALIGNED_H */
diff --git a/include/asm-x86/unaligned.h b/include/asm-x86/unaligned.h
index a7bd416..4c3fe16 100644
--- a/include/asm-x86/unaligned.h
+++ b/include/asm-x86/unaligned.h
@@ -4,11 +4,7 @@
 /*
  * The x86 can do unaligned accesses itself.
  */
-
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
 
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
-
 #endif /* _ASM_X86_UNALIGNED_H */
diff --git a/include/asm-xtensa/unaligned.h b/include/asm-xtensa/unaligned.h
index 8f3424f..13ae4bb 100644
--- a/include/asm-xtensa/unaligned.h
+++ b/include/asm-xtensa/unaligned.h
@@ -10,20 +10,16 @@
 #ifndef _ASM_XTENSA_UNALIGNED_H
 #define _ASM_XTENSA_UNALIGNED_H
 
-#ifdef __XTENSA_EL__
+#include <asm/byteorder.h>
+
+#ifdef __LITTLE_ENDIAN
 # include <linux/unaligned/le_memmove.h>
 # include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#elif defined(__XTENSA_EB__)
+#else
 # include <linux/unaligned/be_memmove.h>
 # include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#else
-# error processor byte order undefined!
 #endif
 
+#include <linux/unaligned/generic.h>
+
 #endif	/* _ASM_XTENSA_UNALIGNED_H */
diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
index 02d97ff..bd4c6c9 100644
--- a/include/linux/unaligned/generic.h
+++ b/include/linux/unaligned/generic.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_UNALIGNED_GENERIC_H
 #define _LINUX_UNALIGNED_GENERIC_H
 
+#include <asm/byteorder.h>
+
 /*
  * Cause a link-time error if we try an unaligned access other than
  * 1,2,4 or 8 bytes long
@@ -65,4 +67,12 @@ extern void __bad_unaligned_access_size(void);
 	}								\
 	(void)0; })
 
+#ifdef __LITTLE_ENDIAN
+# define get_unaligned __get_unaligned_le
+# define put_unaligned __put_unaligned_le
+#else
+# define get_unaligned __get_unaligned_be
+# define put_unaligned __put_unaligned_be
+#endif
+
 #endif /* _LINUX_UNALIGNED_GENERIC_H */
-- 
1.6.0.rc1.154.ge3fc


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYK3Clc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYK3Clc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 21:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYK3Cko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 21:40:44 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:29749 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYK3Ckj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 21:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=U70oeQbzpXAF+hG9oCVfjoOzegcNsQ/luWKhmNtC//OCPjDHD/+M1I/E+CbYpGllqL
         bwcZSquU3w/RzxNwnGLAgtLeIHVapUBgL6Xscqu8zLoeKCwFfFKZmA1cGP14pcQ5ZvSJ
         /O4uAweI/JyIB35EcpXlVjmjMq4S8CCitZro4=
Subject: [PATCH-mm 3/7] unaligned: wire up trivial arches for new common
 unaligned header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 18:40:30 -0800
Message-Id: <1228012830.26141.1028.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arches where unaligned access is OK, or arches the use packed-struct
for the native endianness and byteshifting for the opposite endianness.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/include/asm/unaligned.h     |    7 +------
 arch/avr32/include/asm/unaligned.h     |    8 +-------
 arch/blackfin/include/asm/unaligned.h  |    7 +------
 arch/cris/include/asm/unaligned.h      |    7 ++-----
 arch/ia64/include/asm/unaligned.h      |    7 +------
 arch/m68knommu/include/asm/unaligned.h |   22 +++++-----------------
 arch/mips/include/asm/unaligned.h      |   17 +----------------
 arch/parisc/include/asm/unaligned.h    |    6 +-----
 arch/powerpc/include/asm/unaligned.h   |    7 ++-----
 arch/s390/include/asm/unaligned.h      |    7 ++-----
 arch/sparc/include/asm/unaligned.h     |    6 +-----
 arch/x86/include/asm/unaligned.h       |    8 ++------
 arch/xtensa/include/asm/unaligned.h    |   16 +---------------
 include/asm-frv/unaligned.h            |    7 +------
 include/asm-m68k/unaligned.h           |    7 ++-----
 include/asm-mn10300/unaligned.h        |    7 ++-----
 16 files changed, 26 insertions(+), 120 deletions(-)

diff --git a/arch/alpha/include/asm/unaligned.h b/arch/alpha/include/asm/unaligned.h
index 3787c60..3ae1a25 100644
--- a/arch/alpha/include/asm/unaligned.h
+++ b/arch/alpha/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_ALPHA_UNALIGNED_H
 #define _ASM_ALPHA_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
+#include <linux/unaligned.h>
 
 #endif /* _ASM_ALPHA_UNALIGNED_H */
diff --git a/arch/avr32/include/asm/unaligned.h b/arch/avr32/include/asm/unaligned.h
index 0418772..e85cf9c 100644
--- a/arch/avr32/include/asm/unaligned.h
+++ b/arch/avr32/include/asm/unaligned.h
@@ -10,12 +10,6 @@
  * However, swapped word loads must be word-aligned so we can't
  * optimize word loads in general.
  */
-
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <linux/unaligned.h>
 
 #endif /* _ASM_AVR32_UNALIGNED_H */
diff --git a/arch/blackfin/include/asm/unaligned.h b/arch/blackfin/include/asm/unaligned.h
index fd8a1d6..e509f59 100644
--- a/arch/blackfin/include/asm/unaligned.h
+++ b/arch/blackfin/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_BLACKFIN_UNALIGNED_H
 #define _ASM_BLACKFIN_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#include <linux/unaligned.h>
 
 #endif /* _ASM_BLACKFIN_UNALIGNED_H */
diff --git a/arch/cris/include/asm/unaligned.h b/arch/cris/include/asm/unaligned.h
index 7b3f3fe..13aa4c1 100644
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
+#include <linux/unaligned.h>
 
 #endif /* _ASM_CRIS_UNALIGNED_H */
diff --git a/arch/ia64/include/asm/unaligned.h b/arch/ia64/include/asm/unaligned.h
index 7bddc7f..bfe338f 100644
--- a/arch/ia64/include/asm/unaligned.h
+++ b/arch/ia64/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_IA64_UNALIGNED_H
 #define _ASM_IA64_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#include <linux/unaligned.h>
 
 #endif /* _ASM_IA64_UNALIGNED_H */
diff --git a/arch/m68knommu/include/asm/unaligned.h b/arch/m68knommu/include/asm/unaligned.h
index eb1ea4c..fe1719f 100644
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
 
+#include <linux/unaligned.h>
+
 #endif /* _ASM_M68KNOMMU_UNALIGNED_H */
diff --git a/arch/mips/include/asm/unaligned.h b/arch/mips/include/asm/unaligned.h
index 7924049..e2cb2be 100644
--- a/arch/mips/include/asm/unaligned.h
+++ b/arch/mips/include/asm/unaligned.h
@@ -8,21 +8,6 @@
 #ifndef _ASM_MIPS_UNALIGNED_H
 #define _ASM_MIPS_UNALIGNED_H
 
-#include <linux/compiler.h>
-#if defined(__MIPSEB__)
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#elif defined(__MIPSEL__)
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
-#endif
+#include <linux/unaligned.h>
 
 #endif /* _ASM_MIPS_UNALIGNED_H */
diff --git a/arch/parisc/include/asm/unaligned.h b/arch/parisc/include/asm/unaligned.h
index dfc5d33..cedbd46 100644
--- a/arch/parisc/include/asm/unaligned.h
+++ b/arch/parisc/include/asm/unaligned.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_PARISC_UNALIGNED_H
 #define _ASM_PARISC_UNALIGNED_H
 
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <linux/unaligned.h>
 
 #ifdef __KERNEL__
 struct pt_regs;
diff --git a/arch/powerpc/include/asm/unaligned.h b/arch/powerpc/include/asm/unaligned.h
index 5f1b1e3..f077db7 100644
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
+#include <linux/unaligned.h>
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff --git a/arch/s390/include/asm/unaligned.h b/arch/s390/include/asm/unaligned.h
index da9627a..b397098 100644
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
+#include <linux/unaligned.h>
 
 #endif /* _ASM_S390_UNALIGNED_H */
diff --git a/arch/sparc/include/asm/unaligned.h b/arch/sparc/include/asm/unaligned.h
index 11d2d5f..7a34899 100644
--- a/arch/sparc/include/asm/unaligned.h
+++ b/arch/sparc/include/asm/unaligned.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_SPARC_UNALIGNED_H
 #define _ASM_SPARC_UNALIGNED_H
 
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <linux/unaligned.h>
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff --git a/arch/x86/include/asm/unaligned.h b/arch/x86/include/asm/unaligned.h
index a7bd416..8aeddd8 100644
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
+#include <linux/unaligned.h>
 
 #endif /* _ASM_X86_UNALIGNED_H */
diff --git a/arch/xtensa/include/asm/unaligned.h b/arch/xtensa/include/asm/unaligned.h
index 8e7ed04..956a792 100644
--- a/arch/xtensa/include/asm/unaligned.h
+++ b/arch/xtensa/include/asm/unaligned.h
@@ -10,20 +10,6 @@
 #ifndef _ASM_XTENSA_UNALIGNED_H
 #define _ASM_XTENSA_UNALIGNED_H
 
-#include <asm/byteorder.h>
-
-#ifdef __LITTLE_ENDIAN
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <linux/unaligned.h>
 
 #endif	/* _ASM_XTENSA_UNALIGNED_H */
diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 6c61c05..00e23aa 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -12,11 +12,6 @@
 #ifndef _ASM_UNALIGNED_H
 #define _ASM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <linux/unaligned.h>
 
 #endif /* _ASM_UNALIGNED_H */
diff --git a/include/asm-m68k/unaligned.h b/include/asm-m68k/unaligned.h
index 77698f2..59f03b9 100644
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
+#include <linux/unaligned.h>
 
 #endif /* _ASM_M68K_UNALIGNED_H */
diff --git a/include/asm-mn10300/unaligned.h b/include/asm-mn10300/unaligned.h
index 0df6713..5471a65 100644
--- a/include/asm-mn10300/unaligned.h
+++ b/include/asm-mn10300/unaligned.h
@@ -11,10 +11,7 @@
 #ifndef _ASM_MN10300_UNALIGNED_H
 #define _ASM_MN10300_UNALIGNED_H
 
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#define _UNALIGNED_ACCESS_OK
+#include <linux/unaligned.h>
 
 #endif /* _ASM_MN10300_UNALIGNED_H */
-- 
1.6.0.4.1044.g77718



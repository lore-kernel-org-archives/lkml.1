Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbYKRDj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbYKRDj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYKRDjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:17 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:34235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYKRDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=arHEmqBNSmpZQXN7A12iAc6bm3x0C+m/YrjT/OO3a3cREtU/YTCDSSeGUn1DVcMVf4
         ZKpXpV5h+Y1LReC1wfMmDaBCWlGWt2NUJH0HHUQNxMwDAX14jRgGtsc+NnECHhreY4gQ
         2USGUCIHUpO4PvQfIpzJXe1EDoNpENfr7+ARI=
Subject: [PATCH-mm 3/7] unaligned: use generic implementation on
 packed-struct arches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:11 -0800
Message-Id: <1226979551.6150.268.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, convert arches that use the packed-struct
implementation for native-endianness and C byteshifting for the
other endianness.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/include/asm/unaligned.h    |    7 +------
 arch/avr32/include/asm/unaligned.h    |    8 +-------
 arch/blackfin/include/asm/unaligned.h |    7 +------
 arch/ia64/include/asm/unaligned.h     |    7 +------
 arch/mips/include/asm/unaligned.h     |   17 +----------------
 arch/parisc/include/asm/unaligned.h   |    6 +-----
 arch/sh/include/asm/unaligned.h       |   15 +--------------
 arch/sparc/include/asm/unaligned.h    |    6 +-----
 arch/xtensa/include/asm/unaligned.h   |   16 +---------------
 include/asm-frv/unaligned.h           |    7 +------
 10 files changed, 10 insertions(+), 86 deletions(-)

diff --git a/arch/alpha/include/asm/unaligned.h b/arch/alpha/include/asm/unaligned.h
index 3787c60..15d5fb6 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_ALPHA_UNALIGNED_H */
diff --git a/arch/avr32/include/asm/unaligned.h b/arch/avr32/include/asm/unaligned.h
index 0418772..6352ba2 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_AVR32_UNALIGNED_H */
diff --git a/arch/blackfin/include/asm/unaligned.h b/arch/blackfin/include/asm/unaligned.h
index fd8a1d6..ffed1bd 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_BLACKFIN_UNALIGNED_H */
diff --git a/arch/ia64/include/asm/unaligned.h b/arch/ia64/include/asm/unaligned.h
index 7bddc7f..bb85598 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_IA64_UNALIGNED_H */
diff --git a/arch/mips/include/asm/unaligned.h b/arch/mips/include/asm/unaligned.h
index 7924049..a970d81 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_MIPS_UNALIGNED_H */
diff --git a/arch/parisc/include/asm/unaligned.h b/arch/parisc/include/asm/unaligned.h
index dfc5d33..7412f5f 100644
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
+#include <asm-generic/unaligned.h>
 
 #ifdef __KERNEL__
 struct pt_regs;
diff --git a/arch/sh/include/asm/unaligned.h b/arch/sh/include/asm/unaligned.h
index c1641a0..abe2dd7 100644
--- a/arch/sh/include/asm/unaligned.h
+++ b/arch/sh/include/asm/unaligned.h
@@ -1,19 +1,6 @@
 #ifndef _ASM_SH_UNALIGNED_H
 #define _ASM_SH_UNALIGNED_H
 
-/* SH can't handle unaligned accesses. */
-#ifdef __LITTLE_ENDIAN__
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_SH_UNALIGNED_H */
diff --git a/arch/sparc/include/asm/unaligned.h b/arch/sparc/include/asm/unaligned.h
index 11d2d5f..1a633da 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff --git a/arch/xtensa/include/asm/unaligned.h b/arch/xtensa/include/asm/unaligned.h
index 8e7ed04..3922953 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif	/* _ASM_XTENSA_UNALIGNED_H */
diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 6c61c05..4fec13c 100644
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_UNALIGNED_H */
-- 
1.6.0.4.994.g16bd3e



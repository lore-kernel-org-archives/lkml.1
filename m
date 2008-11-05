Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYKESRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYKESRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYKESQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:16:31 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:40972 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYKESQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gI+qp1/tMLInVznNo0j3rC0HLnicUZXYg7L57zsknmRHHL3Sz54RPD62AunyI1DMhZ
         TMNrcPpBJnBmb7rRx8P3wpLTSzlNtoHP4Xhl1Knp1PGVUXn/mCfz+RKdqFepb4xQjV5T
         uOoFVbsxN6ueWaimIpZF590uOzUTc1RxicpZs=
Subject: [RFC-PATCH 4/5] unaligned: convert all remaining arches to common
 asm-generic version
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Chris Zankel <chris@zankel.net>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:16:18 -0800
Message-Id: <1225908978.5991.183.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Not for immediate application, RFC-only.

 arch/arm/include/asm/unaligned.h   |   15 +--------------
 arch/h8300/include/asm/unaligned.h |    7 +------
 include/asm-m32r/unaligned.h       |   14 +-------------
 include/asm-xtensa/unaligned.h     |   16 +---------------
 4 files changed, 4 insertions(+), 48 deletions(-)

diff --git a/arch/arm/include/asm/unaligned.h b/arch/arm/include/asm/unaligned.h
index 44593a8..c1bf50b 100644
--- a/arch/arm/include/asm/unaligned.h
+++ b/arch/arm/include/asm/unaligned.h
@@ -1,19 +1,6 @@
 #ifndef _ASM_ARM_UNALIGNED_H
 #define _ASM_ARM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
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
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_ARM_UNALIGNED_H */
diff --git a/arch/h8300/include/asm/unaligned.h b/arch/h8300/include/asm/unaligned.h
index b8d06c7..4d7c1f5 100644
--- a/arch/h8300/include/asm/unaligned.h
+++ b/arch/h8300/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_H8300_UNALIGNED_H */
diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index 377eb20..14d2598 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -1,18 +1,6 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-#if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_M32R_UNALIGNED_H */
diff --git a/include/asm-xtensa/unaligned.h b/include/asm-xtensa/unaligned.h
index 8f3424f..3922953 100644
--- a/include/asm-xtensa/unaligned.h
+++ b/include/asm-xtensa/unaligned.h
@@ -10,20 +10,6 @@
 #ifndef _ASM_XTENSA_UNALIGNED_H
 #define _ASM_XTENSA_UNALIGNED_H
 
-#ifdef __XTENSA_EL__
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#elif defined(__XTENSA_EB__)
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#else
-# error processor byte order undefined!
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif	/* _ASM_XTENSA_UNALIGNED_H */
-- 
1.6.0.3.756.gb776d



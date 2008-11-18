Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKRDlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKRDlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKRDjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:23939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYKRDjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jtRYhjpsCqJhfKDkakKs69XDqIVxceeNzqWI4jxpHIt1CfbL5QedtjGj1JV08MaBiL
         1+kYJaoEDfoE/PZdQrH5zhWsjqoyzWwrORNI/VnNz+GjA+RPaCSkpb+NL+5QD7W6K7nz
         7rYtwdn9jmYnjnnye/gO/RFcodD4qIHWhcNWs=
Subject: [PATCH-mm 6/7] unaligned: move ARM, M32R, H8300 to the asm-generic
 version
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:13 -0800
Message-Id: <1226979553.6150.271.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/arm/include/asm/unaligned.h   |   15 +--------------
 arch/h8300/include/asm/unaligned.h |    7 +------
 include/asm-m32r/unaligned.h       |   14 +-------------
 3 files changed, 3 insertions(+), 33 deletions(-)

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
-- 
1.6.0.4.994.g16bd3e



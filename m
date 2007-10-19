Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbXJSGJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbXJSGJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXJSGJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:09:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXJSGJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:09:33 -0400
Date: Fri, 19 Oct 2007 02:09:29 -0400
From: Chris Snook <csnook@redhat.com>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: mostly merge types.h
Message-ID: <20071019060929.GA16291@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Most of types_32.h and types_64.h are the same.  Merge the common definitions
into types.h, keeping the differences in their own files.  Also #error if
types_{32,64}.h is included directly.  Tested with allmodconfig on x86_64.

Signed-off-by: Chris Snook <csnook@redhat.com>

 types.h    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 types_32.h |   48 ++++++------------------------------------------
 types_64.h |   47 +++++++----------------------------------------
 3 files changed, 58 insertions(+), 82 deletions(-)

diff -urp a/include/asm-x86/types_32.h b/include/asm-x86/types_32.h
--- a/include/asm-x86/types_32.h	2007-10-18 04:23:36.000000000 -0400
+++ b/include/asm-x86/types_32.h	2007-10-18 07:03:05.000000000 -0400
@@ -1,64 +1,28 @@
 #ifndef _I386_TYPES_H
 #define _I386_TYPES_H
 
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-/*
- * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
- * header files exported to user space
- */
-
-typedef __signed__ char __s8;
-typedef unsigned char __u8;
-
-typedef __signed__ short __s16;
-typedef unsigned short __u16;
-
-typedef __signed__ int __s32;
-typedef unsigned int __u32;
+#ifndef _X86_TYPES_H
+#error Do not include this file directly.  Use asm/types.h instead.
+#endif
 
-#if defined(__GNUC__)
+#if !defined(__ASSEMBLY__) && defined(__GNUC__)
 __extension__ typedef __signed__ long long __s64;
 __extension__ typedef unsigned long long __u64;
 #endif
 
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
 #ifdef __KERNEL__
 
 #define BITS_PER_LONG 32
 
 #ifndef __ASSEMBLY__
 
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long long s64;
-typedef unsigned long long u64;
-
-/* DMA addresses come in generic and 64-bit flavours.  */
-
+/* DMA addresses come in generic and 64-bit flavours. */
 #ifdef CONFIG_HIGHMEM64G
 typedef u64 dma_addr_t;
 #else
 typedef u32 dma_addr_t;
 #endif
-typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
-
-#endif
+#endif /* _I386_TYPES_H */
diff -urp a/include/asm-x86/types_64.h b/include/asm-x86/types_64.h
--- a/include/asm-x86/types_64.h	2007-10-18 04:23:36.000000000 -0400
+++ b/include/asm-x86/types_64.h	2007-10-18 07:03:11.000000000 -0400
@@ -1,55 +1,22 @@
 #ifndef _X86_64_TYPES_H
 #define _X86_64_TYPES_H
 
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-/*
- * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
- * header files exported to user space
- */
-
-typedef __signed__ char __s8;
-typedef unsigned char __u8;
-
-typedef __signed__ short __s16;
-typedef unsigned short __u16;
-
-typedef __signed__ int __s32;
-typedef unsigned int __u32;
+#ifndef _X86_TYPES_H
+#error Do not include this file directly.  Use asm/types.h instead.
+#endif
 
+#ifndef __ASSEMBLY__
 typedef __signed__ long long __s64;
 typedef unsigned long long  __u64;
+#endif
 
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
 #ifdef __KERNEL__
 
 #define BITS_PER_LONG 64
 
 #ifndef __ASSEMBLY__
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long long s64;
-typedef unsigned long long u64;
-
-typedef u64 dma64_addr_t;
 typedef u64 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
+#endif
 
 #endif /* __KERNEL__ */
-
-#endif
+#endif /* _X86_64_TYPES_H */
diff -urp a/include/asm-x86/types.h b/include/asm-x86/types.h
--- a/include/asm-x86/types.h	2007-10-18 04:23:36.000000000 -0400
+++ b/include/asm-x86/types.h	2007-10-18 06:59:37.000000000 -0400
@@ -1,3 +1,46 @@
+#ifndef _X86_TYPES_H
+#define _X86_TYPES_H
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+/*
+ * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
+ * header files exported to user space
+ */
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+typedef signed char s8;
+typedef unsigned char u8;
+
+typedef signed short s16;
+typedef unsigned short u16;
+
+typedef signed int s32;
+typedef unsigned int u32;
+
+typedef signed long long s64;
+typedef unsigned long long u64;
+
+typedef u64 dma64_addr_t;
+
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
 #  include "types_32.h"
@@ -11,3 +54,5 @@
 #  include "types_64.h"
 # endif
 #endif
+
+#endif /* _X86_TYPES_H */


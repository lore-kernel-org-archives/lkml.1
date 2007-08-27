Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXH0QBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXH0QBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbXH0Pzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41958 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976AbXH0Pzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:48 -0400
Message-Id: <20070827155524.503255159@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, ralf@linux-mips.org
Subject: [patch 03/28] Add cmpxchg64 and cmpxchg64_local to mips
Content-Disposition: inline; filename=add-cmpxchg64-to-mips.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: ralf@linux-mips.org
CC linux-mips@linux-mips.org
---
 include/asm-mips/system.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-mips/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/system.h	2007-08-27 11:28:22.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/system.h	2007-08-27 11:38:09.000000000 -0400
@@ -407,13 +407,22 @@ static inline unsigned long __cmpxchg_u6
 	return retval;
 }
 
+#define cmpxchg64	cmpxchg
+#define cmpxchg64_local	cmpxchg_local
+
 #else
+
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 extern unsigned long __cmpxchg_u64_unsupported_on_32bit_kernels(
 	volatile int * m, unsigned long old, unsigned long new);
 #define __cmpxchg_u64 __cmpxchg_u64_unsupported_on_32bit_kernels
 extern unsigned long __cmpxchg_u64_local_unsupported_on_32bit_kernels(
 	volatile int * m, unsigned long old, unsigned long new);
 #define __cmpxchg_u64_local __cmpxchg_u64_local_unsupported_on_32bit_kernels
+
 #endif
 
 /* This function doesn't exist, so you'll get a linker error
@@ -449,7 +458,6 @@ static inline unsigned long __cmpxchg_lo
 #define cmpxchg(ptr,old,new) \
 	((__typeof__(*(ptr)))__cmpxchg((ptr), \
 		(unsigned long)(old), (unsigned long)(new),sizeof(*(ptr))))
-
 #define cmpxchg_local(ptr,old,new) \
 	((__typeof__(*(ptr)))__cmpxchg_local((ptr), \
 		(unsigned long)(old), (unsigned long)(new),sizeof(*(ptr))))

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

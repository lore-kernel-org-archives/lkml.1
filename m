Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbXJaWpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbXJaWpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760102AbXJaWmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51397 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbXJaWmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:25 -0400
Message-Id: <20071031224212.122045309@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>
Subject: [patch 06/28] Add cmpxchg64 and cmpxchg64_local to x86_64
Content-Disposition: inline; filename=add-cmpxchg64-to-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
---
 include/asm-x86_64/cmpxchg.h |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/asm-x86_64/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cmpxchg.h	2007-10-31 17:32:44.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cmpxchg.h	2007-10-31 17:58:01.000000000 -0400
@@ -124,11 +124,21 @@ static inline unsigned long __cmpxchg_lo
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
 
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

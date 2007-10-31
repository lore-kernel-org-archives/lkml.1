Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXJaWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXJaWoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbXJaWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51381 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbXJaWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:23 -0400
Message-Id: <20071031224211.514698475@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, ralf@linux-mips.org
Subject: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to mips
Content-Disposition: inline; filename=add-cmpxchg64-to-mips.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: ralf@linux-mips.org
CC linux-mips@linux-mips.org
---
 include/asm-mips/cmpxchg.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-lttng/include/asm-mips/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/cmpxchg.h	2007-10-31 17:32:44.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/cmpxchg.h	2007-10-31 17:54:49.000000000 -0400
@@ -104,4 +104,21 @@ extern void __cmpxchg_called_with_bad_po
 #define cmpxchg(ptr, old, new)		__cmpxchg(ptr, old, new, smp_llsc_mb())
 #define cmpxchg_local(ptr, old, new)	__cmpxchg(ptr, old, new, )
 
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 #endif /* __ASM_CMPXCHG_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

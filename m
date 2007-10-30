Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbXJ3T20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbXJ3T20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXJ3TWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:22:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54089 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814AbXJ3TV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:56 -0400
Message-Id: <20071030192102.677087409@polymtl.ca>
References: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:16:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, ralf@linux-mips.org
Subject: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to mips
Content-Disposition: inline; filename=add-cmpxchg64-to-mips.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: ralf@linux-mips.org
CC linux-mips@linux-mips.org
---
 include/asm-mips/cmpxchg.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6-lttng/include/asm-mips/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/cmpxchg.h	2007-10-12 12:05:06.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/cmpxchg.h	2007-10-12 12:08:56.000000000 -0400
@@ -104,4 +104,13 @@ extern void __cmpxchg_called_with_bad_po
 #define cmpxchg(ptr, old, new)		__cmpxchg(ptr, old, new, smp_llsc_mb())
 #define cmpxchg_local(ptr, old, new)	__cmpxchg(ptr, old, new, )
 
+#define cmpxchg64	cmpxchg
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local	cmpxchg_local
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr,o,n)	__cmpxchg64_local_generic((ptr),(o),(n))
+#endif
+
 #endif /* __ASM_CMPXCHG_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

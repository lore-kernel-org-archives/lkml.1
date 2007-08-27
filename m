Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbXH0Qnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbXH0Qnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbXH0QiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:38:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54322 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbXH0QiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:38:13 -0400
Message-Id: <20070827155524.827591009@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to powerpc
Content-Disposition: inline; filename=add-cmpxchg64-to-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:37:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: paulus@samba.org
CC: linuxppc-dev@ozlabs.org
---
 include/asm-powerpc/system.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/system.h	2007-08-27 11:42:08.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/system.h	2007-08-27 11:42:43.000000000 -0400
@@ -485,6 +485,12 @@ __cmpxchg_local(volatile void *ptr, unsi
  */
 #define NET_IP_ALIGN	0
 #define NET_SKB_PAD	L1_CACHE_BYTES
+
+#define cmpxchg64	cmpxchg
+#define cmpxchg64_local	cmpxchg_local
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
 #define arch_align_stack(x) (x)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

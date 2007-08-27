Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbXH0Pz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbXH0Pz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbXH0Pzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41828 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592AbXH0Pzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:33 -0400
Message-Id: <20070827155524.196067138@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: [patch 02/28] Add cmpxchg64 and cmpxchg64_local to alpha
Content-Disposition: inline; filename=add-cmpxchg64-to-alpha.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: rth@twiddle.net
CC: ink@jurassic.park.msu.ru
---
 include/asm-alpha/system.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-alpha/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/system.h	2007-08-27 11:23:08.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/system.h	2007-08-27 11:23:46.000000000 -0400
@@ -687,6 +687,7 @@ __cmpxchg(volatile void *ptr, unsigned l
      (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64	cmpxchg
 
 static inline unsigned long
 __cmpxchg_u8_local(volatile char *m, long old, long new)
@@ -809,6 +810,7 @@ __cmpxchg_local(volatile void *ptr, unsi
      (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64_local	cmpxchg_local
 
 #endif /* __ASSEMBLY__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

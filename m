Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXJaWmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXJaWmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbXJaWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:20 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51330 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbXJaWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:19 -0400
Message-Id: <20071031224211.219641523@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: [patch 03/28] Add cmpxchg64 and cmpxchg64_local to alpha
Content-Disposition: inline; filename=add-cmpxchg64-to-alpha.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: rth@twiddle.net
CC: ink@jurassic.park.msu.ru
---
 include/asm-alpha/system.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/asm-alpha/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/system.h	2007-10-31 17:32:44.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/system.h	2007-10-31 17:52:23.000000000 -0400
@@ -681,13 +681,18 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)						 \
+#define cmpxchg(ptr, o, n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
      (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64(ptr, o, n)						 \
+  ({									 \
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
+	cmpxchg((ptr), (o), (n));					 \
+  })
 
 static inline unsigned long
 __cmpxchg_u8_local(volatile char *m, long old, long new)
@@ -803,13 +808,19 @@ __cmpxchg_local(volatile void *ptr, unsi
 	return old;
 }
 
-#define cmpxchg_local(ptr,o,n)						 \
+#define cmpxchg_local(ptr, o, n)					 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
      (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
+#define cmpxchg64_local(ptr, o, n)					 \
+  ({									 \
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
+	cmpxchg_local((ptr), (o), (n));					 \
+  })
+
 
 #endif /* __ASSEMBLY__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

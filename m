Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXJ3T0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXJ3T0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXJ3TVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:53 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54051 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbXJ3TVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:52 -0400
Message-Id: <20071030192103.292022353@polymtl.ca>
References: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:16:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>
Subject: [patch 06/28] Add cmpxchg64 and cmpxchg64_local to x86_64
Content-Disposition: inline; filename=add-cmpxchg64-to-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
---
 include/asm-x86_64/cmpxchg.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-x86_64/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cmpxchg.h	2007-08-27 11:16:46.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cmpxchg.h	2007-08-27 11:17:21.000000000 -0400
@@ -127,8 +127,10 @@ static inline unsigned long __cmpxchg_lo
 #define cmpxchg(ptr,o,n)\
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg64	cmpxchg
 #define cmpxchg_local(ptr,o,n)\
 	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg64_local	cmpxchg_local
 
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

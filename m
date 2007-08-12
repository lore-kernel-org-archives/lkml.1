Return-Path: <linux-kernel-owner+w=401wt.eu-S935624AbXHLPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624AbXHLPCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764642AbXHLO7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:59:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46546 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762979AbXHLO64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:58:56 -0400
Message-Id: <20070812145838.211752593@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, tony.luck@intel.com
Subject: [patch 09/23] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
Content-Disposition: inline; filename=add-cmpxchg-local-to-ia64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
use cmpxchg_acq as underlying macro, just like the already existing ia64
cmpxchg().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: tony.luck@intel.com
---
 include/asm-ia64/intrinsics.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/include/asm-ia64/intrinsics.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/intrinsics.h	2007-07-20 18:36:09.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/intrinsics.h	2007-07-20 19:29:17.000000000 -0400
@@ -158,6 +158,10 @@ extern long ia64_cmpxchg_called_with_bad
 
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+#define cmpxchg_local(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+
+#define cmpxchg64(ptr,o,n)		cmpxchg_acq(ptr,o,n)
+#define cmpxchg64_local(ptr,o,n)	cmpxchg_acq(ptr,o,n)
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbXIFUls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbXIFUls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbXIFUkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:40:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50959 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXIFUkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:40:16 -0400
Message-Id: <20070906200316.027744569@polymtl.ca>
References: <20070906200228.086651361@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 16:02:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 7/8] Immediate Values Powerpc Optimization Fix
Content-Disposition: inline; filename=immediate-values-powerpc-optimization-fix.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Sep 2007 20:40:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bad call to flush_icache_range(). The second parameter is the end address
of the range, not the length.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/kernel/immediate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/immediate.c	2007-08-28 16:36:10.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-08-28 16:36:40.000000000 -0400
@@ -67,7 +67,7 @@ int arch_immediate_update(const struct _
 	memcpy((void*)immediate->immediate, (void*)immediate->var,
 			immediate->size);
 	flush_icache_range((unsigned long)immediate->immediate,
-				immediate->size);
+		(unsigned long)immediate->immediate + immediate->size);
 	return 0;
 }
 
@@ -99,5 +99,5 @@ void __init arch_immediate_update_early(
 	memcpy((void*)immediate->immediate, (void*)immediate->var,
 			immediate->size);
 	flush_icache_range((unsigned long)immediate->immediate,
-				immediate->size);
+		(unsigned long)immediate->immediate + immediate->size);
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

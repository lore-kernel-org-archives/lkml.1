Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbXHLPAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbXHLPAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbXHLO6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:58:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46527 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761513AbXHLO6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:58:51 -0400
Message-Id: <20070812145838.903282535@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
Subject: [patch 11/23] Fix m32r __xchg
Content-Disposition: inline; filename=fix-m32r-__xchg.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the #endif  /* CONFIG_SMP */ should cover the default condition, or it may cause
bad parameter to be silently missed.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: takata@linux-m32r.org
CC: linux-m32r@ml.linux-m32r.org
---
 include/asm-m32r/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-m32r/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/system.h	2007-08-07 14:55:02.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/system.h	2007-08-07 14:57:57.000000000 -0400
@@ -189,9 +189,9 @@ __xchg(unsigned long x, volatile void * 
 #endif	/* CONFIG_CHIP_M32700_TS1 */
 		);
 		break;
+#endif  /* CONFIG_SMP */
 	default:
 		__xchg_called_with_bad_pointer();
-#endif  /* CONFIG_SMP */
 	}
 
 	local_irq_restore(flags);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

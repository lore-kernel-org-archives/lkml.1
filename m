Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbXHTUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbXHTUY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761981AbXHTUTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:19:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53822 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762406AbXHTUTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:19:23 -0400
Message-Id: <20070820201826.836064378@polymtl.ca>
References: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Adrian Bunk <bunk@kernel.org>
Subject: [patch 11/23] Fix m32r __xchg
Content-Disposition: inline; filename=fix-m32r-__xchg.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:18:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the #endif  /* CONFIG_SMP */ should cover the default condition, or it may cause
bad parameter to be silently missed.

To make it work correctly, we have to remove the ifdef CONFIG SMP surrounding 
__xchg_called_with_bad_pointer declaration. Thanks to Adrian Bunk for detecting
this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: takata@linux-m32r.org
CC: linux-m32r@ml.linux-m32r.org
CC: Adrian Bunk <bunk@kernel.org>
---
 include/asm-m32r/system.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-m32r/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/system.h	2007-08-13 18:21:02.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/system.h	2007-08-19 07:08:26.000000000 -0400
@@ -127,9 +127,7 @@ static inline void local_irq_disable(voi
 	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x),(ptr), \
 			sizeof(*(ptr))))
 
-#ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
-#endif
 
 #ifdef CONFIG_CHIP_M32700_TS1
 #define DCACHE_CLEAR(reg0, reg1, addr)				\
@@ -189,9 +187,9 @@ __xchg(unsigned long x, volatile void * 
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

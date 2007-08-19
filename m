Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXHSLMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXHSLMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 07:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXHSLMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 07:12:17 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:62053 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbXHSLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 07:12:16 -0400
Date: Sun, 19 Aug 2007 07:12:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
Subject: [PATCH] Fix m32r __xchg (revised)
Message-ID: <20070819111213.GA2368@Krystal>
References: <20070812145434.520271946@polymtl.ca> <20070812145838.903282535@polymtl.ca> <20070818204034.GC32595@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070818204034.GC32595@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:09:59 up 20 days, 11:28,  1 user,  load average: 1.24, 0.92, 0.91
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix m32r __xchg (revised)

the #endif  /* CONFIG_SMP */ should cover the default condition, or it may cause
bad parameter to be silently missed.

To make it work correctly, we have to remove the ifdef CONFIG SMP surrounding 
__xchg_called_with_bad_pointer declaration. Thanks to Adrian Bunk for
detecting this.

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

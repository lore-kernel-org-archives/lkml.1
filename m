Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZIXOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZIXOmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZIXOmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48091 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZIXOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:42:46 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 10:42:44 EDT
Message-Id: <20090924133400.044916740@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/12] Sparc create asm.h
Content-Disposition: inline; filename=sparc64-create-asm-h.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a assembly compatibility header for sparc32/64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/asm.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6-lttng/arch/sparc/include/asm/asm.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/asm.h	2009-09-24 08:42:17.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/include/asm/asm.h	2009-09-24 08:49:13.000000000 -0400
@@ -18,6 +18,7 @@
 	brnz,PREDICT	REG, DEST
 #define BRANCH_REG_NOT_ZERO_ANNUL(PREDICT, REG, DEST) \
 	brnz,a,PREDICT	REG, DEST
+#define __ASM_SEL(a, b)	__ASM_FORM(b)
 #else
 #define BRANCH32(TYPE, PREDICT, DEST) \
 	TYPE		DEST
@@ -35,6 +36,16 @@
 #define BRANCH_REG_NOT_ZERO_ANNUL(PREDICT, REG, DEST) \
 	cmp		REG, 0; \
 	bne,a		DEST
+#define __ASM_SEL(a, b)	__ASM_FORM(a)
 #endif
 
+#ifdef __ASSEMBLY__
+#define __ASM_FORM(x)	x
+#else
+#define __ASM_FORM(x)	" " #x " "
+#endif
+
+#define _ASM_PTR	__ASM_SEL(.word, .xword)
+#define _ASM_UAPTR	__ASM_SEL(.uaword, .uaxword)
+
 #endif /* _SPARC_ASM_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

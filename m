Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZLKRfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZLKRfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZLKRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:35:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41531 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603AbZLKRfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:35:04 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU interrupt vector duplicated
Cc: mingo@elte.hu
Message-Id: <E1NJ9Pe-0004P7-0Q@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 11 Dec 2009 11:36:18 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Diffed against 2.6.32

Interrupt vector 0xec has been doubly defined in irq_vectors.h

It seems arbitrary whether LOCAL_PENDING_VECTOR or UV_BAU_MESSAGE is
the higher number.  As long as they are unique.
If they are not unique we'll hit a BUG in alloc_system_vector().

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/irq_vectors.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2009-11-13 18:37:52.000000000 -0600
+++ linux/arch/x86/include/asm/irq_vectors.h	2009-11-13 18:38:43.000000000 -0600
@@ -120,7 +120,7 @@
  */
 #define LOCAL_PENDING_VECTOR		0xec
 
-#define UV_BAU_MESSAGE			0xec
+#define UV_BAU_MESSAGE			0xea
 
 /*
  * Self IPI vector for machine checks

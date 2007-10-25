Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXJYMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXJYMwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXJYMwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:52:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34634 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXJYMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:52:21 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2007 18:22:10 +0530
Message-Id: <20071025125210.5417.83795.sendpatchset@balbir-laptop>
Subject: [x86 patch] Fix UML signal.c build error
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/asm-x86/sigcontext.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-x86/sigcontext.h~uml-fix-sigcontext-build-error include/asm-x86/sigcontext.h
--- 2.6.24-rc1/include/asm-x86/sigcontext.h~uml-fix-sigcontext-build-error	2007-10-25 17:21:34.000000000 +0530
+++ 2.6.24-rc1-balbir/include/asm-x86/sigcontext.h	2007-10-25 17:22:09.000000000 +0530
@@ -4,7 +4,7 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-#ifdef __i386__
+#if BITS_PER_LONG == 32
 /*
  * As documented in the iBCS2 standard..
  *
@@ -83,7 +83,7 @@ struct sigcontext {
 	unsigned long cr2;
 };
 
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 /* FXSAVE frame */
 /* Note: reserved1/2 may someday contain valuable data. Always save/restore
@@ -133,6 +133,6 @@ struct sigcontext {
 	unsigned long reserved1[8];
 };
 
-#endif /* !__i386__ */
+#endif /* !BITS_PER_LONG == 32 */
 
 #endif
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

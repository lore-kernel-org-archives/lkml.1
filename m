Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbXJYLe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbXJYLe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbXJYLeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:34:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57413 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXJYLeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:34:50 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2007 17:04:40 +0530
Message-Id: <20071025113440.27531.47204.sendpatchset@balbir-laptop>
Subject: [x86 patch] Fix UML ptrace-abi.h build error
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix the compilation error

arch/um/kernel/sysrq.c: In function 'show_stack':
arch/um/kernel/sysrq.c:63: error: 'UESP' undeclared (first use in this function)
arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
make[1]: *** [arch/um/kernel/sysrq.o] Error 1
make: *** [arch/um/kernel] Error 2

Use BITS_PER_LONG == 32 instead of the hardcode __i386__ as UML depends on
this header.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/asm-x86/ptrace-abi.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/asm-x86/ptrace-abi.h~uml-fix-ptrace-abi-header include/asm-x86/ptrace-abi.h
--- 2.6.24-rc1/include/asm-x86/ptrace-abi.h~uml-fix-ptrace-abi-header	2007-10-25 17:01:47.000000000 +0530
+++ 2.6.24-rc1-balbir/include/asm-x86/ptrace-abi.h	2007-10-25 17:01:47.000000000 +0530
@@ -1,7 +1,9 @@
 #ifndef _ASM_X86_PTRACE_ABI_H
 #define _ASM_X86_PTRACE_ABI_H
 
-#ifdef __i386__
+#include <asm/types.h>
+
+#if BITS_PER_LONG == 32
 
 #define EBX 0
 #define ECX 1
@@ -22,7 +24,7 @@
 #define SS   16
 #define FRAME_SIZE 17
 
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 #if defined(__ASSEMBLY__) || defined(__FRAME_OFFSETS)
 #define R15 0
@@ -55,7 +57,7 @@
 /* top of stack page */
 #define FRAME_SIZE 168
 
-#endif /* !__i386__ */
+#endif /* !BITS_PER_LONG == 32 */
 
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

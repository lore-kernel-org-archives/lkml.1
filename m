Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYLOQzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYLOQzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYLOQza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:55:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:55179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYLOQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:55:29 -0500
Subject: [PATCH] x86: process_64.c declare __switch_to and sys_arch_prctl
	before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 22:23:54 +0530
Message-Id: <1229360034.15326.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

In asm/system.h moved out __switch_to from CONFIG_X86_32 as it is common for both 32 and 64 bit.

In asm/pctl.h defined sys_arch_prctl
---
 arch/x86/include/asm/prctl.h  |    3 +++
 arch/x86/include/asm/system.h |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/prctl.h b/arch/x86/include/asm/prctl.h
index fe68114..a889464 100644
--- a/arch/x86/include/asm/prctl.h
+++ b/arch/x86/include/asm/prctl.h
@@ -6,5 +6,8 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
+#ifdef CONFIG_X86_64
+extern long sys_arch_prctl(int, unsigned long);
+#endif /* CONFIG_X86_64 */
 
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index f2025b0..2f6340a 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -17,12 +17,12 @@
 # define AT_VECTOR_SIZE_ARCH 1
 #endif
 
-#ifdef CONFIG_X86_32
-
 struct task_struct; /* one of the stranger aspects of C forward declarations */
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 
+#ifdef CONFIG_X86_32
+
 /*
  * Saving eflags is important. It switches not only IOPL between tasks,
  * it also protects other tasks from NT leaking through sysenter etc.
-- 
1.5.5.1




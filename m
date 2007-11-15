Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbXKOQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbXKOQmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbXKOQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:41:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836AbXKOQla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:41:30 -0500
Date: Thu, 15 Nov 2007 11:41:22 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151641.lAFGfMm6024339@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86&x86-64 UML support for sys_indirect
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This part adds support for sys_indirect on UML on x86 and x86-64.

 b/arch/um/Makefile                 |    2 +-
 b/include/asm-um/indirect-i386.h   |    6 ++++++
 b/include/asm-um/indirect-x86_64.h |   10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)


--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -20,7 +20,7 @@ core-y			+= $(ARCH_DIR)/kernel/		\
 
 # Have to precede the include because the included Makefiles reference them.
 SYMLINK_HEADERS := archparam.h system.h sigcontext.h processor.h ptrace.h \
-	module.h vm-flags.h elf.h host_ldt.h
+	module.h vm-flags.h elf.h host_ldt.h indirect.h
 SYMLINK_HEADERS := $(foreach header,$(SYMLINK_HEADERS),include/asm-um/$(header))
 
 # XXX: The "os" symlink is only used by arch/um/include/os.h, which includes
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df588f0..ed21ebe 100644
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-um/indirect-i386.h	2007-11-14 22:20:40.000000000 -0800
@@ -0,0 +1,6 @@
+#ifndef __UM_INDIRECT_I386_H
+#define __UM_INDIRECT_I386_H
+
+#include "asm/arch/indirect_32.h"
+
+#endif
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-um/indirect-x86_64.h	2007-11-14 22:20:58.000000000 -0800
@@ -0,0 +1,10 @@
+#ifndef __UM_INDIRECT_X86_64_H
+#define __UM_INDIRECT_X86_64_H
+
+#include "asm/arch/indirect_64.h"
+
+#undef CALL_INDIRECT
+#define CALL_INDIRECT(regs) \
+  CALL_INDIRECT_WMAX(regs, UM_NR_syscall_max)
+
+#endif

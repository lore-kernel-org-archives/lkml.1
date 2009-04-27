Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbZD3Pvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbZD3Pvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbZD3Pmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbZD3PmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:05 -0400
Message-Id: <d1d9af9e0d9f49866aab0245db2860de10661e25.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Apr 2009 17:34:38 +0200
Subject: [PATCH 16/27] asm-generic: introduce generic syscalls.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1/5i9rOWwh0QE5PWfQ+qzuzf1uARs9t4/osbDL
 yAljcTXUhiVPM16l+z2+dCAQgUbGEaJ8yk/EI67DQaSPyIsDa+
 vaAUKrbkLE1NhOXPhsFTg==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic syscalls.h with all common system
calls that can not be declared in linux/syscalls.h
because some architectures have unusual signatures.

All prototypes in here can be overriden by the
architecture but default to the most common variant.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/syscalls.h |   60 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/syscalls.h

diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
new file mode 100644
index 0000000..23c6f6e
--- /dev/null
+++ b/include/asm-generic/syscalls.h
@@ -0,0 +1,60 @@
+#ifndef __ASM_GENERIC_SYSCALLS_H
+#define __ASM_GENERIC_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+
+/*
+ * Calling conventions for these system calls can differ, so
+ * it's possible to override them.
+ */
+#ifndef sys_clone
+asmlinkage long sys_clone(unsigned long clone_flags, unsigned long newsp,
+			void __user *parent_tid, void __user *child_tid,
+			struct pt_regs *regs);
+#endif
+
+#ifndef sys_fork
+asmlinkage long sys_fork(struct pt_regs *regs);
+#endif
+
+#ifndef sys_fork
+asmlinkage long sys_vfork(struct pt_regs *regs);
+#endif
+
+#ifndef sys_execve
+asmlinkage long sys_execve(char __user *filename, char __user * __user *argv,
+			char __user * __user *envp, struct pt_regs *regs);
+#endif
+
+#ifndef sys_mmap2
+asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, unsigned long pgoff);
+#endif
+
+#ifndef sys_mmap
+asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, off_t pgoff);
+#endif
+
+#ifndef sys_sigaltstack
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			struct pt_regs *);
+#endif
+
+#ifndef sys_rt_sigreturn
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);
+#endif
+
+#ifndef sys_rt_sigsuspend
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
+#endif
+
+#ifndef sys_rt_sigaction
+asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
+			 struct sigaction __user *oact, size_t sigsetsize);
+#endif
+
+#endif /* __ASM_GENERIC_SYSCALLS_H */
-- 
1.5.6.3



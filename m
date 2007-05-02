Return-Path: <linux-kernel-owner+w=401wt.eu-S2992738AbXEBFmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992738AbXEBFmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992764AbXEBFl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:41:58 -0400
Received: from haxent.com ([65.99.219.155]:2168 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbXEBFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:44 -0400
Message-Id: <20070502053425.273417000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:41 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 06/22] pollfs: export the plsignal system call
Content-Disposition: inline; filename=pollfs-signal-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export the new plsignal syscall prototype. While there, make it "conditional".

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/syscalls.h |    2 ++
 kernel/sys_ni.c          |    1 +
 2 files changed, 3 insertions(+)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -605,4 +605,6 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_plsignal(const sigset_t __user * set);
+
 #endif
Index: linux-2.6/kernel/sys_ni.c
===================================================================
--- linux-2.6.orig/kernel/sys_ni.c
+++ linux-2.6/kernel/sys_ni.c
@@ -112,6 +112,7 @@ cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
+cond_syscall(sys_plsignal);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);

--

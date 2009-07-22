Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZGVJJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZGVJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZGVJJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:09:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZGVJJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:09:26 -0400
Date: Wed, 22 Jul 2009 05:08:33 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu,
       Al Viro <viro@zeniv.linux.org.uk>, Amerigo Wang <amwang@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-Id: <20090722091051.6621.15184.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] ia32: use generic sys_pipe()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested by Al, it's better to use the generic sys_pipe() for
ia32.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>

---
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e590261..ba331bf 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -537,7 +537,7 @@ ia32_sys_call_table:
 	.quad sys_mkdir
 	.quad sys_rmdir		/* 40 */
 	.quad sys_dup
-	.quad sys32_pipe
+	.quad sys_pipe
 	.quad compat_sys_times
 	.quad quiet_ni_syscall			/* old prof syscall holder */
 	.quad sys_brk		/* 45 */
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 085a8c3..9f55271 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -189,20 +189,6 @@ asmlinkage long sys32_mprotect(unsigned long start, size_t len,
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_pipe(int __user *fd)
-{
-	int retval;
-	int fds[2];
-
-	retval = do_pipe_flags(fds, 0);
-	if (retval)
-		goto out;
-	if (copy_to_user(fd, fds, sizeof(fds)))
-		retval = -EFAULT;
-out:
-	return retval;
-}
-
 asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
 				   struct sigaction32 __user *oact,
 				   unsigned int sigsetsize)

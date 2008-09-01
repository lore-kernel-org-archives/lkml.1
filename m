Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbYIABje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbYIABje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 21:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYIABjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 21:39:25 -0400
Received: from verein.lst.de ([213.95.11.210]:43953 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYIABjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 21:39:24 -0400
Date: Mon, 1 Sep 2008 03:39:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kill sys32_pause
Message-ID: <20080901013924.GA7947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's just a duplicate of the native sys_pause.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2008-08-22 12:48:34.000000000 -0300
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2008-08-22 12:48:40.000000000 -0300
@@ -556,15 +556,6 @@ asmlinkage long sys32_rt_sigqueueinfo(in
 	return ret;
 }
 
-/* These are here just in case some old ia32 binary calls it. */
-asmlinkage long sys32_pause(void)
-{
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	return -ERESTARTNOHAND;
-}
-
-
 #ifdef CONFIG_SYSCTL_SYSCALL
 struct sysctl_ia32 {
 	unsigned int	name;
Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2008-08-22 12:49:25.000000000 -0300
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2008-08-22 12:49:29.000000000 -0300
@@ -202,7 +202,7 @@ ia32_syscall_table:
 	data8 sys32_ptrace
 	data8 sys32_alarm
 	data8 sys_ni_syscall
-	data8 sys32_pause
+	data8 sys_pause
 	data8 compat_sys_utime	  /* 30 */
 	data8 sys_ni_syscall	  /* old stty syscall holder */
 	data8 sys_ni_syscall	  /* old gtty syscall holder */
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2008-08-22 12:49:33.000000000 -0300
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2008-08-22 12:49:37.000000000 -0300
@@ -1795,14 +1795,6 @@ out:
 }
 
 asmlinkage int
-sys32_pause (void)
-{
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	return -ERESTARTNOHAND;
-}
-
-asmlinkage int
 sys32_msync (unsigned int start, unsigned int len, int flags)
 {
 	unsigned int addr;

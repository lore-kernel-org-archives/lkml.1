Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYHUDDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYHUDDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYHUDDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:03:46 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:44819 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYHUDDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:03:45 -0400
Date: Wed, 20 Aug 2008 23:03:37 -0400 (EDT)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: dave@linux.vnet.ibm.com
cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: [RFC v2][PATCH 1/9] Create trivial sys_checkpoint/sys_restart syscalls
In-Reply-To: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
Message-ID: <Pine.LNX.4.64.0808202302510.17436@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Create trivial sys_checkpoint and sys_restore system calls. They will
enable to checkpoint and restart an entire container, to and from a
checkpoint image file.

First create a template for both syscalls: they take a file descriptor
(for the image file) and flags as arguments. For sys_checkpoint the
first argument identifies the target container; for sys_restart it will
identify the checkpoint image.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
  arch/x86/kernel/syscall_table_32.S |    2 ++
  include/asm-x86/unistd_32.h        |    2 ++
  include/linux/syscalls.h           |    2 ++
  3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d44395f..5543136 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,5 @@ ENTRY(sys_call_table)
  	.long sys_dup3			/* 330 */
  	.long sys_pipe2
  	.long sys_inotify_init1
+	.long sys_checkpoint
+	.long sys_restart
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index d739467..88bdec4 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -338,6 +338,8 @@
  #define __NR_dup3		330
  #define __NR_pipe2		331
  #define __NR_inotify_init1	332
+#define __NR_checkpoint		333
+#define __NR_restart		334

  #ifdef __KERNEL__

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d6ff145..edc218b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -622,6 +622,8 @@ asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
  asmlinkage long sys_eventfd(unsigned int count);
  asmlinkage long sys_eventfd2(unsigned int count, int flags);
  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags);
+asmlinkage long sys_restart(int crid, int fd, unsigned long flags);

  int kernel_execve(const char *filename, char *const argv[], char *const envp[]);

-- 
1.5.4.3


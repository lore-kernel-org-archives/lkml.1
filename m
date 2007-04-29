Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXD2LFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXD2LFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXD2LAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:51339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbXD2Kxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:32 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [41/48] x86: sys_ioperm() prototype cleanup
Message-Id: <20070429105331.7972815108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>
- there's no reason for duplicating the prototype from 
  include/linux/syscalls.h in include/asm-x86_64/unistd.h
- every file should #include the headers containing the prototypes for
  it's global functions

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/ioport.c   |    1 +
 arch/x86_64/kernel/ioport.c |    1 +
 include/asm-x86_64/unistd.h |    1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

Index: linux/include/asm-x86_64/unistd.h
===================================================================
--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -655,7 +655,6 @@ __SYSCALL(__NR_move_pages, sys_move_page
 #include <asm/ptrace.h>
 
 asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs);
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on);
 struct sigaction;
 asmlinkage long sys_rt_sigaction(int sig,
 				const struct sigaction __user *act,
Index: linux/arch/i386/kernel/ioport.c
===================================================================
--- linux.orig/arch/i386/kernel/ioport.c
+++ linux/arch/i386/kernel/ioport.c
@@ -16,6 +16,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
+#include <linux/syscalls.h>
 
 /* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
 static void set_bitmap(unsigned long *bitmap, unsigned int base, unsigned int extent, int new_value)
Index: linux/arch/x86_64/kernel/ioport.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ioport.c
+++ linux/arch/x86_64/kernel/ioport.c
@@ -16,6 +16,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
+#include <linux/syscalls.h>
 
 /* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
 static void set_bitmap(unsigned long *bitmap, unsigned int base, unsigned int extent, int new_value)

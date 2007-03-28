Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXC1MLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXC1MLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXC1MLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:11:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36835 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbXC1MLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:11:05 -0400
Date: Wed, 28 Mar 2007 14:11:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org, ak@suse.de
Cc: discuss@x86-64.org
Subject: [2.6 patch] i386/x86_64: sys_ioperm() prototype cleanup
Message-ID: <20070328121101.GN16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- there's no reason for duplicating the prototype from 
  include/linux/syscalls.h in include/asm-x86_64/unistd.h
- every file should #include the headers containing the prototypes for
  it's global functions

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/ioport.c   |    1 +
 arch/x86_64/kernel/ioport.c |    1 +
 include/asm-x86_64/unistd.h |    1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1/include/asm-x86_64/unistd.h.old	2007-03-26 15:45:56.000000000 +0200
+++ linux-2.6.21-rc4-mm1/include/asm-x86_64/unistd.h	2007-03-26 15:46:05.000000000 +0200
@@ -655,7 +655,6 @@
 #include <asm/ptrace.h>
 
 asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs);
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on);
 struct sigaction;
 asmlinkage long sys_rt_sigaction(int sig,
 				const struct sigaction __user *act,
--- linux-2.6.21-rc4-mm1/arch/i386/kernel/ioport.c.old	2007-03-26 15:44:17.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/ioport.c	2007-03-26 15:44:39.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
+#include <linux/syscalls.h>
 
 /* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
 static void set_bitmap(unsigned long *bitmap, unsigned int base, unsigned int extent, int new_value)
--- linux-2.6.21-rc4-mm1/arch/x86_64/kernel/ioport.c.old	2007-03-26 15:43:45.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/x86_64/kernel/ioport.c	2007-03-26 15:44:01.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
+#include <linux/syscalls.h>
 
 /* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
 static void set_bitmap(unsigned long *bitmap, unsigned int base, unsigned int extent, int new_value)


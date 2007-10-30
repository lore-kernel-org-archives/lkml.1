Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbXJ3R3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbXJ3R3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXJ3R3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:29:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43044 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXJ3R3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:29:34 -0400
Date: Tue, 30 Oct 2007 13:28:50 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - get rid of asmlinkage
Message-ID: <20071030172850.GA8372@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of asmlinkage and remove some old cruft from asm/linkage.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/tls.c   |    9 +++++----
 include/asm-um/linkage.h |    7 -------
 2 files changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/tls.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/tls.c	2007-10-18 23:39:13.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/tls.c	2007-10-22 11:28:26.000000000 -0400
@@ -225,7 +225,8 @@ out:
 }
 
 /* XXX: use do_get_thread_area to read the host value? I'm not at all sure! */
-static int get_tls_entry(struct task_struct* task, struct user_desc *info, int idx)
+static int get_tls_entry(struct task_struct* task, struct user_desc *info,
+			 int idx)
 {
 	struct thread_struct *t = &task->thread;
 
@@ -263,7 +264,7 @@ clear:
 	goto out;
 }
 
-asmlinkage int sys_set_thread_area(struct user_desc __user *user_desc)
+int sys_set_thread_area(struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
@@ -298,7 +299,7 @@ asmlinkage int sys_set_thread_area(struc
  * i386. However the only possible error are caused by bugs.
  */
 int ptrace_set_thread_area(struct task_struct *child, int idx,
-		struct user_desc __user *user_desc)
+			   struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 
@@ -311,7 +312,7 @@ int ptrace_set_thread_area(struct task_s
 	return set_tls_entry(child, &info, idx, 0);
 }
 
-asmlinkage int sys_get_thread_area(struct user_desc __user *user_desc)
+int sys_get_thread_area(struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
Index: linux-2.6.22/include/asm-um/linkage.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/linkage.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/linkage.h	2007-10-22 11:32:11.000000000 -0400
@@ -3,11 +3,4 @@
 
 #include "asm/arch/linkage.h"
 
-
-/* <linux/linkage.h> will pick sane defaults */
-#ifdef CONFIG_GPROF
-#undef FASTCALL
-#undef fastcall
-#endif
-
 #endif

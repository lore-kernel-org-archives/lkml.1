Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXJ2EgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXJ2EgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXJ2EgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:36:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58400 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXJ2EgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:36:13 -0400
Date: Mon, 29 Oct 2007 04:36:10 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] misc uml annotation and section fixes
Message-ID: <20071029043610.GY8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 8456397..59822de 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -165,7 +165,7 @@ static void __init kmap_init(void)
 	kmap_prot = PAGE_KERNEL;
 }
 
-static void init_highmem(void)
+static void __init init_highmem(void)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-i386/ptrace.c
index 9657c89..bd3da8a 100644
--- a/arch/um/sys-i386/ptrace.c
+++ b/arch/um/sys-i386/ptrace.c
@@ -155,7 +155,7 @@ int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	if (err)
 		return err;
 
-	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	n = copy_to_user(buf, fpregs, sizeof(fpregs));
 	if(n > 0)
 		return -EFAULT;
 
@@ -168,7 +168,7 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	long fpregs[HOST_FP_SIZE];
 
 	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	n = copy_from_user(fpregs, buf, sizeof(fpregs));
 	if (n > 0)
 		return -EFAULT;
 
@@ -185,7 +185,7 @@ int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 	if (err)
 		return err;
 
-	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	n = copy_to_user(buf, fpregs, sizeof(fpregs));
 	if(n > 0)
 		return -EFAULT;
 
@@ -198,7 +198,7 @@ int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 	long fpregs[HOST_XFP_SIZE];
 
 	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	n = copy_from_user(fpregs, buf, sizeof(fpregs));
 	if (n > 0)
 		return -EFAULT;
 
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index a3cfeed..b7631b0 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -154,7 +154,7 @@ int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	if (err)
 		return err;
 
-	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	n = copy_to_user(buf, fpregs, sizeof(fpregs));
 	if(n > 0)
 		return -EFAULT;
 
@@ -167,7 +167,7 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	long fpregs[HOST_FP_SIZE];
 
 	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	n = copy_from_user(fpregs, buf, sizeof(fpregs));
 	if (n > 0)
 		return -EFAULT;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765134AbYEIMqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765134AbYEIMqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbYEIMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:44:26 -0400
Received: from verein.lst.de ([213.95.11.210]:39484 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbYEIMoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:44:25 -0400
Date: Fri, 9 May 2008 14:44:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hirokazu Takata <takata@linux-m32r.org>, torvalds@osdl.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m32r: use generic sys_pipe
Message-ID: <20080509124402.GA14406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m32r can use the generic sys_pipe implementation.

The current sys_pipe implementation on m32r only differes from the
generic one by passing a lot of additional unused registers to sys_pipe.

Reviewed and tested by Hirokazu Takata.

Index: linux-2.6/arch/m32r/kernel/sys_m32r.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/sys_m32r.c	2008-05-09 12:44:10.000000000 +0200
+++ linux-2.6/arch/m32r/kernel/sys_m32r.c	2008-05-09 12:44:16.000000000 +0200
@@ -76,29 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-/*
- * sys_pipe() is the normal C calling standard for creating
- * a pipe. It's not the way Unix traditionally does this, though.
- */
-asmlinkage int
-sys_pipe(unsigned long r0, unsigned long r1, unsigned long r2,
-	unsigned long r3, unsigned long r4, unsigned long r5,
-	unsigned long r6, struct pt_regs regs)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int))) {
-			sys_close(fd[0]);
-			sys_close(fd[1]);
-			error = -EFAULT;
-		}
-	}
-	return error;
-}
-
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	unsigned long prot, unsigned long flags,
 	unsigned long fd, unsigned long pgoff)

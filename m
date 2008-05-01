Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbYEAQnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbYEAQnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbYEAQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:43:36 -0400
Received: from verein.lst.de ([213.95.11.210]:37997 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYEAQnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:43:35 -0400
Date: Thu, 1 May 2008 18:43:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] make generic sys_ptrace unconditional
Message-ID: <20080501164311.GA14628@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With s390 the last arch switched to the generic sys_ptrace yesterday so
we can now kill the ifdef around it to enforce every new port it using
it instead of introducing new weirdo versions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/kernel/ptrace.c	2008-04-30 14:04:33.000000000 +0200
+++ linux-2.6/kernel/ptrace.c	2008-04-30 14:10:46.000000000 +0200
@@ -543,7 +543,6 @@ struct task_struct *ptrace_get_task_stru
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
-#ifndef __ARCH_SYS_PTRACE
 asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 {
 	struct task_struct *child;
@@ -591,7 +590,6 @@ asmlinkage long sys_ptrace(long request,
 	unlock_kernel();
 	return ret;
 }
-#endif /* __ARCH_SYS_PTRACE */
 
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
 {

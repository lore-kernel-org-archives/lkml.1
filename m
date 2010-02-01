Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0BATTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:19:19 -0500
Received: from verein.lst.de ([213.95.11.210]:39474 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0BATTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:19:18 -0500
Date: Mon, 1 Feb 2010 20:18:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com
Cc: akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]: mark ptrace_traceme static
Message-ID: <20100201191855.GA11874@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used outside of ptrace.c, so no need to allow access to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/ptrace.h
===================================================================
--- linux-2.6.orig/include/linux/ptrace.h	2010-01-26 18:02:46.745004926 +0100
+++ linux-2.6/include/linux/ptrace.h	2010-01-26 18:02:51.759268161 +0100
@@ -81,7 +81,6 @@
 
 
 extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
-extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern int ptrace_attach(struct task_struct *tsk);
Index: linux-2.6/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/kernel/ptrace.c	2010-01-26 18:02:55.627012005 +0100
+++ linux-2.6/kernel/ptrace.c	2010-01-26 18:04:22.163015407 +0100
@@ -220,7 +220,7 @@ out:
  * Performs checks and sets PT_PTRACED.
  * Should be used by all ptrace implementations for PTRACE_TRACEME.
  */
-int ptrace_traceme(void)
+static int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 

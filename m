Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYIAQPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYIAQPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYIAQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:14:52 -0400
Received: from verein.lst.de ([213.95.11.210]:59862 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYIAQOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:14:52 -0400
Date: Mon, 1 Sep 2008 18:14:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kill sys32_pause
Message-ID: <20080901161451.GA16121@lst.de>
References: <20080901013924.GA7947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901013924.GA7947@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's an unused duplicate of the generic sys_pause.

(now without the b0rked ia64 bits, sorry)


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

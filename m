Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXDBQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXDBQyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964932AbXDBQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:54:34 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40625 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbXDBQyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:54:18 -0400
Date: Mon, 2 Apr 2007 12:50:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, devzero@web.de
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - kernel_thread shouldn't panic
Message-ID: <20070402165012.GA7626@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_thread should just return an error value on do_fork failure, not panic.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/process.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-04-02 11:51:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-04-02 12:01:00.000000000 -0400
@@ -97,8 +97,6 @@ int kernel_thread(int (*fn)(void *), voi
 	current->thread.request.u.thread.arg = arg;
 	pid = do_fork(CLONE_VM | CLONE_UNTRACED | flags, 0,
 		      &current->thread.regs, 0, NULL, NULL);
-	if(pid < 0)
-		panic("do_fork failed in kernel_thread, errno = %d", pid);
 	return pid;
 }
 

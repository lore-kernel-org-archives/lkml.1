Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXDMH2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXDMH2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXDMH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:28:32 -0400
Received: from mail.screens.ru ([213.234.233.54]:55671 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXDMH2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:28:31 -0400
Date: Fri, 13 Apr 2007 11:28:23 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_for_helper: remove unneeded do_sigaction()
Message-ID: <20070413072823.GA1514@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

allow_signal(SIGCHLD) does all necessary job, no need to call do_sigaction()
prior to.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/kmod.c~WH	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/kernel/kmod.c	2007-04-13 11:14:00.000000000 +0400
@@ -181,14 +181,9 @@ static int wait_for_helper(void *data)
 {
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
-	struct k_sigaction sa;
 
 	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
 	 * populate the status, but will return -ECHILD. */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, NULL);
 	allow_signal(SIGCHLD);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1161619AbXDYGmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161619AbXDYGmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161621AbXDYGmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:42:54 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:38817 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161619AbXDYGmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:42:53 -0400
Subject: [PATCH]:Replacing current->state with set_current_state in
	kernel/signal.c
From: Shani Moideen <shani.moideen@wipro.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Wed, 25 Apr 2007 12:08:58 +0530
Message-Id: <1177483138.27118.25.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 25 Apr 2007 06:42:51.0367 (UTC) FILETIME=[F2096770:01C78704]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Replacing current->state with set_current_state in kernel/signal.c
	

thanks.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----


diff --git a/kernel/signal.c b/kernel/signal.c
index 3670225..44e2cf3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2596,7 +2596,7 @@ sys_signal(int sig, __sighandler_t handler)
 asmlinkage long
 sys_pause(void)
 {
-       current->state = TASK_INTERRUPTIBLE;
+       set_current_state(TASK_INTERRUPTIBLE);
        schedule();
        return -ERESTARTNOHAND;
 }
@@ -2622,7 +2622,7 @@ asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize)
        recalc_sigpending();
        spin_unlock_irq(&current->sighand->siglock);

-       current->state = TASK_INTERRUPTIBLE;
+       set_current_state(TASK_INTERRUPTIBLE);
        schedule();
        set_thread_flag(TIF_RESTORE_SIGMASK);
        return -ERESTARTNOHAND;

-- 
Shani 

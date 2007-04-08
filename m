Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbXDHSRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbXDHSRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXDHSRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:17:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:50716 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbXDHSR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:17:28 -0400
Date: Sun, 8 Apr 2007 22:17:23 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] zap_other_threads: remove unneeded ->exit_signal change
Message-ID: <20070408181723.GA307@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already depend on fact that all sub-threads have ->exit_signal == -1,
no need to set it in zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5-mm4/kernel/signal.c~zat	2007-04-07 20:11:14.000000000 +0400
+++ 2.6.21-rc5-mm4/kernel/signal.c	2007-04-08 22:09:20.000000000 +0400
@@ -1163,17 +1163,6 @@ void zap_other_threads(struct task_struc
 		if (t->exit_state)
 			continue;
 
-		/*
-		 * We don't want to notify the parent, since we are
-		 * killed as part of a thread group due to another
-		 * thread doing an execve() or similar. So set the
-		 * exit signal to -1 to allow immediate reaping of
-		 * the process.  But don't detach the thread group
-		 * leader.
-		 */
-		if (t != p->group_leader)
-			t->exit_signal = -1;
-
 		/* SIGKILL will be handled before any pending SIGSTOP */
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);


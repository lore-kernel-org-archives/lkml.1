Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbYCCETc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbYCCETc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760463AbYCCESp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:18:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39567 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbYCCESo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:18:44 -0500
Date: Mon, 3 Mar 2008 07:17:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] document de_thread() with exit_notify() connection
Message-ID: <20080303041755.GA18920@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple of small comments, it is not easy to see what this code does.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/fs/exec.c~7_DOC_EXIT_EXEC	2008-02-17 23:40:07.000000000 +0300
+++ 25/fs/exec.c	2008-03-03 06:54:31.000000000 +0300
@@ -802,7 +802,7 @@ static int de_thread(struct task_struct 
 	if (!thread_group_leader(tsk)) {
 		leader = tsk->group_leader;
 
-		sig->notify_count = -1;
+		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
--- 25/kernel/exit.c~7_DOC_EXIT_EXEC	2008-03-03 06:46:00.000000000 +0300
+++ 25/kernel/exit.c	2008-03-03 07:07:17.000000000 +0300
@@ -808,6 +808,7 @@ static void exit_notify(struct task_stru
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
+	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
 	    tsk->signal->notify_count < 0 &&
 	    tsk->signal->group_exit_task)


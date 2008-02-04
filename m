Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYBDVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYBDVAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYBDVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:00:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47482 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753897AbYBDVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:00:19 -0500
Date: Mon, 4 Feb 2008 22:00:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: small cleanups
Message-ID: <20080204210032.GA1662@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are small cleanups all over the tree. Please apply,

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/fs/select.c b/fs/select.c
index 47f4792..c414aed 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -260,7 +260,7 @@ int do_select(int n, fd_set_bits *fds, s
 		wait = NULL;
 		if (retval || !*timeout || signal_pending(current))
 			break;
-		if(table.error) {
+		if (table.error) {
 			retval = table.error;
 			break;
 		}
diff --git a/kernel/signal.c b/kernel/signal.c
index 4333b6d..107618c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -220,7 +220,7 @@ void flush_signals(struct task_struct *t
 	unsigned long flags;
 
 	spin_lock_irqsave(&t->sighand->siglock, flags);
-	clear_tsk_thread_flag(t,TIF_SIGPENDING);
+	clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	flush_sigqueue(&t->pending);
 	flush_sigqueue(&t->signal->shared_pending);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
@@ -424,7 +424,7 @@ int dequeue_signal(struct task_struct *t
 	}
 	if (signr &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
-	     info->si_sys_private){
+	     info->si_sys_private) {
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 51b5ee5..b376190 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,8 +136,7 @@ static void restart_machine(void)
 	preempt_enable_no_resched();
 }
 
-struct stop_machine_data
-{
+struct stop_machine_data {
 	int (*fn)(void *);
 	void *data;
 	struct completion done;
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 8f6ee07..3931f71 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -17,8 +17,8 @@ #include <linux/spinlock.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/fs.h>		// Needed by writeback.h
-#include <linux/writeback.h>	// Prototypes pdflush_operation()
+#include <linux/fs.h>		/* Needed by writeback.h	  */
+#include <linux/writeback.h>	/* Prototypes pdflush_operation() */
 #include <linux/kthread.h>
 #include <linux/cpuset.h>
 #include <linux/freezer.h>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

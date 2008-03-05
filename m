Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbYCEVyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbYCEVyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbYCEVyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:54:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56574 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbYCEVyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:54:11 -0500
Date: Thu, 6 Mar 2008 00:53:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] send_sigqueue: don't take rcu lock
Message-ID: <20080305215313.GA3818@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on lock_task_sighand-add-rcu-lock-unlock.patch)

lock_task_sighand() was changed, send_sigqueue() doesn't need rcu_read_lock()
any longer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~1_SS_NO_RCU	2008-03-06 00:31:08.000000000 +0300
+++ 25/kernel/signal.c	2008-03-06 00:35:35.000000000 +0300
@@ -1311,8 +1311,6 @@ int send_sigqueue(int sig, struct sigque
 	 * We return -1, when the task is marked exiting, so
 	 * posix_timer_event can redirect it to the group leader
 	 */
-	rcu_read_lock();
-
 	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
 
@@ -1323,8 +1321,6 @@ int send_sigqueue(int sig, struct sigque
 
 	unlock_task_sighand(p, &flags);
 out_err:
-	rcu_read_unlock();
-
 	return ret;
 }
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbYHXPpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbYHXPpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHXPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:45:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60257 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYHXPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:45:22 -0400
Date: Sun, 24 Aug 2008 19:49:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pid_ns: de_thread: kill the now unneeded ->child_reaper change
Message-ID: <20080824154912.GA3783@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() checks if the old leader was the ->child_reaper, this is not
possible any longer. With the previous patch ->group_leader itself will
change ->child_reaper on exit.

>From now find_new_reaper() is the only function (apart from initialization)
which plays with ->child_reaper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.27-rc4/fs/exec.c~3_EXEC	2008-07-30 13:12:47.000000000 +0400
+++ 2.6.27-rc4/fs/exec.c	2008-08-24 19:20:05.000000000 +0400
@@ -825,8 +825,6 @@ static int de_thread(struct task_struct 
 			schedule();
 		}
 
-		if (unlikely(task_child_reaper(tsk) == leader))
-			task_active_pid_ns(tsk)->child_reaper = tsk;
 		/*
 		 * The only record we have of the real-time age of a
 		 * process, regardless of execs it's done, is start_time.


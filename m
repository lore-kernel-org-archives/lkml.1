Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYCTPX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYCTPX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYCTPXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:23:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36862 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYCTPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:23:47 -0400
Date: Thu, 20 Mar 2008 18:28:18 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pids: __set_special_pids: use change_pid() helper
Message-ID: <20080320152818.GA6341@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use change_pid() instead of detach_pid() + attach_pid() in __set_special_pids()

This way task_session() is not NULL in between.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~4_SETSID	2008-03-16 19:41:42.000000000 +0300
+++ 25/kernel/exit.c	2008-03-20 18:25:11.000000000 +0300
@@ -334,13 +334,11 @@ void __set_special_pids(struct pid *pid)
 	pid_t nr = pid_nr(pid);
 
 	if (task_session(curr) != pid) {
-		detach_pid(curr, PIDTYPE_SID);
-		attach_pid(curr, PIDTYPE_SID, pid);
+		change_pid(curr, PIDTYPE_SID, pid);
 		set_task_session(curr, nr);
 	}
 	if (task_pgrp(curr) != pid) {
-		detach_pid(curr, PIDTYPE_PGID);
-		attach_pid(curr, PIDTYPE_PGID, pid);
+		change_pid(curr, PIDTYPE_PGID, pid);
 		set_task_pgrp(curr, nr);
 	}
 }


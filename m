Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYCTPYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYCTPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYCTPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:23:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36867 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504AbYCTPXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:23:51 -0400
Date: Thu, 20 Mar 2008 18:28:18 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pids: sys_setpgid: use change_pid() helper
Message-ID: <20080320152818.GA6338@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use change_pid() instead of detach_pid() + attach_pid() in sys_setpgid().

This way task_pgrp() is not NULL in between.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/sys.c~3_SETPGRP	2008-02-18 19:15:40.000000000 +0300
+++ 25/kernel/sys.c	2008-03-20 18:21:17.000000000 +0300
@@ -972,8 +972,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		goto out;
 
 	if (task_pgrp(p) != pgrp) {
-		detach_pid(p, PIDTYPE_PGID);
-		attach_pid(p, PIDTYPE_PGID, pgrp);
+		change_pid(p, PIDTYPE_PGID, pgrp);
 		set_task_pgrp(p, pid_nr(pgrp));
 	}
 


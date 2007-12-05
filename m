Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbXLESgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbXLESgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXLESgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:36:37 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46464 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLESgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:36:36 -0500
Date: Wed, 5 Dec 2007 21:37:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] sys_setsid: remove now unneeded session != 1 check
Message-ID: <20071205183722.GA6139@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric's "fix clone(CLONE_NEWPID)" eliminated the last reason for this hack.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/sys.c~	2007-11-27 16:58:38.000000000 +0300
+++ PT/kernel/sys.c	2007-12-05 21:31:53.000000000 +0300
@@ -1056,11 +1056,8 @@ asmlinkage long sys_setsid(void)
 
 	/* Fail if a process group id already exists that equals the
 	 * proposed session id.
-	 *
-	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
-	 * this group/session beforehand.
 	 */
-	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
+	if (pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYHXPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYHXPpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYHXPpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:45:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60259 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYHXPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:45:22 -0400
Date: Sun, 24 Aug 2008 19:49:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] pid_ns: kill the now unused task_child_reaper()
Message-ID: <20080824154913.GA3786@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_child_reaper() has no callers anymore, kill it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.27-rc4/include/linux/pid_namespace.h~4_KILL_HELPER	2008-07-30 13:12:48.000000000 +0400
+++ 2.6.27-rc4/include/linux/pid_namespace.h	2008-08-24 19:33:12.000000000 +0400
@@ -84,12 +84,6 @@ static inline struct pid_namespace *task
 	return tsk->nsproxy->pid_ns;
 }
 
-static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
-{
-	BUG_ON(tsk != current);
-	return tsk->nsproxy->pid_ns->child_reaper;
-}
-
 void pidhash_init(void);
 void pidmap_init(void);
 


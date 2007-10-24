Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbXJXQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbXJXQcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbXJXQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33378 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759309AbXJXQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:44 -0400
Date: Wed, 24 Oct 2007 18:24:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport find_task_by_*
Message-ID: <20071024162414.GF30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- find_task_by_pid_type_ns
- find_task_by_vpid
- find_task_by_pid_ns

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/pid.c |    4 ----
 1 file changed, 4 deletions(-)

65b4847eb3d64c037d8b418d7560b71a3065d304 
diff --git a/kernel/pid.c b/kernel/pid.c
index d1db36b..b09d7c9 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -378,8 +378,6 @@ struct task_struct *find_task_by_pid_type_ns(int type, int nr,
 	return pid_task(find_pid_ns(nr, ns), type);
 }
 
-EXPORT_SYMBOL(find_task_by_pid_type_ns);
-
 struct task_struct *find_task_by_pid(pid_t nr)
 {
 	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
@@ -391,13 +389,11 @@ struct task_struct *find_task_by_vpid(pid_t vnr)
 	return find_task_by_pid_type_ns(PIDTYPE_PID, vnr,
 			current->nsproxy->pid_ns);
 }
-EXPORT_SYMBOL(find_task_by_vpid);
 
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
 	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, ns);
 }
-EXPORT_SYMBOL(find_task_by_pid_ns);
 
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {


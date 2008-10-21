Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYJUTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYJUTTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYJUTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:19:45 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:54596 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYJUTTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:19:45 -0400
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2008 15:19:44 EDT
From: henrik@austad.us
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Henrik Austad <henrik.austad@gmail.com>
Subject: sched: add CONFIG_SMP consistency
Date: Tue, 21 Oct 2008 20:45:19 +0200
Message-Id: <1224614719-14452-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <henrik.austad@gmail.com>

Do not declare select_task_rq as part of sched_class when CONFIG_SMP is
not set.

Signed-off-by: Henrik Austad <henrik.austad@gmail.com>
---
 include/linux/sched.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c226c7b..9e0e33c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -898,8 +898,9 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
+#ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sync);
-
+#endif
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
-- 
1.6.0.1


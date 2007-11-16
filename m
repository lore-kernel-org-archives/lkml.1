Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXKPRhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXKPRhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762704AbXKPRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:37:00 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54620 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762653AbXKPRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:36:59 -0500
Message-Id: <20071116173523.729879270@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 02:34:40 +0900
From: penguin-kernel@I-love.SAKURA.ne.jp
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #5 01/18] Add struct vfsmount to struct task_struct.
Content-Disposition: inline; filename=add-struct-vfsmount-to-struct-task_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows VFS wrapper functions associate "struct vfsmount"
with "struct task_struct" so that LSM hooks can calculate
pathname of given "struct dentry".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    2 ++
 2 files changed, 3 insertions(+)

--- linux-2.6-mm.orig/include/linux/init_task.h	2007-11-14 15:12:03.000000000 +0900
+++ linux-2.6-mm/include/linux/init_task.h	2007-11-14 15:15:33.000000000 +0900
@@ -173,6 +173,7 @@ extern struct group_info init_groups;
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	.last_vfsmount  = NULL,                                         \
 }
 
 
--- linux-2.6-mm.orig/include/linux/sched.h	2007-11-14 15:14:35.000000000 +0900
+++ linux-2.6-mm/include/linux/sched.h	2007-11-14 15:15:33.000000000 +0900
@@ -1191,6 +1191,8 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+	/* vfsmount info for LSM hooks. */
+	struct vfsmount *last_vfsmount;
 };
 
 /*

-- 

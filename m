Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYAIAz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYAIAz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYAIAy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:54:29 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51860 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYAIAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:54:21 -0500
Message-Id: <20080109005418.469053691@nttdata.co.jp>
References: <20080109005320.323184643@nttdata.co.jp>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 09:53:22 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #6 retry 02/21] Add struct vfsmount to struct task_struct.
X-OriginalArrivalTime: 09 Jan 2008 00:54:19.0115 (UTC) FILETIME=[2A5A3BB0:01C8525A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows VFS wrapper functions associate "struct vfsmount"
with "struct task_struct" so that LSM hooks can calculate
pathname of given "struct dentry".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    2 ++
 2 files changed, 3 insertions(+)

--- linux-2.6-mm.orig/include/linux/init_task.h
+++ linux-2.6-mm/include/linux/init_task.h
@@ -187,6 +187,7 @@ extern struct group_info init_groups;
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	.last_vfsmount  = NULL,                                         \
 }
 
 
--- linux-2.6-mm.orig/include/linux/sched.h
+++ linux-2.6-mm/include/linux/sched.h
@@ -1238,6 +1238,8 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+	/* vfsmount info for LSM hooks. */
+	struct vfsmount *last_vfsmount;
 };
 
 /*

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYJFB1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYJFB1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJFB12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:27:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYJFB12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:27:28 -0400
Message-ID: <48E96964.9060606@cn.fujitsu.com>
Date: Mon, 06 Oct 2008 09:27:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: remove redundant code in cpu_cgroup_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css will be initialized by cgroup core.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..5fa8560 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8991,7 +8991,6 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
-		init_task_group.css.cgroup = cgrp;
 		return &init_task_group.css;
 	}
 
@@ -9000,9 +8999,6 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	if (IS_ERR(tg))
 		return ERR_PTR(-ENOMEM);
 
-	/* Bind the cgroup to task_group object we just created */
-	tg->css.cgroup = cgrp;
-
 	return &tg->css;
 }
 
-- 
1.5.4.rc3


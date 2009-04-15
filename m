Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZDOCxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZDOCxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZDOCxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:53:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZDOCxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:53:02 -0400
Message-ID: <49E54B2A.9060100@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 10:49:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix off-by-one bug in balance_tasks()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the load that need be moved equals the half weight of a task, I think
it is unnecessary to move this task. Or this task will be moved back and
forth.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..44926c8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3085,7 +3085,7 @@ next:
 	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
 
-	if ((p->se.load.weight >> 1) > rem_load_move ||
+	if ((p->se.load.weight >> 1) >= rem_load_move ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
 		p = iterator->next(iterator->arg);
 		goto next;
-- 
1.6.0.3



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZJAHrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZJAHrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbZJAHrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:47:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:51908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbZJAHre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:47:34 -0400
Date: Thu, 1 Oct 2009 07:47:14 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4ABC5AF9.6060808@cn.fujitsu.com>
References: <4ABC5AF9.6060808@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Clean up perf_event_init_task()
Message-ID: <tip-27f9994c50e95f3a5a81fe4c7491a9f9cffe6ec0@git.kernel.org>
Git-Commit-ID: 27f9994c50e95f3a5a81fe4c7491a9f9cffe6ec0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 07:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f9994c50e95f3a5a81fe4c7491a9f9cffe6ec0
Gitweb:     http://git.kernel.org/tip/27f9994c50e95f3a5a81fe4c7491a9f9cffe6ec0
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Fri, 25 Sep 2009 13:54:01 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 09:30:44 +0200

perf_event: Clean up perf_event_init_task()

While at it: we can traverse ctx->group_list to get all
group leader, it should be safe since we hold ctx->mutex.

Changlog v1->v2:

  - remove WARN_ON_ONCE() according to Peter Zijlstra's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4ABC5AF9.6060808@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_event.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e50543d..e491fb0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4767,9 +4767,7 @@ int perf_event_init_task(struct task_struct *child)
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
-		if (event != event->group_leader)
-			continue;
+	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
 
 		if (!event->attr.inherit) {
 			inherited_all = 0;

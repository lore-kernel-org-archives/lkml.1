Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYLAKCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYLAKCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLAKCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:02:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42868 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYLAKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:02:30 -0500
Date: Mon, 1 Dec 2008 19:01:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, nickpiggin@yahoo.com.au, knikanth@suse.de,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/4] memcg: remove unused logic in mem_cgroup_move_task()
Message-Id: <20081201190136.0e8b6ef0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary codes (...fragments of not-implemented functionalilty...)

Changelog:
 - removed all unused fragments.
 - added comment.


Reported-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: mmotm-2.6.28-Nov30/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov30/mm/memcontrol.c
@@ -2008,25 +2008,10 @@ static void mem_cgroup_move_task(struct 
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
-	struct mm_struct *mm;
-	struct mem_cgroup *mem, *old_mem;
-
-	mm = get_task_mm(p);
-	if (mm == NULL)
-		return;
-
-	mem = mem_cgroup_from_cont(cont);
-	old_mem = mem_cgroup_from_cont(old_cont);
-
 	/*
-	 * Only thread group leaders are allowed to migrate, the mm_struct is
-	 * in effect owned by the leader
+	 * FIXME: It's better to move charges of this process from old
+	 * memcg to new memcg. But it's just on TODO-List now.
 	 */
-	if (!thread_group_leader(p))
-		goto out;
-
-out:
-	mmput(mm);
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {


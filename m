Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYLCEwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYLCEwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYLCEvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:51:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51956 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYLCEvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:51:01 -0500
Date: Wed, 3 Dec 2008 13:50:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       knikanth@suse.de,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  2/21] memcg-check-group-leader-fix.patch
Message-Id: <20081203135010.18c1c8b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
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


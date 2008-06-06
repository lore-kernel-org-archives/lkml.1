Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbYFFBmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbYFFBmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYFFBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:42:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61825 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYFFBmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:42:09 -0400
Message-ID: <4848955D.2020302@cn.fujitsu.com>
Date: Fri, 06 Jun 2008 09:39:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] memcg: clean up checking of  the disabled flag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those checks are unnecessary, because when the subsystem is disabled
it can't be mounted, so those functions won't get called.

The check is needed in functions which will be called in other places
except cgroup.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/memcontrol.c	2008-06-06 09:15:56.000000000 +0800
+++ b/mm/memcontrol.c	2008-06-06 09:09:04.000000000 +0800
@@ -845,9 +845,6 @@ static int mem_cgroup_force_empty(struct
 	int ret = -EBUSY;
 	int node, zid;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
@@ -1105,8 +1102,6 @@ static void mem_cgroup_destroy(struct cg
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	if (mem_cgroup_subsys.disabled)
-		return 0;
 	return cgroup_add_files(cont, ss, mem_cgroup_files,
 					ARRAY_SIZE(mem_cgroup_files));
 }
@@ -1119,9 +1114,6 @@ static void mem_cgroup_move_task(struct 
 	struct mm_struct *mm;
 	struct mem_cgroup *mem, *old_mem;
 
-	if (mem_cgroup_subsys.disabled)
-		return;
-
 	mm = get_task_mm(p);
 	if (mm == NULL)
 		return;

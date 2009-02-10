Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZBJJps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZBJJps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZBJJpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:45:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47366 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZBJJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:45:40 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg: remove mem_cgroup_calc_mapped_ratio()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090210184249.6FCD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 18:45:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, mem_cgroup_calc_mapped_ratio() is unused at all.
it can be removed and KAMEZAWA-san suggested it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/memcontrol.c |   17 -----------------
 1 file changed, 17 deletions(-)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -445,23 +445,6 @@ int task_in_mem_cgroup(struct task_struc
 	return ret;
 }
 
-/*
- * Calculate mapped_ratio under memory controller. This will be used in
- * vmscan.c for deteremining we have to reclaim mapped pages.
- */
-int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
-{
-	long total, rss;
-
-	/*
-	 * usage is recorded in bytes. But, here, we assume the number of
-	 * physical pages can be represented by "long" on any arch.
-	 */
-	total = (long) (mem->res.usage >> PAGE_SHIFT) + 1L;
-	rss = (long)mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
-	return (int)((rss * 100L) / total);
-}
-
 static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
 {
 	unsigned long active;



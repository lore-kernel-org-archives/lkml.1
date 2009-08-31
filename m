Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZHaKnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZHaKnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZHaKng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:43:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:48391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZHaKne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:43:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182301565"
Message-Id: <20090831104216.923421735@intel.com>
References: <20090831102640.092092954@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Aug 2009 18:26:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: lizf@cn.fujitsu.com
CC: nishimura@mxp.nes.nec.co.jp
cc: menage@google.com
CC: linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH 3/4] memcg: add accessor to mem_cgroup.css
Content-Disposition: inline; filename=memcg-mem_cgroup_css.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that one can check its cgroup id and free the reference count
grabbed by try_get_mem_cgroup_from_page().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |    6 ++++++
 2 files changed, 13 insertions(+)

--- linux-mm.orig/include/linux/memcontrol.h	2009-08-31 15:25:48.000000000 +0800
+++ linux-mm/include/linux/memcontrol.h	2009-08-31 15:27:00.000000000 +0800
@@ -81,6 +81,8 @@ int mm_match_cgroup(const struct mm_stru
 	return cgroup == mem;
 }
 
+extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *mem);
+
 extern int
 mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
@@ -206,6 +208,11 @@ static inline int task_in_mem_cgroup(str
 	return 1;
 }
 
+static inline struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *mem)
+{
+	return NULL;
+}
+
 static inline int
 mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
 {
--- linux-mm.orig/mm/memcontrol.c	2009-08-31 15:25:48.000000000 +0800
+++ linux-mm/mm/memcontrol.c	2009-08-31 15:25:52.000000000 +0800
@@ -282,6 +282,12 @@ mem_cgroup_zoneinfo(struct mem_cgroup *m
 	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
 }
 
+struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *mem)
+{
+	return &mem->css;
+}
+EXPORT_SYMBOL(mem_cgroup_css);
+
 static struct mem_cgroup_per_zone *
 page_cgroup_zoneinfo(struct page_cgroup *pc)
 {

-- 


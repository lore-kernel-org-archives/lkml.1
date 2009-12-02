Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZLBEhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZLBEhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZLBEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:57394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbZLBEhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764933"
Message-Id: <20091202043046.264611775@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/24] memcg: add accessor to mem_cgroup.css
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=memcg-mem_cgroup_css.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that an outside user can free the reference count grabbed by
try_get_mem_cgroup_from_page().

CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |    5 +++++
 2 files changed, 12 insertions(+)

--- linux-mm.orig/include/linux/memcontrol.h	2009-11-02 10:26:21.000000000 +0800
+++ linux-mm/include/linux/memcontrol.h	2009-11-02 10:26:21.000000000 +0800
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
--- linux-mm.orig/mm/memcontrol.c	2009-11-02 10:26:21.000000000 +0800
+++ linux-mm/mm/memcontrol.c	2009-11-02 10:26:21.000000000 +0800
@@ -282,6 +282,11 @@ mem_cgroup_zoneinfo(struct mem_cgroup *m
 	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
 }
 
+struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *mem)
+{
+	return &mem->css;
+}
+
 static struct mem_cgroup_per_zone *
 page_cgroup_zoneinfo(struct page_cgroup *pc)
 {



Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZHaKn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZHaKn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZHaKn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:43:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:39277 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZHaKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182301561"
Message-Id: <20090831104216.648065078@intel.com>
References: <20090831102640.092092954@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Aug 2009 18:26:41 +0800
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
Subject: [RFC][PATCH 1/4] memcg: show memory.id in cgroupfs
Content-Disposition: inline; filename=memcg-show-id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwpoison test suite need to selectively inject hwpoison to some
targeted task pages, and must not kill important system processes
such as init.

The memory cgroup serves this purpose well. We can put the target
processes under the control of a memory cgroup, tell the hwpoison
injection code the id of that memory cgroup so that it will only
poison pages associated with it.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-mm.orig/mm/memcontrol.c	2009-08-31 15:27:34.000000000 +0800
+++ linux-mm/mm/memcontrol.c	2009-08-31 15:41:50.000000000 +0800
@@ -2510,6 +2510,11 @@ mem_cgroup_get_recursive_idx_stat(struct
 	*val = d.val;
 }
 
+static u64 mem_cgroup_id_read(struct cgroup *cont, struct cftype *cft)
+{
+	return css_id(cgroup_subsys_state(cont, mem_cgroup_subsys_id));
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
@@ -2842,6 +2847,10 @@ static int mem_cgroup_swappiness_write(s
 
 static struct cftype mem_cgroup_files[] = {
 	{
+		.name = "id",
+		.read_u64 = mem_cgroup_id_read,
+	},
+	{
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,

-- 


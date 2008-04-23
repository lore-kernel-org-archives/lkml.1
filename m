Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYDWC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYDWC1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYDWC1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:27:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbYDWC1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:27:33 -0400
Message-ID: <480E9E52.4080905@cn.fujitsu.com>
Date: Wed, 23 Apr 2008 10:26:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] memcg: remove redundant initialization in mem_cgroup_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*mem has been zeroed, that means mem->info has already
been filled with 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eefa750..020e8f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1014,8 +1014,6 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 
 	res_counter_init(&mem->res);
 
-	memset(&mem->info, 0, sizeof(mem->info));
-
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
-- 1.5.4.rc3

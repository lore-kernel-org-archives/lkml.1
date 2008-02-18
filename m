Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYBRGBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYBRGBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYBRGBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:01:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57680 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbYBRGA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:00:59 -0500
Message-ID: <47B91EC9.7080606@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:59:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 3/3] memcgroup: return negative error code in mem_cgroup_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cgroup requires the subsystem to return negative error code on
error in the create method.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c2959ee..4aac04c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1101,7 +1101,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
 	if (mem == NULL)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	res_counter_init(&mem->res);
 
@@ -1117,7 +1117,7 @@ free_out:
 		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
 		kfree(mem);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
-- 
1.5.4.rc3


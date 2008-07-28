Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYG1CaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYG1CaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYG1CaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:30:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbYG1CaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:30:00 -0400
Message-ID: <488D2ECB.2070801@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:28:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] memcg: remove redundant check in move_task()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's guaranteed by cgroup that old_cgrp != cgrp.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fba566c..7056c3b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1168,9 +1168,6 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 	mem = mem_cgroup_from_cont(cont);
 	old_mem = mem_cgroup_from_cont(old_cont);
 
-	if (mem == old_mem)
-		goto out;
-
 	/*
 	 * Only thread group leaders are allowed to migrate, the mm_struct is
 	 * in effect owned by the leader
-- 
1.5.4.rc3



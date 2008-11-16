Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYKPEh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYKPEh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYKPEhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbYKPEhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:37:06 -0500
Message-ID: <491FA2AA.6060706@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:33:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kamezawa.hiroyu@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] memcontrol: use simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use simple_malloc()/simple_free() instead of current codes.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 866dcc7..66e1c6d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1062,11 +1062,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *mem;
 
-	if (sizeof(*mem) < PAGE_SIZE)
-		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
-	else
-		mem = vmalloc(sizeof(*mem));
-
+	mem = simple_malloc(sizeof(*mem));
 	if (mem)
 		memset(mem, 0, sizeof(*mem));
 	return mem;
@@ -1074,10 +1070,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 
 static void mem_cgroup_free(struct mem_cgroup *mem)
 {
-	if (sizeof(*mem) < PAGE_SIZE)
-		kfree(mem);
-	else
-		vfree(mem);
+	simple_free(mem);
 }
 
 




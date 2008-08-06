Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYHFOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYHFOQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHFOQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:16:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35790 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYHFOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:16:41 -0400
Date: Wed, 6 Aug 2008 15:15:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: fix oops in mem_cgroup_shrink_usage
Message-ID: <Pine.LNX.4.64.0808061511110.1539@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got an oops in mem_cgroup_shrink_usage() when testing loop over tmpfs:
yes, of course, loop0 has no mm: other entry points check but this didn't.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.27-rc2/mm/memcontrol.c	2008-08-06 08:36:20.000000000 +0100
+++ linux/mm/memcontrol.c	2008-08-06 09:05:26.000000000 +0100
@@ -796,6 +796,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	if (mem_cgroup_subsys.disabled)
 		return 0;
+	if (!mm)
+		return 0;
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));

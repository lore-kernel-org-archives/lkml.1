Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYKSP3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYKSP3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYKSP25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:28:57 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33383 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYKSP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:28:57 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 19 Nov 2008 20:58:42 +0530
Message-Id: <20081119152842.10651.31873.sendpatchset@balbir-laptop>
Subject: [mm][PATCH] Memory cgroup fix hierarchy selector
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew and Li reviewed and found that we need to check for val being 1 or 0
for the root container as well. use_hierarchy's type is changed to bool.
We still continue to use the ease of write_X64 for writing to it and then
check if the values are sane.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-add-hierarchy-selector mm/memcontrol.c
--- linux-2.6.28-rc4/mm/memcontrol.c~memcg-fix-add-hierarchy-selector	2008-11-19 11:07:21.000000000 +0530
+++ linux-2.6.28-rc4-balbir/mm/memcontrol.c	2008-11-19 14:11:56.000000000 +0530
@@ -151,7 +151,7 @@ struct mem_cgroup {
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
-	unsigned long use_hierarchy;
+	bool use_hierarchy;
 
 	int		obsolete;
 	atomic_t	refcnt;
@@ -1556,8 +1556,8 @@ static int mem_cgroup_hierarchy_write(st
 	 * For the root cgroup, parent_mem is NULL, we allow value to be
 	 * set if there are no children.
 	 */
-	if (!parent_mem || (!parent_mem->use_hierarchy &&
-				(val == 1 || val == 0))) {
+	if ((!parent_mem || !parent_mem->use_hierarchy) &&
+				(val == 1 || val == 0)) {
 		if (list_empty(&cont->children))
 			mem->use_hierarchy = val;
 		else
_

-- 
	Balbir

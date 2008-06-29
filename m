Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYF2APh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYF2APh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYF2APa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:15:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34015 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYF2AP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:15:29 -0400
Date: Sun, 29 Jun 2008 01:15:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: mem_cgroup_shrink_usage css_put
In-Reply-To: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290114380.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_shrink_usage makes no charge: balance its css_get with a css_put.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's memcg-helper-function-for-relcaim-from-shmem.patch

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
@@ -801,6 +801,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
 	} while (!progress && --retry);
 
+	css_put(&mem->css);
 	if (!retry)
 		return -ENOMEM;
 	return 0;

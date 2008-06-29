Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYF2AWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYF2AWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYF2AWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:22:37 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34106 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYF2AWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:22:37 -0400
Date: Sun, 29 Jun 2008 01:22:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] splitlru: memcg swapbacked pages active
In-Reply-To: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290120270.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru,
so shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's vmscan-split-lru-lists-into-anon-file-sets.patch

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
@@ -560,6 +560,8 @@ static int mem_cgroup_charge_common(stru
 		pc->flags = PAGE_CGROUP_FLAG_CACHE;
 		if (page_is_file_cache(page))
 			pc->flags |= PAGE_CGROUP_FLAG_FILE;
+		else
+			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
 	} else
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZLIPtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZLIPtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZLIPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:49:11 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63595 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZLIPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:49:10 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>, stable@kernel.org
Subject: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for root cgroup
Date: Wed,  9 Dec 2009 17:48:58 +0200
Message-Id: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really want to take MEM_CGROUP_STAT_SWAPOUT into account.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: stable@kernel.org
---
 mm/memcontrol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..6314015 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2541,6 +2541,7 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 			val += idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
 				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);
-- 
1.6.5.3


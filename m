Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYLHOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYLHOqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYLHOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:46:10 -0500
Received: from mail.klingt.org ([86.59.21.178]:43717 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYLHOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:46:09 -0500
X-Greylist: delayed 708 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 09:46:09 EST
From: Tim Blechmann <tim@klingt.org>
To: rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tim Blechmann <tim@klingt.org>
Subject: [PATCH] [RT] avoid preemption in memory controller code
Date: Mon,  8 Dec 2008 15:34:14 +0100
Message-Id: <1228746854-23875-1-git-send-email-tim@klingt.org>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Mon, 08 Dec 2008 15:34:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the lru_lock of struct mem_group_per_zone is used to avoid preemption
during the __mem_cgroup_stat_add_safe function.
therefore, a raw_spinlock_t should be used.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 517f945..8661732 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -95,9 +95,9 @@ enum mem_cgroup_zstat_index {
 
 struct mem_cgroup_per_zone {
 	/*
-	 * spin_lock to protect the per cgroup LRU
+	 * raw_spin_lock to protect the per cgroup LRU
 	 */
-	spinlock_t		lru_lock;
+	raw_spinlock_t		lru_lock;
 	struct list_head	active_list;
 	struct list_head	inactive_list;
 	unsigned long count[NR_MEM_CGROUP_ZSTAT];
-- 
1.5.6.3


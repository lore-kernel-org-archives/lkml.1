Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0BJXzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:55:42 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47049 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0BJXzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:55:41 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH mmotm] memcg: check if first threshold crossed
Date: Thu, 11 Feb 2010 01:55:23 +0200
Message-Id: <1265846123-2244-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in memory thresholds code. We don't check if first
threshold (array index 0) was crossed down. This patch fixes it.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 41e00c2..a443c30 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3252,7 +3252,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 	 * If none of thresholds below usage is crossed, we read
 	 * only one element of the array here.
 	 */
-	for (; i > 0 && unlikely(t->entries[i].threshold > usage); i--)
+	for (; i >= 0 && unlikely(t->entries[i].threshold > usage); i--)
 		eventfd_signal(t->entries[i].eventfd, 1);
 
 	/* i = current_threshold + 1 */
-- 
1.6.5.8


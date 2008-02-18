Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYBRGBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYBRGBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYBRGAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:00:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59584 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYBRGAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:00:53 -0500
Message-ID: <47B91EC2.3020805@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:59:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
be VM_BUG_ON(page).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6bded84..c2959ee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -534,7 +534,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 		if (scan >= nr_to_scan)
 			break;
 		page = pc->page;
-		VM_BUG_ON(!pc);
+		VM_BUG_ON(!page);
 
 		if (unlikely(!PageLRU(page)))
 			continue;
-- 
1.5.4.rc3


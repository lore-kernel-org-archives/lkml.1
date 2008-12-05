Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYLEMcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYLEMcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLEMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:31:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39389 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLEMbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:31:53 -0500
Date: Fri, 5 Dec 2008 21:24:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH -mmotm 2/4] memcg: remove mem_cgroup_try_charge
Message-Id: <20081205212401.1f446c93.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, mem_cgroup_try_charge is not used by anyone, so we can remove it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 include/linux/memcontrol.h |    8 --------
 mm/memcontrol.c            |   21 +--------------------
 2 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fe82b58..4b35739 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -40,8 +40,6 @@ struct mm_struct;
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
-extern int mem_cgroup_try_charge(struct mm_struct *mm,
-		gfp_t gfp_mask, struct mem_cgroup **ptr);
 extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		struct page *page, gfp_t mask, struct mem_cgroup **ptr);
 extern void mem_cgroup_commit_charge_swapin(struct page *page,
@@ -135,12 +133,6 @@ static inline int mem_cgroup_cache_charge(struct page *page,
 	return 0;
 }
 
-static inline int mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **ptr)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50ee1be..9c5856b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -808,27 +808,8 @@ nomem:
 	return -ENOMEM;
 }
 
-/**
- * mem_cgroup_try_charge - get charge of PAGE_SIZE.
- * @mm: an mm_struct which is charged against. (when *memcg is NULL)
- * @gfp_mask: gfp_mask for reclaim.
- * @memcg: a pointer to memory cgroup which is charged against.
- *
- * charge against memory cgroup pointed by *memcg. if *memcg == NULL, estimated
- * memory cgroup from @mm is got and stored in *memcg.
- *
- * Returns 0 if success. -ENOMEM at failure.
- * This call can invoke OOM-Killer.
- */
-
-int mem_cgroup_try_charge(struct mm_struct *mm,
-			  gfp_t mask, struct mem_cgroup **memcg)
-{
-	return __mem_cgroup_try_charge(mm, mask, memcg, true);
-}
-
 /*
- * commit a charge got by mem_cgroup_try_charge() and makes page_cgroup to be
+ * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
  * USED state. If already USED, uncharge and return.
  */
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZBJJuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZBJJuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZBJJun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:50:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47812 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZBJJum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:50:42 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] memcg: remove mem_cgroup_reclaim_imbalance() perfectly
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090210184538.6FCF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 18:50:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db (vmscan: 
split LRU lists into anon & file sets) remove mem_cgroup_reclaim_imbalance().

but it isn't enough.
memcontrol.h header file still have legacy parts.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 include/linux/memcontrol.h |    6 ------
 1 file changed, 6 deletions(-)

Index: b/include/linux/memcontrol.h
===================================================================
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -88,7 +88,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
@@ -202,11 +201,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline int mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
-{
-	return 0;
-}
-
 static inline bool mem_cgroup_disabled(void)
 {
 	return true;



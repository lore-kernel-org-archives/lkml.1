Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYEOJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYEOJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEOJ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:27:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54810 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYEOJ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:27:38 -0400
Date: Thu, 15 May 2008 18:32:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>, minchan.kim@gmail.com
Subject: [PATCH -mm 4/5] memcg: add hints for branch
Message-Id: <20080515183233.2eb16b51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080515182516.763967cc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080515182516.763967cc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Showing brach direction for obvious conditions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: mm-2.6.26-rc2-mm1/mm/memcontrol.c
===================================================================
--- mm-2.6.26-rc2-mm1.orig/mm/memcontrol.c
+++ mm-2.6.26-rc2-mm1/mm/memcontrol.c
@@ -550,7 +550,7 @@ retry:
 	 * The page_cgroup exists and
 	 * the page has already been accounted.
 	 */
-	if (pc) {
+	if (unlikely(pc)) {
 		VM_BUG_ON(pc->page != page);
 		VM_BUG_ON(!pc->mem_cgroup);
 		unlock_page_cgroup(page);
@@ -559,7 +559,7 @@ retry:
 	unlock_page_cgroup(page);
 
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
-	if (pc == NULL)
+	if (unlikely(pc == NULL))
 		goto err;
 
 	/*
@@ -616,7 +616,7 @@ retry:
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
-	if (page_get_page_cgroup(page)) {
+	if (unlikely(page_get_page_cgroup(page))) {
 		unlock_page_cgroup(page);
 		/*
 		 * Another charge has been added to this page already.
@@ -690,7 +690,7 @@ __mem_cgroup_uncharge_common(struct page
 	 */
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
-	if (!pc)
+	if (unlikely(!pc))
 		goto unlock;
 
 	VM_BUG_ON(pc->page != page);


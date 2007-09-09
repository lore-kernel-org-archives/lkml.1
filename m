Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbXIIU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbXIIU3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXIIUZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60746 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759513AbXIIUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:41 -0400
Date: Sun, 9 Sep 2007 22:25:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] mm/memcontrol.c: clenups
Message-ID: <20070909202548.GW3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
>...
>  memory containment
>...

This patch makes the following needlessly global functions static:
- lock_page_container()
- unlock_page_container()
- __mem_container_move_lists()

Additionally, there was no reason for the "mem_control_type" object.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

b582cc510b6b0a182dc56025828e7a3c566b9724 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8162d98..49bf04f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -91,7 +91,7 @@ enum {
 	MEM_CONTAINER_TYPE_CACHED,
 	MEM_CONTAINER_TYPE_ALL,
 	MEM_CONTAINER_TYPE_MAX,
-} mem_control_type;
+};
 
 static struct mem_container init_mem_container;
 
@@ -156,18 +156,18 @@ struct page_container *page_get_page_container(struct page *page)
 		(page->page_container & ~PAGE_CONTAINER_LOCK);
 }
 
-void __always_inline lock_page_container(struct page *page)
+static void __always_inline lock_page_container(struct page *page)
 {
 	bit_spin_lock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
 	VM_BUG_ON(!page_container_locked(page));
 }
 
-void __always_inline unlock_page_container(struct page *page)
+static void __always_inline unlock_page_container(struct page *page)
 {
 	bit_spin_unlock(PAGE_CONTAINER_LOCK_BIT, &page->page_container);
 }
 
-void __mem_container_move_lists(struct page_container *pc, bool active)
+static void __mem_container_move_lists(struct page_container *pc, bool active)
 {
 	if (active)
 		list_move(&pc->lru, &pc->mem_container->active_list);


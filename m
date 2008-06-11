Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYFKC1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYFKC1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYFKC1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:27:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58076 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYFKC1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:27:35 -0400
Date: Wed, 11 Jun 2008 11:26:47 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc5-mm2 (compile error in mm/memory_hotplug.c)
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20080609223145.5c9a2878.akpm@linux-foundation.org>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080611112111.C7BE.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> lockess pagecache
>
> +vmscan-move-isolate_lru_page-to-vmscanc.patch
>   :

This patch is cause of compile error in mm/memory_hotplug.c.
Obviously, just here is old against changing interface of
isolate_lru_page(). :-(

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>


---
 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: current/mm/memory_hotplug.c
===================================================================
--- current.orig/mm/memory_hotplug.c
+++ current/mm/memory_hotplug.c
@@ -595,8 +595,9 @@ do_migrate_range(unsigned long start_pfn
 		 * We can skip free pages. And we can only deal with pages on
 		 * LRU.
 		 */
-		ret = isolate_lru_page(page, &source);
+		ret = isolate_lru_page(page);
 		if (!ret) { /* Success */
+			list_add_tail(&page->lru, &source);
 			move_pages--;
 		} else {
 			/* Becasue we don't have big zone->lock. we should

-- 
Yasunori Goto 



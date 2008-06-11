Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYFKSrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYFKSrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYFKSrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYFKSrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:00 -0400
Message-Id: <20080611184339.364358765@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:23 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 09/24] vmscan: add newly swapped in pages to the inactive list
Content-Disposition: inline; filename=vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Swapin_readahead can read in a lot of data that the processes in
memory never need.  Adding swap cache pages to the inactive list
prevents them from putting too much pressure on the working set.

This has the potential to help the programs that are already in
memory, but it could also be a disadvantage to processes that
are trying to get swapped in.

Signed-off-by: Rik van Riel <riel@redhat.com>

---
 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/mm/swap_state.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/swap_state.c	2008-06-10 13:35:23.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/swap_state.c	2008-06-10 13:40:46.000000000 -0400
@@ -303,7 +303,7 @@ struct page *read_swap_cache_async(swp_e
 			/*
 			 * Initiate read into locked page and return.
 			 */
-			lru_cache_add_active_anon(new_page);
+			lru_cache_add_anon(new_page);
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}

-- 
All Rights Reversed


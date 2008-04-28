Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbYD1S02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbYD1S02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936460AbYD1SWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:22:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936403AbYD1SWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:22:38 -0400
Message-Id: <20080428181853.047787212@redhat.com>
References: <20080428181835.502876582@redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 14:18:45 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH -mm 10/15] add newly swapped in pages to the inactive list
Content-Disposition: inline; filename=rvr-swapin-inactive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swapin_readahead can read in a lot of data that the processes in
memory never need.  Adding swap cache pages to the inactive list
prevents them from putting too much pressure on the working set.

This has the potential to help the programs that are already in
memory, but it could also be a disadvantage to processes that
are trying to get swapped in.

In short, this patch needs testing.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.25-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.25-mm1.orig/mm/swap_state.c	2008-04-24 12:01:36.000000000 -0400
+++ linux-2.6.25-mm1/mm/swap_state.c	2008-04-24 12:03:45.000000000 -0400
@@ -301,7 +301,7 @@ struct page *read_swap_cache_async(swp_e
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


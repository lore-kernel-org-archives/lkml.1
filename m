Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXLRVVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXLRVVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXLRVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:17:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbXLRVRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:17:36 -0500
Message-Id: <20071218211549.621840854@redhat.com>
References: <20071218211539.250334036@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 16:15:50 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
Subject: [patch 11/20] add newly swapped in pages to the inactive list
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

Index: linux-2.6.23-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/swap_state.c
+++ linux-2.6.23-mm1/mm/swap_state.c
@@ -370,7 +370,7 @@ struct page *read_swap_cache_async(swp_e
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


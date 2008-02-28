Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbYB1Tpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbYB1Tpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763335AbYB1TmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:42:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761530AbYB1Tl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:41:58 -0500
Message-Id: <20080228192928.790504650@redhat.com>
References: <20080228192908.126720629@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 28 Feb 2008 14:29:18 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: [patch 10/21] add newly swapped in pages to the inactive list
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

Index: linux-2.6.25-rc2-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/mm/swap_state.c	2008-02-28 00:27:06.000000000 -0500
+++ linux-2.6.25-rc2-mm1/mm/swap_state.c	2008-02-28 00:29:51.000000000 -0500
@@ -300,7 +300,7 @@ struct page *read_swap_cache_async(swp_e
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


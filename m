Return-Path: <linux-kernel-owner+w=401wt.eu-S1763033AbYEPSw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763033AbYEPSw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761041AbYEPSsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:48:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760969AbYEPSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:47:58 -0400
Message-Id: <20080516183224.560370213@redhat.com>
References: <20080516183207.361608893@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 May 2008 14:32:16 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [patch 09/14] add newly swapped in pages to the inactive list
Content-Disposition: inline; filename=rvr-swapin-inactive.patch
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

In short, this patch needs testing.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.26-rc2-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/swap_state.c	2008-05-16 13:53:09.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/swap_state.c	2008-05-16 14:05:02.000000000 -0400
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


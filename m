Return-Path: <linux-kernel-owner+w=401wt.eu-S934788AbXHGPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788AbXHGPcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXHGPcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:32:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4920 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbXHGPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:32:15 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] synchronous lumpy: improve commentary on writeback wait
References: <20070806122204.924fa0e9.akpm@linux-foundation.org>
InReply-To: <20070806122204.924fa0e9.akpm@linux-foundation.org>
Message-ID: <5de3a4f206c81c41e8b1ce5eeb245851@pinky>
Date: Tue, 07 Aug 2007 16:31:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Improve code commentary on the initial writeback wait in synchronous
reclaim mode.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 mm/vmscan.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b1e9291..a6e65d0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -479,6 +479,14 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
+			/*
+			 * Synchronous reclaim is performed in two passes,
+			 * first an asynchronous pass over the list to
+			 * start parallel writeback, and a second synchronous
+			 * pass to wait for the IO to complete.  Wait here
+			 * for any page for which writeback has already
+			 * started.
+			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
 			else

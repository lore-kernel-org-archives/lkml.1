Return-Path: <linux-kernel-owner+w=401wt.eu-S934795AbXGQPmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795AbXGQPmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934570AbXGQPlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500AbXGQPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:59 -0400
Message-Id: <20070717173757.510649000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 04/12] mm: remove raw ClearPageLocked() usage
Content-Disposition: inline; filename=unlock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove the last raw ClearPageLocked() user

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c
+++ linux-2.6/mm/swap_state.c
@@ -368,7 +368,7 @@ struct page *read_swap_cache_async(swp_e
 	} while (err != -ENOENT && err != -ENOMEM);
 
 	if (new_page) {
-		ClearPageLocked(new_page);
+		unlock_page(new_page);
 		page_cache_release(new_page);
 	}
 	return found_page;

--


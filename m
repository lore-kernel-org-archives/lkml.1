Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYGBNVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYGBNVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYGBNVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:21:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45045 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYGBNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:21:01 -0400
Date: Wed, 02 Jul 2008 22:19:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [resend][PATCH] fix lru_cache_add_active_or_unevictable
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080702221101.D16A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found I forgot insert below patch to my patchset for 2.6.26-rc5-mm3 today.
So, I resend it.

enjoy!


-------------------------
From: Rik van Riel <riel@redhat.com>

Undo an overzealous code cleanup to lru_cache_add_active_or_unevictable.
The callers do not set PageActive so the page would get added to the
wrong list.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Index: linux-2.6.26-rc5-mm3/mm/swap.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/mm/swap.c	2008-07-01 18:47:04.000000000 +0900
+++ linux-2.6.26-rc5-mm3/mm/swap.c	2008-07-01 19:28:43.000000000 +0900
@@ -259,7 +259,7 @@
 					struct vm_area_struct *vma)
 {
 	if (page_evictable(page, vma))
-		lru_cache_add_lru(page, page_lru(page));
+		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
 	else
 		add_page_to_unevictable_list(page);
 }



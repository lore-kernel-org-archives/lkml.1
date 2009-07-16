Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZGPIiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZGPIiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZGPIip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:38:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57983 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZGPIio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:38:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] Kill unnecessary page flag test
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
References: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
Message-Id: <20090716173741.9D4E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 17:38:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Kill unnecessary page flag test

The page_lru() already evaluate PageActive() and PageSwapBacked(). We
don't need to re-evaluate it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1160,8 +1160,8 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page)) {
-				int file = !!page_is_file_cache(page);
+			if (is_active_lru(lru)) {
+				int file = !!is_file_lru(lru);
 				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {



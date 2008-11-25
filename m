Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYKYE3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYKYE3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYKYE3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:29:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46796 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKYE3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:29:23 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make scan_zone_unevictable_pages() static
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132811.26DC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:29:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse output following warning

	mm/vmscan.c:2507:6: warning: symbol 'scan_zone_unevictable_pages' was not declared. Should it be static?

cleanup here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-11-05 01:11:44.000000000 +0900
+++ b/mm/vmscan.c	2008-11-22 21:45:21.000000000 +0900
@@ -2504,7 +2504,7 @@ void scan_mapping_unevictable_pages(stru
  * back onto @zone's unevictable list.
  */
 #define SCAN_UNEVICTABLE_BATCH_SIZE 16UL /* arbitrary lock hold batch size */
-void scan_zone_unevictable_pages(struct zone *zone)
+static void scan_zone_unevictable_pages(struct zone *zone)
 {
 	struct list_head *l_unevictable = &zone->lru[LRU_UNEVICTABLE].list;
 	unsigned long scan;



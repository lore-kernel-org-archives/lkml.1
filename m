Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZF3GZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZF3GZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZF3GZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:25:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39490 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZF3GZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:25:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Makes slab pages field in show_free_areas() separate two field
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090630152324.A73A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Jun 2009 15:25:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Makes slab pages field in show_free_areas() separate two field

if OOM happed, We really want to know the number of rest reclaimable pages.
Then, reclaimable slab and unreclaimable slab shouldn't be mixed displaing.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2119,7 +2119,8 @@ void show_free_areas(void)
 		" inactive_file:%lu"
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
+		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
+		" mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
@@ -2129,8 +2130,8 @@ void show_free_areas(void)
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
 		global_page_state(NR_FREE_PAGES),
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-			global_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_page_state(NR_SLAB_RECLAIMABLE),
+		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE));



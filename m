Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbZGIIHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbZGIIHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbZGIIGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:06:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47911 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbZGIIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:06:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5][resend] add per-zone statistics to show_free_areas()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
Message-Id: <20090709170535.23BA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 17:06:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] add per-zone statistics to show_free_areas()

show_free_areas() displays only a limited amount of zone counters. This
patch includes additional counters in the display to allow easier
debugging. This may be especially useful if an OOM is due to running out
of DMA memory.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2151,6 +2151,16 @@ void show_free_areas(void)
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" present:%lukB"
+			" mlocked:%lukB"
+			" dirty:%lukB"
+			" writeback:%lukB"
+			" mapped:%lukB"
+			" slab_reclaimable:%lukB"
+			" slab_unreclaimable:%lukB"
+			" pagetables:%lukB"
+			" unstable:%lukB"
+			" bounce:%lukB"
+			" writeback_tmp:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
@@ -2165,6 +2175,16 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
 			K(zone->present_pages),
+			K(zone_page_state(zone, NR_MLOCK)),
+			K(zone_page_state(zone, NR_FILE_DIRTY)),
+			K(zone_page_state(zone, NR_WRITEBACK)),
+			K(zone_page_state(zone, NR_FILE_MAPPED)),
+			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
+			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
+			K(zone_page_state(zone, NR_PAGETABLE)),
+			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
+			K(zone_page_state(zone, NR_BOUNCE)),
+			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
 			);



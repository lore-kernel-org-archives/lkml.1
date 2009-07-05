Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZGEJ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZGEJ01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZGEJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:26:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53848 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZGEJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:26:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090705181400.08F1.A69D9226@jp.fujitsu.com>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com>
Message-Id: <20090705182533.0902.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 18:26:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] add NR_ANON_PAGES to OOM log

show_free_areas can display NR_FILE_PAGES, but it can't display
NR_ANON_PAGES.

this patch fix its inconsistency.


Reported-by: Wu Fengguang <fengguang.wu@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2216,6 +2216,7 @@ void show_free_areas(void)
 		printk("= %lukB\n", K(total));
 	}
 
+	printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
 	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();



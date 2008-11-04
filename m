Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYKDBlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYKDBlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYKDBlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:41:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:41182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYKDBlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:41:14 -0500
Message-ID: <490FA7EA.2060305@kernel.org>
Date: Mon, 03 Nov 2008 17:39:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: print out memmap number only it is not zero
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

not print out for non used zone on nodes other than node0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3451,9 +3451,10 @@ static void __paginginit free_area_init_
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			printk(KERN_DEBUG
-				"  %s zone: %lu pages used for memmap\n",
-				zone_names[j], memmap_pages);
+			if (memmap_pages)
+				printk(KERN_DEBUG
+				       "  %s zone: %lu pages used for memmap\n",
+				       zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
 				"  %s zone: %lu pages exceeds realsize %lu\n",

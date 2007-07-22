Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbXGVSy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbXGVSy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760883AbXGVSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:54:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:39396
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757922AbXGVSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:54:18 -0400
Date: Sun, 22 Jul 2007 20:56:08 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mm/page_alloc.c: Use list_for_each_entry instead of list_for_each
Message-ID: <20070722185608.GK27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070722184202.GF27415@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722184202.GF27415@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm/page_alloc.c: Convert list_for_each to list_for_each_entry in
mark_free_pages()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 05ace44..1f138fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -731,7 +731,7 @@ void mark_free_pages(struct zone *zone)
 	unsigned long pfn, max_zone_pfn;
 	unsigned long flags;
 	int order;
-	struct list_head *curr;
+	struct page *curr_page;
 
 	if (!zone->spanned_pages)
 		return;
@@ -748,10 +748,11 @@ void mark_free_pages(struct zone *zone)
 		}
 
 	for (order = MAX_ORDER - 1; order >= 0; --order)
-		list_for_each(curr, &zone->free_area[order].free_list) {
+		list_for_each_entry(curr_page,
+				    &zone->free_area[order].free_list, lru) {
 			unsigned long i;
 
-			pfn = page_to_pfn(list_entry(curr, struct page, lru));
+			pfn = page_to_pfn(curr_page);
 			for (i = 0; i < (1UL << order); i++)
 				swsusp_set_page_free(pfn_to_page(pfn + i));
 		}

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              La posibilidad de realizar un suenyo es lo
                 que hace que la vida sea interesante
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

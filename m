Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbYGDQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbYGDQvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759004AbYGDQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:04 -0400
Received: from saeurebad.de ([85.214.36.134]:38512 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604AbYGDQvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:01 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:52 2008
Message-Id: <20080704161452.426549011@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:38 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 01/20] mm: print swapcache page count in show_swap_cache_info()
Content-Disposition: inline; filename=mm-show-swapcache-pages-in-show_swap_cache_info.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most show_mem() implementations calculate the amount of pages within
the swapcache every time.  Move the output to a more appropriate place
and use the anyway available total_swapcache_pages variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -56,7 +56,8 @@ static struct {
 
 void show_swap_cache_info(void)
 {
-	printk("Swap cache: add %lu, delete %lu, find %lu/%lu\n",
+	printk("%lu pages in swap cache\n", total_swapcache_pages);
+	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));

-- 


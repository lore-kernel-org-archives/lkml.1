Return-Path: <linux-kernel-owner+w=401wt.eu-S1761152AbYDDM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152AbYDDM7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbYDDMzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:55:14 -0400
Received: from saeurebad.de ([85.214.36.134]:44718 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195AbYDDMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:55:07 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:30 2008
Message-Id: <20080404115230.720471887@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:38 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 01/22 -v2] Print current swapcache page count in show_swap_cache_info()
Content-Disposition: inline; filename=print-total_swapcache_pages-in-show_swap_cache_info.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most show_mem() implementations calculate the amount of pages within
the swapcache every time.  Move the output to a more appropriate place
and use the anyway available total_swapcache_pages variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 50757ee..71cc0e1 100644
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


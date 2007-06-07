Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXFGKBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXFGKBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFGKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:01:27 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:40255 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXFGKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:01:25 -0400
Subject: 
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: tony.luck@intel.com, rohit.seth@intel.com, kenneth.w.chen@intel.com
Cc: linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Thu, 07 Jun 2007 15:15:23 +0530
Message-Id: <1181209523.10486.1.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 07 Jun 2007 09:50:00.0621 (UTC) FILETIME=[36F4D5D0:01C7A8E9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/arch/ia64/mm/hugetlbpage.c b/arch/ia64/mm/hugetlbpage.c
index 1346b7f..d22861c 100644
--- a/arch/ia64/mm/hugetlbpage.c
+++ b/arch/ia64/mm/hugetlbpage.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/log2.h>
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -182,7 +183,7 @@ static int __init hugetlb_setup_sz(char *str)
 		tr_pages = 0x15557000UL;
 
 	size = memparse(str, &str);
-	if (*str || (size & (size-1)) || !(tr_pages & size) ||
+	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
 		size <= PAGE_SIZE ||
 		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
 		printk(KERN_WARNING "Invalid huge page size specified\n");

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"


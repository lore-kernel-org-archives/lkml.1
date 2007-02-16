Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbXBPMhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbXBPMhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBPMhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:37:08 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:57950 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbXBPMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:37:07 -0500
Subject: [KJ][PATCH] is_power_of_2 in ia64mm
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Feb 2007 17:33:55 +0530
Message-Id: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 16 Feb 2007 12:05:00.0165 (UTC) FILETIME=[AECEEB50:01C751C2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2


diff --git a/arch/ia64/mm/hugetlbpage.c b/arch/ia64/mm/hugetlbpage.c
index 0c7e94e..0ccc70e 100644
--- a/arch/ia64/mm/hugetlbpage.c
+++ b/arch/ia64/mm/hugetlbpage.c
@@ -16,6 +16,7 @@
 #include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/log2.h>
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
 		tr_pages = 0x15557000UL;
 
 	size = memparse(str, &str);
-	if (*str || (size & (size-1)) || !(tr_pages & size) ||
+	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
 		size <= PAGE_SIZE ||
 		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
 		printk(KERN_WARNING "Invalid huge page size specified\n");

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"

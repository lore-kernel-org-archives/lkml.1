Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZD3XqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZD3XqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZD3Xp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:45:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59075 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759484AbZD3Xp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:45:27 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/3] avr32: Use standard macros for .data.page_aligned section.
Date: Thu, 30 Apr 2009 19:42:37 -0400
Message-Id: <1241134959-7735-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134959-7735-1-git-send-email-tabbott@mit.edu>
References: <1241134959-7735-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/kernel/vmlinux.lds.S |    3 +--
 arch/avr32/mm/init.c            |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 7910d41..36d676f 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -98,8 +98,7 @@ SECTIONS
 		*(.data.init_task)
 
 		/* Then, the page-aligned data */
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index e819fa6..cc60d10 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -24,11 +24,9 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-#define __page_aligned	__attribute__((section(".data.page_aligned")))
-
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned;
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 struct page *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
-- 
1.6.2.1


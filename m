Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYF0P67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYF0P67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbYF0P57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:57:59 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43669 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbYF0P56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:57:58 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/6] avr32: Remove useless zeroing of swapper_pg_dir at startup
Date: Fri, 27 Jun 2008 17:57:52 +0200
Message-Id: <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0013 (UTC) FILETIME=[88059AD0:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swapper_pg_dir is stored in .bss, so it must already be zeroed out
when we get there.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/mm/init.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 5ee1e40..0e77578 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -108,19 +108,9 @@ void __init paging_init(void)
 	zero_page = alloc_bootmem_low_pages_node(NODE_DATA(0),
 						 PAGE_SIZE);
 
-	{
-		pgd_t *pg_dir;
-		int i;
-
-		pg_dir = swapper_pg_dir;
-		sysreg_write(PTBR, (unsigned long)pg_dir);
-
-		for (i = 0; i < PTRS_PER_PGD; i++)
-			pgd_val(pg_dir[i]) = 0;
-
-		enable_mmu();
-		printk ("CPU: Paging enabled\n");
-	}
+	sysreg_write(PTBR, (unsigned long)swapper_pg_dir);
+	enable_mmu();
+	printk ("CPU: Paging enabled\n");
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-- 
1.5.5.4


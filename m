Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbXE1Iim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbXE1Iim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761219AbXE1Igj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7605 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069464:sNHT22938335"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 06/20] Blackfin arch: mark our memory init functions with __init so they get freed after init
Date: Mon, 28 May 2007 16:37:41 +0800
Message-Id: <11803414781802-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mm/blackfin_sram.c |    8 ++++----
 arch/blackfin/mm/init.c          |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 3c9e635..0241764 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -7,7 +7,7 @@
  * Description:  SRAM driver for Blackfin ADSP-BF5xx
  *
  * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
+ *               Copyright 2004-2007 Analog Devices Inc.
  *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
@@ -80,7 +80,7 @@ static struct l1_sram_piece l1_inst_sram[CONFIG_L1_MAX_PIECE];
 #endif
 
 /* L1 Scratchpad SRAM initialization function */
-void l1sram_init(void)
+void __init l1sram_init(void)
 {
 	printk(KERN_INFO "Blackfin Scratchpad data SRAM: %d KB\n",
 	       L1_SCRATCH_LENGTH >> 10);
@@ -94,7 +94,7 @@ void l1sram_init(void)
 	spin_lock_init(&l1sram_lock);
 }
 
-void l1_data_sram_init(void)
+void __init l1_data_sram_init(void)
 {
 #if L1_DATA_A_LENGTH != 0
 	printk(KERN_INFO "Blackfin DATA_A SRAM: %d KB\n",
@@ -120,7 +120,7 @@ void l1_data_sram_init(void)
 	spin_lock_init(&l1_data_sram_lock);
 }
 
-void l1_inst_sram_init(void)
+void __init l1_inst_sram_init(void)
 {
 #if L1_CODE_LENGTH != 0
 	printk(KERN_INFO "Blackfin Instruction SRAM: %d KB\n",
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index d6cf105..570356d 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -7,7 +7,7 @@
  * Description:
  *
  * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
+ *               Copyright 2004-2007 Analog Devices Inc.
  *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
@@ -53,7 +53,7 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
+void __init show_mem(void)
 {
 	unsigned long i;
 	int free = 0, total = 0, reserved = 0, shared = 0;
@@ -86,7 +86,7 @@ void show_mem(void)
  * The parameters are pointers to where to stick the starting and ending
  * addresses  of available kernel virtual memory.
  */
-void paging_init(void)
+void __init paging_init(void)
 {
 	/*
 	 * make sure start_mem is page aligned,  otherwise bootmem and
@@ -125,7 +125,7 @@ void paging_init(void)
 	}
 }
 
-void mem_init(void)
+void __init mem_init(void)
 {
 	unsigned int codek = 0, datak = 0, initk = 0;
 	unsigned long tmp;
@@ -169,7 +169,7 @@ void mem_init(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	int pages = 0;
 	for (; start < end; start += PAGE_SIZE) {
@@ -183,14 +183,14 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void free_initmem(void)
+void __init free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
 	unsigned long addr;
-/*
- *	the following code should be cool even if these sections
- *	are not page aligned.
- */
+	/*
+	 *	the following code should be cool even if these sections
+	 *	are not page aligned.
+	 */
 	addr = PAGE_ALIGN((unsigned long)(__init_begin));
 	/* next to check that the page we free is not a partial page */
 	for (; addr + PAGE_SIZE < (unsigned long)(__init_end);
-- 
1.5.2

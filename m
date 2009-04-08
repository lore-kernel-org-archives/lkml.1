Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbZDHL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbZDHL3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762945AbZDHLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35582 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762864AbZDHLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:50 -0400
X-Sasl-enc: 9By9ZDDesfxiZXXddwDSZuTGulHb4IrqETQnuGs5G+Qt 1239189768
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 14/56] ia64: Remove void casts
Date: Wed,  8 Apr 2009 12:21:46 +0100
Message-Id: <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/ia64/kernel/mca_drv.c |    2 +-
 arch/ia64/mm/contig.c      |    2 +-
 arch/ia64/mm/discontig.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index f94aaa8..820f34e 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -496,7 +496,7 @@ recover_from_read_error(slidx_table_t *slidx,
 	u64 target_identifier;
 	pal_min_state_area_t *pmsa;
 	struct ia64_psr *psr1, *psr2;
-	ia64_fptr_t *mca_hdlr_bh = (ia64_fptr_t*)mca_handler_bhhook;
+	ia64_fptr_t *mca_hdlr_bh = mca_handler_bhhook;
 
 	/* Is target address valid? */
 	target_identifier = get_target_identifier(peidx);
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 0ee085e..e0d27b0 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -272,7 +272,7 @@ paging_init (void)
 		map_size = PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
 			sizeof(struct page));
 		vmalloc_end -= map_size;
-		vmem_map = (struct page *) vmalloc_end;
+		vmem_map = vmalloc_end;
 		efi_memmap_walk(create_mem_map_page_table, NULL);
 
 		/*
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index d85ba98..f3a45cd 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -668,7 +668,7 @@ void __init paging_init(void)
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 	vmalloc_end -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
 		sizeof(struct page));
-	vmem_map = (struct page *) vmalloc_end;
+	vmem_map = vmalloc_end;
 	efi_memmap_walk(create_mem_map_page_table, NULL);
 	printk("Virtual mem_map starts at 0x%p\n", vmem_map);
 #endif
-- 
1.5.4.3


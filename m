Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYGYOup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYGYOup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYGYOuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:50:07 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:8496 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYGYOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:50:05 -0400
X-BigFish: VPS8(z37d4lzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4KH72-04-24G-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] x86: convert init_64.c from round_up to roundup
Date: Fri, 25 Jul 2008 16:48:57 +0200
Message-ID: <1216997339-31427-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0483 (UTC) FILETIME=[925E72B0:01C8EE65]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/init_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ec37121..e480577 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -258,7 +258,7 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = round_up((unsigned long)_end, PMD_SIZE) - 1;
+	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
@@ -474,14 +474,14 @@ static void __init find_early_table_space(unsigned long end)
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	if (direct_gbpages) {
 		unsigned long extra;
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
 	} else
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-	tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (cpu_has_pse) {
 		unsigned long extra;
@@ -489,7 +489,7 @@ static void __init find_early_table_space(unsigned long end)
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	tables += round_up(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
-- 
1.5.3.7



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZCCKzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZCCKzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZCCKzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:55:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57360 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZCCKzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:55:09 -0500
Subject: [PATCH 2/2] x86: use roundup() instead of PAGE_ALIGN() in
	find_early_table_space()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2009 12:55:05 +0200
Message-Id: <1236077705.2675.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

This patch changes find_early_table_space() to use roundup() for rounding up
tables to page size to unify the common parts of the 32-bit and 64-bit
implementations.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 1a2e193..a0c32d5 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -824,10 +824,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = PAGE_ALIGN(puds * sizeof(pud_t));
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (use_pse) {
 		unsigned long extra;
@@ -838,10 +838,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	/* for fixmap */
-	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
-- 
1.5.4.3




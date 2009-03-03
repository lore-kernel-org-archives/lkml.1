Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZCCLK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZCCLK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZCCLKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:10:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:59568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbZCCLKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:10:37 -0500
Date: Tue, 3 Mar 2009 11:09:45 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236077705.2675.6.camel@penberg-laptop>
References: <1236077705.2675.6.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: use roundup() instead of PAGE_ALIGN() in find_early_table_space()
Message-ID: <tip-fd578f9c0a0a7bf3e460e6f21cdc6f4018949e80@git.kernel.org>
Git-Commit-ID: fd578f9c0a0a7bf3e460e6f21cdc6f4018949e80
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 11:09:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd578f9c0a0a7bf3e460e6f21cdc6f4018949e80
Gitweb:     http://git.kernel.org/tip/fd578f9c0a0a7bf3e460e6f21cdc6f4018949e80
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Tue, 3 Mar 2009 12:55:05 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 12:07:00 +0100

x86: use roundup() instead of PAGE_ALIGN() in find_early_table_space()

Impact: cleanup

This patch changes find_early_table_space() to use roundup() for rounding up
tables to page size to unify the common parts of the 32-bit and 64-bit
implementations.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236077705.2675.6.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5b06a2f..1dd6b63 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -845,10 +845,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = PAGE_ALIGN(puds * sizeof(pud_t));
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (use_pse) {
 		unsigned long extra;
@@ -859,10 +859,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	/* for fixmap */
-	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could

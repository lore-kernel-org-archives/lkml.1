Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYH1U65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYH1U65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYH1U6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:58:47 -0400
Received: from gw.goop.org ([64.81.55.164]:42405 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbYH1U6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:58:46 -0400
Message-ID: <48B7117F.8090008@goop.org>
Date: Thu, 28 Aug 2008 13:58:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make sure the CPA test code's use of _PAGE_UNUSED1 is
 obvious
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPA test code uses _PAGE_UNUSED1, so make sure its obvious.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pageattr-test.c |    6 +++---
 include/asm-x86/pgtable.h   |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -32,7 +32,7 @@
 	GPS			= (1<<30)
 };
 
-#define PAGE_TESTBIT	__pgprot(_PAGE_UNUSED1)
+#define PAGE_CPA_TEST	__pgprot(_PAGE_CPA_TEST)
 
 static int pte_testbit(pte_t pte)
 {
@@ -174,7 +174,7 @@
 		}
 
 		test_addr = addr[i];
-		err = change_page_attr_set(&test_addr, len[i], PAGE_TESTBIT, 0);
+		err = change_page_attr_set(&test_addr, len[i], PAGE_CPA_TEST, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
@@ -207,7 +207,7 @@
 			continue;
 		}
 		test_addr = addr[i];
-		err = change_page_attr_clear(&test_addr, len[i], PAGE_TESTBIT, 0);
+		err = change_page_attr_clear(&test_addr, len[i], PAGE_CPA_TEST, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);
 			failed++;
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -19,6 +19,7 @@
 #define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
+#define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 #define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
@@ -36,6 +37,7 @@
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
+#define _PAGE_CPA_TEST	(_AT(pteval_t, 1) << _PAGE_BIT_CPA_TEST)
 #define __HAVE_ARCH_PTE_SPECIAL
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYBKJfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYBKJfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYBKJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:34 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:37305 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYBKJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:33 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/8] CPA: Fix gbpages support in try_preserve_lage_page
Message-Id: <20080211093429.CD9D31B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:29 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:08.0990 (UTC) FILETIME=[6A0593E0:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use correct page sizes and masks for GB pages in try_preserve_large_page()

This prevents a boot hang on a GB capable system with CONFIG_DIRECT_GBPAGES
enabled.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -278,8 +278,8 @@ try_preserve_large_page(pte_t *kpte, uns
 		break;
 #ifdef CONFIG_X86_64
 	case PG_LEVEL_1G:
-		psize = PMD_PAGE_SIZE;
-		pmask = PMD_PAGE_MASK;
+		psize = PUD_PAGE_SIZE;
+		pmask = PUD_PAGE_MASK;
 		break;
 #endif
 	default:

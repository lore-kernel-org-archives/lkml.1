Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXHOKkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXHOKkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXHOKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:38:58 -0400
Received: from mail.suse.de ([195.135.220.2]:45726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbXHOKi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200708151238.148026000@suse.de>
In-Reply-To: <200708151238.148026000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2.6.22] [3/5] x86_64: Change PMDS invocation to single macro
Message-Id: <20070815103856.606DA14F28@wotan.suse.de>
Date: Wed, 15 Aug 2007 12:38:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Very old binutils (2.12.90...) seem to have trouble with newlines
in assembler macro invocation. They put them into the resulting
argument expansion. In this case this lead to a parse error because
a .rept expression ended up spread over multiple lines. Change the PMDS() 
invocation to a single line.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/head.S |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.22-stable/arch/x86_64/kernel/head.S
===================================================================
--- linux-2.6.22-stable.orig/arch/x86_64/kernel/head.S
+++ linux-2.6.22-stable/arch/x86_64/kernel/head.S
@@ -326,8 +326,7 @@ NEXT_PAGE(level2_kernel_pgt)
 	/* 40MB kernel mapping. The kernel code cannot be bigger than that.
 	   When you change this change KERNEL_TEXT_SIZE in page.h too. */
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511)-((2^30)*510)) = 0 */
-	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL,
-		KERNEL_TEXT_SIZE/PMD_SIZE)
+	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_SIZE/PMD_SIZE)
 	/* Module mapping starts here */
 	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_SIZE/PMD_SIZE)),8,0
 

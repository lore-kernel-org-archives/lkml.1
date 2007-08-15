Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbXHOAmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbXHOAmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbXHOAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:40:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbXHOAkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:40:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070815240.194452000@suse.de>
In-Reply-To: <20070815240.194452000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] [3/4] x86_64: Change PMDS invocation to single macro
Message-Id: <20070815004036.6BBCF14DC8@wotan.suse.de>
Date: Wed, 15 Aug 2007 02:40:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Very old binutils (2.12.90...) seem to have trouble with newlines
in assembler macro invocation. They put them into the resulting
argument expansion. In this case this lead to a parse error because
a .rept expression ended up spread over multiple lines. Change the PMDS() 
invocation to a single line.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -345,8 +345,7 @@ NEXT_PAGE(level2_kernel_pgt)
 	/* 40MB kernel mapping. The kernel code cannot be bigger than that.
 	   When you change this change KERNEL_TEXT_SIZE in page.h too. */
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511)-((2^30)*510)) = 0 */
-	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL,
-		KERNEL_TEXT_SIZE/PMD_SIZE)
+	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_SIZE/PMD_SIZE)
 	/* Module mapping starts here */
 	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_SIZE/PMD_SIZE)),8,0
 

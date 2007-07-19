Return-Path: <linux-kernel-owner+w=401wt.eu-S938989AbXGSOF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938989AbXGSOF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765316AbXGSNtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:48673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196AbXGSNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:06 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: rpjday@mindspring.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [34/48] i386: Update alignment when 4K stacks are used.
Message-Id: <20070719134904.B579E14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

  it's not clear from MAINTAINERS who's responsible for something this
generic.

---
 arch/i386/kernel/irq.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux/arch/i386/kernel/irq.c
===================================================================
--- linux.orig/arch/i386/kernel/irq.c
+++ linux/arch/i386/kernel/irq.c
@@ -149,15 +149,11 @@ fastcall unsigned int do_IRQ(struct pt_r
 
 #ifdef CONFIG_4KSTACKS
 
-/*
- * These should really be __section__(".bss.page_aligned") as well, but
- * gcc's 3.0 and earlier don't handle that correctly.
- */
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing

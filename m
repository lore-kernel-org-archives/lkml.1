Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXBLHnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXBLHnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXBLHiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:23 -0500
Received: from ns1.suse.de ([195.135.220.2]:38393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091AbXBLHiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:08 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [20/39] i386: Small cleanup to TLB flush code
Message-Id: <20070212073807.A9CCA13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Remove outdated comment
- Use cpu_relax() in a busy loop

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/smp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -375,8 +375,7 @@ static void flush_tlb_others(cpumask_t c
 	/*
 	 * i'm not happy about this global shared spinlock in the
 	 * MM hot path, but we'll see how contended it is.
-	 * Temporarily this turns IRQs off, so that lockups are
-	 * detected by the NMI watchdog.
+	 * AK: x86-64 has a faster method that could be ported.
 	 */
 	spin_lock(&tlbstate_lock);
 	
@@ -401,7 +400,7 @@ static void flush_tlb_others(cpumask_t c
 
 	while (!cpus_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
-		mb();
+		cpu_relax();
 
 	flush_mm = NULL;
 	flush_va = 0;

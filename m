Return-Path: <linux-kernel-owner+w=401wt.eu-S940321AbXGaGAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940321AbXGaGAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXGaF7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:59:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:59355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbXGaF7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:59:52 -0400
Subject: [PATCH] i386: flush_cpumask doesn't need "or"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 15:59:42 +1000
Message-Id: <1185861582.5495.424.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Did I miss something or do we needlessly do an "or" to flush_cpumask
while we could just assign it ? We never exit that function with the
mask not empty and we have a spinlock...

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/arch/i386/kernel/smp.c
===================================================================
--- linux-work.orig/arch/i386/kernel/smp.c	2007-07-31 15:54:55.000000000 +1000
+++ linux-work/arch/i386/kernel/smp.c	2007-07-31 15:56:13.000000000 +1000
@@ -375,7 +375,8 @@ void native_flush_tlb_others(const cpuma
 	
 	flush_mm = mm;
 	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+	flush_cpumask = cpumask;
+
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.



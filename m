Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbXH0QEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbXH0QEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbXH0P7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:59:09 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43180 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbXH0P7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:59:07 -0400
Message-Id: <20070827155852.961937802@polymtl.ca>
References: <20070827155601.360241608@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:56:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu
Subject: [patch 09/10] Text Edit Lock - i386 standardize debug rodata
Content-Disposition: inline; filename=text-edit-lock-i386-standardize-debug-rodata.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:58:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize DEBUG_RODATA, removing special cases for hotplug and kprobes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
---
 arch/i386/mm/init.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-08-19 22:28:00.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-08-19 22:34:39.000000000 -0400
@@ -794,23 +794,15 @@ static int noinline do_test_wp_bit(void)
 }
 
 #ifdef CONFIG_DEBUG_RODATA
-
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		change_page_attr(virt_to_page(start),
-		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-		printk("Write protecting the kernel text: %luk\n", size >> 10);
-	}
-#endif
+	change_page_attr(virt_to_page(start),
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
+
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
@@ -826,6 +818,7 @@ void mark_rodata_ro(void)
 	 */
 	global_flush_tlb();
 }
+
 #endif
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

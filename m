Return-Path: <linux-kernel-owner+w=401wt.eu-S1765773AbYDVPSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765773AbYDVPSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYDVPSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:18:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15813 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYDVPSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:18:36 -0400
Message-Id: <480E1DF8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:18:48 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: eliminate duplicate consistency checks
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_32.c |   13 -------------
 1 file changed, 13 deletions(-)

--- linux-2.6.25/arch/x86/mm/init_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-i386-mm-init-cleanup/arch/x86/mm/init_32.c	2008-03-13 13:57:31.000000000 +0100
@@ -576,17 +576,6 @@ void __init mem_init(void)
 #endif
 	bad_ppro = ppro_with_ram_bug();
 
-#ifdef CONFIG_HIGHMEM
-	/* check that fixmap and pkmap do not overlap */
-	if (PKMAP_BASE + LAST_PKMAP*PAGE_SIZE >= FIXADDR_START) {
-		printk(KERN_ERR
-			"fixmap and kmap areas overlap - this will crash\n");
-		printk(KERN_ERR "pkstart: %lxh pkend: %lxh fixstart %lxh\n",
-				PKMAP_BASE, PKMAP_BASE + LAST_PKMAP*PAGE_SIZE,
-				FIXADDR_START);
-		BUG();
-	}
-#endif
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
@@ -619,7 +608,6 @@ void __init mem_init(void)
 		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
 	       );
 
-#if 1 /* double-sanity-check paranoia */
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 #ifdef CONFIG_HIGHMEM
@@ -660,7 +648,6 @@ void __init mem_init(void)
 #endif
 	BUG_ON(VMALLOC_START				> VMALLOC_END);
 	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
-#endif /* double-sanity-check paranoia */
 
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();




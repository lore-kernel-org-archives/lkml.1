Return-Path: <linux-kernel-owner+w=401wt.eu-S966719AbXJSEhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719AbXJSEhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXJSEh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:37:26 -0400
Received: from rex.snapgear.com ([203.143.235.140]:46179 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753132AbXJSEh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:37:26 -0400
Date: Fri, 19 Oct 2007 14:36:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190436.l9J4ai5d004958@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: no separate stack region to report at startup
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no separate stack region addresses to print at startup time,
so remove it from the debug listing

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/kernel/setup.c linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.23/arch/m68knommu/kernel/setup.c	2007-10-19 10:30:54.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c	2007-10-19 10:35:38.000000000 +1000
@@ -188,11 +173,9 @@ void setup_arch(char **cmdline_p)
 		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
 		(int) &_sdata, (int) &_edata,
 		(int) &_sbss, (int) &_ebss);
-	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
-		"STACK=0x%06x-0x%06x\n",
+	printk(KERN_DEBUG "MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
 		(int) &_ebss, (int) memory_start,
-		(int) memory_start, (int) memory_end,
-		(int) memory_end, (int) _ramend);
+		(int) memory_start, (int) memory_end);
 #endif
 
 	/* Keep a copy of command line */

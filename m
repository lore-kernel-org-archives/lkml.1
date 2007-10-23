Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXJWEkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXJWEkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXJWEi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:38:56 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58873 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbXJWEiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:38:55 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsSC001794@goober>
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

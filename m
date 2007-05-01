Return-Path: <linux-kernel-owner+w=401wt.eu-S1423788AbXEAEKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423788AbXEAEKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946594AbXEAEAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:48993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490AbXEAD6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:25 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/30] i386: Drop noisy e820 debugging printks
Message-Id: <20070501035824.D28E413CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/e820.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -393,10 +393,8 @@ int __init sanitize_e820_map(struct e820
 		   ____________________33__
 		   ______________________4_
 	*/
-	printk("sanitize start\n");
 	/* if there's only one memory region, don't bother */
 	if (*pnr_map < 2) {
-		printk("sanitize bail 0\n");
 		return -1;
 	}
 
@@ -405,7 +403,6 @@ int __init sanitize_e820_map(struct e820
 	/* bail out if we find any unreasonable addresses in bios map */
 	for (i=0; i<old_nr; i++)
 		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr) {
-			printk("sanitize bail 1\n");
 			return -1;
 		}
 
@@ -501,7 +498,6 @@ int __init sanitize_e820_map(struct e820
 	memcpy(biosmap, new_bios, new_nr*sizeof(struct e820entry));
 	*pnr_map = new_nr;
 
-	printk("sanitize end\n");
 	return 0;
 }
 
@@ -532,7 +528,6 @@ int __init copy_e820_map(struct e820entr
 		unsigned long long size = biosmap->size;
 		unsigned long long end = start + size;
 		unsigned long type = biosmap->type;
-		printk("copy_e820_map() start: %016Lx size: %016Lx end: %016Lx type: %ld\n", start, size, end, type);
 
 		/* Overflow in 64 bits? Ignore the memory map. */
 		if (start > end)
@@ -543,17 +538,11 @@ int __init copy_e820_map(struct e820entr
 		 * Not right. Fix it up.
 		 */
 		if (type == E820_RAM) {
-			printk("copy_e820_map() type is E820_RAM\n");
 			if (start < 0x100000ULL && end > 0xA0000ULL) {
-				printk("copy_e820_map() lies in range...\n");
-				if (start < 0xA0000ULL) {
-					printk("copy_e820_map() start < 0xA0000ULL\n");
+				if (start < 0xA0000ULL)
 					add_memory_region(start, 0xA0000ULL-start, type);
-				}
-				if (end <= 0x100000ULL) {
-					printk("copy_e820_map() end <= 0x100000ULL\n");
+				if (end <= 0x100000ULL)
 					continue;
-				}
 				start = 0x100000ULL;
 				size = end - start;
 			}

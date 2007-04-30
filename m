Return-Path: <linux-kernel-owner+w=401wt.eu-S1423436AbXD3QBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423436AbXD3QBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423455AbXD3Pz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:55:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:34362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423456AbXD3Ptt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:49 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: randy.dunlap@oracle.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [16/34] i386: fix mtrr sections
Message-Id: <20070430154948.B6DDF151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings in mtrr code.
Fix line length on one source line.

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x103)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x180)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x199)
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text: from .text.get_mtrr_state after 'get_mtrr_state' (at offset 0x1c1)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -38,7 +38,7 @@ static struct mtrr_state mtrr_state = {}
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
-static __initdata int mtrr_show;
+static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
@@ -68,12 +68,13 @@ void mtrr_save_fixed_ranges(void *info)
 	get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
 
 	for (i = 0; i < 8; ++i, ++types, base += step)
-		printk(KERN_INFO "MTRR %05X-%05X %s\n", base, base + step - 1, mtrr_attrib_to_str(*types));
+		printk(KERN_INFO "MTRR %05X-%05X %s\n",
+			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */

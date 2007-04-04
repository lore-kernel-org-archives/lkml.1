Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXDDDXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXDDDXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXDDDXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:23:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22329 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258AbXDDDXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:23:22 -0400
Date: Tue, 3 Apr 2007 20:24:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ak@suse.de
Subject: [PATCH -mm] fix mtrr sections
Message-Id: <20070403202428.3b55a8e3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
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
---
 arch/i386/kernel/cpu/mtrr/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc5-mm4.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux-2.6.21-rc5-mm4/arch/i386/kernel/cpu/mtrr/generic.c
@@ -26,7 +26,7 @@ static struct mtrr_state mtrr_state = {}
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
-static __initdata int mtrr_show;
+static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
@@ -51,12 +51,13 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
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

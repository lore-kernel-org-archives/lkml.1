Return-Path: <linux-kernel-owner+w=401wt.eu-S966267AbXDDBhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966267AbXDDBhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966252AbXDDBfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:55 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34558 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966249AbXDDBfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:32 -0400
X-Greylist: delayed 1138 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 21:35:31 EDT
Message-Id: <20070404011453.598418421@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:06:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 4/6] Rename the parainstructions symbols to be consistent with the others
Content-Disposition: inline; filename=fix-parainstructions-name.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The other symbols used to delineate the alt-instructions sections have
the form __foo/__foo_end.  Rename parainstructions to match.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/kernel/alternative.c |    6 +++---
 arch/i386/kernel/vmi.c         |    6 +++---
 arch/i386/kernel/vmlinux.lds.S |    4 ++--
 include/asm-i386/alternative.h |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -327,8 +327,8 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
+extern struct paravirt_patch __parainstructions[],
+	__parainstructions_end[];
 #endif	/* CONFIG_PARAVIRT */
 
 void __init alternative_instructions(void)
@@ -367,6 +367,6 @@ void __init alternative_instructions(voi
 		alternatives_smp_switch(0);
 	}
 #endif
- 	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+ 	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -72,8 +72,8 @@ static struct {
 } vmi_ops;
 
 /* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
+extern struct paravirt_patch __parainstructions[],
+	__parainstructions_end[];
 
 /*
  * VMI patching routines.
@@ -917,7 +917,7 @@ static inline int __init activate_vmi(vo
 	 * to do this before IRQs get reenabled.  Fortunately, it is
 	 * idempotent.
 	 */
-	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+	apply_paravirt(__parainstructions, __parainstructions_end);
 
 	vmi_bringup();
 
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -166,9 +166,9 @@ SECTIONS
   }
   . = ALIGN(4);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__start_parainstructions = .;
+  	__parainstructions = .;
 	*(.parainstructions)
-  	__stop_parainstructions = .;
+  	__parainstructions_end = .;
   }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
===================================================================
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -121,8 +121,8 @@ static inline void
 static inline void
 apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions	NULL
+#define __parainstructions_end	NULL
 #endif
 
 #endif /* _I386_ALTERNATIVE_H */

-- 


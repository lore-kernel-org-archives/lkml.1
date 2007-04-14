Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXDNVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXDNVZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXDNVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:49 -0400
Received: from gw.goop.org ([64.81.55.164]:59558 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbXDNVUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:20 -0400
Message-Id: <20070414204925.262100710@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 25/28] From: Jeremy Fitzhardinge <jeremy@goop.org>
Content-Disposition: inline; filename=rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The other symbols used to delineate the alt-instructions sections have the
form __foo/__foo_end.  Rename parainstructions to match.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/i386/kernel/alternative.c |    2 +-
 arch/i386/kernel/vmi.c         |    6 +++---
 arch/i386/kernel/vmlinux.lds.S |    4 ++--
 include/asm-i386/alternative.h |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -386,6 +386,6 @@ void __init alternative_instructions(voi
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
@@ -74,8 +74,8 @@ static struct {
 } vmi_ops;
 
 /* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
+extern struct paravirt_patch __parainstructions[],
+	__parainstructions_end[];
 
 /* Cached VMI operations */
 struct vmi_timer_ops vmi_timer_ops;
@@ -909,7 +909,7 @@ static inline int __init activate_vmi(vo
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
@@ -124,8 +124,8 @@ apply_paravirt(struct paravirt_patch_sit
 apply_paravirt(struct paravirt_patch_site *start,
 	       struct paravirt_patch_site *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions	NULL
+#define __parainstructions_end	NULL
 #endif
 
 #endif /* _I386_ALTERNATIVE_H */

-- 


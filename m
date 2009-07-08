Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZGHWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZGHWdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZGHWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbZGHWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:43 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [5/8] x86: mce: Move code in mce.c
Message-Id: <20090708223142.306CD1D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the X86_OLD_MCE ifdefs are gone move some code that
used to be outside the big ifdef to a more natural place
near its user.

No code change.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -45,17 +45,6 @@
 
 #include "mce-internal.h"
 
-/* Handle unconfigured int18 (should never happen) */
-static void unexpected_machine_check(struct pt_regs *regs, long error_code)
-{
-	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n",
-	       smp_processor_id());
-}
-
-/* Call the installed machine check handler for this CPU setup. */
-void (*machine_check_vector)(struct pt_regs *, long error_code) =
-						unexpected_machine_check;
-
 int mce_disabled __read_mostly;
 
 #define MISC_MCELOG_MINOR	227
@@ -1322,6 +1311,17 @@ static void mce_init_timer(void)
 	add_timer(t);
 }
 
+/* Handle unconfigured int18 (should never happen) */
+static void unexpected_machine_check(struct pt_regs *regs, long error_code)
+{
+	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n",
+	       smp_processor_id());
+}
+
+/* Call the installed machine check handler for this CPU setup. */
+void (*machine_check_vector)(struct pt_regs *, long error_code) =
+						unexpected_machine_check;
+
 /*
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off:

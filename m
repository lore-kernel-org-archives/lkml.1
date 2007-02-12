Return-Path: <linux-kernel-owner+w=401wt.eu-S964995AbXBLQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995AbXBLQyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965003AbXBLQwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:03 -0500
Received: from ns1.suse.de ([195.135.220.2]:47980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964973AbXBLQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:52 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [26/29] i386: Move mce_disabled to asm/mce.h
Message-Id: <20070212165147.311B113F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>
Allows external actors to disable mce.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

===================================================================
---
 arch/i386/kernel/cpu/mcheck/mce.h |    2 +-
 include/asm-i386/mce.h            |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/mcheck/mce.h
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/mce.h
+++ linux/arch/i386/kernel/cpu/mcheck/mce.h
@@ -1,4 +1,5 @@
 #include <linux/init.h>
+#include <asm/mce.h>
 
 void amd_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
@@ -9,6 +10,5 @@ void winchip_mcheck_init(struct cpuinfo_
 /* Call the installed machine check handler for this CPU setup. */
 extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-extern int mce_disabled;
 extern int nr_mce_banks;
 
Index: linux/include/asm-i386/mce.h
===================================================================
--- linux.orig/include/asm-i386/mce.h
+++ linux/include/asm-i386/mce.h
@@ -3,3 +3,5 @@ extern void mcheck_init(struct cpuinfo_x
 #else
 #define mcheck_init(c) do {} while(0)
 #endif
+
+extern int mce_disabled;

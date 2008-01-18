Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbYARR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbYARR2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbYARR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:35686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761685AbYARR1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:20 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/7] Don't disable RDTSC in userland for 32bit notsc
Message-Id: <20080118172719.76B7C14AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modern 32bit userland doesn't even boot when the TSC is disabled
because ld.so tends to contain RDTSCs.  So make notsc only effective for the 
kernel, similar to 64bit.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/common.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -654,7 +654,6 @@ void __cpuinit cpu_init(void)
 		printk(KERN_NOTICE "Disabling TSC...\n");
 		/**** FIX-HPA: DOES THIS REALLY BELONG HERE? ****/
 		clear_bit(X86_FEATURE_TSC, boot_cpu_data.x86_capability);
-		set_in_cr4(X86_CR4_TSD);
 	}
 
 	load_idt(&idt_descr);

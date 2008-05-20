Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbYETEJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbYETEJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYETEJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:09:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYETEJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:09:47 -0400
Date: Tue, 20 May 2008 00:09:35 -0400
Message-Id: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Remove unnecessary code in 64bit CPU identification.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were no 64bit Transmeta CPUs made (and it'd be something of
a surprise if they started any time soon).   To the best of my knowledge,
no CPU vendor cloned the 80860000 cpuid space claimed by Transmeta.
By removing this code, we can also eliminate calling cpuid 0x80000007 twice.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index ff62838..0380726 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1042,20 +1042,11 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 		}
 		if (xlvl >= 0x80000004)
 			get_model_name(c); /* Default name */
-	}
 
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		/* Don't set x86_cpuid_level here for now to not confuse. */
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
+		if (xlvl >= 0x80000007)
+			c->x86_power = cpuid_edx(0x80000007);
 	}
 
-	c->extended_cpuid_level = cpuid_eax(0x80000000);
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);



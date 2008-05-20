Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYETEKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYETEKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYETEJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:09:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYETEJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:09:47 -0400
Date: Tue, 20 May 2008 00:09:31 -0400
Message-Id: <200805200409.m4K49V3G024332@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Add recent Centaur CPUs to PAT whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From conversation with Centaur engineers, both the newer generations
of the VIA C7, and their future CPUs support PAT, with no known errata.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..638a3a6 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -62,6 +81,10 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
 			return;
 		break;
+	case X86_VENDOR_CENTAUR:
+		if ((c->x86 > 6) || (c->x86 == 6 && c->x86_model >= 10))
+			set_cpu_cap(c, X86_FEATURE_PAT);
+		break;
 	}
 
 	pat_disable(cpu_has_pat ?

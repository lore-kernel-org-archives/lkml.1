Return-Path: <linux-kernel-owner+w=401wt.eu-S1765012AbYASEc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765012AbYASEc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761840AbYASEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:32:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:53154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975AbYASEcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:32:20 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080119532.133547000@suse.de>
To: davej@codemonkey.org.uk, mingo@elte.hu, tglx@linutronix.de,
       jesse.barnes@intel.com, andreas.herrmann3@amd.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] Fix some inaccurate comments in MTRR checking code
Date: Sat, 19 Jan 2008 05:32:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- is_cpu(INTEL) actually refers only to the MTRR architecture
and all AMD CPUs since K7 use the Intel MTRR architecture so the
fixup code runs on AMD too. Remove a comment claiming otherwise.

[Perhaps is_cpu should be renamed, the name is clearly confusing]

- Clarify another incorrect comment.

Cc: davej@codemonkey.org.uk
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mtrr/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux/arch/x86/kernel/cpu/mtrr/main.c
@@ -640,6 +640,8 @@ early_param("disable_mtrr_trim", disable
  * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
  * memory configurations.  This routine checks to make sure the MTRRs having
  * a write back type cover all of the memory the kernel is intending to use.
+ * [AK: actually it doesn't check that. It just checks that the highest
+ * MTRR is matching the end of memory. That is not quite the same.]
  * If not, it'll trim any memory off the end by adjusting end_pfn, removing
  * it from the kernel's allocation pools, warning the user with an obnoxious
  * message.
@@ -649,7 +651,6 @@ void __init mtrr_trim_uncached_memory(vo
 	unsigned long i, base, size, highest_addr = 0, def, dummy;
 	mtrr_type type;
 
-	/* Make sure we only trim uncachable memory on Intel machines */
 	rdmsr(MTRRdefType_MSR, def, dummy);
 	def &= 0xff;
 	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)

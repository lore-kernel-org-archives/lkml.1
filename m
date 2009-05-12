Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZELPsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZELPsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZELPrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:51113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248AbZELPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:40 -0400
Subject: [PATCH 6/10 -tip] x86: early_init_intel() user of Advanced Power
 Management features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142849.2547.19.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam>  <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:11:48 +0530
Message-Id: <1242142908.2547.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use X86_FEATURE_CONSTANT_TSC to determine TSC Invariance

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7437fa1..62130a0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,14 +61,14 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
 	 *
 	 * It is also reliable across cores and sockets. (but not across
 	 * cabinets - we turn it off in that case explicitly.)
 	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 		sched_clock_stable = 1;
-- 
1.6.0.6




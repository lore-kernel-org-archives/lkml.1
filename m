Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZETHiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZETHiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZETHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:38:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:35801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZETHiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:38:15 -0400
Message-ID: <4A13B344.7030307@kernel.org>
Date: Wed, 20 May 2009 00:37:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: enable_update_mptable should MACRO
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <4A12E759.6040806@kernel.org> <20090520071900.GB11952@elte.hu>
In-Reply-To: <20090520071900.GB11952@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



instead of declare as one inline function.
because other case that is variable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -61,9 +61,11 @@ extern void get_smp_config(void);
 #ifdef CONFIG_X86_MPPARSE
 extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
+extern int enable_update_mptable;
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
+#define enable_update_mptable 0
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
@@ -87,15 +89,6 @@ static inline int acpi_probe_gsi(void)
 }
 #endif /* CONFIG_ACPI */
 
-#ifdef CONFIG_X86_MPPARSE
-extern int enable_update_mptable;
-#else
-static inline int enable_update_mptable(void)
-{
-	return 0;
-}
-#endif
-
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
 struct physid_mask {

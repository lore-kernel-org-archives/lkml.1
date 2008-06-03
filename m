Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYFCRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYFCRhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYFCRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:37:28 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58211 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYFCRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:37:26 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K1WE9N-01-AN4-01
In-Reply-To: <20080602143830.GA6835@elte.hu>
References: <20080602143830.GA6835@elte.hu>
From: Robert Richter <robert.richter@amd.com>
Subject: [PATCH] fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <20080603173705.1790F8316@erda.amd.com>
Date: Tue, 3 Jun 2008 19:37:04 +0200
X-OriginalArrivalTime: 03 Jun 2008 17:37:05.0319 (UTC) FILETIME=[7083E370:01C8C5A0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/powerpc/kernel/setup_64.c |    2 --
 arch/x86/kernel/cpu/amd.c      |    1 -
 arch/x86/kernel/cpu/amd_64.c   |    1 +
 arch/x86/kernel/setup.c        |    4 ++--
 include/asm-x86/mmconfig.h     |    6 ------
 5 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 098fd96..3a193a9 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -62,8 +62,6 @@
 #include <asm/udbg.h>
 #include <asm/kexec.h>
 
-#include "setup.h"
-
 #ifdef DEBUG
 #define DBG(fmt...) udbg_printf(fmt)
 #else
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 656b40a..99221f9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -4,7 +4,6 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
-#include <asm/mmconfig.h>
 
 #include <mach_apic.h>
 #include "../setup.h"
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 180097e..6c63496 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -6,6 +6,7 @@
 #include <asm/cacheflush.h>
 
 #include <mach_apic.h>
+#include "../setup.h"
 
 extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
 extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 549e6e6..a7185ac 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -204,6 +204,8 @@ void __init setup_per_cpu_areas(void)
 	setup_cpumask_of_cpu();
 }
 
+#endif
+
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
 void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
@@ -217,8 +219,6 @@ void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
 }
 
-#endif
-
 #ifdef X86_64_NUMA
 
 /*
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index 691798f..95beda0 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -9,10 +9,4 @@ static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
 #endif
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_64)
-extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
-#else
-static inline void amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c) { }
-#endif
-
 #endif
-- 
1.5.5.1



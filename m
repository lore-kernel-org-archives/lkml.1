Return-Path: <linux-kernel-owner+w=401wt.eu-S1762467AbYFES5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467AbYFES5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYFES50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:57:26 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6133 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYFES5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:57:25 -0400
X-BigFish: VPS2(zzzz10d3izzz32i67h)
X-Spam-TCS-SCL: 6:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K207B1-01-UR8-01
In-Reply-To: <20080604151131.GV23679@erda.amd.com>
References: <20080604151131.GV23679@erda.amd.com>
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 5 Jun 2008 19:32:55 +0200
Subject: [PATCH] fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <20080605185706.35A3B806B@erda.amd.com>
X-OriginalArrivalTime: 05 Jun 2008 18:57:07.0459 (UTC) FILETIME=[F3A3CD30:01C8C73D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/amd.c    |    1 -
 arch/x86/kernel/cpu/amd_64.c |    1 +
 arch/x86/kernel/setup.c      |    4 ++--
 arch/x86/kernel/setup_64.c   |    2 --
 include/asm-x86/mmconfig.h   |    6 ------
 5 files changed, 3 insertions(+), 11 deletions(-)

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
index d8f1712..f2dc414 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -136,6 +136,8 @@ void __init setup_per_cpu_areas(void)
 	setup_cpumask_of_cpu();
 }
 
+#endif
+
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
 void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
@@ -148,5 +150,3 @@ void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
 	}
 	set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
 }
-
-#endif
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 215bd67..25afdd8 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -73,8 +73,6 @@
 #include <asm/pat.h>
 #include <asm/mmconfig.h>
 
-#include "setup.h"
-
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
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
1.5.5.3



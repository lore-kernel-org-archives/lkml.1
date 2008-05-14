Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYENPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYENPCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYENPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:02:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51176 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756616AbYENPCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:02:12 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: Move es7000_plat out of mpparse.c
Date: Wed, 14 May 2008 19:02:51 +0400
Message-ID: <20080514150251.24443.5516.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/mpparse.c         |   11 ++++++-----
 arch/x86/mach-es7000/es7000plat.c |    2 ++
 include/asm-x86/system.h          |    1 -
 3 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5a18b2b..ff13423 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -793,15 +793,14 @@ void __init find_smp_config(void)
                             ACPI-based MP Configuration
    -------------------------------------------------------------------------- */
 
-/*
- * Keep this outside and initialized to 0, for !CONFIG_ACPI builds:
- */
-int es7000_plat;
-
 #ifdef CONFIG_ACPI
 
 #ifdef	CONFIG_X86_IO_APIC
 
+#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
+extern int es7000_plat;
+#endif
+
 #define MP_ISA_BUS		0
 
 static struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
@@ -928,11 +927,13 @@ void __init mp_config_acpi_legacy_irqs(void)
 	set_bit(MP_ISA_BUS, mp_bus_not_pci);
 	Dprintk("Bus #%d is ISA\n", MP_ISA_BUS);
 
+#if defined(CONFIG_X86_ES7000) || defined(CONFIG_X86_GENERICARCH)
 	/*
 	 * Older generations of ES7000 have no legacy identity mappings
 	 */
 	if (es7000_plat == 1)
 		return;
+#endif
 
 	/*
 	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
diff --git a/arch/x86/mach-es7000/es7000plat.c b/arch/x86/mach-es7000/es7000plat.c
index f5d6f7d..a41c77a 100644
--- a/arch/x86/mach-es7000/es7000plat.c
+++ b/arch/x86/mach-es7000/es7000plat.c
@@ -52,6 +52,8 @@ static struct mip_reg		*host_reg;
 static int 			mip_port;
 static unsigned long		mip_addr, host_addr;
 
+int es7000_plat;
+
 /*
  * GSI override for ES7000 platforms.
  */
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index df7133c..0cc278d 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -318,7 +318,6 @@ static inline void clflush(volatile void *__p)
 void disable_hlt(void);
 void enable_hlt(void);
 
-extern int es7000_plat;
 void cpu_idle_wait(void);
 
 extern unsigned long arch_align_stack(unsigned long sp);


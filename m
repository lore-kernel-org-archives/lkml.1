Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbZA2AQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbZA2AQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZA1Xq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740AbZA1XqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:22 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 082/114] x86: move mach-default/*.h files to asm/
Date: Wed, 28 Jan 2009 23:42:28 +0000
Message-Id: <1233186180-29883-83-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are getting rid of subarchitecture support - move the hook files
to asm/. (These are now stale and should be replaced with more explicit
runtime mechanisms - but the transition is simpler this way.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/{mach-default => }/apm.h      |    0
 arch/x86/include/asm/{mach-default => }/do_timer.h |    0
 .../include/asm/{mach-default => }/entry_arch.h    |    5 +++++
 .../include/asm/{mach-default => }/mach_timer.h    |    0
 .../include/asm/{mach-default => }/mach_traps.h    |    0
 .../include/asm/{mach-default => }/pci-functions.h |    0
 .../include/asm/{mach-default => }/setup_arch.h    |    0
 .../include/asm/{mach-default => }/smpboot_hooks.h |    0
 arch/x86/kernel/apm_32.c                           |    2 +-
 arch/x86/kernel/entry_32.S                         |    2 +-
 arch/x86/kernel/nmi.c                              |    2 +-
 arch/x86/kernel/probe_roms_32.c                    |    2 +-
 arch/x86/kernel/setup.c                            |    2 +-
 arch/x86/kernel/smpboot.c                          |    2 +-
 arch/x86/kernel/time_32.c                          |    2 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/pci/pcbios.c                              |    2 +-
 drivers/clocksource/acpi_pm.c                      |    2 +-
 drivers/clocksource/cyclone.c                      |    2 +-
 19 files changed, 16 insertions(+), 11 deletions(-)
 rename arch/x86/include/asm/{mach-default => }/apm.h (100%)
 rename arch/x86/include/asm/{mach-default => }/do_timer.h (100%)
 rename arch/x86/include/asm/{mach-default => }/entry_arch.h (95%)
 rename arch/x86/include/asm/{mach-default => }/mach_timer.h (100%)
 rename arch/x86/include/asm/{mach-default => }/mach_traps.h (100%)
 rename arch/x86/include/asm/{mach-default => }/pci-functions.h (100%)
 rename arch/x86/include/asm/{mach-default => }/setup_arch.h (100%)
 rename arch/x86/include/asm/{mach-default => }/smpboot_hooks.h (100%)

diff --git a/arch/x86/include/asm/mach-default/apm.h b/arch/x86/include/asm/apm.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/apm.h
rename to arch/x86/include/asm/apm.h
diff --git a/arch/x86/include/asm/mach-default/do_timer.h b/arch/x86/include/asm/do_timer.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/do_timer.h
rename to arch/x86/include/asm/do_timer.h
diff --git a/arch/x86/include/asm/mach-default/entry_arch.h b/arch/x86/include/asm/entry_arch.h
similarity index 95%
rename from arch/x86/include/asm/mach-default/entry_arch.h
rename to arch/x86/include/asm/entry_arch.h
index 6fa399a..b87b077 100644
--- a/arch/x86/include/asm/mach-default/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -41,10 +41,15 @@ BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
  * a much simpler SMP time architecture:
  */
 #ifdef CONFIG_X86_LOCAL_APIC
+
 BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
+#ifdef CONFIG_PERF_COUNTERS
+BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+#endif
+
 #ifdef CONFIG_X86_MCE_P4THERMAL
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
diff --git a/arch/x86/include/asm/mach-default/mach_timer.h b/arch/x86/include/asm/mach_timer.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/mach_timer.h
rename to arch/x86/include/asm/mach_timer.h
diff --git a/arch/x86/include/asm/mach-default/mach_traps.h b/arch/x86/include/asm/mach_traps.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/mach_traps.h
rename to arch/x86/include/asm/mach_traps.h
diff --git a/arch/x86/include/asm/mach-default/pci-functions.h b/arch/x86/include/asm/pci-functions.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/pci-functions.h
rename to arch/x86/include/asm/pci-functions.h
diff --git a/arch/x86/include/asm/mach-default/setup_arch.h b/arch/x86/include/asm/setup_arch.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/setup_arch.h
rename to arch/x86/include/asm/setup_arch.h
diff --git a/arch/x86/include/asm/mach-default/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
similarity index 100%
rename from arch/x86/include/asm/mach-default/smpboot_hooks.h
rename to arch/x86/include/asm/smpboot_hooks.h
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 98807bb..37ba5f8 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -301,7 +301,7 @@ extern int (*console_blank_hook)(int);
  */
 #define APM_ZERO_SEGS
 
-#include "apm.h"
+#include <asm/apm.h>
 
 /*
  * Define to re-initialize the interrupt 0 timer to 100 Hz after a suspend.
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a0b91aa..65efd42 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -688,7 +688,7 @@ ENDPROC(name)
 #define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
 
 /* The include is where all of the SMP etc. interrupts come from */
-#include "entry_arch.h"
+#include <asm/entry_arch.h>
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 23b6d9e..bdfad80 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -34,7 +34,7 @@
 
 #include <asm/mce.h>
 
-#include <mach_traps.h>
+#include <asm/mach_traps.h>
 
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
index 675a48c..071e7fe 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms_32.c
@@ -18,7 +18,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/io.h>
-#include <setup_arch.h>
+#include <asm/setup_arch.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 92e4293..e645d47 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -81,7 +81,7 @@
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/vmi.h>
-#include <setup_arch.h>
+#include <asm/setup_arch.h>
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 489fde9..e90b3e5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -66,7 +66,7 @@
 #include <linux/mc146818rtc.h>
 
 #include <asm/genapic.h>
-#include <smpboot_hooks.h>
+#include <asm/smpboot_hooks.h>
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 3985cac..764c74e 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -38,7 +38,7 @@
 #include <asm/time.h>
 #include <asm/timer.h>
 
-#include "do_timer.h"
+#include <asm/do_timer.h>
 
 int timer_ack;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ed5aee5..214bc32 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -54,7 +54,7 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 
-#include <mach_traps.h>
+#include <asm/mach_traps.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/pgalloc.h>
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index b82cae9..1c975cc 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
-#include <asm/mach-default/pci-functions.h>
+#include <asm/pci-functions.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index e1129fa..ee19b6e 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -143,7 +143,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
 #endif
 
 #ifndef CONFIG_X86_64
-#include "mach_timer.h"
+#include <asm/mach_timer.h>
 #define PMTMR_EXPECTED_RATE \
   ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
 /*
diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 1bde303..8615059 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -7,7 +7,7 @@
 #include <asm/pgtable.h>
 #include <asm/io.h>
 
-#include "mach_timer.h"
+#include <asm/mach_timer.h>
 
 #define CYCLONE_CBAR_ADDR	0xFEB00CD0	/* base address ptr */
 #define CYCLONE_PMCC_OFFSET	0x51A0		/* offset to control register */
-- 
1.6.0.2


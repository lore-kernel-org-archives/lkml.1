Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYABSbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYABSbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYABSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:31:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:37714 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYABSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:31:31 -0500
Message-ID: <477BD875.2090508@ct.jp.nec.com>
Date: Wed, 02 Jan 2008 10:31:17 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: clean up apic_32/64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

White space and coding style clean up.
Make apic_32/64.c similar.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/apic_32.c |    5 ++---
 arch/x86/kernel/apic_64.c |   23 +++++++++++++++++------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 2865792..1e417df 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -577,7 +577,6 @@ static void local_apic_timer_interrupt(void)
  * [ if a single-CPU system runs an SMP kernel then we call the local
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
-
 void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
@@ -1021,7 +1020,7 @@ void __cpuinit setup_local_APIC(void)
 /*
  * Detect and initialize APIC
  */
-static int __init detect_init_APIC (void)
+static int __init detect_init_APIC(void)
 {
 	u32 h, l, features;
 
@@ -1165,7 +1164,7 @@ fake_ioapic_page:
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-int __init APIC_init_uniprocessor (void)
+int __init APIC_init_uniprocessor(void)
 {
 	if (enable_local_apic < 0)
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9439aa3..286a396 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -23,33 +23,37 @@
 #include <linux/mc146818rtc.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
-#include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
+#include <linux/module.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
+#include <asm/hpet.h>
 #include <asm/pgalloc.h>
 #include <asm/mach_apic.h>
 #include <asm/nmi.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
 #include <asm/timex.h>
-#include <asm/hpet.h>
 #include <asm/apic.h>
 
-int apic_verbosity;
 int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
 
-/* Local APIC timer works in C2? */
+/* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
+/*
+ * Debug level, exported for io_apic.c
+ */
+int apic_verbosity;
+
 static struct resource lapic_resource = {
 	.name = "Local APIC",
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
@@ -355,6 +359,11 @@ static void __init calibrate_APIC_clock(void)
 	calibration_result = result / HZ;
 }
 
+/*
+ * Setup the boot APIC
+ *
+ * Calibrate and verify the result.
+ */
 void __init setup_boot_APIC_clock(void)
 {
 	/*
@@ -1109,8 +1118,8 @@ static struct sysdev_class lapic_sysclass = {
 };
 
 static struct sys_device device_lapic = {
-	.id		= 0,
-	.cls		= &lapic_sysclass,
+	.id	= 0,
+	.cls	= &lapic_sysclass,
 };
 
 static void __cpuinit apic_pm_activate(void)
@@ -1121,9 +1130,11 @@ static void __cpuinit apic_pm_activate(void)
 static int __init init_lapic_sysfs(void)
 {
 	int error;
+
 	if (!cpu_has_apic)
 		return 0;
 	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
+
 	error = sysdev_class_register(&lapic_sysclass);
 	if (!error)
 		error = sysdev_register(&device_lapic);
-- 
1.5.3.6


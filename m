Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbZFOIXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbZFOIXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZFOIXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:23:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47800 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZFOIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:23:34 -0400
Message-ID: <4A360500.3070800@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:23:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/16] x86, mce: unify smp_thermal_interrupt, prepare p4
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused argument regs from handlers, and use inc_irq_stat.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/p4.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 8d3e40e..ddeed6e 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -35,7 +35,7 @@ static int mce_num_extended_msrs;
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
 
-static void unexpected_thermal_interrupt(struct pt_regs *regs)
+static void unexpected_thermal_interrupt(void)
 {
 	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
 			smp_processor_id());
@@ -43,7 +43,7 @@ static void unexpected_thermal_interrupt(struct pt_regs *regs)
 }
 
 /* P4/Xeon Thermal transition interrupt handler: */
-static void intel_thermal_interrupt(struct pt_regs *regs)
+static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
@@ -54,14 +54,13 @@ static void intel_thermal_interrupt(struct pt_regs *regs)
 }
 
 /* Thermal interrupt handler for this CPU setup: */
-static void (*vendor_thermal_interrupt)(struct pt_regs *regs) =
-						unexpected_thermal_interrupt;
+static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
 
 void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
-	vendor_thermal_interrupt(regs);
-	__get_cpu_var(irq_stat).irq_thermal_count++;
+	vendor_thermal_interrupt();
+	inc_irq_stat(irq_thermal_count);
 	irq_exit();
 }
 
-- 
1.6.3



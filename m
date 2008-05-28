Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYE1Bty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYE1Bty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYE1Bto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:49:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36355 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYE1Btn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:49:43 -0400
Message-ID: <483CBA33.5080104@ct.jp.nec.com>
Date: Tue, 27 May 2008 18:49:39 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: coding style fixes for nmi.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

before
	total: 1 errors, 6 warnings, 534 lines checked
after
	total: 0 errors, 1 warnings, 532 lines checked

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
cleanup for unified nmi.c

 arch/x86/kernel/nmi.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 9b02b0d..9ecf56f 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -23,9 +23,8 @@
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
+#include <linux/smp.h>
 
-#include <asm/smp.h>
-#include <asm/nmi.h>
 #include <asm/proto.h>
 #include <asm/timer.h>
 
@@ -45,13 +44,16 @@ static cpumask_t backtrace_mask = CPU_MASK_NONE;
  *  0: the lapic NMI watchdog is disabled, but can be enabled
  */
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
-static int panic_on_timeout;
+EXPORT_SYMBOL(nmi_active);
 
 unsigned int nmi_watchdog = NMI_DEFAULT;
+EXPORT_SYMBOL(nmi_watchdog);
+
+static int panic_on_timeout;
 
 static unsigned int nmi_hz = HZ;
 static DEFINE_PER_CPU(short, wd_enabled);
-static int endflag __initdata = 0;
+static int endflag __initdata;
 
 static inline unsigned int get_nmi_count(int cpu)
 {
@@ -410,7 +412,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
-		printk("NMI backtrace for cpu %d\n", cpu);
+		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		dump_stack();
 		spin_unlock(&lock);
 		cpu_clear(cpu, backtrace_mask);
@@ -528,7 +530,3 @@ void __trigger_all_cpu_backtrace(void)
 		mdelay(1);
 	}
 }
-
-EXPORT_SYMBOL(nmi_active);
-EXPORT_SYMBOL(nmi_watchdog);
-
-- 
1.5.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZFEIQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZFEIQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZFEIG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37516 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbZFEIFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 28/62] Blackfin: do not append newlines to panic() messages
Date: Fri,  5 Jun 2009 04:04:37 -0400
Message-Id: <1244189111-19639-29-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic() function already handles newlines for us.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c   |    8 ++++----
 arch/blackfin/kernel/traps.c   |    4 ++--
 arch/blackfin/mach-bf561/smp.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 0838eaf..5a4a036 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -477,7 +477,7 @@ static __init void memory_setup(void)
 
 	if (DMA_UNCACHED_REGION > (_ramend - _ramstart)) {
 		console_init();
-		panic("DMA region exceeds memory limit: %lu.\n",
+		panic("DMA region exceeds memory limit: %lu.",
 			_ramend - _ramstart);
 	}
 	memory_end = _ramend - DMA_UNCACHED_REGION;
@@ -531,7 +531,7 @@ static __init void memory_setup(void)
 
 	if (mtd_size == 0) {
 		console_init();
-		panic("Don't boot kernel without rootfs attached.\n");
+		panic("Don't boot kernel without rootfs attached.");
 	}
 
 	/* Relocate MTD image to the top of memory after the uncached memory area */
@@ -886,7 +886,7 @@ void __init setup_arch(char **cmdline_p)
 				printk(KERN_ERR "Warning: Compiled for Rev %d, but running on Rev %d\n",
 				       bfin_compiled_revid(), bfin_revid());
 				if (bfin_compiled_revid() > bfin_revid())
-					panic("Error: you are missing anomaly workarounds for this rev\n");
+					panic("Error: you are missing anomaly workarounds for this rev");
 			}
 		}
 		if (bfin_revid() < CONFIG_BF_REV_MIN || bfin_revid() > CONFIG_BF_REV_MAX)
@@ -896,7 +896,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* We can't run on BF548-0.1 due to ANOMALY 05000448 */
 	if (bfin_cpuid() == 0x27de && bfin_revid() == 1)
-		panic("You can't run on this processor due to 05000448\n");
+		panic("You can't run on this processor due to 05000448");
 
 	printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index ffe7fb5..fb57742 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -222,7 +222,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 		show_regs(fp);
 	}
 #endif
-	panic("Double Fault - unrecoverable event\n");
+	panic("Double Fault - unrecoverable event");
 
 }
 
@@ -1246,5 +1246,5 @@ void panic_cplb_error(int cplb_panic, struct pt_regs *fp)
 	dump_bfin_mem(fp);
 	show_regs(fp);
 	dump_stack();
-	panic("Unrecoverable event\n");
+	panic("Unrecoverable event");
 }
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index 9b27e69..4ea13d2 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -135,7 +135,7 @@ void __init platform_request_ipi(irq_handler_t handler)
 	ret = request_irq(IRQ_SUPPLE_0, handler, IRQF_DISABLED,
 			  "SMP interrupt", handler);
 	if (ret)
-		panic("Cannot request supplemental interrupt 0 for IPI service\n");
+		panic("Cannot request supplemental interrupt 0 for IPI service");
 }
 
 void platform_send_ipi(cpumask_t callmap)
-- 
1.6.3.1


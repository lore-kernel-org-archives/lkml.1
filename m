Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZD0Jtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZD0Jtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZD0JsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:23 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754131AbZD0JsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:22 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/30] microblaze_mmu_v1: Alocate TLB for early console
Date: Mon, 27 Apr 2009 10:31:54 +0200
Message-Id: <1240821139-7247-6-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-5-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/setup.h   |   10 ++++++++--
 arch/microblaze/kernel/early_printk.c |    3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/include/asm/setup.h b/arch/microblaze/include/asm/setup.h
index 9b98e8e..27f8daf 100644
--- a/arch/microblaze/include/asm/setup.h
+++ b/arch/microblaze/include/asm/setup.h
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -18,7 +19,6 @@
 extern unsigned int boot_cpuid; /* move to smp.h */
 
 extern char cmd_line[COMMAND_LINE_SIZE];
-#  endif/* __KERNEL__ */
 
 void early_printk(const char *fmt, ...);
 
@@ -30,6 +30,11 @@ void setup_heartbeat(void);
 
 unsigned long long sched_clock(void);
 
+#   ifdef CONFIG_MMU
+extern void mmu_reset(void);
+extern void early_console_reg_tlb_alloc(unsigned int addr);
+#   endif /* CONFIG_MMU */
+
 void time_init(void);
 void init_IRQ(void);
 void machine_early_init(const char *cmdline, unsigned int ram,
@@ -40,5 +45,6 @@ void machine_shutdown(void);
 void machine_halt(void);
 void machine_power_off(void);
 
+#  endif/* __KERNEL__ */
 # endif /* __ASSEMBLY__ */
 #endif /* _ASM_MICROBLAZE_SETUP_H */
diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index 4b0f0fd..7de8492 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -87,6 +87,9 @@ int __init setup_early_printk(char *opt)
 	base_addr = early_uartlite_console();
 	if (base_addr) {
 		early_console_initialized = 1;
+#ifdef CONFIG_MMU
+		early_console_reg_tlb_alloc(base_addr);
+#endif
 		early_printk("early_printk_console is enabled at 0x%08x\n",
 							base_addr);
 
-- 
1.5.5.1


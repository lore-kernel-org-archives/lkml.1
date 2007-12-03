Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbXLFMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbXLFMzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXLFMod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:33 -0500
Received: from nic2.axis.se ([193.13.178.10]:45015 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXLFMoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:32 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <b7459b0dc261cc213217c3f321167ea226292d94.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Mon, 3 Dec 2007 10:54:15 +0100
Subject: [PATCH 42/47] Minor updates to CRISv32 kernel/process.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths for machine dependent header files.
- Remove unused extern declaration of etrax_gpio_wake_up_check.
- Register name for first timer is now regi_timer0.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/process.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index b72a155..3933c04 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -12,17 +12,13 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/timer_defs.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/timer_defs.h>
+#include <hwregs/intr_vect_defs.h>
 
 extern void stop_watchdog(void);
 
-#ifdef CONFIG_ETRAX_GPIO
-extern void etrax_gpio_wake_up_check(void); /* Defined in drivers/gpio.c. */
-#endif
-
 extern int cris_hlt_counter;
 
 /* We use this if we don't have any better idle routine. */
@@ -82,7 +78,7 @@ hard_reset_now(void)
 	wd_ctrl.cmd = regk_timer_start;
 
         arch_enable_nmi();
-	REG_WR(timer, regi_timer, rw_wd_ctrl, wd_ctrl);
+	REG_WR(timer, regi_timer0, rw_wd_ctrl, wd_ctrl);
 }
 #endif
 
@@ -162,7 +158,7 @@ copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
 	/* Put the switch stack right below the pt_regs. */
 	swstack = ((struct switch_stack *) childregs) - 1;
 
-	/* Parameter to ret_from_sys_call. 0 is don't restart the syscall. */
+	/* Paramater to ret_from_sys_call. 0 is don't restart the syscall. */
 	swstack->r9 = 0;
 
 	/*
-- 
1.5.3.6.970.gd25430


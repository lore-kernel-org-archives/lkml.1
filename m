Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbXKIGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbXKIGFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXKIGDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:53 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52879 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859AbXKIGDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:52 -0500
Date: Fri, 9 Nov 2007 07:03:28 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: nmi_64.c: make code static
Message-ID: <20071109060328.GW26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- panic_on_timeout
- setup_nmi_watchdog()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/nmi_64.c |    4 ++--
 include/asm-x86/nmi_64.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

26ae99846d73a4a501f30a667f27a522f1b4d893 
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index a576fd7..ce08111 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -39,7 +39,7 @@ static cpumask_t backtrace_mask = CPU_MASK_NONE;
  *  0: the lapic NMI watchdog is disabled, but can be enabled
  */
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
-int panic_on_timeout;
+static int panic_on_timeout;
 
 unsigned int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;
@@ -135,7 +135,7 @@ int __init check_nmi_watchdog (void)
 	return 0;
 }
 
-int __init setup_nmi_watchdog(char *str)
+static int __init setup_nmi_watchdog(char *str)
 {
 	int nmi;
 
diff --git a/include/asm-x86/nmi_64.h b/include/asm-x86/nmi_64.h
index 65b6acf..bc997f9 100644
--- a/include/asm-x86/nmi_64.h
+++ b/include/asm-x86/nmi_64.h
@@ -41,7 +41,6 @@ extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 
 #define get_nmi_reason() inb(0x61)
 
-extern int panic_on_timeout;
 extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
@@ -60,7 +59,6 @@ extern void enable_timer_nmi_watchdog(void);
 extern int nmi_watchdog_tick (struct pt_regs * regs, unsigned reason);
 
 extern void nmi_watchdog_default(void);
-extern int setup_nmi_watchdog(char *);
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;


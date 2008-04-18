Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYDRXZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYDRXZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYDRXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59000 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYDRXW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:59 -0400
Message-Id: <6f7c39979b436a53abf7d44cf181354db61a7607.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: hskinnemoen@atmel.com
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/15] [AVR32] remove unused 'irq' argument from local_timer_interrupt()
Date: Fri, 18 Apr 2008 19:22:57 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/avr32/kernel/time.c             |    4 ++--
 arch/avr32/mach-at32ap/time-tc.c     |    2 +-
 include/asm-avr32/arch-at32ap/time.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 36a46c3..d6bb69c 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -150,7 +150,7 @@ int __weak avr32_hpt_start(void)
  *
  * In UP mode, it is invoked from the (global) timer_interrupt.
  */
-void local_timer_interrupt(int irq, void *dev_id)
+void local_timer_interrupt(void *dev_id)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
@@ -175,7 +175,7 @@ irqreturn_t __weak timer_interrupt(int irq, void *dev_id)
 	 *
 	 * SMP is not supported yet.
 	 */
-	local_timer_interrupt(irq, dev_id);
+	local_timer_interrupt(dev_id);
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/avr32/mach-at32ap/time-tc.c b/arch/avr32/mach-at32ap/time-tc.c
index 1026586..53e8e6e 100644
--- a/arch/avr32/mach-at32ap/time-tc.c
+++ b/arch/avr32/mach-at32ap/time-tc.c
@@ -209,7 +209,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		 *
 		 * SMP is not supported yet.
 		 */
-		local_timer_interrupt(irq, dev_id);
+		local_timer_interrupt(dev_id);
 
 		return IRQ_HANDLED;
 	}
diff --git a/include/asm-avr32/arch-at32ap/time.h b/include/asm-avr32/arch-at32ap/time.h
index cc8a434..d23b5b0 100644
--- a/include/asm-avr32/arch-at32ap/time.h
+++ b/include/asm-avr32/arch-at32ap/time.h
@@ -13,7 +13,7 @@
 
 extern struct irqaction timer_irqaction;
 extern struct platform_device at32_systc0_device;
-extern void local_timer_interrupt(int irq, void *dev_id);
+extern void local_timer_interrupt(void *dev_id);
 
 #define TIMER_BCR					0x000000c0
 #define TIMER_BCR_SYNC						 0
-- 
1.5.4.1


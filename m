Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZADLHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZADLHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZADLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:07:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZADLHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:07:23 -0500
Subject: [PATCH -tip] x86: irqinit_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:35:17 +0530
Message-Id: <1231067117.27852.36.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: Use #include <linux/delay.h> instead of <asm/delay.h>
ERROR: trailing whitespace
WARNING: externs should be avoided in .c files
ERROR: space required after that ',' (ctx:VxV)
WARNING: space prohibited between function name and open parenthesis '('

total: 2 errors, 4 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irqinit_32.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 3b2bb78..0bef628 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -9,18 +9,18 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/timer.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/arch_hooks.h>
 #include <asm/i8259.h>
-
+#include <asm/traps.h>
 
 
 /*
@@ -34,12 +34,10 @@
  * leads to races. IBM designers who came up with it should
  * be shot.
  */
- 
 
 static irqreturn_t math_error_irq(int cpl, void *dev_id)
 {
-	extern void math_error(void __user *);
-	outb(0,0xF0);
+	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
 	math_error((void __user *)get_irq_regs()->ip);
@@ -56,7 +54,7 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
-void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
-- 
1.5.5.1




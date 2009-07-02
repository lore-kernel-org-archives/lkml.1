Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZGBPbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZGBPbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZGBPb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:31:29 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:39506 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZGBPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eQ5nLBxap/KarrXnMupb6TIHgJkiDvAV4lVjdAcxGHIwX2DXMhnT3vrZ26aN2FUnzV
         egDcXLQ+jRAu7k24WJYULLiMckJm2pQVjWbG7rZtJnX/h/Pcs+wP3Ys/DDVEp7Eo2YVM
         fnlpkE6TMBan2ddFToYMZXYVW69DFwtMtgH9g=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 08/16] [loongson] clean up the coding style
Date: Thu,  2 Jul 2009 23:23:03 +0800
Message-Id: <47838a3035e4123de6b19c7de44ec2fc974270cd.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

with the help of script/checkpatch.pl, i have cleaned up the coding
style.

1. remove un-needed header files and tune some comments.
2. remove some un-needed { }

add a new header file loongson.h:

3. move some common header files to loongson.h
4. move some common extern declartions to loongson.h

and this new header file is needed for future loongson2f support.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/include/asm/mach-lemote/loongson.h |   36 +++++++++++++++++++
 arch/mips/include/asm/mach-lemote/pci.h      |    8 +++--
 arch/mips/lemote/lm2e/bonito-irq.c           |   27 +-------------
 arch/mips/lemote/lm2e/cmdline.c              |    5 +--
 arch/mips/lemote/lm2e/early_printk.c         |    4 +--
 arch/mips/lemote/lm2e/env.c                  |    6 +--
 arch/mips/lemote/lm2e/init.c                 |    6 +---
 arch/mips/lemote/lm2e/irq.c                  |   48 ++++----------------------
 arch/mips/lemote/lm2e/mem.c                  |    2 +-
 arch/mips/lemote/lm2e/pci.c                  |   26 +-------------
 arch/mips/lemote/lm2e/reset.c                |    7 ++--
 arch/mips/lemote/lm2e/setup.c                |   24 +------------
 arch/mips/lemote/lm2e/time.c                 |    5 +--
 arch/mips/pci/fixup-lm2e.c                   |   18 ----------
 14 files changed, 66 insertions(+), 156 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-lemote/loongson.h

diff --git a/arch/mips/include/asm/mach-lemote/loongson.h b/arch/mips/include/asm/mach-lemote/loongson.h
new file mode 100644
index 0000000..76cc2bd
--- /dev/null
+++ b/arch/mips/include/asm/mach-lemote/loongson.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __ASM_MACH_LOONGSON_LOONGSON_H
+#define __ASM_MACH_LOONGSON_LOONGSON_H
+
+#include <linux/io.h>
+#include <linux/init.h>
+
+/* there is an internal bonito64-compatiable northbridge in loongson2e/2f */
+#include <asm/mips-boards/bonito64.h>
+
+/* loongson internal northbridge initialization */
+extern void bonito_irq_init(void);
+
+/* loongson-based machines specific reboot setup */
+extern void mips_reboot_setup(void);
+
+/* environment arguments from bootloader */
+extern unsigned long bus_clock, cpu_clock_freq;
+extern unsigned long memsize, highmemsize;
+
+/* loongson-specific command line, env and memory initialization */
+extern void __init prom_init_memory(void);
+extern void __init prom_init_cmdline(void);
+extern void __init prom_init_env(void);
+
+#endif /* __ASM_MACH_LOONGSON_LOONGSON_H */
diff --git a/arch/mips/include/asm/mach-lemote/pci.h b/arch/mips/include/asm/mach-lemote/pci.h
index 0307e49..92b2f59 100644
--- a/arch/mips/include/asm/mach-lemote/pci.h
+++ b/arch/mips/include/asm/mach-lemote/pci.h
@@ -19,11 +19,13 @@
  * 02139, USA.
  */
 
-#ifndef _LEMOTE_PCI_H_
-#define _LEMOTE_PCI_H_
+#ifndef __ASM_MACH_LEMOTE_PCI_H_
+#define __ASM_MACH_LEMOTE_PCI_H_
+
+extern struct pci_ops bonito64_pci_ops;
 
 #define LOONGSON2E_PCI_MEM_START	0x14000000UL
 #define LOONGSON2E_PCI_MEM_END		0x1fffffffUL
 #define LOONGSON2E_PCI_IO_START		0x00004000UL
 
-#endif /* !_LEMOTE_PCI_H_ */
+#endif /* !__ASM_MACH_LEMOTE_PCI_H_ */
diff --git a/arch/mips/lemote/lm2e/bonito-irq.c b/arch/mips/lemote/lm2e/bonito-irq.c
index 8fc3bce..3e31e7a 100644
--- a/arch/mips/lemote/lm2e/bonito-irq.c
+++ b/arch/mips/lemote/lm2e/bonito-irq.c
@@ -10,32 +10,10 @@
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-
-#include <asm/mips-boards/bonito64.h>
 
+#include <loongson.h>
 
 static inline void bonito_irq_enable(unsigned int irq)
 {
@@ -66,9 +44,8 @@ void bonito_irq_init(void)
 {
 	u32 i;
 
-	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++) {
+	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++)
 		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
-	}
 
 	setup_irq(BONITO_IRQ_BASE + 10, &dma_timeout_irqaction);
 }
diff --git a/arch/mips/lemote/lm2e/cmdline.c b/arch/mips/lemote/lm2e/cmdline.c
index 442b935..75f1b24 100644
--- a/arch/mips/lemote/lm2e/cmdline.c
+++ b/arch/mips/lemote/lm2e/cmdline.c
@@ -17,11 +17,10 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
-#include <linux/io.h>
-#include <linux/init.h>
-
 #include <asm/bootinfo.h>
 
+#include <loongson.h>
+
 int prom_argc;
 /* pmon passes arguments in 32bit pointers */
 int *_prom_argv;
diff --git a/arch/mips/lemote/lm2e/early_printk.c b/arch/mips/lemote/lm2e/early_printk.c
index 811c7de..3e0a6ea 100644
--- a/arch/mips/lemote/lm2e/early_printk.c
+++ b/arch/mips/lemote/lm2e/early_printk.c
@@ -9,11 +9,9 @@
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
  */
-#include <linux/io.h>
-#include <linux/init.h>
 #include <linux/serial_reg.h>
 
-#include <asm/mips-boards/bonito64.h>
+#include <loongson.h>
 
 #define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
 
diff --git a/arch/mips/lemote/lm2e/env.c b/arch/mips/lemote/lm2e/env.c
index 9e88409..b9ef503 100644
--- a/arch/mips/lemote/lm2e/env.c
+++ b/arch/mips/lemote/lm2e/env.c
@@ -17,12 +17,10 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
-
-#include <linux/io.h>
-#include <linux/init.h>
-
 #include <asm/bootinfo.h>
 
+#include <loongson.h>
+
 unsigned long bus_clock, cpu_clock_freq;
 unsigned long memsize, highmemsize;
 
diff --git a/arch/mips/lemote/lm2e/init.c b/arch/mips/lemote/lm2e/init.c
index 6fe624d..3abe927 100644
--- a/arch/mips/lemote/lm2e/init.c
+++ b/arch/mips/lemote/lm2e/init.c
@@ -8,15 +8,11 @@
  * option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/bootmem.h>
 
 #include <asm/bootinfo.h>
-#include <asm/mips-boards/bonito64.h>
 
-extern void __init prom_init_cmdline(void);
-extern void __init prom_init_env(void);
-extern void __init prom_init_memory(void);
+#include <loongson.h>
 
 void __init prom_init(void)
 {
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
index 1d0a09f..fb7643a 100644
--- a/arch/mips/lemote/lm2e/irq.c
+++ b/arch/mips/lemote/lm2e/irq.c
@@ -6,35 +6,14 @@
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 #include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/i8259.h>
-#include <asm/mipsregs.h>
-#include <asm/mips-boards/bonito64.h>
-
 
+#include <loongson.h>
 /*
  * the first level int-handler will jump here if it is a bonito irq
  */
@@ -67,27 +46,24 @@ static void i8259_irqdispatch(void)
 	int irq;
 
 	irq = i8259_irq();
-	if (irq >= 0) {
+	if (irq >= 0)
 		do_IRQ(irq);
-	} else {
+	else
 		spurious_interrupt();
-	}
-
 }
 
 asmlinkage void plat_irq_dispatch(void)
 {
 	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
 
-	if (pending & CAUSEF_IP7) {
+	if (pending & CAUSEF_IP7)
 		do_IRQ(MIPS_CPU_IRQ_BASE + 7);
-	} else if (pending & CAUSEF_IP5) {
+	else if (pending & CAUSEF_IP5)
 		i8259_irqdispatch();
-	} else if (pending & CAUSEF_IP2) {
+	else if (pending & CAUSEF_IP2)
 		bonito_irqdispatch();
-	} else {
+	else
 		spurious_interrupt();
-	}
 }
 
 static struct irqaction cascade_irqaction = {
@@ -97,8 +73,6 @@ static struct irqaction cascade_irqaction = {
 
 void __init arch_init_irq(void)
 {
-	extern void bonito_irq_init(void);
-
 	/*
 	 * Clear all of the interrupts while we change the able around a bit.
 	 * int-handler is not on bootstrap
@@ -128,16 +102,8 @@ void __init arch_init_irq(void)
 	init_i8259_irqs();
 	bonito_irq_init();
 
-	/*
-	printk("GPIODATA=%x, GPIOIE=%x\n", BONITO_GPIODATA, BONITO_GPIOIE);
-	printk("INTEN=%x, INTSET=%x, INTCLR=%x, INTISR=%x\n",
-			BONITO_INTEN, BONITO_INTENSET,
-			BONITO_INTENCLR, BONITO_INTISR);
-	*/
-
 	/* bonito irq at IP2 */
 	setup_irq(MIPS_CPU_IRQ_BASE + 2, &cascade_irqaction);
 	/* 8259 irq at IP5 */
 	setup_irq(MIPS_CPU_IRQ_BASE + 5, &cascade_irqaction);
-
 }
diff --git a/arch/mips/lemote/lm2e/mem.c b/arch/mips/lemote/lm2e/mem.c
index f24af70..6a7feb1 100644
--- a/arch/mips/lemote/lm2e/mem.c
+++ b/arch/mips/lemote/lm2e/mem.c
@@ -10,7 +10,7 @@
 
 #include <asm/bootinfo.h>
 
-extern unsigned long memsize, highmemsize;
+#include <loongson.h>
 
 void __init prom_init_memory(void)
 {
diff --git a/arch/mips/lemote/lm2e/pci.c b/arch/mips/lemote/lm2e/pci.c
index 152efb6..bee846e 100644
--- a/arch/mips/lemote/lm2e/pci.c
+++ b/arch/mips/lemote/lm2e/pci.c
@@ -1,6 +1,4 @@
 /*
- * pci.c
- *
  * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
  * Author: Fuxin Zhang, zhangfx@lemote.com
  *
@@ -8,31 +6,11 @@
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
-#include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <asm/mips-boards/bonito64.h>
-#include <asm/mach-lemote/pci.h>
 
-extern struct pci_ops bonito64_pci_ops;
+#include <pci.h>
+#include <loongson.h>
 
 static struct resource loongson2e_pci_mem_resource = {
 	.name   = "LOONGSON2E PCI MEM",
diff --git a/arch/mips/lemote/lm2e/reset.c b/arch/mips/lemote/lm2e/reset.c
index 7758093..d89c9e4 100644
--- a/arch/mips/lemote/lm2e/reset.c
+++ b/arch/mips/lemote/lm2e/reset.c
@@ -10,10 +10,10 @@
  * Author: Zhangjin Wu, wuzj@lemote.com
  */
 #include <linux/pm.h>
-#include <linux/io.h>
 
 #include <asm/reboot.h>
-#include <asm/mips-boards/bonito64.h>
+
+#include <loongson.h>
 
 static void loongson2e_restart(char *command)
 {
@@ -27,7 +27,8 @@ static void loongson2e_restart(char *command)
 
 static void loongson2e_halt(void)
 {
-	while (1) ;
+	while (1)
+		;
 }
 
 void mips_reboot_setup(void)
diff --git a/arch/mips/lemote/lm2e/setup.c b/arch/mips/lemote/lm2e/setup.c
index 1c4968f..655695c 100644
--- a/arch/mips/lemote/lm2e/setup.c
+++ b/arch/mips/lemote/lm2e/setup.c
@@ -1,7 +1,4 @@
 /*
- * BRIEF MODULE DESCRIPTION
- * setup.c - board dependent boot routines
- *
  * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
  * Author: Fuxin Zhang, zhangfx@lemote.com
  *
@@ -9,35 +6,18 @@
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 
 #include <asm/wbflush.h>
 
+#include <loongson.h>
+
 #ifdef CONFIG_VT
 #include <linux/console.h>
 #include <linux/screen_info.h>
 #endif
 
-extern void mips_reboot_setup(void);
-
 void (*__wbflush)(void);
 EXPORT_SYMBOL(__wbflush);
 
diff --git a/arch/mips/lemote/lm2e/time.c b/arch/mips/lemote/lm2e/time.c
index b9d3f11..b13d171 100644
--- a/arch/mips/lemote/lm2e/time.c
+++ b/arch/mips/lemote/lm2e/time.c
@@ -10,13 +10,10 @@
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
  */
-
-#include <linux/init.h>
-
 #include <asm/mc146818-time.h>
 #include <asm/time.h>
 
-extern unsigned long cpu_clock_freq;
+#include <loongson.h>
 
 void __init plat_time_init(void)
 {
diff --git a/arch/mips/pci/fixup-lm2e.c b/arch/mips/pci/fixup-lm2e.c
index e18ae4f..0c4c7a8 100644
--- a/arch/mips/pci/fixup-lm2e.c
+++ b/arch/mips/pci/fixup-lm2e.c
@@ -1,6 +1,4 @@
 /*
- * fixup-lm2e.c
- *
  * Copyright (C) 2004 ICT CAS
  * Author: Li xiaoyu, ICT CAS
  *   lixy@ict.ac.cn
@@ -12,22 +10,6 @@
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 #include <linux/init.h>
 #include <linux/pci.h>
-- 
1.6.2.1


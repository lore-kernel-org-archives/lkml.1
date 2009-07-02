Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZGBP1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZGBP1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGBP1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:27:00 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:55517 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZGBP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H+OHENP6ZVI9zZYzwsK3+H6lpc5oWUoeIeNgc4ZCTCkSGcbp2SZSIsnp6XXc8Q6FiJ
         DtTmlLHhZ1BowBh9llycwdy+EM1RO3gqmsd7+HnYk6rRCohhQDZdeYZK9Lwm1e6cW539
         YgyKak87mfJ8d+2x3TP9EsHXbng/tulgB+Y7U=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 13/16] [loongson] split common loongson source code out
Date: Thu,  2 Jul 2009 23:26:45 +0800
Message-Id: <988e19d2c2ed38b3f11d07dc4556707e7d02c5aa.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to share common loongson source code between all of the loongson-based
machines. there is a need to split it out of the fuloong-2e/ directory.
at the same time, other according tuning is needed. the machine-specific
parts are defined as macros in relative header file, pci.h, mem.h,
machine.h.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig                              |   32 +++-------
 arch/mips/Makefile                             |    7 +-
 arch/mips/include/asm/mach-loongson/loongson.h |   11 +++
 arch/mips/include/asm/mach-loongson/machine.h  |   22 ++++++
 arch/mips/include/asm/mach-loongson/mem.h      |   30 +++++++++
 arch/mips/include/asm/mach-loongson/pci.h      |   12 +++-
 arch/mips/loongson/Kconfig                     |   31 +++++++++
 arch/mips/loongson/Makefile                    |   11 +++
 arch/mips/loongson/common/Makefile             |   11 +++
 arch/mips/loongson/common/bonito-irq.c         |   51 +++++++++++++++
 arch/mips/loongson/common/cmdline.c            |   52 +++++++++++++++
 arch/mips/loongson/common/early_printk.c       |   38 +++++++++++
 arch/mips/loongson/common/env.c                |   58 ++++++++++++++++
 arch/mips/loongson/common/init.c               |   30 +++++++++
 arch/mips/loongson/common/irq.c                |   74 +++++++++++++++++++++
 arch/mips/loongson/common/machtype.c           |   17 +++++
 arch/mips/loongson/common/mem.c                |   35 ++++++++++
 arch/mips/loongson/common/pci.c                |   83 ++++++++++++++++++++++++
 arch/mips/loongson/common/reset.c              |   39 +++++++++++
 arch/mips/loongson/common/setup.c              |   60 +++++++++++++++++
 arch/mips/loongson/common/time.c               |   27 ++++++++
 arch/mips/loongson/fuloong-2e/Makefile         |    8 +--
 arch/mips/loongson/fuloong-2e/bonito-irq.c     |   51 ---------------
 arch/mips/loongson/fuloong-2e/cmdline.c        |   52 ---------------
 arch/mips/loongson/fuloong-2e/early_printk.c   |   39 -----------
 arch/mips/loongson/fuloong-2e/env.c            |   58 ----------------
 arch/mips/loongson/fuloong-2e/init.c           |   30 ---------
 arch/mips/loongson/fuloong-2e/irq.c            |   52 ++-------------
 arch/mips/loongson/fuloong-2e/machtype.c       |   15 ----
 arch/mips/loongson/fuloong-2e/mem.c            |   36 ----------
 arch/mips/loongson/fuloong-2e/pci.c            |   83 ------------------------
 arch/mips/loongson/fuloong-2e/reset.c          |   31 ++-------
 arch/mips/loongson/fuloong-2e/setup.c          |   60 -----------------
 arch/mips/loongson/fuloong-2e/time.c           |   27 --------
 34 files changed, 717 insertions(+), 556 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/machine.h
 create mode 100644 arch/mips/include/asm/mach-loongson/mem.h
 create mode 100644 arch/mips/loongson/Kconfig
 create mode 100644 arch/mips/loongson/Makefile
 create mode 100644 arch/mips/loongson/common/Makefile
 create mode 100644 arch/mips/loongson/common/bonito-irq.c
 create mode 100644 arch/mips/loongson/common/cmdline.c
 create mode 100644 arch/mips/loongson/common/early_printk.c
 create mode 100644 arch/mips/loongson/common/env.c
 create mode 100644 arch/mips/loongson/common/init.c
 create mode 100644 arch/mips/loongson/common/irq.c
 create mode 100644 arch/mips/loongson/common/machtype.c
 create mode 100644 arch/mips/loongson/common/mem.c
 create mode 100644 arch/mips/loongson/common/pci.c
 create mode 100644 arch/mips/loongson/common/reset.c
 create mode 100644 arch/mips/loongson/common/setup.c
 create mode 100644 arch/mips/loongson/common/time.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/bonito-irq.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/cmdline.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/early_printk.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/env.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/init.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/machtype.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/mem.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/pci.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/setup.c
 delete mode 100644 arch/mips/loongson/fuloong-2e/time.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3414e23..482dcc3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -174,30 +174,15 @@ config LASAT
 	select SYS_SUPPORTS_64BIT_KERNEL if BROKEN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 
-config LEMOTE_FULOONG2E
-	bool "Lemote Fuloong2e mini-PC"
-	select ARCH_SPARSEMEM_ENABLE
-	select CEVT_R4K
-	select CSRC_R4K
-	select SYS_HAS_CPU_LOONGSON2
-	select DMA_NONCOHERENT
-	select BOOT_ELF32
-	select BOARD_SCACHE
-	select HAVE_STD_PC_SERIAL_PORT
-	select HW_HAS_PCI
-	select I8259
-	select ISA
-	select IRQ_CPU
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL
-	select SYS_SUPPORTS_LITTLE_ENDIAN
-	select SYS_SUPPORTS_HIGHMEM
-	select SYS_HAS_EARLY_PRINTK
-	select GENERIC_ISA_DMA_SUPPORT_BROKEN
-	select CPU_HAS_WB
+config MACH_LOONGSON
+	bool "Loongson family of machines"
 	help
-	  Lemote Fuloong2e mini-PC board based on the Chinese Loongson-2E CPU and
-	  an FPGA northbridge
+	  This enables the support of Loongson family of machines.
+
+	  Loongson is a family of general-purpose MIPS-compatible CPUs.
+	  developed at Institute of Computing Technology (ICT),
+	  Chinese Academy of Sciences (CAS) in the People's Republic
+	  of China. The chief architect is Professor Weiwu Hu.
 
 config MIPS_MALTA
 	bool "MIPS Malta board"
@@ -668,6 +653,7 @@ source "arch/mips/sibyte/Kconfig"
 source "arch/mips/txx9/Kconfig"
 source "arch/mips/vr41xx/Kconfig"
 source "arch/mips/cavium-octeon/Kconfig"
+source "arch/mips/loongson/Kconfig"
 
 endmenu
 
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 7754cbb..94d6f58 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -314,11 +314,12 @@ cflags-$(CONFIG_WR_PPMC)		+= -I$(srctree)/arch/mips/include/asm/mach-wrppmc
 load-$(CONFIG_WR_PPMC)		+= 0xffffffff80100000
 
 #
-# lemote fuloong2e mini-PC board
+# Loongson family
 #
-core-$(CONFIG_LEMOTE_FULOONG2E) +=arch/mips/loongson/fuloong-2e/
+core-$(CONFIG_MACH_LOONGSON) +=arch/mips/loongson/
+cflags-$(CONFIG_MACH_LOONGSON) += -I$(srctree)/arch/mips/include/asm/mach-loongson \
+                    -mno-branch-likely
 load-$(CONFIG_LEMOTE_FULOONG2E) +=0xffffffff80100000
-cflags-$(CONFIG_LEMOTE_FULOONG2E) += -I$(srctree)/arch/mips/include/asm/mach-loongson/
 
 #
 # MIPS Malta board
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index 95ee4c8..1c6d4a8 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -24,6 +24,10 @@ extern void bonito_irq_init(void);
 /* loongson-based machines specific reboot setup */
 extern void mips_reboot_setup(void);
 
+/* machine-specific reboot/halt operation */
+extern void mach_prepare_reboot(void);
+extern void mach_prepare_shutdown(void);
+
 /* environment arguments from bootloader */
 extern unsigned long bus_clock, cpu_clock_freq;
 extern unsigned long memsize, highmemsize;
@@ -33,6 +37,13 @@ extern void __init prom_init_memory(void);
 extern void __init prom_init_cmdline(void);
 extern void __init prom_init_env(void);
 
+/* irq operation functions */
+extern void bonito_irqdispatch(void);
+extern void __init bonito_irq_init(void);
+extern void __init set_irq_trigger_mode(void);
+extern void __init mach_init_irq(void);
+extern void mach_irq_dispatch(unsigned int pending);
+
 /* PCI Configuration Registers */
 #define LOONGSON_PCI_ISR4C  BONITO_PCI_REG(0x4c)
 
diff --git a/arch/mips/include/asm/mach-loongson/machine.h b/arch/mips/include/asm/mach-loongson/machine.h
new file mode 100644
index 0000000..8e60d36
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/machine.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON_MACHINE_H
+#define __ASM_MACH_LOONGSON_MACHINE_H
+
+#ifdef CONFIG_LEMOTE_FULOONG2E
+
+#define LOONGSON_UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
+
+#define LOONGSON_MACHNAME "lemote-fuloong-2e-box"
+
+#endif
+
+#endif /* __ASM_MACH_LOONGSON_MACHINE_H */
diff --git a/arch/mips/include/asm/mach-loongson/mem.h b/arch/mips/include/asm/mach-loongson/mem.h
new file mode 100644
index 0000000..bd7b3cb
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/mem.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON_MEM_H
+#define __ASM_MACH_LOONGSON_MEM_H
+
+/*
+ * On Lemote Loongson 2e
+ *
+ * the high memory space starts from 512M.
+ * the peripheral registers reside between 0x1000:0000 and 0x2000:0000.
+ */
+
+#ifdef CONFIG_LEMOTE_FULOONG2E
+
+#define LOONGSON_HIGHMEM_START  0x20000000
+
+#define LOONGSON_MMIO_MEM_START 0x10000000
+#define LOONGSON_MMIO_MEM_END   0x20000000
+
+#endif
+
+#endif /* __ASM_MACH_LOONGSON_MEM_H */
diff --git a/arch/mips/include/asm/mach-loongson/pci.h b/arch/mips/include/asm/mach-loongson/pci.h
index e229b29..f1663ca 100644
--- a/arch/mips/include/asm/mach-loongson/pci.h
+++ b/arch/mips/include/asm/mach-loongson/pci.h
@@ -24,8 +24,14 @@
 
 extern struct pci_ops bonito64_pci_ops;
 
-#define LOONGSON2E_PCI_MEM_START	BONITO_PCILO1_BASE
-#define LOONGSON2E_PCI_MEM_END		(BONITO_PCILO1_BASE + 0x04000000 * 2)
-#define LOONGSON2E_PCI_IO_START		0x00004000UL
+#ifdef CONFIG_LEMOTE_FULOONG2E
+
+/* this pci memory space is mapped by pcimap in pci.c */
+#define LOONGSON_PCI_MEM_START	BONITO_PCILO1_BASE
+#define LOONGSON_PCI_MEM_END	(BONITO_PCILO1_BASE + 0x04000000 * 2)
+/* this is an offset from mips_io_port_base */
+#define LOONGSON_PCI_IO_START	0x00004000UL
+
+#endif
 
 #endif /* !__ASM_MACH_LOONGSON_PCI_H_ */
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
new file mode 100644
index 0000000..376712a
--- /dev/null
+++ b/arch/mips/loongson/Kconfig
@@ -0,0 +1,31 @@
+choice
+    prompt "Machine Type"
+    depends on MACH_LOONGSON
+
+config LEMOTE_FULOONG2E
+    bool "Lemote Fuloong(2e) mini-PC"
+    select ARCH_SPARSEMEM_ENABLE
+    select CEVT_R4K
+    select CSRC_R4K
+    select SYS_HAS_CPU_LOONGSON2
+    select DMA_NONCOHERENT
+    select BOOT_ELF32
+    select BOARD_SCACHE
+    select HW_HAS_PCI
+    select I8259
+    select ISA
+    select IRQ_CPU
+    select SYS_SUPPORTS_32BIT_KERNEL
+    select SYS_SUPPORTS_64BIT_KERNEL
+    select SYS_SUPPORTS_LITTLE_ENDIAN
+    select SYS_SUPPORTS_HIGHMEM
+    select SYS_HAS_EARLY_PRINTK
+    select GENERIC_HARDIRQS_NO__DO_IRQ
+    select GENERIC_ISA_DMA_SUPPORT_BROKEN
+    select CPU_HAS_WB
+    help
+      Lemote Fuloong(2e) mini-PC board based on the Chinese Loongson-2E CPU and
+      an FPGA northbridge
+
+      Lemote Fuloong(2e) mini PC have a VIA686B south bridge.
+endchoice
diff --git a/arch/mips/loongson/Makefile b/arch/mips/loongson/Makefile
new file mode 100644
index 0000000..39048c4
--- /dev/null
+++ b/arch/mips/loongson/Makefile
@@ -0,0 +1,11 @@
+#
+# Common code for all Loongson based systems
+#
+
+obj-$(CONFIG_MACH_LOONGSON) += common/
+
+#
+# Lemote Fuloong mini-PC (Loongson 2E-based)
+#
+
+obj-$(CONFIG_LEMOTE_FULOONG2E)  += fuloong-2e/
diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
new file mode 100644
index 0000000..4e3889d
--- /dev/null
+++ b/arch/mips/loongson/common/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for loongson based machines.
+#
+
+obj-y += setup.o init.o cmdline.o env.o time.o reset.o irq.o \
+    pci.o bonito-irq.o mem.o
+
+#
+# Early printk support
+#
+obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
diff --git a/arch/mips/loongson/common/bonito-irq.c b/arch/mips/loongson/common/bonito-irq.c
new file mode 100644
index 0000000..3e31e7a
--- /dev/null
+++ b/arch/mips/loongson/common/bonito-irq.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
+ * Copyright (C) 2000, 2001 Ralf Baechle (ralf@gnu.org)
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/interrupt.h>
+
+#include <loongson.h>
+
+static inline void bonito_irq_enable(unsigned int irq)
+{
+	BONITO_INTENSET = (1 << (irq - BONITO_IRQ_BASE));
+	mmiowb();
+}
+
+static inline void bonito_irq_disable(unsigned int irq)
+{
+	BONITO_INTENCLR = (1 << (irq - BONITO_IRQ_BASE));
+	mmiowb();
+}
+
+static struct irq_chip bonito_irq_type = {
+	.name	= "bonito_irq",
+	.ack	= bonito_irq_disable,
+	.mask	= bonito_irq_disable,
+	.mask_ack = bonito_irq_disable,
+	.unmask	= bonito_irq_enable,
+};
+
+static struct irqaction dma_timeout_irqaction = {
+	.handler	= no_action,
+	.name		= "dma_timeout",
+};
+
+void bonito_irq_init(void)
+{
+	u32 i;
+
+	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++)
+		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
+
+	setup_irq(BONITO_IRQ_BASE + 10, &dma_timeout_irqaction);
+}
diff --git a/arch/mips/loongson/common/cmdline.c b/arch/mips/loongson/common/cmdline.c
new file mode 100644
index 0000000..75f1b24
--- /dev/null
+++ b/arch/mips/loongson/common/cmdline.c
@@ -0,0 +1,52 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+int prom_argc;
+/* pmon passes arguments in 32bit pointers */
+int *_prom_argv;
+
+void __init prom_init_cmdline(void)
+{
+	int i;
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	prom_argc = fw_arg0;
+	_prom_argv = (int *)fw_arg1;
+
+	/* arg[0] is "g", the rest is boot parameters */
+	arcs_cmdline[0] = '\0';
+	for (i = 1; i < prom_argc; i++) {
+		l = (long)_prom_argv[i];
+		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
+		    >= sizeof(arcs_cmdline))
+			break;
+		strcat(arcs_cmdline, ((char *)l));
+		strcat(arcs_cmdline, " ");
+	}
+
+	if ((strstr(arcs_cmdline, "console=")) == NULL)
+		strcat(arcs_cmdline, " console=ttyS0,115200");
+	if ((strstr(arcs_cmdline, "root=")) == NULL)
+		strcat(arcs_cmdline, " root=/dev/hda1");
+}
diff --git a/arch/mips/loongson/common/early_printk.c b/arch/mips/loongson/common/early_printk.c
new file mode 100644
index 0000000..bc73edc
--- /dev/null
+++ b/arch/mips/loongson/common/early_printk.c
@@ -0,0 +1,38 @@
+/*  early printk support
+ *
+ *  Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *  Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ *  Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/serial_reg.h>
+
+#include <loongson.h>
+#include <machine.h>
+
+#define PORT(base, offset) (u8 *)(base + offset)
+
+static inline unsigned int serial_in(phys_addr_t base, int offset)
+{
+	return readb(PORT(base, offset));
+}
+
+static inline void serial_out(phys_addr_t base, int offset, int value)
+{
+	writeb(value, PORT(base, offset));
+}
+
+void prom_putchar(char c)
+{
+	phys_addr_t uart_base =
+		(phys_addr_t) ioremap_nocache(LOONGSON_UART_BASE, 8);
+
+	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)
+		;
+
+	serial_out(uart_base, UART_TX, c);
+}
diff --git a/arch/mips/loongson/common/env.c b/arch/mips/loongson/common/env.c
new file mode 100644
index 0000000..b9ef503
--- /dev/null
+++ b/arch/mips/loongson/common/env.c
@@ -0,0 +1,58 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+unsigned long bus_clock, cpu_clock_freq;
+unsigned long memsize, highmemsize;
+
+/* pmon passes arguments in 32bit pointers */
+int *_prom_envp;
+
+#define parse_even_earlier(res, option, p)				\
+do {									\
+	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
+			strict_strtol((char *)p + strlen(option"="),	\
+					10, &res);			\
+} while (0)
+
+void __init prom_init_env(void)
+{
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	_prom_envp = (int *)fw_arg2;
+
+	l = (long)*_prom_envp;
+	while (l != 0) {
+		parse_even_earlier(bus_clock, "busclock", l);
+		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
+		parse_even_earlier(memsize, "memsize", l);
+		parse_even_earlier(highmemsize, "highmemsize", l);
+		_prom_envp++;
+		l = (long)*_prom_envp;
+	}
+	if (memsize == 0)
+		memsize = 256;
+
+	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
+		bus_clock, cpu_clock_freq, memsize, highmemsize);
+}
diff --git a/arch/mips/loongson/common/init.c b/arch/mips/loongson/common/init.c
new file mode 100644
index 0000000..3abe927
--- /dev/null
+++ b/arch/mips/loongson/common/init.c
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/bootmem.h>
+
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+void __init prom_init(void)
+{
+    /* init base address of io space */
+	set_io_port_base((unsigned long)
+		ioremap(BONITO_PCIIO_BASE, BONITO_PCIIO_SIZE));
+
+	prom_init_cmdline();
+	prom_init_env();
+	prom_init_memory();
+}
+
+void __init prom_free_prom_memory(void)
+{
+}
diff --git a/arch/mips/loongson/common/irq.c b/arch/mips/loongson/common/irq.c
new file mode 100644
index 0000000..f368c73
--- /dev/null
+++ b/arch/mips/loongson/common/irq.c
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#include <loongson.h>
+/*
+ * the first level int-handler will jump here if it is a bonito irq
+ */
+void bonito_irqdispatch(void)
+{
+	u32 int_status;
+	int i;
+
+	/* workaround the IO dma problem: let cpu looping to allow DMA finish */
+	int_status = BONITO_INTISR;
+	if (int_status & (1 << 10)) {
+		while (int_status & (1 << 10)) {
+			udelay(1);
+			int_status = BONITO_INTISR;
+		}
+	}
+
+	/* Get pending sources, masked by current enables */
+	int_status = BONITO_INTISR & BONITO_INTEN;
+
+	if (int_status != 0) {
+		i = __ffs(int_status);
+		int_status &= ~(1 << i);
+		do_IRQ(BONITO_IRQ_BASE + i);
+	}
+}
+
+asmlinkage void plat_irq_dispatch(void)
+{
+	unsigned int pending;
+
+	pending = read_c0_cause() & read_c0_status() & ST0_IM;
+
+	/* machine-specific plat_irq_dispatch */
+	mach_irq_dispatch(pending);
+}
+
+void __init arch_init_irq(void)
+{
+	/*
+	 * Clear all of the interrupts while we change the able around a bit.
+	 * int-handler is not on bootstrap
+	 */
+	clear_c0_status(ST0_IM | ST0_BEV);
+	local_irq_disable();
+
+	/* setting irq trigger mode */
+	set_irq_trigger_mode();
+
+	/* no steer */
+	BONITO_INTSTEER = 0;
+
+	/*
+	 * Mask out all interrupt by writing "1" to all bit position in
+	 * the interrupt reset reg.
+	 */
+	BONITO_INTENCLR = ~0;
+
+	/* machine specific irq init */
+	mach_init_irq();
+}
diff --git a/arch/mips/loongson/common/machtype.c b/arch/mips/loongson/common/machtype.c
new file mode 100644
index 0000000..845b3fb
--- /dev/null
+++ b/arch/mips/loongson/common/machtype.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <machine.h>
+
+const char *get_system_type(void)
+{
+	return LOONGSON_MACHNAME;
+}
+
diff --git a/arch/mips/loongson/common/mem.c b/arch/mips/loongson/common/mem.c
new file mode 100644
index 0000000..7c92f79
--- /dev/null
+++ b/arch/mips/loongson/common/mem.c
@@ -0,0 +1,35 @@
+/*
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/fs.h>
+#include <linux/fcntl.h>
+#include <linux/mm.h>
+
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+#include <mem.h>
+
+void __init prom_init_memory(void)
+{
+    add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
+#ifdef CONFIG_64BIT
+    if (highmemsize > 0)
+	add_memory_region(LOONGSON_HIGHMEM_START,
+		highmemsize << 20, BOOT_MEM_RAM);
+#endif /* CONFIG_64BIT */
+}
+
+/* override of arch/mips/mm/cache.c: __uncached_access */
+int __uncached_access(struct file *file, unsigned long addr)
+{
+	if (file->f_flags & O_SYNC)
+		return 1;
+
+	return addr >= __pa(high_memory) ||
+		((addr >= LOONGSON_MMIO_MEM_START) &&
+		 (addr < LOONGSON_MMIO_MEM_END));
+}
diff --git a/arch/mips/loongson/common/pci.c b/arch/mips/loongson/common/pci.c
new file mode 100644
index 0000000..a3a4abf
--- /dev/null
+++ b/arch/mips/loongson/common/pci.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/pci.h>
+
+#include <pci.h>
+#include <loongson.h>
+
+static struct resource loongson_pci_mem_resource = {
+	.name   = "pci memory space",
+	.start  = LOONGSON_PCI_MEM_START,
+	.end    = LOONGSON_PCI_MEM_END,
+	.flags  = IORESOURCE_MEM,
+};
+
+static struct resource loongson_pci_io_resource = {
+	.name   = "pci io space",
+	.start  = LOONGSON_PCI_IO_START,
+	.end    = IO_SPACE_LIMIT,
+	.flags  = IORESOURCE_IO,
+};
+
+static struct pci_controller  loongson_pci_controller = {
+	.pci_ops        = &bonito64_pci_ops,
+	.io_resource    = &loongson_pci_io_resource,
+	.mem_resource   = &loongson_pci_mem_resource,
+	.mem_offset     = 0x00000000UL,
+	.io_offset      = 0x00000000UL,
+};
+
+static void __init setup_pcimap(void)
+{
+	/*
+	 * local to PCI mapping for CPU accessing PCI space
+	 * CPU address space [256M,448M] is window for accessing pci space
+	 * we set pcimap_lo[0,1,2] to map it to pci space[0M,64M], [320M,448M]
+	 *
+	 * pcimap: PCI_MAP2  PCI_Mem_Lo2 PCI_Mem_Lo1 PCI_Mem_Lo0
+	 * 	     [<2G]   [384M,448M] [320M,384M] [0M,64M]
+	 */
+	BONITO_PCIMAP = BONITO_PCIMAP_PCIMAP_2 |
+		BONITO_PCIMAP_WIN(2, BONITO_PCILO2_BASE) |
+		BONITO_PCIMAP_WIN(1, BONITO_PCILO1_BASE) |
+		BONITO_PCIMAP_WIN(0, 0);
+
+	/*
+	 * PCI-DMA to local mapping: [2G,2G+256M] -> [0M,256M]
+	 */
+	BONITO_PCIBASE0 = 0x80000000ul;   /* base: 2G -> mmap: 0M */
+	/* size: 256M, burst transmission, pre-fetch enable, 64bit */
+	LOONGSON_PCI_HIT0_SEL_L = 0xc000000cul;
+	LOONGSON_PCI_HIT0_SEL_H = 0xfffffffful;
+	LOONGSON_PCI_HIT1_SEL_L = 0x00000006ul; /* set this BAR as invalid */
+	LOONGSON_PCI_HIT1_SEL_H = 0x00000000ul;
+	LOONGSON_PCI_HIT2_SEL_L = 0x00000006ul; /* set this BAR as invalid */
+	LOONGSON_PCI_HIT2_SEL_H = 0x00000000ul;
+
+	/* avoid deadlock of PCI reading/writing lock operation */
+	LOONGSON_PCI_ISR4C = 0xd2000001ul;
+
+	/* can not change gnt to break pci transfer when device's gnt not
+	deassert for some broken device */
+	LOONGSON_PXARB_CFG = 0x00fe0105ul;
+}
+
+static int __init pcibios_init(void)
+{
+	setup_pcimap();
+
+	loongson_pci_controller.io_map_base = mips_io_port_base;
+
+	register_pci_controller(&loongson_pci_controller);
+
+	return 0;
+}
+
+arch_initcall(pcibios_init);
diff --git a/arch/mips/loongson/common/reset.c b/arch/mips/loongson/common/reset.c
new file mode 100644
index 0000000..8f67c00
--- /dev/null
+++ b/arch/mips/loongson/common/reset.c
@@ -0,0 +1,39 @@
+/*
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Zhangjin Wu, wuzj@lemote.com
+ */
+#include <linux/pm.h>
+
+#include <asm/reboot.h>
+
+#include <loongson.h>
+
+static void loongson_restart(char *command)
+{
+	/* do preparation for reboot */
+	mach_prepare_reboot();
+
+	/* reboot via jumping to boot base address */
+	((void (*)(void))ioremap_nocache(BONITO_BOOT_BASE, 4)) ();
+}
+
+static void loongson_halt(void)
+{
+	mach_prepare_shutdown();
+	while (1)
+		;
+}
+
+void mips_reboot_setup(void)
+{
+	_machine_restart = loongson_restart;
+	_machine_halt = loongson_halt;
+	pm_power_off = loongson_halt;
+}
diff --git a/arch/mips/loongson/common/setup.c b/arch/mips/loongson/common/setup.c
new file mode 100644
index 0000000..aaa070c
--- /dev/null
+++ b/arch/mips/loongson/common/setup.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/module.h>
+
+#include <asm/wbflush.h>
+
+#include <loongson.h>
+
+#ifdef CONFIG_VT
+#include <linux/console.h>
+#include <linux/screen_info.h>
+#endif
+
+void (*__wbflush)(void);
+EXPORT_SYMBOL(__wbflush);
+
+static void wbflush_loongson(void)
+{
+	asm(".set\tpush\n\t"
+	    ".set\tnoreorder\n\t"
+	    ".set mips3\n\t"
+	    "sync\n\t"
+	    "nop\n\t"
+	    ".set\tpop\n\t"
+	    ".set mips0\n\t");
+}
+
+void __init plat_mem_setup(void)
+{
+	mips_reboot_setup();
+
+	__wbflush = wbflush_loongson;
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	conswitchp = &vga_con;
+
+	screen_info = (struct screen_info) {
+		0, 25,		/* orig-x, orig-y */
+		    0,		/* unused */
+		    0,		/* orig-video-page */
+		    0,		/* orig-video-mode */
+		    80,		/* orig-video-cols */
+		    0, 0, 0,	/* ega_ax, ega_bx, ega_cx */
+		    25,		/* orig-video-lines */
+		    VIDEO_TYPE_VGAC,	/* orig-video-isVGA */
+		    16		/* orig-video-points */
+	};
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
diff --git a/arch/mips/loongson/common/time.c b/arch/mips/loongson/common/time.c
new file mode 100644
index 0000000..b13d171
--- /dev/null
+++ b/arch/mips/loongson/common/time.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <asm/mc146818-time.h>
+#include <asm/time.h>
+
+#include <loongson.h>
+
+void __init plat_time_init(void)
+{
+	/* setup mips r4k timer */
+	mips_hpt_frequency = cpu_clock_freq / 2;
+}
+
+unsigned long read_persistent_clock(void)
+{
+	return mc146818_get_cmos_time();
+}
diff --git a/arch/mips/loongson/fuloong-2e/Makefile b/arch/mips/loongson/fuloong-2e/Makefile
index feb1d6b..96e45c1 100644
--- a/arch/mips/loongson/fuloong-2e/Makefile
+++ b/arch/mips/loongson/fuloong-2e/Makefile
@@ -2,12 +2,6 @@
 # Makefile for Lemote Fuloong2e mini-PC board.
 #
 
-obj-y += setup.o init.o reset.o irq.o pci.o bonito-irq.o mem.o \
-		env.o cmdline.o time.o machtype.o
-
-#
-# Early printk support
-#
-obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
+obj-y += irq.o reset.o machtype.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/loongson/fuloong-2e/bonito-irq.c b/arch/mips/loongson/fuloong-2e/bonito-irq.c
deleted file mode 100644
index 3e31e7a..0000000
--- a/arch/mips/loongson/fuloong-2e/bonito-irq.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright 2001 MontaVista Software Inc.
- * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- * Copyright (C) 2000, 2001 Ralf Baechle (ralf@gnu.org)
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/interrupt.h>
-
-#include <loongson.h>
-
-static inline void bonito_irq_enable(unsigned int irq)
-{
-	BONITO_INTENSET = (1 << (irq - BONITO_IRQ_BASE));
-	mmiowb();
-}
-
-static inline void bonito_irq_disable(unsigned int irq)
-{
-	BONITO_INTENCLR = (1 << (irq - BONITO_IRQ_BASE));
-	mmiowb();
-}
-
-static struct irq_chip bonito_irq_type = {
-	.name	= "bonito_irq",
-	.ack	= bonito_irq_disable,
-	.mask	= bonito_irq_disable,
-	.mask_ack = bonito_irq_disable,
-	.unmask	= bonito_irq_enable,
-};
-
-static struct irqaction dma_timeout_irqaction = {
-	.handler	= no_action,
-	.name		= "dma_timeout",
-};
-
-void bonito_irq_init(void)
-{
-	u32 i;
-
-	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++)
-		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
-
-	setup_irq(BONITO_IRQ_BASE + 10, &dma_timeout_irqaction);
-}
diff --git a/arch/mips/loongson/fuloong-2e/cmdline.c b/arch/mips/loongson/fuloong-2e/cmdline.c
deleted file mode 100644
index 75f1b24..0000000
--- a/arch/mips/loongson/fuloong-2e/cmdline.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Based on Ocelot Linux port, which is
- * Copyright 2001 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * Copyright 2003 ICT CAS
- * Author: Michael Guo <guoyi@ict.ac.cn>
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-int prom_argc;
-/* pmon passes arguments in 32bit pointers */
-int *_prom_argv;
-
-void __init prom_init_cmdline(void)
-{
-	int i;
-	long l;
-
-	/* firmware arguments are initialized in head.S */
-	prom_argc = fw_arg0;
-	_prom_argv = (int *)fw_arg1;
-
-	/* arg[0] is "g", the rest is boot parameters */
-	arcs_cmdline[0] = '\0';
-	for (i = 1; i < prom_argc; i++) {
-		l = (long)_prom_argv[i];
-		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
-		    >= sizeof(arcs_cmdline))
-			break;
-		strcat(arcs_cmdline, ((char *)l));
-		strcat(arcs_cmdline, " ");
-	}
-
-	if ((strstr(arcs_cmdline, "console=")) == NULL)
-		strcat(arcs_cmdline, " console=ttyS0,115200");
-	if ((strstr(arcs_cmdline, "root=")) == NULL)
-		strcat(arcs_cmdline, " root=/dev/hda1");
-}
diff --git a/arch/mips/loongson/fuloong-2e/early_printk.c b/arch/mips/loongson/fuloong-2e/early_printk.c
deleted file mode 100644
index 3e0a6ea..0000000
--- a/arch/mips/loongson/fuloong-2e/early_printk.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*  early printk support
- *
- *  Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
- *  Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- *  Author: Wu Zhangjin, wuzj@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/serial_reg.h>
-
-#include <loongson.h>
-
-#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
-
-#define PORT(base, offset) (u8 *)(base + offset)
-
-static inline unsigned int serial_in(phys_addr_t base, int offset)
-{
-	return readb(PORT(base, offset));
-}
-
-static inline void serial_out(phys_addr_t base, int offset, int value)
-{
-	writeb(value, PORT(base, offset));
-}
-
-void prom_putchar(char c)
-{
-	phys_addr_t uart_base =
-		(phys_addr_t) ioremap_nocache(UART_BASE, 8);
-
-	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)
-		;
-
-	serial_out(uart_base, UART_TX, c);
-}
diff --git a/arch/mips/loongson/fuloong-2e/env.c b/arch/mips/loongson/fuloong-2e/env.c
deleted file mode 100644
index b9ef503..0000000
--- a/arch/mips/loongson/fuloong-2e/env.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Based on Ocelot Linux port, which is
- * Copyright 2001 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * Copyright 2003 ICT CAS
- * Author: Michael Guo <guoyi@ict.ac.cn>
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-unsigned long bus_clock, cpu_clock_freq;
-unsigned long memsize, highmemsize;
-
-/* pmon passes arguments in 32bit pointers */
-int *_prom_envp;
-
-#define parse_even_earlier(res, option, p)				\
-do {									\
-	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
-			strict_strtol((char *)p + strlen(option"="),	\
-					10, &res);			\
-} while (0)
-
-void __init prom_init_env(void)
-{
-	long l;
-
-	/* firmware arguments are initialized in head.S */
-	_prom_envp = (int *)fw_arg2;
-
-	l = (long)*_prom_envp;
-	while (l != 0) {
-		parse_even_earlier(bus_clock, "busclock", l);
-		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
-		parse_even_earlier(memsize, "memsize", l);
-		parse_even_earlier(highmemsize, "highmemsize", l);
-		_prom_envp++;
-		l = (long)*_prom_envp;
-	}
-	if (memsize == 0)
-		memsize = 256;
-
-	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
-		bus_clock, cpu_clock_freq, memsize, highmemsize);
-}
diff --git a/arch/mips/loongson/fuloong-2e/init.c b/arch/mips/loongson/fuloong-2e/init.c
deleted file mode 100644
index 3abe927..0000000
--- a/arch/mips/loongson/fuloong-2e/init.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/bootmem.h>
-
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-void __init prom_init(void)
-{
-    /* init base address of io space */
-	set_io_port_base((unsigned long)
-		ioremap(BONITO_PCIIO_BASE, BONITO_PCIIO_SIZE));
-
-	prom_init_cmdline();
-	prom_init_env();
-	prom_init_memory();
-}
-
-void __init prom_free_prom_memory(void)
-{
-}
diff --git a/arch/mips/loongson/fuloong-2e/irq.c b/arch/mips/loongson/fuloong-2e/irq.c
index 9585f5a..7888cf6 100644
--- a/arch/mips/loongson/fuloong-2e/irq.c
+++ b/arch/mips/loongson/fuloong-2e/irq.c
@@ -7,39 +7,12 @@
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
  */
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/i8259.h>
 
 #include <loongson.h>
-/*
- * the first level int-handler will jump here if it is a bonito irq
- */
-static void bonito_irqdispatch(void)
-{
-	u32 int_status;
-	int i;
-
-	/* workaround the IO dma problem: let cpu looping to allow DMA finish */
-	int_status = BONITO_INTISR;
-	if (int_status & (1 << 10)) {
-		while (int_status & (1 << 10)) {
-			udelay(1);
-			int_status = BONITO_INTISR;
-		}
-	}
-
-	/* Get pending sources, masked by current enables */
-	int_status = BONITO_INTISR & BONITO_INTEN;
-
-	if (int_status != 0) {
-		i = __ffs(int_status);
-		int_status &= ~(1 << i);
-		do_IRQ(BONITO_IRQ_BASE + i);
-	}
-}
 
 static void i8259_irqdispatch(void)
 {
@@ -52,10 +25,8 @@ static void i8259_irqdispatch(void)
 		spurious_interrupt();
 }
 
-asmlinkage void plat_irq_dispatch(void)
+asmlinkage void mach_irq_dispatch(unsigned int pending)
 {
-	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
-
 	if (pending & CAUSEF_IP7)
 		do_IRQ(MIPS_CPU_IRQ_BASE + 7);
 	else if (pending & CAUSEF_IP6) /* perf counter loverflow */
@@ -73,26 +44,15 @@ static struct irqaction cascade_irqaction = {
 	.name = "cascade",
 };
 
-void __init arch_init_irq(void)
+void __init set_irq_trigger_mode(void)
 {
-	/*
-	 * Clear all of the interrupts while we change the able around a bit.
-	 * int-handler is not on bootstrap
-	 */
-	clear_c0_status(ST0_IM | ST0_BEV);
-	local_irq_disable();
-
 	/* most bonito irq should be level triggered */
 	BONITO_INTEDGE = BONITO_ICU_SYSTEMERR | BONITO_ICU_MASTERERR |
-		BONITO_ICU_RETRYERR | BONITO_ICU_MBOXES;
-	BONITO_INTSTEER = 0;
-
-	/*
-	 * Mask out all interrupt by writing "1" to all bit position in
-	 * the interrupt reset reg.
-	 */
-	BONITO_INTENCLR = ~0;
+	    BONITO_ICU_RETRYERR | BONITO_ICU_MBOXES;
+}
 
+void __init mach_init_irq(void)
+{
 	/* init all controller
 	 *   0-15         ------> i8259 interrupt
 	 *   16-23        ------> mips cpu interrupt
diff --git a/arch/mips/loongson/fuloong-2e/machtype.c b/arch/mips/loongson/fuloong-2e/machtype.c
deleted file mode 100644
index e03aa0d..0000000
--- a/arch/mips/loongson/fuloong-2e/machtype.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-const char *get_system_type(void)
-{
-	return "lemote-fuloong-2e-box";
-}
-
diff --git a/arch/mips/loongson/fuloong-2e/mem.c b/arch/mips/loongson/fuloong-2e/mem.c
deleted file mode 100644
index 6a7feb1..0000000
--- a/arch/mips/loongson/fuloong-2e/mem.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <linux/fs.h>
-#include <linux/fcntl.h>
-#include <linux/mm.h>
-
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-void __init prom_init_memory(void)
-{
-    add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
-#ifdef CONFIG_64BIT
-    if (highmemsize > 0)
-		add_memory_region(0x20000000, highmemsize << 20, BOOT_MEM_RAM);
-#endif /* CONFIG_64BIT */
-}
-
-/* override of arch/mips/mm/cache.c: __uncached_access */
-int __uncached_access(struct file *file, unsigned long addr)
-{
-	if (file->f_flags & O_SYNC)
-		return 1;
-
-	/*
-	 * On the Lemote Loongson 2e system, the peripheral registers
-	 * reside between 0x1000:0000 and 0x2000:0000.
-	 */
-	return addr >= __pa(high_memory) ||
-		((addr >= 0x10000000) && (addr < 0x20000000));
-}
diff --git a/arch/mips/loongson/fuloong-2e/pci.c b/arch/mips/loongson/fuloong-2e/pci.c
deleted file mode 100644
index 9812c30..0000000
--- a/arch/mips/loongson/fuloong-2e/pci.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/pci.h>
-
-#include <pci.h>
-#include <loongson.h>
-
-static struct resource loongson2e_pci_mem_resource = {
-	.name   = "LOONGSON2E PCI MEM",
-	.start  = LOONGSON2E_PCI_MEM_START,
-	.end    = LOONGSON2E_PCI_MEM_END,
-	.flags  = IORESOURCE_MEM,
-};
-
-static struct resource loongson2e_pci_io_resource = {
-	.name   = "LOONGSON2E PCI IO MEM",
-	.start  = LOONGSON2E_PCI_IO_START,
-	.end    = IO_SPACE_LIMIT,
-	.flags  = IORESOURCE_IO,
-};
-
-static struct pci_controller  loongson2e_pci_controller = {
-	.pci_ops        = &bonito64_pci_ops,
-	.io_resource    = &loongson2e_pci_io_resource,
-	.mem_resource   = &loongson2e_pci_mem_resource,
-	.mem_offset     = 0x00000000UL,
-	.io_offset      = 0x00000000UL,
-};
-
-static void __init setup_pcimap(void)
-{
-	/*
-	 * local to PCI mapping for CPU accessing PCI space
-	 * CPU address space [256M,448M] is window for accessing pci space
-	 * we set pcimap_lo[0,1,2] to map it to pci space[0M,64M], [320M,448M]
-	 *
-	 * pcimap: PCI_MAP2  PCI_Mem_Lo2 PCI_Mem_Lo1 PCI_Mem_Lo0
-	 * 	     [<2G]   [384M,448M] [320M,384M] [0M,64M]
-	 */
-	BONITO_PCIMAP = BONITO_PCIMAP_PCIMAP_2 |
-		BONITO_PCIMAP_WIN(2, BONITO_PCILO2_BASE) |
-		BONITO_PCIMAP_WIN(1, BONITO_PCILO1_BASE) |
-		BONITO_PCIMAP_WIN(0, 0);
-
-	/*
-	 * PCI-DMA to local mapping: [2G,2G+256M] -> [0M,256M]
-	 */
-	BONITO_PCIBASE0 = 0x80000000ul;   /* base: 2G -> mmap: 0M */
-	/* size: 256M, burst transmission, pre-fetch enable, 64bit */
-	LOONGSON_PCI_HIT0_SEL_L = 0xc000000cul;
-	LOONGSON_PCI_HIT0_SEL_H = 0xfffffffful;
-	LOONGSON_PCI_HIT1_SEL_L = 0x00000006ul; /* set this BAR as invalid */
-	LOONGSON_PCI_HIT1_SEL_H = 0x00000000ul;
-	LOONGSON_PCI_HIT2_SEL_L = 0x00000006ul; /* set this BAR as invalid */
-	LOONGSON_PCI_HIT2_SEL_H = 0x00000000ul;
-
-	/* avoid deadlock of PCI reading/writing lock operation */
-	LOONGSON_PCI_ISR4C = 0xd2000001ul;
-
-	/* can not change gnt to break pci transfer when device's gnt not
-	deassert for some broken device */
-	LOONGSON_PXARB_CFG = 0x00fe0105ul;
-}
-
-static int __init pcibios_init(void)
-{
-	setup_pcimap();
-
-	loongson2e_pci_controller.io_map_base = mips_io_port_base;
-
-	register_pci_controller(&loongson2e_pci_controller);
-
-	return 0;
-}
-
-arch_initcall(pcibios_init);
diff --git a/arch/mips/loongson/fuloong-2e/reset.c b/arch/mips/loongson/fuloong-2e/reset.c
index d89c9e4..17f8237 100644
--- a/arch/mips/loongson/fuloong-2e/reset.c
+++ b/arch/mips/loongson/fuloong-2e/reset.c
@@ -1,39 +1,24 @@
-/*
+/* Board-specific reboot/shutdown routines
+ * Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
- *
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
- * Author: Zhangjin Wu, wuzj@lemote.com
  */
-#include <linux/pm.h>
-
-#include <asm/reboot.h>
 
 #include <loongson.h>
 
-static void loongson2e_restart(char *command)
+void mach_prepare_reboot(void)
 {
-	/* do preparation for reboot */
 	BONITO_BONGENCFG &= ~(1 << 2);
 	BONITO_BONGENCFG |= (1 << 2);
-
-	/* reboot via jumping to boot base address */
-	((void (*)(void))ioremap_nocache(BONITO_BOOT_BASE, 4)) ();
 }
 
-static void loongson2e_halt(void)
+void mach_prepare_shutdown(void)
 {
-	while (1)
-		;
 }
 
-void mips_reboot_setup(void)
-{
-	_machine_restart = loongson2e_restart;
-	_machine_halt = loongson2e_halt;
-	pm_power_off = loongson2e_halt;
-}
diff --git a/arch/mips/loongson/fuloong-2e/setup.c b/arch/mips/loongson/fuloong-2e/setup.c
deleted file mode 100644
index 655695c..0000000
--- a/arch/mips/loongson/fuloong-2e/setup.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/module.h>
-
-#include <asm/wbflush.h>
-
-#include <loongson.h>
-
-#ifdef CONFIG_VT
-#include <linux/console.h>
-#include <linux/screen_info.h>
-#endif
-
-void (*__wbflush)(void);
-EXPORT_SYMBOL(__wbflush);
-
-static void wbflush_loongson2e(void)
-{
-	asm(".set\tpush\n\t"
-	    ".set\tnoreorder\n\t"
-	    ".set mips3\n\t"
-	    "sync\n\t"
-	    "nop\n\t"
-	    ".set\tpop\n\t"
-	    ".set mips0\n\t");
-}
-
-void __init plat_mem_setup(void)
-{
-	mips_reboot_setup();
-
-	__wbflush = wbflush_loongson2e;
-
-#ifdef CONFIG_VT
-#if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
-
-	screen_info = (struct screen_info) {
-		0, 25,		/* orig-x, orig-y */
-		    0,		/* unused */
-		    0,		/* orig-video-page */
-		    0,		/* orig-video-mode */
-		    80,		/* orig-video-cols */
-		    0, 0, 0,	/* ega_ax, ega_bx, ega_cx */
-		    25,		/* orig-video-lines */
-		    VIDEO_TYPE_VGAC,	/* orig-video-isVGA */
-		    16		/* orig-video-points */
-	};
-#elif defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;
-#endif
-#endif
-}
diff --git a/arch/mips/loongson/fuloong-2e/time.c b/arch/mips/loongson/fuloong-2e/time.c
deleted file mode 100644
index b13d171..0000000
--- a/arch/mips/loongson/fuloong-2e/time.c
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <asm/mc146818-time.h>
-#include <asm/time.h>
-
-#include <loongson.h>
-
-void __init plat_time_init(void)
-{
-	/* setup mips r4k timer */
-	mips_hpt_frequency = cpu_clock_freq / 2;
-}
-
-unsigned long read_persistent_clock(void)
-{
-	return mc146818_get_cmos_time();
-}
-- 
1.6.2.1


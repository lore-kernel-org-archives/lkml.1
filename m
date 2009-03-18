Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbZCRVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbZCRVvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZCRVnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:24 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757917AbZCRVnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:21 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 22/57] microblaze_v7: setup.c, setup.h - system setting
Date: Wed, 18 Mar 2009 21:30:49 +0100
Message-Id: <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/setup.h |   43 ++++++++
 arch/microblaze/kernel/setup.c      |  198 +++++++++++++++++++++++++++++++++++
 2 files changed, 241 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/setup.h
 create mode 100644 arch/microblaze/kernel/setup.c

diff --git a/arch/microblaze/include/asm/setup.h b/arch/microblaze/include/asm/setup.h
new file mode 100644
index 0000000..70075fe
--- /dev/null
+++ b/arch/microblaze/include/asm/setup.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SETUP_H
+#define _ASM_MICROBLAZE_SETUP_H
+
+# ifndef __ASSEMBLY__
+
+#  ifdef __KERNEL__
+extern unsigned int boot_cpuid; /* move to smp.h */
+
+#  define COMMAND_LINE_SIZE	256
+extern char cmd_line[COMMAND_LINE_SIZE];
+#  endif/* __KERNEL__ */
+
+void early_printk(const char *fmt, ...);
+
+int setup_early_printk(char *opt);
+void disable_early_printk(void);
+
+void heartbeat(void);
+void setup_heartbeat(void);
+
+unsigned long long sched_clock(void);
+
+void time_init(void);
+void init_IRQ(void);
+void machine_early_init(const char *cmdline, unsigned int ram,
+						unsigned int fdt);
+
+void machine_restart(char *cmd);
+void machine_shutdown(void);
+void machine_halt(void);
+void machine_power_off(void);
+
+# endif /* __ASSEMBLY__ */
+#endif /* _ASM_MICROBLAZE_SETUP_H */
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
new file mode 100644
index 0000000..d50184b
--- /dev/null
+++ b/arch/microblaze/kernel/setup.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/cpu.h>
+#include <linux/initrd.h>
+#include <linux/console.h>
+#include <linux/debugfs.h>
+
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/page.h>
+#include <linux/io.h>
+#include <linux/bug.h>
+#include <linux/param.h>
+#include <linux/cache.h>
+#include <asm/cacheflush.h>
+#include <asm/entry.h>
+#include <asm/cpuinfo.h>
+
+#include <asm/system.h>
+#include <asm/prom.h>
+#include <asm/pgtable.h>
+
+DEFINE_PER_CPU(unsigned int, KSP);	/* Saved kernel stack pointer */
+DEFINE_PER_CPU(unsigned int, KM);	/* Kernel/user mode */
+DEFINE_PER_CPU(unsigned int, ENTRY_SP);	/* Saved SP on kernel entry */
+DEFINE_PER_CPU(unsigned int, R11_SAVE);	/* Temp variable for entry */
+DEFINE_PER_CPU(unsigned int, CURRENT_SAVE);	/* Saved current pointer */
+
+unsigned int boot_cpuid;
+char cmd_line[COMMAND_LINE_SIZE];
+
+void __init setup_arch(char **cmdline_p)
+{
+#ifdef CONFIG_CMDLINE_FORCE
+	strlcpy(cmd_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+#endif
+	*cmdline_p = cmd_line;
+
+	console_verbose();
+
+	unflatten_device_tree();
+
+	/* NOTE I think that this function is not necessary to call */
+	/* irq_early_init(); */
+	setup_cpuinfo();
+
+	__invalidate_icache_all();
+	__enable_icache();
+
+	__invalidate_dcache_all();
+	__enable_dcache();
+
+	panic_timeout = 120;
+
+	setup_memory();
+
+#if defined(CONFIG_SELFMOD_INTC) || defined(CONFIG_SELFMOD_TIMER)
+	printk(KERN_NOTICE "Self modified code enable\n");
+#endif
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_XILINX_CONSOLE)
+	conswitchp = &xil_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
+
+#ifdef CONFIG_MTD_UCLINUX
+/* Handle both romfs and cramfs types, without generating unnecessary
+ code (ie no point checking for CRAMFS if it's not even enabled) */
+inline unsigned get_romfs_len(unsigned *addr)
+{
+#ifdef CONFIG_ROMFS_FS
+	if (memcmp(&addr[0], "-rom1fs-", 8) == 0) /* romfs */
+		return be32_to_cpu(addr[2]);
+#endif
+
+#ifdef CONFIG_CRAMFS
+	if (addr[0] == le32_to_cpu(0x28cd3d45)) /* cramfs */
+		return le32_to_cpu(addr[1]);
+#endif
+	return 0;
+}
+#endif	/* CONFIG_MTD_UCLINUX_EBSS */
+
+void __init machine_early_init(const char *cmdline, unsigned int ram,
+		unsigned int fdt)
+{
+	unsigned long *src, *dst = (unsigned long *)0x0;
+
+/* clearing bss section */
+	memset(__bss_start, 0, __bss_stop-__bss_start);
+	memset(_ssbss, 0, _esbss-_ssbss);
+
+	/*
+	* Copy command line passed from bootloader, or use default
+	* if none provided, or forced
+	*/
+#ifndef CONFIG_CMDLINE_BOOL
+	if (cmdline && cmdline[0] != '\0')
+		strlcpy(cmd_line, cmdline, COMMAND_LINE_SIZE);
+#endif
+
+/* initialize device tree for usage in early_printk */
+	early_init_devtree((void *)_fdt_start);
+
+#ifdef CONFIG_EARLY_PRINTK
+	setup_early_printk(NULL);
+#endif
+
+	early_printk("Ramdisk addr 0x%08x, FDT 0x%08x\n", ram, fdt);
+	printk(KERN_NOTICE "Found FDT at 0x%08x\n", fdt);
+
+#ifdef CONFIG_MTD_UCLINUX
+	{
+		int size;
+		unsigned int romfs_base;
+		romfs_base = (ram ? ram : (unsigned int)&__init_end);
+		/* if CONFIG_MTD_UCLINUX_EBSS is defined, assume ROMFS is at the
+		 * end of kernel, which is ROMFS_LOCATION defined above. */
+		size = PAGE_ALIGN(get_romfs_len((unsigned *)romfs_base));
+		early_printk("Found romfs @ 0x%08x (0x%08x)\n",
+				romfs_base, size);
+		early_printk("#### klimit %p ####\n", klimit);
+		BUG_ON(size < 0); /* What else can we do? */
+
+		/* Use memmove to handle likely case of memory overlap */
+		early_printk("Moving 0x%08x bytes from 0x%08x to 0x%08x\n",
+			size, romfs_base, (unsigned)&_ebss);
+		memmove(&_ebss, (int *)romfs_base, size);
+
+		/* update klimit */
+		klimit += PAGE_ALIGN(size);
+		early_printk("New klimit: 0x%08x\n", (unsigned)klimit);
+	}
+#endif
+
+	for (src = __ivt_start; src < __ivt_end; src++, dst++)
+		*dst = *src;
+
+	/* Initialize global data */
+	per_cpu(KM, 0) = 0x1;	/* We start in kernel mode */
+	per_cpu(CURRENT_SAVE, 0) = (unsigned long)current;
+}
+
+#ifdef CONFIG_DEBUG_FS
+struct dentry *of_debugfs_root;
+
+static int microblaze_debugfs_init(void)
+{
+	of_debugfs_root = debugfs_create_dir("microblaze", NULL);
+
+	return of_debugfs_root == NULL;
+}
+arch_initcall(microblaze_debugfs_init);
+#endif
+
+void machine_restart(char *cmd)
+{
+	printk(KERN_NOTICE "Machine restart...\n");
+	dump_stack();
+	while (1)
+		;
+}
+
+void machine_shutdown(void)
+{
+	printk(KERN_NOTICE "Machine shutdown...\n");
+	while (1)
+		;
+}
+
+void machine_halt(void)
+{
+	printk(KERN_NOTICE "Machine halt...\n");
+	while (1)
+		;
+}
+
+void machine_power_off(void)
+{
+	printk(KERN_NOTICE "Machine power off...\n");
+	while (1)
+		;
+}
-- 
1.5.5.1


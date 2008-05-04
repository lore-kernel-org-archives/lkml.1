Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYEDPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYEDPta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYEDPtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:49:19 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:49332 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752523AbYEDPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:49:18 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 21/56] microblaze_v2: setup.c - system setting
Date: Sun,  4 May 2008 13:41:10 +0200
Message-Id: <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/setup.c |  189 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 189 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/setup.c

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
new file mode 100644
index 0000000..afd2786
--- /dev/null
+++ b/arch/microblaze/kernel/setup.c
@@ -0,0 +1,189 @@
+/*
+ * arch/microblaze/kernel/setup.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+#include <asm/io.h>
+#include <asm/bug.h>
+#include <asm/param.h>
+#include <asm/cache.h>
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
+static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+
+void __init setup_arch(char **cmdline_p)
+{
+	console_verbose();
+
+	unflatten_device_tree();
+	/* NOTE I think that this function is not necessary to call */
+	/* irq_early_init(); */
+	setup_cpuinfo();
+
+	__flush_icache_all();
+	__enable_icache();
+
+	__flush_dcache_all();
+	__enable_dcache();
+
+	panic_timeout = 120;
+
+	setup_memory();
+	paging_init();
+#ifdef CONFIG_HACK
+	printk(KERN_NOTICE "HACK function enable\n");
+#else
+	printk(KERN_NOTICE "HACK function disable\n");
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
+	early_printk("Ramdisk addr 0x%08x, FDT 0x%08x\n", ram, fdt);
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
+	memset(__bss_start, 0, __bss_stop-__bss_start);
+	memset(_ssbss, 0, _esbss-_ssbss);
+
+	printk(KERN_NOTICE "Found FDT at 0x%08x\n", fdt);
+	early_init_devtree((void *)fdt);
+
+	/* Copy command line passed from bootloader, or use default
+	 if none provided, or forced */
+#ifndef CONFIG_CMDLINE_FORCE
+	if (cmdline && cmdline[0] != '\0')
+		strlcpy(cmd_line, cmdline, COMMAND_LINE_SIZE);
+	else
+#endif
+		strlcpy(cmd_line, default_command_line, COMMAND_LINE_SIZE);
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
1.5.4.GIT


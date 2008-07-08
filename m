Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbYGHMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbYGHMLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbYGHMK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:10:26 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:26198 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758024AbYGHMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:10:18 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 22/58] microblaze_v5: setup.c - system setting
Date: Tue,  8 Jul 2008 13:59:22 +0200
Message-Id: <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/setup.c |  195 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/setup.c

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
new file mode 100644
index 0000000..6015d5a
--- /dev/null
+++ b/arch/microblaze/kernel/setup.c
@@ -0,0 +1,195 @@
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
+int have_of = 1;
+unsigned int boot_cpuid;
+char cmd_line[COMMAND_LINE_SIZE];
+
+#ifdef CONFIG_CMDLINE_BOOL
+static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+#endif
+
+void __init setup_memory(void);
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
+	__invalidate_icache_all();
+	__enable_icache();
+
+	__invalidate_dcache_all();
+	__enable_dcache();
+
+	panic_timeout = 120;
+
+	setup_memory();
+	paging_init();
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
+#ifdef CONFIG_CMDLINE_BOOL
+#ifndef CONFIG_CMDLINE_FORCE
+	if (cmdline && cmdline[0] != '\0')
+		strlcpy(cmd_line, cmdline, COMMAND_LINE_SIZE);
+	else
+#endif
+		strlcpy(cmd_line, default_command_line, COMMAND_LINE_SIZE);
+#endif
+
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


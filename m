Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYLAM45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYLAM45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYLAM4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:56:18 -0500
Received: from ozlabs.org ([203.10.76.45]:44040 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbYLAM4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:56:10 -0500
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>, Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       David Howells <dhowells@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
CC: Russell King <rmk@arm.linux.org.uk>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Bryan Wu <cooloney@kernel.org>
CC: Mikael Starvik <starvik@axis.com>
CC: David Howells <dhowells@redhat.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: David Howells <dhowells@redhat.com>
CC: Grant Grundler <grundler@parisc-linux.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Dike <jdike@addtoit.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Chris Zankel <chris@zankel.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:26:01 +1030
Subject: [RFC 5/8] param: arch_get_boot_command_line()
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012326.03151.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows us to get the command line before setup_arch(): right at
the beginning of start_kernel().  It also cleans up chaotic
commandline handling.

This means most setup_arch boutique early cmdline handling can be
turned into core_params.  This saves some bytes, but also gets them
the optional sysfs presence.

I used fixme's to suggest further arch-specific cleanups.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/kernel/setup.c                  |   36 ++++++++++++++++-----------
 arch/arm/kernel/setup.c                    |   31 ++++++++++++++---------
 arch/arm/mach-pxa/corgi.c                  |    2 -
 arch/arm/mach-s3c2412/mach-smdk2413.c      |    2 -
 arch/arm/mach-s3c2412/mach-vstms.c         |    2 -
 arch/avr32/kernel/setup.c                  |    4 ---
 arch/blackfin/kernel/setup.c               |   22 ++++++++--------
 arch/cris/kernel/setup.c                   |   29 +++++++++++-----------
 arch/frv/kernel/setup.c                    |   11 +++++---
 arch/h8300/kernel/setup.c                  |   27 ++++++++++----------
 arch/ia64/dig/setup.c                      |    2 -
 arch/ia64/hp/sim/hpsim_setup.c             |    2 -
 arch/ia64/include/asm/machvec.h            |    4 +--
 arch/ia64/include/asm/paravirt.h           |    8 +++---
 arch/ia64/kernel/machvec.c                 |    2 -
 arch/ia64/kernel/setup.c                   |   22 +++++++++-------
 arch/ia64/sn/kernel/setup.c                |    9 +++---
 arch/ia64/uv/kernel/setup.c                |    2 -
 arch/ia64/xen/xen_pv_ops.c                 |    2 -
 arch/m32r/kernel/setup.c                   |   16 ++++++------
 arch/m68k/kernel/setup.c                   |   25 ++++++++++++-------
 arch/m68knommu/include/asm/machdep.h       |    2 -
 arch/m68knommu/kernel/setup.c              |   33 ++++++++++++-------------
 arch/m68knommu/platform/5206/config.c      |    2 -
 arch/m68knommu/platform/5206e/config.c     |   16 ++++++------
 arch/m68knommu/platform/520x/config.c      |    2 -
 arch/m68knommu/platform/523x/config.c      |    2 -
 arch/m68knommu/platform/5249/config.c      |    2 -
 arch/m68knommu/platform/5272/config.c      |   23 +++++++++--------
 arch/m68knommu/platform/527x/config.c      |    2 -
 arch/m68knommu/platform/528x/config.c      |    2 -
 arch/m68knommu/platform/5307/config.c      |   13 ++++++---
 arch/m68knommu/platform/532x/config.c      |   22 +++++++---------
 arch/m68knommu/platform/5407/config.c      |    2 -
 arch/m68knommu/platform/68328/config.c     |    2 -
 arch/m68knommu/platform/68328/head-pilot.S |    2 -
 arch/m68knommu/platform/68360/config.c     |    6 +++-
 arch/m68knommu/platform/68EZ328/config.c   |    4 ++-
 arch/m68knommu/platform/68VZ328/config.c   |   12 +++++----
 arch/mips/kernel/setup.c                   |   18 +++++++------
 arch/mn10300/kernel/setup.c                |   17 ++++++------
 arch/parisc/kernel/setup.c                 |   30 +++++++++-------------
 arch/powerpc/kernel/setup_32.c             |   10 +++++--
 arch/powerpc/kernel/setup_64.c             |    8 ++++--
 arch/s390/kernel/setup.c                   |    6 ----
 arch/sh/boards/board-magicpanelr2.c        |    2 -
 arch/sh/boards/board-sh7785lcr.c           |    2 -
 arch/sh/boards/mach-dreamcast/setup.c      |    2 -
 arch/sh/boards/mach-highlander/setup.c     |    2 -
 arch/sh/boards/mach-hp6xx/setup.c          |    2 -
 arch/sh/boards/mach-landisk/setup.c        |    2 -
 arch/sh/boards/mach-microdev/setup.c       |    2 -
 arch/sh/boards/mach-migor/setup.c          |    2 -
 arch/sh/boards/mach-r2d/setup.c            |    2 -
 arch/sh/boards/mach-sdk7780/setup.c        |    2 -
 arch/sh/boards/mach-se/7343/setup.c        |    2 -
 arch/sh/boards/mach-se/770x/setup.c        |    2 -
 arch/sh/boards/mach-se/7721/setup.c        |    2 -
 arch/sh/boards/mach-se/7722/setup.c        |    2 -
 arch/sh/boards/mach-se/7780/setup.c        |    2 -
 arch/sh/boards/mach-sh03/setup.c           |    2 -
 arch/sh/boards/mach-sh7763rdp/setup.c      |    2 -
 arch/sh/include/asm/machvec.h              |    2 -
 arch/sh/kernel/setup.c                     |   26 ++++++++++---------
 arch/sparc/kernel/setup.c                  |   13 ++++++---
 arch/sparc64/kernel/setup.c                |   13 ++++++---
 arch/um/kernel/um_arch.c                   |   10 +++++--
 arch/x86/kernel/setup.c                    |   38 +++++++++++++++--------------
 arch/xtensa/kernel/setup.c                 |   19 +++++++-------
 include/linux/init.h                       |    3 +-
 init/main.c                                |   20 +++++++++------
 kernel/kexec.c                             |    1 
 72 files changed, 371 insertions(+), 306 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -496,8 +496,27 @@ register_cpus(void)
 
 arch_initcall(register_cpus);
 
+void arch_get_boot_command_line(void)
+{
+	/*
+	 * Locate the command line.
+	 */
+	/* Hack for Jensen... since we're restricted to 8 or 16 chars for
+	   boot flags depending on the boot mode, we need some shorthand.
+	   This should do for installation.  */
+	if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
+		strlcpy(command_line, "root=/dev/fd0 load_ramdisk=1",
+			sizeof command_line);
+	} else {
+		strlcpy(command_line, COMMAND_LINE, sizeof command_line);
+	}
+
+	/* FIXME: Can we skip command_line and just use boot_command_line? */
+	strcpy(boot_command_line, command_line);
+}
+
 void __init
-setup_arch(char **cmdline_p)
+setup_arch(void)
 {
 	extern char _end[];
 
@@ -542,21 +561,8 @@ setup_arch(char **cmdline_p)
 	kernel_end = callback_init(kernel_end);
 
 	/* 
-	 * Locate the command line.
-	 */
-	/* Hack for Jensen... since we're restricted to 8 or 16 chars for
-	   boot flags depending on the boot mode, we need some shorthand.
-	   This should do for installation.  */
-	if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
-		strlcpy(command_line, "root=/dev/fd0 load_ramdisk=1", sizeof command_line);
-	} else {
-		strlcpy(command_line, COMMAND_LINE, sizeof command_line);
-	}
-	strcpy(boot_command_line, command_line);
-	*cmdline_p = command_line;
-
-	/* 
 	 * Process command-line arguments.
+	 * FIXME: Use core_param.
 	 */
 	while ((p = strsep(&args, " \t")) != NULL) {
 		if (!*p) continue;
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -414,9 +414,11 @@ __early_param("mem=", early_mem);
 
 /*
  * Initial parsing of the command line.
+ * FIXME: Use generic early_param / core_param code here.
  */
-static void __init parse_cmdline(char **cmdline_p, char *from)
+static void __init parse_cmdline(void)
 {
+	const char *from = boot_command_line;
 	char c = ' ', *to = command_line;
 	int len = 0;
 
@@ -448,7 +450,6 @@ static void __init parse_cmdline(char **
 		*to++ = c;
 	}
 	*to = '\0';
-	*cmdline_p = command_line;
 }
 
 static void __init
@@ -673,11 +674,24 @@ static int __init customize_machine(void
 }
 arch_initcall(customize_machine);
 
-void __init setup_arch(char **cmdline_p)
+void arch_get_boot_command_line(void)
+{
+	struct machine_desc *mdesc;
+	const char *from;
+
+	mdesc = setup_machine(machine_arch_type);
+	if (mdesc->cmdline)
+		from = mdesc->cmdline();
+	else
+		from = default_command_line;
+
+	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
-	char *from;
 
 	setup_processor();
 	mdesc = setup_machine(machine_arch_type);
@@ -700,11 +714,6 @@ void __init setup_arch(char **cmdline_p)
 	if (tags->hdr.tag != ATAG_CORE)
 		tags = (struct tag *)&init_tags;
 
-	if (mdesc->cmdline)
-		from = mdesc->cmdline();
-	else
-		from = default_command_line;
-
 	if (mdesc->fixup)
 		mdesc->fixup(mdesc, tags, &meminfo);
 
@@ -720,9 +729,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data   = (unsigned long) &_edata;
 	init_mm.brk	   = (unsigned long) &_end;
 
-	memcpy(boot_command_line, from, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
-	parse_cmdline(cmdline_p, from);
+	parse_cmdline();
 	paging_init(&meminfo, mdesc);
 	request_standard_resources(&meminfo, mdesc);
 
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -589,7 +589,7 @@ static void __init corgi_init(void)
 }
 
 static void __init fixup_corgi(struct machine_desc *desc,
-		struct tag *tags, char **cmdline, struct meminfo *mi)
+		struct tag *tags, struct meminfo *mi)
 {
 	sharpsl_save_param();
 	mi->nr_banks=1;
diff --git a/arch/arm/mach-s3c2412/mach-smdk2413.c b/arch/arm/mach-s3c2412/mach-smdk2413.c
--- a/arch/arm/mach-s3c2412/mach-smdk2413.c
+++ b/arch/arm/mach-s3c2412/mach-smdk2413.c
@@ -111,7 +111,7 @@ static struct platform_device *smdk2413_
 };
 
 static void __init smdk2413_fixup(struct machine_desc *desc,
-				  struct tag *tags, char **cmdline,
+				  struct tag *tags,
 				  struct meminfo *mi)
 {
 	if (tags != phys_to_virt(S3C2410_SDRAM_PA + 0x100)) {
diff --git a/arch/arm/mach-s3c2412/mach-vstms.c b/arch/arm/mach-s3c2412/mach-vstms.c
--- a/arch/arm/mach-s3c2412/mach-vstms.c
+++ b/arch/arm/mach-s3c2412/mach-vstms.c
@@ -129,7 +129,7 @@ static struct platform_device *vstms_dev
 };
 
 static void __init vstms_fixup(struct machine_desc *desc,
-				  struct tag *tags, char **cmdline,
+				  struct tag *tags,
 				  struct meminfo *mi)
 {
 	if (tags != phys_to_virt(S3C2410_SDRAM_PA + 0x100)) {
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -536,7 +536,7 @@ static void __init setup_bootmem(void)
 	}
 }
 
-void __init setup_arch (char **cmdline_p)
+void __init setup_arch(void)
 {
 	struct clk *cpu_clk;
 
@@ -579,8 +579,6 @@ void __init setup_arch (char **cmdline_p
 		       ((cpu_hz + 500) / 1000) % 1000);
 	}
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
 	parse_early_param();
 
 	setup_bootmem();
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -710,23 +710,23 @@ static inline int __init get_mem_size(vo
 	BUG();
 }
 
-void __init setup_arch(char **cmdline_p)
+void arch_get_boot_command_line(void)
+{
+#if defined(CONFIG_CMDLINE_BOOL)
+	strlcpy(command_line, CONFIG_CMDLINE, sizeof(command_line));
+#endif
+
+	/* FIXME: Get rid of command_line and just use boot_command_line? */
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	unsigned long sclk, cclk;
 
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
 #endif
-
-#if defined(CONFIG_CMDLINE_BOOL)
-	strncpy(&command_line[0], CONFIG_CMDLINE, sizeof(command_line));
-	command_line[sizeof(command_line) - 1] = 0;
-#endif
-
-	/* Keep a copy of command line */
-	*cmdline_p = &command_line[0];
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
 
 	/* setup memory defaults from the user config */
 	physical_mem_end = 0;
diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
--- a/arch/cris/kernel/setup.c
+++ b/arch/cris/kernel/setup.c
@@ -40,6 +40,20 @@ static struct cpu cpu_devices[NR_CPUS];
 
 extern void show_etrax_copyright(void);		/* arch-vX/kernel/setup.c */
 
+void __init arch_get_boot_command_line(void)
+{
+#ifdef CONFIG_ETRAX_CMDLINE
+	if (!strcmp(cris_command_line, "")) {
+		strlcpy(cris_command_line, CONFIG_ETRAX_CMDLINE,
+			COMMAND_LINE_SIZE);
+		cris_command_line[COMMAND_LINE_SIZE - 1] = '\0';
+	}
+#endif
+
+	/* FIXME: Do we need cris_command_line at all? */
+	strlcpy(boot_command_line, cris_command_line, COMMAND_LINE_SIZE);
+}
+
 /* This mainly sets up the memory area, and can be really confusing.
  *
  * The physical DRAM is virtually mapped into dram_start to dram_end
@@ -56,7 +70,7 @@ extern void show_etrax_copyright(void);	
  *
  */
 
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
 	extern void init_etrax_debug(void);
 	unsigned long bootmap_size;
@@ -144,19 +158,6 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init();
 
-	*cmdline_p = cris_command_line;
-
-#ifdef CONFIG_ETRAX_CMDLINE
-        if (!strcmp(cris_command_line, "")) {
-		strlcpy(cris_command_line, CONFIG_ETRAX_CMDLINE, COMMAND_LINE_SIZE);
-		cris_command_line[COMMAND_LINE_SIZE - 1] = '\0';
-	}
-#endif
-
-	/* Save command line for future references. */
-	memcpy(boot_command_line, cris_command_line, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
-
 	/* give credit for the CRIS port */
 	show_etrax_copyright();
 
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -721,6 +721,7 @@ void __cpuinit calibrate_delay(void)
 /*****************************************************************************/
 /*
  * look through the command line for some things we need to know immediately
+ * FIXME: Use core_param or early_param.
  */
 static void __init parse_cmdline_early(char *cmdline)
 {
@@ -747,19 +748,22 @@ static void __init parse_cmdline_early(c
 
 } /* end parse_cmdline_early() */
 
+void __init arch_get_boot_command_line(void)
+{
+	memcpy(boot_command_line, redboot_command_line, COMMAND_LINE_SIZE);
+}
+
 /*****************************************************************************/
 /*
  *
  */
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
 #ifdef CONFIG_MMU
 	printk("Linux FR-V port done by Red Hat Inc <dhowells@redhat.com>\n");
 #else
 	printk("uClinux FR-V port done by Red Hat Inc <dhowells@redhat.com>\n");
 #endif
-
-	memcpy(boot_command_line, redboot_command_line, COMMAND_LINE_SIZE);
 
 	determine_cpu();
 	determine_clocks(1);
@@ -794,7 +798,6 @@ void __init setup_arch(char **cmdline_p)
 
 	/* deal with the command line - RedBoot may have passed one to the kernel */
 	memcpy(command_line, boot_command_line, sizeof(command_line));
-	*cmdline_p = &command_line[0];
 	parse_cmdline_early(command_line);
 
 	/* set up the memory description
diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -91,7 +91,18 @@ static const struct console gdb_console 
 };
 #endif
 
-void __init setup_arch(char **cmdline_p)
+/* FIXME: Can we avoid command_line temporary? */
+void __init arch_get_boot_command_line(void)
+{
+#ifdef CONFIG_DEFAULT_CMDLINE
+	/* set from default command line */
+	if (*command_line == '\0')
+		strcpy(command_line, CONFIG_KERNEL_COMMAND);
+#endif
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	int bootmap_size;
 
@@ -145,19 +156,9 @@ void __init setup_arch(char **cmdline_p)
 		(int) memory_end, (int) &_ramend);
 #endif
 
-#ifdef CONFIG_DEFAULT_CMDLINE
-	/* set from default command line */
-	if (*command_line == '\0')
-		strcpy(command_line,CONFIG_KERNEL_COMMAND);
-#endif
-	/* Keep a copy of command line */
-	*cmdline_p = &command_line[0];
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = 0;
-
 #ifdef DEBUG
-	if (strlen(*cmdline_p)) 
-		printk(KERN_DEBUG "Command line: '%s'\n", *cmdline_p);
+	if (strlen(command_line))
+		printk(KERN_DEBUG "Command line: '%s'\n", command_line);
 #endif
 
 	/*
diff --git a/arch/ia64/dig/setup.c b/arch/ia64/dig/setup.c
--- a/arch/ia64/dig/setup.c
+++ b/arch/ia64/dig/setup.c
@@ -25,7 +25,7 @@
 #include <asm/system.h>
 
 void __init
-dig_setup (char **cmdline_p)
+dig_setup(void)
 {
 	unsigned int orig_x, orig_y, num_cols, num_rows, font_height;
 
diff --git a/arch/ia64/hp/sim/hpsim_setup.c b/arch/ia64/hp/sim/hpsim_setup.c
--- a/arch/ia64/hp/sim/hpsim_setup.c
+++ b/arch/ia64/hp/sim/hpsim_setup.c
@@ -38,7 +38,7 @@ ia64_ctl_trace (long on)
 }
 
 void __init
-hpsim_setup (char **cmdline_p)
+hpsim_setup(void)
 {
 	ROOT_DEV = Root_SDA1;		/* default to first SCSI drive */
 
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -25,7 +25,7 @@ struct msi_desc;
 struct msi_desc;
 struct dma_attrs;
 
-typedef void ia64_mv_setup_t (char **);
+typedef void ia64_mv_setup_t (void);
 typedef void ia64_mv_cpu_init_t (void);
 typedef void ia64_mv_irq_init_t (void);
 typedef void ia64_mv_send_ipi_t (int, int, int, int);
@@ -111,7 +111,7 @@ machvec_noop_bus (struct pci_bus *bus)
 {
 }
 
-extern void machvec_setup (char **);
+extern void machvec_setup(void);
 extern void machvec_timer_interrupt (int, void *);
 extern void machvec_dma_sync_single (struct device *, dma_addr_t, size_t, int);
 extern void machvec_dma_sync_sg (struct device *, struct scatterlist *, int, int);
diff --git a/arch/ia64/include/asm/paravirt.h b/arch/ia64/include/asm/paravirt.h
--- a/arch/ia64/include/asm/paravirt.h
+++ b/arch/ia64/include/asm/paravirt.h
@@ -64,7 +64,7 @@ struct pv_init_ops {
 	int (*reserve_memory)(struct rsvd_region *region);
 
 	void (*arch_setup_early)(void);
-	void (*arch_setup_console)(char **cmdline_p);
+	void (*arch_setup_console)(void);
 	int (*arch_setup_nomca)(void);
 
 	void (*post_smp_prepare_boot_cpu)(void);
@@ -91,10 +91,10 @@ static inline void paravirt_arch_setup_e
 		pv_init_ops.arch_setup_early();
 }
 
-static inline void paravirt_arch_setup_console(char **cmdline_p)
+static inline void paravirt_arch_setup_console(void)
 {
 	if (pv_init_ops.arch_setup_console)
-		pv_init_ops.arch_setup_console(cmdline_p);
+		pv_init_ops.arch_setup_console();
 }
 
 static inline int paravirt_arch_setup_nomca(void)
@@ -238,7 +238,7 @@ paravirt_do_steal_accounting(unsigned lo
 #define paravirt_reserve_memory(region)			0
 
 #define paravirt_arch_setup_early()			do { } while (0)
-#define paravirt_arch_setup_console(cmdline_p)		do { } while (0)
+#define paravirt_arch_setup_console()			do { } while (0)
 #define paravirt_arch_setup_nomca()			0
 #define paravirt_post_smp_prepare_boot_cpu()		do { } while (0)
 
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -63,7 +63,7 @@ machvec_init_from_cmdline(const char *cm
 #endif /* CONFIG_IA64_GENERIC */
 
 void
-machvec_setup (char **arg)
+machvec_setup(void)
 {
 }
 EXPORT_SYMBOL(machvec_setup);
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -447,7 +447,7 @@ io_port_init (void)
  * Returns non-zero if a console couldn't be setup.
  */
 static inline int __init
-early_console_setup (char *cmdline)
+early_console_setup(char *cmdline)
 {
 	int earlycons = 0;
 
@@ -529,17 +529,19 @@ int __init reserve_elfcorehdr(unsigned l
 
 #endif /* CONFIG_PROC_VMCORE */
 
-void __init
-setup_arch (char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	strlcpy(boot_command_line, __va(ia64_boot_param->command_line)
+		COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	unw_init();
 
 	paravirt_arch_setup_early();
 
 	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
-
-	*cmdline_p = __va(ia64_boot_param->command_line);
-	strlcpy(boot_command_line, *cmdline_p, COMMAND_LINE_SIZE);
 
 	efi_init();
 	io_port_init();
@@ -550,12 +552,12 @@ setup_arch (char **cmdline_p)
 	 * that ia64_mv is initialised before any command line
 	 * settings may cause console setup to occur
 	 */
-	machvec_init_from_cmdline(*cmdline_p);
+	machvec_init_from_cmdline(boot_command_line);
 #endif
 
 	parse_early_param();
 
-	if (early_console_setup(*cmdline_p) == 0)
+	if (early_console_setup(boot_command_line) == 0)
 		mark_bsp_online();
 
 #ifdef CONFIG_ACPI
@@ -605,7 +607,7 @@ setup_arch (char **cmdline_p)
 #endif
 
 	paravirt_banner();
-	paravirt_arch_setup_console(cmdline_p);
+	paravirt_arch_setup_console();
 
 #ifdef CONFIG_VT
 	if (!conswitchp) {
@@ -631,7 +633,7 @@ setup_arch (char **cmdline_p)
 	if (!nomca)
 		ia64_mca_init();
 
-	platform_setup(cmdline_p);
+	platform_setup(boot_command_line);
 #ifndef CONFIG_IA64_HP_SIM
 	check_sal_cache_flush();
 #endif
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -361,13 +361,12 @@ static unsigned long sn2_rtc_initial;
 
 /**
  * sn_setup - SN platform setup routine
- * @cmdline_p: kernel command line
  *
  * Handles platform setup for SN machines.  This includes determining
  * the RTC frequency (via a SAL call), initializing secondary CPUs, and
  * setting up per-node data areas.  The console is also initialized here.
  */
-void __init sn_setup(char **cmdline_p)
+void __init sn_setup(void)
 {
 	long status, ticks_per_sec, drift;
 	u32 version = sn_sal_rev();
@@ -425,11 +424,11 @@ void __init sn_setup(char **cmdline_p)
 
 	if (vga_console_membase) {
 		/* usable vga ... make tty0 the preferred default console */
-		if (!strstr(*cmdline_p, "console="))
+		if (!strstr(boot_command_line, "console="))
 			add_preferred_console("tty", 0, NULL);
 	} else {
 		printk(KERN_DEBUG "SGI: Disabling VGA console\n");
-		if (!strstr(*cmdline_p, "console="))
+		if (!strstr(boot_command_line, "console="))
 			add_preferred_console("ttySG", 0, NULL);
 #ifdef CONFIG_DUMMY_CONSOLE
 		conswitchp = &dummy_con;
@@ -470,7 +469,7 @@ void __init sn_setup(char **cmdline_p)
 	/*
 	 * Create the PDAs and NODEPDAs for all the cpus.
 	 */
-	sn_init_pdas(cmdline_p);
+	sn_init_pdas();
 
 	ia64_mark_idle = &snidle;
 
diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -58,7 +58,7 @@ static __init void get_lowmem_redirect(u
 	BUG();
 }
 
-void __init uv_setup(char **cmdline_p)
+void __init uv_setup(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
 	union uvh_node_id_u node_id;
diff --git a/arch/ia64/xen/xen_pv_ops.c b/arch/ia64/xen/xen_pv_ops.c
--- a/arch/ia64/xen/xen_pv_ops.c
+++ b/arch/ia64/xen/xen_pv_ops.c
@@ -129,7 +129,7 @@ xen_arch_setup_early(void)
 }
 
 static void __init
-xen_arch_setup_console(char **cmdline_p)
+xen_arch_setup_console(void)
 {
 	add_preferred_console("xenboot", 0, NULL);
 	add_preferred_console("tty", 0, NULL);
diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -83,20 +83,21 @@ unsigned long memory_start;
 unsigned long memory_start;
 unsigned long memory_end;
 
-void __init setup_arch(char **);
 int get_cpuinfo(char *);
 
-static __inline__ void parse_mem_cmdline(char ** cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	strlcpy(boot_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
+}
+
+/* FIXME: use core_param/early_param here. */
+static inline void parse_mem_cmdline(void)
 {
 	char c = ' ';
 	char *to = command_line;
 	char *from = COMMAND_LINE;
 	int len = 0;
 	int usermem = 0;
-
-	/* Save unparsed command line copy for /proc/cmdline */
-	memcpy(boot_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 
 	memory_start = (unsigned long)CONFIG_MEMORY_START+PAGE_OFFSET;
 	memory_end = memory_start+(unsigned long)CONFIG_MEMORY_SIZE;
@@ -124,7 +125,6 @@ static __inline__ void parse_mem_cmdline
 		*(to++) = c;
 	}
 	*to = '\0';
-	*cmdline_p = command_line;
 	if (usermem)
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 }
@@ -220,7 +220,7 @@ extern unsigned long setup_memory(void);
 extern unsigned long setup_memory(void);
 #endif	/* CONFIG_DISCONTIGMEM */
 
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
 	ROOT_DEV = old_decode_dev(ORIG_ROOT_DEV);
 
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -74,8 +74,6 @@ EXPORT_SYMBOL(m68k_memory);
 EXPORT_SYMBOL(m68k_memory);
 
 struct mem_info m68k_ramdisk;
-
-static char m68k_command_line[CL_SIZE];
 
 void (*mach_sched_init) (irq_handler_t handler) __initdata = NULL;
 /* machine dependent irq functions */
@@ -170,8 +168,7 @@ static void __init m68k_parse_bootinfo(c
 			break;
 
 		case BI_COMMAND_LINE:
-			strlcpy(m68k_command_line, (const char *)data,
-				sizeof(m68k_command_line));
+			/* Done in arch_get_boot_command_line */
 			break;
 
 		default:
@@ -213,7 +210,22 @@ static void __init m68k_parse_bootinfo(c
 #endif
 }
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	extern char _end[];
+	/* The bootinfo is located right after the kernel bss */
+	const struct bi_record *record = (const struct bi_record *)&_end;
+
+	while (record->tag != BI_LAST) {
+		if (record->tag == BI_COMMAND_LINE)
+			strlcpy(boot_command_line, (const char *)record->data,
+				COMMAND_LINE_SIZE);
+
+		record = ((void *)record) + record->size;
+	}
+}
+
+void __init setup_arch(void)
 {
 	extern int _etext, _edata, _end;
 	int i;
@@ -255,9 +267,6 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_code = (unsigned long) &_etext;
 	init_mm.end_data = (unsigned long) &_edata;
 	init_mm.brk = (unsigned long) &_end;
-
-	*cmdline_p = m68k_command_line;
-	memcpy(boot_command_line, *cmdline_p, CL_SIZE);
 
 	parse_early_param();
 
diff --git a/arch/m68knommu/include/asm/machdep.h b/arch/m68knommu/include/asm/machdep.h
--- a/arch/m68knommu/include/asm/machdep.h
+++ b/arch/m68knommu/include/asm/machdep.h
@@ -19,7 +19,7 @@ extern void (*mach_halt)( void );
 extern void (*mach_halt)( void );
 extern void (*mach_power_off)( void );
 
-extern void config_BSP(char *command, int len);
+extern void config_BSP(void);
 
 extern void do_IRQ(int irq, struct pt_regs *fp);
 
diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -40,8 +40,6 @@ unsigned long memory_end;
 
 EXPORT_SYMBOL(memory_start);
 EXPORT_SYMBOL(memory_end);
-
-char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* machine dependent timer functions */
 void (*mach_gettod)(int*, int*, int*, int*, int*, int*);
@@ -111,7 +109,20 @@ extern int _stext, _etext, _sdata, _edat
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
 
-void __init setup_arch(char **cmdline_p)
+void __weak __init platform_get_boot_command_line(void)
+{
+}
+
+void __init arch_get_boot_command_line(void)
+{
+#if defined(CONFIG_BOOTPARAM)
+	strlcpy(boot_command_line, CONFIG_BOOTPARAM_STRING, COMMAND_LINE_SIZE);
+#endif
+
+	platform_get_boot_command_line();
+}
+
+void __init setup_arch(void)
 {
 	int bootmap_size;
 
@@ -123,12 +134,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data = (unsigned long) &_edata;
 	init_mm.brk = (unsigned long) 0;
 
-	config_BSP(&command_line[0], sizeof(command_line));
-
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(&command_line[0], CONFIG_BOOTPARAM_STRING, sizeof(command_line));
-	command_line[sizeof(command_line) - 1] = 0;
-#endif
+	config_BSP();
 
 	printk(KERN_INFO "\x0F\r\n\nuClinux/" CPU "\n");
 
@@ -176,14 +182,9 @@ void __init setup_arch(char **cmdline_p)
 		(int) memory_start, (int) memory_end);
 #endif
 
-	/* Keep a copy of command line */
-	*cmdline_p = &command_line[0];
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = 0;
-
 #ifdef DEBUG
-	if (strlen(*cmdline_p))
-		printk(KERN_DEBUG "Command line: '%s'\n", *cmdline_p);
+	if (strlen(boot_command_line))
+		printk(KERN_DEBUG "Command line: '%s'\n", boot_command_line);
 #endif
 
 #if defined(CONFIG_FRAMEBUFFER_CONSOLE) && defined(CONFIG_DUMMY_CONSOLE)
diff --git a/arch/m68knommu/platform/5206/config.c b/arch/m68knommu/platform/5206/config.c
--- a/arch/m68knommu/platform/5206/config.c
+++ b/arch/m68knommu/platform/5206/config.c
@@ -109,7 +109,7 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 	mach_reset = coldfire_reset;
diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
--- a/arch/m68knommu/platform/5206e/config.c
+++ b/arch/m68knommu/platform/5206e/config.c
@@ -108,15 +108,17 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+#if defined(CONFIG_NETtel)
+void __init platform_get_boot_command_line(void)
+{
+	/* Copy command line from FLASH to local buffer... */
+	strlcpy(boot_command_line, (char *)0xf0004000, COMMAND_LINE_SIZE);
+}
+#endif /* CONFIG_NETtel */
+
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-
-#if defined(CONFIG_NETtel)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xf0004000, size);
-	commandp[size-1] = 0;
-#endif /* CONFIG_NETtel */
 
 	mach_reset = coldfire_reset;
 }
diff --git a/arch/m68knommu/platform/520x/config.c b/arch/m68knommu/platform/520x/config.c
--- a/arch/m68knommu/platform/520x/config.c
+++ b/arch/m68knommu/platform/520x/config.c
@@ -114,7 +114,7 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mach_reset = coldfire_reset;
 	m520x_uarts_init();
diff --git a/arch/m68knommu/platform/523x/config.c b/arch/m68knommu/platform/523x/config.c
--- a/arch/m68knommu/platform/523x/config.c
+++ b/arch/m68knommu/platform/523x/config.c
@@ -98,7 +98,7 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_disableall();
 	mach_reset = coldfire_reset;
diff --git a/arch/m68knommu/platform/5249/config.c b/arch/m68knommu/platform/5249/config.c
--- a/arch/m68knommu/platform/5249/config.c
+++ b/arch/m68knommu/platform/5249/config.c
@@ -105,7 +105,7 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 	mach_reset = coldfire_reset;
diff --git a/arch/m68knommu/platform/5272/config.c b/arch/m68knommu/platform/5272/config.c
--- a/arch/m68knommu/platform/5272/config.c
+++ b/arch/m68knommu/platform/5272/config.c
@@ -123,7 +123,18 @@ void mcf_settimericr(int timer, int leve
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init platform_get_boot_command_line(void)
+{
+#if defined(CONFIG_NETtel) || defined(CONFIG_SCALES)
+	/* Copy command line from FLASH to local buffer... */
+	strlcpy(boot_command_line, (char *)0xf0004000, COMMAND_LINE_SIZE);
+#elif defined(CONFIG_CANCam)
+	/* Copy command line from FLASH to local buffer... */
+	strlcpy(boot_command_line, (char *)0xf0010000, COMMAND_LINE_SIZE);
+#endif
+}
+
+void __init config_BSP(void)
 {
 #if defined (CONFIG_MOD5272)
 	volatile unsigned char	*pivrp;
@@ -134,16 +145,6 @@ void __init config_BSP(char *commandp, i
 #endif
 
 	mcf_disableall();
-
-#if defined(CONFIG_NETtel) || defined(CONFIG_SCALES)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xf0004000, size);
-	commandp[size-1] = 0;
-#elif defined(CONFIG_CANCam)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xf0010000, size);
-	commandp[size-1] = 0;
-#endif
 
 	mcf_timervector = 69;
 	mcf_profilevector = 70;
diff --git a/arch/m68knommu/platform/527x/config.c b/arch/m68knommu/platform/527x/config.c
--- a/arch/m68knommu/platform/527x/config.c
+++ b/arch/m68knommu/platform/527x/config.c
@@ -112,7 +112,7 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_disableall();
 	mach_reset = coldfire_reset;
diff --git a/arch/m68knommu/platform/528x/config.c b/arch/m68knommu/platform/528x/config.c
--- a/arch/m68knommu/platform/528x/config.c
+++ b/arch/m68knommu/platform/528x/config.c
@@ -369,7 +369,7 @@ void wildfiremod_halt(void)
 }
 #endif
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_disableall();
 
diff --git a/arch/m68knommu/platform/5307/config.c b/arch/m68knommu/platform/5307/config.c
--- a/arch/m68knommu/platform/5307/config.c
+++ b/arch/m68knommu/platform/5307/config.c
@@ -118,16 +118,21 @@ void mcf_settimericr(unsigned int timer,
 }
 
 /***************************************************************************/
+#if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
+    defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
+void __init platform_get_boot_command_line(void)
+{
+	/* Copy command line from FLASH to local buffer... */
+	strlcpy(boot_command_line, (char *) 0xf0004000, COMMAND_LINE_SIZE);
+}
+#endif
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
 #if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
     defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xf0004000, size);
-	commandp[size-1] = 0;
 	/* Different timer setup - to prevent device clash */
 	mcf_timervector = 30;
 	mcf_profilevector = 31;
diff --git a/arch/m68knommu/platform/532x/config.c b/arch/m68knommu/platform/532x/config.c
--- a/arch/m68knommu/platform/532x/config.c
+++ b/arch/m68knommu/platform/532x/config.c
@@ -115,21 +115,19 @@ void mcf_settimericr(unsigned int timer,
 }
 
 /***************************************************************************/
+#if !defined(CONFIG_BOOTPARAM)
+void __init platform_get_boot_command_line(void)
+{
+	/* Copy command line from FLASH to local buffer... */
+	memcpy(boot_command_line, (char *)0x4000, 4);
+	if (strncmp(boot_command_line, "kcl ", 4) == 0)
+		strlcpy(boot_command_line, (char *)0x4004, COMMAND_LINE_SIZE);
+}
+#endif
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-
-#if !defined(CONFIG_BOOTPARAM)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0x4000, 4);
-	if(strncmp(commandp, "kcl ", 4) == 0){
-		memcpy(commandp, (char *) 0x4004, size);
-		commandp[size-1] = 0;
-	} else {
-		memset(commandp, 0, size);
-	}
-#endif
 
 	mcf_timervector = 64+32;
 	mcf_profilevector = 64+33;
diff --git a/arch/m68knommu/platform/5407/config.c b/arch/m68knommu/platform/5407/config.c
--- a/arch/m68knommu/platform/5407/config.c
+++ b/arch/m68knommu/platform/5407/config.c
@@ -110,7 +110,7 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-void __init config_BSP(char *commandp, int size)
+void __init config_BSP(void)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
diff --git a/arch/m68knommu/platform/68328/config.c b/arch/m68knommu/platform/68328/config.c
--- a/arch/m68knommu/platform/68328/config.c
+++ b/arch/m68knommu/platform/68328/config.c
@@ -39,7 +39,7 @@ void m68328_reset (void)
 
 /***************************************************************************/
 
-void config_BSP(char *command, int len)
+void config_BSP(void)
 {
   printk(KERN_INFO "\n68328 support D. Jeff Dionne <jeff@uclinux.org>\n");
   printk(KERN_INFO "68328 support Kenneth Albanowski <kjahds@kjshds.com>\n");
diff --git a/arch/m68knommu/platform/68328/head-pilot.S b/arch/m68knommu/platform/68328/head-
pilot.S
--- a/arch/m68knommu/platform/68328/head-pilot.S
+++ b/arch/m68knommu/platform/68328/head-pilot.S
@@ -163,7 +163,7 @@ L1:
 
 	/* Copy command line from end of bss to command line */
 	moveal	#_ebss, %a0
-	moveal	#command_line, %a1
+	moveal	#boot_command_line, %a1
 	lea	%a1@(512), %a2
 
 	DBG_PUTC('G')
diff --git a/arch/m68knommu/platform/68360/config.c b/arch/m68knommu/platform/68360/config.c
--- a/arch/m68knommu/platform/68360/config.c
+++ b/arch/m68knommu/platform/68360/config.c
@@ -142,8 +142,7 @@ _bsc1(char *, getbenv, char *, a)
 _bsc1(char *, getbenv, char *, a)
 #endif
 
-
-void config_BSP(char *command, int len)
+void config_BSP(void)
 {
   unsigned char *p;
 
@@ -172,11 +171,14 @@ void config_BSP(char *command, int len)
   printk(KERN_INFO "uCquicc hwaddr %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
          p[0], p[1], p[2], p[3], p[4], p[5]);
 
+#if 0 /* Did this ever work?  Was strcpy supposed to be other way? */
   p = getbenv("APPEND");
   if (p)
     strcpy(p,command);
   else
     command[0] = 0;
+#endif
+
 #else
   scc1_hwaddr = "\00\01\02\03\04\05";
 #endif
diff --git a/arch/m68knommu/platform/68EZ328/config.c 
b/arch/m68knommu/platform/68EZ328/config.c
--- a/arch/m68knommu/platform/68EZ328/config.c
+++ b/arch/m68knommu/platform/68EZ328/config.c
@@ -52,7 +52,7 @@ _bsc1(char *, getbenv, char *, a)
 _bsc1(char *, getbenv, char *, a)
 #endif
 
-void config_BSP(char *command, int len)
+void config_BSP(void)
 {
   unsigned char *p;
 
@@ -64,9 +64,11 @@ void config_BSP(char *command, int len)
   printk(KERN_INFO "uCsimm hwaddr %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
          p[0], p[1], p[2], p[3], p[4], p[5]);
 
+#if 0 /* Did this ever work? strcpy wrong way? */
   p = getbenv("APPEND");
   if (p) strcpy(p,command);
   else command[0] = 0;
+#endif
 #endif
  
   mach_gettod = m68328_timer_gettod;
diff --git a/arch/m68knommu/platform/68VZ328/config.c 
b/arch/m68knommu/platform/68VZ328/config.c
--- a/arch/m68knommu/platform/68VZ328/config.c
+++ b/arch/m68knommu/platform/68VZ328/config.c
@@ -59,7 +59,7 @@ static void m68vz328_reset(void)
 	);
 }
 
-static void init_hardware(char *command, int size)
+static void init_hardware(void)
 {
 #ifdef CONFIG_DIRECT_IO_ACCESS
 	SCR = 0x10;					/* allow user access to internal registers */
@@ -150,7 +150,7 @@ _bsc1(unsigned char *, gethwaddr, int, a
 _bsc1(unsigned char *, gethwaddr, int, a)
 _bsc1(char *, getbenv, char *, a)
 
-static void init_hardware(char *command, int size)
+static void init_hardware(void)
 {
 	char *p;
 
@@ -158,11 +158,13 @@ static void init_hardware(char *command,
 	p = cs8900a_hwaddr = gethwaddr(0);
 	printk(KERN_INFO "uCdimm hwaddr %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
 		p[0], p[1], p[2], p[3], p[4], p[5]);
+#if 0 /* Did this ever work?  strcpy wrong way? */
 	p = getbenv("APPEND");
 	if (p)
 		strcpy(p, command);
 	else
 		command[0] = 0;
+#endif
 }
 
 /***************************************************************************/
@@ -172,7 +174,7 @@ static void m68vz328_reset(void)
 {
 }
 
-static void init_hardware(char *command, int size)
+static void init_hardware(void)
 {
 }
 
@@ -180,11 +182,11 @@ static void init_hardware(char *command,
 #endif
 /***************************************************************************/
 
-void config_BSP(char *command, int size)
+void config_BSP(void)
 {
 	printk(KERN_INFO "68VZ328 DragonBallVZ support (c) 2001 Lineo, Inc.\n");
 
-	init_hardware(command, size);
+	init_hardware();
 
 	mach_gettod = m68328_timer_gettod;
 	mach_reset = m68vz328_reset;
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -465,7 +465,14 @@ static int __init early_parse_mem(char *
 }
 early_param("mem", early_parse_mem);
 
-static void __init arch_mem_init(char **cmdline_p)
+void arch_get_boot_command_line(void)
+{
+	/* FIXME: Just replace command_line with boot_command_line? */
+	strlcpy(command_line, arcs_cmdline, sizeof(command_line));
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+static void __init arch_mem_init(void)
 {
 	extern void plat_mem_setup(void);
 
@@ -474,11 +481,6 @@ static void __init arch_mem_init(char **
 
 	pr_info("Determined physical RAM map:\n");
 	print_memory_map();
-
-	strlcpy(command_line, arcs_cmdline, sizeof(command_line));
-	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-
-	*cmdline_p = command_line;
 
 	parse_early_param();
 
@@ -545,7 +547,7 @@ static void __init resource_init(void)
 	}
 }
 
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch()
 {
 	cpu_probe();
 	prom_init();
@@ -564,7 +566,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-	arch_mem_init(cmdline_p);
+	arch_mem_init();
 
 	resource_init();
 	plat_smp_setup();
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -73,15 +73,17 @@ static const char *const mn10300_cputype
 	"unknown"
 };
 
+void __init arch_get_boot_command_line(void)
+{
+	strcpy(boot_command_line, redboot_command_line);
+}
+
 /*
- *
+ * FIXME: use core_param
  */
-static void __init parse_mem_cmdline(char **cmdline_p)
+static void __init parse_mem_cmdline(void)
 {
 	char *from, *to, c;
-
-	/* save unparsed command line copy for /proc/cmdline */
-	strcpy(boot_command_line, redboot_command_line);
 
 	/* see if there's an explicit memory size option */
 	from = redboot_command_line;
@@ -103,7 +105,6 @@ static void __init parse_mem_cmdline(cha
 	}
 
 	*to = '\0';
-	*cmdline_p = redboot_command_line;
 
 	if (memory_size == 0)
 		panic("Memory size not known\n");
@@ -117,14 +118,14 @@ static void __init parse_mem_cmdline(cha
 /*
  * architecture specific setup
  */
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
 	unsigned long bootmap_size;
 	unsigned long kstart_pfn, start_pfn, free_pfn, end_pfn;
 
 	cpu_init();
 	unit_setup();
-	parse_mem_cmdline(cmdline_p);
+	parse_mem_cmdline();
 
 	init_mm.start_code = (unsigned long)&_text;
 	init_mm.end_code = (unsigned long) &_etext;
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -63,30 +63,17 @@ unsigned long parisc_vmerge_boundary = 0
 unsigned long parisc_vmerge_boundary = 0;
 unsigned long parisc_vmerge_max_size = 0;
 
-void __init setup_cmdline(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
 {
 	extern unsigned int boot_args[];
 
 	/* Collect stuff passed in from the boot loader */
 
 	/* boot_args[0] is free-mem start, boot_args[1] is ptr to command line */
-	if (boot_args[0] < 64) {
-		/* called from hpux boot loader */
-		boot_command_line[0] = '\0';
-	} else {
+	if (boot_args[0] >= 64) {
+		/* not called from hpux boot loader */
 		strcpy(boot_command_line, (char *)__va(boot_args[1]));
-
-#ifdef CONFIG_BLK_DEV_INITRD
-		if (boot_args[2] != 0) /* did palo pass us a ramdisk? */
-		{
-		    initrd_start = (unsigned long)__va(boot_args[2]);
-		    initrd_end = (unsigned long)__va(boot_args[3]);
-		}
-#endif
 	}
-
-	strcpy(command_line, boot_command_line);
-	*cmdline_p = command_line;
 }
 
 #ifdef CONFIG_PA11
@@ -121,6 +108,7 @@ extern void collect_boot_cpu_data(void);
 
 void __init setup_arch(char **cmdline_p)
 {
+	extern unsigned int boot_args[];
 #ifdef CONFIG_64BIT
 	extern int parisc_narrow_firmware;
 #endif
@@ -142,7 +130,15 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 	setup_pdc();
-	setup_cmdline(cmdline_p);
+	strcpy(command_line, boot_command_line);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	/* did palo pass us a ramdisk? */
+	if (boot_args[0] >= 64 && boot_args[2] != 0) {
+		initrd_start = (unsigned long)__va(boot_args[2]);
+		initrd_end = (unsigned long)__va(boot_args[3]);
+	}
+#endif
 	collect_boot_cpu_data();
 	do_memory_inventory();  /* probe for physical memory */
 	parisc_cache_init();
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -264,11 +264,15 @@ static void __init exc_lvl_early_init(vo
 #define exc_lvl_early_init()
 #endif
 
+void arch_get_boot_command_line(void)
+{
+	/* FIXME: Get rid of cmd_line in favor of boot_command_line? */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+}
+
 /* Warning, IO base is not yet inited */
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
-	*cmdline_p = cmd_line;
-
 	/* so udelay does something sensible, assume <= 1000 bogomips */
 	loops_per_jiffy = 500000000 / HZ;
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -502,6 +502,12 @@ static void __init emergency_stack_init(
 	}
 }
 
+void arch_get_boot_command_line(void)
+{
+	/* FIXME: Get rid of cmd_line in favor of boot_command_line? */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+}
+
 /*
  * Called into from start_kernel, after lock_kernel has been called.
  * Initializes bootmem, which is unsed to manage page allocation until
@@ -510,8 +516,6 @@ void __init setup_arch(char **cmdline_p)
 void __init setup_arch(char **cmdline_p)
 {
 	ppc64_boot_msg(0x12, "Setup Arch");
-
-	*cmdline_p = cmd_line;
 
 	/*
 	 * Set cache line size based on type of cpu as a default.
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -750,7 +750,7 @@ static void __init setup_hwcaps(void)
  */
 
 void __init
-setup_arch(char **cmdline_p)
+setup_arch(void)
 {
         /*
          * print what head.S has found out about the machine
@@ -772,10 +772,6 @@ setup_arch(char **cmdline_p)
 	} else
 		printk("We are running native (64 bit mode)\n");
 #endif /* CONFIG_64BIT */
-
-	/* Have one command line that is parsed and saved in /proc/cmdline */
-	/* boot_command_line has been already set up in early.c */
-	*cmdline_p = boot_command_line;
 
         ROOT_DEV = Root_RAM0;
 
diff --git a/arch/sh/boards/board-magicpanelr2.c b/arch/sh/boards/board-magicpanelr2.c
--- a/arch/sh/boards/board-magicpanelr2.c
+++ b/arch/sh/boards/board-magicpanelr2.c
@@ -202,7 +202,7 @@ static void __init setup_port_multiplexi
 	ctrl_outw(0x0142, PORT_PVCR);	/* 00 00 00 01 01 00 00 10 */
 }
 
-static void __init mpr2_setup(char **cmdline_p)
+static void __init mpr2_setup(void)
 {
 	__set_io_port_base(0xa0000000);
 
diff --git a/arch/sh/boards/board-sh7785lcr.c b/arch/sh/boards/board-sh7785lcr.c
--- a/arch/sh/boards/board-sh7785lcr.c
+++ b/arch/sh/boards/board-sh7785lcr.c
@@ -278,7 +278,7 @@ static void sh7785lcr_power_off(void)
 }
 
 /* Initialize the board */
-static void __init sh7785lcr_setup(char **cmdline_p)
+static void __init sh7785lcr_setup(void)
 {
 	void __iomem *sm501_reg;
 
diff --git a/arch/sh/boards/mach-dreamcast/setup.c b/arch/sh/boards/mach-dreamcast/setup.c
--- a/arch/sh/boards/mach-dreamcast/setup.c
+++ b/arch/sh/boards/mach-dreamcast/setup.c
@@ -33,7 +33,7 @@ extern int gapspci_init(void);
 extern int gapspci_init(void);
 extern int systemasic_irq_demux(int);
 
-static void __init dreamcast_setup(char **cmdline_p)
+static void __init dreamcast_setup(void)
 {
 	int i;
 
diff --git a/arch/sh/boards/mach-highlander/setup.c b/arch/sh/boards/mach-highlander/setup.c
--- a/arch/sh/boards/mach-highlander/setup.c
+++ b/arch/sh/boards/mach-highlander/setup.c
@@ -279,7 +279,7 @@ static void r7780rp_power_off(void)
 /*
  * Initialize the board
  */
-static void __init highlander_setup(char **cmdline_p)
+static void __init highlander_setup(void)
 {
 	u16 ver = ctrl_inw(PA_VERREG);
 	int i;
diff --git a/arch/sh/boards/mach-hp6xx/setup.c b/arch/sh/boards/mach-hp6xx/setup.c
--- a/arch/sh/boards/mach-hp6xx/setup.c
+++ b/arch/sh/boards/mach-hp6xx/setup.c
@@ -67,7 +67,7 @@ static int __init hp6xx_devices_setup(vo
 	return platform_add_devices(hp6xx_devices, ARRAY_SIZE(hp6xx_devices));
 }
 
-static void __init hp6xx_setup(char **cmdline_p)
+static void __init hp6xx_setup(void)
 {
 	u8 v8;
 	u16 v;
diff --git a/arch/sh/boards/mach-landisk/setup.c b/arch/sh/boards/mach-landisk/setup.c
--- a/arch/sh/boards/mach-landisk/setup.c
+++ b/arch/sh/boards/mach-landisk/setup.c
@@ -85,7 +85,7 @@ static int __init landisk_devices_setup(
 
 __initcall(landisk_devices_setup);
 
-static void __init landisk_setup(char **cmdline_p)
+static void __init landisk_setup(void)
 {
         /* LED ON */
 	ctrl_outb(ctrl_inb(PA_LED) | 0x03, PA_LED);
diff --git a/arch/sh/boards/mach-microdev/setup.c b/arch/sh/boards/mach-microdev/setup.c
--- a/arch/sh/boards/mach-microdev/setup.c
+++ b/arch/sh/boards/mach-microdev/setup.c
@@ -355,7 +355,7 @@ static int __init smsc_superio_setup(voi
 	return 0;
 }
 
-static void __init microdev_setup(char **cmdline_p)
+static void __init microdev_setup(void)
 {
 	int * const fpgaRevisionRegister = (int*)(MICRODEV_FPGA_GP_BASE + 0x8ul);
 	const int fpgaRevision = *fpgaRevisionRegister;
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -590,7 +590,7 @@ static int __init migor_devices_setup(vo
 }
 __initcall(migor_devices_setup);
 
-static void __init migor_setup(char **cmdline_p)
+static void __init migor_setup(void)
 {
 }
 
diff --git a/arch/sh/boards/mach-r2d/setup.c b/arch/sh/boards/mach-r2d/setup.c
--- a/arch/sh/boards/mach-r2d/setup.c
+++ b/arch/sh/boards/mach-r2d/setup.c
@@ -218,7 +218,7 @@ static void rts7751r2d_power_off(void)
 /*
  * Initialize the board
  */
-static void __init rts7751r2d_setup(char **cmdline_p)
+static void __init rts7751r2d_setup(void)
 {
 	void __iomem *sm501_reg;
 	u16 ver = ctrl_inw(PA_VERREG);
diff --git a/arch/sh/boards/mach-sdk7780/setup.c b/arch/sh/boards/mach-sdk7780/setup.c
--- a/arch/sh/boards/mach-sdk7780/setup.c
+++ b/arch/sh/boards/mach-sdk7780/setup.c
@@ -81,7 +81,7 @@ static int __init sdk7780_devices_setup(
 }
 device_initcall(sdk7780_devices_setup);
 
-static void __init sdk7780_setup(char **cmdline_p)
+static void __init sdk7780_setup(void)
 {
 	u16 ver = ctrl_inw(FPGA_FPVERR);
 	u16 dateStamp = ctrl_inw(FPGA_FPDATER);
diff --git a/arch/sh/boards/mach-se/7343/setup.c b/arch/sh/boards/mach-se/7343/setup.c
--- a/arch/sh/boards/mach-se/7343/setup.c
+++ b/arch/sh/boards/mach-se/7343/setup.c
@@ -110,7 +110,7 @@ device_initcall(sh7343se_devices_setup);
 /*
  * Initialize the board
  */
-static void __init sh7343se_setup(char **cmdline_p)
+static void __init sh7343se_setup(void)
 {
 	ctrl_outw(0xf900, FPGA_OUT);	/* FPGA */
 
diff --git a/arch/sh/boards/mach-se/770x/setup.c b/arch/sh/boards/mach-se/770x/setup.c
--- a/arch/sh/boards/mach-se/770x/setup.c
+++ b/arch/sh/boards/mach-se/770x/setup.c
@@ -24,7 +24,7 @@ static void __init smsc_config(int index
 }
 
 /* XXX: Another candidate for a more generic cchip machine vector */
-static void __init smsc_setup(char **cmdline_p)
+static void __init smsc_setup(void)
 {
 	outb_p(CONFIG_ENTER, CONFIG_PORT);
 	outb_p(CONFIG_ENTER, CONFIG_PORT);
diff --git a/arch/sh/boards/mach-se/7721/setup.c b/arch/sh/boards/mach-se/7721/setup.c
--- a/arch/sh/boards/mach-se/7721/setup.c
+++ b/arch/sh/boards/mach-se/7721/setup.c
@@ -79,7 +79,7 @@ static int __init se7721_devices_setup(v
 }
 device_initcall(se7721_devices_setup);
 
-static void __init se7721_setup(char **cmdline_p)
+static void __init se7721_setup(void)
 {
 	/* for USB */
 	ctrl_outw(0x0000, 0xA405010C);	/* PGCR */
diff --git a/arch/sh/boards/mach-se/7722/setup.c b/arch/sh/boards/mach-se/7722/setup.c
--- a/arch/sh/boards/mach-se/7722/setup.c
+++ b/arch/sh/boards/mach-se/7722/setup.c
@@ -153,7 +153,7 @@ static int __init se7722_devices_setup(v
 }
 device_initcall(se7722_devices_setup);
 
-static void __init se7722_setup(char **cmdline_p)
+static void __init se7722_setup(void)
 {
 	ctrl_outw(0x010D, FPGA_OUT);    /* FPGA */
 
diff --git a/arch/sh/boards/mach-se/7780/setup.c b/arch/sh/boards/mach-se/7780/setup.c
--- a/arch/sh/boards/mach-se/7780/setup.c
+++ b/arch/sh/boards/mach-se/7780/setup.c
@@ -81,7 +81,7 @@ device_initcall(se7780_devices_setup);
 #define GPIO_PMSELR      0xFFEA0080
 #define GPIO_PECR        0xFFEA0008
 
-static void __init se7780_setup(char **cmdline_p)
+static void __init se7780_setup(void)
 {
 	/* "SH-Linux" on LED Display */
 	ctrl_outw( 'S' , PA_LED_DISP + (DISP_SEL0_ADDR << 1) );
diff --git a/arch/sh/boards/mach-sh03/setup.c b/arch/sh/boards/mach-sh03/setup.c
--- a/arch/sh/boards/mach-sh03/setup.c
+++ b/arch/sh/boards/mach-sh03/setup.c
@@ -36,7 +36,7 @@ static void __iomem *sh03_ioport_map(uns
 /* arch/sh/boards/sh03/rtc.c */
 void sh03_time_init(void);
 
-static void __init sh03_setup(char **cmdline_p)
+static void __init sh03_setup(void)
 {
 	board_time_init = sh03_time_init;
 }
diff --git a/arch/sh/boards/mach-sh7763rdp/setup.c b/arch/sh/boards/mach-sh7763rdp/setup.c
--- a/arch/sh/boards/mach-sh7763rdp/setup.c
+++ b/arch/sh/boards/mach-sh7763rdp/setup.c
@@ -151,7 +151,7 @@ static int __init sh7763rdp_devices_setu
 }
 device_initcall(sh7763rdp_devices_setup);
 
-static void __init sh7763rdp_setup(char **cmdline_p)
+static void __init sh7763rdp_setup(void)
 {
 	/* Board version check */
 	if (ctrl_inw(CPLD_BOARD_ID_ERV_REG) == 0xECB1)
diff --git a/arch/sh/include/asm/machvec.h b/arch/sh/include/asm/machvec.h
--- a/arch/sh/include/asm/machvec.h
+++ b/arch/sh/include/asm/machvec.h
@@ -17,7 +17,7 @@ struct device;
 struct device;
 
 struct sh_machine_vector {
-	void (*mv_setup)(char **cmdline_p);
+	void (*mv_setup)(void);
 	const char *mv_name;
 	int mv_nr_irqs;
 
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -329,7 +329,19 @@ early_param("elfcorehdr", parse_elfcoreh
 early_param("elfcorehdr", parse_elfcorehdr);
 #endif
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+#ifdef CONFIG_CMDLINE_BOOL
+	strlcpy(command_line, CONFIG_CMDLINE, sizeof(command_line));
+#else
+	strlcpy(command_line, COMMAND_LINE, sizeof(command_line));
+#endif
+
+	/* FIXME: get rid of command_line, just use boot_command_line? */
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	enable_mmu();
 
@@ -370,16 +382,6 @@ void __init setup_arch(char **cmdline_p)
 	if (!memory_end)
 		memory_end = memory_start + __MEMORY_SIZE;
 
-#ifdef CONFIG_CMDLINE_BOOL
-	strlcpy(command_line, CONFIG_CMDLINE, sizeof(command_line));
-#else
-	strlcpy(command_line, COMMAND_LINE, sizeof(command_line));
-#endif
-
-	/* Save unparsed command line copy for /proc/cmdline */
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
 	parse_early_param();
 
 	sh_mv_setup();
@@ -407,7 +409,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Perform the machine specific initialisation */
 	if (likely(sh_mv.mv_setup))
-		sh_mv.mv_setup(cmdline_p);
+		sh_mv.mv_setup();
 
 	paging_init();
 
diff --git a/arch/sparc/kernel/setup.c b/arch/sparc/kernel/setup.c
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -203,16 +203,19 @@ struct tt_entry *sparc_ttable;
 
 struct pt_regs fake_swapper_regs;
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	strcpy(boot_command_line, prom_getbootargs());
+}
+
+void __init setup_arch(void)
 {
 	int i;
 	unsigned long highest_paddr;
 
 	sparc_ttable = (struct tt_entry *) &start;
 
-	/* Initialize PROM console and command line. */
-	*cmdline_p = prom_getbootargs();
-	strcpy(boot_command_line, *cmdline_p);
+	/* Initialize PROM console. */
 	parse_early_param();
 
 	/* Set sparc_cpu_model */
@@ -262,7 +265,7 @@ void __init setup_arch(char **cmdline_p)
 #elif defined(CONFIG_PROM_CONSOLE)
 	conswitchp = &prom_con;
 #endif
-	boot_flags_init(*cmdline_p);
+	boot_flags_init(boot_command_line);
 
 	idprom_init();
 	if (ARCH_SUN4C)
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -276,14 +276,17 @@ void __init boot_cpu_id_too_large(int cp
 }
 #endif
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
 {
-	/* Initialize PROM console and command line. */
-	*cmdline_p = prom_getbootargs();
-	strcpy(boot_command_line, *cmdline_p);
+	strcpy(boot_command_line, prom_getbootargs());
+}
+
+void __init setup_arch(void)
+{
+	/* Initialize PROM console. */
 	parse_early_param();
 
-	boot_flags_init(*cmdline_p);
+	boot_flags_init(boot_command_line);
 	register_console(&prom_early_console);
 
 	if (tlb_type == hypervisor)
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -371,11 +371,15 @@ int __init linux_main(int argc, char **a
 	return start_uml();
 }
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	/* FIXME: do we need command_line at all? */
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	paging_init();
-	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
 	setup_hostinfo(host_info, sizeof host_info);
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -782,6 +782,25 @@ static struct dmi_system_id __initdata b
 	{}
 };
 
+void __init arch_get_boot_command_line(void)
+{
+#ifdef CONFIG_CMDLINE_BOOL
+#ifdef CONFIG_CMDLINE_OVERRIDE
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	if (builtin_cmdline[0]) {
+		/* append boot loader cmdline to builtin */
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	}
+#endif
+#endif
+
+	/* FIXME: Get rid of command_line? */
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -794,8 +813,7 @@ static struct dmi_system_id __initdata b
  *
  * Note: On x86_64, fixmaps are ready for use even before this is called.
  */
-
-void __init setup_arch(char **cmdline_p)
+void __init setup_arch(void)
 {
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -868,22 +886,6 @@ void __init setup_arch(char **cmdline_p)
 	data_resource.end = virt_to_phys(_edata)-1;
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
-
-#ifdef CONFIG_CMDLINE_BOOL
-#ifdef CONFIG_CMDLINE_OVERRIDE
-	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-#else
-	if (builtin_cmdline[0]) {
-		/* append boot loader cmdline to builtin */
-		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
-		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-	}
-#endif
-#endif
-
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
 
 	parse_early_param();
 
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -198,10 +198,6 @@ void __init init_arch(bp_tag_t *bp_start
 
 	sysmem.nr_banks = 0;
 
-#ifdef CONFIG_CMDLINE_BOOL
-	strcpy(command_line, default_command_line);
-#endif
-
 	/* Parse boot parameters */
 
         if (bp_start)
@@ -240,14 +236,19 @@ extern char _DoubleExceptionVector_liter
 extern char _DoubleExceptionVector_literal_start;
 extern char _DoubleExceptionVector_text_end;
 
-void __init setup_arch(char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+#ifdef CONFIG_CMDLINE_BOOL
+	strcpy(command_line, default_command_line);
+#endif
+	/* FIXME: Can we skip command_line? */
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+}
+
+void __init setup_arch(void)
 {
 	extern int mem_reserve(unsigned long, unsigned long, int);
 	extern void bootmem_init(void);
-
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
-	*cmdline_p = command_line;
 
 	/* Reserve some memory regions */
 
diff --git a/include/linux/init.h b/include/linux/init.h
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -149,7 +149,8 @@ extern unsigned int reset_devices;
 extern unsigned int reset_devices;
 
 /* used by init/main.c */
-void setup_arch(char **);
+void setup_arch(void);
+void arch_get_cmdline(char *cmdline);
 void prepare_namespace(void);
 
 extern void (*late_time_init)(void);
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -458,12 +458,12 @@ static void __init smp_init(void)
  * parsing is performed in place, and we should allow a component to
  * store reference of name/value for future reference.
  */
-static void __init setup_command_line(char *command_line)
+static void __init setup_command_line(void)
 {
 	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (command_line)+1);
+	static_command_line = alloc_bootmem(strlen (boot_command_line)+1);
 	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	strcpy (static_command_line, boot_command_line);
 }
 
 /*
@@ -554,9 +554,15 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+/* If the arch already sets boot_command_line, we need do nothing. */
+void __init __weak arch_get_boot_command_line(void)
+{
+}
+
+/* Ideally, this would take a 'const char *cmdline' param. */
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	arch_get_boot_command_line();
 
 	smp_setup_processor_id();
 
@@ -583,10 +589,10 @@ asmlinkage void __init start_kernel(void
 	page_address_init();
 	printk(KERN_NOTICE);
 	printk(linux_banner);
-	setup_arch(&command_line);
+	setup_arch();
 	mm_init_owner(&init_mm, &init_task);
-	setup_command_line(command_line);
-	parse_args("Core params", command_line, __start___core_param,
+	setup_command_line();
+	parse_args("Core params", boot_command_line, __start___core_param,
 		   __stop___core_param - __start___core_param,
 		   unknown_core_ok, true);
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1273,6 +1273,7 @@ static int __init parse_crashkernel_simp
 /*
  * That function is the entry point for command line parsing and should be
  * called from the arch-specific code.
+ * FIXME: Use core_param?
  */
 int __init parse_crashkernel(char 		 *cmdline,
 			     unsigned long long system_ram,



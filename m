Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXGGQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXGGQ3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXGGQ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:29:06 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:55648 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXGGQ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:29:05 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Date: Sat, 07 Jul 2007 22:20:54 +0530
Message-Id: <20070707165054.1465.81110.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -rc7][resend] sh: Silence bogus section mismatch warnings
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sh_machine_vector structures throughout arch/sh/boards/ are marked
__initmv so that they go to the .machvec.init section, when SH_GENERIC ||
SH_UNKNOWN. But when !SH_GENERIC && !SH_UNKNOWN, __initmv is not defined,
so all the machine vector structures go to the .data section. But, all
the .mv_setup members of various sh_machine_vector structures throughout
the arch/sh/boards/ directory are set to point to functions that are
marked as __init unconditionally.

This leads to:

MODPOST vmlinux
WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section mismatch:
reference to .init.text: (between 'mv_dreamcast' and 'systemasic_int')

These are bogus warnings, sh_machine_vector structures are used only at
init-time. So mark .mv_setup functions as __initmv too, to get rid of them.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

First sent in http://lkml.org/lkml/2007/6/23/116 and then resent in
http://lkml.org/lkml/2007/6/28/120. From http://lkml.org/lkml/2007/6/30/77
I presume this can also be marked:

Tested-by: Adrian McMenamin <adrian@newgolddream.dyndns.info>

 arch/sh/boards/dreamcast/setup.c           |    2 +-
 arch/sh/boards/hp6xx/setup.c               |    2 +-
 arch/sh/boards/landisk/setup.c             |    2 +-
 arch/sh/boards/mpc1211/setup.c             |    2 +-
 arch/sh/boards/renesas/hs7751rvoip/setup.c |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c     |    2 +-
 arch/sh/boards/renesas/rts7751r2d/setup.c  |    2 +-
 arch/sh/boards/se/7343/setup.c             |    2 +-
 arch/sh/boards/se/770x/setup.c             |    4 ++--
 arch/sh/boards/se/7722/setup.c             |    2 +-
 arch/sh/boards/se/7780/setup.c             |    2 +-
 arch/sh/boards/sh03/setup.c                |    2 +-
 arch/sh/boards/snapgear/setup.c            |    2 +-
 arch/sh/boards/superh/microdev/setup.c     |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

---

diff -ruNp c/arch/sh/boards/dreamcast/setup.c d/arch/sh/boards/dreamcast/setup.c
--- c/arch/sh/boards/dreamcast/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/dreamcast/setup.c	2007-06-23 18:35:28.000000000 +0530
@@ -36,7 +36,7 @@ extern int systemasic_irq_demux(int);
 void *dreamcast_consistent_alloc(struct device *, size_t, dma_addr_t *, gfp_t);
 int dreamcast_consistent_free(struct device *, size_t, void *, dma_addr_t);
 
-static void __init dreamcast_setup(char **cmdline_p)
+static void __initmv dreamcast_setup(char **cmdline_p)
 {
 	int i;
 
diff -ruNp c/arch/sh/boards/hp6xx/setup.c d/arch/sh/boards/hp6xx/setup.c
--- c/arch/sh/boards/hp6xx/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/hp6xx/setup.c	2007-06-23 18:36:13.000000000 +0530
@@ -55,7 +55,7 @@ static int __init hp6xx_devices_setup(vo
 	return platform_add_devices(hp6xx_devices, ARRAY_SIZE(hp6xx_devices));
 }
 
-static void __init hp6xx_setup(char **cmdline_p)
+static void __initmv hp6xx_setup(char **cmdline_p)
 {
 	u8 v8;
 	u16 v;
diff -ruNp c/arch/sh/boards/landisk/setup.c d/arch/sh/boards/landisk/setup.c
--- c/arch/sh/boards/landisk/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/landisk/setup.c	2007-06-23 18:36:57.000000000 +0530
@@ -85,7 +85,7 @@ static int __init landisk_devices_setup(
 
 __initcall(landisk_devices_setup);
 
-static void __init landisk_setup(char **cmdline_p)
+static void __initmv landisk_setup(char **cmdline_p)
 {
         /* LED ON */
 	ctrl_outb(ctrl_inb(PA_LED) | 0x03, PA_LED);
diff -ruNp c/arch/sh/boards/mpc1211/setup.c d/arch/sh/boards/mpc1211/setup.c
--- c/arch/sh/boards/mpc1211/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/mpc1211/setup.c	2007-06-23 18:37:26.000000000 +0530
@@ -311,7 +311,7 @@ __initcall(mpc1211_devices_setup);
 /* arch/sh/boards/mpc1211/rtc.c */
 void mpc1211_time_init(void);
 
-static void __init mpc1211_setup(char **cmdline_p)
+static void __initmv mpc1211_setup(char **cmdline_p)
 {
 	unsigned char spd_buf[128];
 
diff -ruNp c/arch/sh/boards/renesas/hs7751rvoip/setup.c d/arch/sh/boards/renesas/hs7751rvoip/setup.c
--- c/arch/sh/boards/renesas/hs7751rvoip/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/renesas/hs7751rvoip/setup.c	2007-06-23 18:37:48.000000000 +0530
@@ -79,7 +79,7 @@ static int __init hs7751rvoip_cf_init(vo
 /*
  * Initialize the board
  */
-static void __init hs7751rvoip_setup(char **cmdline_p)
+static void __initmv hs7751rvoip_setup(char **cmdline_p)
 {
 	device_initcall(hs7751rvoip_cf_init);
 
diff -ruNp c/arch/sh/boards/renesas/r7780rp/setup.c d/arch/sh/boards/renesas/r7780rp/setup.c
--- c/arch/sh/boards/renesas/r7780rp/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/renesas/r7780rp/setup.c	2007-06-23 18:38:12.000000000 +0530
@@ -128,7 +128,7 @@ static void r7780rp_power_off(void)
 /*
  * Initialize the board
  */
-static void __init highlander_setup(char **cmdline_p)
+static void __initmv highlander_setup(char **cmdline_p)
 {
 	u16 ver = ctrl_inw(PA_VERREG);
 	int i;
diff -ruNp c/arch/sh/boards/renesas/rts7751r2d/setup.c d/arch/sh/boards/renesas/rts7751r2d/setup.c
--- c/arch/sh/boards/renesas/rts7751r2d/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/renesas/rts7751r2d/setup.c	2007-06-23 18:38:34.000000000 +0530
@@ -158,7 +158,7 @@ static void rts7751r2d_power_off(void)
 /*
  * Initialize the board
  */
-static void __init rts7751r2d_setup(char **cmdline_p)
+static void __initmv rts7751r2d_setup(char **cmdline_p)
 {
 	u16 ver = ctrl_inw(PA_VERREG);
 
diff -ruNp c/arch/sh/boards/se/7343/setup.c d/arch/sh/boards/se/7343/setup.c
--- c/arch/sh/boards/se/7343/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/se/7343/setup.c	2007-06-23 18:39:02.000000000 +0530
@@ -56,7 +56,7 @@ static int __init sh7343se_devices_setup
 				    ARRAY_SIZE(sh7343se_platform_devices));
 }
 
-static void __init sh7343se_setup(char **cmdline_p)
+static void __initmv sh7343se_setup(char **cmdline_p)
 {
 	device_initcall(sh7343se_devices_setup);
 }
diff -ruNp c/arch/sh/boards/se/770x/setup.c d/arch/sh/boards/se/770x/setup.c
--- c/arch/sh/boards/se/770x/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/se/770x/setup.c	2007-06-23 18:39:46.000000000 +0530
@@ -18,14 +18,14 @@ void init_se_IRQ(void);
 /*
  * Configure the Super I/O chip
  */
-static void __init smsc_config(int index, int data)
+static void __initmv smsc_config(int index, int data)
 {
 	outb_p(index, INDEX_PORT);
 	outb_p(data, DATA_PORT);
 }
 
 /* XXX: Another candidate for a more generic cchip machine vector */
-static void __init smsc_setup(char **cmdline_p)
+static void __initmv smsc_setup(char **cmdline_p)
 {
 	outb_p(CONFIG_ENTER, CONFIG_PORT);
 	outb_p(CONFIG_ENTER, CONFIG_PORT);
diff -ruNp c/arch/sh/boards/se/7722/setup.c d/arch/sh/boards/se/7722/setup.c
--- c/arch/sh/boards/se/7722/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/se/7722/setup.c	2007-06-23 18:40:15.000000000 +0530
@@ -101,7 +101,7 @@ static int __init se7722_devices_setup(v
 }
 device_initcall(se7722_devices_setup);
 
-static void __init se7722_setup(char **cmdline_p)
+static void __initmv se7722_setup(char **cmdline_p)
 {
 	ctrl_outw(0x010D, FPGA_OUT);    /* FPGA */
 
diff -ruNp c/arch/sh/boards/se/7780/setup.c d/arch/sh/boards/se/7780/setup.c
--- c/arch/sh/boards/se/7780/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/se/7780/setup.c	2007-06-23 18:40:36.000000000 +0530
@@ -78,7 +78,7 @@ device_initcall(se7780_devices_setup);
 #define GPIO_PMSELR      0xFFEA0080
 #define GPIO_PECR        0xFFEA0008
 
-static void __init se7780_setup(char **cmdline_p)
+static void __initmv se7780_setup(char **cmdline_p)
 {
 	/* "SH-Linux" on LED Display */
 	ctrl_outw( 'S' , PA_LED_DISP + (DISP_SEL0_ADDR << 1) );
diff -ruNp c/arch/sh/boards/sh03/setup.c d/arch/sh/boards/sh03/setup.c
--- c/arch/sh/boards/sh03/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/sh03/setup.c	2007-06-23 18:41:55.000000000 +0530
@@ -44,7 +44,7 @@ static void __iomem *sh03_ioport_map(uns
 /* arch/sh/boards/sh03/rtc.c */
 void sh03_time_init(void);
 
-static void __init sh03_setup(char **cmdline_p)
+static void __initmv sh03_setup(char **cmdline_p)
 {
 	board_time_init = sh03_time_init;
 }
diff -ruNp c/arch/sh/boards/snapgear/setup.c d/arch/sh/boards/snapgear/setup.c
--- c/arch/sh/boards/snapgear/setup.c	2007-04-26 08:38:32.000000000 +0530
+++ d/arch/sh/boards/snapgear/setup.c	2007-06-23 18:42:41.000000000 +0530
@@ -88,7 +88,7 @@ static void __init init_snapgear_IRQ(voi
 /*
  * Initialize the board
  */
-static void __init snapgear_setup(char **cmdline_p)
+static void __initmv snapgear_setup(char **cmdline_p)
 {
 	board_time_init = secureedge5410_rtc_init;
 }
diff -ruNp c/arch/sh/boards/superh/microdev/setup.c d/arch/sh/boards/superh/microdev/setup.c
--- c/arch/sh/boards/superh/microdev/setup.c	2007-06-20 17:55:36.000000000 +0530
+++ d/arch/sh/boards/superh/microdev/setup.c	2007-06-23 18:43:51.000000000 +0530
@@ -355,7 +355,7 @@ static int __init smsc_superio_setup(voi
 	return 0;
 }
 
-static void __init microdev_setup(char **cmdline_p)
+static void __initmv microdev_setup(char **cmdline_p)
 {
 	int * const fpgaRevisionRegister = (int*)(MICRODEV_FPGA_GP_BASE + 0x8ul);
 	const int fpgaRevision = *fpgaRevisionRegister;

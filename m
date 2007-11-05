Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXKERTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXKERTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXKERIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:36 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59561 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757826AbXKERIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:31 -0500
Date: Mon, 5 Nov 2007 18:08:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill arch/m68k/amiga/amiga_ksyms.c
Message-ID: <20071105170808.GD12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/amiga/Makefile      |    2 +-
 arch/m68k/amiga/amiga_ksyms.c |   33 ---------------------------------
 arch/m68k/amiga/amisound.c    |    3 +++
 arch/m68k/amiga/chipram.c     |    7 +++++++
 arch/m68k/amiga/config.c      |   12 ++++++++++++
 arch/m68k/amiga/pcmcia.c      |    9 +++++++++
 6 files changed, 32 insertions(+), 34 deletions(-)

d3f693f2a9a840b3b8c041e25f434a8cc09f2ff3 
diff --git a/arch/m68k/amiga/Makefile b/arch/m68k/amiga/Makefile
index 8b41565..6a0d765 100644
--- a/arch/m68k/amiga/Makefile
+++ b/arch/m68k/amiga/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Linux arch/m68k/amiga source directory
 #
 
-obj-y		:= config.o amiints.o cia.o chipram.o amisound.o amiga_ksyms.o
+obj-y		:= config.o amiints.o cia.o chipram.o amisound.o
 
 obj-$(CONFIG_AMIGA_PCMCIA)	+= pcmcia.o
diff --git a/arch/m68k/amiga/amiga_ksyms.c b/arch/m68k/amiga/amiga_ksyms.c
deleted file mode 100644
index 7fdcf6b..0000000
--- a/arch/m68k/amiga/amiga_ksyms.c
+++ /dev/null
@@ -1,33 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amipcmcia.h>
-
-extern volatile u_short amiga_audio_min_period;
-extern u_short amiga_audio_period;
-
-/*
- * Add things here when you find the need for it.
- */
-EXPORT_SYMBOL(amiga_model);
-EXPORT_SYMBOL(amiga_chipset);
-EXPORT_SYMBOL(amiga_hw_present);
-EXPORT_SYMBOL(amiga_eclock);
-EXPORT_SYMBOL(amiga_colorclock);
-EXPORT_SYMBOL(amiga_chip_alloc);
-EXPORT_SYMBOL(amiga_chip_free);
-EXPORT_SYMBOL(amiga_chip_avail);
-EXPORT_SYMBOL(amiga_chip_size);
-EXPORT_SYMBOL(amiga_audio_period);
-EXPORT_SYMBOL(amiga_audio_min_period);
-
-#ifdef CONFIG_AMIGA_PCMCIA
-  EXPORT_SYMBOL(pcmcia_reset);
-  EXPORT_SYMBOL(pcmcia_copy_tuple);
-  EXPORT_SYMBOL(pcmcia_program_voltage);
-  EXPORT_SYMBOL(pcmcia_access_speed);
-  EXPORT_SYMBOL(pcmcia_write_enable);
-  EXPORT_SYMBOL(pcmcia_write_disable);
-#endif
diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
index 1f5bfb5..9af8c6b 100644
--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -12,6 +12,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 #include <asm/amigahw.h>
@@ -31,6 +32,7 @@ static const signed char sine_data[] = {
      */
 
 volatile unsigned short amiga_audio_min_period = 124; /* Default for pre-OCS */
+EXPORT_SYMBOL(amiga_audio_min_period);
 
 #define MAX_PERIOD	(65535)
 
@@ -40,6 +42,7 @@ volatile unsigned short amiga_audio_min_period = 124; /* Default for pre-OCS */
      */
 
 unsigned short amiga_audio_period = MAX_PERIOD;
+EXPORT_SYMBOL(amiga_audio_period);
 
 static unsigned long clock_constant;
 
diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index fa015d8..d10726f 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -13,10 +13,13 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/module.h>
+
 #include <asm/page.h>
 #include <asm/amigahw.h>
 
 unsigned long amiga_chip_size;
+EXPORT_SYMBOL(amiga_chip_size);
 
 static struct resource chipram_res = {
     .name = "Chip RAM", .start = CHIP_PHYSADDR
@@ -67,6 +70,7 @@ void *amiga_chip_alloc(unsigned long size, const char *name)
 #endif
     return (void *)ZTWO_VADDR(res->start);
 }
+EXPORT_SYMBOL(amiga_chip_alloc);
 
 
     /*
@@ -120,6 +124,7 @@ void amiga_chip_free(void *ptr)
     }
     printk("amiga_chip_free: trying to free nonexistent region at %p\n", ptr);
 }
+EXPORT_SYMBOL(amiga_chip_free);
 
 
 unsigned long amiga_chip_avail(void)
@@ -129,3 +134,5 @@ unsigned long amiga_chip_avail(void)
 #endif
 	return chipavail;
 }
+EXPORT_SYMBOL(amiga_chip_avail);
+
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 3574853..50f5daa 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/zorro.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
@@ -36,13 +37,24 @@
 #include <asm/io.h>
 
 unsigned long amiga_model;
+EXPORT_SYMBOL(amiga_model);
+
 unsigned long amiga_eclock;
+EXPORT_SYMBOL(amiga_eclock);
+
 unsigned long amiga_masterclock;
+
 unsigned long amiga_colorclock;
+EXPORT_SYMBOL(amiga_colorclock);
+
 unsigned long amiga_chipset;
+EXPORT_SYMBOL(amiga_chipset);
+
 unsigned char amiga_vblank;
 unsigned char amiga_psfreq;
+
 struct amiga_hw_present amiga_hw_present;
+EXPORT_SYMBOL(amiga_hw_present);
 
 static char s_a500[] __initdata = "A500";
 static char s_a500p[] __initdata = "A500+";
diff --git a/arch/m68k/amiga/pcmcia.c b/arch/m68k/amiga/pcmcia.c
index 186662c..7106f0c 100644
--- a/arch/m68k/amiga/pcmcia.c
+++ b/arch/m68k/amiga/pcmcia.c
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
+#include <linux/module.h>
+
 #include <asm/amigayle.h>
 #include <asm/amipcmcia.h>
 
@@ -30,6 +32,7 @@ void pcmcia_reset(void)
 	while (time_before(jiffies, reset_start_time + 1*HZ/100));
 	b = gayle_reset;
 }
+EXPORT_SYMBOL(pcmcia_reset);
 
 
 /* copy a tuple, including tuple header. return nb bytes copied */
@@ -61,6 +64,7 @@ int pcmcia_copy_tuple(unsigned char tuple_id, void *tuple, int max_len)
 
 	return 0;
 }
+EXPORT_SYMBOL(pcmcia_copy_tuple);
 
 void pcmcia_program_voltage(int voltage)
 {
@@ -84,6 +88,7 @@ void pcmcia_program_voltage(int voltage)
 	gayle.config = cfg_byte;
 
 }
+EXPORT_SYMBOL(pcmcia_program_voltage);
 
 void pcmcia_access_speed(int speed)
 {
@@ -101,13 +106,17 @@ void pcmcia_access_speed(int speed)
 	cfg_byte = (cfg_byte & 0xf3) | s;
 	gayle.config = cfg_byte;
 }
+EXPORT_SYMBOL(pcmcia_access_speed);
 
 void pcmcia_write_enable(void)
 {
 	gayle.cardstatus = GAYLE_CS_WR|GAYLE_CS_DA;
 }
+EXPORT_SYMBOL(pcmcia_write_enable);
 
 void pcmcia_write_disable(void)
 {
 	gayle.cardstatus = 0;
 }
+EXPORT_SYMBOL(pcmcia_write_disable);
+


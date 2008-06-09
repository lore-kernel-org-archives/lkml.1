Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYFIWZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYFIWZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYFIWXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53887 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYFIWXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:22 -0400
Date: Tue, 10 Jun 2008 01:22:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k/amiga/: possible cleanups
Message-ID: <20080609222228.GG1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- amiints.c: add a proper prototype for amiga_init_IRQ() in 
             include/asm-m68k/amigaints.h
- make the following needlessly global code static:
  - config.c: amiga_model
  - config.c: amiga_psfreq
  - config.c: amiga_serial_console_write()
- #if 0 the following unused functions:
  - config.c: amiga_serial_puts()
  - config.c: amiga_serial_console_wait_key()
  - config.c: amiga_serial_gets()
- remove the following unused variable:
  - config.c: amiga_masterclock

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/amiga/config.c     |   20 ++++++--------------
 include/asm-m68k/amigahw.h   |    4 ----
 include/asm-m68k/amigaints.h |    2 ++
 3 files changed, 8 insertions(+), 18 deletions(-)

7468c1d57c48a277ac1b2cdd237eee7a962bb2ad diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index dd0734e..df679d9 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -36,14 +36,11 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 
-unsigned long amiga_model;
-EXPORT_SYMBOL(amiga_model);
+static unsigned long amiga_model;
 
 unsigned long amiga_eclock;
 EXPORT_SYMBOL(amiga_eclock);
 
-unsigned long amiga_masterclock;
-
 unsigned long amiga_colorclock;
 EXPORT_SYMBOL(amiga_colorclock);
 
@@ -53,7 +50,7 @@ EXPORT_SYMBOL(amiga_chipset);
 unsigned char amiga_vblank;
 EXPORT_SYMBOL(amiga_vblank);
 
-unsigned char amiga_psfreq;
+static unsigned char amiga_psfreq;
 
 struct amiga_hw_present amiga_hw_present;
 EXPORT_SYMBOL(amiga_hw_present);
@@ -94,8 +91,6 @@ static char *amiga_models[] __initdata = {
 static char amiga_model_name[13] = "Amiga ";
 
 static void amiga_sched_init(irq_handler_t handler);
-/* amiga specific irq functions */
-extern void amiga_init_IRQ(void);
 static void amiga_get_model(char *model);
 static int amiga_get_hardware_list(char *buffer);
 /* amiga specific timer functions */
@@ -109,8 +104,6 @@ static void amiga_reset(void);
 extern void amiga_init_sound(void);
 static void amiga_mem_console_write(struct console *co, const char *b,
 				    unsigned int count);
-void amiga_serial_console_write(struct console *co, const char *s,
-				unsigned int count);
 #ifdef CONFIG_HEARTBEAT
 static void amiga_heartbeat(int on);
 #endif
@@ -420,8 +413,7 @@ void __init config_amiga(void)
 	mach_heartbeat = amiga_heartbeat;
 #endif
 
-	/* Fill in the clock values (based on the 700 kHz E-Clock) */
-	amiga_masterclock = 40*amiga_eclock;	/* 28 MHz */
+	/* Fill in the clock value (based on the 700 kHz E-Clock) */
 	amiga_colorclock = 5*amiga_eclock;	/* 3.5 MHz */
 
 	/* clear all DMA bits */
@@ -819,8 +811,8 @@ static void amiga_serial_putc(char c)
 		;
 }
 
-void amiga_serial_console_write(struct console *co, const char *s,
-				unsigned int count)
+static void amiga_serial_console_write(struct console *co, const char *s,
+				       unsigned int count)
 {
 	while (count--) {
 		if (*s == '\n')
@@ -829,7 +821,7 @@ void amiga_serial_console_write(struct console *co, const char *s,
 	}
 }
 
-#ifdef CONFIG_SERIAL_CONSOLE
+#if 0
 void amiga_serial_puts(const char *s)
 {
 	amiga_serial_console_write(NULL, s, strlen(s));
diff --git a/include/asm-m68k/amigahw.h b/include/asm-m68k/amigahw.h
index a16fe4e..5ca5dd9 100644
--- a/include/asm-m68k/amigahw.h
+++ b/include/asm-m68k/amigahw.h
@@ -22,8 +22,6 @@
      *  Different Amiga models
      */
 
-extern unsigned long amiga_model;
-
 #define AMI_UNKNOWN	(0)
 #define AMI_500		(1)
 #define AMI_500PLUS	(2)
@@ -59,11 +57,9 @@ extern unsigned long amiga_chipset;
      */
 
 extern unsigned long amiga_eclock;	/* 700 kHz E Peripheral Clock */
-extern unsigned long amiga_masterclock;	/* 28 MHz Master Clock */
 extern unsigned long amiga_colorclock;	/* 3.5 MHz Color Clock */
 extern unsigned long amiga_chip_size;	/* Chip RAM Size (bytes) */
 extern unsigned char amiga_vblank;	/* VBLANK Frequency */
-extern unsigned char amiga_psfreq;	/* Power Supply Frequency */
 
 
 #define AMIGAHW_DECLARE(name)	unsigned name : 1
diff --git a/include/asm-m68k/amigaints.h b/include/asm-m68k/amigaints.h
index 7c87134..31101eb 100644
--- a/include/asm-m68k/amigaints.h
+++ b/include/asm-m68k/amigaints.h
@@ -98,6 +98,8 @@
 #define CIA_ICR_ALL	0x1f
 #define CIA_ICR_SETCLR	0x80
 
+void amiga_init_IRQ(void);
+
 /* to access the interrupt control registers of CIA's use only
 ** these functions, they behave exactly like the amiga os routines
 */


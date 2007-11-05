Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXKERU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXKERU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXKERIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59567 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757920AbXKERIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:49 -0500
Date: Mon, 5 Nov 2007 18:08:25 +0100
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill arch/m68k/atari/atari_ksyms.c
Message-ID: <20071105170825.GF12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/atari/Makefile      |    2 -
 arch/m68k/atari/ataints.c     |    3 ++
 arch/m68k/atari/atari_ksyms.c |   35 ----------------------------------
 arch/m68k/atari/atasound.c    |    2 +
 arch/m68k/atari/config.c      |   11 ++++++++++
 arch/m68k/atari/debug.c       |    6 +++++
 arch/m68k/atari/stdma.c       |    5 ++++
 arch/m68k/atari/stram.c       |    3 ++
 8 files changed, 31 insertions(+), 36 deletions(-)

e84d52fc9189ff418dba466ebca1536d843c71ac 
diff --git a/arch/m68k/atari/Makefile b/arch/m68k/atari/Makefile
index 2cb8619..2cd905e 100644
--- a/arch/m68k/atari/Makefile
+++ b/arch/m68k/atari/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y		:= config.o time.o debug.o ataints.o stdma.o \
-			atasound.o stram.o atari_ksyms.o
+			atasound.o stram.o
 
 ifeq ($(CONFIG_PCI),y)
 obj-$(CONFIG_HADES)	+= hades-pci.o
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index b85ca22..b45593a 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -40,6 +40,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 #include <asm/traps.h>
@@ -446,6 +447,7 @@ unsigned long atari_register_vme_int(void)
 	free_vme_vec_bitmap |= 1 << i;
 	return VME_SOURCE_BASE + i;
 }
+EXPORT_SYMBOL(atari_register_vme_int);
 
 
 void atari_unregister_vme_int(unsigned long irq)
@@ -455,5 +457,6 @@ void atari_unregister_vme_int(unsigned long irq)
 		free_vme_vec_bitmap &= ~(1 << irq);
 	}
 }
+EXPORT_SYMBOL(atari_unregister_vme_int);
 
 
diff --git a/arch/m68k/atari/atari_ksyms.c b/arch/m68k/atari/atari_ksyms.c
deleted file mode 100644
index a047571..0000000
--- a/arch/m68k/atari/atari_ksyms.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <linux/module.h>
-
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-#include <asm/atarihw.h>
-#include <asm/atariints.h>
-#include <asm/atarikb.h>
-#include <asm/atari_joystick.h>
-#include <asm/atari_stdma.h>
-#include <asm/atari_stram.h>
-
-extern void atari_microwire_cmd( int cmd );
-extern int atari_MFP_init_done;
-extern int atari_SCC_init_done;
-extern int atari_SCC_reset_done;
-
-EXPORT_SYMBOL(atari_mch_cookie);
-EXPORT_SYMBOL(atari_mch_type);
-EXPORT_SYMBOL(atari_hw_present);
-EXPORT_SYMBOL(atari_switches);
-EXPORT_SYMBOL(atari_dont_touch_floppy_select);
-EXPORT_SYMBOL(atari_register_vme_int);
-EXPORT_SYMBOL(atari_unregister_vme_int);
-EXPORT_SYMBOL(stdma_lock);
-EXPORT_SYMBOL(stdma_release);
-EXPORT_SYMBOL(stdma_others_waiting);
-EXPORT_SYMBOL(stdma_islocked);
-EXPORT_SYMBOL(atari_stram_alloc);
-EXPORT_SYMBOL(atari_stram_free);
-
-EXPORT_SYMBOL(atari_MFP_init_done);
-EXPORT_SYMBOL(atari_SCC_init_done);
-EXPORT_SYMBOL(atari_SCC_reset_done);
-
-EXPORT_SYMBOL(atari_microwire_cmd);
diff --git a/arch/m68k/atari/atasound.c b/arch/m68k/atari/atasound.c
index ee04250..d266fe8 100644
--- a/arch/m68k/atari/atasound.c
+++ b/arch/m68k/atari/atasound.c
@@ -22,6 +22,7 @@
 #include <linux/fcntl.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include <asm/atarihw.h>
 #include <asm/system.h>
@@ -43,6 +44,7 @@ void atari_microwire_cmd (int cmd)
 	while( tt_microwire.mask != 0x7ff)
 		;
 }
+EXPORT_SYMBOL(atari_microwire_cmd);
 
 
 /* PSG base frequency */
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index e40e5dc..5945e15 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/vt_kern.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
@@ -43,10 +44,20 @@
 #include <asm/io.h>
 
 u_long atari_mch_cookie;
+EXPORT_SYMBOL(atari_mch_cookie);
+
 u_long atari_mch_type;
+EXPORT_SYMBOL(atari_mch_type);
+
 struct atari_hw_present atari_hw_present;
+EXPORT_SYMBOL(atari_hw_present);
+
 u_long atari_switches;
+EXPORT_SYMBOL(atari_switches);
+
 int atari_dont_touch_floppy_select;
+EXPORT_SYMBOL(atari_dont_touch_floppy_select);
+
 int atari_rtc_year_offset;
 
 /* local function prototypes */
diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index fbeed8c..043ddbc 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -15,17 +15,23 @@
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 
 /* Flag that Modem1 port is already initialized and used */
 int atari_MFP_init_done;
+EXPORT_SYMBOL(atari_MFP_init_done);
+
 /* Flag that Modem1 port is already initialized and used */
 int atari_SCC_init_done;
+EXPORT_SYMBOL(atari_SCC_init_done);
+
 /* Can be set somewhere, if a SCC master reset has already be done and should
  * not be repeated; used by kgdb */
 int atari_SCC_reset_done;
+EXPORT_SYMBOL(atari_SCC_reset_done);
 
 static struct console atari_console_driver = {
 	.name	= "debug",
diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
index ab3fd52..d1bd029 100644
--- a/arch/m68k/atari/stdma.c
+++ b/arch/m68k/atari/stdma.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 
 #include <asm/atari_stdma.h>
 #include <asm/atariints.h>
@@ -91,6 +92,7 @@ void stdma_lock(irq_handler_t handler, void *data)
 	stdma_isr_data = data;
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(stdma_lock);
 
 
 /*
@@ -117,6 +119,7 @@ void stdma_release(void)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(stdma_release);
 
 
 /*
@@ -134,6 +137,7 @@ int stdma_others_waiting(void)
 {
 	return waitqueue_active(&stdma_wait);
 }
+EXPORT_SYMBOL(stdma_others_waiting);
 
 
 /*
@@ -155,6 +159,7 @@ int stdma_islocked(void)
 {
 	return stdma_locked;
 }
+EXPORT_SYMBOL(stdma_islocked);
 
 
 /*
diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index bf4588c..8dda651 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -20,6 +20,7 @@
 #include <linux/bootmem.h>
 #include <linux/mount.h>
 #include <linux/blkdev.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/machdep.h>
@@ -208,6 +209,7 @@ void *atari_stram_alloc(long size, const char *owner)
 	}
 	return( addr );
 }
+EXPORT_SYMBOL(atari_stram_alloc);
 
 void atari_stram_free( void *addr )
 
@@ -237,6 +239,7 @@ void atari_stram_free( void *addr )
 	printk( KERN_ERR "atari_stram_free: cannot free block at %p "
 			"(called from %p)\n", addr, __builtin_return_address(0) );
 }
+EXPORT_SYMBOL(atari_stram_free);
 
 
 /* ------------------------------------------------------------------------ */


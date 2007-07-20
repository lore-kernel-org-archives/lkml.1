Return-Path: <linux-kernel-owner+w=401wt.eu-S1765876AbXGTDeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765876AbXGTDeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763350AbXGTDdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35653 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763195AbXGTDdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:19 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 4/8] m68k: missing exports
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjF0-0004lI-5W@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/atari/atakeyb.c      |    9 ++++++++-
 arch/m68k/kernel/setup.c       |    1 +
 arch/m68k/mac/config.c         |    1 +
 arch/m68k/mm/sun3kmap.c        |    2 ++
 drivers/ide/legacy/falconide.c |    2 ++
 drivers/scsi/NCR53C9x.c        |    7 +++++++
 6 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 1c29603..2b5f647 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -13,6 +13,7 @@
  * enhanced by Bjoern Brauel and Roman Hodek
  */
 
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -42,6 +43,9 @@ void (*atari_mouse_interrupt_hook) (char *);
 void (*atari_input_keyboard_interrupt_hook) (unsigned char, char);
 /* Hook for mouse inputdev  driver */
 void (*atari_input_mouse_interrupt_hook) (char *);
+EXPORT_SYMBOL(atari_mouse_interrupt_hook);
+EXPORT_SYMBOL(atari_input_keyboard_interrupt_hook);
+EXPORT_SYMBOL(atari_input_mouse_interrupt_hook);
 
 /* variables for IKBD self test: */
 
@@ -429,6 +433,7 @@ void ikbd_mouse_rel_pos(void)
 
 	ikbd_write(cmd, 1);
 }
+EXPORT_SYMBOL(ikbd_mouse_rel_pos);
 
 /* Set absolute mouse position reporting */
 void ikbd_mouse_abs_pos(int xmax, int ymax)
@@ -453,6 +458,7 @@ void ikbd_mouse_thresh(int x, int y)
 
 	ikbd_write(cmd, 3);
 }
+EXPORT_SYMBOL(ikbd_mouse_thresh);
 
 /* Set mouse scale */
 void ikbd_mouse_scale(int x, int y)
@@ -495,6 +501,7 @@ void ikbd_mouse_y0_top(void)
 
 	ikbd_write(cmd, 1);
 }
+EXPORT_SYMBOL(ikbd_mouse_y0_top);
 
 /* Resume */
 void ikbd_resume(void)
@@ -511,6 +518,7 @@ void ikbd_mouse_disable(void)
 
 	ikbd_write(cmd, 1);
 }
+EXPORT_SYMBOL(ikbd_mouse_disable);
 
 /* Pause output */
 void ikbd_pause(void)
@@ -696,7 +704,6 @@ int __init atari_keyb_init(void)
 	return 0;
 }
 
-
 int atari_kbdrate(struct kbd_repeat *k)
 {
 	if (k->delay > 0) {
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index 215c7bd..7e6d5fb 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -58,6 +58,7 @@ extern int end;
 extern unsigned long availmem;
 
 int m68k_num_memory;
+EXPORT_SYMBOL(m68k_num_memory);
 int m68k_realnum_memory;
 EXPORT_SYMBOL(m68k_realnum_memory);
 unsigned long m68k_memoffset;
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 5fd4132..9a7f14e 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -49,6 +49,7 @@ struct mac_booter_data mac_bi_data;
 int mac_bisize = sizeof mac_bi_data;
 
 struct mac_hw_present mac_hw_present;
+EXPORT_SYMBOL(mac_hw_present);
 
 /* New m68k bootinfo stuff and videobase */
 
diff --git a/arch/m68k/mm/sun3kmap.c b/arch/m68k/mm/sun3kmap.c
index 1af24cb..3dc4115 100644
--- a/arch/m68k/mm/sun3kmap.c
+++ b/arch/m68k/mm/sun3kmap.c
@@ -105,6 +105,7 @@ void __iomem *sun3_ioremap(unsigned long phys, unsigned long size,
 	return (void __iomem *)ret;
 
 }
+EXPORT_SYMBOL(sun3_ioremap);
 
 
 void __iomem *__ioremap(unsigned long phys, unsigned long size, int cache)
@@ -157,3 +158,4 @@ int sun3_map_test(unsigned long addr, char *val)
 
 	return ret;
 }
+EXPORT_SYMBOL(sun3_map_test);
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index e1e9d9d..f0829b8 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -8,6 +8,7 @@
  *  more details.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
@@ -54,6 +55,7 @@ static int falconide_offsets[IDE_NR_PORTS] __initdata = {
      */
 
 int falconide_intr_lock;
+EXPORT_SYMBOL(falconide_intr_lock);
 
 
     /*
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 773d11d..79b4df1 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -95,6 +95,8 @@ enum {
 /* The master ring of all esp hosts we are managing in this driver. */
 static struct NCR_ESP *espchain;
 int nesps = 0, esps_in_use = 0, esps_running = 0;
+EXPORT_SYMBOL(nesps);
+EXPORT_SYMBOL(esps_running);
 
 irqreturn_t esp_intr(int irq, void *dev_id);
 
@@ -524,6 +526,7 @@ void esp_bootup_reset(struct NCR_ESP *esp, struct ESP_regs *eregs)
 	/* Eat any bitrot in the chip and we are done... */
 	trash = esp_read(eregs->esp_intrpt);
 }
+EXPORT_SYMBOL(esp_bootup_reset);
 
 /* Allocate structure and insert basic data such as SCSI chip frequency
  * data and a pointer to the device
@@ -772,6 +775,7 @@ const char *esp_info(struct Scsi_Host *host)
 		panic("Bogon ESP revision");
 	};
 }
+EXPORT_SYMBOL(esp_info);
 
 /* From Wolfgang Stanglmeier's NCR scsi driver. */
 struct info_str
@@ -902,6 +906,7 @@ int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t off
 		*start = buffer;
 	return esp_host_info(esp, buffer, offset, length);
 }
+EXPORT_SYMBOL(esp_proc_info);
 
 static void esp_get_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 {
@@ -3535,6 +3540,7 @@ state_machine:
 	if(esp->dma_irq_exit)
 		esp->dma_irq_exit(esp);
 }
+EXPORT_SYMBOL(esp_handle);
 
 #ifndef CONFIG_SMP
 irqreturn_t esp_intr(int irq, void *dev_id)
@@ -3631,6 +3637,7 @@ void esp_release(void)
 	esps_in_use--;
 	esps_running = esps_in_use;
 }
+EXPORT_SYMBOL(esp_release);
 #endif
 
 EXPORT_SYMBOL(esp_abort);
-- 
1.5.3.GIT



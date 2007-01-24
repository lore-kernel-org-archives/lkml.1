Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXAXWgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXAXWgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbXAXWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:36:04 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:3359 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932825AbXAXWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:36:01 -0500
Date: Wed, 24 Jan 2007 23:36:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/media/video/bt8xx/: possible cleanups
Message-ID: <20070124223608.GR17836@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- remove the following unused global functions:
  - bttv-if.c: bttv_get_cardinfo()
  - bttv-if.c: bttv_get_id()
  - bttv-if.c: bttv_get_gpio_queue()
  - bttv-if.c: bttv_i2c_call()
- remove the following unused EXPORT_SYMBOL's:
  - bttv-gpio.c: bttv_sub_bus_type
  - bttv-gpio.c: bttv_gpio_inout
  - bttv-gpio.c: bttv_gpio_read
  - bttv-gpio.c: bttv_gpio_write
  - bttv-gpio.c: bttv_gpio_bits

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/bt8xx/bttv-gpio.c |    5 --
 drivers/media/video/bt8xx/bttv-if.c   |   50 --------------------------
 drivers/media/video/bt8xx/bttv.h      |   24 ------------
 3 files changed, 79 deletions(-)

--- linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv-gpio.c.old	2006-04-23 01:18:08.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv-gpio.c	2006-04-23 01:19:52.000000000 +0200
@@ -71,7 +71,6 @@
 	.probe  = bttv_sub_probe,
 	.remove = bttv_sub_remove,
 };
-EXPORT_SYMBOL(bttv_sub_bus_type);
 
 static void release_sub_device(struct device *dev)
 {
@@ -166,7 +167,6 @@
 	btwrite(data,BT848_GPIO_OUT_EN);
 	spin_unlock_irqrestore(&btv->gpio_lock,flags);
 }
-EXPORT_SYMBOL(bttv_gpio_inout);
 
 u32 bttv_gpio_read(struct bttv_core *core)
 {
@@ -176,7 +176,6 @@
 	value = btread(BT848_GPIO_DATA);
 	return value;
 }
-EXPORT_SYMBOL(bttv_gpio_read);
 
 void bttv_gpio_write(struct bttv_core *core, u32 value)
 {
@@ -184,7 +183,6 @@
 
 	btwrite(value,BT848_GPIO_DATA);
 }
-EXPORT_SYMBOL(bttv_gpio_write);
 
 void bttv_gpio_bits(struct bttv_core *core, u32 mask, u32 bits)
 {
@@ -199,7 +197,6 @@
 	btwrite(data,BT848_GPIO_DATA);
 	spin_unlock_irqrestore(&btv->gpio_lock,flags);
 }
-EXPORT_SYMBOL(bttv_gpio_bits);
 
 /*
  * Local variables:
--- linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv.h.old	2006-04-23 01:21:30.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv.h	2006-04-23 01:23:19.000000000 +0200
@@ -287,17 +287,8 @@
 /* this obsolete -- please use the sysfs-based
    interface below for new code */
 
-/* returns card type + card ID (for bt878-based ones)
-   for possible values see lines below beginning with #define BTTV_BOARD_UNKNOWN
-   returns negative value if error occurred
-*/
-extern int bttv_get_cardinfo(unsigned int card, int *type,
-			     unsigned int *cardid);
 extern struct pci_dev* bttv_get_pcidev(unsigned int card);
 
-/* obsolete, use bttv_get_cardinfo instead */
-extern int bttv_get_id(unsigned int card);
-
 /* sets GPOE register (BT848_GPIO_OUT_EN) to new value:
    data | (current_GPOE_value & ~mask)
    returns negative value if error occurred
@@ -317,21 +308,6 @@
 extern int bttv_write_gpio(unsigned int card,
 			   unsigned long mask, unsigned long data);
 
-/* returns pointer to task queue which can be used as parameter to
-   interruptible_sleep_on
-   in interrupt handler if BT848_INT_GPINT bit is set - this queue is activated
-   (wake_up_interruptible) and following call to the function bttv_read_gpio
-   should return new value of GPDATA,
-   returns NULL value if error occurred or queue is not available
-   WARNING: because there is no buffer for GPIO data, one MUST
-   process data ASAP
-*/
-extern wait_queue_head_t* bttv_get_gpio_queue(unsigned int card);
-
-/* call i2c clients
-*/
-extern void bttv_i2c_call(unsigned int card, unsigned int cmd, void *arg);
-
 
 
 /* ---------------------------------------------------------- */
--- linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv-if.c.old	2006-04-23 01:20:25.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/video/bt8xx/bttv-if.c	2006-04-23 01:23:39.000000000 +0200
@@ -33,32 +33,16 @@
 
 #include "bttvp.h"
 
-EXPORT_SYMBOL(bttv_get_cardinfo);
 EXPORT_SYMBOL(bttv_get_pcidev);
-EXPORT_SYMBOL(bttv_get_id);
 EXPORT_SYMBOL(bttv_gpio_enable);
 EXPORT_SYMBOL(bttv_read_gpio);
 EXPORT_SYMBOL(bttv_write_gpio);
-EXPORT_SYMBOL(bttv_get_gpio_queue);
-EXPORT_SYMBOL(bttv_i2c_call);
 
 /* ----------------------------------------------------------------------- */
 /* Exported functions - for other modules which want to access the         */
 /*                      gpio ports (IR for example)                        */
 /*                      see bttv.h for comments                            */
 
-int bttv_get_cardinfo(unsigned int card, int *type, unsigned *cardid)
-{
-	printk("The bttv_* interface is obsolete and will go away,\n"
-	       "please use the new, sysfs based interface instead.\n");
-	if (card >= bttv_num) {
-		return -1;
-	}
-	*type   = bttvs[card].c.type;
-	*cardid = bttvs[card].cardid;
-	return 0;
-}
-
 struct pci_dev* bttv_get_pcidev(unsigned int card)
 {
 	if (card >= bttv_num)
@@ -66,17 +50,6 @@
 	return bttvs[card].c.pci;
 }
 
-int bttv_get_id(unsigned int card)
-{
-	printk("The bttv_* interface is obsolete and will go away,\n"
-	       "please use the new, sysfs based interface instead.\n");
-	if (card >= bttv_num) {
-		return -1;
-	}
-	return bttvs[card].c.type;
-}
-
-
 int bttv_gpio_enable(unsigned int card, unsigned long mask, unsigned long data)
 {
 	struct bttv *btv;
@@ -130,28 +103,6 @@
 	return 0;
 }
 
-wait_queue_head_t* bttv_get_gpio_queue(unsigned int card)
-{
-	struct bttv *btv;
-
-	if (card >= bttv_num) {
-		return NULL;
-	}
-
-	btv = &bttvs[card];
-	if (bttvs[card].shutdown) {
-		return NULL;
-	}
-	return &btv->gpioq;
-}
-
-void bttv_i2c_call(unsigned int card, unsigned int cmd, void *arg)
-{
-	if (card >= bttv_num)
-		return;
-	bttv_call_i2c_clients(&bttvs[card], cmd, arg);
-}
-
 /*
  * Local variables:
  * c-basic-offset: 8




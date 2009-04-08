Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbZDHGZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbZDHGZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbZDHGZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:25:12 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:13623 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164AbZDHGZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:25:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACvf20lR9NvS/2dsb2JhbADNJweCLQGBRgaHZA
Date: Wed, 8 Apr 2009 08:25:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, u.kleine-koenig@pengutronix.de,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Thomas Reitmayr <treitmayr@devbase.at>
Subject: [WATCHDOG] v2.6.30-rc1 patches
Message-ID: <20090408062505.GB6025@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig          |    2 
 drivers/watchdog/Makefile         |    2 
 drivers/watchdog/at91rm9200_wdt.c |    6 -
 drivers/watchdog/i6300esb.c       |  155 ++++++++++++++++++--------------------
 drivers/watchdog/ks8695_wdt.c     |    6 -
 drivers/watchdog/omap_wdt.c       |    6 -
 drivers/watchdog/orion5x_wdt.c    |   57 ++++++++++---
 7 files changed, 128 insertions(+), 106 deletions(-)

with these Changes:

Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Sat Mar 28 00:26:56 2009 +0100

    [WATCHDOG] omap_wdt.c: move probe function to .devinit.text
    
    A pointer to omap_wdt_probe is passed to the core via
    platform_driver_register and so the function must not disappear when the
    .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
    unbinding and binding a device to the driver via sysfs will result in an
    oops as does a device being registered late.
    
    An alternative to this patch is using platform_driver_probe instead of
    platform_driver_register plus removing the pointer to the probe function
    from the struct platform_driver.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Cc: Alan Cox <alan@redhat.com>
    Cc: Felipe Balbi <felipe.balbi@nokia.com>
    Cc: George G. Davis <gdavis@mvista.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Sat Mar 28 00:26:45 2009 +0100

    [WATCHDOG] ks8695_wdt.c: move probe function to .devinit.text
    
    A pointer to ks8695wdt_probe is passed to the core via
    platform_driver_register and so the function must not disappear when the
    .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
    unbinding and binding a device to the driver via sysfs will result in an
    oops as does a device being registered late.
    
    An alternative to this patch is using platform_driver_probe instead of
    platform_driver_register plus removing the pointer to the probe function
    from the struct platform_driver.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Alan Cox <alan@redhat.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Sat Mar 28 00:26:26 2009 +0100

    [WATCHDOG] at91rm9200_wdt.c: move probe function to .devinit.text
    
    A pointer to at91wdt_probe is passed to the core via
    platform_driver_register and so the function must not disappear when the
    .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
    unbinding and binding a device to the driver via sysfs will result in an
    oops as does a device being registered late.
    
    An alternative to this patch is using platform_driver_probe instead of
    platform_driver_register plus removing the pointer to the probe function
    from the struct platform_driver.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Cc: Andrew Victor <linux@maxim.org.za>
    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    Cc: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date:   Tue Mar 31 15:46:57 2009 +0300

    [WATCHDOG] remove ARM26 sections
    
    Removes ARM26 sections from Kconfig and Makefile, because
    ARM26 is long gone.
    
    Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
    Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Reitmayr <treitmayr@devbase.at>
Date:   Fri Feb 20 19:44:59 2009 +0100

    [WATCHDOG] orion5x_wdt: Add shutdown callback, use watchdog ping function
    
    * Added a callback to disable the watchdog on shutdown.
    * Use a separate ping function to reduce the number of register accesses
      if the watchdog is already enabled and just needs to be reloaded.
    * Minor cleanup of function names.
    
    Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 25 19:16:28 2009 +0000

    [WATCHDOG] i6300esb.c: Restructure initialization of the device
    
    The i6300ESB watchdog should be stopped before userspace has access to the
    watchdog. So fix this and restructure the initialization sequence into:
    	* See if we have a i6300 device
    	* make sure that we have valid module parameters
    	* Initialize the device
    	* register the /dev/watchdog device so that userspace has access
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 25 19:14:45 2009 +0000

    [WATCHDOG] i6300esb.c: Fix the GETSTATUS and GETBOOTSTATUS ioctls.
    
    The WDIOC_GETSTATUS and WDIOC_GETBOOTSTATUS should return WDIOF_* flags
    (and not counter values, ...)
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 25 19:20:10 2009 +0000

    [WATCHDOG] i6300esb.c: Cleanup
    
    Cleanup to keep checkpatch.pl happy.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 6302414..5eb8f21 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -240,8 +240,6 @@ config ORION5X_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called orion5x_wdt.
 
-# ARM26 Architecture
-
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 806b3eb..7f8c56b 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -42,8 +42,6 @@ obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION5X_WATCHDOG) += orion5x_wdt.o
 
-# ARM26 Architecture
-
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
 
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index e35d545..29e52c2 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -197,7 +197,7 @@ static struct miscdevice at91wdt_miscdev = {
 	.fops		= &at91wdt_fops,
 };
 
-static int __init at91wdt_probe(struct platform_device *pdev)
+static int __devinit at91wdt_probe(struct platform_device *pdev)
 {
 	int res;
 
@@ -214,7 +214,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit at91wdt_remove(struct platform_device *pdev)
+static int __devexit at91wdt_remove(struct platform_device *pdev)
 {
 	int res;
 
@@ -252,7 +252,7 @@ static int at91wdt_resume(struct platform_device *pdev)
 
 static struct platform_driver at91wdt_driver = {
 	.probe		= at91wdt_probe,
-	.remove		= __exit_p(at91wdt_remove),
+	.remove		= __devexit_p(at91wdt_remove),
 	.shutdown	= at91wdt_shutdown,
 	.suspend	= at91wdt_suspend,
 	.resume		= at91wdt_resume,
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 2dbe835..7ba0b11 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -52,10 +52,10 @@
 #define ESB_LOCK_REG    0x68            /* WDT lock register                 */
 
 /* Memory mapped registers */
-#define ESB_TIMER1_REG  BASEADDR + 0x00 /* Timer1 value after each reset     */
-#define ESB_TIMER2_REG  BASEADDR + 0x04 /* Timer2 value after each reset     */
-#define ESB_GINTSR_REG  BASEADDR + 0x08 /* General Interrupt Status Register */
-#define ESB_RELOAD_REG  BASEADDR + 0x0c /* Reload register                   */
+#define ESB_TIMER1_REG (BASEADDR + 0x00)/* Timer1 value after each reset     */
+#define ESB_TIMER2_REG (BASEADDR + 0x04)/* Timer2 value after each reset     */
+#define ESB_GINTSR_REG (BASEADDR + 0x08)/* General Interrupt Status Register */
+#define ESB_RELOAD_REG (BASEADDR + 0x0c)/* Reload register                   */
 
 /* Lock register bits */
 #define ESB_WDT_FUNC    (0x01 << 2)   /* Watchdog functionality            */
@@ -68,6 +68,7 @@
 #define ESB_WDT_INTTYPE (0x11 << 0)   /* Interrupt type on timer1 timeout  */
 
 /* Reload register bits */
+#define ESB_WDT_TIMEOUT (0x01 << 9)    /* Watchdog timed out                */
 #define ESB_WDT_RELOAD  (0x01 << 8)    /* prevent timeout                   */
 
 /* Magic constants */
@@ -87,7 +88,6 @@ static struct platform_device *esb_platform_device;
 /* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
 #define WATCHDOG_HEARTBEAT 30
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
-
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat,
 		"Watchdog heartbeat in seconds. (1<heartbeat<2046, default="
@@ -123,7 +123,7 @@ static int esb_timer_start(void)
 	esb_unlock_registers();
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 	/* Enable or Enable + Lock? */
-	val = 0x02 | (nowayout ? 0x01 : 0x00);
+	val = ESB_WDT_ENABLE | (nowayout ? ESB_WDT_LOCK : 0x00);
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
 	spin_unlock(&esb_lock);
 	return 0;
@@ -143,7 +143,7 @@ static int esb_timer_stop(void)
 	spin_unlock(&esb_lock);
 
 	/* Returns 0 if the timer was disabled, non-zero otherwise */
-	return (val & 0x01);
+	return val & ESB_WDT_ENABLE;
 }
 
 static void esb_timer_keepalive(void)
@@ -190,18 +190,6 @@ static int esb_timer_set_heartbeat(int time)
 	return 0;
 }
 
-static int esb_timer_read(void)
-{
-	u32 count;
-
-	/* This isn't documented, and doesn't take into
-	 * acount which stage is running, but it looks
-	 * like a 20 bit count down, so we might as well report it.
-	 */
-	pci_read_config_dword(esb_pci, 0x64, &count);
-	return (int)count;
-}
-
 /*
  *	/dev/watchdog handling
  */
@@ -282,7 +270,7 @@ static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 					sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
-		return put_user(esb_timer_read(), p);
+		return put_user(0, p);
 
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(triggered, p);
@@ -362,8 +350,6 @@ MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
 
 static unsigned char __devinit esb_getdevice(void)
 {
-	u8 val1;
-	unsigned short val2;
 	/*
 	 *      Find the PCI device
 	 */
@@ -371,66 +357,79 @@ static unsigned char __devinit esb_getdevice(void)
 	esb_pci = pci_get_device(PCI_VENDOR_ID_INTEL,
 					PCI_DEVICE_ID_INTEL_ESB_9, NULL);
 
-	if (esb_pci) {
-		if (pci_enable_device(esb_pci)) {
-			printk(KERN_ERR PFX "failed to enable device\n");
-			goto err_devput;
-		}
+	if (!esb_pci)
+		return 0;
 
-		if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
-			printk(KERN_ERR PFX "failed to request region\n");
-			goto err_disable;
-		}
+	if (pci_enable_device(esb_pci)) {
+		printk(KERN_ERR PFX "failed to enable device\n");
+		goto err_devput;
+	}
 
-		BASEADDR = pci_ioremap_bar(esb_pci, 0);
-		if (BASEADDR == NULL) {
-			/* Something's wrong here, BASEADDR has to be set */
-			printk(KERN_ERR PFX "failed to get BASEADDR\n");
-			goto err_release;
-		}
+	if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
+		printk(KERN_ERR PFX "failed to request region\n");
+		goto err_disable;
+	}
 
-		/*
-		 * The watchdog has two timers, it can be setup so that the
-		 * expiry of timer1 results in an interrupt and the expiry of
-		 * timer2 results in a reboot. We set it to not generate
-		 * any interrupts as there is not much we can do with it
-		 * right now.
-		 *
-		 * We also enable reboots and set the timer frequency to
-		 * the PCI clock divided by 2^15 (approx 1KHz).
-		 */
-		pci_write_config_word(esb_pci, ESB_CONFIG_REG, 0x0003);
-
-		/* Check that the WDT isn't already locked */
-		pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
-		if (val1 & ESB_WDT_LOCK)
-			printk(KERN_WARNING PFX "nowayout already set\n");
-
-		/* Set the timer to watchdog mode and disable it for now */
-		pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
-
-		/* Check if the watchdog was previously triggered */
-		esb_unlock_registers();
-		val2 = readw(ESB_RELOAD_REG);
-		triggered = (val2 & (0x01 << 9) >> 9);
-
-		/* Reset trigger flag and timers */
-		esb_unlock_registers();
-		writew((0x11 << 8), ESB_RELOAD_REG);
-
-		/* Done */
-		return 1;
+	BASEADDR = pci_ioremap_bar(esb_pci, 0);
+	if (BASEADDR == NULL) {
+		/* Something's wrong here, BASEADDR has to be set */
+		printk(KERN_ERR PFX "failed to get BASEADDR\n");
+		goto err_release;
+	}
+
+	/* Done */
+	return 1;
 
 err_release:
-		pci_release_region(esb_pci, 0);
+	pci_release_region(esb_pci, 0);
 err_disable:
-		pci_disable_device(esb_pci);
+	pci_disable_device(esb_pci);
 err_devput:
-		pci_dev_put(esb_pci);
-	}
+	pci_dev_put(esb_pci);
 	return 0;
 }
 
+static void __devinit esb_initdevice(void)
+{
+	u8 val1;
+	u16 val2;
+
+	/*
+	 * Config register:
+	 * Bit    5 : 0 = Enable WDT_OUTPUT
+	 * Bit    2 : 0 = set the timer frequency to the PCI clock
+	 * divided by 2^15 (approx 1KHz).
+	 * Bits 1:0 : 11 = WDT_INT_TYPE Disabled.
+	 * The watchdog has two timers, it can be setup so that the
+	 * expiry of timer1 results in an interrupt and the expiry of
+	 * timer2 results in a reboot. We set it to not generate
+	 * any interrupts as there is not much we can do with it
+	 * right now.
+	 */
+	pci_write_config_word(esb_pci, ESB_CONFIG_REG, 0x0003);
+
+	/* Check that the WDT isn't already locked */
+	pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
+	if (val1 & ESB_WDT_LOCK)
+		printk(KERN_WARNING PFX "nowayout already set\n");
+
+	/* Set the timer to watchdog mode and disable it for now */
+	pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
+
+	/* Check if the watchdog was previously triggered */
+	esb_unlock_registers();
+	val2 = readw(ESB_RELOAD_REG);
+	if (val2 & ESB_WDT_TIMEOUT)
+		triggered = WDIOF_CARDRESET;
+
+	/* Reset WDT_TIMEOUT flag and timers */
+	esb_unlock_registers();
+	writew((ESB_WDT_TIMEOUT | ESB_WDT_RELOAD), ESB_RELOAD_REG);
+
+	/* And set the correct timeout value */
+	esb_timer_set_heartbeat(heartbeat);
+}
+
 static int __devinit esb_probe(struct platform_device *dev)
 {
 	int ret;
@@ -441,13 +440,17 @@ static int __devinit esb_probe(struct platform_device *dev)
 
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-	if (esb_timer_set_heartbeat(heartbeat)) {
-		esb_timer_set_heartbeat(WATCHDOG_HEARTBEAT);
+	if (heartbeat < 0x1 || heartbeat > 2 * 0x03ff) {
+		heartbeat = WATCHDOG_HEARTBEAT;
 		printk(KERN_INFO PFX
 			"heartbeat value must be 1<heartbeat<2046, using %d\n",
 								heartbeat);
 	}
 
+	/* Initialize the watchdog and make sure it does not run */
+	esb_initdevice();
+
+	/* Register the watchdog so that userspace has access to it */
 	ret = misc_register(&esb_miscdev);
 	if (ret != 0) {
 		printk(KERN_ERR PFX
@@ -455,7 +458,6 @@ static int __devinit esb_probe(struct platform_device *dev)
 							WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
-	esb_timer_stop();
 	printk(KERN_INFO PFX
 		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
 						BASEADDR, heartbeat, nowayout);
@@ -463,11 +465,8 @@ static int __devinit esb_probe(struct platform_device *dev)
 
 err_unmap:
 	iounmap(BASEADDR);
-/* err_release: */
 	pci_release_region(esb_pci, 0);
-/* err_disable: */
 	pci_disable_device(esb_pci);
-/* err_devput: */
 	pci_dev_put(esb_pci);
 	return ret;
 }
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 74c92d3..ae38321 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -221,7 +221,7 @@ static struct miscdevice ks8695wdt_miscdev = {
 	.fops		= &ks8695wdt_fops,
 };
 
-static int __init ks8695wdt_probe(struct platform_device *pdev)
+static int __devinit ks8695wdt_probe(struct platform_device *pdev)
 {
 	int res;
 
@@ -238,7 +238,7 @@ static int __init ks8695wdt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit ks8695wdt_remove(struct platform_device *pdev)
+static int __devexit ks8695wdt_remove(struct platform_device *pdev)
 {
 	int res;
 
@@ -276,7 +276,7 @@ static int ks8695wdt_resume(struct platform_device *pdev)
 
 static struct platform_driver ks8695wdt_driver = {
 	.probe		= ks8695wdt_probe,
-	.remove		= __exit_p(ks8695wdt_remove),
+	.remove		= __devexit_p(ks8695wdt_remove),
 	.shutdown	= ks8695wdt_shutdown,
 	.suspend	= ks8695wdt_suspend,
 	.resume		= ks8695wdt_resume,
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index aa5ad6e..f271385 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -258,7 +258,7 @@ static const struct file_operations omap_wdt_fops = {
 	.release = omap_wdt_release,
 };
 
-static int __init omap_wdt_probe(struct platform_device *pdev)
+static int __devinit omap_wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
@@ -367,7 +367,7 @@ static void omap_wdt_shutdown(struct platform_device *pdev)
 		omap_wdt_disable(wdev);
 }
 
-static int omap_wdt_remove(struct platform_device *pdev)
+static int __devexit omap_wdt_remove(struct platform_device *pdev)
 {
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -426,7 +426,7 @@ static int omap_wdt_resume(struct platform_device *pdev)
 
 static struct platform_driver omap_wdt_driver = {
 	.probe		= omap_wdt_probe,
-	.remove		= omap_wdt_remove,
+	.remove		= __devexit_p(omap_wdt_remove),
 	.shutdown	= omap_wdt_shutdown,
 	.suspend	= omap_wdt_suspend,
 	.resume		= omap_wdt_resume,
diff --git a/drivers/watchdog/orion5x_wdt.c b/drivers/watchdog/orion5x_wdt.c
index e81441f..7529616 100644
--- a/drivers/watchdog/orion5x_wdt.c
+++ b/drivers/watchdog/orion5x_wdt.c
@@ -42,7 +42,17 @@ static unsigned int wdt_tclk;
 static unsigned long wdt_status;
 static spinlock_t wdt_lock;
 
-static void wdt_enable(void)
+static void orion5x_wdt_ping(void)
+{
+	spin_lock(&wdt_lock);
+
+	/* Reload watchdog duration */
+	writel(wdt_tclk * heartbeat, WDT_VAL);
+
+	spin_unlock(&wdt_lock);
+}
+
+static void orion5x_wdt_enable(void)
 {
 	u32 reg;
 
@@ -69,7 +79,7 @@ static void wdt_enable(void)
 	spin_unlock(&wdt_lock);
 }
 
-static void wdt_disable(void)
+static void orion5x_wdt_disable(void)
 {
 	u32 reg;
 
@@ -101,7 +111,7 @@ static int orion5x_wdt_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-	wdt_enable();
+	orion5x_wdt_enable();
 	return nonseekable_open(inode, file);
 }
 
@@ -122,18 +132,28 @@ static ssize_t orion5x_wdt_write(struct file *file, const char *data,
 					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
 			}
 		}
-		wdt_enable();
+		orion5x_wdt_ping();
 	}
 	return len;
 }
 
-static struct watchdog_info ident = {
+static int orion5x_wdt_settimeout(int new_time)
+{
+	if ((new_time <= 0) || (new_time > wdt_max_duration))
+		return -EINVAL;
+
+	/* Set new watchdog time to be used when
+	 * orion5x_wdt_enable() or orion5x_wdt_ping() is called. */
+	heartbeat = new_time;
+	return 0;
+}
+
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 			  WDIOF_KEEPALIVEPING,
 	.identity	= "Orion5x Watchdog",
 };
 
-
 static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
@@ -152,7 +172,7 @@ static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case WDIOC_KEEPALIVE:
-		wdt_enable();
+		orion5x_wdt_ping();
 		ret = 0;
 		break;
 
@@ -161,12 +181,11 @@ static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (ret)
 			break;
 
-		if (time <= 0 || time > wdt_max_duration) {
+		if (orion5x_wdt_settimeout(time)) {
 			ret = -EINVAL;
 			break;
 		}
-		heartbeat = time;
-		wdt_enable();
+		orion5x_wdt_ping();
 		/* Fall through */
 
 	case WDIOC_GETTIMEOUT:
@@ -187,7 +206,7 @@ static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 static int orion5x_wdt_release(struct inode *inode, struct file *file)
 {
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		wdt_disable();
+		orion5x_wdt_disable();
 	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
@@ -230,7 +249,7 @@ static int __devinit orion5x_wdt_probe(struct platform_device *pdev)
 	orion5x_wdt_miscdev.parent = &pdev->dev;
 
 	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
-	if (heartbeat <= 0 || heartbeat > wdt_max_duration)
+	if (orion5x_wdt_settimeout(heartbeat))
 		heartbeat = wdt_max_duration;
 
 	ret = misc_register(&orion5x_wdt_miscdev);
@@ -247,7 +266,7 @@ static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
 	int ret;
 
 	if (test_bit(WDT_IN_USE, &wdt_status)) {
-		wdt_disable();
+		orion5x_wdt_disable();
 		clear_bit(WDT_IN_USE, &wdt_status);
 	}
 
@@ -258,9 +277,16 @@ static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
 	return ret;
 }
 
+static void orion5x_wdt_shutdown(struct platform_device *pdev)
+{
+	if (test_bit(WDT_IN_USE, &wdt_status))
+		orion5x_wdt_disable();
+}
+
 static struct platform_driver orion5x_wdt_driver = {
 	.probe		= orion5x_wdt_probe,
 	.remove		= __devexit_p(orion5x_wdt_remove),
+	.shutdown	= orion5x_wdt_shutdown,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "orion5x_wdt",
@@ -285,10 +311,11 @@ MODULE_AUTHOR("Sylver Bruneau <sylver.bruneau@googlemail.com>");
 MODULE_DESCRIPTION("Orion5x Processor Watchdog");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds");
+MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

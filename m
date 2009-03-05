Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZCETaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZCETaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZCETaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:30:11 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:16692 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641AbZCETaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:30:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAH+3r0lR9THf/2dsb2JhbADYVgeEAQY
Date: Thu, 5 Mar 2009 20:30:04 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT-PULL] v2.6.29-rc watchdog fixes
Message-ID: <20090305193004.GG6026@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

 drivers/watchdog/gef_wdt.c     |    2 
 drivers/watchdog/ks8695_wdt.c  |    1 
 drivers/watchdog/orion5x_wdt.c |    1 
 drivers/watchdog/rc32434_wdt.c |  168 ++++++++++++++++-------------------------
 4 files changed, 72 insertions(+), 100 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Feb 25 13:33:01 2009 +0100

    [WATCHDOG] orion5x_wdt.c: 'ORION5X_TCLK' undeclared
    
    orion5x_wdt no longer compiled after the changes in commit
    ebe35aff883496c07248df82c8576c3b6e84bbbe ("Orion: prepare for
    runtime-determined timer tick rate").
    
    The tick rate define (ORION5X_TCLK) was removed in favor of a runtime
    detection. The quick fix is to add the define in the watchdog driver.
    The fix is not correct for all supported orion5x platforms, but since
    the supported platforms right now are 133 Mhz and 166 Mhz, it won't
    be _that_ far off. ;-) A fix that uses the runtime-determined timer
    tick rate will be applied later.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Kristof Provost <kristof@sigsegv.be>
    Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
    Cc: Nicolas Pitre <nico@cam.org>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Mar 3 15:10:05 2009 +0100

    [WATCHDOG] gef_wdt.c: fsl_get_sys_freq() failure not noticed
    
    fsl_get_sys_freq() may return -1 when 'soc' isn't found, but in
    gef_wdt_probe() 'freq' is unsigned, so the test doesn't catch that.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Feb 12 13:42:41 2009 +0300

    [WATCHDOG] ks8695_wdt.c: 'CLOCK_TICK_RATE' undeclared
    
    On arm-acs5k_tiny:
    
    drivers/watchdog/ks8695_wdt.c:68: error: 'CLOCK_TICK_RATE' undeclared
    	(first use in this function)
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: Phil Sutter <n0-1@freewrt.org>
Date:   Sun Feb 8 16:44:42 2009 +0100

    [WATCHDOG] rc32434_wdt: fix sections
    
    Fix init and exit sections.
    
    Signed-off-by: Phil Sutter <n0-1@freewrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: Phil Sutter <n0-1@freewrt.org>
Date:   Sun Feb 8 16:44:42 2009 +0100

    [WATCHDOG] rc32434_wdt: fix watchdog driver
    
    The existing driver code wasn't working. Neither the timeout was set
    correctly, nor system reset was being triggered, as the driver seemed
    to keep the WDT alive himself. There was also some unnecessary code.
    
    Signed-off-by: Phil Sutter <n0-1@freewrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index f0c2b7a..734d980 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -269,7 +269,7 @@ static int __devinit gef_wdt_probe(struct of_device *dev,
 	bus_clk = 133; /* in MHz */
 
 	freq = fsl_get_sys_freq();
-	if (freq > 0)
+	if (freq != -1)
 		bus_clk = freq;
 
 	/* Map devices registers into memory */
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 0b798fd..74c92d3 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -21,6 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <mach/timex.h>
 #include <mach/regs-timer.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
diff --git a/drivers/watchdog/orion5x_wdt.c b/drivers/watchdog/orion5x_wdt.c
index 14a339f..b64ae1a 100644
--- a/drivers/watchdog/orion5x_wdt.c
+++ b/drivers/watchdog/orion5x_wdt.c
@@ -29,6 +29,7 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
+#define ORION5X_TCLK		166666667
 #define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index 57027f4..f3553fa 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -34,104 +34,89 @@
 #include <asm/time.h>
 #include <asm/mach-rc32434/integ.h>
 
-#define MAX_TIMEOUT			20
-#define RC32434_WDT_INTERVAL		(15 * HZ)
-
-#define VERSION "0.2"
+#define VERSION "0.4"
 
 static struct {
-	struct completion stop;
-	int running;
-	struct timer_list timer;
-	int queue;
-	int default_ticks;
 	unsigned long inuse;
 } rc32434_wdt_device;
 
 static struct integ __iomem *wdt_reg;
-static int ticks = 100 * HZ;
 
 static int expect_close;
-static int timeout;
+
+/* Board internal clock speed in Hz,
+ * the watchdog timer ticks at. */
+extern unsigned int idt_cpu_freq;
+
+/* translate wtcompare value to seconds and vice versa */
+#define WTCOMP2SEC(x)	(x / idt_cpu_freq)
+#define SEC2WTCOMP(x)	(x * idt_cpu_freq)
+
+/* Use a default timeout of 20s. This should be
+ * safe for CPU clock speeds up to 400MHz, as
+ * ((2 ^ 32) - 1) / (400MHz / 2) = 21s.  */
+#define WATCHDOG_TIMEOUT 20
+
+static int timeout = WATCHDOG_TIMEOUT;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+/* apply or and nand masks to data read from addr and write back */
+#define SET_BITS(addr, or, nand) \
+	writel((readl(&addr) | or) & ~nand, &addr)
 
 static void rc32434_wdt_start(void)
 {
-	u32 val;
-
-	if (!rc32434_wdt_device.inuse) {
-		writel(0, &wdt_reg->wtcount);
+	u32 or, nand;
 
-		val = RC32434_ERR_WRE;
-		writel(readl(&wdt_reg->errcs) | val, &wdt_reg->errcs);
+	/* zero the counter before enabling */
+	writel(0, &wdt_reg->wtcount);
 
-		val = RC32434_WTC_EN;
-		writel(readl(&wdt_reg->wtc) | val, &wdt_reg->wtc);
-	}
-	rc32434_wdt_device.running++;
-}
+	/* don't generate a non-maskable interrupt,
+	 * do a warm reset instead */
+	nand = 1 << RC32434_ERR_WNE;
+	or = 1 << RC32434_ERR_WRE;
 
-static void rc32434_wdt_stop(void)
-{
-	u32 val;
+	/* reset the ERRCS timeout bit in case it's set */
+	nand |= 1 << RC32434_ERR_WTO;
 
-	if (rc32434_wdt_device.running) {
+	SET_BITS(wdt_reg->errcs, or, nand);
 
-		val = ~RC32434_WTC_EN;
-		writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
+	/* reset WTC timeout bit and enable WDT */
+	nand = 1 << RC32434_WTC_TO;
+	or = 1 << RC32434_WTC_EN;
 
-		val = ~RC32434_ERR_WRE;
-		writel(readl(&wdt_reg->errcs) & val, &wdt_reg->errcs);
+	SET_BITS(wdt_reg->wtc, or, nand);
+}
 
-		rc32434_wdt_device.running = 0;
-	}
+static void rc32434_wdt_stop(void)
+{
+	/* Disable WDT */
+	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
 }
 
-static void rc32434_wdt_set(int new_timeout)
+static int rc32434_wdt_set(int new_timeout)
 {
-	u32 cmp = new_timeout * HZ;
-	u32 state, val;
+	int max_to = WTCOMP2SEC((u32)-1);
 
+	if (new_timeout < 0 || new_timeout > max_to) {
+		printk(KERN_ERR KBUILD_MODNAME
+			": timeout value must be between 0 and %d",
+			max_to);
+		return -EINVAL;
+	}
 	timeout = new_timeout;
-	/*
-	 * store and disable WTC
-	 */
-	state = (u32)(readl(&wdt_reg->wtc) & RC32434_WTC_EN);
-	val = ~RC32434_WTC_EN;
-	writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
-
-	writel(0, &wdt_reg->wtcount);
-	writel(cmp, &wdt_reg->wtcompare);
-
-	/*
-	 * restore WTC
-	 */
-
-	writel(readl(&wdt_reg->wtc) | state, &wdt_reg);
-}
+	writel(SEC2WTCOMP(timeout), &wdt_reg->wtcompare);
 
-static void rc32434_wdt_reset(void)
-{
-	ticks = rc32434_wdt_device.default_ticks;
+	return 0;
 }
 
-static void rc32434_wdt_update(unsigned long unused)
+static void rc32434_wdt_ping(void)
 {
-	if (rc32434_wdt_device.running)
-		ticks--;
-
 	writel(0, &wdt_reg->wtcount);
-
-	if (rc32434_wdt_device.queue && ticks)
-		mod_timer(&rc32434_wdt_device.timer,
-			jiffies + RC32434_WDT_INTERVAL);
-	else
-		complete(&rc32434_wdt_device.stop);
 }
 
 static int rc32434_wdt_open(struct inode *inode, struct file *file)
@@ -142,19 +127,23 @@ static int rc32434_wdt_open(struct inode *inode, struct file *file)
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
+	rc32434_wdt_start();
+	rc32434_wdt_ping();
+
 	return nonseekable_open(inode, file);
 }
 
 static int rc32434_wdt_release(struct inode *inode, struct file *file)
 {
-	if (expect_close && nowayout == 0) {
+	if (expect_close == 42) {
 		rc32434_wdt_stop();
 		printk(KERN_INFO KBUILD_MODNAME ": disabling watchdog timer\n");
 		module_put(THIS_MODULE);
-	} else
+	} else {
 		printk(KERN_CRIT KBUILD_MODNAME
 			": device closed unexpectedly. WDT will not stop !\n");
-
+		rc32434_wdt_ping();
+	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
 	return 0;
 }
@@ -174,10 +163,10 @@ static ssize_t rc32434_wdt_write(struct file *file, const char *data,
 				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
-					expect_close = 1;
+					expect_close = 42;
 			}
 		}
-		rc32434_wdt_update(0);
+		rc32434_wdt_ping();
 		return len;
 	}
 	return 0;
@@ -197,11 +186,11 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 	};
 	switch (cmd) {
 	case WDIOC_KEEPALIVE:
-		rc32434_wdt_reset();
+		rc32434_wdt_ping();
 		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		value = readl(&wdt_reg->wtcount);
+		value = 0;
 		if (copy_to_user(argp, &value, sizeof(int)))
 			return -EFAULT;
 		break;
@@ -218,6 +207,7 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 			break;
 		case WDIOS_DISABLECARD:
 			rc32434_wdt_stop();
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -225,11 +215,9 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_SETTIMEOUT:
 		if (copy_from_user(&new_timeout, argp, sizeof(int)))
 			return -EFAULT;
-		if (new_timeout < 1)
+		if (rc32434_wdt_set(new_timeout))
 			return -EINVAL;
-		if (new_timeout > MAX_TIMEOUT)
-			return -EINVAL;
-		rc32434_wdt_set(new_timeout);
+		/* Fall through */
 	case WDIOC_GETTIMEOUT:
 		return copy_to_user(argp, &timeout, sizeof(int));
 	default:
@@ -254,15 +242,15 @@ static struct miscdevice rc32434_wdt_miscdev = {
 	.fops	= &rc32434_wdt_fops,
 };
 
-static char banner[] = KERN_INFO KBUILD_MODNAME
+static char banner[] __devinitdata = KERN_INFO KBUILD_MODNAME
 		": Watchdog Timer version " VERSION ", timer margin: %d sec\n";
 
-static int rc32434_wdt_probe(struct platform_device *pdev)
+static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb500_wdt_res");
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
 		printk(KERN_ERR KBUILD_MODNAME
 			"failed to retrieve resources\n");
@@ -277,24 +265,12 @@ static int rc32434_wdt_probe(struct platform_device *pdev)
 	}
 
 	ret = misc_register(&rc32434_wdt_miscdev);
-
 	if (ret < 0) {
 		printk(KERN_ERR KBUILD_MODNAME
 			"failed to register watchdog device\n");
 		goto unmap;
 	}
 
-	init_completion(&rc32434_wdt_device.stop);
-	rc32434_wdt_device.queue = 0;
-
-	clear_bit(0, &rc32434_wdt_device.inuse);
-
-	setup_timer(&rc32434_wdt_device.timer, rc32434_wdt_update, 0L);
-
-	rc32434_wdt_device.default_ticks = ticks;
-
-	rc32434_wdt_start();
-
 	printk(banner, timeout);
 
 	return 0;
@@ -304,23 +280,17 @@ unmap:
 	return ret;
 }
 
-static int rc32434_wdt_remove(struct platform_device *pdev)
+static int __devexit rc32434_wdt_remove(struct platform_device *pdev)
 {
-	if (rc32434_wdt_device.queue) {
-		rc32434_wdt_device.queue = 0;
-		wait_for_completion(&rc32434_wdt_device.stop);
-	}
 	misc_deregister(&rc32434_wdt_miscdev);
-
 	iounmap(wdt_reg);
-
 	return 0;
 }
 
 static struct platform_driver rc32434_wdt = {
 	.probe	= rc32434_wdt_probe,
-	.remove = rc32434_wdt_remove,
-	.driver = {
+	.remove	= __devexit_p(rc32434_wdt_remove),
+	.driver	= {
 		.name = "rc32434_wdt",
 	}
 };

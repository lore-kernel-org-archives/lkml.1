Return-Path: <linux-kernel-owner+w=401wt.eu-S2992826AbXBIUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992826AbXBIUpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992828AbXBIUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:45:19 -0500
Received: from outmx024.isp.belgacom.be ([195.238.4.128]:55510 "EHLO
	outmx024.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992826AbXBIUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:45:16 -0500
Date: Fri, 9 Feb 2007 21:45:23 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] v2.6.20 watchdog patches
Message-ID: <20070209204523.GB2510@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/char/watchdog/pcwd.c        |   26 ++++++++++++---
 drivers/char/watchdog/pcwd_pci.c    |   32 +++++++++++++++---
 drivers/char/watchdog/pcwd_usb.c    |   61 ++++++++++++++++++++++--------------
 drivers/char/watchdog/pnx4008_wdt.c |    3 +
 drivers/char/watchdog/s3c2410_wdt.c |   60 ++++++++++++++++++++---------------
 5 files changed, 123 insertions(+), 59 deletions(-)

with these Changes:

Merge: 62d0cfc... f3dc073...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Feb 9 21:35:36 2007 +0100

    Merge ../linux-2.6-watchdog-mm

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jan 9 22:43:49 2007 +0100

    [WATCHDOG] pcwd_usb.c - get heartbeat from dip switches
    
    The PCWD cards normally use the heartbeat that is set via
    the dip-switches of the card. There are only 3 switches,
    thus 8 combinations that each have a certain heartbeat.
    The card can however be programmed with a heartbeat from
    1 till 65535 seconds. This is what our driver does: it
    programs the heartbeat on the card.
    
    There are however a lot of people that don't know that
    we set the heartbeat of the watchdog card to the value
    provided by the heartbeat module parameter. Instead they
    think that the heartbeat value is the same as set by the
    dip-switches.
    
    This patch changes the driver so that at startup you can
    take the heartbeat from the dip-switches. You do this
    by setting the heartbeat module parameter to 0. This
    patch also makes this the default behaviour.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jan 9 22:38:54 2007 +0100

    [WATCHDOG] pcwd.c - e-mail adres update
    
    update Simon Machell's e-mail adres
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jan 8 22:45:30 2007 +0100

    [WATCHDOG] pcwd_usb.c - get heartbeat from dip switches
    
    The PCWD cards normally use the heartbeat that is set via
    the dip-switches of the card. There are only 3 switches,
    thus 8 combinations that each have a certain heartbeat.
    The card can however be programmed with a heartbeat from
    1 till 65535 seconds. This is what our driver does: it
    programs the heartbeat on the card.
    
    There are however a lot of people that don't know that
    we set the heartbeat of the watchdog card to the value
    provided by the heartbeat module parameter. Instead they
    think that the heartbeat value is the same as set by the
    dip-switches.
    
    This patch changes the driver so that at startup you can
    take the heartbeat from the dip-switches. You do this
    by setting the heartbeat module parameter to 0. This
    patch also makes this the default behaviour.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jan 8 22:40:33 2007 +0100

    [WATCHDOG] pcwd_usb.c - document includes
    
    document and review the include files.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jan 7 21:57:03 2007 +0100

    [WATCHDOG] pcwd_pci.c - spinlock fixes
    
    the keepalive and get_temperature functions should
    use spinlocks also.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jan 7 21:49:11 2007 +0100

    [WATCHDOG] pcwd_pci.c - get heartbeat from dip switches
    
    The PCWD cards normally use the heartbeat that is set via
    the dip-switches of the card. There are only 3 switches,
    thus 8 combinations that each have a certain heartbeat.
    The card can however be programmed with a heartbeat from
    1 till 65535 seconds. This is what our driver does: it
    programs the heartbeat on the card.
    
    There are however a lot of people that don't know that
    we set the heartbeat of the watchdog card to the value
    provided by the heartbeat module parameter. Instead they
    think that the heartbeat value is the same as set by the
    dip-switches.
    
    This patch changes the driver so that at startup you can
    take the heartbeat from the dip-switches. You do this
    by setting the heartbeat module parameter to 0. This
    patch also makes this the default behaviour.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue Dec 19 17:51:44 2006 +0900

    [WATCHDOG] fix clk_get() error check
    
    The return value of clk_get() should be checked by IS_ERR().
    
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Mon Dec 18 10:31:32 2006 +0000

    [WATCHDOG] s3c2410_wdt exit driver via labels
    
    Cleanup the s3c2410_wdt driver's exit point by
    using labels instead of multiple returns. Also
    remove the checks for the resources having been
    allocate in the exit, as we will now either have
    fully allocated or not allocated the resources
    at-all.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/watchdog/pcwd.c b/drivers/char/watchdog/pcwd.c
index 8e1e6e4..aab6621 100644
--- a/drivers/char/watchdog/pcwd.c
+++ b/drivers/char/watchdog/pcwd.c
@@ -2,7 +2,7 @@
  * PC Watchdog Driver
  * by Ken Hollis (khollis@bitgate.com)
  *
- * Permission granted from Simon Machell (73244.1270@compuserve.com)
+ * Permission granted from Simon Machell (smachell@berkprod.com)
  * Written for the Linux Kernel, and GPLed by Ken Hollis
  *
  * 960107	Added request_region routines, modulized the whole thing.
@@ -70,8 +70,8 @@ #include <asm/uaccess.h>	/* For copy_to_
 #include <asm/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
-#define WATCHDOG_VERSION "1.17"
-#define WATCHDOG_DATE "12 Feb 2006"
+#define WATCHDOG_VERSION "1.18"
+#define WATCHDOG_DATE "06 Jan 2007"
 #define WATCHDOG_DRIVER_NAME "ISA-PC Watchdog"
 #define WATCHDOG_NAME "pcwd"
 #define PFX WATCHDOG_NAME ": "
@@ -132,6 +132,18 @@ #define CMD_ISA_DELAY_TIME_4SECS	0x0B
 #define CMD_ISA_DELAY_TIME_8SECS	0x0C
 #define CMD_ISA_RESET_RELAYS		0x0D
 
+/* Watchdog's Dip Switch heartbeat values */
+static const int heartbeat_tbl [] = {
+	20,	/* OFF-OFF-OFF	= 20 Sec  */
+	40,	/* OFF-OFF-ON	= 40 Sec  */
+	60,	/* OFF-ON-OFF	=  1 Min  */
+	300,	/* OFF-ON-ON	=  5 Min  */
+	600,	/* ON-OFF-OFF	= 10 Min  */
+	1800,	/* ON-OFF-ON	= 30 Min  */
+	3600,	/* ON-ON-OFF	=  1 Hour */
+	7200,	/* ON-ON-ON	=  2 hour */
+};
+
 /*
  * We are using an kernel timer to do the pinging of the watchdog
  * every ~500ms. We try to set the internal heartbeat of the
@@ -167,10 +179,10 @@ static int debug = QUIET;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
 
-#define WATCHDOG_HEARTBEAT 60		/* 60 sec default heartbeat */
+#define WATCHDOG_HEARTBEAT 0		/* default heartbeat = delay-time from dip-switches */
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<=heartbeat<=7200, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<=heartbeat<=7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -844,6 +856,10 @@ static int __devinit pcwatchdog_init(int
 	/* Show info about the card itself */
 	pcwd_show_card_info();
 
+	/* If heartbeat = 0 then we use the heartbeat from the dip-switches */
+	if (heartbeat == 0)
+		heartbeat = heartbeat_tbl[(pcwd_get_option_switches() & 0x07)];
+
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
diff --git a/drivers/char/watchdog/pcwd_pci.c b/drivers/char/watchdog/pcwd_pci.c
index f4872c8..95ddcd8 100644
--- a/drivers/char/watchdog/pcwd_pci.c
+++ b/drivers/char/watchdog/pcwd_pci.c
@@ -1,7 +1,7 @@
 /*
  *	Berkshire PCI-PC Watchdog Card Driver
  *
- *	(c) Copyright 2003-2005 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2003-2007 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
@@ -51,8 +51,8 @@ #include <asm/uaccess.h>	/* For copy_to_
 #include <asm/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
-#define WATCHDOG_VERSION "1.02"
-#define WATCHDOG_DATE "03 Sep 2005"
+#define WATCHDOG_VERSION "1.03"
+#define WATCHDOG_DATE "06 Jan 2007"
 #define WATCHDOG_DRIVER_NAME "PCI-PC Watchdog"
 #define WATCHDOG_NAME "pcwd_pci"
 #define PFX WATCHDOG_NAME ": "
@@ -96,6 +96,18 @@ #define CMD_READ_WATCHDOG_TIMEOUT		0x18
 #define CMD_WRITE_WATCHDOG_TIMEOUT		0x19
 #define CMD_GET_CLEAR_RESET_COUNT		0x84
 
+/* Watchdog's Dip Switch heartbeat values */
+static const int heartbeat_tbl [] = {
+	5,	/* OFF-OFF-OFF	=  5 Sec  */
+	10,	/* OFF-OFF-ON	= 10 Sec  */
+	30,	/* OFF-ON-OFF	= 30 Sec  */
+	60,	/* OFF-ON-ON	=  1 Min  */
+	300,	/* ON-OFF-OFF	=  5 Min  */
+	600,	/* ON-OFF-ON	= 10 Min  */
+	1800,	/* ON-ON-OFF	= 30 Min  */
+	3600,	/* ON-ON-ON	=  1 hour */
+};
+
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int cards_found;
 
@@ -119,10 +131,10 @@ static int debug = QUIET;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
 
-#define WATCHDOG_HEARTBEAT 2	/* 2 sec default heartbeat */
+#define WATCHDOG_HEARTBEAT 0	/* default heartbeat = delay-time from dip-switches */
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -286,7 +298,9 @@ static int pcipcwd_stop(void)
 static int pcipcwd_keepalive(void)
 {
 	/* Re-trigger watchdog by writing to port 0 */
+	spin_lock(&pcipcwd_private.io_lock);
 	outb_p(0x42, pcipcwd_private.io_addr);	/* send out any data */
+	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (debug >= DEBUG)
 		printk(KERN_DEBUG PFX "Watchdog keepalive signal send\n");
@@ -373,7 +387,9 @@ static int pcipcwd_get_temperature(int *
 	if (!pcipcwd_private.supports_temp)
 		return -ENODEV;
 
+	spin_lock(&pcipcwd_private.io_lock);
 	*temperature = inb_p(pcipcwd_private.io_addr);
+	spin_unlock(&pcipcwd_private.io_lock);
 
 	/*
 	 * Convert celsius to fahrenheit, since this was
@@ -711,6 +727,10 @@ static int __devinit pcipcwd_card_init(s
 	/* Show info about the card itself */
 	pcipcwd_show_card_info();
 
+	/* If heartbeat = 0 then we use the heartbeat from the dip-switches */
+	if (heartbeat == 0)
+		heartbeat = heartbeat_tbl[(pcipcwd_get_option_switches() & 0x07)];
+
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (pcipcwd_set_heartbeat(heartbeat)) {
 		pcipcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
@@ -798,6 +818,8 @@ static int __init pcipcwd_init_module(vo
 static void __exit pcipcwd_cleanup_module(void)
 {
 	pci_unregister_driver(&pcipcwd_driver);
+
+	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(pcipcwd_init_module);
diff --git a/drivers/char/watchdog/pcwd_usb.c b/drivers/char/watchdog/pcwd_usb.c
index 2da5ac9..1ad1f22 100644
--- a/drivers/char/watchdog/pcwd_usb.c
+++ b/drivers/char/watchdog/pcwd_usb.c
@@ -1,7 +1,7 @@
 /*
  *	Berkshire USB-PC Watchdog Card Driver
  *
- *	(c) Copyright 2004 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2004-2007 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	Based on source code of the following authors:
  *	  Ken Hollis <kenji@bitgate.com>,
@@ -24,26 +24,25 @@
  *	http://www.berkprod.com/ or http://www.pcwatchdog.com/
  */
 
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/delay.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/fs.h>
-#include <linux/smp_lock.h>
-#include <linux/completion.h>
-#include <asm/uaccess.h>
-#include <linux/usb.h>
-#include <linux/mutex.h>
+#include <linux/module.h>	/* For module specific items */
+#include <linux/moduleparam.h>	/* For new moduleparam's */
+#include <linux/types.h>	/* For standard types (like size_t) */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/delay.h>	/* For mdelay function */
+#include <linux/miscdevice.h>	/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/watchdog.h>	/* For the watchdog specific items */
+#include <linux/notifier.h>	/* For notifier support */
+#include <linux/reboot.h>	/* For reboot_notifier stuff */
+#include <linux/init.h>		/* For __init/__exit/... */
+#include <linux/fs.h>		/* For file operations */
+#include <linux/usb.h>		/* For USB functions */
+#include <linux/slab.h>		/* For kmalloc, ... */
+#include <linux/mutex.h>	/* For mutex locking */
 #include <linux/hid.h>		/* For HID_REQ_SET_REPORT & HID_DT_REPORT */
 
+#include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
+
 
 #ifdef CONFIG_USB_DEBUG
 	static int debug = 1;
@@ -57,8 +56,8 @@ #define dbg(format, arg...) do { if (deb
 
 
 /* Module and Version Information */
-#define DRIVER_VERSION "1.01"
-#define DRIVER_DATE "15 Mar 2005"
+#define DRIVER_VERSION "1.02"
+#define DRIVER_DATE "06 Jan 2007"
 #define DRIVER_AUTHOR "Wim Van Sebroeck <wim@iguana.be>"
 #define DRIVER_DESC "Berkshire USB-PC Watchdog driver"
 #define DRIVER_LICENSE "GPL"
@@ -75,10 +74,10 @@ MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
-#define WATCHDOG_HEARTBEAT 2	/* 2 sec default heartbeat */
+#define WATCHDOG_HEARTBEAT 0	/* default heartbeat = delay-time from dip-switches */
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -110,6 +109,18 @@ #define CMD_WRITE_WATCHDOG_TIMEOUT	0x19	
 #define CMD_ENABLE_WATCHDOG		0x30	/* Enable / Disable Watchdog */
 #define CMD_DISABLE_WATCHDOG		CMD_ENABLE_WATCHDOG
 
+/* Watchdog's Dip Switch heartbeat values */
+static const int heartbeat_tbl [] = {
+	5,	/* OFF-OFF-OFF	=  5 Sec  */
+	10,	/* OFF-OFF-ON	= 10 Sec  */
+	30,	/* OFF-ON-OFF	= 30 Sec  */
+	60,	/* OFF-ON-ON	=  1 Min  */
+	300,	/* ON-OFF-OFF	=  5 Min  */
+	600,	/* ON-OFF-ON	= 10 Min  */
+	1800,	/* ON-ON-OFF	= 30 Min  */
+	3600,	/* ON-ON-ON	=  1 hour */
+};
+
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int cards_found;
 
@@ -682,6 +693,10 @@ static int usb_pcwd_probe(struct usb_int
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
 
+	/* If heartbeat = 0 then we use the heartbeat from the dip-switches */
+	if (heartbeat == 0)
+		heartbeat = heartbeat_tbl[(option_switches & 0x07)];
+
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (usb_pcwd_set_heartbeat(usb_pcwd, heartbeat)) {
 		usb_pcwd_set_heartbeat(usb_pcwd, WATCHDOG_HEARTBEAT);
diff --git a/drivers/char/watchdog/pnx4008_wdt.c b/drivers/char/watchdog/pnx4008_wdt.c
index 3a55fc6..0e3d589 100644
--- a/drivers/char/watchdog/pnx4008_wdt.c
+++ b/drivers/char/watchdog/pnx4008_wdt.c
@@ -283,7 +283,8 @@ static int pnx4008_wdt_probe(struct plat
 	wdt_base = (void __iomem *)IO_ADDRESS(res->start);
 
 	wdt_clk = clk_get(&pdev->dev, "wdt_ck");
-	if (!wdt_clk) {
+	if (IS_ERR(wdt_clk)) {
+		ret = PTR_ERR(wdt_clk);
 		release_resource(wdt_mem);
 		kfree(wdt_mem);
 		goto out;
diff --git a/drivers/char/watchdog/s3c2410_wdt.c b/drivers/char/watchdog/s3c2410_wdt.c
index 18cb050..5a5cc2a 100644
--- a/drivers/char/watchdog/s3c2410_wdt.c
+++ b/drivers/char/watchdog/s3c2410_wdt.c
@@ -366,13 +366,15 @@ static int s3c2410wdt_probe(struct platf
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		printk(KERN_INFO PFX "failed to get memory region\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err_req;
 	}
 
 	wdt_base = ioremap(res->start, size);
 	if (wdt_base == 0) {
 		printk(KERN_INFO PFX "failed to ioremap() region\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_req;
 	}
 
 	DBG("probe: mapped wdt_base=%p\n", wdt_base);
@@ -380,22 +382,21 @@ static int s3c2410wdt_probe(struct platf
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
 		printk(KERN_INFO PFX "failed to get irq resource\n");
-		iounmap(wdt_base);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err_map;
 	}
 
 	ret = request_irq(res->start, s3c2410wdt_irq, 0, pdev->name, pdev);
 	if (ret != 0) {
 		printk(KERN_INFO PFX "failed to install irq (%d)\n", ret);
-		iounmap(wdt_base);
-		return ret;
+		goto err_map;
 	}
 
 	wdt_clock = clk_get(&pdev->dev, "watchdog");
-	if (wdt_clock == NULL) {
+	if (IS_ERR(wdt_clock)) {
 		printk(KERN_INFO PFX "failed to find watchdog clock source\n");
-		iounmap(wdt_base);
-		return -ENOENT;
+		ret = PTR_ERR(wdt_clock);
+		goto err_irq;
 	}
 
 	clk_enable(wdt_clock);
@@ -418,8 +419,7 @@ static int s3c2410wdt_probe(struct platf
 	if (ret) {
 		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
-		iounmap(wdt_base);
-		return ret;
+		goto err_clk;
 	}
 
 	if (tmr_atboot && started == 0) {
@@ -434,26 +434,36 @@ static int s3c2410wdt_probe(struct platf
 	}
 
 	return 0;
+
+ err_clk:
+	clk_disable(wdt_clock);
+	clk_put(wdt_clock);
+
+ err_irq:
+	free_irq(wdt_irq->start, pdev);
+
+ err_map:
+	iounmap(wdt_base);
+
+ err_req:
+	release_resource(wdt_mem);
+	kfree(wdt_mem);
+
+	return ret;
 }
 
 static int s3c2410wdt_remove(struct platform_device *dev)
 {
-	if (wdt_mem != NULL) {
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
-		wdt_mem = NULL;
-	}
+	release_resource(wdt_mem);
+	kfree(wdt_mem);
+	wdt_mem = NULL;
 
-	if (wdt_irq != NULL) {
-		free_irq(wdt_irq->start, dev);
-		wdt_irq = NULL;
-	}
+	free_irq(wdt_irq->start, dev);
+	wdt_irq = NULL;
 
-	if (wdt_clock != NULL) {
-		clk_disable(wdt_clock);
-		clk_put(wdt_clock);
-		wdt_clock = NULL;
-	}
+	clk_disable(wdt_clock);
+	clk_put(wdt_clock);
+	wdt_clock = NULL;
 
 	iounmap(wdt_base);
 	misc_deregister(&s3c2410wdt_miscdev);

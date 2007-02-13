Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369AbXBMWck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbXBMWck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXBMWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:32:40 -0500
Received: from outmx006.isp.belgacom.be ([195.238.4.99]:60623 "EHLO
	outmx006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXBMWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:32:36 -0500
Date: Tue, 13 Feb 2007 23:32:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] v2.6.20 patches
Message-ID: <20070213223247.GA4262@infomag.infomag.iguana.be>
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

 drivers/char/watchdog/acquirewdt.c     |  155 +++++++++++++++-----------
 drivers/char/watchdog/advantechwdt.c   |  142 +++++++++++++++---------
 drivers/char/watchdog/alim1535_wdt.c   |    2 
 drivers/char/watchdog/alim7101_wdt.c   |   15 --
 drivers/char/watchdog/cpu5wdt.c        |   13 --
 drivers/char/watchdog/eurotechwdt.c    |    2 
 drivers/char/watchdog/i6300esb.c       |    2 
 drivers/char/watchdog/i8xx_tco.c       |    2 
 drivers/char/watchdog/iTCO_wdt.c       |    6 -
 drivers/char/watchdog/ib700wdt.c       |  192 +++++++++++++++++++++------------
 drivers/char/watchdog/ibmasr.c         |    2 
 drivers/char/watchdog/indydog.c        |    2 
 drivers/char/watchdog/machzwd.c        |   18 +--
 drivers/char/watchdog/mixcomwd.c       |   16 +-
 drivers/char/watchdog/pc87413_wdt.c    |    2 
 drivers/char/watchdog/pcwd.c           |   32 +++--
 drivers/char/watchdog/pcwd_pci.c       |   34 ++++-
 drivers/char/watchdog/pcwd_usb.c       |   63 ++++++----
 drivers/char/watchdog/pnx4008_wdt.c    |    3 
 drivers/char/watchdog/s3c2410_wdt.c    |   62 ++++++----
 drivers/char/watchdog/sbc60xxwdt.c     |   14 --
 drivers/char/watchdog/sbc8360.c        |    2 
 drivers/char/watchdog/sbc_epx_c3.c     |    2 
 drivers/char/watchdog/sc1200wdt.c      |    2 
 drivers/char/watchdog/sc520_wdt.c      |   14 --
 drivers/char/watchdog/shwdt.c          |    8 -
 drivers/char/watchdog/smsc37b787_wdt.c |    2 
 drivers/char/watchdog/softdog.c        |    2 
 drivers/char/watchdog/w83627hf_wdt.c   |    2 
 drivers/char/watchdog/w83697hf_wdt.c   |    2 
 drivers/char/watchdog/w83877f_wdt.c    |   14 --
 drivers/char/watchdog/w83977f_wdt.c    |    2 
 drivers/char/watchdog/wafer5823wdt.c   |    2 
 drivers/char/watchdog/wdt.c            |    2 
 drivers/char/watchdog/wdt977.c         |    2 
 drivers/char/watchdog/wdt_pci.c        |    2 
 36 files changed, 489 insertions(+), 350 deletions(-)

with these Changes:

Merge: 9af9fc4... 82eb7c5...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Feb 13 23:24:34 2007 +0100

    Merge ../linux-2.6-watchdog-mm

Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Thu Feb 8 18:39:36 2007 +0100

    [WATCHDOG] timers cleanup
    
    - Use timer macros to set function and data members and to modify
      expiration time.
    - Use DEFINE_TIMER for single (platform dependent) watchdog timers and
      do not init them at run-time in these cases.
    - del_timer_sync is common in most cases -- we want to wait for timer
      function if it's still running.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Cc: Steve Hill <steve@navaho.co.uk>
    Cc: Heiko Ronsdorf <hero@ihg.uni-duisburg.de>
    Cc: Fernando Fuganti <fuganti@conectiva.com.br>
    Cc: Gergely Madarasz <gorgo@itc.hu>
    Cc: Ken Hollis <khollis@bitgate.com>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Merge: 62d0cfc... f3dc073...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Feb 9 21:35:36 2007 +0100

    Merge ../linux-2.6-watchdog-mm

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 22:54:18 2007 +0100

    [WATCHDOG] ib700wdt.c - convert to platform_device part 2
    
    Convert the reboot_notifier into the platform_device's shutdown
    method
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 22:39:46 2007 +0100

    [WATCHDOG] ib700wdt.c - convert to platform_device
    
    Convert the ib700wdt watchdog into a platform_device
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 22:12:54 2007 +0100

    [WATCHDOG] ib700wdt.c spinlock/WDIOC_SETOPTIONS changes
    
    Add the WDIOC_SETOPTIONS ioctl call. Because of this we
    move the spinlocking to the different watchdog operations.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 22:07:03 2007 +0100

    [WATCHDOG] ib700wdt.c small clean-up's
    
    * Fix identation
    * Add watchdog "mandatory" WDIOC_GETBOOTSTATUS ioctl
    * On unexpected close -> since this is considered as
      a write to the watchdog device, make sure we ping a
      last time.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 21:58:08 2007 +0100

    [WATCHDOG] ib700wdt.c clean-up init and exit routines
    
    clean-up the init and exit routines so that they use
    the same sequence.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 21:50:53 2007 +0100

    [WATCHDOG] ib700_wdt.c stop + set_heartbeat operations
    
    move the code to stop the watchdog and the code to
    set the heartbeat of the watchdog to seperate functions.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jan 27 20:54:24 2007 +0100

    [WATCHDOG] show default value for nowayout in module parameter
    
    change default=CONFIG_WATCHDOG_NOWAYOUT in the module parameter
    for nowayout by it's real value (0 or 1) by using:
    __MODULE_STRING(WATCHDOG_NOWAYOUT)
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jan 11 22:42:41 2007 +0100

    [WATCHDOG] advantechwdt.c - convert to platform_device part 2
    
    Convert the reboot_notifier into the platform_device's shutdown
    method
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jan 11 22:35:40 2007 +0100

    [WATCHDOG] advantechwdt.c - convert to platform_device
    
    Convert the advantechwdt watchdog into a platform_device
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jan 11 22:27:51 2007 +0100

    [WATCHDOG] advantechwdt.c - move set_heartbeat to a seperate function
    
    Put the set_heartbeat/timeout code into a seperate function
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jan 11 22:19:28 2007 +0100

    [WATCHDOG] advantechwdt.c - cleanup before platform_device patches
    
    This cleanup consists of:
    - make sure that the printk's use the module/driver-name
    - do the exit of the module exactly the opposite of the init of the module
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jan 10 23:38:56 2007 +0100

    [WATCHDOG] acquirewdt.c - convert to platform_device part 2
    
    Convert the reboot_notifier into the platform_device's shutdown
    method
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jan 10 23:36:13 2007 +0100

    [WATCHDOG] acquirewdt.c - convert to platform_device
    
    Convert the acquirewdt watchdog into a platform_device
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jan 10 23:23:44 2007 +0100

    [WATCHDOG] acquirewdt.c - clean before platform_device patches
    
    Clean the current code before we convert the driver to a platform_device.
    This clean consists of:
    - document the includes
    - make sure that the printk's use the module/driver-name
    - do the exit of the module exactly the opposite of the init of the module
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

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
diff --git a/drivers/char/watchdog/acquirewdt.c b/drivers/char/watchdog/acquirewdt.c
index 154d67e..85269c3 100644
--- a/drivers/char/watchdog/acquirewdt.c
+++ b/drivers/char/watchdog/acquirewdt.c
@@ -48,46 +48,52 @@
  *		It can be 1, 2, 10, 20, 110 or 220 seconds.
  */
 
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/fs.h>
-#include <linux/ioport.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/system.h>
+/*
+ *	Includes, defines, variables, module parameters, ...
+ */
 
+/* Includes */
+#include <linux/module.h>		/* For module specific items */
+#include <linux/moduleparam.h>		/* For new moduleparam's */
+#include <linux/types.h>		/* For standard types (like size_t) */
+#include <linux/errno.h>		/* For the -ENODEV/... values */
+#include <linux/kernel.h>		/* For printk/panic/... */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/watchdog.h>		/* For the watchdog specific items */
+#include <linux/fs.h>			/* For file operations */
+#include <linux/ioport.h>		/* For io-port access */
+#include <linux/platform_device.h>	/* For platform_driver framework */
+#include <linux/init.h>			/* For __init/__exit/... */
+
+#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <asm/io.h>			/* For inb/outb/... */
+
+/* Module information */
+#define DRV_NAME "acquirewdt"
+#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_HEARTBEAT 0	/* There is no way to see what the correct time-out period is */
 
+/* internal variables */
+static struct platform_device *acq_platform_device;	/* the watchdog platform device */
 static unsigned long acq_is_open;
 static char expect_close;
 
-/*
- *	You must set these - there is no sane way to probe for this board.
- */
-
-static int wdt_stop = 0x43;
+/* module parameters */
+static int wdt_stop = 0x43;	/* You must set this - there is no sane way to probe for this board. */
 module_param(wdt_stop, int, 0);
 MODULE_PARM_DESC(wdt_stop, "Acquire WDT 'stop' io port (default 0x43)");
 
-static int wdt_start = 0x443;
+static int wdt_start = 0x443;	/* You must set this - there is no sane way to probe for this board. */
 module_param(wdt_start, int, 0);
 MODULE_PARM_DESC(wdt_start, "Acquire WDT 'start' io port (default 0x443)");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
- *	Kernel methods.
+ *	Watchdog Operations
  */
 
 static void acq_keepalive(void)
@@ -103,7 +109,7 @@ static void acq_stop(void)
 }
 
 /*
- *	/dev/watchdog handling.
+ *	/dev/watchdog handling
  */
 
 static ssize_t acq_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
@@ -143,7 +149,7 @@ static int acq_ioctl(struct inode *inode
 	{
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
-		.identity = "Acquire WDT",
+		.identity = WATCHDOG_NAME,
 	};
 
 	switch(cmd)
@@ -214,20 +220,6 @@ static int acq_close(struct inode *inode
 }
 
 /*
- *	Notifier for system down
- */
-
-static int acq_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if(code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		acq_stop();
-	}
-	return NOTIFY_DONE;
-}
-
-/*
  *	Kernel Interfaces
  */
 
@@ -240,29 +232,20 @@ static const struct file_operations acq_
 	.release	= acq_close,
 };
 
-static struct miscdevice acq_miscdev=
-{
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &acq_fops,
+static struct miscdevice acq_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &acq_fops,
 };
 
 /*
- *	The WDT card needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
+ *	Init & exit routines
  */
 
-static struct notifier_block acq_notifier =
-{
-	.notifier_call = acq_notify_sys,
-};
-
-static int __init acq_init(void)
+static int __devinit acq_probe(struct platform_device *dev)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for Acquire single board computer initialising.\n");
-
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
 			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
@@ -279,18 +262,11 @@ static int __init acq_init(void)
 		goto unreg_stop;
 	}
 
-	ret = register_reboot_notifier(&acq_notifier);
-	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		goto unreg_regions;
-	}
-
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
 		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		goto unreg_reboot;
+		goto unreg_regions;
 	}
 
 	printk (KERN_INFO PFX "initialized. (nowayout=%d)\n",
@@ -298,8 +274,6 @@ static int __init acq_init(void)
 
 	return 0;
 
-unreg_reboot:
-	unregister_reboot_notifier(&acq_notifier);
 unreg_regions:
 	release_region(wdt_start, 1);
 unreg_stop:
@@ -309,13 +283,60 @@ out:
 	return ret;
 }
 
-static void __exit acq_exit(void)
+static int __devexit acq_remove(struct platform_device *dev)
 {
 	misc_deregister(&acq_miscdev);
-	unregister_reboot_notifier(&acq_notifier);
+	release_region(wdt_start,1);
 	if(wdt_stop != wdt_start)
 		release_region(wdt_stop,1);
-	release_region(wdt_start,1);
+
+	return 0;
+}
+
+static void acq_shutdown(struct platform_device *dev)
+{
+	/* Turn the WDT off if we have a soft shutdown */
+	acq_stop();
+}
+
+static struct platform_driver acquirewdt_driver = {
+	.probe		= acq_probe,
+	.remove		= __devexit_p(acq_remove),
+	.shutdown	= acq_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init acq_init(void)
+{
+	int err;
+
+	printk(KERN_INFO "WDT driver for Acquire single board computer initialising.\n");
+
+	err = platform_driver_register(&acquirewdt_driver);
+	if (err)
+		return err;
+
+	acq_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(acq_platform_device)) {
+		err = PTR_ERR(acq_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&acquirewdt_driver);
+	return err;
+}
+
+static void __exit acq_exit(void)
+{
+	platform_device_unregister(acq_platform_device);
+	platform_driver_unregister(&acquirewdt_driver);
+	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(acq_init);
diff --git a/drivers/char/watchdog/advantechwdt.c b/drivers/char/watchdog/advantechwdt.c
index 9d73276..8121cc2 100644
--- a/drivers/char/watchdog/advantechwdt.c
+++ b/drivers/char/watchdog/advantechwdt.c
@@ -35,18 +35,19 @@ #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/fs.h>
 #include <linux/ioport.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
+#include <linux/platform_device.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
+#define DRV_NAME "advantechwdt"
+#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Advantech WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
+static struct platform_device *advwdt_platform_device;	/* the watchdog platform device */
 static unsigned long advwdt_is_open;
 static char adv_expect_close;
 
@@ -75,10 +76,10 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
- *	Kernel methods.
+ *	Watchdog Operations
  */
 
 static void
@@ -94,6 +95,20 @@ advwdt_disable(void)
 	inb_p(wdt_stop);
 }
 
+static int
+advwdt_set_heartbeat(int t)
+{
+	if ((t < 1) || (t > 63))
+		return -EINVAL;
+
+	timeout = t;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
 static ssize_t
 advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
@@ -126,7 +141,7 @@ advwdt_ioctl(struct inode *inode, struct
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
-		.identity = "Advantech WDT",
+		.identity = WATCHDOG_NAME,
 	};
 
 	switch (cmd) {
@@ -146,9 +161,8 @@ advwdt_ioctl(struct inode *inode, struct
 	case WDIOC_SETTIMEOUT:
 	  if (get_user(new_timeout, p))
 		  return -EFAULT;
-	  if ((new_timeout < 1) || (new_timeout > 63))
+	  if (advwdt_set_heartbeat(new_timeout))
 		  return -EINVAL;
-	  timeout = new_timeout;
 	  advwdt_ping();
 	  /* Fall */
 
@@ -209,21 +223,6 @@ advwdt_close(struct inode *inode, struct
 }
 
 /*
- *	Notifier for system down
- */
-
-static int
-advwdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
-		advwdt_disable();
-	}
-	return NOTIFY_DONE;
-}
-
-/*
  *	Kernel Interfaces
  */
 
@@ -237,33 +236,20 @@ static const struct file_operations advw
 };
 
 static struct miscdevice advwdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &advwdt_fops,
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &advwdt_fops,
 };
 
 /*
- *	The WDT needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
+ *	Init & exit routines
  */
 
-static struct notifier_block advwdt_notifier = {
-	.notifier_call = advwdt_notify_sys,
-};
-
-static int __init
-advwdt_init(void)
+static int __devinit
+advwdt_probe(struct platform_device *dev)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for Advantech single board computer initialising.\n");
-
-	if (timeout < 1 || timeout > 63) {
-		timeout = WATCHDOG_TIMEOUT;
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=63, using %d\n",
-			timeout);
-	}
-
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
 			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
@@ -280,18 +266,18 @@ advwdt_init(void)
 		goto unreg_stop;
 	}
 
-	ret = register_reboot_notifier(&advwdt_notifier);
-	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		goto unreg_regions;
+	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	if (advwdt_set_heartbeat(timeout)) {
+		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
+		printk (KERN_INFO PFX "timeout value must be 1<=x<=63, using %d\n",
+			timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
 		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		goto unreg_reboot;
+		goto unreg_regions;
 	}
 
 	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
@@ -299,8 +285,6 @@ advwdt_init(void)
 
 out:
 	return ret;
-unreg_reboot:
-	unregister_reboot_notifier(&advwdt_notifier);
 unreg_regions:
 	release_region(wdt_start, 1);
 unreg_stop:
@@ -309,14 +293,64 @@ unreg_stop:
 	goto out;
 }
 
-static void __exit
-advwdt_exit(void)
+static int __devexit
+advwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&advwdt_miscdev);
-	unregister_reboot_notifier(&advwdt_notifier);
+	release_region(wdt_start,1);
 	if(wdt_stop != wdt_start)
 		release_region(wdt_stop,1);
-	release_region(wdt_start,1);
+
+	return 0;
+}
+
+static void
+advwdt_shutdown(struct platform_device *dev)
+{
+	/* Turn the WDT off if we have a soft shutdown */
+	advwdt_disable();
+}
+
+static struct platform_driver advwdt_driver = {
+	.probe		= advwdt_probe,
+	.remove		= __devexit_p(advwdt_remove),
+	.shutdown	= advwdt_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init
+advwdt_init(void)
+{
+	int err;
+
+	printk(KERN_INFO "WDT driver for Advantech single board computer initialising.\n");
+
+	err = platform_driver_register(&advwdt_driver);
+	if (err)
+		return err;
+
+	advwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(advwdt_platform_device)) {
+		err = PTR_ERR(advwdt_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&advwdt_driver);
+	return err;
+}
+
+static void __exit
+advwdt_exit(void)
+{
+	platform_device_unregister(advwdt_platform_device);
+	platform_driver_unregister(&advwdt_driver);
+	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(advwdt_init);
diff --git a/drivers/char/watchdog/alim1535_wdt.c b/drivers/char/watchdog/alim1535_wdt.c
index 01b0d13..e3f6a7d 100644
--- a/drivers/char/watchdog/alim1535_wdt.c
+++ b/drivers/char/watchdog/alim1535_wdt.c
@@ -40,7 +40,7 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	ali_start	-	start watchdog countdown
diff --git a/drivers/char/watchdog/alim7101_wdt.c b/drivers/char/watchdog/alim7101_wdt.c
index bf25d0a..c195078 100644
--- a/drivers/char/watchdog/alim7101_wdt.c
+++ b/drivers/char/watchdog/alim7101_wdt.c
@@ -69,7 +69,7 @@ module_param(use_gpio, int, 0);
 MODULE_PARM_DESC(use_gpio, "Use the gpio watchdog.  (required by old cobalt boards)");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -78,7 +78,7 @@ static struct pci_dev *alim7101_pmu;
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
-		 __stringify(CONFIG_WATCHDOG_NOWAYOUT) ")");
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Whack the dog
@@ -108,8 +108,7 @@ static void wdt_timer_ping(unsigned long
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 }
 
 /*
@@ -147,9 +146,7 @@ static void wdt_startup(void)
 	wdt_change(WDT_ENABLE);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
-
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
@@ -380,10 +377,6 @@ static int __init alim7101_wdt_init(void
 			timeout);
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 1;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/char/watchdog/cpu5wdt.c
index 00bdabb..bcd7e36 100644
--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -80,10 +80,8 @@ static void cpu5wdt_trigger(unsigned lon
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
 	/* requeue?? */
-	if( cpu5wdt_device.queue && ticks ) {
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
-	}
+	if (cpu5wdt_device.queue && ticks)
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	else {
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
@@ -109,8 +107,7 @@ static void cpu5wdt_start(void)
 		outb(1, port + CPU5WDT_MODE_REG);
 		outb(0, port + CPU5WDT_RESET_REG);
 		outb(0, port + CPU5WDT_ENABLE_REG);
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
@@ -245,9 +242,7 @@ static int __devinit cpu5wdt_init(void)
 
 	clear_bit(0, &cpu5wdt_device.inuse);
 
-	init_timer(&cpu5wdt_device.timer);
-	cpu5wdt_device.timer.function = cpu5wdt_trigger;
-	cpu5wdt_device.timer.data = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
 
 	cpu5wdt_device.default_ticks = ticks;
 
diff --git a/drivers/char/watchdog/eurotechwdt.c b/drivers/char/watchdog/eurotechwdt.c
index e228d6e..f70387f 100644
--- a/drivers/char/watchdog/eurotechwdt.c
+++ b/drivers/char/watchdog/eurotechwdt.c
@@ -73,7 +73,7 @@ #define WDT_TIMEOUT		60                /
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some symbolic names
diff --git a/drivers/char/watchdog/i6300esb.c b/drivers/char/watchdog/i6300esb.c
index fb64df4..c598250 100644
--- a/drivers/char/watchdog/i6300esb.c
+++ b/drivers/char/watchdog/i6300esb.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some i6300ESB specific functions
diff --git a/drivers/char/watchdog/i8xx_tco.c b/drivers/char/watchdog/i8xx_tco.c
index e0627d7..a62ef48 100644
--- a/drivers/char/watchdog/i8xx_tco.c
+++ b/drivers/char/watchdog/i8xx_tco.c
@@ -109,7 +109,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some TCO specific functions
diff --git a/drivers/char/watchdog/iTCO_wdt.c b/drivers/char/watchdog/iTCO_wdt.c
index 7eac922..8b13dfa 100644
--- a/drivers/char/watchdog/iTCO_wdt.c
+++ b/drivers/char/watchdog/iTCO_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO Watchdog Driver (Used in i82801 and i6300ESB chipsets)
  *
- *	(c) Copyright 2006 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2007 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -49,7 +49,7 @@
 /* Module and version information */
 #define DRV_NAME        "iTCO_wdt"
 #define DRV_VERSION     "1.01"
-#define DRV_RELDATE     "11-Nov-2006"
+#define DRV_RELDATE     "21-Jan-2007"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -187,7 +187,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /* iTCO Vendor Specific Support hooks */
 #ifdef CONFIG_ITCO_VENDOR_SUPPORT
diff --git a/drivers/char/watchdog/ib700wdt.c b/drivers/char/watchdog/ib700wdt.c
index c1ed209..c3a60f5 100644
--- a/drivers/char/watchdog/ib700wdt.c
+++ b/drivers/char/watchdog/ib700wdt.c
@@ -3,8 +3,8 @@
  *
  *	(c) Copyright 2001 Charles Howes <chowes@vsol.net>
  *
- *      Based on advantechwdt.c which is based on acquirewdt.c which
- *       is based on wdt.c.
+ *	Based on advantechwdt.c which is based on acquirewdt.c which
+ *	is based on wdt.c.
  *
  *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
  *
@@ -25,9 +25,9 @@
  *
  *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
  *
- *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
- *           Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *           Added timeout module option to override default
+ *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
+ *	     Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *	     Added timeout module option to override default
  *
  */
 
@@ -36,22 +36,24 @@ #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/ioport.h>
-#include <linux/notifier.h>
 #include <linux/fs.h>
-#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
+#include <linux/platform_device.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
+static struct platform_device *ibwdt_platform_device;
 static unsigned long ibwdt_is_open;
 static spinlock_t ibwdt_lock;
 static char expect_close;
 
-#define PFX "ib700wdt: "
+/* Module information */
+#define DRV_NAME "ib700wdt"
+#define PFX DRV_NAME ": "
 
 /*
  *
@@ -118,20 +120,51 @@ static int wd_margin = WD_TIMO;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 /*
- *	Kernel methods.
+ *	Watchdog Operations
  */
 
 static void
 ibwdt_ping(void)
 {
+	spin_lock(&ibwdt_lock);
+
 	/* Write a watchdog value */
 	outb_p(wd_margin, WDT_START);
+
+	spin_unlock(&ibwdt_lock);
 }
 
+static void
+ibwdt_disable(void)
+{
+	spin_lock(&ibwdt_lock);
+	outb_p(0, WDT_STOP);
+	spin_unlock(&ibwdt_lock);
+}
+
+static int
+ibwdt_set_heartbeat(int t)
+{
+	int i;
+
+	if ((t < 0) || (t > 30))
+		return -EINVAL;
+
+	for (i = 0x0F; i > -1; i--)
+		if (wd_times[i] > t)
+			break;
+	wd_margin = i;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
 static ssize_t
 ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
@@ -159,7 +192,7 @@ static int
 ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	  unsigned long arg)
 {
-	int i, new_margin;
+	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
@@ -176,6 +209,7 @@ ibwdt_ioctl(struct inode *inode, struct 
 	  break;
 
 	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
 	  return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
@@ -185,18 +219,33 @@ ibwdt_ioctl(struct inode *inode, struct 
 	case WDIOC_SETTIMEOUT:
 	  if (get_user(new_margin, p))
 		  return -EFAULT;
-	  if ((new_margin < 0) || (new_margin > 30))
+	  if (ibwdt_set_heartbeat(new_margin))
 		  return -EINVAL;
-	  for (i = 0x0F; i > -1; i--)
-		  if (wd_times[i] > new_margin)
-			  break;
-	  wd_margin = i;
 	  ibwdt_ping();
 	  /* Fall */
 
 	case WDIOC_GETTIMEOUT:
 	  return put_user(wd_times[wd_margin], p);
-	  break;
+
+	case WDIOC_SETOPTIONS:
+	{
+	  int options, retval = -EINVAL;
+
+	  if (get_user(options, p))
+	    return -EFAULT;
+
+	  if (options & WDIOS_DISABLECARD) {
+	    ibwdt_disable();
+	    retval = 0;
+	  }
+
+	  if (options & WDIOS_ENABLECARD) {
+	    ibwdt_ping();
+	    retval = 0;
+	  }
+
+	  return retval;
+	}
 
 	default:
 	  return -ENOTTY;
@@ -207,9 +256,7 @@ ibwdt_ioctl(struct inode *inode, struct 
 static int
 ibwdt_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&ibwdt_lock);
 	if (test_and_set_bit(0, &ibwdt_is_open)) {
-		spin_unlock(&ibwdt_lock);
 		return -EBUSY;
 	}
 	if (nowayout)
@@ -217,41 +264,24 @@ ibwdt_open(struct inode *inode, struct f
 
 	/* Activate */
 	ibwdt_ping();
-	spin_unlock(&ibwdt_lock);
 	return nonseekable_open(inode, file);
 }
 
 static int
 ibwdt_close(struct inode *inode, struct file *file)
 {
-	spin_lock(&ibwdt_lock);
-	if (expect_close == 42)
-		outb_p(0, WDT_STOP);
-	else
+	if (expect_close == 42) {
+		ibwdt_disable();
+	} else {
 		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
-
+		ibwdt_ping();
+	}
 	clear_bit(0, &ibwdt_is_open);
 	expect_close = 0;
-	spin_unlock(&ibwdt_lock);
 	return 0;
 }
 
 /*
- *	Notifier for system down
- */
-
-static int
-ibwdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
-		outb_p(0, WDT_STOP);
-	}
-	return NOTIFY_DONE;
-}
-
-/*
  *	Kernel Interfaces
  */
 
@@ -271,26 +301,14 @@ static struct miscdevice ibwdt_miscdev =
 };
 
 /*
- *	The WDT needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
+ *	Init & exit routines
  */
 
-static struct notifier_block ibwdt_notifier = {
-	.notifier_call = ibwdt_notify_sys,
-};
-
-static int __init ibwdt_init(void)
+static int __devinit ibwdt_probe(struct platform_device *dev)
 {
 	int res;
 
-	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
-
 	spin_lock_init(&ibwdt_lock);
-	res = misc_register(&ibwdt_miscdev);
-	if (res) {
-		printk (KERN_ERR PFX "failed to register misc device\n");
-		goto out_nomisc;
-	}
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
@@ -305,34 +323,78 @@ #endif
 		res = -EIO;
 		goto out_nostartreg;
 	}
-	res = register_reboot_notifier(&ibwdt_notifier);
+
+	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk (KERN_ERR PFX "Failed to register reboot notifier.\n");
-		goto out_noreboot;
+		printk (KERN_ERR PFX "failed to register misc device\n");
+		goto out_nomisc;
 	}
 	return 0;
 
-out_noreboot:
+out_nomisc:
 	release_region(WDT_START, 1);
 out_nostartreg:
 #if WDT_START != WDT_STOP
 	release_region(WDT_STOP, 1);
 #endif
 out_nostopreg:
-	misc_deregister(&ibwdt_miscdev);
-out_nomisc:
 	return res;
 }
 
-static void __exit
-ibwdt_exit(void)
+static int __devexit ibwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&ibwdt_miscdev);
-	unregister_reboot_notifier(&ibwdt_notifier);
+	release_region(WDT_START,1);
 #if WDT_START != WDT_STOP
 	release_region(WDT_STOP,1);
 #endif
-	release_region(WDT_START,1);
+	return 0;
+}
+
+static void ibwdt_shutdown(struct platform_device *dev)
+{
+	/* Turn the WDT off if we have a soft shutdown */
+	ibwdt_disable();
+}
+
+static struct platform_driver ibwdt_driver = {
+	.probe		= ibwdt_probe,
+	.remove		= __devexit_p(ibwdt_remove),
+	.shutdown	= ibwdt_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init ibwdt_init(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
+
+	err = platform_driver_register(&ibwdt_driver);
+	if (err)
+		return err;
+
+	ibwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(ibwdt_platform_device)) {
+		err = PTR_ERR(ibwdt_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&ibwdt_driver);
+	return err;
+}
+
+static void __exit ibwdt_exit(void)
+{
+	platform_device_unregister(ibwdt_platform_device);
+	platform_driver_unregister(&ibwdt_driver);
+	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(ibwdt_init);
diff --git a/drivers/char/watchdog/ibmasr.c b/drivers/char/watchdog/ibmasr.c
index dd6760f..8195f50 100644
--- a/drivers/char/watchdog/ibmasr.c
+++ b/drivers/char/watchdog/ibmasr.c
@@ -396,7 +396,7 @@ module_init(ibmasr_init);
 module_exit(ibmasr_exit);
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
 MODULE_AUTHOR("Andrey Panin");
diff --git a/drivers/char/watchdog/indydog.c b/drivers/char/watchdog/indydog.c
index 0bc2393..788245b 100644
--- a/drivers/char/watchdog/indydog.c
+++ b/drivers/char/watchdog/indydog.c
@@ -32,7 +32,7 @@ #define WATCHDOG_TIMEOUT 30		/* 30 sec d
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void indydog_start(void)
 {
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 276577d..4a328ba 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -95,7 +95,7 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define PFX "machzwd"
 
@@ -118,12 +118,14 @@ static int action = 0;
 module_param(action, int, 0);
 MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
+static void zf_ping(unsigned long data);
+
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
 static spinlock_t zf_lock;
 static spinlock_t zf_port_lock;
-static struct timer_list zf_timer;
+static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
 static unsigned long next_heartbeat = 0;
 
 
@@ -220,9 +222,7 @@ static void zf_timer_on(void)
 	next_heartbeat = jiffies + ZF_USER_TIMEO;
 
 	/* start the timer for internal ping */
-	zf_timer.expires = jiffies + ZF_HW_TIMEO;
-
-	add_timer(&zf_timer);
+	mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 
 	/* start watchdog timer */
 	ctrl_reg = zf_get_control();
@@ -260,8 +260,7 @@ static void zf_ping(unsigned long data)
 		zf_set_control(ctrl_reg);
 		spin_unlock_irqrestore(&zf_port_lock, flags);
 
-		zf_timer.expires = jiffies + ZF_HW_TIMEO;
-		add_timer(&zf_timer);
+		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	}else{
 		printk(KERN_CRIT PFX ": I will reset your machine\n");
 	}
@@ -465,11 +464,6 @@ static int __init zf_init(void)
 	zf_set_status(0);
 	zf_set_control(0);
 
-	/* this is the timer that will do the hard work */
-	init_timer(&zf_timer);
-	zf_timer.function = zf_ping;
-	zf_timer.data = 0;
-
 	return 0;
 
 no_reboot:
diff --git a/drivers/char/watchdog/mixcomwd.c b/drivers/char/watchdog/mixcomwd.c
index c2dac0a..f35e284 100644
--- a/drivers/char/watchdog/mixcomwd.c
+++ b/drivers/char/watchdog/mixcomwd.c
@@ -56,16 +56,18 @@ #define MIXCOM_ID 0x11
 #define FLASHCOM_WATCHDOG_OFFSET 0x4
 #define FLASHCOM_ID 0x18
 
+static void mixcomwd_timerfun(unsigned long d);
+
 static unsigned long mixcomwd_opened; /* long req'd for setbit --RR */
 
 static int watchdog_port;
 static int mixcomwd_timer_alive;
-static DEFINE_TIMER(mixcomwd_timer, NULL, 0, 0);
+static DEFINE_TIMER(mixcomwd_timer, mixcomwd_timerfun, 0, 0);
 static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void mixcomwd_ping(void)
 {
@@ -77,7 +79,7 @@ static void mixcomwd_timerfun(unsigned l
 {
 	mixcomwd_ping();
 
-	mod_timer(&mixcomwd_timer,jiffies+ 5*HZ);
+	mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 }
 
 /*
@@ -114,12 +116,8 @@ static int mixcomwd_release(struct inode
 			printk(KERN_ERR "mixcomwd: release called while internal timer alive");
 			return -EBUSY;
 		}
-		init_timer(&mixcomwd_timer);
-		mixcomwd_timer.expires=jiffies + 5 * HZ;
-		mixcomwd_timer.function=mixcomwd_timerfun;
-		mixcomwd_timer.data=0;
 		mixcomwd_timer_alive=1;
-		add_timer(&mixcomwd_timer);
+		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else {
 		printk(KERN_CRIT "mixcomwd: WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
@@ -285,7 +283,7 @@ static void __exit mixcomwd_exit(void)
 		if(mixcomwd_timer_alive) {
 			printk(KERN_WARNING "mixcomwd: I quit now, hardware will"
 			       " probably reboot!\n");
-			del_timer(&mixcomwd_timer);
+			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive=0;
 		}
 	}
diff --git a/drivers/char/watchdog/pc87413_wdt.c b/drivers/char/watchdog/pc87413_wdt.c
index 1d447e3..4faea2f 100644
--- a/drivers/char/watchdog/pc87413_wdt.c
+++ b/drivers/char/watchdog/pc87413_wdt.c
@@ -631,5 +631,5 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout in minutes (default=" __MODULE_STRING(timeout) ").");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
diff --git a/drivers/char/watchdog/pcwd.c b/drivers/char/watchdog/pcwd.c
index 8e1e6e4..6e8b570 100644
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
+#define WATCHDOG_DATE "21 Jan 2007"
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
@@ -167,14 +179,14 @@ static int debug = QUIET;
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
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Internal functions
@@ -831,9 +843,7 @@ static int __devinit pcwatchdog_init(int
 	/* clear the "card caused reboot" flag */
 	pcwd_clear_status();
 
-	init_timer(&pcwd_private.timer);
-	pcwd_private.timer.function = pcwd_timer_ping;
-	pcwd_private.timer.data = 0;
+	setup_timer(&pcwd_private.timer, pcwd_timer_ping, 0);
 
 	/*  Disable the board  */
 	pcwd_stop();
@@ -844,6 +854,10 @@ static int __devinit pcwatchdog_init(int
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
index f4872c8..61a89e9 100644
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
+#define WATCHDOG_DATE "21 Jan 2007"
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
 
@@ -119,14 +131,14 @@ static int debug = QUIET;
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
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Internal functions
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
index 2da5ac9..31037f9 100644
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
+#define DRIVER_DATE "21 Jan 2007"
 #define DRIVER_AUTHOR "Wim Van Sebroeck <wim@iguana.be>"
 #define DRIVER_DESC "Berkshire USB-PC Watchdog driver"
 #define DRIVER_LICENSE "GPL"
@@ -75,14 +74,14 @@ MODULE_ALIAS_MISCDEV(TEMP_MINOR);
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
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /* The vendor and product id's for the USB-PC Watchdog card */
 #define USB_PCWD_VENDOR_ID	0x0c98
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
index 18cb050..dff6cb5 100644
--- a/drivers/char/watchdog/s3c2410_wdt.c
+++ b/drivers/char/watchdog/s3c2410_wdt.c
@@ -78,7 +78,7 @@ MODULE_PARM_DESC(tmr_margin, "Watchdog t
 
 MODULE_PARM_DESC(tmr_atboot, "Watchdog is started at boot time if set to 1, default=" __MODULE_STRING(CONFIG_S3C2410_WATCHDOG_ATBOOT));
 
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, 0 to reboot (default depends on ONLY_TESTING)");
 
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
diff --git a/drivers/char/watchdog/sbc60xxwdt.c b/drivers/char/watchdog/sbc60xxwdt.c
index c7b2045..b628203 100644
--- a/drivers/char/watchdog/sbc60xxwdt.c
+++ b/drivers/char/watchdog/sbc60xxwdt.c
@@ -100,10 +100,10 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -122,8 +122,7 @@ static void wdt_timer_ping(unsigned long
 		/* Ping the WDT by reading from wdt_start */
 		inb_p(wdt_start);
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -138,8 +137,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
 
@@ -363,10 +361,6 @@ static int __init sbc60xxwdt_init(void)
 		}
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
diff --git a/drivers/char/watchdog/sbc8360.c b/drivers/char/watchdog/sbc8360.c
index 41fc6f8..67ae426 100644
--- a/drivers/char/watchdog/sbc8360.c
+++ b/drivers/char/watchdog/sbc8360.c
@@ -204,7 +204,7 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Index into timeout table (0-63) (default=27 (60s))");
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
-		 "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+		 "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
diff --git a/drivers/char/watchdog/sbc_epx_c3.c b/drivers/char/watchdog/sbc_epx_c3.c
index 8882b42..82cbd88 100644
--- a/drivers/char/watchdog/sbc_epx_c3.c
+++ b/drivers/char/watchdog/sbc_epx_c3.c
@@ -35,7 +35,7 @@ #define WATCHDOG_TIMEOUT 1		/* 1 sec def
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define EPXC3_WATCHDOG_CTL_REG 0x1ee /* write 1 to enable, 0 to disable */
 #define EPXC3_WATCHDOG_PET_REG 0x1ef /* write anything to pet once enabled */
diff --git a/drivers/char/watchdog/sc1200wdt.c b/drivers/char/watchdog/sc1200wdt.c
index e323983..1e4a8d7 100644
--- a/drivers/char/watchdog/sc1200wdt.c
+++ b/drivers/char/watchdog/sc1200wdt.c
@@ -92,7 +92,7 @@ MODULE_PARM_DESC(timeout, "range is 0-25
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 
diff --git a/drivers/char/watchdog/sc520_wdt.c b/drivers/char/watchdog/sc520_wdt.c
index caec37b..2676a43 100644
--- a/drivers/char/watchdog/sc520_wdt.c
+++ b/drivers/char/watchdog/sc520_wdt.c
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * AMD Elan SC520 - Watchdog Timer Registers
@@ -121,7 +121,7 @@ #define WDT_ENB		0x8000	/* [15] Watchdog
 static __u16 __iomem *wdtmrctl;
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -145,8 +145,7 @@ static void wdt_timer_ping(unsigned long
 		spin_unlock(&wdt_spinlock);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -179,8 +178,7 @@ static int wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
@@ -389,10 +387,6 @@ static int __init sc520_wdt_init(void)
 
 	spin_lock_init(&wdt_spinlock);
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	/* Check that the timeout value is within it's range ; if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
diff --git a/drivers/char/watchdog/shwdt.c b/drivers/char/watchdog/shwdt.c
index dc40362..cecbedd 100644
--- a/drivers/char/watchdog/shwdt.c
+++ b/drivers/char/watchdog/shwdt.c
@@ -65,10 +65,12 @@ static int clock_division_ratio = WTCSR_
 
 #define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
 
+static void sh_wdt_ping(unsigned long data);
+
 static unsigned long shwdt_is_open;
 static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
-static struct timer_list timer;
+static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
@@ -433,10 +435,6 @@ static int __init sh_wdt_init(void)
 		       "be 1<=x<=3600, using %d\n", heartbeat);
 	}
 
-	init_timer(&timer);
-	timer.function = sh_wdt_ping;
-	timer.data = 0;
-
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
 		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
diff --git a/drivers/char/watchdog/smsc37b787_wdt.c b/drivers/char/watchdog/smsc37b787_wdt.c
index 9f56913..aa977f1 100644
--- a/drivers/char/watchdog/smsc37b787_wdt.c
+++ b/drivers/char/watchdog/smsc37b787_wdt.c
@@ -624,4 +624,4 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "range is 1-255 units, default is 60");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
diff --git a/drivers/char/watchdog/softdog.c b/drivers/char/watchdog/softdog.c
index 4067e1f..9c36949 100644
--- a/drivers/char/watchdog/softdog.c
+++ b/drivers/char/watchdog/softdog.c
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(soft_margin, "Watchdog 
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef ONLY_TESTING
 static int soft_noboot = 1;
diff --git a/drivers/char/watchdog/w83627hf_wdt.c b/drivers/char/watchdog/w83627hf_wdt.c
index 07d4bff..337ee42 100644
--- a/drivers/char/watchdog/w83627hf_wdt.c
+++ b/drivers/char/watchdog/w83627hf_wdt.c
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
diff --git a/drivers/char/watchdog/w83697hf_wdt.c b/drivers/char/watchdog/w83697hf_wdt.c
index 7768b55..f9f6f54 100644
--- a/drivers/char/watchdog/w83697hf_wdt.c
+++ b/drivers/char/watchdog/w83697hf_wdt.c
@@ -60,7 +60,7 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
diff --git a/drivers/char/watchdog/w83877f_wdt.c b/drivers/char/watchdog/w83877f_wdt.c
index b0e5f84..3c88fe1 100644
--- a/drivers/char/watchdog/w83877f_wdt.c
+++ b/drivers/char/watchdog/w83877f_wdt.c
@@ -87,10 +87,10 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -114,8 +114,7 @@ static void wdt_timer_ping(unsigned long
 		inb_p(WDT_PING);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 		spin_unlock(&wdt_spinlock);
 
@@ -155,8 +154,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	wdt_change(WDT_ENABLE);
 
@@ -377,10 +375,6 @@ static int __init w83877f_wdt_init(void)
 		goto err_out_region1;
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
diff --git a/drivers/char/watchdog/w83977f_wdt.c b/drivers/char/watchdog/w83977f_wdt.c
index 2c8d5d8..1579684 100644
--- a/drivers/char/watchdog/w83977f_wdt.c
+++ b/drivers/char/watchdog/w83977f_wdt.c
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(testmode,"Watchdog test
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
diff --git a/drivers/char/watchdog/wafer5823wdt.c b/drivers/char/watchdog/wafer5823wdt.c
index 163e028..950905d 100644
--- a/drivers/char/watchdog/wafer5823wdt.c
+++ b/drivers/char/watchdog/wafer5823wdt.c
@@ -65,7 +65,7 @@ MODULE_PARM_DESC(timeout, "Watchdog time
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wafwdt_ping(void)
 {
diff --git a/drivers/char/watchdog/wdt.c b/drivers/char/watchdog/wdt.c
index 517fbd8..0a3de6a 100644
--- a/drivers/char/watchdog/wdt.c
+++ b/drivers/char/watchdog/wdt.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /* You must set these - there is no sane way to probe for this board. */
 static int io=0x240;
diff --git a/drivers/char/watchdog/wdt977.c b/drivers/char/watchdog/wdt977.c
index 6253041..7d300ff 100644
--- a/drivers/char/watchdog/wdt977.c
+++ b/drivers/char/watchdog/wdt977.c
@@ -68,7 +68,7 @@ MODULE_PARM_DESC(testmode,"Watchdog test
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
diff --git a/drivers/char/watchdog/wdt_pci.c b/drivers/char/watchdog/wdt_pci.c
index ce1261c..6baf4ae 100644
--- a/drivers/char/watchdog/wdt_pci.c
+++ b/drivers/char/watchdog/wdt_pci.c
@@ -90,7 +90,7 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef CONFIG_WDT_501_PCI
 /* Support for the Fan Tachometer on the PCI-WDT501 */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZCYJ0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZCYJ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZCYJ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:26:43 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:49588 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbZCYJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:26:36 -0400
X-Belgacom-Dynamic: yes
Date: Wed, 25 Mar 2009 10:26:27 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Lammerts <eric@lammerts.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Phil Sutter <n0-1@freewrt.org>, Thomas Reitmayr <treitmayr@devbase.at>,
       Julia Lawall <julia@diku.dk>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [WATCHDOG] v2.6.29 watchdog patches
Message-ID: <20090325092627.GE27002@infomag.iguana.be>
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

 arch/arm/mach-orion5x/common.c                 |   29 ++++
 arch/arm/plat-orion/include/plat/orion5x_wdt.h |   18 ++
 drivers/watchdog/Kconfig                       |   15 --
 drivers/watchdog/acquirewdt.c                  |    8 -
 drivers/watchdog/advantechwdt.c                |    7 -
 drivers/watchdog/alim1535_wdt.c                |   20 +-
 drivers/watchdog/alim7101_wdt.c                |    6 
 drivers/watchdog/at91sam9_wdt.c                |    2 
 drivers/watchdog/cpwd.c                        |  101 +++++++-------
 drivers/watchdog/davinci_wdt.c                 |   45 +++---
 drivers/watchdog/eurotechwdt.c                 |   22 +--
 drivers/watchdog/geodewdt.c                    |   11 +
 drivers/watchdog/hpwdt.c                       |   20 +-
 drivers/watchdog/i6300esb.c                    |  101 +++++++++-----
 drivers/watchdog/iTCO_vendor_support.c         |    6 
 drivers/watchdog/iTCO_wdt.c                    |   15 +-
 drivers/watchdog/it87_wdt.c                    |   12 -
 drivers/watchdog/mpc5200_wdt.c                 |    4 
 drivers/watchdog/mpcore_wdt.c                  |    2 
 drivers/watchdog/mtx-1_wdt.c                   |    2 
 drivers/watchdog/orion5x_wdt.c                 |   76 ++++++++--
 drivers/watchdog/pc87413_wdt.c                 |    6 
 drivers/watchdog/pcwd.c                        |   44 +++---
 drivers/watchdog/pcwd_pci.c                    |  108 +++++++++------
 drivers/watchdog/pcwd_usb.c                    |  175 +++++++++++++++----------
 drivers/watchdog/pnx4008_wdt.c                 |   18 +-
 drivers/watchdog/rc32434_wdt.c                 |  153 +++++++++++++--------
 drivers/watchdog/riowd.c                       |   23 +--
 drivers/watchdog/sa1100_wdt.c                  |    6 
 drivers/watchdog/sbc60xxwdt.c                  |    2 
 drivers/watchdog/sbc8360.c                     |   12 -
 drivers/watchdog/sbc_epx_c3.c                  |    3 
 drivers/watchdog/sc1200wdt.c                   |    7 -
 drivers/watchdog/sc520_wdt.c                   |    9 -
 drivers/watchdog/smsc37b787_wdt.c              |   30 ++--
 drivers/watchdog/softdog.c                     |    5 
 drivers/watchdog/w83697hf_wdt.c                |    3 
 drivers/watchdog/w83697ug_wdt.c                |   23 ++-
 drivers/watchdog/w83977f_wdt.c                 |    2 
 drivers/watchdog/wd501p.h                      |   24 +--
 drivers/watchdog/wdt.c                         |  152 ++++++++++-----------
 drivers/watchdog/wdt977.c                      |    2 
 42 files changed, 793 insertions(+), 536 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Mar 23 13:50:38 2009 +0000

    [WATCHDOG] i6300esb.c: start locking
    
    Change the start function in preparation of the generic watchdog code.
    Also make sure that locking of the start function is OK.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Mar 19 19:02:44 2009 +0000

    [WATCHDOG] i6300esb.c: convert to platform device driver
    
    Convert the Intel 6300ESB watchdog timer to a platform device driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Sun Mar 22 10:46:42 2009 +0000

    [WATCHDOG] wdt.c: remove #ifdef CONFIG_WDT_501
    
    Change the wdt.c watchdog driver so that the code is the same for
    both the WDT500 as the WDT501-P card. The selection of the card
    is now being done via the module parameter: 'type' instead of the
    config option CONFIG_WDT_501.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 18 09:09:26 2009 +0000

    [WATCHDOG] Fix io.h & uaccess.h includes.
    
    Fix following includes:
    * #include <asm/io.h> should be #include <linux/io.h>
    * #include <asm/uaccess.h> should be #include <linux/uaccess.h>
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 18 08:35:09 2009 +0000

    [WATCHDOG] More coding-style and trivial clean-up
    
    Some more cleaning-up of the watchdog drivers.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 18 08:18:43 2009 +0000

    [WATCHDOG] struct file_operations should be const
    
    Fix following warnings:
    WARNING: struct file_operations should normally be const
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Mar 18 08:05:24 2009 +0000

    [WATCHDOG] cpwd.c: Coding style - Clean-up
    
    This brings the cpwd.c watchdog driver in line with the kernel's coding style.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Tue Mar 3 00:17:16 2009 +0000

    [WATCHDOG] hpwdt.c: Add new HP BMC controller.
    
    Add the PCI-ID for the upcoming new BMC controller for HP hardware.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Julia Lawall <julia@diku.dk>
Date:   Mon Dec 29 11:23:47 2008 +0100

    [PATCH 13/13] drivers/watchdog: use USB API functions rather than constants
    
    This set of patches introduces calls to the following set of functions:
    
    usb_endpoint_dir_in(epd)
    usb_endpoint_dir_out(epd)
    usb_endpoint_is_bulk_in(epd)
    usb_endpoint_is_bulk_out(epd)
    usb_endpoint_is_int_in(epd)
    usb_endpoint_is_int_out(epd)
    usb_endpoint_num(epd)
    usb_endpoint_type(epd)
    usb_endpoint_xfer_bulk(epd)
    usb_endpoint_xfer_control(epd)
    usb_endpoint_xfer_int(epd)
    usb_endpoint_xfer_isoc(epd)
    
    In some cases, introducing one of these functions is not possible, and it
    just replaces an explicit integer value by one of the following constants:
    
    USB_ENDPOINT_XFER_BULK
    USB_ENDPOINT_XFER_CONTROL
    USB_ENDPOINT_XFER_INT
    USB_ENDPOINT_XFER_ISOC
    
    An extract of the semantic patch that makes these changes is as follows:
    (http://www.emn.fr/x-info/coccinelle/)
    
    // <smpl>
    @r1@ struct usb_endpoint_descriptor *epd; @@
    
    - ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
    - \(USB_ENDPOINT_XFER_CONTROL\|0\))
    + usb_endpoint_xfer_control(epd)
    
    @r5@ struct usb_endpoint_descriptor *epd; @@
    
    - ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
    -  \(USB_DIR_IN\|0x80\))
    + usb_endpoint_dir_in(epd)
    
    @inc@
    @@
    
    #include <linux/usb.h>
    
    @depends on !inc && (r1||r5)@
    @@
    
    + #include <linux/usb.h>
      #include <linux/usb/...>
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Reitmayr <treitmayr@devbase.at>
Date:   Tue Feb 24 14:59:22 2009 -0800

    [WATCHDOG] orion5x_wdt: fix compile issue by providing tclk as platform data
    
    The orion5x-wdt driver is now registered as a platform device and
    receives the tclk value as platform data. This fixes a compile issue
    cause by a previously removed define "ORION5X_TCLK".
    
    Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>
    Acked-by: Nicolas Pitre <nico@marvell.com>
    Signed-off-by: Kristof Provost <kristof@sigsegv.be>
    Cc: Lennert Buytenhek <buytenh@wantstofly.org>
    Cc: Wim Van Sebroeck <wim@iguana.be>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Cc: Martin Michlmayr <tbm@cyrius.com>
    Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
    Cc: Kunihiko IMAI <bak@d2.dion.ne.jp>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 23 13:08:37 2009 +0000

    [WATCHDOG] rc32434_wdt: make sure watchdog is not running at startup
    
    Make sure that the watchdog is not running after loading
    and before it is started by opening /dev/watchdog.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 23 13:08:36 2009 +0000

    [WATCHDOG] rc32434_wdt: add spin_locking
    
    Add spin_locks to prevent races.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 23 13:08:35 2009 +0000

    [WATCHDOG] rc32434_wdt: add shutdown method
    
    Add shutdown method to the platform driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Phil Sutter <n0-1@freewrt.org>
Date:   Sun Feb 8 16:44:42 2009 +0100

    [WATCHDOG] rc32434_wdt: add timeout module parameter
    
    The WDT timer ticks quite fast (half of the CPU clock speed, which may
    be between 198MHz and 330MHz (or 400MHz on newer boards)). Given it's
    size of 32Bit, the maximum timeout value ranges from about 21s to 43s,
    depending on the configured CPU clock speed.
    
    This patch add's the timeout module parameter and checks that it's not
    bigger then the maximum timeout for the given clock speed.
    
    Signed-off-by: Phil Sutter <n0-1@freewrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Phil Sutter <n0-1@freewrt.org>
Date:   Sun Feb 8 16:44:42 2009 +0100

    [WATCHDOG] rc32434_wdt: clean-up driver
    
    Clean-up the rc32434 driver code:
    	- name the platform driver rc32434_wdt_driver
    	- Replace KBUILD_MODNAME ": " with PFX define.
    	- Cleanup include files
    	- Order the ioctl's
    
    Signed-off-by: Phil Sutter <n0-1@freewrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Kevin Hilman <khilman@deeprootsystems.com>
Date:   Thu Jan 29 14:14:30 2009 -0800

    [WATCHDOG] davinci: convert to ioremap() + io[read|write]
    
    Remove davinci platform-specific IO accessor macros in favor
    of standard ioremap + io[read|write]* functions.
    
    Also, convert printk(KERN_ERR ....) into dev_err(...)
    
    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Eric Lammerts <eric@lammerts.org>
Date:   Tue Feb 3 17:45:56 2009 -0500

    [WATCHDOG] w83697ug: add error checking
    
    I noticed the W83697UG driver tries to register a watchdog even though
    it already noticed the chip isn't there.
    
    WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.
    w83697ug/uf WDT: No W83697UG/UF could be found
    w83697ug/uf WDT: Watchdog already running. Resetting timeout to 60 sec
    w83697ug/uf WDT: cannot register miscdev on minor=130 (err=-16)
    
    Patch propagates the error back to wdt_init().
    
    Signed-off-by: Eric Lammerts <eric@lammerts.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jan 21 11:13:11 2009 +0000

    [WATCHDOG] cpwd.c & riowd.c - unlocked_ioctl
    
    Switch to unlocked_ioctl
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 8a0e49d..1a1df24 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -31,6 +31,7 @@
 #include <plat/ehci-orion.h>
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
+#include <plat/orion5x_wdt.h>
 #include <plat/time.h>
 #include "common.h"
 
@@ -533,6 +534,29 @@ void __init orion5x_xor_init(void)
 
 
 /*****************************************************************************
+ * Watchdog
+ ****************************************************************************/
+static struct orion5x_wdt_platform_data orion5x_wdt_data = {
+	.tclk			= 0,
+};
+
+static struct platform_device orion5x_wdt_device = {
+	.name		= "orion5x_wdt",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &orion5x_wdt_data,
+	},
+	.num_resources	= 0,
+};
+
+void __init orion5x_wdt_init(void)
+{
+	orion5x_wdt_data.tclk = orion5x_tclk;
+	platform_device_register(&orion5x_wdt_device);
+}
+
+
+/*****************************************************************************
  * Time handling
  ****************************************************************************/
 int orion5x_tclk;
@@ -631,6 +655,11 @@ void __init orion5x_init(void)
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
 		disable_hlt();
 	}
+
+	/*
+	 * Register watchdog driver
+	 */
+	orion5x_wdt_init();
 }
 
 /*
diff --git a/arch/arm/plat-orion/include/plat/orion5x_wdt.h b/arch/arm/plat-orion/include/plat/orion5x_wdt.h
new file mode 100644
index 0000000..3c9cf6a
--- /dev/null
+++ b/arch/arm/plat-orion/include/plat/orion5x_wdt.h
@@ -0,0 +1,18 @@
+/*
+ * arch/arm/plat-orion/include/plat/orion5x_wdt.h
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __PLAT_ORION5X_WDT_H
+#define __PLAT_ORION5X_WDT_H
+
+struct orion5x_wdt_platform_data {
+	u32	tclk;		/* no <linux/clk.h> support yet */
+};
+
+
+#endif
+
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 325c10f..55f64af 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -940,21 +940,6 @@ config WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called wdt.
 
-config WDT_501
-	bool "WDT501 features"
-	depends on WDT
-	help
-	  Saying Y here and creating a character special file /dev/temperature
-	  with major number 10 and minor number 131 ("man mknod") will give
-	  you a thermometer inside your computer: reading from
-	  /dev/temperature yields one byte, the temperature in degrees
-	  Fahrenheit. This works only if you have a WDT501P watchdog board
-	  installed.
-
-	  If you want to enable the Fan Tachometer on the WDT501P, then you
-	  can do this via the tachometer parameter. Only do this if you have a
-	  fan tachometer actually set up.
-
 #
 # PCI-based Watchdog Cards
 #
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 3e57aa4..4d18c87 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -1,7 +1,7 @@
 /*
  *	Acquire Single Board Computer Watchdog Timer driver
  *
- *      Based on wdt.c. Original copyright messages:
+ *	Based on wdt.c. Original copyright messages:
  *
  *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *						All Rights Reserved.
@@ -17,9 +17,9 @@
  *
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
- *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
- *          Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *          Can't add timeout - driver doesn't allow changing value
+ *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
+ *	    Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *	    Can't add timeout - driver doesn't allow changing value
  */
 
 /*
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index a1d7856..824d076 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -138,7 +138,9 @@ static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING |
+			   WDIOF_SETTIMEOUT |
+			   WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
 	};
@@ -259,7 +261,8 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 		goto unreg_stop;
 	}
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range ;
+	 * if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
 		printk(KERN_INFO PFX
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2a7690e..937a80f 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -60,7 +60,7 @@ static void ali_start(void)
 
 	pci_read_config_dword(ali_pci, 0xCC, &val);
 	val &= ~0x3F;	/* Mask count */
-	val |= (1<<25) | ali_timeout_bits;
+	val |= (1 << 25) | ali_timeout_bits;
 	pci_write_config_dword(ali_pci, 0xCC, val);
 
 	spin_unlock(&ali_lock);
@@ -79,8 +79,8 @@ static void ali_stop(void)
 	spin_lock(&ali_lock);
 
 	pci_read_config_dword(ali_pci, 0xCC, &val);
-	val &= ~0x3F;	/* Mask count to zero (disabled) */
-	val &= ~(1<<25);/* and for safety mask the reset enable */
+	val &= ~0x3F;		/* Mask count to zero (disabled) */
+	val &= ~(1 << 25);	/* and for safety mask the reset enable */
 	pci_write_config_dword(ali_pci, 0xCC, val);
 
 	spin_unlock(&ali_lock);
@@ -89,7 +89,7 @@ static void ali_stop(void)
 /*
  *	ali_keepalive	-	send a keepalive to the watchdog
  *
- *      Send a keepalive to the timer (actually we restart the timer).
+ *	Send a keepalive to the timer (actually we restart the timer).
  */
 
 static void ali_keepalive(void)
@@ -109,11 +109,11 @@ static int ali_settimer(int t)
 	if (t < 0)
 		return -EINVAL;
 	else if (t < 60)
-		ali_timeout_bits = t|(1<<6);
+		ali_timeout_bits = t|(1 << 6);
 	else if (t < 3600)
-		ali_timeout_bits = (t/60)|(1<<7);
+		ali_timeout_bits = (t / 60)|(1 << 7);
 	else if (t < 18000)
-		ali_timeout_bits = (t/300)|(1<<6)|(1<<7);
+		ali_timeout_bits = (t / 300)|(1 << 6)|(1 << 7);
 	else
 		return -EINVAL;
 
@@ -138,7 +138,7 @@ static int ali_settimer(int t)
  */
 
 static ssize_t ali_write(struct file *file, const char __user *data,
-			      size_t len, loff_t *ppos)
+						size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
@@ -348,9 +348,9 @@ static int __init ali_find_watchdog(void)
 	/* Timer bits */
 	wdog &= ~0x3F;
 	/* Issued events */
-	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));
+	wdog &= ~((1 << 27)|(1 << 26)|(1 << 25)|(1 << 24));
 	/* No monitor bits */
-	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));
+	wdog &= ~((1 << 16)|(1 << 13)|(1 << 12)|(1 << 11)|(1 << 10)|(1 << 9));
 
 	pci_write_config_dword(pdev, 0xCC, wdog);
 
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index a045ef8..90f98df 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -355,7 +355,8 @@ static int __init alim7101_wdt_init(void)
 	alim7101_pmu = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
 		NULL);
 	if (!alim7101_pmu) {
-		printk(KERN_INFO PFX "ALi M7101 PMU not present - WDT not set\n");
+		printk(KERN_INFO PFX
+			"ALi M7101 PMU not present - WDT not set\n");
 		return -EBUSY;
 	}
 
@@ -399,7 +400,8 @@ static int __init alim7101_wdt_init(void)
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
 			wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index a56ac84..435b057 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -201,7 +201,7 @@ static long at91_wdt_ioctl(struct file *file,
  * Pat the watchdog whenever device is written to.
  */
 static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
-      loff_t *ppos)
+								loff_t *ppos)
 {
 	if (!len)
 		return 0;
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 084dfe9..41070e4 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -1,13 +1,13 @@
 /* cpwd.c - driver implementation for hardware watchdog
  * timers found on Sun Microsystems CP1400 and CP1500 boards.
  *
- * This device supports both the generic Linux watchdog 
+ * This device supports both the generic Linux watchdog
  * interface and Solaris-compatible ioctls as best it is
  * able.
  *
  * NOTE: 	CP1400 systems appear to have a defective intr_mask
  * 			register on the PLD, preventing the disabling of
- * 			timer interrupts.  We use a timer to periodically 
+ * 			timer interrupts.  We use a timer to periodically
  * 			reset 'stopped' watchdogs on affected platforms.
  *
  * Copyright (c) 2000 Eric Brower (ebrower@usa.net)
@@ -28,10 +28,9 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/irq.h>
-#include <asm/uaccess.h>
-
 #include <asm/watchdog.h>
 
 #define DRIVER_NAME	"cpwd"
@@ -43,8 +42,8 @@
 #define WD_BLIMIT	0xFFFF
 
 #define WD0_MINOR	212
-#define WD1_MINOR	213	
-#define WD2_MINOR	214	
+#define WD1_MINOR	213
+#define WD2_MINOR	214
 
 /* Internal driver definitions.  */
 #define WD0_ID			0
@@ -91,16 +90,16 @@ struct cpwd {
 
 static struct cpwd *cpwd_device;
 
-/* Sun uses Altera PLD EPF8820ATC144-4 
+/* Sun uses Altera PLD EPF8820ATC144-4
  * providing three hardware watchdogs:
  *
- * 	1) RIC - sends an interrupt when triggered
- * 	2) XIR - asserts XIR_B_RESET when triggered, resets CPU
- * 	3) POR - asserts POR_B_RESET when triggered, resets CPU, backplane, board
+ * 1) RIC - sends an interrupt when triggered
+ * 2) XIR - asserts XIR_B_RESET when triggered, resets CPU
+ * 3) POR - asserts POR_B_RESET when triggered, resets CPU, backplane, board
  *
  *** Timer register block definition (struct wd_timer_regblk)
  *
- * dcntr and limit registers (halfword access):      
+ * dcntr and limit registers (halfword access):
  * -------------------
  * | 15 | ...| 1 | 0 |
  * -------------------
@@ -108,7 +107,8 @@ static struct cpwd *cpwd_device;
  * -------------------
  * dcntr - 	Current 16-bit downcounter value.
  * 			When downcounter reaches '0' watchdog expires.
- * 			Reading this register resets downcounter with 'limit' value.
+ * 			Reading this register resets downcounter with
+ * 			'limit' value.
  * limit - 	16-bit countdown value in 1/10th second increments.
  * 			Writing this register begins countdown with input value.
  * 			Reading from this register does not affect counter.
@@ -158,11 +158,11 @@ static int wd0_timeout = 0;
 static int wd1_timeout = 0;
 static int wd2_timeout = 0;
 
-module_param	(wd0_timeout, int, 0);
+module_param(wd0_timeout, int, 0);
 MODULE_PARM_DESC(wd0_timeout, "Default watchdog0 timeout in 1/10secs");
-module_param 	(wd1_timeout, int, 0);
+module_param(wd1_timeout, int, 0);
 MODULE_PARM_DESC(wd1_timeout, "Default watchdog1 timeout in 1/10secs");
-module_param 	(wd2_timeout, int, 0);
+module_param(wd2_timeout, int, 0);
 MODULE_PARM_DESC(wd2_timeout, "Default watchdog2 timeout in 1/10secs");
 
 MODULE_AUTHOR("Eric Brower <ebrower@usa.net>");
@@ -201,9 +201,9 @@ static u8 cpwd_readb(void __iomem *addr)
 static void cpwd_toggleintr(struct cpwd *p, int index, int enable)
 {
 	unsigned char curregs = cpwd_readb(p->regs + PLD_IMASK);
-	unsigned char setregs = 
-		(index == -1) ? 
-		(WD0_INTR_MASK | WD1_INTR_MASK | WD2_INTR_MASK) : 
+	unsigned char setregs =
+		(index == -1) ?
+		(WD0_INTR_MASK | WD1_INTR_MASK | WD2_INTR_MASK) :
 		(p->devs[index].intr_mask);
 
 	if (enable == WD_INTR_ON)
@@ -303,24 +303,24 @@ static int cpwd_getstatus(struct cpwd *p, int index)
 	unsigned char ret  = WD_STOPPED;
 
 	/* determine STOPPED */
-	if (!stat) 
+	if (!stat)
 		return ret;
 
 	/* determine EXPIRED vs FREERUN vs RUNNING */
 	else if (WD_S_EXPIRED & stat) {
 		ret = WD_EXPIRED;
-	} else if(WD_S_RUNNING & stat) {
+	} else if (WD_S_RUNNING & stat) {
 		if (intr & p->devs[index].intr_mask) {
 			ret = WD_FREERUN;
 		} else {
 			/* Fudge WD_EXPIRED status for defective CP1400--
-			 * IF timer is running 
-			 * 	AND brokenstop is set 
+			 * IF timer is running
+			 * 	AND brokenstop is set
 			 * 	AND an interrupt has been serviced
 			 * we are WD_EXPIRED.
 			 *
-			 * IF timer is running 
-			 * 	AND brokenstop is set 
+			 * IF timer is running
+			 * 	AND brokenstop is set
 			 * 	AND no interrupt has been serviced
 			 * we are WD_FREERUN.
 			 */
@@ -329,7 +329,8 @@ static int cpwd_getstatus(struct cpwd *p, int index)
 				if (p->devs[index].runstatus & WD_STAT_SVCD) {
 					ret = WD_EXPIRED;
 				} else {
-					/* we could as well pretend we are expired */
+					/* we could as well pretend
+					 * we are expired */
 					ret = WD_FREERUN;
 				}
 			} else {
@@ -342,7 +343,7 @@ static int cpwd_getstatus(struct cpwd *p, int index)
 	if (p->devs[index].runstatus & WD_STAT_SVCD)
 		ret |= WD_SERVICED;
 
-	return(ret);
+	return ret;
 }
 
 static irqreturn_t cpwd_interrupt(int irq, void *dev_id)
@@ -367,22 +368,22 @@ static int cpwd_open(struct inode *inode, struct file *f)
 	struct cpwd *p = cpwd_device;
 
 	lock_kernel();
-	switch(iminor(inode)) {
-		case WD0_MINOR:
-		case WD1_MINOR:
-		case WD2_MINOR:
-			break;
+	switch (iminor(inode)) {
+	case WD0_MINOR:
+	case WD1_MINOR:
+	case WD2_MINOR:
+		break;
 
-		default:
-			unlock_kernel();
-			return -ENODEV;
+	default:
+		unlock_kernel();
+		return -ENODEV;
 	}
 
 	/* Register IRQ on first open of device */
 	if (!p->initialized) {
-		if (request_irq(p->irq, &cpwd_interrupt, 
+		if (request_irq(p->irq, &cpwd_interrupt,
 				IRQF_SHARED, DRIVER_NAME, p)) {
-			printk(KERN_ERR PFX "Cannot register IRQ %d\n", 
+			printk(KERN_ERR PFX "Cannot register IRQ %d\n",
 				p->irq);
 			unlock_kernel();
 			return -EBUSY;
@@ -400,8 +401,7 @@ static int cpwd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int cpwd_ioctl(struct inode *inode, struct file *file, 
-		      unsigned int cmd, unsigned long arg)
+static long cpwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
@@ -409,6 +409,7 @@ static int cpwd_ioctl(struct inode *inode, struct file *file,
 		.identity		= DRIVER_NAME,
 	};
 	void __user *argp = (void __user *)arg;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int index = iminor(inode) - WD0_MINOR;
 	struct cpwd *p = cpwd_device;
 	int setopt = 0;
@@ -442,7 +443,7 @@ static int cpwd_ioctl(struct inode *inode, struct file *file,
 			cpwd_starttimer(p, index);
 		} else {
 			return -EINVAL;
-		}	
+		}
 		break;
 
 	/* Solaris-compatible IOCTLs */
@@ -458,7 +459,7 @@ static int cpwd_ioctl(struct inode *inode, struct file *file,
 
 	case WIOCSTOP:
 		if (p->enabled)
-			return(-EINVAL);
+			return -EINVAL;
 
 		cpwd_stoptimer(p, index);
 		break;
@@ -481,7 +482,7 @@ static long cpwd_compat_ioctl(struct file *file, unsigned int cmd,
 	case WIOCSTOP:
 	case WIOCGSTAT:
 		lock_kernel();
-		rval = cpwd_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		rval = cpwd_ioctl(file, cmd, arg);
 		unlock_kernel();
 		break;
 
@@ -493,7 +494,7 @@ static long cpwd_compat_ioctl(struct file *file, unsigned int cmd,
 	return rval;
 }
 
-static ssize_t cpwd_write(struct file *file, const char __user *buf, 
+static ssize_t cpwd_write(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -508,20 +509,20 @@ static ssize_t cpwd_write(struct file *file, const char __user *buf,
 	return 0;
 }
 
-static ssize_t cpwd_read(struct file * file, char __user *buffer,
+static ssize_t cpwd_read(struct file *file, char __user *buffer,
 			 size_t count, loff_t *ppos)
 {
 	return -EINVAL;
 }
 
 static const struct file_operations cpwd_fops = {
-	.owner =	THIS_MODULE,
-	.ioctl =	cpwd_ioctl,
-	.compat_ioctl =	cpwd_compat_ioctl,
-	.open =		cpwd_open,
-	.write =	cpwd_write,
-	.read =		cpwd_read,
-	.release =	cpwd_release,
+	.owner =		THIS_MODULE,
+	.unlocked_ioctl =	cpwd_ioctl,
+	.compat_ioctl =		cpwd_compat_ioctl,
+	.open =			cpwd_open,
+	.write =		cpwd_write,
+	.read =			cpwd_read,
+	.release =		cpwd_release,
 };
 
 static int __devinit cpwd_probe(struct of_device *op,
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 2e13602..c51d0b0 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -24,7 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <mach/hardware.h>
+#include <linux/device.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -75,9 +75,9 @@ static void wdt_service(void)
 	spin_lock(&io_lock);
 
 	/* put watchdog in service state */
-	davinci_writel(WDKEY_SEQ0, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
 	/* put watchdog in active state */
-	davinci_writel(WDKEY_SEQ1, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
 
 	spin_unlock(&io_lock);
 }
@@ -90,29 +90,29 @@ static void wdt_enable(void)
 	spin_lock(&io_lock);
 
 	/* disable, internal clock source */
-	davinci_writel(0, wdt_base + TCR);
+	iowrite32(0, wdt_base + TCR);
 	/* reset timer, set mode to 64-bit watchdog, and unreset */
-	davinci_writel(0, wdt_base + TGCR);
+	iowrite32(0, wdt_base + TGCR);
 	tgcr = TIMMODE_64BIT_WDOG | TIM12RS_UNRESET | TIM34RS_UNRESET;
-	davinci_writel(tgcr, wdt_base + TGCR);
+	iowrite32(tgcr, wdt_base + TGCR);
 	/* clear counter regs */
-	davinci_writel(0, wdt_base + TIM12);
-	davinci_writel(0, wdt_base + TIM34);
+	iowrite32(0, wdt_base + TIM12);
+	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
 	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
-	davinci_writel(timer_margin, wdt_base + PRD12);
+	iowrite32(timer_margin, wdt_base + PRD12);
 	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
-	davinci_writel(timer_margin, wdt_base + PRD34);
+	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
-	davinci_writel(ENAMODE12_PERIODIC, wdt_base + TCR);
+	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
 	/* Once the WDT is in pre-active state write to
 	 * TIM12, TIM34, PRD12, PRD34, TCR, TGCR, WDTCR are
 	 * write protected (except for the WDKEY field)
 	 */
 	/* put watchdog in pre-active state */
-	davinci_writel(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
 	/* put watchdog in active state */
-	davinci_writel(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
 
 	spin_unlock(&io_lock);
 }
@@ -197,17 +197,16 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
 	struct resource *res;
+	struct device *dev = &pdev->dev;
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	printk(KERN_INFO MODULE_NAME
-		"DaVinci Watchdog Timer: heartbeat %d sec\n", heartbeat);
+	dev_info(dev, "heartbeat %d sec\n", heartbeat);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resource\n");
+		dev_err(dev, "failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
@@ -215,20 +214,26 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
+		dev_err(dev, "failed to get memory region\n");
 		return -ENOENT;
 	}
-	wdt_base = (void __iomem *)(res->start);
+
+	wdt_base = ioremap(res->start, size);
+	if (!wdt_base) {
+		dev_err(dev, "failed to map memory region\n");
+		return -ENOMEM;
+	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
+		dev_err(dev, "cannot register misc device\n");
 		release_resource(wdt_mem);
 		kfree(wdt_mem);
 	} else {
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
 
+	iounmap(wdt_base);
 	return ret;
 }
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index a171fc6..9add354 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -8,19 +8,19 @@
  *	Based on wdt.c.
  *	Original copyright messages:
  *
- *      (c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *						All Rights Reserved.
  *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
  *
- *      Neither Alan Cox nor CymruNet Ltd. admit liability nor provide
- *      warranty for any of this software. This material is provided
- *      "AS-IS" and at no charge.
+ *	Neither Alan Cox nor CymruNet Ltd. admit liability nor provide
+ *	warranty for any of this software. This material is provided
+ *	"AS-IS" and at no charge.
  *
- *      (c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>*
+ *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>*
  */
 
 /* Changelog:
@@ -37,7 +37,7 @@
  *	add expect_close support
  *
  * 2002.05.30 - Joel Becker <joel.becker@oracle.com>
- * 	Added Matt Domsch's nowayout module option.
+ *	Added Matt Domsch's nowayout module option.
  */
 
 /*
@@ -151,7 +151,7 @@ static void eurwdt_activate_timer(void)
 	if (irq == 0)
 		printk(KERN_INFO ": interrupt disabled\n");
 
-	eurwdt_write_reg(WDT_TIMER_CFG, irq<<4);
+	eurwdt_write_reg(WDT_TIMER_CFG, irq << 4);
 
 	eurwdt_write_reg(WDT_UNIT_SEL, WDT_UNIT_SECS);	/* we use seconds */
 	eurwdt_set_timeout(0);	/* the default timeout */
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 6799a6d..9acf001 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -34,11 +34,15 @@
 
 static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=131, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=131, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static struct platform_device *geodewdt_platform_device;
 static unsigned long wdt_flags;
@@ -269,7 +273,8 @@ static int __init geodewdt_init(void)
 	if (ret)
 		return ret;
 
-	geodewdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	geodewdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(geodewdt_platform_device)) {
 		ret = PTR_ERR(geodewdt_platform_device);
 		goto err;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 763c1ea..6cf155d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -47,6 +47,7 @@
 #define PCI_BIOS32_PARAGRAPH_LEN	16
 #define PCI_ROM_BASE1			0x000F0000
 #define ROM_SIZE			0x10000
+#define HPWDT_VERSION			"1.01"
 
 struct bios32_service_dir {
 	u32 signature;
@@ -130,17 +131,14 @@ static void *cru_rom_addr;
 static struct cmn_registers cmn_regs;
 
 static struct pci_device_id hpwdt_devices[] = {
-	{
-	 .vendor = PCI_VENDOR_ID_COMPAQ,
-	 .device = 0xB203,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
-	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },
 	{0},			/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
-extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs, unsigned long *pRomEntry);
+extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+						unsigned long *pRomEntry);
 
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */
@@ -605,7 +603,7 @@ static long hpwdt_ioctl(struct file *file, unsigned int cmd,
 /*
  *	Kernel interfaces
  */
-static struct file_operations hpwdt_fops = {
+static const struct file_operations hpwdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = hpwdt_write,
@@ -704,10 +702,11 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	}
 
 	printk(KERN_INFO
-		"hp Watchdog Timer Driver: 1.00"
+		"hp Watchdog Timer Driver: %s"
 		", timer margin: %d seconds (nowayout=%d)"
 		", allow kernel dump: %s (default = 0/OFF).\n",
-		soft_margin, nowayout, (allow_kdump == 0) ? "OFF" : "ON");
+		HPWDT_VERSION, soft_margin, nowayout,
+		(allow_kdump == 0) ? "OFF" : "ON");
 
 	return 0;
 
@@ -757,6 +756,7 @@ static int __init hpwdt_init(void)
 MODULE_AUTHOR("Tom Mingarelli");
 MODULE_DESCRIPTION("hp watchdog driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HPWDT_VERSION);
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 74f951c..2dbe835 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -13,7 +13,7 @@
  *
  *	The timer is implemented in the following I/O controller hubs:
  *	(See the intel documentation on http://developer.intel.com.)
- *	6300ESB chip : document number 300641-003
+ *	6300ESB chip : document number 300641-004
  *
  *  2004YYZZ Ross Biro
  *	Initial version 0.01
@@ -34,7 +34,7 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/reboot.h>
+#include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
@@ -42,7 +42,7 @@
 #include <linux/io.h>
 
 /* Module and version information */
-#define ESB_VERSION "0.03"
+#define ESB_VERSION "0.04"
 #define ESB_MODULE_NAME "i6300ESB timer"
 #define ESB_DRIVER_NAME ESB_MODULE_NAME ", v" ESB_VERSION
 #define PFX ESB_MODULE_NAME ": "
@@ -81,6 +81,7 @@ static unsigned long timer_alive;
 static struct pci_dev *esb_pci;
 static unsigned short triggered; /* The status of the watchdog upon boot */
 static char esb_expect_close;
+static struct platform_device *esb_platform_device;
 
 /* module parameters */
 /* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
@@ -114,13 +115,18 @@ static inline void esb_unlock_registers(void)
 	writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
 }
 
-static void esb_timer_start(void)
+static int esb_timer_start(void)
 {
 	u8 val;
 
+	spin_lock(&esb_lock);
+	esb_unlock_registers();
+	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 	/* Enable or Enable + Lock? */
 	val = 0x02 | (nowayout ? 0x01 : 0x00);
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
+	spin_unlock(&esb_lock);
+	return 0;
 }
 
 static int esb_timer_stop(void)
@@ -207,7 +213,6 @@ static int esb_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 
 	/* Reload and activate timer */
-	esb_timer_keepalive();
 	esb_timer_start();
 
 	return nonseekable_open(inode, file);
@@ -240,7 +245,8 @@ static ssize_t esb_write(struct file *file, const char __user *data,
 			 * five months ago... */
 			esb_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			 * magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data + i))
@@ -292,7 +298,6 @@ static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		}
 
 		if (new_options & WDIOS_ENABLECARD) {
-			esb_timer_keepalive();
 			esb_timer_start();
 			retval = 0;
 		}
@@ -319,19 +324,6 @@ static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 /*
- *      Notify system
- */
-
-static int esb_notify_sys(struct notifier_block *this,
-					unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		esb_timer_stop();	/* Turn the WDT off */
-
-	return NOTIFY_DONE;
-}
-
-/*
  *      Kernel Interfaces
  */
 
@@ -350,10 +342,6 @@ static struct miscdevice esb_miscdev = {
 	.fops = &esb_fops,
 };
 
-static struct notifier_block esb_notifier = {
-	.notifier_call = esb_notify_sys,
-};
-
 /*
  * Data for PCI driver interface
  *
@@ -372,7 +360,7 @@ MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
  *      Init & exit routines
  */
 
-static unsigned char __init esb_getdevice(void)
+static unsigned char __devinit esb_getdevice(void)
 {
 	u8 val1;
 	unsigned short val2;
@@ -443,7 +431,7 @@ err_devput:
 	return 0;
 }
 
-static int __init watchdog_init(void)
+static int __devinit esb_probe(struct platform_device *dev)
 {
 	int ret;
 
@@ -459,19 +447,13 @@ static int __init watchdog_init(void)
 			"heartbeat value must be 1<heartbeat<2046, using %d\n",
 								heartbeat);
 	}
-	ret = register_reboot_notifier(&esb_notifier);
-	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
-		goto err_unmap;
-	}
 
 	ret = misc_register(&esb_miscdev);
 	if (ret != 0) {
 		printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
-		goto err_notifier;
+		goto err_unmap;
 	}
 	esb_timer_stop();
 	printk(KERN_INFO PFX
@@ -479,8 +461,6 @@ static int __init watchdog_init(void)
 						BASEADDR, heartbeat, nowayout);
 	return 0;
 
-err_notifier:
-	unregister_reboot_notifier(&esb_notifier);
 err_unmap:
 	iounmap(BASEADDR);
 /* err_release: */
@@ -492,7 +472,7 @@ err_unmap:
 	return ret;
 }
 
-static void __exit watchdog_cleanup(void)
+static int __devexit esb_remove(struct platform_device *dev)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -500,11 +480,58 @@ static void __exit watchdog_cleanup(void)
 
 	/* Deregister */
 	misc_deregister(&esb_miscdev);
-	unregister_reboot_notifier(&esb_notifier);
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
 	pci_dev_put(esb_pci);
+	return 0;
+}
+
+static void esb_shutdown(struct platform_device *dev)
+{
+	esb_timer_stop();
+}
+
+static struct platform_driver esb_platform_driver = {
+	.probe          = esb_probe,
+	.remove         = __devexit_p(esb_remove),
+	.shutdown       = esb_shutdown,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = ESB_MODULE_NAME,
+	},
+};
+
+static int __init watchdog_init(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
+		ESB_VERSION);
+
+	err = platform_driver_register(&esb_platform_driver);
+	if (err)
+		return err;
+
+	esb_platform_device = platform_device_register_simple(ESB_MODULE_NAME,
+								-1, NULL, 0);
+	if (IS_ERR(esb_platform_device)) {
+		err = PTR_ERR(esb_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&esb_platform_driver);
+	return err;
+}
+
+static void __exit watchdog_cleanup(void)
+{
+	platform_device_unregister(esb_platform_device);
+	platform_driver_unregister(&esb_platform_driver);
+	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(watchdog_init);
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index d8264ad..d3c0f6d 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -47,7 +47,8 @@
 
 static int vendorsupport;
 module_param(vendorsupport, int, 0);
-MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default=0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
+MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default="
+			"0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
 
 /*
  *	Vendor Specific Support
@@ -305,7 +306,8 @@ static void __exit iTCO_vendor_exit_module(void)
 module_init(iTCO_vendor_init_module);
 module_exit(iTCO_vendor_exit_module);
 
-MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>, R. Seretny <lkpatches@paypc.com>");
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>, "
+		"R. Seretny <lkpatches@paypc.com>");
 MODULE_DESCRIPTION("Intel TCO Vendor Specific WatchDog Timer Driver Support");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 3523349..648250b 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -273,7 +273,9 @@ static struct platform_device *iTCO_wdt_platform_device;
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39 (TCO v1) or 613 (TCO v2), default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
+	"(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -346,7 +348,8 @@ static int iTCO_wdt_start(void)
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
+		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+					"reboot disabled by hardware\n");
 		return -EIO;
 	}
 
@@ -669,7 +672,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
+		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+					"reboot disabled by hardware\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out;
 	}
@@ -716,8 +720,9 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 2 < heartbeat < 39 (TCO v1) or 613 (TCO v2), using %d\n",
-							heartbeat);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
+				"or 613 (TCO v2), using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index afb8af3..cc133c5 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -188,8 +188,8 @@ static inline int superio_inb(int reg)
 
 static inline void superio_outb(int val, int reg)
 {
-       outb(reg, REG);
-       outb(val, VAL);
+	outb(reg, REG);
+	outb(val, VAL);
 }
 
 static inline int superio_inw(int reg)
@@ -204,10 +204,10 @@ static inline int superio_inw(int reg)
 
 static inline void superio_outw(int val, int reg)
 {
-       outb(reg++, REG);
-       outb(val >> 8, VAL);
-       outb(reg, REG);
-       outb(val, VAL);
+	outb(reg++, REG);
+	outb(val >> 8, VAL);
+	outb(reg, REG);
+	outb(val, VAL);
 }
 
 /* watchdog timer handling */
diff --git a/drivers/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
index db91892..465fe36 100644
--- a/drivers/watchdog/mpc5200_wdt.c
+++ b/drivers/watchdog/mpc5200_wdt.c
@@ -9,8 +9,8 @@
 #include <asm/mpc52xx.h>
 
 
-#define GPT_MODE_WDT		(1<<15)
-#define GPT_MODE_CE		(1<<12)
+#define GPT_MODE_WDT		(1 << 15)
+#define GPT_MODE_CE		(1 << 12)
 #define GPT_MODE_MS_TIMER	(0x4)
 
 
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 1130ad6..1512ab8 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -5,7 +5,7 @@
  *
  *	Based on the SoftDog driver:
  *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
- * 						All Rights Reserved.
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 3acce62..539b6f6 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -5,7 +5,7 @@
  *							All Rights Reserved.
  *                              http://www.4g-systems.biz
  *
- * 	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
+ *	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
  *
  *      This program is free software; you can redistribute it and/or
  *      modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/orion5x_wdt.c b/drivers/watchdog/orion5x_wdt.c
index b64ae1a..e81441f 100644
--- a/drivers/watchdog/orion5x_wdt.c
+++ b/drivers/watchdog/orion5x_wdt.c
@@ -16,11 +16,13 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
+#include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <plat/orion5x_wdt.h>
 
 /*
  * Watchdog timer block registers.
@@ -29,13 +31,14 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
-#define ORION5X_TCLK		166666667
-#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
+#define WDT_MAX_CYCLE_COUNT	0xffffffff
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
 static int nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat =  WDT_MAX_DURATION;	/* (seconds) */
+static int heartbeat = -1;		/* module parameter (seconds) */
+static unsigned int wdt_max_duration;	/* (seconds) */
+static unsigned int wdt_tclk;
 static unsigned long wdt_status;
 static spinlock_t wdt_lock;
 
@@ -46,7 +49,7 @@ static void wdt_enable(void)
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
-	writel(ORION5X_TCLK * heartbeat, WDT_VAL);
+	writel(wdt_tclk * heartbeat, WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -88,7 +91,7 @@ static void wdt_disable(void)
 static int orion5x_wdt_get_timeleft(int *time_left)
 {
 	spin_lock(&wdt_lock);
-	*time_left = readl(WDT_VAL) / ORION5X_TCLK;
+	*time_left = readl(WDT_VAL) / wdt_tclk;
 	spin_unlock(&wdt_lock);
 	return 0;
 }
@@ -158,7 +161,7 @@ static long orion5x_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (ret)
 			break;
 
-		if (time <= 0 || time > WDT_MAX_DURATION) {
+		if (time <= 0 || time > wdt_max_duration) {
 			ret = -EINVAL;
 			break;
 		}
@@ -210,23 +213,69 @@ static struct miscdevice orion5x_wdt_miscdev = {
 	.fops		= &orion5x_wdt_fops,
 };
 
-static int __init orion5x_wdt_init(void)
+static int __devinit orion5x_wdt_probe(struct platform_device *pdev)
 {
+	struct orion5x_wdt_platform_data *pdata = pdev->dev.platform_data;
 	int ret;
 
-	spin_lock_init(&wdt_lock);
+	if (pdata) {
+		wdt_tclk = pdata->tclk;
+	} else {
+		printk(KERN_ERR "Orion5x Watchdog misses platform data\n");
+		return -ENODEV;
+	}
+
+	if (orion5x_wdt_miscdev.parent)
+		return -EBUSY;
+	orion5x_wdt_miscdev.parent = &pdev->dev;
+
+	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
+	if (heartbeat <= 0 || heartbeat > wdt_max_duration)
+		heartbeat = wdt_max_duration;
 
 	ret = misc_register(&orion5x_wdt_miscdev);
-	if (ret == 0)
-		printk("Orion5x Watchdog Timer: heartbeat %d sec\n",
-								heartbeat);
+	if (ret)
+		return ret;
+
+	printk(KERN_INFO "Orion5x Watchdog Timer: Initial timeout %d sec%s\n",
+				heartbeat, nowayout ? ", nowayout" : "");
+	return 0;
+}
+
+static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
+{
+	int ret;
+
+	if (test_bit(WDT_IN_USE, &wdt_status)) {
+		wdt_disable();
+		clear_bit(WDT_IN_USE, &wdt_status);
+	}
+
+	ret = misc_deregister(&orion5x_wdt_miscdev);
+	if (!ret)
+		orion5x_wdt_miscdev.parent = NULL;
 
 	return ret;
 }
 
+static struct platform_driver orion5x_wdt_driver = {
+	.probe		= orion5x_wdt_probe,
+	.remove		= __devexit_p(orion5x_wdt_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "orion5x_wdt",
+	},
+};
+
+static int __init orion5x_wdt_init(void)
+{
+	spin_lock_init(&wdt_lock);
+	return platform_driver_register(&orion5x_wdt_driver);
+}
+
 static void __exit orion5x_wdt_exit(void)
 {
-	misc_deregister(&orion5x_wdt_miscdev);
+	platform_driver_unregister(&orion5x_wdt_driver);
 }
 
 module_init(orion5x_wdt_init);
@@ -236,8 +285,7 @@ MODULE_AUTHOR("Sylver Bruneau <sylver.bruneau@googlemail.com>");
 MODULE_DESCRIPTION("Orion5x Processor Watchdog");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default is "
-					__MODULE_STRING(WDT_MAX_DURATION) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 484c215..1a2b916 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -536,7 +536,8 @@ static int __init pc87413_init(void)
 
 	ret = misc_register(&pc87413_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pc87413_notifier);
 		return ret;
@@ -574,7 +575,8 @@ static void __exit pc87413_exit(void)
 module_init(pc87413_init);
 module_exit(pc87413_exit);
 
-MODULE_AUTHOR("Sven Anders <anders@anduras.de>, Marcus Junker <junker@anduras.de>,");
+MODULE_AUTHOR("Sven Anders <anders@anduras.de>, "
+		"Marcus Junker <junker@anduras.de>,");
 MODULE_DESCRIPTION("PC87413 WDT driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 9e1331a..aa95123 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -24,25 +24,25 @@
  *		version reporting.  Added read routine for temperature.
  *		Removed some extra defines, added an autodetect Revision
  *		routine.
- * 961006       Revised some documentation, fixed some cosmetic bugs.  Made
- *              drivers to panic the system if it's overheating at bootup.
+ * 961006	Revised some documentation, fixed some cosmetic bugs.  Made
+ *		drivers to panic the system if it's overheating at bootup.
  * 961118	Changed some verbiage on some of the output, tidied up
  *		code bits, and added compatibility to 2.1.x.
- * 970912       Enabled board on open and disable on close.
+ * 970912	Enabled board on open and disable on close.
  * 971107	Took account of recent VFS changes (broke read).
- * 971210       Disable board on initialisation in case board already ticking.
- * 971222       Changed open/close for temperature handling
- *              Michael Meskes <meskes@debian.org>.
- * 980112       Used minor numbers from include/linux/miscdevice.h
- * 990403       Clear reset status after reading control status register in
- *              pcwd_showprevstate(). [Marc Boucher <marc@mbsi.ca>]
+ * 971210	Disable board on initialisation in case board already ticking.
+ * 971222	Changed open/close for temperature handling
+ *		Michael Meskes <meskes@debian.org>.
+ * 980112	Used minor numbers from include/linux/miscdevice.h
+ * 990403	Clear reset status after reading control status register in
+ *		pcwd_showprevstate(). [Marc Boucher <marc@mbsi.ca>]
  * 990605	Made changes to code to support Firmware 1.22a, added
  *		fairly useless proc entry.
  * 990610	removed said useless proc code for the merge <alan>
  * 000403	Removed last traces of proc code. <davej>
  * 011214	Added nowayout module option to override
  *		CONFIG_WATCHDOG_NOWAYOUT <Matt_Domsch@dell.com>
- *              Added timeout module option to override default
+ *		Added timeout module option to override default
  */
 
 /*
@@ -76,8 +76,7 @@
 #define WATCHDOG_DRIVER_NAME "ISA-PC Watchdog"
 #define WATCHDOG_NAME "pcwd"
 #define PFX WATCHDOG_NAME ": "
-#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION " (" WATCHDOG_DATE ")\n"
-#define WD_VER WATCHDOG_VERSION " (" WATCHDOG_DATE ")"
+#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 /*
  * It should be noted that PCWD_REVISION_B was removed because A and B
@@ -200,7 +199,9 @@ MODULE_PARM_DESC(debug,
 #define WATCHDOG_HEARTBEAT 0
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2 <= heartbeat <= 7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
+	"(2 <= heartbeat <= 7200 or 0=delay-time from dip-switches, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -239,7 +240,8 @@ static int send_isa_command(int cmd)
 	}
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "received following data for cmd=0x%02x: port0=0x%02x last_port0=0x%02x\n",
+		printk(KERN_DEBUG PFX "received following data for "
+			"cmd=0x%02x: port0=0x%02x last_port0=0x%02x\n",
 			cmd, port0, last_port0);
 
 	return port0;
@@ -339,10 +341,12 @@ static void pcwd_show_card_info(void)
 							pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
-		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port 0x%04x (Firmware version: %s)\n",
+		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port "
+			"0x%04x (Firmware version: %s)\n",
 			pcwd_private.io_addr, pcwd_private.fw_ver_str);
 		option_switches = pcwd_get_option_switches();
-		printk(KERN_INFO PFX "Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
+		printk(KERN_INFO PFX "Option switches (0x%02x): "
+			"Temperature Reset Enable=%s, Power On Delay=%s\n",
 			option_switches,
 			((option_switches & 0x10) ? "ON" : "OFF"),
 			((option_switches & 0x08) ? "ON" : "OFF"));
@@ -358,7 +362,8 @@ static void pcwd_show_card_info(void)
 		printk(KERN_INFO PFX "Temperature Option Detected\n");
 
 	if (pcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX "Previous reboot was caused by the card\n");
+		printk(KERN_INFO PFX
+			"Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
 		printk(KERN_EMERG PFX
@@ -871,7 +876,7 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	cards_found++;
 	if (cards_found == 1)
 		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
-								WD_VER);
+							WATCHDOG_VERSION);
 
 	if (cards_found > 1) {
 		printk(KERN_ERR PFX "This driver only supports 1 device\n");
@@ -1026,7 +1031,8 @@ static void __exit pcwd_cleanup_module(void)
 module_init(pcwd_init_module);
 module_exit(pcwd_cleanup_module);
 
-MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>, Wim Van Sebroeck <wim@iguana.be>");
+MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>, "
+		"Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("Berkshire ISA-PC Watchdog driver");
 MODULE_VERSION(WATCHDOG_VERSION);
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 5d76422..698f51b 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -24,7 +24,8 @@
  *	A bells and whistles driver is available from:
  *	http://www.kernel.org/pub/linux/kernel/people/wim/pcwd/pcwd_pci/
  *
- *	More info available at http://www.berkprod.com/ or http://www.pcwatchdog.com/
+ *	More info available at
+ *	http://www.berkprod.com/ or http://www.pcwatchdog.com/
  */
 
 /*
@@ -51,11 +52,10 @@
 
 /* Module and version information */
 #define WATCHDOG_VERSION "1.03"
-#define WATCHDOG_DATE "21 Jan 2007"
 #define WATCHDOG_DRIVER_NAME "PCI-PC Watchdog"
 #define WATCHDOG_NAME "pcwd_pci"
 #define PFX WATCHDOG_NAME ": "
-#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION " (" WATCHDOG_DATE ")\n"
+#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 /* Stuff for the PCI ID's  */
 #ifndef PCI_VENDOR_ID_QUICKLOGIC
@@ -76,7 +76,8 @@
 #define WD_PCI_TTRP		0x04	/* Temperature Trip status */
 #define WD_PCI_RL2A		0x08	/* Relay 2 Active */
 #define WD_PCI_RL1A		0x10	/* Relay 1 Active */
-#define WD_PCI_R2DS		0x40	/* Relay 2 Disable Temperature-trip/reset */
+#define WD_PCI_R2DS		0x40	/* Relay 2 Disable Temperature-trip /
+									reset */
 #define WD_PCI_RLY2		0x80	/* Activate Relay 2 on the board */
 /* Port 2 : Control Status #2 */
 #define WD_PCI_WDIS		0x10	/* Watchdog Disable */
@@ -114,12 +115,18 @@ static int cards_found;
 static int temp_panic;
 static unsigned long is_active;
 static char expect_release;
-static struct {				/* this is private data for each PCI-PC watchdog card */
-	int supports_temp;		/* Wether or not the card has a temperature device */
-	int boot_status;		/* The card's boot status */
-	unsigned long io_addr;		/* The cards I/O address */
-	spinlock_t io_lock;		/* the lock for io operations */
-	struct pci_dev *pdev;		/* the PCI-device */
+/* this is private data for each PCI-PC watchdog card */
+static struct {
+	/* Wether or not the card has a temperature device */
+	int supports_temp;
+	/* The card's boot status */
+	int boot_status;
+	/* The cards I/O address */
+	unsigned long io_addr;
+	/* the lock for io operations */
+	spinlock_t io_lock;
+	/* the PCI-device */
+	struct pci_dev *pdev;
 } pcipcwd_private;
 
 /* module parameters */
@@ -130,14 +137,18 @@ static int debug = QUIET;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
 
-#define WATCHDOG_HEARTBEAT 0	/* default heartbeat = delay-time from dip-switches */
+#define WATCHDOG_HEARTBEAT 0	/* default heartbeat =
+						delay-time from dip-switches */
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
+	"(0<heartbeat<65536 or 0=delay-time from dip-switches, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+					__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Internal functions
@@ -148,8 +159,8 @@ static int send_command(int cmd, int *msb, int *lsb)
 	int got_response, count;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "sending following data cmd=0x%02x msb=0x%02x lsb=0x%02x\n",
-		cmd, *msb, *lsb);
+		printk(KERN_DEBUG PFX "sending following data "
+		"cmd=0x%02x msb=0x%02x lsb=0x%02x\n", cmd, *msb, *lsb);
 
 	spin_lock(&pcipcwd_private.io_lock);
 	/* If a command requires data it should be written first.
@@ -166,17 +177,20 @@ static int send_command(int cmd, int *msb, int *lsb)
 	 * the WRSP bit in port 2 and give it a max. timeout of
 	 * PCI_COMMAND_TIMEOUT to process */
 	got_response = inb_p(pcipcwd_private.io_addr + 2) & WD_PCI_WRSP;
-	for (count = 0; (count < PCI_COMMAND_TIMEOUT) && (!got_response); count++) {
+	for (count = 0; (count < PCI_COMMAND_TIMEOUT) && (!got_response);
+								count++) {
 		mdelay(1);
 		got_response = inb_p(pcipcwd_private.io_addr + 2) & WD_PCI_WRSP;
 	}
 
 	if (debug >= DEBUG) {
 		if (got_response) {
-			printk(KERN_DEBUG PFX "time to process command was: %d ms\n",
+			printk(KERN_DEBUG PFX
+				"time to process command was: %d ms\n",
 				count);
 		} else {
-			printk(KERN_DEBUG PFX "card did not respond on command!\n");
+			printk(KERN_DEBUG PFX
+				"card did not respond on command!\n");
 		}
 	}
 
@@ -189,7 +203,8 @@ static int send_command(int cmd, int *msb, int *lsb)
 		inb_p(pcipcwd_private.io_addr + 6);
 
 		if (debug >= DEBUG)
-			printk(KERN_DEBUG PFX "received following data for cmd=0x%02x: msb=0x%02x lsb=0x%02x\n",
+			printk(KERN_DEBUG PFX "received following data for "
+				"cmd=0x%02x: msb=0x%02x lsb=0x%02x\n",
 				cmd, *msb, *lsb);
 	}
 
@@ -218,7 +233,8 @@ static void pcipcwd_show_card_info(void)
 	char fw_ver_str[20];		/* The cards firmware version */
 	int option_switches;
 
-	got_fw_rev = send_command(CMD_GET_FIRMWARE_VERSION, &fw_rev_major, &fw_rev_minor);
+	got_fw_rev = send_command(CMD_GET_FIRMWARE_VERSION, &fw_rev_major,
+								&fw_rev_minor);
 	if (got_fw_rev)
 		sprintf(fw_ver_str, "%u.%02u", fw_rev_major, fw_rev_minor);
 	else
@@ -227,23 +243,27 @@ static void pcipcwd_show_card_info(void)
 	/* Get switch settings */
 	option_switches = pcipcwd_get_option_switches();
 
-	printk(KERN_INFO PFX "Found card at port 0x%04x (Firmware: %s) %s temp option\n",
+	printk(KERN_INFO PFX "Found card at port "
+		"0x%04x (Firmware: %s) %s temp option\n",
 		(int) pcipcwd_private.io_addr, fw_ver_str,
 		(pcipcwd_private.supports_temp ? "with" : "without"));
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
+	printk(KERN_INFO PFX "Option switches (0x%02x): "
+		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
 
 	if (pcipcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX "Previous reset was caused by the Watchdog card\n");
+		printk(KERN_INFO PFX
+			"Previous reset was caused by the Watchdog card\n");
 
 	if (pcipcwd_private.boot_status & WDIOF_OVERHEAT)
 		printk(KERN_INFO PFX "Card sensed a CPU Overheat\n");
 
 	if (pcipcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX "No previous trip detected - Cold boot or reset\n");
+		printk(KERN_INFO PFX
+			"No previous trip detected - Cold boot or reset\n");
 }
 
 static int pcipcwd_start(void)
@@ -283,7 +303,8 @@ static int pcipcwd_stop(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (!(stat_reg & WD_PCI_WDIS)) {
-		printk(KERN_ERR PFX "Card did not acknowledge disable attempt\n");
+		printk(KERN_ERR PFX
+			"Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
@@ -364,7 +385,8 @@ static int pcipcwd_clear_status(void)
 	}
 
 	/* clear trip status & LED and keep mode of relay 2 */
-	outb_p((control_status & WD_PCI_R2DS) | WD_PCI_WTRP, pcipcwd_private.io_addr + 1);
+	outb_p((control_status & WD_PCI_R2DS) | WD_PCI_WTRP,
+						pcipcwd_private.io_addr + 1);
 
 	/* clear reset counter */
 	msb = 0;
@@ -437,7 +459,8 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 			 * five months ago... */
 			expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			 * magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data + i))
@@ -531,7 +554,7 @@ static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		if (pcipcwd_set_heartbeat(new_heartbeat))
-		    return -EINVAL;
+			return -EINVAL;
 
 		pcipcwd_keepalive();
 		/* Fall */
@@ -560,7 +583,8 @@ static int pcipcwd_open(struct inode *inode, struct file *file)
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active)) {
 		if (debug >= VERBOSE)
-			printk(KERN_ERR PFX "Attempt to open already opened device.\n");
+			printk(KERN_ERR PFX
+				"Attempt to open already opened device.\n");
 		return -EBUSY;
 	}
 
@@ -578,7 +602,8 @@ static int pcipcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		pcipcwd_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		pcipcwd_keepalive();
 	}
 	expect_release = 0;
@@ -621,7 +646,8 @@ static int pcipcwd_temp_release(struct inode *inode, struct file *file)
  *	Notify system
  */
 
-static int pcipcwd_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int pcipcwd_notify_sys(struct notifier_block *this, unsigned long code,
+								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		pcipcwd_stop();	/* Turn the WDT off */
@@ -722,34 +748,38 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 
 	/* If heartbeat = 0 then we use the heartbeat from the dip-switches */
 	if (heartbeat == 0)
-		heartbeat = heartbeat_tbl[(pcipcwd_get_option_switches() & 0x07)];
+		heartbeat =
+			heartbeat_tbl[(pcipcwd_get_option_switches() & 0x07)];
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range ;
+	 * if not reset to the default */
 	if (pcipcwd_set_heartbeat(heartbeat)) {
 		pcipcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 0<heartbeat<65536, using %d\n",
+		printk(KERN_INFO PFX
+			"heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	ret = register_reboot_notifier(&pcipcwd_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto err_out_release_region;
 	}
 
 	if (pcipcwd_private.supports_temp) {
 		ret = misc_register(&pcipcwd_temp_miscdev);
 		if (ret != 0) {
-			printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-				TEMP_MINOR, ret);
+			printk(KERN_ERR PFX "cannot register miscdev on "
+				"minor=%d (err=%d)\n", TEMP_MINOR, ret);
 			goto err_out_unregister_reboot;
 		}
 	}
 
 	ret = misc_register(&pcipcwd_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_out_misc_deregister;
 	}
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index afb0896..052fe45 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -51,12 +51,11 @@
 
 /* Use our own dbg macro */
 #undef dbg
-#define dbg(format, arg...) do { if (debug) printk(KERN_DEBUG PFX format "\n" , ## arg); } while (0)
-
+#define dbg(format, arg...) \
+	do { if (debug) printk(KERN_DEBUG PFX format "\n" , ## arg); } while (0)
 
 /* Module and Version Information */
 #define DRIVER_VERSION "1.02"
-#define DRIVER_DATE "21 Jan 2007"
 #define DRIVER_AUTHOR "Wim Van Sebroeck <wim@iguana.be>"
 #define DRIVER_DESC "Berkshire USB-PC Watchdog driver"
 #define DRIVER_LICENSE "GPL"
@@ -73,14 +72,18 @@ MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
-#define WATCHDOG_HEARTBEAT 0	/* default heartbeat = delay-time from dip-switches */
+#define WATCHDOG_HEARTBEAT 0	/* default heartbeat =
+						delay-time from dip-switches */
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
+	"(0<heartbeat<65536 or 0=delay-time from dip-switches, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /* The vendor and product id's for the USB-PC Watchdog card */
 #define USB_PCWD_VENDOR_ID	0x0c98
@@ -91,20 +94,21 @@ static struct usb_device_id usb_pcwd_table[] = {
 	{ USB_DEVICE(USB_PCWD_VENDOR_ID, USB_PCWD_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
-MODULE_DEVICE_TABLE (usb, usb_pcwd_table);
+MODULE_DEVICE_TABLE(usb, usb_pcwd_table);
 
 /* according to documentation max. time to process a command for the USB
  * watchdog card is 100 or 200 ms, so we give it 250 ms to do it's job */
 #define USB_COMMAND_TIMEOUT	250
 
 /* Watchdog's internal commands */
-#define CMD_READ_TEMP			0x02	/* Read Temperature; Re-trigger Watchdog */
+#define CMD_READ_TEMP			0x02	/* Read Temperature;
+							Re-trigger Watchdog */
 #define CMD_TRIGGER			CMD_READ_TEMP
 #define CMD_GET_STATUS			0x04	/* Get Status Information */
 #define CMD_GET_FIRMWARE_VERSION	0x08	/* Get Firmware Version */
 #define CMD_GET_DIP_SWITCH_SETTINGS	0x0c	/* Get Dip Switch Settings */
 #define CMD_READ_WATCHDOG_TIMEOUT	0x18	/* Read Current Watchdog Time */
-#define CMD_WRITE_WATCHDOG_TIMEOUT	0x19	/* Write Current Watchdog Time */
+#define CMD_WRITE_WATCHDOG_TIMEOUT	0x19	/* Write Current WatchdogTime */
 #define CMD_ENABLE_WATCHDOG		0x30	/* Enable / Disable Watchdog */
 #define CMD_DISABLE_WATCHDOG		CMD_ENABLE_WATCHDOG
 
@@ -129,23 +133,36 @@ static char expect_release;
 
 /* Structure to hold all of our device specific stuff */
 struct usb_pcwd_private {
-	struct usb_device	*udev;			/* save off the usb device pointer */
-	struct usb_interface	*interface;		/* the interface for this device */
-
-	unsigned int		interface_number;	/* the interface number used for cmd's */
-
-	unsigned char		*intr_buffer;		/* the buffer to intr data */
-	dma_addr_t		intr_dma;		/* the dma address for the intr buffer */
-	size_t			intr_size;		/* the size of the intr buffer */
-	struct urb		*intr_urb;		/* the urb used for the intr pipe */
-
-	unsigned char		cmd_command;		/* The command that is reported back */
-	unsigned char		cmd_data_msb;		/* The data MSB that is reported back */
-	unsigned char		cmd_data_lsb;		/* The data LSB that is reported back */
-	atomic_t		cmd_received;		/* true if we received a report after a command */
-
-	int			exists;			/* Wether or not the device exists */
-	struct mutex		mtx;			/* locks this structure */
+	/* save off the usb device pointer */
+	struct usb_device	*udev;
+	/* the interface for this device */
+	struct usb_interface	*interface;
+
+	/* the interface number used for cmd's */
+	unsigned int		interface_number;
+
+	/* the buffer to intr data */
+	unsigned char		*intr_buffer;
+	/* the dma address for the intr buffer */
+	dma_addr_t		intr_dma;
+	/* the size of the intr buffer */
+	size_t			intr_size;
+	/* the urb used for the intr pipe */
+	struct urb		*intr_urb;
+
+	/* The command that is reported back */
+	unsigned char		cmd_command;
+	/* The data MSB that is reported back */
+	unsigned char		cmd_data_msb;
+	/* The data LSB that is reported back */
+	unsigned char		cmd_data_lsb;
+	/* true if we received a report after a command */
+	atomic_t		cmd_received;
+
+	/* Wether or not the device exists */
+	int			exists;
+	/* locks this structure */
+	struct mutex		mtx;
 };
 static struct usb_pcwd_private *usb_pcwd_device;
 
@@ -153,7 +170,8 @@ static struct usb_pcwd_private *usb_pcwd_device;
 static DEFINE_MUTEX(disconnect_mutex);
 
 /* local function prototypes */
-static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_device_id *id);
+static int usb_pcwd_probe(struct usb_interface *interface,
+						const struct usb_device_id *id);
 static void usb_pcwd_disconnect(struct usb_interface *interface);
 
 /* usb specific object needed to register this driver with the usb subsystem */
@@ -167,7 +185,8 @@ static struct usb_driver usb_pcwd_driver = {
 
 static void usb_pcwd_intr_done(struct urb *urb)
 {
-	struct usb_pcwd_private *usb_pcwd = (struct usb_pcwd_private *)urb->context;
+	struct usb_pcwd_private *usb_pcwd =
+				(struct usb_pcwd_private *)urb->context;
 	unsigned char *data = usb_pcwd->intr_buffer;
 	int retval;
 
@@ -178,11 +197,13 @@ static void usb_pcwd_intr_done(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__,
+								urb->status);
 		return;
 	/* -EPIPE:  should clear the halt */
 	default:		/* error */
-		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__,
+								urb->status);
 		goto resubmit;
 	}
 
@@ -199,22 +220,23 @@ static void usb_pcwd_intr_done(struct urb *urb)
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		printk(KERN_ERR PFX "can't resubmit intr, usb_submit_urb failed with result %d\n",
-			retval);
+		printk(KERN_ERR PFX "can't resubmit intr, "
+			"usb_submit_urb failed with result %d\n", retval);
 }
 
-static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd, unsigned char cmd,
-	unsigned char *msb, unsigned char *lsb)
+static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd,
+		unsigned char cmd, unsigned char *msb, unsigned char *lsb)
 {
 	int got_response, count;
 	unsigned char buf[6];
 
-	/* We will not send any commands if the USB PCWD device does not exist */
+	/* We will not send any commands if the USB PCWD device does
+	 * not exist */
 	if ((!usb_pcwd) || (!usb_pcwd->exists))
 		return -1;
 
-	/* The USB PC Watchdog uses a 6 byte report format. The board currently uses
-	 * only 3 of the six bytes of the report. */
+	/* The USB PC Watchdog uses a 6 byte report format.
+	 * The board currently uses only 3 of the six bytes of the report. */
 	buf[0] = cmd;			/* Byte 0 = CMD */
 	buf[1] = *msb;			/* Byte 1 = Data MSB */
 	buf[2] = *lsb;			/* Byte 2 = Data LSB */
@@ -229,12 +251,14 @@ static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd, unsigned cha
 			HID_REQ_SET_REPORT, HID_DT_REPORT,
 			0x0200, usb_pcwd->interface_number, buf, sizeof(buf),
 			USB_COMMAND_TIMEOUT) != sizeof(buf)) {
-		dbg("usb_pcwd_send_command: error in usb_control_msg for cmd 0x%x 0x%x 0x%x\n", cmd, *msb, *lsb);
+		dbg("usb_pcwd_send_command: error in usb_control_msg for "
+				"cmd 0x%x 0x%x 0x%x\n", cmd, *msb, *lsb);
 	}
 	/* wait till the usb card processed the command,
 	 * with a max. timeout of USB_COMMAND_TIMEOUT */
 	got_response = 0;
-	for (count = 0; (count < USB_COMMAND_TIMEOUT) && (!got_response); count++) {
+	for (count = 0; (count < USB_COMMAND_TIMEOUT) && (!got_response);
+								count++) {
 		mdelay(1);
 		if (atomic_read(&usb_pcwd->cmd_received))
 			got_response = 1;
@@ -256,10 +280,12 @@ static int usb_pcwd_start(struct usb_pcwd_private *usb_pcwd)
 	int retval;
 
 	/* Enable Watchdog */
-	retval = usb_pcwd_send_command(usb_pcwd, CMD_ENABLE_WATCHDOG, &msb, &lsb);
+	retval = usb_pcwd_send_command(usb_pcwd, CMD_ENABLE_WATCHDOG,
+								&msb, &lsb);
 
 	if ((retval == 0) || (lsb == 0)) {
-		printk(KERN_ERR PFX "Card did not acknowledge enable attempt\n");
+		printk(KERN_ERR PFX
+				"Card did not acknowledge enable attempt\n");
 		return -1;
 	}
 
@@ -273,10 +299,12 @@ static int usb_pcwd_stop(struct usb_pcwd_private *usb_pcwd)
 	int retval;
 
 	/* Disable Watchdog */
-	retval = usb_pcwd_send_command(usb_pcwd, CMD_DISABLE_WATCHDOG, &msb, &lsb);
+	retval = usb_pcwd_send_command(usb_pcwd, CMD_DISABLE_WATCHDOG,
+								&msb, &lsb);
 
 	if ((retval == 0) || (lsb != 0)) {
-		printk(KERN_ERR PFX "Card did not acknowledge disable attempt\n");
+		printk(KERN_ERR PFX
+			"Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
@@ -308,7 +336,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 	return 0;
 }
 
-static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd, int *temperature)
+static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
+							int *temperature)
 {
 	unsigned char msb, lsb;
 
@@ -323,7 +352,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd, int *temp
 	return 0;
 }
 
-static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd, int *time_left)
+static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
+								int *time_left)
 {
 	unsigned char msb, lsb;
 
@@ -341,7 +371,7 @@ static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd, int *time_le
  */
 
 static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
-			      size_t len, loff_t *ppos)
+						size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
@@ -352,7 +382,8 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 			 * five months ago... */
 			expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			 * magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data + i))
@@ -431,7 +462,7 @@ static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		if (usb_pcwd_set_heartbeat(usb_pcwd_device, new_heartbeat))
-		    return -EINVAL;
+			return -EINVAL;
 
 		usb_pcwd_keepalive(usb_pcwd_device);
 		/* Fall */
@@ -475,7 +506,8 @@ static int usb_pcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		usb_pcwd_stop(usb_pcwd_device);
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		usb_pcwd_keepalive(usb_pcwd_device);
 	}
 	expect_release = 0;
@@ -515,7 +547,8 @@ static int usb_pcwd_temperature_release(struct inode *inode, struct file *file)
  *	Notify system
  */
 
-static int usb_pcwd_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int usb_pcwd_notify_sys(struct notifier_block *this, unsigned long code,
+								void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		usb_pcwd_stop(usb_pcwd_device);	/* Turn the WDT off */
@@ -578,7 +611,8 @@ static inline void usb_pcwd_delete(struct usb_pcwd_private *usb_pcwd)
  *	Called by the usb core when a new device is connected that it thinks
  *	this driver might be interested in.
  */
-static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_device_id *id)
+static int usb_pcwd_probe(struct usb_interface *interface,
+						const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct usb_host_interface *iface_desc;
@@ -602,16 +636,15 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 
 	/* check out that we have a HID device */
 	if (!(iface_desc->desc.bInterfaceClass == USB_CLASS_HID)) {
-		printk(KERN_ERR PFX "The device isn't a Human Interface Device\n");
+		printk(KERN_ERR PFX
+			"The device isn't a Human Interface Device\n");
 		return -ENODEV;
 	}
 
 	/* check out the endpoint: it has to be Interrupt & IN */
 	endpoint = &iface_desc->endpoint[0].desc;
 
-	if (!((endpoint->bEndpointAddress & USB_DIR_IN) &&
-	     ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-				== USB_ENDPOINT_XFER_INT))) {
+	if (!usb_endpoint_is_int_in(endpoint)) {
 		/* we didn't find a Interrupt endpoint with direction IN */
 		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
 		return -ENODEV;
@@ -634,10 +667,12 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	usb_pcwd->udev = udev;
 	usb_pcwd->interface = interface;
 	usb_pcwd->interface_number = iface_desc->desc.bInterfaceNumber;
-	usb_pcwd->intr_size = (le16_to_cpu(endpoint->wMaxPacketSize) > 8 ? le16_to_cpu(endpoint->wMaxPacketSize) : 8);
+	usb_pcwd->intr_size = (le16_to_cpu(endpoint->wMaxPacketSize) > 8 ?
+				le16_to_cpu(endpoint->wMaxPacketSize) : 8);
 
 	/* set up the memory buffer's */
-	usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size, GFP_ATOMIC, &usb_pcwd->intr_dma);
+	usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size,
+					GFP_ATOMIC, &usb_pcwd->intr_dma);
 	if (!usb_pcwd->intr_buffer) {
 		printk(KERN_ERR PFX "Out of memory\n");
 		goto error;
@@ -671,7 +706,8 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	usb_pcwd_stop(usb_pcwd);
 
 	/* Get the Firmware Version */
-	got_fw_rev = usb_pcwd_send_command(usb_pcwd, CMD_GET_FIRMWARE_VERSION, &fw_rev_major, &fw_rev_minor);
+	got_fw_rev = usb_pcwd_send_command(usb_pcwd, CMD_GET_FIRMWARE_VERSION,
+						&fw_rev_major, &fw_rev_minor);
 	if (got_fw_rev)
 		sprintf(fw_ver_str, "%u.%02u", fw_rev_major, fw_rev_minor);
 	else
@@ -681,9 +717,11 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 		fw_ver_str);
 
 	/* Get switch settings */
-	usb_pcwd_send_command(usb_pcwd, CMD_GET_DIP_SWITCH_SETTINGS, &dummy, &option_switches);
+	usb_pcwd_send_command(usb_pcwd, CMD_GET_DIP_SWITCH_SETTINGS, &dummy,
+							&option_switches);
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
+	printk(KERN_INFO PFX "Option switches (0x%02x): "
+		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
@@ -692,30 +730,35 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	if (heartbeat == 0)
 		heartbeat = heartbeat_tbl[(option_switches & 0x07)];
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range ;
+	 * if not reset to the default */
 	if (usb_pcwd_set_heartbeat(usb_pcwd, heartbeat)) {
 		usb_pcwd_set_heartbeat(usb_pcwd, WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 0<heartbeat<65536, using %d\n",
+		printk(KERN_INFO PFX
+			"heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	retval = register_reboot_notifier(&usb_pcwd_notifier);
 	if (retval != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n",
 			retval);
 		goto error;
 	}
 
 	retval = misc_register(&usb_pcwd_temperature_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
 			TEMP_MINOR, retval);
 		goto err_out_unregister_reboot;
 	}
 
 	retval = misc_register(&usb_pcwd_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, retval);
 		goto err_out_misc_deregister;
 	}
@@ -801,7 +844,7 @@ static int __init usb_pcwd_init(void)
 		return result;
 	}
 
-	printk(KERN_INFO PFX DRIVER_DESC " v" DRIVER_VERSION " (" DRIVER_DATE ")\n");
+	printk(KERN_INFO PFX DRIVER_DESC " v" DRIVER_VERSION "\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6d9f3d4..6413519 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -54,22 +54,22 @@
 
 /* WDTIM_CTRL bit definitions */
 #define COUNT_ENAB     1
-#define RESET_COUNT    (1<<1)
-#define DEBUG_EN       (1<<2)
+#define RESET_COUNT    (1 << 1)
+#define DEBUG_EN       (1 << 2)
 
 /* WDTIM_MCTRL bit definitions */
 #define MR0_INT        1
 #undef  RESET_COUNT0
-#define RESET_COUNT0   (1<<2)
-#define STOP_COUNT0    (1<<2)
-#define M_RES1         (1<<3)
-#define M_RES2         (1<<4)
-#define RESFRC1        (1<<5)
-#define RESFRC2        (1<<6)
+#define RESET_COUNT0   (1 << 2)
+#define STOP_COUNT0    (1 << 2)
+#define M_RES1         (1 << 3)
+#define M_RES2         (1 << 4)
+#define RESFRC1        (1 << 5)
+#define RESFRC2        (1 << 6)
 
 /* WDTIM_EMR bit definitions */
 #define EXT_MATCH0      1
-#define MATCH_OUTPUT_HIGH (2<<4)	/*a MATCH_CTRL setting */
+#define MATCH_OUTPUT_HIGH (2 << 4)	/*a MATCH_CTRL setting */
 
 /* WDTIM_RES bit definitions */
 #define WDOG_RESET      1	/* read only */
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f3553fa..f6cccc9 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -17,27 +17,29 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/reboot.h>
-#include <linux/smp_lock.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/uaccess.h>
-
-#include <asm/bootinfo.h>
-#include <asm/time.h>
-#include <asm/mach-rc32434/integ.h>
-
-#define VERSION "0.4"
+#include <linux/module.h>		/* For module specific items */
+#include <linux/moduleparam.h>		/* For new moduleparam's */
+#include <linux/types.h>		/* For standard types (like size_t) */
+#include <linux/errno.h>		/* For the -ENODEV/... values */
+#include <linux/kernel.h>		/* For printk/panic/... */
+#include <linux/fs.h>			/* For file operations */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
+#include <linux/watchdog.h>		/* For the watchdog specific items */
+#include <linux/init.h>			/* For __init/__exit/... */
+#include <linux/platform_device.h>	/* For platform_driver framework */
+#include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+
+#include <asm/mach-rc32434/integ.h>	/* For the Watchdog registers */
+
+#define PFX KBUILD_MODNAME ": "
+
+#define VERSION "1.0"
 
 static struct {
 	unsigned long inuse;
+	spinlock_t io_lock;
 } rc32434_wdt_device;
 
 static struct integ __iomem *wdt_reg;
@@ -58,6 +60,9 @@ extern unsigned int idt_cpu_freq;
 #define WATCHDOG_TIMEOUT 20
 
 static int timeout = WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout value, in seconds (default="
+		WATCHDOG_TIMEOUT ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -68,10 +73,29 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 #define SET_BITS(addr, or, nand) \
 	writel((readl(&addr) | or) & ~nand, &addr)
 
+static int rc32434_wdt_set(int new_timeout)
+{
+	int max_to = WTCOMP2SEC((u32)-1);
+
+	if (new_timeout < 0 || new_timeout > max_to) {
+		printk(KERN_ERR PFX "timeout value must be between 0 and %d",
+			max_to);
+		return -EINVAL;
+	}
+	timeout = new_timeout;
+	spin_lock(&rc32434_wdt_device.io_lock);
+	writel(SEC2WTCOMP(timeout), &wdt_reg->wtcompare);
+	spin_unlock(&rc32434_wdt_device.io_lock);
+
+	return 0;
+}
+
 static void rc32434_wdt_start(void)
 {
 	u32 or, nand;
 
+	spin_lock(&rc32434_wdt_device.io_lock);
+
 	/* zero the counter before enabling */
 	writel(0, &wdt_reg->wtcount);
 
@@ -85,38 +109,35 @@ static void rc32434_wdt_start(void)
 
 	SET_BITS(wdt_reg->errcs, or, nand);
 
+	/* set the timeout (either default or based on module param) */
+	rc32434_wdt_set(timeout);
+
 	/* reset WTC timeout bit and enable WDT */
 	nand = 1 << RC32434_WTC_TO;
 	or = 1 << RC32434_WTC_EN;
 
 	SET_BITS(wdt_reg->wtc, or, nand);
+
+	spin_unlock(&rc32434_wdt_device.io_lock);
+	printk(KERN_INFO PFX "Started watchdog timer.\n");
 }
 
 static void rc32434_wdt_stop(void)
 {
+	spin_lock(&rc32434_wdt_device.io_lock);
+
 	/* Disable WDT */
 	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
-}
-
-static int rc32434_wdt_set(int new_timeout)
-{
-	int max_to = WTCOMP2SEC((u32)-1);
-
-	if (new_timeout < 0 || new_timeout > max_to) {
-		printk(KERN_ERR KBUILD_MODNAME
-			": timeout value must be between 0 and %d",
-			max_to);
-		return -EINVAL;
-	}
-	timeout = new_timeout;
-	writel(SEC2WTCOMP(timeout), &wdt_reg->wtcompare);
 
-	return 0;
+	spin_unlock(&rc32434_wdt_device.io_lock);
+	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
 }
 
 static void rc32434_wdt_ping(void)
 {
+	spin_lock(&rc32434_wdt_device.io_lock);
 	writel(0, &wdt_reg->wtcount);
+	spin_unlock(&rc32434_wdt_device.io_lock);
 }
 
 static int rc32434_wdt_open(struct inode *inode, struct file *file)
@@ -137,11 +158,10 @@ static int rc32434_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		rc32434_wdt_stop();
-		printk(KERN_INFO KBUILD_MODNAME ": disabling watchdog timer\n");
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT KBUILD_MODNAME
-			": device closed unexpectedly. WDT will not stop !\n");
+		printk(KERN_CRIT PFX
+			"device closed unexpectedly. WDT will not stop!\n");
 		rc32434_wdt_ping();
 	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
@@ -185,8 +205,9 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 		.identity =		"RC32434_WDT Watchdog",
 	};
 	switch (cmd) {
-	case WDIOC_KEEPALIVE:
-		rc32434_wdt_ping();
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
 		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
@@ -194,10 +215,6 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (copy_to_user(argp, &value, sizeof(int)))
 			return -EFAULT;
 		break;
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		break;
 	case WDIOC_SETOPTIONS:
 		if (copy_from_user(&value, argp, sizeof(int)))
 			return -EFAULT;
@@ -212,6 +229,9 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 			return -EINVAL;
 		}
 		break;
+	case WDIOC_KEEPALIVE:
+		rc32434_wdt_ping();
+		break;
 	case WDIOC_SETTIMEOUT:
 		if (copy_from_user(&new_timeout, argp, sizeof(int)))
 			return -EFAULT;
@@ -227,7 +247,7 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 	return 0;
 }
 
-static struct file_operations rc32434_wdt_fops = {
+static const struct file_operations rc32434_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= rc32434_wdt_write,
@@ -242,8 +262,8 @@ static struct miscdevice rc32434_wdt_miscdev = {
 	.fops	= &rc32434_wdt_fops,
 };
 
-static char banner[] __devinitdata = KERN_INFO KBUILD_MODNAME
-		": Watchdog Timer version " VERSION ", timer margin: %d sec\n";
+static char banner[] __devinitdata = KERN_INFO PFX
+		"Watchdog Timer version " VERSION ", timer margin: %d sec\n";
 
 static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
@@ -252,22 +272,33 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
-		printk(KERN_ERR KBUILD_MODNAME
-			"failed to retrieve resources\n");
+		printk(KERN_ERR PFX "failed to retrieve resources\n");
 		return -ENODEV;
 	}
 
 	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
 	if (!wdt_reg) {
-		printk(KERN_ERR KBUILD_MODNAME
-			"failed to remap I/O resources\n");
+		printk(KERN_ERR PFX "failed to remap I/O resources\n");
 		return -ENXIO;
 	}
 
+	spin_lock_init(&rc32434_wdt_device.io_lock);
+
+	/* Make sure the watchdog is not running */
+	rc32434_wdt_stop();
+
+	/* Check that the heartbeat value is within it's range;
+	 * if not reset to the default */
+	if (rc32434_wdt_set(timeout)) {
+		rc32434_wdt_set(WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+			"timeout value must be between 0 and %d\n",
+			WTCOMP2SEC((u32)-1));
+	}
+
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR KBUILD_MODNAME
-			"failed to register watchdog device\n");
+		printk(KERN_ERR PFX "failed to register watchdog device\n");
 		goto unmap;
 	}
 
@@ -287,22 +318,28 @@ static int __devexit rc32434_wdt_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver rc32434_wdt = {
-	.probe	= rc32434_wdt_probe,
-	.remove	= __devexit_p(rc32434_wdt_remove),
-	.driver	= {
-		.name = "rc32434_wdt",
+static void rc32434_wdt_shutdown(struct platform_device *pdev)
+{
+	rc32434_wdt_stop();
+}
+
+static struct platform_driver rc32434_wdt_driver = {
+	.probe		= rc32434_wdt_probe,
+	.remove		= __devexit_p(rc32434_wdt_remove),
+	.shutdown	= rc32434_wdt_shutdown,
+	.driver		= {
+			.name = "rc32434_wdt",
 	}
 };
 
 static int __init rc32434_wdt_init(void)
 {
-	return platform_driver_register(&rc32434_wdt);
+	return platform_driver_register(&rc32434_wdt_driver);
 }
 
 static void __exit rc32434_wdt_exit(void)
 {
-	platform_driver_unregister(&rc32434_wdt);
+	platform_driver_unregister(&rc32434_wdt_driver);
 }
 
 module_init(rc32434_wdt_init);
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 09cb183..1e8f02f 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -14,9 +14,8 @@
 #include <linux/watchdog.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 
 /* RIO uses the NatSemi Super I/O power management logical device
@@ -86,8 +85,7 @@ static int riowd_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int riowd_ioctl(struct inode *inode, struct file *filp,
-		       unsigned int cmd, unsigned long arg)
+static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
@@ -147,7 +145,8 @@ static int riowd_ioctl(struct inode *inode, struct file *filp,
 	return 0;
 }
 
-static ssize_t riowd_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t riowd_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	struct riowd *p = riowd_device;
 
@@ -160,12 +159,12 @@ static ssize_t riowd_write(struct file *file, const char __user *buf, size_t cou
 }
 
 static const struct file_operations riowd_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.ioctl =	riowd_ioctl,
-	.open =		riowd_open,
-	.write =	riowd_write,
-	.release =	riowd_release,
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.unlocked_ioctl =	riowd_ioctl,
+	.open =			riowd_open,
+	.write =		riowd_write,
+	.release =		riowd_release,
 };
 
 static struct miscdevice riowd_miscdev = {
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index e19b457..5bd782f 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -1,8 +1,8 @@
 /*
  *	Watchdog driver for the SA11x0/PXA2xx
  *
- *      (c) Copyright 2000 Oleg Drokin <green@crimea.edu>
- *          Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
+ *	(c) Copyright 2000 Oleg Drokin <green@crimea.edu>
+ *	    Based on SoftDog driver by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -15,7 +15,7 @@
  *
  *	(c) Copyright 2000           Oleg Drokin <green@crimea.edu>
  *
- *      27/11/2000 Initial release
+ *	27/11/2000 Initial release
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 3266daa..d1c390c 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -1,7 +1,7 @@
 /*
  *	60xx Single Board Computer Watchdog Timer driver for Linux 2.2.x
  *
- *      Based on acquirewdt.c by Alan Cox.
+ *	Based on acquirewdt.c by Alan Cox.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index ae74f6b..b6e6799 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -4,12 +4,12 @@
  *	(c) Copyright 2005 Webcon, Inc.
  *
  *	Based on ib700wdt.c, which is based on advantechwdt.c which is based
- *      on acquirewdt.c which is based on wdt.c.
+ *	on acquirewdt.c which is based on wdt.c.
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
@@ -30,9 +30,9 @@
  *
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
- *      14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
- *           Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *           Added timeout module option to override default
+ *	14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
+ *	     Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *	     Added timeout module option to override default
  *
  */
 
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 06553de..e467ddc 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -35,7 +35,8 @@ static int epx_c3_alive;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+					__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define EPXC3_WATCHDOG_CTL_REG 0x1ee /* write 1 to enable, 0 to disable */
 #define EPXC3_WATCHDOG_PET_REG 0x1ef /* write anything to pet once enabled */
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 23da3cc..b5e19c1 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -71,7 +71,7 @@
 #define UART2_IRQ	0x04	/* Serial1 */
 /* 5 -7 are reserved */
 
-static char banner[] __initdata = KERN_INFO PFX SC1200_MODULE_VER;
+static char banner[] __initdata = PFX SC1200_MODULE_VER;
 static int timeout = 1;
 static int io = -1;
 static int io_len = 2;		/* for non plug and play */
@@ -392,7 +392,7 @@ static int __init sc1200wdt_init(void)
 {
 	int ret;
 
-	printk("%s\n", banner);
+	printk(KERN_INFO "%s\n", banner);
 
 #if defined CONFIG_PNP
 	if (isapnp) {
@@ -477,6 +477,7 @@ module_init(sc1200wdt_init);
 module_exit(sc1200wdt_exit);
 
 MODULE_AUTHOR("Zwane Mwaikambo <zwane@commfireservices.com>");
-MODULE_DESCRIPTION("Driver for National Semiconductor PC87307/PC97307 watchdog component");
+MODULE_DESCRIPTION(
+	"Driver for National Semiconductor PC87307/PC97307 watchdog component");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index a2b6c10..52b63f2 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -1,8 +1,8 @@
 /*
  *	AMD Elan SC520 processor Watchdog Timer driver
  *
- *      Based on acquirewdt.c by Alan Cox,
- *           and sbc60xxwdt.c by Jakob Oestergaard <jakob@unthought.net>
+ *	Based on acquirewdt.c by Alan Cox,
+ *	     and sbc60xxwdt.c by Jakob Oestergaard <jakob@unthought.net>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -11,7 +11,7 @@
  *
  *	The authors do NOT admit liability nor provide warranty for
  *	any of this software. This material is provided "AS-IS" in
- *      the hope that it may be useful for others.
+ *	the hope that it may be useful for others.
  *
  *	(c) Copyright 2001    Scott Jennings <linuxdrivers@oro.net>
  *           9/27 - 2001      [Initial release]
@@ -438,6 +438,7 @@ module_init(sc520_wdt_init);
 module_exit(sc520_wdt_unload);
 
 MODULE_AUTHOR("Scott and Bill Jennings");
-MODULE_DESCRIPTION("Driver for watchdog timer in AMD \"Elan\" SC520 uProcessor");
+MODULE_DESCRIPTION(
+	"Driver for watchdog timer in AMD \"Elan\" SC520 uProcessor");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 2e56cad..8a1f0bc 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -2,7 +2,7 @@
  *	SMsC 37B787 Watchdog Timer driver for Linux 2.6.x.x
  *
  *	Based on acquirewdt.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
- *       and some other existing drivers
+ *	and some other existing drivers
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -11,7 +11,7 @@
  *
  *	The authors do NOT admit liability nor provide warranty for
  *	any of this software. This material is provided "AS-IS" in
- *      the hope that it may be useful for others.
+ *	the hope that it may be useful for others.
  *
  *	(C) Copyright 2003-2006  Sven Anders <anders@anduras.de>
  *
@@ -22,19 +22,19 @@
  *
  *  Theory of operation:
  *
- *      A Watchdog Timer (WDT) is a hardware circuit that can
- *      reset the computer system in case of a software fault.
- *      You probably knew that already.
+ *	A Watchdog Timer (WDT) is a hardware circuit that can
+ *	reset the computer system in case of a software fault.
+ *	You probably knew that already.
  *
- *      Usually a userspace daemon will notify the kernel WDT driver
- *      via the /dev/watchdog special device file that userspace is
- *      still alive, at regular intervals.  When such a notification
- *      occurs, the driver will usually tell the hardware watchdog
- *      that everything is in order, and that the watchdog should wait
- *      for yet another little while to reset the system.
- *      If userspace fails (RAM error, kernel bug, whatever), the
- *      notifications cease to occur, and the hardware watchdog will
- *      reset the system (causing a reboot) after the timeout occurs.
+ *	Usually a userspace daemon will notify the kernel WDT driver
+ *	via the /dev/watchdog special device file that userspace is
+ *	still alive, at regular intervals.  When such a notification
+ *	occurs, the driver will usually tell the hardware watchdog
+ *	that everything is in order, and that the watchdog should wait
+ *	for yet another little while to reset the system.
+ *	If userspace fails (RAM error, kernel bug, whatever), the
+ *	notifications cease to occur, and the hardware watchdog will
+ *	reset the system (causing a reboot) after the timeout occurs.
  *
  * Create device with:
  *  mknod /dev/watchdog c 10 130
@@ -485,7 +485,7 @@ static long wb_smsc_wdt_ioctl(struct file *file,
 	case WDIOC_GETTIMEOUT:
 		new_timeout = timeout;
 		if (unit == UNIT_MINUTE)
-			  new_timeout *= 60;
+			new_timeout *= 60;
 		return put_user(new_timeout, uarg.i);
 	default:
 		return -ENOTTY;
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 7204f96..ebcc9ce 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -1,7 +1,8 @@
 /*
  *	SoftDog	0.07:	A Software Watchdog Device
  *
- *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>, All Rights Reserved.
+ *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *							All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -32,7 +33,7 @@
  *	Added WDIOC_GETTIMEOUT and WDIOC_SETTIMOUT.
  *
  *  20020530 Joel Becker <joel.becker@oracle.com>
- *  	Added Matt Domsch's nowayout module option.
+ *	Added Matt Domsch's nowayout module option.
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 3c7aa41..a9c7f35 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -462,6 +462,7 @@ module_init(wdt_init);
 module_exit(wdt_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marcus Junker <junker@anduras.de>, Samuel Tardieu <sam@rfc1149.net>");
+MODULE_AUTHOR("Marcus Junker <junker@anduras.de>, "
+		"Samuel Tardieu <sam@rfc1149.net>");
 MODULE_DESCRIPTION("w83697hf/hg WDT driver");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index ada8ad8..883b5f7 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -2,7 +2,7 @@
  *	w83697ug/uf WDT driver
  *
  *	(c) Copyright 2008 Flemming Fransen <ff@nrvissing.net>
- *              reused original code to supoprt w83697ug/uf.
+ *		reused original code to support w83697ug/uf.
  *
  *	Based on w83627hf_wdt.c which is based on advantechwdt.c
  *	which is based on wdt.c.
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(nowayout,
 							(same as EFER) */
 #define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
 
-static void w83697ug_select_wd_register(void)
+static int w83697ug_select_wd_register(void)
 {
 	unsigned char c;
 	unsigned char version;
@@ -102,7 +102,7 @@ static void w83697ug_select_wd_register(void)
 
 	} else {
 		printk(KERN_ERR PFX "No W83697UG/UF could be found\n");
-		return;
+		return -ENODEV;
 	}
 
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
@@ -110,6 +110,8 @@ static void w83697ug_select_wd_register(void)
 	outb_p(0x30, WDT_EFER); /* select CR30 */
 	c = inb_p(WDT_EFDR);
 	outb_p(c || 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+
+	return 0;
 }
 
 static void w83697ug_unselect_wd_register(void)
@@ -117,11 +119,14 @@ static void w83697ug_unselect_wd_register(void)
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
-static void w83697ug_init(void)
+static int w83697ug_init(void)
 {
+	int ret;
 	unsigned char t;
 
-	w83697ug_select_wd_register();
+	ret = w83697ug_select_wd_register();
+	if (ret != 0)
+		return ret;
 
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);    /* read CRF6 */
@@ -137,13 +142,15 @@ static void w83697ug_init(void)
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
 	w83697ug_unselect_wd_register();
+	return 0;
 }
 
 static void wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
 
-	w83697ug_select_wd_register();
+	if (w83697ug_select_wd_register() < 0)
+		return;
 
 	outb_p(0xF4, WDT_EFER);    /* Select CRF4 */
 	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF4 */
@@ -347,7 +354,9 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	w83697ug_init();
+	ret = w83697ug_init();
+	if (ret != 0)
+		goto unreg_regions;
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 2525da5..0560182 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -426,7 +426,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		if (wdt_set_timeout(new_timeout))
-		    return -EINVAL;
+			return -EINVAL;
 
 		wdt_keepalive();
 		/* Fall */
diff --git a/drivers/watchdog/wd501p.h b/drivers/watchdog/wd501p.h
index db34853..0e3a497 100644
--- a/drivers/watchdog/wd501p.h
+++ b/drivers/watchdog/wd501p.h
@@ -11,9 +11,9 @@
  *
  *	http://www.cymru.net
  *
- *	This driver is provided under the GNU General Public License, incorporated
- *	herein by reference. The driver is provided without warranty or
- *	support.
+ *	This driver is provided under the GNU General Public License,
+ *	incorporated herein by reference. The driver is provided without
+ *	warranty or support.
  *
  *	Release 0.04.
  *
@@ -39,13 +39,13 @@
 /* programmable outputs: */
 #define WDT_PROGOUT		(io+15)	/* wr=enable, rd=disable */
 
-								/* FAN 501 500 */
-#define WDC_SR_WCCR		1	/* Active low */	/*  X   X   X  */
-#define WDC_SR_TGOOD		2				/*  X   X   -  */
-#define WDC_SR_ISOI0		4				/*  X   X   X  */
-#define WDC_SR_ISII1		8				/*  X   X   X  */
-#define WDC_SR_FANGOOD		16				/*  X   -   -  */
-#define WDC_SR_PSUOVER		32	/* Active low */	/*  X   X   -  */
-#define WDC_SR_PSUUNDR		64	/* Active low */	/*  X   X   -  */
-#define WDC_SR_IRQ		128	/* Active low */	/*  X   X   X  */
+							 /* FAN 501 500 */
+#define WDC_SR_WCCR		1	/* Active low */ /*  X   X   X  */
+#define WDC_SR_TGOOD		2			 /*  X   X   -  */
+#define WDC_SR_ISOI0		4			 /*  X   X   X  */
+#define WDC_SR_ISII1		8			 /*  X   X   X  */
+#define WDC_SR_FANGOOD		16			 /*  X   -   -  */
+#define WDC_SR_PSUOVER		32	/* Active low */ /*  X   X   -  */
+#define WDC_SR_PSUUNDR		64	/* Active low */ /*  X   X   -  */
+#define WDC_SR_IRQ		128	/* Active low */ /*  X   X   X  */
 
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index eddb918..3bbefe9 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -1,5 +1,5 @@
 /*
- *	Industrial Computer Source WDT500/501 driver
+ *	Industrial Computer Source WDT501 driver
  *
  *	(c) Copyright 1996-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *						All Rights Reserved.
@@ -82,14 +82,16 @@ MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
 module_param(irq, int, 0);
 MODULE_PARM_DESC(irq, "WDT irq (default=11)");
 
-#ifdef CONFIG_WDT_501
 /* Support for the Fan Tachometer on the WDT501-P */
 static int tachometer;
-
 module_param(tachometer, int, 0);
 MODULE_PARM_DESC(tachometer,
 		"WDT501-P Fan Tachometer support (0=disable, default=0)");
-#endif /* CONFIG_WDT_501 */
+
+static int type = 500;
+module_param(type, int, 0);
+MODULE_PARM_DESC(type,
+		"WDT501-P Card type (500 or 501 , default=500)");
 
 /*
  *	Programming support
@@ -158,7 +160,7 @@ static int wdt_stop(void)
  *	reloading the cascade counter.
  */
 
-static int wdt_ping(void)
+static void wdt_ping(void)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
@@ -169,7 +171,6 @@ static int wdt_ping(void)
 	wdt_ctr_load(1, wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
 	spin_unlock_irqrestore(&wdt_lock, flags);
-	return 0;
 }
 
 /**
@@ -193,7 +194,6 @@ static int wdt_set_heartbeat(int t)
 
 /**
  *	wdt_get_status:
- *	@status:		the new status.
  *
  *	Extract the status information from a WDT watchdog device. There are
  *	several board variants so we have to know which bits are valid. Some
@@ -202,36 +202,35 @@ static int wdt_set_heartbeat(int t)
  *	we then map the bits onto the status ioctl flags.
  */
 
-static int wdt_get_status(int *status)
+static int wdt_get_status(void)
 {
 	unsigned char new_status;
+	int status = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wdt_lock, flags);
 	new_status = inb_p(WDT_SR);
 	spin_unlock_irqrestore(&wdt_lock, flags);
 
-	*status = 0;
 	if (new_status & WDC_SR_ISOI0)
-		*status |= WDIOF_EXTERN1;
+		status |= WDIOF_EXTERN1;
 	if (new_status & WDC_SR_ISII1)
-		*status |= WDIOF_EXTERN2;
-#ifdef CONFIG_WDT_501
-	if (!(new_status & WDC_SR_TGOOD))
-		*status |= WDIOF_OVERHEAT;
-	if (!(new_status & WDC_SR_PSUOVER))
-		*status |= WDIOF_POWEROVER;
-	if (!(new_status & WDC_SR_PSUUNDR))
-		*status |= WDIOF_POWERUNDER;
-	if (tachometer) {
-		if (!(new_status & WDC_SR_FANGOOD))
-			*status |= WDIOF_FANFAULT;
+		status |= WDIOF_EXTERN2;
+	if (type == 501) {
+		if (!(new_status & WDC_SR_TGOOD))
+			status |= WDIOF_OVERHEAT;
+		if (!(new_status & WDC_SR_PSUOVER))
+			status |= WDIOF_POWEROVER;
+		if (!(new_status & WDC_SR_PSUUNDR))
+			status |= WDIOF_POWERUNDER;
+		if (tachometer) {
+			if (!(new_status & WDC_SR_FANGOOD))
+				status |= WDIOF_FANFAULT;
+		}
 	}
-#endif /* CONFIG_WDT_501 */
-	return 0;
+	return status;
 }
 
-#ifdef CONFIG_WDT_501
 /**
  *	wdt_get_temperature:
  *
@@ -239,7 +238,7 @@ static int wdt_get_status(int *status)
  *	farenheit. It was designed by an imperial measurement luddite.
  */
 
-static int wdt_get_temperature(int *temperature)
+static int wdt_get_temperature(void)
 {
 	unsigned short c;
 	unsigned long flags;
@@ -247,10 +246,18 @@ static int wdt_get_temperature(int *temperature)
 	spin_lock_irqsave(&wdt_lock, flags);
 	c = inb_p(WDT_RT);
 	spin_unlock_irqrestore(&wdt_lock, flags);
-	*temperature = (c * 11 / 15) + 7;
-	return 0;
+	return (c * 11 / 15) + 7;
+}
+
+static void wdt_decode_501(int status)
+{
+	if (!(status & WDC_SR_TGOOD))
+		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
+	if (!(status & WDC_SR_PSUOVER))
+		printk(KERN_CRIT "PSU over voltage.\n");
+	if (!(status & WDC_SR_PSUUNDR))
+		printk(KERN_CRIT "PSU under voltage.\n");
 }
-#endif /* CONFIG_WDT_501 */
 
 /**
  *	wdt_interrupt:
@@ -275,18 +282,13 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 
 	printk(KERN_CRIT "WDT status %d\n", status);
 
-#ifdef CONFIG_WDT_501
-	if (!(status & WDC_SR_TGOOD))
-		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
-	if (!(status & WDC_SR_PSUOVER))
-		printk(KERN_CRIT "PSU over voltage.\n");
-	if (!(status & WDC_SR_PSUUNDR))
-		printk(KERN_CRIT "PSU under voltage.\n");
-	if (tachometer) {
-		if (!(status & WDC_SR_FANGOOD))
-			printk(KERN_CRIT "Possible fan fault.\n");
+	if (type == 501) {
+		wdt_decode_501(status);
+		if (tachometer) {
+			if (!(status & WDC_SR_FANGOOD))
+				printk(KERN_CRIT "Possible fan fault.\n");
+		}
 	}
-#endif /* CONFIG_WDT_501 */
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
@@ -366,17 +368,18 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	/* Add options according to the card we have */
 	ident.options |= (WDIOF_EXTERN1|WDIOF_EXTERN2);
-#ifdef CONFIG_WDT_501
-	ident.options |= (WDIOF_OVERHEAT|WDIOF_POWERUNDER|WDIOF_POWEROVER);
-	if (tachometer)
-		ident.options |= WDIOF_FANFAULT;
-#endif /* CONFIG_WDT_501 */
+	if (type == 501) {
+		ident.options |= (WDIOF_OVERHEAT|WDIOF_POWERUNDER|
+							WDIOF_POWEROVER);
+		if (tachometer)
+			ident.options |= WDIOF_FANFAULT;
+	}
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
-		wdt_get_status(&status);
+		status = wdt_get_status();
 		return put_user(status, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
@@ -446,7 +449,6 @@ static int wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-#ifdef CONFIG_WDT_501
 /**
  *	wdt_temp_read:
  *	@file: file handle to the watchdog board
@@ -461,10 +463,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 static ssize_t wdt_temp_read(struct file *file, char __user *buf,
 						size_t count, loff_t *ptr)
 {
-	int temperature;
-
-	if (wdt_get_temperature(&temperature))
-		return -EFAULT;
+	int temperature = wdt_get_temperature();
 
 	if (copy_to_user(buf, &temperature, 1))
 		return -EFAULT;
@@ -497,7 +496,6 @@ static int wdt_temp_release(struct inode *inode, struct file *file)
 {
 	return 0;
 }
-#endif /* CONFIG_WDT_501 */
 
 /**
  *	notify_sys:
@@ -539,7 +537,6 @@ static struct miscdevice wdt_miscdev = {
 	.fops	= &wdt_fops,
 };
 
-#ifdef CONFIG_WDT_501
 static const struct file_operations wdt_temp_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -553,7 +550,6 @@ static struct miscdevice temp_miscdev = {
 	.name	= "temperature",
 	.fops	= &wdt_temp_fops,
 };
-#endif /* CONFIG_WDT_501 */
 
 /*
  *	The WDT card needs to learn about soft shutdowns in order to
@@ -577,9 +573,8 @@ static struct notifier_block wdt_notifier = {
 static void __exit wdt_exit(void)
 {
 	misc_deregister(&wdt_miscdev);
-#ifdef CONFIG_WDT_501
-	misc_deregister(&temp_miscdev);
-#endif /* CONFIG_WDT_501 */
+	if (type == 501)
+		misc_deregister(&temp_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
 	free_irq(irq, NULL);
 	release_region(io, 8);
@@ -597,12 +592,17 @@ static int __init wdt_init(void)
 {
 	int ret;
 
+	if (type != 500 && type != 501) {
+		printk(KERN_ERR "wdt: unknown card type '%d'.\n", type);
+		return -ENODEV;
+	}
+
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
 	if (wdt_set_heartbeat(heartbeat)) {
 		wdt_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO "wdt: heartbeat value must be 0 < heartbeat < 65536, using %d\n",
-			WD_TIMO);
+		printk(KERN_INFO "wdt: heartbeat value must be "
+			"0 < heartbeat < 65536, using %d\n", WD_TIMO);
 	}
 
 	if (!request_region(io, 8, "wdt501p")) {
@@ -625,15 +625,14 @@ static int __init wdt_init(void)
 		goto outirq;
 	}
 
-#ifdef CONFIG_WDT_501
-	ret = misc_register(&temp_miscdev);
-	if (ret) {
-		printk(KERN_ERR
-			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
-		goto outrbt;
+	if (type == 501) {
+		ret = misc_register(&temp_miscdev);
+		if (ret) {
+			printk(KERN_ERR "wdt: cannot register miscdev "
+				"on minor=%d (err=%d)\n", TEMP_MINOR, ret);
+			goto outrbt;
+		}
 	}
-#endif /* CONFIG_WDT_501 */
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret) {
@@ -643,28 +642,25 @@ static int __init wdt_init(void)
 		goto outmisc;
 	}
 
-	ret = 0;
-	printk(KERN_INFO "WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO "WDT500/501-P driver 0.10 "
+		"at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
 		io, irq, heartbeat, nowayout);
-#ifdef CONFIG_WDT_501
-	printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+	if (type == 501)
+		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
 				(tachometer ? "Enabled" : "Disabled"));
-#endif /* CONFIG_WDT_501 */
-
-out:
-	return ret;
+	return 0;
 
 outmisc:
-#ifdef CONFIG_WDT_501
-	misc_deregister(&temp_miscdev);
+	if (type == 501)
+		misc_deregister(&temp_miscdev);
 outrbt:
-#endif /* CONFIG_WDT_501 */
 	unregister_reboot_notifier(&wdt_notifier);
 outirq:
 	free_irq(irq, NULL);
 outreg:
 	release_region(io, 8);
-	goto out;
+out:
+	return ret;
 }
 
 module_init(wdt_init);
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 60e28d4..90ef70e 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -401,7 +401,7 @@ static long wdt977_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		if (wdt977_set_timeout(new_timeout))
-		    return -EINVAL;
+			return -EINVAL;
 
 		wdt977_keepalive();
 		/* Fall */

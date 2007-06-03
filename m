Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXFCNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXFCNLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXFCNL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 09:11:27 -0400
Received: from outmx039.isp.belgacom.be ([195.238.6.176]:35290 "EHLO
	outmx039.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXFCNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 09:11:25 -0400
Date: Sun, 3 Jun 2007 15:13:06 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] v2.6.22-rc3 updates
Message-ID: <20070603131305.GA3830@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I still have 1 new driver and 1 Documentation update for the watchdog device
drivers. This doesn't impact the current drivers.

So can you please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/pcwd-watchdog.txt |    8 
 Documentation/watchdog/watchdog-api.txt  |  236 +----------------------
 Documentation/watchdog/watchdog.txt      |   94 ---------
 Documentation/watchdog/wdt.txt           |   43 ++++
 drivers/char/watchdog/Kconfig            |    7 
 drivers/char/watchdog/Makefile           |    1 
 drivers/char/watchdog/ks8695_wdt.c       |  308 +++++++++++++++++++++++++++++++
 7 files changed, 376 insertions(+), 321 deletions(-)

with these Changes:

Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed May 23 14:43:52 2007 -0700

    [WATCHDOG] clean-up watchdog documentation
    
    Random sampling of some URLs in the Documentation tree to see how many were
    stale found that one watchdog driver was now a porn site.  In fact if the
    watchdogs document directory was any older it would be written in latin
    
    Clean it up somewhat and add Last reviewed headers, something all the
    Documentation could do with IMHO.
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Andrew Victor <andrew@sanpeople.com>
Date:   Mon May 14 14:45:25 2007 +0200

    [WATCHDOG] ks8695_wdt.c - new KS8695 watchdog driver
    
    Watchdog driver for the Kendin/Micrel KS8695 processor.
    
    Signed-off-by: Andrew Victor <andrew@sanpeople.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/pcwd-watchdog.txt b/Documentation/watchdog/pcwd-watchdog.txt
index d9ee633..4f68052 100644
--- a/Documentation/watchdog/pcwd-watchdog.txt
+++ b/Documentation/watchdog/pcwd-watchdog.txt
@@ -1,3 +1,5 @@
+Last reviewed: 10/05/2007
+
                      Berkshire Products PC Watchdog Card
                    Support for ISA Cards  Revision A and C
            Documentation and Driver by Ken Hollis <kenji@bitgate.com>
@@ -14,8 +16,8 @@
 
  The Watchdog Driver will automatically find your watchdog card, and will
  attach a running driver for use with that card.  After the watchdog
- drivers have initialized, you can then talk to the card using the PC
- Watchdog program, available from http://ftp.bitgate.com/pcwd/.
+ drivers have initialized, you can then talk to the card using a PC
+ Watchdog program.
 
  I suggest putting a "watchdog -d" before the beginning of an fsck, and
  a "watchdog -e -t 1" immediately after the end of an fsck.  (Remember
@@ -62,5 +64,3 @@
  -- Ken Hollis
     (kenji@bitgate.com)
 
-(This documentation may be out of date.  Check
- http://ftp.bitgate.com/pcwd/ for the absolute latest additions.)
diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index 8d16f6f..bb7cb1d 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -1,3 +1,6 @@
+Last reviewed: 10/05/2007
+
+
 The Linux Watchdog driver API.
 
 Copyright 2002 Christer Weingel <wingel@nano-system.com>
@@ -22,7 +25,7 @@ the system.  If userspace fails (RAM error, kernel bug, whatever), the
 notifications cease to occur, and the hardware watchdog will reset the
 system (causing a reboot) after the timeout occurs.
 
-The Linux watchdog API is a rather AD hoc construction and different
+The Linux watchdog API is a rather ad-hoc construction and different
 drivers implement different, and sometimes incompatible, parts of it.
 This file is an attempt to document the existing usage and allow
 future driver writers to use it as a reference.
@@ -46,14 +49,16 @@ some of the drivers support the configuration option "Disable watchdog
 shutdown on close", CONFIG_WATCHDOG_NOWAYOUT.  If it is set to Y when
 compiling the kernel, there is no way of disabling the watchdog once
 it has been started.  So, if the watchdog daemon crashes, the system
-will reboot after the timeout has passed.
+will reboot after the timeout has passed. Watchdog devices also usually
+support the nowayout module parameter so that this option can be controlled
+at runtime.
 
-Some other drivers will not disable the watchdog, unless a specific
-magic character 'V' has been sent /dev/watchdog just before closing
-the file.  If the userspace daemon closes the file without sending
-this special character, the driver will assume that the daemon (and
-userspace in general) died, and will stop pinging the watchdog without
-disabling it first.  This will then cause a reboot.
+Drivers will not disable the watchdog, unless a specific magic character 'V'
+has been sent /dev/watchdog just before closing the file.  If the userspace
+daemon closes the file without sending this special character, the driver
+will assume that the daemon (and userspace in general) died, and will stop
+pinging the watchdog without disabling it first.  This will then cause a
+reboot if the watchdog is not re-opened in sufficient time.
 
 The ioctl API:
 
@@ -227,218 +232,3 @@ The following options are available:
 
 [FIXME -- better explanations]
 
-Implementations in the current drivers in the kernel tree:
-
-Here I have tried to summarize what the different drivers support and
-where they do strange things compared to the other drivers.
-
-acquirewdt.c -- Acquire Single Board Computer
-
-	This driver has a hardcoded timeout of 1 minute
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns KEEPALIVEPING.  GETSTATUS will return 1 if
-	the device is open, 0 if not.  [FIXME -- isn't this rather
-	silly?  To be able to use the ioctl, the device must be open
-	and so GETSTATUS will always return 1].
-
-advantechwdt.c -- Advantech Single Board Computer
-
-	Timeout that defaults to 60 seconds, supports SETTIMEOUT.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-	[FIXME -- silliness again?]
-	
-booke_wdt.c -- PowerPC BookE Watchdog Timer
-
-	Timeout default varies according to frequency, supports
-	SETTIMEOUT
-
-	Watchdog cannot be turned off, CONFIG_WATCHDOG_NOWAYOUT
-	does not make sense
-
-	GETSUPPORT returns the watchdog_info struct, and
-	GETSTATUS returns the supported options. GETBOOTSTATUS
-	returns a 1 if the last reset was caused by the
-	watchdog and a 0 otherwise. This watchdog cannot be
-	disabled once it has been started. The wdt_period kernel
-	parameter selects which bit of the time base changing
-	from 0->1 will trigger the watchdog exception. Changing
-	the timeout from the ioctl calls will change the
-	wdt_period as defined above. Finally if you would like to
-	replace the default Watchdog Handler you can implement the
-	WatchdogHandler() function in your own code.
-
-eurotechwdt.c -- Eurotech CPU-1220/1410
-
-	The timeout can be set using the SETTIMEOUT ioctl and defaults
-	to 60 seconds.
-
-	Also has a module parameter "ev", event type which controls
-	what should happen on a timeout, the string "int" or anything
-	else that causes a reboot.  [FIXME -- better description]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns CARDRESET and WDIOF_SETTIMEOUT but
-	GETSTATUS is not supported and GETBOOTSTATUS just returns 0.
-
-i810-tco.c -- Intel 810 chipset
-
-	Also has support for a lot of other i8x0 stuff, but the
-	watchdog is one of the things.
-
-	The timeout is set using the module parameter "i810_margin",
-	which is in steps of 0.6 seconds where 2<i810_margin<64.  The
-	driver supports the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT.
-
-	GETSUPPORT returns WDIOF_SETTIMEOUT.  The GETSTATUS call
-	returns some kind of timer value which ist not compatible with
-	the other drivers.  GETBOOT status returns some kind of
-	hardware specific boot status.  [FIXME -- describe this]
-
-ib700wdt.c -- IB700 Single Board Computer
-
-	Default timeout of 30 seconds and the timeout is settable
-	using the SETTIMEOUT ioctl.  Note that only a few timeout
-	values are supported.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-	[FIXME -- silliness again?]
-
-machzwd.c -- MachZ ZF-Logic
-
-	Hardcoded timeout of 10 seconds
-
-	Has a module parameter "action" that controls what happens
-	when the timeout runs out which can be 0 = RESET (default), 
-	1 = SMI, 2 = NMI, 3 = SCI.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT and the magic character
-	'V' close handling.
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, and the GETSTATUS call
-	returns if the device is open or not.  [FIXME -- silliness
-	again?]
-
-mixcomwd.c -- MixCom Watchdog
-
-	[FIXME -- I'm unable to tell what the timeout is]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, GETSTATUS returns if
-	the device is opened or not [FIXME -- I'm not really sure how
-	this works, there seems to be some magic connected to
-	CONFIG_WATCHDOG_NOWAYOUT]
-
-pcwd.c -- Berkshire PC Watchdog
-
-	Hardcoded timeout of 1.5 seconds
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_OVERHEAT|WDIOF_CARDRESET and both
-	GETSTATUS and GETBOOTSTATUS return something useful.
-
-	The SETOPTIONS call can be used to enable and disable the card
-	and to ask the driver to call panic if the system overheats.
-
-sbc60xxwdt.c -- 60xx Single Board Computer
-
-	Hardcoded timeout of 10 seconds
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT, but has the magic
-	character 'V' close handling.
-
-	No bits set in GETSUPPORT
-
-scx200.c -- National SCx200 CPUs
-
-	Not in the kernel yet.
-
-	The timeout is set using a module parameter "margin" which
-	defaults to 60 seconds.  The timeout can also be set using
-	SETTIMEOUT and read using GETTIMEOUT.
-
-	Supports a module parameter "nowayout" that is initialized
-	with the value of CONFIG_WATCHDOG_NOWAYOUT.  Also supports the
-	magic character 'V' handling.
-
-shwdt.c -- SuperH 3/4 processors
-
-	[FIXME -- I'm unable to tell what the timeout is]
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING, and the GETSTATUS call
-	returns if the device is open or not.  [FIXME -- silliness
-	again?]
-
-softdog.c -- Software watchdog
-
-	The timeout is set with the module parameter "soft_margin"
-	which defaults to 60 seconds, the timeout is also settable
-	using the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	WDIOF_SETTIMEOUT bit set in GETSUPPORT
-
-w83877f_wdt.c -- W83877F Computer
-
-	Hardcoded timeout of 30 seconds
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT, but has the magic
-	character 'V' close handling.
-
-	No bits set in GETSUPPORT
-
-w83627hf_wdt.c -- w83627hf watchdog
-
-	Timeout that defaults to 60 seconds, supports SETTIMEOUT.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
-	The GETSTATUS call returns if the device is open or not.
-
-wdt.c -- ICS WDT500/501 ISA and
-wdt_pci.c -- ICS WDT500/501 PCI
-
-	Default timeout of 60 seconds.  The timeout is also settable
-        using the SETTIMEOUT ioctl.
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	GETSUPPORT returns with bits set depending on the actual
-	card. The WDT501 supports a lot of external monitoring, the
-	WDT500 much less.
-
-wdt285.c -- Footbridge watchdog
-
-	The timeout is set with the module parameter "soft_margin"
-	which defaults to 60 seconds.  The timeout is also settable
-	using the SETTIMEOUT ioctl.
-
-	Does not support CONFIG_WATCHDOG_NOWAYOUT
-
-	WDIOF_SETTIMEOUT bit set in GETSUPPORT
-
-wdt977.c -- Netwinder W83977AF chip
-
-	Hardcoded timeout of 3 minutes
-
-	Supports CONFIG_WATCHDOG_NOWAYOUT
-
-	Does not support any ioctls at all.
-
diff --git a/Documentation/watchdog/watchdog.txt b/Documentation/watchdog/watchdog.txt
deleted file mode 100644
index 4b1ff69..0000000
--- a/Documentation/watchdog/watchdog.txt
+++ /dev/null
@@ -1,94 +0,0 @@
-	Watchdog Timer Interfaces For The Linux Operating System
-
-		Alan Cox <alan@lxorguk.ukuu.org.uk>
-
-	     Custom Linux Driver And Program Development
-
-
-The following watchdog drivers are currently implemented:
-
-	ICS	WDT501-P
-	ICS	WDT501-P (no fan tachometer)
-	ICS	WDT500-P
-	Software Only
-	SA1100 Internal Watchdog
-	Berkshire Products PC Watchdog Revision A & C (by Ken Hollis)
-
-
-All six interfaces provide /dev/watchdog, which when open must be written
-to within a timeout or the machine will reboot. Each write delays the reboot
-time another timeout. In the case of the software watchdog the ability to 
-reboot will depend on the state of the machines and interrupts. The hardware
-boards physically pull the machine down off their own onboard timers and
-will reboot from almost anything.
-
-A second temperature monitoring interface is available on the WDT501P cards
-and some Berkshire cards. This provides /dev/temperature. This is the machine 
-internal temperature in degrees Fahrenheit. Each read returns a single byte 
-giving the temperature.
-
-The third interface logs kernel messages on additional alert events.
-
-Both software and hardware watchdog drivers are available in the standard
-kernel. If you are using the software watchdog, you probably also want
-to use "panic=60" as a boot argument as well.
-
-The wdt card cannot be safely probed for. Instead you need to pass
-wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
-
-The SA1100 watchdog module can be configured with the "sa1100_margin"
-commandline argument which specifies timeout value in seconds.
-
-The i810 TCO watchdog modules can be configured with the "i810_margin"
-commandline argument which specifies the counter initial value. The counter
-is decremented every 0.6 seconds and default to 50 (30 seconds). Values can
-range between 3 and 63.
-
-The i810 TCO watchdog driver also implements the WDIOC_GETSTATUS and
-WDIOC_GETBOOTSTATUS ioctl()s. WDIOC_GETSTATUS returns the actual counter value
-and WDIOC_GETBOOTSTATUS returns the value of TCO2 Status Register (see Intel's
-documentation for the 82801AA and 82801AB datasheet). 
-
-Features
---------
-		WDT501P		WDT500P		Software	Berkshire	i810 TCO	SA1100WD
-Reboot Timer	   X               X                X		    X               X               X
-External Reboot	   X	           X                o		    o               o               X
-I/O Port Monitor   o		   o		    o		    X               o               o
-Temperature	   X		   o		    o               X               o               o
-Fan Speed          X		   o		    o               o               o               o
-Power Under	   X               o                o               o               o               o
-Power Over         X               o                o               o               o               o
-Overheat           X               o                o               o               o               o
-
-The external event interfaces on the WDT boards are not currently supported.
-Minor numbers are however allocated for it.
-
-
-Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
-
-
-Contact Information
-
-People keep asking about the WDT watchdog timer hardware: The phone contacts
-for Industrial Computer Source are:
- 
-Industrial Computer Source
-http://www.indcompsrc.com
-ICS Advent, San Diego
-6260 Sequence Dr.
-San Diego, CA 92121-4371
-Phone (858) 677-0877
-FAX: (858) 677-0895
->
-ICS Advent Europe, UK
-Oving Road
-Chichester,
-West Sussex,
-PO19 4ET, UK
-Phone: 00.44.1243.533900
-
-
-and please mention Linux when enquiring.
-
-For full information about the PCWD cards see the pcwd-watchdog.txt document.
diff --git a/Documentation/watchdog/wdt.txt b/Documentation/watchdog/wdt.txt
new file mode 100644
index 0000000..03fd756
--- /dev/null
+++ b/Documentation/watchdog/wdt.txt
@@ -0,0 +1,43 @@
+Last Reviewed: 10/05/2007
+
+	WDT Watchdog Timer Interfaces For The Linux Operating System
+		Alan Cox <alan@lxorguk.ukuu.org.uk>
+
+	ICS	WDT501-P
+	ICS	WDT501-P (no fan tachometer)
+	ICS	WDT500-P
+
+All the interfaces provide /dev/watchdog, which when open must be written
+to within a timeout or the machine will reboot. Each write delays the reboot
+time another timeout. In the case of the software watchdog the ability to
+reboot will depend on the state of the machines and interrupts. The hardware
+boards physically pull the machine down off their own onboard timers and
+will reboot from almost anything.
+
+A second temperature monitoring interface is available on the WDT501P cards
+This provides /dev/temperature. This is the machine internal temperature in
+degrees Fahrenheit. Each read returns a single byte giving the temperature.
+
+The third interface logs kernel messages on additional alert events.
+
+The wdt card cannot be safely probed for. Instead you need to pass
+wdt=ioaddr,irq as a boot parameter - eg "wdt=0x240,11".
+
+Features
+--------
+		WDT501P		WDT500P
+Reboot Timer	   X               X
+External Reboot	   X	           X
+I/O Port Monitor   o		   o
+Temperature	   X		   o
+Fan Speed          X		   o
+Power Under	   X               o
+Power Over         X               o
+Overheat           X               o
+
+The external event interfaces on the WDT boards are not currently supported.
+Minor numbers are however allocated for it.
+
+
+Example Watchdog Driver:  see Documentation/watchdog/src/watchdog-simple.c
+
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 1cad32c..53f5538 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -115,6 +115,13 @@ config IXP4XX_WATCHDOG
 
 	  Say N if you are unsure.
 
+config KS8695_WATCHDOG
+	tristate "KS8695 watchdog"
+	depends on ARCH_KS8695
+	help
+	  Watchdog timer embedded into KS8695 processor. This will reboot your
+	  system when the timeout is reached.
+
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
 	depends on ARCH_S3C2410
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 8bfc00c..d90f649 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
 obj-$(CONFIG_977_WATCHDOG) += wdt977.o
 obj-$(CONFIG_IXP2000_WATCHDOG) += ixp2000_wdt.o
 obj-$(CONFIG_IXP4XX_WATCHDOG) += ixp4xx_wdt.o
+obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
 obj-$(CONFIG_SA1100_WATCHDOG) += sa1100_wdt.o
 obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
diff --git a/drivers/char/watchdog/ks8695_wdt.c b/drivers/char/watchdog/ks8695_wdt.c
new file mode 100644
index 0000000..7150fb9
--- /dev/null
+++ b/drivers/char/watchdog/ks8695_wdt.c
@@ -0,0 +1,308 @@
+/*
+ * Watchdog driver for Kendin/Micrel KS8695.
+ *
+ * (C) 2007 Andrew Victor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <asm/bitops.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/arch/regs-timer.h>
+
+
+#define WDT_DEFAULT_TIME	5	/* seconds */
+#define WDT_MAX_TIME		171	/* seconds */
+
+static int wdt_time = WDT_DEFAULT_TIME;
+static int nowayout = WATCHDOG_NOWAYOUT;
+
+module_param(wdt_time, int, 0);
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+#endif
+
+
+static unsigned long ks8695wdt_busy;
+
+/* ......................................................................... */
+
+/*
+ * Disable the watchdog.
+ */
+static void inline ks8695_wdt_stop(void)
+{
+	unsigned long tmcon;
+
+	/* disable timer0 */
+	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
+	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+}
+
+/*
+ * Enable and reset the watchdog.
+ */
+static void inline ks8695_wdt_start(void)
+{
+	unsigned long tmcon;
+	unsigned long tval = wdt_time * CLOCK_TICK_RATE;
+
+	/* disable timer0 */
+	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
+	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+
+	/* program timer0 */
+	__raw_writel(tval | T0TC_WATCHDOG, KS8695_TMR_VA + KS8695_T0TC);
+
+	/* re-enable timer0 */
+	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
+	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+}
+
+/*
+ * Reload the watchdog timer.  (ie, pat the watchdog)
+ */
+static void inline ks8695_wdt_reload(void)
+{
+	unsigned long tmcon;
+
+	/* disable, then re-enable timer0 */
+	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
+	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+}
+
+/*
+ * Change the watchdog time interval.
+ */
+static int ks8695_wdt_settimeout(int new_time)
+{
+	/*
+	 * All counting occurs at SLOW_CLOCK / 128 = 0.256 Hz
+	 *
+	 * Since WDV is a 16-bit counter, the maximum period is
+	 * 65536 / 0.256 = 256 seconds.
+	 */
+	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
+		return -EINVAL;
+
+	/* Set new watchdog time. It will be used when ks8695_wdt_start() is called. */
+	wdt_time = new_time;
+	return 0;
+}
+
+/* ......................................................................... */
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int ks8695_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &ks8695wdt_busy))
+		return -EBUSY;
+
+	ks8695_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device.
+ * If CONFIG_WATCHDOG_NOWAYOUT is NOT defined then the watchdog is also
+ *  disabled.
+ */
+static int ks8695_wdt_close(struct inode *inode, struct file *file)
+{
+	if (!nowayout)
+		ks8695_wdt_stop();	/* Disable the watchdog when file is closed */
+
+	clear_bit(0, &ks8695wdt_busy);
+	return 0;
+}
+
+static struct watchdog_info ks8695_wdt_info = {
+	.identity	= "ks8695 watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+};
+
+/*
+ * Handle commands from user-space.
+ */
+static int ks8695_wdt_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value;
+
+	switch(cmd) {
+		case WDIOC_KEEPALIVE:
+			ks8695_wdt_reload();	/* pat the watchdog */
+			return 0;
+
+		case WDIOC_GETSUPPORT:
+			return copy_to_user(argp, &ks8695_wdt_info, sizeof(ks8695_wdt_info)) ? -EFAULT : 0;
+
+		case WDIOC_SETTIMEOUT:
+			if (get_user(new_value, p))
+				return -EFAULT;
+
+			if (ks8695_wdt_settimeout(new_value))
+				return -EINVAL;
+
+			/* Enable new time value */
+			ks8695_wdt_start();
+
+			/* Return current value */
+			return put_user(wdt_time, p);
+
+		case WDIOC_GETTIMEOUT:
+			return put_user(wdt_time, p);
+
+		case WDIOC_GETSTATUS:
+		case WDIOC_GETBOOTSTATUS:
+			return put_user(0, p);
+
+		case WDIOC_SETOPTIONS:
+			if (get_user(new_value, p))
+				return -EFAULT;
+
+			if (new_value & WDIOS_DISABLECARD)
+				ks8695_wdt_stop();
+			if (new_value & WDIOS_ENABLECARD)
+				ks8695_wdt_start();
+			return 0;
+
+		default:
+			return -ENOTTY;
+	}
+}
+
+/*
+ * Pat the watchdog whenever device is written to.
+ */
+static ssize_t ks8695_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	ks8695_wdt_reload();		/* pat the watchdog */
+	return len;
+}
+
+/* ......................................................................... */
+
+static const struct file_operations ks8695wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= ks8695_wdt_ioctl,
+	.open		= ks8695_wdt_open,
+	.release	= ks8695_wdt_close,
+	.write		= ks8695_wdt_write,
+};
+
+static struct miscdevice ks8695wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &ks8695wdt_fops,
+};
+
+static int __init ks8695wdt_probe(struct platform_device *pdev)
+{
+	int res;
+
+	if (ks8695wdt_miscdev.parent)
+		return -EBUSY;
+	ks8695wdt_miscdev.parent = &pdev->dev;
+
+	res = misc_register(&ks8695wdt_miscdev);
+	if (res)
+		return res;
+
+	printk("KS8695 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	return 0;
+}
+
+static int __exit ks8695wdt_remove(struct platform_device *pdev)
+{
+	int res;
+
+	res = misc_deregister(&ks8695wdt_miscdev);
+	if (!res)
+		ks8695wdt_miscdev.parent = NULL;
+
+	return res;
+}
+
+static void ks8695wdt_shutdown(struct platform_device *pdev)
+{
+	ks8695_wdt_stop();
+}
+
+#ifdef CONFIG_PM
+
+static int ks8695wdt_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	ks8695_wdt_stop();
+	return 0;
+}
+
+static int ks8695wdt_resume(struct platform_device *pdev)
+{
+	if (ks8695wdt_busy)
+		ks8695_wdt_start();
+	return 0;
+}
+
+#else
+#define ks8695wdt_suspend NULL
+#define ks8695wdt_resume	NULL
+#endif
+
+static struct platform_driver ks8695wdt_driver = {
+	.probe		= ks8695wdt_probe,
+	.remove		= __exit_p(ks8695wdt_remove),
+	.shutdown	= ks8695wdt_shutdown,
+	.suspend	= ks8695wdt_suspend,
+	.resume		= ks8695wdt_resume,
+	.driver		= {
+		.name	= "ks8695_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ks8695_wdt_init(void)
+{
+	/* Check that the heartbeat value is within range; if not reset to the default */
+	if (ks8695_wdt_settimeout(wdt_time)) {
+		ks8695_wdt_settimeout(WDT_DEFAULT_TIME);
+		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n", wdt_time, WDT_MAX_TIME);
+	}
+
+	return platform_driver_register(&ks8695wdt_driver);
+}
+
+static void __exit ks8695_wdt_exit(void)
+{
+	platform_driver_unregister(&ks8695wdt_driver);
+}
+
+module_init(ks8695_wdt_init);
+module_exit(ks8695_wdt_exit);
+
+MODULE_AUTHOR("Andrew Victor");
+MODULE_DESCRIPTION("Watchdog driver for KS8695");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

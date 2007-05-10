Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXEJUlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXEJUlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXEJUlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:41:36 -0400
Received: from outmx028.isp.belgacom.be ([195.238.5.49]:50009 "EHLO
	outmx028.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbXEJUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:41:33 -0400
Date: Thu, 10 May 2007 22:42:20 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Florian Fainelli <florian.fainelli@int-evry.fr>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Vlad Drukker <vlad@storewiz.com>
Subject: [WATCHDOG] patches for v2.6.22-rc1
Message-ID: <20070510204220.GA30764@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/feature-removal-schedule.txt |    8 
 MAINTAINERS                                |    6 
 drivers/char/watchdog/Kconfig              |  150 +++----
 drivers/char/watchdog/Makefile             |    2 
 drivers/char/watchdog/cpu5wdt.c            |   14 
 drivers/char/watchdog/eurotechwdt.c        |   22 -
 drivers/char/watchdog/i8xx_tco.c           |  571 -----------------------------
 drivers/char/watchdog/i8xx_tco.h           |   42 --
 drivers/char/watchdog/ibmasr.c             |   11 
 drivers/char/watchdog/machzwd.c            |   18 
 drivers/char/watchdog/mtx-1_wdt.c          |  238 ++++++++++++
 drivers/char/watchdog/pcwd.c               |  242 ++++++------
 drivers/char/watchdog/pcwd_usb.c           |    8 
 drivers/char/watchdog/s3c2410_wdt.c        |    6 
 drivers/char/watchdog/sbc8360.c            |   28 -
 drivers/char/watchdog/w83627hf_wdt.c       |   23 -
 16 files changed, 496 insertions(+), 893 deletions(-)

with these Changes:

Author: Florian Fainelli <florian.fainelli@int-evry.fr>
Date:   Sun May 6 12:55:32 2007 +0200

    [WATCHDOG] MTX-1 Watchdog driver
    
    This patch adds support for the MTX-1 boards watchdog. If not available the
    board will reboot every 100 seconds. It uses the Linux watchdog and timer
    APIs.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@int-evry.fr>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Arnaud Patard <arnaud.patard@rtp-net.org>
Date:   Sat May 5 15:53:15 2007 +0200

    [WATCHDOG] s3c2410_wdt - initialize watchdog irq resource
    
    In the error path of s3c2410wdt_probe() and in s3c2410wdt_remove(),
    we're using wdt_irq without initialising it, leading to a oops.
    
    Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date:   Mon Apr 30 13:56:42 2007 +0200

    [WATCHDOG] Kconfig menuconfig patch
    
    Change Kconfig objects from "menu, config" into "menuconfig" so
    that the user can disable the whole feature without having to
    enter the menu first.
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat May 5 05:48:23 2007 +0000

    [WATCHDOG] pcwd.c: Port to the new device driver model
    
    Port the pcwd.c driver to the new device driver model.
    Since this is an ISA card, I used Rene Herman's new isa bus type.
    This made the probing for the card very "easy".
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Date:   Thu May 3 20:15:14 2007 -0700

    [WATCHDOG] use mutex instead of semaphore in Berkshire USB-PC Watchdog driver
    
    The Berkshire USB-PC Watchdog driver uses a semaphore as mutex.  Use the mutex
    API instead of the (binary) semaphore.
    
    Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Adrian Bunk <bunk@stusta.de>
Date:   Fri Apr 6 12:22:17 2007 +0200

    [WATCHDOG] the scheduled removal of the i8xx_tco watchdog driver
    
    This patch contains the scheduled removal of the i8xx_tco watchdog
    driver.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Merge: fb8f7ba... dc87c39...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue May 1 06:53:01 2007 +0000

    Merge /pub/scm/linux/kernel/git/torvalds/linux-2.6

Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sat Mar 24 15:58:12 2007 +0300

    [WATCHDOG] Semi-typical watchdog bug re early misc_register()
    
    It seems that some watchdog drivers are doing following mistake:
    
    	rv = misc_register();
    	if (rv < 0)
    		return rv;
    	rv = request_region();
    	if (rv < 0) {
    		misc_deregister();
    		return rv;
    	}
    
    But, right after misc_register() returns, misc device can be opened and
    ioctls interacting with hardware issued, and driver can do outb() to
    port it doesn't own yet, because request_region() is still pending.
    
    Here is my patch, compile-tested only.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Vlad Drukker <vlad@storewiz.com>
Date:   Sun Mar 25 17:34:39 2007 +0200

    [WATCHDOG] add support for the w83627thf chipset.
    
    Added support for W83627THF, watchdog chip.
    
    Signed-off-by: Vlad Drukker <vlad@storewiz.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5c88ba1..d6d183f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -288,14 +288,6 @@ Who:	Richard Purdie <rpurdie@rpsys.net>
 
 ---------------------------
 
-What:	i8xx_tco watchdog driver
-When:	in 2.6.22
-Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
-	watchdog driver.
-Who:	Wim Van Sebroeck <wim@iguana.be>
-
----------------------------
-
 What:	Multipath cached routing support in ipv4
 When:	in 2.6.23
 Why:	Code was merged, then submitter immediately disappeared leaving
diff --git a/MAINTAINERS b/MAINTAINERS
index af1c792..6fd435d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1644,12 +1644,6 @@ P:	H. Peter Anvin
 M:	hpa@zytor.com
 S:	Maintained
 
-i810 TCO TIMER WATCHDOG
-P:	Nils Faerber
-M:	nils@kernelconcepts.de
-W:	http://www.kernelconcepts.de/
-S:	Maintained
-
 IA64 (Itanium) PLATFORM
 P:	Tony Luck
 M:	tony.luck@intel.com
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 60198a7..1cad32c 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -2,9 +2,7 @@
 # Watchdog device configuration
 #
 
-menu "Watchdog Cards"
-
-config WATCHDOG
+menuconfig WATCHDOG
 	bool "Watchdog Timer Support"
 	---help---
 	  If you say Y here (and to one of the following options) and create a
@@ -28,9 +26,10 @@ config WATCHDOG
 
 	  If unsure, say N.
 
+if WATCHDOG
+
 config WATCHDOG_NOWAYOUT
 	bool "Disable watchdog shutdown on close"
-	depends on WATCHDOG
 	help
 	  The default watchdog behaviour (which you get if you say N here) is
 	  to stop the timer if the process managing it closes the file
@@ -43,13 +42,11 @@ config WATCHDOG_NOWAYOUT
 #
 
 comment "Watchdog Device Drivers"
-	depends on WATCHDOG
 
 # Architecture Independent
 
 config SOFT_WATCHDOG
 	tristate "Software watchdog"
-	depends on WATCHDOG
 	help
 	  A software monitoring watchdog. This will fail to reboot your system
 	  from some situations that the hardware watchdog will recover
@@ -62,14 +59,14 @@ config SOFT_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on WATCHDOG && ARCH_AT91RM9200
+	depends on ARCH_AT91RM9200
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
-	depends on WATCHDOG && FOOTBRIDGE
+	depends on FOOTBRIDGE
 	help
 	  The Intel Footbridge chip contains a built-in watchdog circuit. Say Y
 	  here if you wish to use this. Alternatively say M to compile the
@@ -83,7 +80,7 @@ config 21285_WATCHDOG
 
 config 977_WATCHDOG
 	tristate "NetWinder WB83C977 watchdog"
-	depends on WATCHDOG && FOOTBRIDGE && ARCH_NETWINDER
+	depends on FOOTBRIDGE && ARCH_NETWINDER
 	help
 	  Say Y here to include support for the WB977 watchdog included in
 	  NetWinder machines. Alternatively say M to compile the driver as
@@ -93,7 +90,7 @@ config 977_WATCHDOG
 
 config IXP2000_WATCHDOG
 	tristate "IXP2000 Watchdog"
-	depends on WATCHDOG && ARCH_IXP2000
+	depends on ARCH_IXP2000
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Intel IXP2000(2400, 2800, 2850) network processors.
@@ -104,7 +101,7 @@ config IXP2000_WATCHDOG
 
 config IXP4XX_WATCHDOG
 	tristate "IXP4xx Watchdog"
-	depends on WATCHDOG && ARCH_IXP4XX
+	depends on ARCH_IXP4XX
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Intel IXP4xx network processors. This driver can
@@ -120,7 +117,7 @@ config IXP4XX_WATCHDOG
 
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
-	depends on WATCHDOG && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  Watchdog timer block in the Samsung S3C2410 chips. This will
 	  reboot the system when the timer expires with the watchdog
@@ -136,7 +133,7 @@ config S3C2410_WATCHDOG
 
 config SA1100_WATCHDOG
 	tristate "SA1100/PXA2xx watchdog"
-	depends on WATCHDOG && ( ARCH_SA1100 || ARCH_PXA )
+	depends on ARCH_SA1100 || ARCH_PXA
 	help
 	  Watchdog timer embedded into SA11x0 and PXA2xx chips. This will
 	  reboot your system when timeout is reached.
@@ -148,7 +145,7 @@ config SA1100_WATCHDOG
 
 config MPCORE_WATCHDOG
 	tristate "MPcore watchdog"
-	depends on WATCHDOG && ARM_MPCORE_PLATFORM && LOCAL_TIMERS
+	depends on ARM_MPCORE_PLATFORM && LOCAL_TIMERS
 	help
 	  Watchdog timer embedded into the MPcore system.
 
@@ -157,7 +154,7 @@ config MPCORE_WATCHDOG
 
 config EP93XX_WATCHDOG
 	tristate "EP93xx Watchdog"
-	depends on WATCHDOG && ARCH_EP93XX
+	depends on ARCH_EP93XX
 	help
 	  Say Y here if to include support for the watchdog timer
 	  embedded in the Cirrus Logic EP93xx family of devices.
@@ -167,14 +164,14 @@ config EP93XX_WATCHDOG
 
 config OMAP_WATCHDOG
 	tristate "OMAP Watchdog"
-	depends on WATCHDOG && (ARCH_OMAP16XX || ARCH_OMAP24XX)
+	depends on ARCH_OMAP16XX || ARCH_OMAP24XX
 	help
 	  Support for TI OMAP1610/OMAP1710/OMAP2420 watchdog.  Say 'Y' here to
 	  enable the OMAP1610/OMAP1710 watchdog timer.
 
 config PNX4008_WATCHDOG
 	tristate "PNX4008 Watchdog"
-	depends on WATCHDOG && ARCH_PNX4008
+	depends on ARCH_PNX4008
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the PNX4008 processor.
@@ -187,7 +184,7 @@ config PNX4008_WATCHDOG
 
 config ACQUIRE_WDT
 	tristate "Acquire SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on Single Board
 	  Computers produced by Acquire Inc (and others). This watchdog
@@ -201,7 +198,7 @@ config ACQUIRE_WDT
 
 config ADVANTECH_WDT
 	tristate "Advantech SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  If you are configuring a Linux kernel for the Advantech single-board
 	  computer, say `Y' here to support its built-in watchdog timer
@@ -210,7 +207,7 @@ config ADVANTECH_WDT
 
 config ALIM1535_WDT
 	tristate "ALi M1535 PMU Watchdog Timer"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	---help---
 	  This is the driver for the hardware watchdog on the ALi M1535 PMU.
 
@@ -221,7 +218,7 @@ config ALIM1535_WDT
 
 config ALIM7101_WDT
 	tristate "ALi M7101 PMU Computer Watchdog"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	help
 	  This is the driver for the hardware watchdog on the ALi M7101 PMU
 	  as used in the x86 Cobalt servers.
@@ -233,7 +230,7 @@ config ALIM7101_WDT
 
 config SC520_WDT
 	tristate "AMD Elan SC520 processor Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is the driver for the hardware watchdog built in to the
 	  AMD "Elan" SC520 microcomputer commonly used in embedded systems.
@@ -246,7 +243,7 @@ config SC520_WDT
 
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  Enable support for the watchdog timer on the Eurotech CPU-1220 and
 	  CPU-1410 cards.  These are PC/104 SBCs. Spec sheets and product
@@ -254,7 +251,7 @@ config EUROTECH_WDT
 
 config IB700_WDT
 	tristate "IB700 SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the IB700 Single
 	  Board Computer produced by TMC Technology (www.tmc-uk.com). This watchdog
@@ -270,7 +267,7 @@ config IB700_WDT
 
 config IBMASR
 	tristate "IBM Automatic Server Restart"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is the driver for the IBM Automatic Server Restart watchdog
 	  timer built-in into some eServer xSeries machines.
@@ -280,7 +277,7 @@ config IBMASR
 
 config WAFER_WDT
 	tristate "ICP Wafer 5823 Single Board Computer Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is a driver for the hardware watchdog on the ICP Wafer 5823
 	  Single Board Computer (and probably other similar models).
@@ -290,7 +287,7 @@ config WAFER_WDT
 
 config I6300ESB_WDT
 	tristate "Intel 6300ESB Timer/Watchdog"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	---help---
 	  Hardware driver for the watchdog timer built into the Intel
 	  6300ESB controller hub.
@@ -298,31 +295,9 @@ config I6300ESB_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called i6300esb.
 
-config I8XX_TCO
-	tristate "Intel i8xx TCO Timer/Watchdog"
-	depends on WATCHDOG && (X86 || IA64) && PCI
-	default n
-	---help---
-	  Hardware driver for the TCO timer built into the Intel 82801
-	  I/O Controller Hub family.  The TCO (Total Cost of Ownership)
-	  timer is a watchdog timer that will reboot the machine after
-	  its second expiration. The expiration time can be configured
-	  with the "heartbeat" parameter.
-
-	  On some motherboards the driver may fail to reset the chipset's
-	  NO_REBOOT flag which prevents the watchdog from rebooting the
-	  machine. If this is the case you will get a kernel message like
-	  "failed to reset NO_REBOOT flag, reboot disabled by hardware".
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called i8xx_tco.
-
-	  Note: This driver will be removed in the near future. Please
-	  use the Intel TCO Timer/Watchdog driver.
-
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
-	depends on WATCHDOG && (X86 || IA64) && PCI
+	depends on (X86 || IA64) && PCI
 	---help---
 	  Hardware driver for the intel TCO timer based watchdog devices.
 	  These drivers are included in the Intel 82801 I/O Controller
@@ -351,7 +326,7 @@ config ITCO_VENDOR_SUPPORT
 
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is a driver for National Semiconductor PC87307/PC97307 hardware
 	  watchdog cards as found on the SC1200. This watchdog is mainly used
@@ -365,7 +340,7 @@ config SC1200_WDT
 
 config SCx200_WDT
 	tristate "National Semiconductor SCx200 Watchdog"
-	depends on WATCHDOG && SCx200 && PCI
+	depends on SCx200 && PCI
 	help
 	  Enable the built-in watchdog timer support on the National
 	  Semiconductor SCx200 processors.
@@ -374,7 +349,7 @@ config SCx200_WDT
 
 config PC87413_WDT
 	tristate "NS PC87413 watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the PC87413 chipset
 	  This watchdog simply watches your kernel to make sure it doesn't
@@ -388,7 +363,7 @@ config PC87413_WDT
  
 config 60XX_WDT
 	tristate "SBC-60XX Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This driver can be used with the watchdog timer found on some
 	  single board computers, namely the 6010 PII based computer.
@@ -402,7 +377,7 @@ config 60XX_WDT
 
 config SBC8360_WDT
 	tristate "SBC8360 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 
 	  This is the driver for the hardware watchdog on the SBC8360 Single
@@ -415,7 +390,7 @@ config SBC8360_WDT
 
 config CPU5_WDT
 	tristate "SMA CPU5 Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  TBD.
 	  To compile this driver as a module, choose M here: the
@@ -423,7 +398,7 @@ config CPU5_WDT
 
 config SMSC37B787_WDT
 	tristate "Winbond SMsC37B787 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog component on the
 	  Winbond SMsC37B787 chipset as used on the NetRunner Mainboard
@@ -443,7 +418,7 @@ config SMSC37B787_WDT
 
 config W83627HF_WDT
 	tristate "W83627HF Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83627HF chipset
 	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
@@ -458,7 +433,7 @@ config W83627HF_WDT
 
 config W83697HF_WDT
 	tristate "W83697HF/W83697HG Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83697HF/HG
 	  chipset as used in Dedibox/VIA motherboards (and likely others).
@@ -473,7 +448,7 @@ config W83697HF_WDT
 
 config W83877F_WDT
 	tristate "W83877F (EMACS) Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83877F chipset
 	  as used in EMACS PC-104 motherboards (and likely others).  This
@@ -488,7 +463,7 @@ config W83877F_WDT
 
 config W83977F_WDT
 	tristate "W83977F (PCM-5335) Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83977F I/O chip
 	  as used in AAEON's PCM-5335 SBC (and likely others).  This
@@ -501,7 +476,7 @@ config W83977F_WDT
 
 config MACHZ_WDT
 	tristate "ZF MachZ Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  If you are using a ZF Micro MachZ processor, say Y here, otherwise
 	  N.  This is the driver for the watchdog timer built-in on that
@@ -514,7 +489,7 @@ config MACHZ_WDT
 
 config SBC_EPX_C3_WATCHDOG
 	tristate "Winsystems SBC EPX-C3 watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the built-in watchdog timer on the EPX-C3
 	  Single-board computer made by Winsystems, Inc.
@@ -537,19 +512,19 @@ config SBC_EPX_C3_WATCHDOG
 
 config 8xx_WDT
 	tristate "MPC8xx Watchdog Timer"
-	depends on WATCHDOG && 8xx
+	depends on 8xx
 
 config 83xx_WDT
 	tristate "MPC83xx Watchdog Timer"
-	depends on WATCHDOG && PPC_83xx
+	depends on PPC_83xx
 
 config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
-	depends on WATCHDOG && MV64X60
+	depends on MV64X60
 
 config BOOKE_WDT
 	bool "PowerPC Book-E Watchdog Timer"
-	depends on WATCHDOG && (BOOKE || 4xx)
+	depends on BOOKE || 4xx
 	---help---
 	  Please see Documentation/watchdog/watchdog-api.txt for
 	  more information.
@@ -558,7 +533,7 @@ config BOOKE_WDT
 
 config WATCHDOG_RTAS
 	tristate "RTAS watchdog"
-	depends on WATCHDOG && PPC_RTAS
+	depends on PPC_RTAS
 	help
 	  This driver adds watchdog support for the RTAS watchdog.
 
@@ -569,16 +544,23 @@ config WATCHDOG_RTAS
 
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
-	depends on WATCHDOG && SGI_IP22
+	depends on SGI_IP22
 	help
 	  Hardware driver for the Indy's/I2's watchdog. This is a
 	  watchdog timer that will reboot the machine after a 60 second
 	  timer expired and no process has written to /dev/watchdog during
 	  that time.
 
+config WDT_MTX1
+	tristate "MTX-1 Hardware Watchdog"
+	depends on MIPS_MTX1
+	help
+	  Hardware driver for the MTX-1 boards. This is a watchdog timer that
+	  will reboot the machine after a 100 seconds timer expired.
+
 config WDT_RM9K_GPI
 	tristate "RM9000/GPI hardware watchdog"
-	depends on WATCHDOG && CPU_RM9000
+	depends on CPU_RM9000
 	help
 	  Watchdog implementation using the GPI hardware found on
 	  PMC-Sierra RM9xxx CPUs.
@@ -590,7 +572,7 @@ config WDT_RM9K_GPI
 
 config ZVM_WATCHDOG
 	tristate "z/VM Watchdog Timer"
-	depends on WATCHDOG && S390
+	depends on S390
 	help
 	  IBM s/390 and zSeries machines running under z/VM 5.1 or later
 	  provide a virtual watchdog timer to their guest that cause a
@@ -604,7 +586,7 @@ config ZVM_WATCHDOG
 
 config SH_WDT
 	tristate "SuperH Watchdog"
-	depends on WATCHDOG && SUPERH
+	depends on SUPERH
 	help
 	  This driver adds watchdog support for the integrated watchdog in the
 	  SuperH processors. If you have one of these processors and wish
@@ -631,7 +613,7 @@ config SH_WDT_MMAP
 
 config WATCHDOG_CP1XXX
 	tristate "CP1XXX Hardware Watchdog support"
-	depends on WATCHDOG && SPARC64 && PCI
+	depends on SPARC64 && PCI
 	---help---
 	  This is the driver for the hardware watchdog timers present on
 	  Sun Microsystems CompactPCI models CP1400 and CP1500.
@@ -645,7 +627,7 @@ config WATCHDOG_CP1XXX
 
 config WATCHDOG_RIO
 	tristate "RIO Hardware Watchdog support"
-	depends on WATCHDOG && SPARC64 && PCI
+	depends on SPARC64 && PCI
 	help
 	  Say Y here to support the hardware watchdog capability on Sun RIO
 	  machines.  The watchdog timeout period is normally one minute but
@@ -656,11 +638,11 @@ config WATCHDOG_RIO
 #
 
 comment "ISA-based Watchdog Cards"
-	depends on WATCHDOG && ISA
+	depends on ISA
 
 config PCWATCHDOG
 	tristate "Berkshire Products ISA-PC Watchdog"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  This is the driver for the Berkshire Products ISA-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -676,7 +658,7 @@ config PCWATCHDOG
 
 config MIXCOMWD
 	tristate "Mixcom Watchdog"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  This is a driver for the Mixcom hardware watchdog cards.  This
 	  watchdog simply watches your kernel to make sure it doesn't freeze,
@@ -690,7 +672,7 @@ config MIXCOMWD
 
 config WDT
 	tristate "WDT Watchdog timer"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  If you have a WDT500P or WDT501P watchdog board, say Y here,
 	  otherwise N. It is not possible to probe for this board, which means
@@ -720,11 +702,11 @@ config WDT_501
 #
 
 comment "PCI-based Watchdog Cards"
-	depends on WATCHDOG && PCI
+	depends on PCI
 
 config PCIPCWATCHDOG
 	tristate "Berkshire Products PCI-PC Watchdog"
-	depends on WATCHDOG && PCI
+	depends on PCI
 	---help---
 	  This is the driver for the Berkshire Products PCI-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -739,7 +721,7 @@ config PCIPCWATCHDOG
 
 config WDTPCI
 	tristate "PCI-WDT500/501 Watchdog timer"
-	depends on WATCHDOG && PCI
+	depends on PCI
 	---help---
 	  If you have a PCI-WDT500/501 watchdog board, say Y here, otherwise N.
 
@@ -766,11 +748,11 @@ config WDT_501_PCI
 #
 
 comment "USB-based Watchdog Cards"
-	depends on WATCHDOG && USB
+	depends on USB
 
 config USBPCWATCHDOG
 	tristate "Berkshire Products USB-PC Watchdog"
-	depends on WATCHDOG && USB
+	depends on USB
 	---help---
 	  This is the driver for the Berkshire Products USB-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -783,4 +765,4 @@ config USBPCWATCHDOG
 
 	  Most people will say N.
 
-endmenu
+endif # WATCHDOG
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 2cd8ff8..8bfc00c 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
-obj-$(CONFIG_I8XX_TCO) += i8xx_tco.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
@@ -73,6 +72,7 @@ obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
 
 # MIPS Architecture
 obj-$(CONFIG_INDYDOG) += indydog.o
+obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 
 # S390 Architecture
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/char/watchdog/cpu5wdt.c
index bcd7e36..d0d45a8 100644
--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -220,17 +220,17 @@ static int __devinit cpu5wdt_init(void)
 	if ( verbose )
 		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
+	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
+
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
@@ -250,9 +250,9 @@ static int __devinit cpu5wdt_init(void)
 
 	return 0;
 
-no_port:
-	misc_deregister(&cpu5wdt_misc);
 no_misc:
+	release_region(port, CPU5WDT_EXTENT);
+no_port:
 	return err;
 }
 
diff --git a/drivers/char/watchdog/eurotechwdt.c b/drivers/char/watchdog/eurotechwdt.c
index f70387f..b070324 100644
--- a/drivers/char/watchdog/eurotechwdt.c
+++ b/drivers/char/watchdog/eurotechwdt.c
@@ -413,17 +413,10 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&eurwdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
-		WATCHDOG_MINOR);
-		goto out;
-	}
-
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
 	if(ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
-		goto outmisc;
+		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
@@ -438,6 +431,13 @@ static int __init eurwdt_init(void)
 		goto outreg;
 	}
 
+	ret = misc_register(&eurwdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
+		WATCHDOG_MINOR);
+		goto outreboot;
+	}
+
 	eurwdt_unlock_chip();
 
 	ret = 0;
@@ -448,14 +448,14 @@ static int __init eurwdt_init(void)
 out:
 	return ret;
 
+outreboot:
+	unregister_reboot_notifier(&eurwdt_notifier);
+
 outreg:
 	release_region(io, 2);
 
 outirq:
 	free_irq(irq, NULL);
-
-outmisc:
-	misc_deregister(&eurwdt_miscdev);
 	goto out;
 }
 
diff --git a/drivers/char/watchdog/i8xx_tco.c b/drivers/char/watchdog/i8xx_tco.c
deleted file mode 100644
index a62ef48..0000000
--- a/drivers/char/watchdog/i8xx_tco.c
+++ /dev/null
@@ -1,571 +0,0 @@
-/*
- *	i8xx_tco:	TCO timer driver for i8xx chipsets
- *
- *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights Reserved.
- *				http://www.kernelconcepts.de
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither kernel concepts nor Nils Faerber admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
- *
- *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
- *				developed for
- *                              Jentro AG, Haar/Munich (Germany)
- *
- *	TCO timer driver for i8xx chipsets
- *	based on softdog.c by Alan Cox <alan@redhat.com>
- *
- *	The TCO timer is implemented in the following I/O controller hubs:
- *	(See the intel documentation on http://developer.intel.com.)
- *	82801AA  (ICH)    : document number 290655-003, 290677-014,
- *	82801AB  (ICHO)   : document number 290655-003, 290677-014,
- *	82801BA  (ICH2)   : document number 290687-002, 298242-027,
- *	82801BAM (ICH2-M) : document number 290687-002, 298242-027,
- *	82801CA  (ICH3-S) : document number 290733-003, 290739-013,
- *	82801CAM (ICH3-M) : document number 290716-001, 290718-007,
- *	82801DB  (ICH4)   : document number 290744-001, 290745-020,
- *	82801DBM (ICH4-M) : document number 252337-001, 252663-005,
- *	82801E   (C-ICH)  : document number 273599-001, 273645-002,
- *	82801EB  (ICH5)   : document number 252516-001, 252517-003,
- *	82801ER  (ICH5R)  : document number 252516-001, 252517-003,
- *
- *  20000710 Nils Faerber
- *	Initial Version 0.01
- *  20000728 Nils Faerber
- *	0.02 Fix for SMI_EN->TCO_EN bit, some cleanups
- *  20011214 Matt Domsch <Matt_Domsch@dell.com>
- *	0.03 Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
- *	     Didn't add timeout option as i810_margin already exists.
- *  20020224 Joel Becker, Wim Van Sebroeck
- *	0.04 Support for 82801CA(M) chipset, timer margin needs to be > 3,
- *	     add support for WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT.
- *  20020412 Rob Radez <rob@osinvestor.com>, Wim Van Sebroeck
- *	0.05 Fix possible timer_alive race, add expect close support,
- *	     clean up ioctls (WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS and
- *	     WDIOC_SETOPTIONS), made i810tco_getdevice __init,
- *	     removed boot_status, removed tco_timer_read,
- *	     added support for 82801DB and 82801E chipset,
- *	     added support for 82801EB and 8280ER chipset,
- *	     general cleanup.
- *  20030921 Wim Van Sebroeck <wim@iguana.be>
- *	0.06 change i810_margin to heartbeat, use module_param,
- *	     added notify system support, renamed module to i8xx_tco.
- *  20050128 Wim Van Sebroeck <wim@iguana.be>
- *	0.07 Added support for the ICH4-M, ICH6, ICH6R, ICH6-M, ICH6W and ICH6RW
- *	     chipsets. Also added support for the "undocumented" ICH7 chipset.
- *  20050807 Wim Van Sebroeck <wim@iguana.be>
- *	0.08 Make sure that the watchdog is only "armed" when started.
- *	     (Kernel Bug 4251)
- *  20060416 Wim Van Sebroeck <wim@iguana.be>
- *	0.09 Remove support for the ICH6, ICH6R, ICH6-M, ICH6W and ICH6RW and
- *	     ICH7 chipsets. (See Kernel Bug 6031 - other code will support these
- *	     chipsets)
- */
-
-/*
- *	Includes, defines, variables, module parameters, ...
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/pci.h>
-#include <linux/ioport.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-#include "i8xx_tco.h"
-
-/* Module and version information */
-#define TCO_VERSION "0.09"
-#define TCO_MODULE_NAME "i8xx TCO timer"
-#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
-#define PFX TCO_MODULE_NAME ": "
-
-/* internal variables */
-static unsigned int ACPIBASE;
-static spinlock_t tco_lock;	/* Guards the hardware */
-static unsigned long timer_alive;
-static char tco_expect_close;
-static struct pci_dev *i8xx_tco_pci;
-
-/* module parameters */
-#define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat (2<heartbeat<39) */
-static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/*
- * Some TCO specific functions
- */
-
-static inline unsigned char seconds_to_ticks(int seconds)
-{
-	/* the internal timer is stored as ticks which decrement
-	 * every 0.6 seconds */
-	return (seconds * 10) / 6;
-}
-
-static int tco_timer_start (void)
-{
-	unsigned char val;
-
-	spin_lock(&tco_lock);
-
-	/* disable chipset's NO_REBOOT bit */
-	pci_read_config_byte (i8xx_tco_pci, 0xd4, &val);
-	val &= 0xfd;
-	pci_write_config_byte (i8xx_tco_pci, 0xd4, val);
-
-	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is enabled to count */
-	val = inb (TCO1_CNT + 1);
-	val &= 0xf7;
-	outb (val, TCO1_CNT + 1);
-	val = inb (TCO1_CNT + 1);
-
-	spin_unlock(&tco_lock);
-
-	if (val & 0x08)
-		return -1;
-	return 0;
-}
-
-static int tco_timer_stop (void)
-{
-	unsigned char val, val1;
-
-	spin_lock(&tco_lock);
-	/* Bit 11: TCO Timer Halt -> 1 = The TCO timer is disabled */
-	val = inb (TCO1_CNT + 1);
-	val |= 0x08;
-	outb (val, TCO1_CNT + 1);
-	val = inb (TCO1_CNT + 1);
-
-	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
-	pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-	val1 |= 0x02;
-	pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-
-	spin_unlock(&tco_lock);
-
-	if ((val & 0x08) == 0)
-		return -1;
-	return 0;
-}
-
-static int tco_timer_keepalive (void)
-{
-	spin_lock(&tco_lock);
-	/* Reload the timer by writing to the TCO Timer Reload register */
-	outb (0x01, TCO1_RLD);
-	spin_unlock(&tco_lock);
-	return 0;
-}
-
-static int tco_timer_set_heartbeat (int t)
-{
-	unsigned char val;
-	unsigned char tmrval;
-
-	tmrval = seconds_to_ticks(t);
-	/* from the specs: */
-	/* "Values of 0h-3h are ignored and should not be attempted" */
-	if (tmrval > 0x3f || tmrval < 0x04)
-		return -EINVAL;
-
-	/* Write new heartbeat to watchdog */
-	spin_lock(&tco_lock);
-	val = inb (TCO1_TMR);
-	val &= 0xc0;
-	val |= tmrval;
-	outb (val, TCO1_TMR);
-	val = inb (TCO1_TMR);
-	spin_unlock(&tco_lock);
-
-	if ((val & 0x3f) != tmrval)
-		return -EINVAL;
-
-	heartbeat = t;
-	return 0;
-}
-
-static int tco_timer_get_timeleft (int *time_left)
-{
-	unsigned char val;
-
-	spin_lock(&tco_lock);
-
-	/* read the TCO Timer */
-	val = inb (TCO1_RLD);
-	val &= 0x3f;
-
-	spin_unlock(&tco_lock);
-
-	*time_left = (int)((val * 6) / 10);
-
-	return 0;
-}
-
-/*
- *	/dev/watchdog handling
- */
-
-static int i8xx_tco_open (struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &timer_alive))
-		return -EBUSY;
-
-	/*
-	 *      Reload and activate timer
-	 */
-	tco_timer_keepalive ();
-	tco_timer_start ();
-	return nonseekable_open(inode, file);
-}
-
-static int i8xx_tco_release (struct inode *inode, struct file *file)
-{
-	/*
-	 *      Shut off the timer.
-	 */
-	if (tco_expect_close == 42) {
-		tco_timer_stop ();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
-		tco_timer_keepalive ();
-	}
-	clear_bit(0, &timer_alive);
-	tco_expect_close = 0;
-	return 0;
-}
-
-static ssize_t i8xx_tco_write (struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
-			tco_expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
-			for (i = 0; i != len; i++) {
-				char c;
-				if(get_user(c, data+i))
-					return -EFAULT;
-				if (c == 'V')
-					tco_expect_close = 42;
-			}
-		}
-
-		/* someone wrote to us, we should reload the timer */
-		tco_timer_keepalive ();
-	}
-	return len;
-}
-
-static int i8xx_tco_ioctl (struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
-{
-	int new_options, retval = -EINVAL;
-	int new_heartbeat;
-	int time_left;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		TCO_MODULE_NAME,
-	};
-
-	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user (0, p);
-
-		case WDIOC_KEEPALIVE:
-			tco_timer_keepalive ();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user (new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				tco_timer_stop ();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				tco_timer_keepalive ();
-				tco_timer_start ();
-				retval = 0;
-			}
-
-			return retval;
-		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (tco_timer_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			tco_timer_keepalive ();
-			/* Fall */
-		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
-
-		case WDIOC_GETTIMELEFT:
-		{
-			if (tco_timer_get_timeleft(&time_left))
-				return -EINVAL;
-
-			return put_user(time_left, p);
-		}
-
-		default:
-			return -ENOTTY;
-	}
-}
-
-/*
- *	Notify system
- */
-
-static int i8xx_tco_notify_sys (struct notifier_block *this, unsigned long code, void *unused)
-{
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		tco_timer_stop ();
-	}
-
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations i8xx_tco_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	i8xx_tco_write,
-	.ioctl =	i8xx_tco_ioctl,
-	.open =		i8xx_tco_open,
-	.release =	i8xx_tco_release,
-};
-
-static struct miscdevice i8xx_tco_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&i8xx_tco_fops,
-};
-
-static struct notifier_block i8xx_tco_notifier = {
-	.notifier_call =	i8xx_tco_notify_sys,
-};
-
-/*
- * Data for PCI driver interface
- *
- * This data only exists for exporting the supported
- * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
- * register a pci_driver, because someone else might one day
- * want to register another driver on the same PCI id.
- */
-static struct pci_device_id i8xx_tco_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_10) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_12) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801E_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1) },
-	{ },			/* End of list */
-};
-MODULE_DEVICE_TABLE (pci, i8xx_tco_pci_tbl);
-
-/*
- *	Init & exit routines
- */
-
-static unsigned char __init i8xx_tco_getdevice (void)
-{
-	struct pci_dev *dev = NULL;
-	u8 val1, val2;
-	u16 badr;
-	/*
-	 *      Find the PCI device
-	 */
-
-	for_each_pci_dev(dev)
-		if (pci_match_id(i8xx_tco_pci_tbl, dev)) {
-			i8xx_tco_pci = dev;
-			break;
-		}
-
-	if (i8xx_tco_pci) {
-		/*
-		 *      Find the ACPI base I/O address which is the base
-		 *      for the TCO registers (TCOBASE=ACPIBASE + 0x60)
-		 *      ACPIBASE is bits [15:7] from 0x40-0x43
-		 */
-		pci_read_config_byte (i8xx_tco_pci, 0x40, &val1);
-		pci_read_config_byte (i8xx_tco_pci, 0x41, &val2);
-		badr = ((val2 << 1) | (val1 >> 7)) << 7;
-		ACPIBASE = badr;
-		/* Something's wrong here, ACPIBASE has to be set */
-		if (badr == 0x0001 || badr == 0x0000) {
-			printk (KERN_ERR PFX "failed to get TCOBASE address\n");
-			pci_dev_put(i8xx_tco_pci);
-			return 0;
-		}
-
-		/* Check chipset's NO_REBOOT bit */
-		pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-		if (val1 & 0x02) {
-			val1 &= 0xfd;
-			pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-			pci_read_config_byte (i8xx_tco_pci, 0xd4, &val1);
-			if (val1 & 0x02) {
-				printk (KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
-				pci_dev_put(i8xx_tco_pci);
-				return 0;	/* Cannot reset NO_REBOOT bit */
-			}
-		}
-		/* Disable reboots untill the watchdog starts */
-		val1 |= 0x02;
-		pci_write_config_byte (i8xx_tco_pci, 0xd4, val1);
-
-		/* Set the TCO_EN bit in SMI_EN register */
-		if (!request_region (SMI_EN + 1, 1, "i8xx TCO")) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				SMI_EN + 1);
-			pci_dev_put(i8xx_tco_pci);
-			return 0;
-		}
-		val1 = inb (SMI_EN + 1);
-		val1 &= 0xdf;
-		outb (val1, SMI_EN + 1);
-		release_region (SMI_EN + 1, 1);
-		return 1;
-	}
-	return 0;
-}
-
-static int __init watchdog_init (void)
-{
-	int ret;
-
-	spin_lock_init(&tco_lock);
-
-	/* Check whether or not the hardware watchdog is there */
-	if (!i8xx_tco_getdevice () || i8xx_tco_pci == NULL)
-		return -ENODEV;
-
-	if (!request_region (TCOBASE, 0x10, "i8xx TCO")) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			TCOBASE);
-		ret = -EIO;
-		goto out;
-	}
-
-	/* Clear out the (probably old) status */
-	outb (0, TCO1_STS);
-	outb (3, TCO2_STS);
-
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
-	if (tco_timer_set_heartbeat (heartbeat)) {
-		heartbeat = WATCHDOG_HEARTBEAT;
-		tco_timer_set_heartbeat (heartbeat);
-		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39, using %d\n",
-			heartbeat);
-	}
-
-	ret = register_reboot_notifier(&i8xx_tco_notifier);
-	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		goto unreg_region;
-	}
-
-	ret = misc_register(&i8xx_tco_miscdev);
-	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto unreg_notifier;
-	}
-
-	tco_timer_stop ();
-
-	printk (KERN_INFO PFX "initialized (0x%04x). heartbeat=%d sec (nowayout=%d)\n",
-		TCOBASE, heartbeat, nowayout);
-
-	return 0;
-
-unreg_notifier:
-	unregister_reboot_notifier(&i8xx_tco_notifier);
-unreg_region:
-	release_region (TCOBASE, 0x10);
-out:
-	pci_dev_put(i8xx_tco_pci);
-	return ret;
-}
-
-static void __exit watchdog_cleanup (void)
-{
-	/* Stop the timer before we leave */
-	if (!nowayout)
-		tco_timer_stop ();
-
-	/* Deregister */
-	misc_deregister (&i8xx_tco_miscdev);
-	unregister_reboot_notifier(&i8xx_tco_notifier);
-	release_region (TCOBASE, 0x10);
-
-	pci_dev_put(i8xx_tco_pci);
-}
-
-module_init(watchdog_init);
-module_exit(watchdog_cleanup);
-
-MODULE_AUTHOR("Nils Faerber");
-MODULE_DESCRIPTION("TCO timer driver for i8xx chipsets");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/i8xx_tco.h b/drivers/char/watchdog/i8xx_tco.h
deleted file mode 100644
index cc14eb8..0000000
--- a/drivers/char/watchdog/i8xx_tco.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- *	i8xx_tco:	TCO timer driver for i8xx chipsets
- *
- *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights Reserved.
- *				http://www.kernelconcepts.de
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither kernel concepts nor Nils Faerber admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
- *
- *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
- *				developed for
- *                              Jentro AG, Haar/Munich (Germany)
- *
- *	TCO timer driver for i8xx chipsets
- *	based on softdog.c by Alan Cox <alan@redhat.com>
- *
- *	For history and the complete list of supported I/O Controller Hub's
- *	see i8xx_tco.c
- */
-
-
-/*
- * Some address definitions for the TCO
- */
-
-#define	TCOBASE		ACPIBASE + 0x60	/* TCO base address		*/
-#define TCO1_RLD	TCOBASE + 0x00	/* TCO Timer Reload and Current Value */
-#define TCO1_TMR	TCOBASE + 0x01	/* TCO Timer Initial Value	*/
-#define	TCO1_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
-#define	TCO1_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
-#define	TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
-#define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
-#define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
-
-#define	SMI_EN		ACPIBASE + 0x30	/* SMI Control and Enable Register */
diff --git a/drivers/char/watchdog/ibmasr.c b/drivers/char/watchdog/ibmasr.c
index 8195f50..94155f6 100644
--- a/drivers/char/watchdog/ibmasr.c
+++ b/drivers/char/watchdog/ibmasr.c
@@ -367,18 +367,17 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	rc = asr_get_base_address();
+	if (rc)
+		return rc;
+
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
+		release_region(asr_base, asr_length);
 		printk(KERN_ERR PFX "failed to register misc device\n");
 		return rc;
 	}
 
-	rc = asr_get_base_address();
-	if (rc) {
-		misc_deregister(&asr_miscdev);
-		return rc;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 76c7fa3..a0d2716 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -440,13 +440,6 @@ static int __init zf_init(void)
 	spin_lock_init(&zf_lock);
 	spin_lock_init(&zf_port_lock);
 
-	ret = misc_register(&zf_miscdev);
-	if (ret){
-		printk(KERN_ERR "can't misc_register on minor=%d\n",
-							WATCHDOG_MINOR);
-		goto out;
-	}
-
 	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
@@ -461,16 +454,23 @@ static int __init zf_init(void)
 		goto no_reboot;
 	}
 
+	ret = misc_register(&zf_miscdev);
+	if (ret){
+		printk(KERN_ERR "can't misc_register on minor=%d\n",
+							WATCHDOG_MINOR);
+		goto no_misc;
+	}
+
 	zf_set_status(0);
 	zf_set_control(0);
 
 	return 0;
 
+no_misc:
+	unregister_reboot_notifier(&zf_notifier);
 no_reboot:
 	release_region(ZF_IOBASE, 3);
 no_region:
-	misc_deregister(&zf_miscdev);
-out:
 	return ret;
 }
 
diff --git a/drivers/char/watchdog/mtx-1_wdt.c b/drivers/char/watchdog/mtx-1_wdt.c
new file mode 100644
index 0000000..419ab44
--- /dev/null
+++ b/drivers/char/watchdog/mtx-1_wdt.c
@@ -0,0 +1,238 @@
+/*
+ *      Driver for the MTX-1 Watchdog.
+ *
+ *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>, All Rights Reserved.
+ *                              http://www.4g-systems.biz
+ *
+ * 	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Neither Michael Stickel nor 4G Systems admit liability nor provide
+ *      warranty for any of this software. This material is provided
+ *      "AS-IS" and at no charge.
+ *
+ *      (c) Copyright 2005    4G Systems <info@4g-systems.biz>
+ *
+ *      Release 0.01.
+ *      Author: Michael Stickel  michael.stickel@4g-systems.biz
+ *
+ *      Release 0.02.
+ *	Author: Florian Fainelli florian@openwrt.org
+ *		use the Linux watchdog/timer APIs
+ *
+ *      The Watchdog is configured to reset the MTX-1
+ *      if it is not triggered for 100 seconds.
+ *      It should not be triggered more often than 1.6 seconds.
+ *
+ *      A timer triggers the watchdog every 5 seconds, until
+ *      it is opened for the first time. After the first open
+ *      it MUST be triggered every 2..95 seconds.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/timer.h>
+#include <linux/completion.h>
+#include <linux/jiffies.h>
+#include <linux/watchdog.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+
+#include <asm/mach-au1x00/au1000.h>
+
+#define MTX1_WDT_INTERVAL	(5 * HZ)
+
+static int ticks = 100 * HZ;
+
+static struct {
+	struct completion stop;
+	volatile int running;
+	struct timer_list timer;
+	volatile int queue;
+	int default_ticks;
+	unsigned long inuse;
+} mtx1_wdt_device;
+
+static void mtx1_wdt_trigger(unsigned long unused)
+{
+	u32 tmp;
+
+	if (mtx1_wdt_device.running)
+		ticks--;
+	/*
+	 * toggle GPIO2_15
+	 */
+	tmp = au_readl(GPIO2_DIR);
+	tmp = (tmp & ~(1<<15)) | ((~tmp) & (1<<15));
+	au_writel (tmp, GPIO2_DIR);
+
+	if (mtx1_wdt_device.queue && ticks)
+		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
+	else {
+		complete(&mtx1_wdt_device.stop);
+	}
+}
+
+static void mtx1_wdt_reset(void)
+{
+	ticks = mtx1_wdt_device.default_ticks;
+}
+
+
+static void mtx1_wdt_start(void)
+{
+	if (!mtx1_wdt_device.queue) {
+		mtx1_wdt_device.queue = 1;
+		au_writel (au_readl(GPIO2_DIR) | (u32)(1<<15), GPIO2_DIR);
+		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
+	}
+	mtx1_wdt_device.running++;
+}
+
+static int mtx1_wdt_stop(void)
+{
+	if (mtx1_wdt_device.queue) {
+		mtx1_wdt_device.queue = 0;
+		au_writel (au_readl(GPIO2_DIR) & ~((u32)(1<<15)), GPIO2_DIR);
+	}
+
+	ticks = mtx1_wdt_device.default_ticks;
+
+	return 0;
+}
+
+/* Filesystem functions */
+
+static int mtx1_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &mtx1_wdt_device.inuse))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+
+static int mtx1_wdt_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &mtx1_wdt_device.inuse);
+	return 0;
+}
+
+static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	unsigned int value;
+	static struct watchdog_info ident =
+	{
+		.options = WDIOF_CARDRESET,
+		.identity = "MTX-1 WDT",
+	};
+
+	switch(cmd) {
+		case WDIOC_KEEPALIVE:
+			mtx1_wdt_reset();
+			break;
+		case WDIOC_GETSTATUS:
+			if ( copy_to_user(argp, &value, sizeof(int)) )
+				return -EFAULT;
+			break;
+		case WDIOC_GETSUPPORT:
+			if ( copy_to_user(argp, &ident, sizeof(ident)) )
+				return -EFAULT;
+			break;
+		case WDIOC_SETOPTIONS:
+			if ( copy_from_user(&value, argp, sizeof(int)) )
+				return -EFAULT;
+			switch(value) {
+				case WDIOS_ENABLECARD:
+					mtx1_wdt_start();
+					break;
+				case WDIOS_DISABLECARD:
+					return mtx1_wdt_stop();
+				default:
+					return -EINVAL;
+			}
+			break;
+		default:
+			return -ENOTTY;
+	}
+	return 0;
+}
+
+
+static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count, loff_t *ppos)
+{
+	if (!count)
+		return -EIO;
+
+	mtx1_wdt_reset();
+	return count;
+}
+
+static struct file_operations mtx1_wdt_fops = {
+	.owner 		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= mtx1_wdt_ioctl,
+	.open 		= mtx1_wdt_open,
+	.write 		= mtx1_wdt_write,
+	.release 	= mtx1_wdt_release
+};
+
+
+static struct miscdevice mtx1_wdt_misc = {
+	.minor 	= WATCHDOG_MINOR,
+	.name 	= "watchdog",
+	.fops 	= &mtx1_wdt_fops
+};
+
+
+static int __init mtx1_wdt_init(void)
+{
+	int ret;
+
+	if ((ret = misc_register(&mtx1_wdt_misc)) < 0) {
+		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		return ret;
+	}
+
+	init_completion(&mtx1_wdt_device.stop);
+	mtx1_wdt_device.queue = 0;
+
+	clear_bit(0, &mtx1_wdt_device.inuse);
+
+	setup_timer(&mtx1_wdt_device.timer, mtx1_wdt_trigger, 0L);
+
+	mtx1_wdt_device.default_ticks = ticks;
+
+	mtx1_wdt_start();
+
+	printk(KERN_INFO "MTX-1 Watchdog driver\n");
+
+	return 0;
+}
+
+static void __exit mtx1_wdt_exit(void)
+{
+	if (mtx1_wdt_device.queue) {
+		mtx1_wdt_device.queue = 0;
+		wait_for_completion(&mtx1_wdt_device.stop);
+	}
+	misc_deregister(&mtx1_wdt_misc);
+}
+
+module_init(mtx1_wdt_init);
+module_exit(mtx1_wdt_exit);
+
+MODULE_AUTHOR("Michael Stickel, Florian Fainelli");
+MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/watchdog/pcwd.c b/drivers/char/watchdog/pcwd.c
index 6e8b570..7b41434 100644
--- a/drivers/char/watchdog/pcwd.c
+++ b/drivers/char/watchdog/pcwd.c
@@ -59,10 +59,10 @@
 #include <linux/jiffies.h>	/* For jiffies stuff */
 #include <linux/miscdevice.h>	/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>	/* For the watchdog specific items */
-#include <linux/notifier.h>	/* For notifier support */
-#include <linux/reboot.h>	/* For reboot_notifier stuff */
+#include <linux/reboot.h>	/* For kernel_power_off() */
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/fs.h>		/* For file operations */
+#include <linux/isa.h>		/* For isa devices */
 #include <linux/ioport.h>	/* For io-port access */
 #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
 
@@ -70,8 +70,8 @@
 #include <asm/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
-#define WATCHDOG_VERSION "1.18"
-#define WATCHDOG_DATE "21 Jan 2007"
+#define WATCHDOG_VERSION "1.20"
+#define WATCHDOG_DATE "18 Feb 2007"
 #define WATCHDOG_DRIVER_NAME "ISA-PC Watchdog"
 #define WATCHDOG_NAME "pcwd"
 #define PFX WATCHDOG_NAME ": "
@@ -89,6 +89,15 @@
 #define	PCWD_REVISION_C		2
 
 /*
+ * These are the auto-probe addresses available.
+ *
+ * Revision A only uses ports 0x270 and 0x370.  Revision C introduced 0x350.
+ * Revision A has an address range of 2 addresses, while Revision C has 4.
+ */
+#define PCWD_ISA_NR_CARDS	3
+static int pcwd_ioports[] = { 0x270, 0x350, 0x370, 0x000 };
+
+/*
  * These are the defines that describe the control status bits for the
  * PCI-PC Watchdog card.
 */
@@ -485,7 +494,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk (KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX "Temperature overheat trip!\n");
 				kernel_power_off();
 				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
@@ -497,7 +506,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk (KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX "Temperature overheat trip!\n");
 				kernel_power_off();
 				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
@@ -734,20 +743,6 @@ static int pcwd_temp_close(struct inode *inode, struct file *file)
 }
 
 /*
- *	Notify system
- */
-
-static int pcwd_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
-{
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		pcwd_stop();
-	}
-
-	return NOTIFY_DONE;
-}
-
-/*
  *	Kernel Interfaces
  */
 
@@ -780,10 +775,6 @@ static struct miscdevice temp_miscdev = {
 	.fops =		&pcwd_temp_fops,
 };
 
-static struct notifier_block pcwd_notifier = {
-	.notifier_call =	pcwd_notify_sys,
-};
-
 /*
  *	Init & exit routines
  */
@@ -803,10 +794,67 @@ static inline int get_revision(void)
 	return r;
 }
 
-static int __devinit pcwatchdog_init(int base_addr)
+/*
+ *  The ISA cards have a heartbeat bit in one of the registers, which
+ *  register is card dependent.  The heartbeat bit is monitored, and if
+ *  found, is considered proof that a Berkshire card has been found.
+ *  The initial rate is once per second at board start up, then twice
+ *  per second for normal operation.
+ */
+static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
+{
+	int base_addr=pcwd_ioports[id];
+	int port0, last_port0;	/* Reg 0, in case it's REV A */
+	int port1, last_port1;	/* Register 1 for REV C cards */
+	int i;
+	int retval;
+
+	if (debug >= DEBUG)
+		printk(KERN_DEBUG PFX "pcwd_isa_match id=%d\n",
+			id);
+
+	if (!request_region (base_addr, 4, "PCWD")) {
+		printk(KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
+		return 0;
+	}
+
+	retval = 0;
+
+	port0 = inb_p(base_addr);	/* For REV A boards */
+	port1 = inb_p(base_addr + 1);	/* For REV C boards */
+	if (port0 != 0xff || port1 != 0xff) {
+		/* Not an 'ff' from a floating bus, so must be a card! */
+		for (i = 0; i < 4; ++i) {
+
+			msleep(500);
+
+			last_port0 = port0;
+			last_port1 = port1;
+
+			port0 = inb_p(base_addr);
+			port1 = inb_p(base_addr + 1);
+
+			/* Has either hearbeat bit changed?  */
+			if ((port0 ^ last_port0) & WD_HRTBT ||
+			    (port1 ^ last_port1) & WD_REVC_HRBT) {
+				retval = 1;
+				break;
+			}
+		}
+	}
+	release_region (base_addr, 4);
+
+	return retval;
+}
+
+static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 {
 	int ret;
 
+	if (debug >= DEBUG)
+		printk(KERN_DEBUG PFX "pcwd_isa_probe id=%d\n",
+			id);
+
 	cards_found++;
 	if (cards_found == 1)
 		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n", WD_VER);
@@ -816,11 +864,13 @@ static int __devinit pcwatchdog_init(int base_addr)
 		return -ENODEV;
 	}
 
-	if (base_addr == 0x0000) {
+	if (pcwd_ioports[id] == 0x0000) {
 		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
 		return -ENODEV;
 	}
-	pcwd_private.io_addr = base_addr;
+	pcwd_private.io_addr = pcwd_ioports[id];
+
+	spin_lock_init(&pcwd_private.io_lock);
 
 	/* Check card's revision */
 	pcwd_private.revision = get_revision();
@@ -828,8 +878,8 @@ static int __devinit pcwatchdog_init(int base_addr)
 	if (!request_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			pcwd_private.io_addr);
-		pcwd_private.io_addr = 0x0000;
-		return -EIO;
+		ret=-EIO;
+		goto error_request_region;
 	}
 
 	/* Initial variables */
@@ -865,24 +915,12 @@ static int __devinit pcwatchdog_init(int base_addr)
 			WATCHDOG_HEARTBEAT);
 	}
 
-	ret = register_reboot_notifier(&pcwd_notifier);
-	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
-		release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
-		pcwd_private.io_addr = 0x0000;
-		return ret;
-	}
-
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
 			printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 				TEMP_MINOR, ret);
-			unregister_reboot_notifier(&pcwd_notifier);
-			release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
-			pcwd_private.io_addr = 0x0000;
-			return ret;
+			goto error_misc_register_temp;
 		}
 	}
 
@@ -890,22 +928,34 @@ static int __devinit pcwatchdog_init(int base_addr)
 	if (ret) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		if (pcwd_private.supports_temp)
-			misc_deregister(&temp_miscdev);
-		unregister_reboot_notifier(&pcwd_notifier);
-		release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
-		pcwd_private.io_addr = 0x0000;
-		return ret;
+		goto error_misc_register_watchdog;
 	}
 
 	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
+
+error_misc_register_watchdog:
+	if (pcwd_private.supports_temp)
+		misc_deregister(&temp_miscdev);
+error_misc_register_temp:
+	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
+error_request_region:
+	pcwd_private.io_addr = 0x0000;
+	cards_found--;
+	return ret;
 }
 
-static void __devexit pcwatchdog_exit(void)
+static int __devexit pcwd_isa_remove(struct device *dev, unsigned int id)
 {
+	if (debug >= DEBUG)
+		printk(KERN_DEBUG PFX "pcwd_isa_remove id=%d\n",
+			id);
+
+	if (!pcwd_private.io_addr)
+		return 1;
+
 	/*  Disable the board  */
 	if (!nowayout)
 		pcwd_stop();
@@ -914,102 +964,50 @@ static void __devexit pcwatchdog_exit(void)
 	misc_deregister(&pcwd_miscdev);
 	if (pcwd_private.supports_temp)
 		misc_deregister(&temp_miscdev);
-	unregister_reboot_notifier(&pcwd_notifier);
 	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
 	pcwd_private.io_addr = 0x0000;
 	cards_found--;
+
+	return 0;
 }
 
-/*
- *  The ISA cards have a heartbeat bit in one of the registers, which
- *  register is card dependent.  The heartbeat bit is monitored, and if
- *  found, is considered proof that a Berkshire card has been found.
- *  The initial rate is once per second at board start up, then twice
- *  per second for normal operation.
- */
-static int __init pcwd_checkcard(int base_addr)
+static void pcwd_isa_shutdown(struct device *dev, unsigned int id)
 {
-	int port0, last_port0;	/* Reg 0, in case it's REV A */
-	int port1, last_port1;	/* Register 1 for REV C cards */
-	int i;
-	int retval;
-
-	if (!request_region (base_addr, 4, "PCWD")) {
-		printk (KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
-		return 0;
-	}
-
-	retval = 0;
-
-	port0 = inb_p(base_addr);	/* For REV A boards */
-	port1 = inb_p(base_addr + 1);	/* For REV C boards */
-	if (port0 != 0xff || port1 != 0xff) {
-		/* Not an 'ff' from a floating bus, so must be a card! */
-		for (i = 0; i < 4; ++i) {
-
-			msleep(500);
-
-			last_port0 = port0;
-			last_port1 = port1;
-
-			port0 = inb_p(base_addr);
-			port1 = inb_p(base_addr + 1);
-
-			/* Has either hearbeat bit changed?  */
-			if ((port0 ^ last_port0) & WD_HRTBT ||
-			    (port1 ^ last_port1) & WD_REVC_HRBT) {
-				retval = 1;
-				break;
-			}
-		}
-	}
-	release_region (base_addr, 4);
+	if (debug >= DEBUG)
+		printk(KERN_DEBUG PFX "pcwd_isa_shutdown id=%d\n",
+			id);
 
-	return retval;
+	pcwd_stop();
 }
 
-/*
- * These are the auto-probe addresses available.
- *
- * Revision A only uses ports 0x270 and 0x370.  Revision C introduced 0x350.
- * Revision A has an address range of 2 addresses, while Revision C has 4.
- */
-static int pcwd_ioports[] = { 0x270, 0x350, 0x370, 0x000 };
+static struct isa_driver pcwd_isa_driver = {
+	.match		= pcwd_isa_match,
+	.probe		= pcwd_isa_probe,
+	.remove		= __devexit_p(pcwd_isa_remove),
+	.shutdown	= pcwd_isa_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= WATCHDOG_NAME,
+	},
+};
 
 static int __init pcwd_init_module(void)
 {
-	int i, found = 0;
-
-	spin_lock_init(&pcwd_private.io_lock);
-
-	for (i = 0; pcwd_ioports[i] != 0; i++) {
-		if (pcwd_checkcard(pcwd_ioports[i])) {
-			if (!(pcwatchdog_init(pcwd_ioports[i])))
-				found++;
-		}
-	}
-
-	if (!found) {
-		printk (KERN_INFO PFX "No card detected, or port not available\n");
-		return -ENODEV;
-	}
-
-	return 0;
+	return isa_register_driver(&pcwd_isa_driver, PCWD_ISA_NR_CARDS);
 }
 
 static void __exit pcwd_cleanup_module(void)
 {
-	if (pcwd_private.io_addr)
-		pcwatchdog_exit();
-
+	isa_unregister_driver(&pcwd_isa_driver);
 	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(pcwd_init_module);
 module_exit(pcwd_cleanup_module);
 
-MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>");
+MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>, Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("Berkshire ISA-PC Watchdog driver");
+MODULE_VERSION(WATCHDOG_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS_MISCDEV(TEMP_MINOR);
diff --git a/drivers/char/watchdog/pcwd_usb.c b/drivers/char/watchdog/pcwd_usb.c
index 31037f9..1e7a671 100644
--- a/drivers/char/watchdog/pcwd_usb.c
+++ b/drivers/char/watchdog/pcwd_usb.c
@@ -146,7 +146,7 @@ struct usb_pcwd_private {
 	atomic_t		cmd_received;		/* true if we received a report after a command */
 
 	int			exists;			/* Wether or not the device exists */
-	struct semaphore	sem;			/* locks this structure */
+	struct mutex		mtx;			/* locks this structure */
 };
 static struct usb_pcwd_private *usb_pcwd_device;
 
@@ -635,7 +635,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 
 	usb_pcwd_device = usb_pcwd;
 
-	init_MUTEX (&usb_pcwd->sem);
+	mutex_init(&usb_pcwd->mtx);
 	usb_pcwd->udev = udev;
 	usb_pcwd->interface = interface;
 	usb_pcwd->interface_number = iface_desc->desc.bInterfaceNumber;
@@ -763,7 +763,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 	usb_pcwd = usb_get_intfdata (interface);
 	usb_set_intfdata (interface, NULL);
 
-	down (&usb_pcwd->sem);
+	mutex_lock(&usb_pcwd->mtx);
 
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -777,7 +777,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 	misc_deregister(&usb_pcwd_temperature_miscdev);
 	unregister_reboot_notifier(&usb_pcwd_notifier);
 
-	up (&usb_pcwd->sem);
+	mutex_unlock(&usb_pcwd->mtx);
 
 	/* Delete the USB PCWD device */
 	usb_pcwd_delete(usb_pcwd);
diff --git a/drivers/char/watchdog/s3c2410_wdt.c b/drivers/char/watchdog/s3c2410_wdt.c
index dff6cb5..20fa29c 100644
--- a/drivers/char/watchdog/s3c2410_wdt.c
+++ b/drivers/char/watchdog/s3c2410_wdt.c
@@ -379,14 +379,14 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	DBG("probe: mapped wdt_base=%p\n", wdt_base);
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
+	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (wdt_irq == NULL) {
 		printk(KERN_INFO PFX "failed to get irq resource\n");
 		ret = -ENOENT;
 		goto err_map;
 	}
 
-	ret = request_irq(res->start, s3c2410wdt_irq, 0, pdev->name, pdev);
+	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
 	if (ret != 0) {
 		printk(KERN_INFO PFX "failed to install irq (%d)\n", ret);
 		goto err_map;
diff --git a/drivers/char/watchdog/sbc8360.c b/drivers/char/watchdog/sbc8360.c
index 67ae426..285d852 100644
--- a/drivers/char/watchdog/sbc8360.c
+++ b/drivers/char/watchdog/sbc8360.c
@@ -333,18 +333,17 @@ static int __init sbc8360_init(void)
 	int res;
 	unsigned long int mseconds = 60000;
 
-	spin_lock_init(&sbc8360_lock);
-	res = misc_register(&sbc8360_miscdev);
-	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
-		goto out_nomisc;
+	if (timeout < 0 || timeout > 63) {
+		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
+		res = -EINVAL;
+		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
 		printk(KERN_ERR PFX "ENABLE method I/O %X is not available.\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
-		goto out_noenablereg;
+		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
 		printk(KERN_ERR PFX
@@ -360,10 +359,11 @@ static int __init sbc8360_init(void)
 		goto out_noreboot;
 	}
 
-	if (timeout < 0 || timeout > 63) {
-		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
-		res = -EINVAL;
-		goto out_noreboot;
+	spin_lock_init(&sbc8360_lock);
+	res = misc_register(&sbc8360_miscdev);
+	if (res) {
+		printk(KERN_ERR PFX "failed to register misc device\n");
+		goto out_nomisc;
 	}
 
 	wd_margin = wd_times[timeout][0];
@@ -383,13 +383,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
+      out_nomisc:
+	unregister_reboot_notifier(&sbc8360_notifier);
       out_noreboot:
-	release_region(SBC8360_ENABLE, 1);
 	release_region(SBC8360_BASETIME, 1);
-      out_noenablereg:
       out_nobasetimereg:
-	misc_deregister(&sbc8360_miscdev);
-      out_nomisc:
+	release_region(SBC8360_ENABLE, 1);
+      out:
 	return res;
 }
 
diff --git a/drivers/char/watchdog/w83627hf_wdt.c b/drivers/char/watchdog/w83627hf_wdt.c
index 337ee42..b46e7f4 100644
--- a/drivers/char/watchdog/w83627hf_wdt.c
+++ b/drivers/char/watchdog/w83627hf_wdt.c
@@ -1,5 +1,8 @@
 /*
- *	w83627hf WDT driver
+ *	w83627hf/thf WDT driver
+ *
+ *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
+ *		added support for W83627THF.
  *
  *	(c) Copyright 2003 Pádraig Brady <P@draigBrady.com>
  *
@@ -39,7 +42,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#define WATCHDOG_NAME "w83627hf WDT"
+#define WATCHDOG_NAME "w83627hf/thf WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -50,7 +53,7 @@ static spinlock_t io_lock;
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2E;
 module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83627hf WDT io port (default 0x2E)");
+MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
@@ -71,9 +74,19 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 static void
 w83627hf_select_wd_register(void)
 {
+	unsigned char c;
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
 
+	outb(0x20, WDT_EFER); 	/* check chip version	*/
+	c = inb(WDT_EFDR);
+	if (c == 0x82) {	/* W83627THF 		*/
+		outb_p(0x2b, WDT_EFER); /* select GPIO3 */
+		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
+		outb_p(0x2b, WDT_EFER);
+		outb_p(c, WDT_EFDR);	/* set GPIO3 to WDT0 */
+	}
+
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
 	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
 	outb_p(0x30, WDT_EFER); /* select CR30 */
@@ -311,7 +324,7 @@ wdt_init(void)
 
 	spin_lock_init(&io_lock);
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF Super I/O chip initialising.\n");
+	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
@@ -367,5 +380,5 @@ module_exit(wdt_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pádraig Brady <P@draigBrady.com>");
-MODULE_DESCRIPTION("w83627hf WDT driver");
+MODULE_DESCRIPTION("w83627hf/thf WDT driver");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

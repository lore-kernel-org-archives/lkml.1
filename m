Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbXDJTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbXDJTts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXDJTts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:49:48 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:35418 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXDJTtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:49:47 -0400
Date: Tue, 10 Apr 2007 21:48:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/30] Use menuconfig objects - APM
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102129180.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(I hope Andi is the right one to Cc, otherwise please add, thanks!)


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/arch/i386/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/Kconfig
+++ linux-2.6.21-rc5/arch/i386/Kconfig
@@ -915,12 +915,9 @@ source kernel/power/Kconfig
 
 source "drivers/acpi/Kconfig"
 
-menu "APM (Advanced Power Management) BIOS Support"
-depends on PM && !X86_VISWS
-
-config APM
+menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
-	depends on PM
+	depends on PM && !X86_VISWS
 	---help---
 	  APM is a BIOS specification for saving power using several different
 	  techniques. This is mostly useful for battery powered laptops with
@@ -977,9 +974,10 @@ config APM
 	  To compile this driver as a module, choose M here: the
 	  module will be called apm.
 
+if APM
+
 config APM_IGNORE_USER_SUSPEND
 	bool "Ignore USER SUSPEND"
-	depends on APM
 	help
 	  This option will ignore USER SUSPEND requests. On machines with a
 	  compliant APM BIOS, you want to say N. However, on the NEC Versa M
@@ -987,7 +985,6 @@ config APM_IGNORE_USER_SUSPEND
 
 config APM_DO_ENABLE
 	bool "Enable PM at boot time"
-	depends on APM
 	---help---
 	  Enable APM features at boot time. From page 36 of the APM BIOS
 	  specification: "When disabled, the APM BIOS does not automatically
@@ -1005,7 +1002,6 @@ config APM_DO_ENABLE
 
 config APM_CPU_IDLE
 	bool "Make CPU Idle calls when idle"
-	depends on APM
 	help
 	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
 	  On some machines, this can activate improved power savings, such as
@@ -1017,7 +1013,6 @@ config APM_CPU_IDLE
 
 config APM_DISPLAY_BLANK
 	bool "Enable console blanking using APM"
-	depends on APM
 	help
 	  Enable console blanking using the APM. Some laptops can use this to
 	  turn off the LCD backlight when the screen blanker of the Linux
@@ -1031,7 +1026,6 @@ config APM_DISPLAY_BLANK
 
 config APM_RTC_IS_GMT
 	bool "RTC stores time in GMT"
-	depends on APM
 	help
 	  Say Y here if your RTC (Real Time Clock a.k.a. hardware clock)
 	  stores the time in GMT (Greenwich Mean Time). Say N if your RTC
@@ -1044,7 +1038,6 @@ config APM_RTC_IS_GMT
 
 config APM_ALLOW_INTS
 	bool "Allow interrupts during APM BIOS calls"
-	depends on APM
 	help
 	  Normally we disable external interrupts while we are making calls to
 	  the APM BIOS as a measure to lessen the effects of a badly behaving
@@ -1055,13 +1048,12 @@ config APM_ALLOW_INTS
 
 config APM_REAL_MODE_POWER_OFF
 	bool "Use real mode APM BIOS call to power off"
-	depends on APM
 	help
 	  Use real mode APM BIOS calls to switch off the computer. This is
 	  a work-around for a number of buggy BIOSes. Switch this option on if
 	  your computer crashes instead of powering off properly.
 
-endmenu
+endif # APM
 
 source "arch/i386/kernel/cpu/cpufreq/Kconfig"
 
#<EOF>

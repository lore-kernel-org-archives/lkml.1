Return-Path: <linux-kernel-owner+w=401wt.eu-S1161596AbXD2XvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161596AbXD2XvC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161605AbXD2XrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:41961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161602AbXD2Xq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:27 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [17/26] i386: Use menuconfig objects - APM
Message-Id: <20070429234626.D0A1C150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Engelhardt <jengelh@linux01.gwdg.de>

(I hope Andi is the right one to Cc, otherwise please add, thanks!)


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
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
 
 config APM_ALLOW_INTS
 	bool "Allow interrupts during APM BIOS calls"
-	depends on APM
 	help
 	  Normally we disable external interrupts while we are making calls to
 	  the APM BIOS as a measure to lessen the effects of a badly behaving
@@ -1042,13 +1036,12 @@ config APM_ALLOW_INTS
 
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
 

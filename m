Return-Path: <linux-kernel-owner+w=401wt.eu-S934806AbYBAEqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806AbYBAEqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764424AbYBAEmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:13 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757604AbYBAEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516606"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 23/37] Suspend: Clean up Kconfig (V2)
Date: Thu, 31 Jan 2008 23:36:54 -0500
Message-Id: <9a72d19a83ff28dd65eae54e210a9141ad993e88.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

This cleans up the suspend Kconfig and removes the need to
declare centrally which architectures support suspend. All
architectures that currently support suspend are modified
accordingly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/Kconfig      |    3 +++
 arch/blackfin/Kconfig |    4 ++++
 arch/frv/Kconfig      |    5 +++++
 arch/mips/Kconfig     |    4 ++++
 arch/powerpc/Kconfig  |    4 ++++
 arch/sh/Kconfig       |    4 ++++
 arch/x86/Kconfig      |    4 ++++
 kernel/power/Kconfig  |   21 +++------------------
 8 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 77201d3..a00d8b9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1035,6 +1035,9 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
 endmenu
 
 source "net/Kconfig"
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index fc7ca86..4802eb7 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -898,6 +898,10 @@ endmenu
 menu "Power management options"
 source "kernel/power/Kconfig"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 choice
 	prompt "Select PM Wakeup Event Source"
 	default PM_WAKEUP_GPIO_BY_SIC_IWR
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 43153e7..2e25b95 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -357,6 +357,11 @@ source "drivers/pcmcia/Kconfig"
 #	  should probably wait a while.
 
 menu "Power management options"
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source kernel/power/Kconfig
 endmenu
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4fad0a3..e387f3a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2086,6 +2086,10 @@ endmenu
 
 menu "Power management options"
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source "kernel/power/Kconfig"
 
 endmenu
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 68f0cf7..824140d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -166,6 +166,10 @@ config ARCH_HIBERNATION_POSSIBLE
 	depends on (PPC64 && HIBERNATE_64) || (PPC32 && HIBERNATE_32)
 	default y
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200
+
 config PPC_DCR_NATIVE
 	bool
 	default n
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1cd9c8f..b30c4c3 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -882,6 +882,10 @@ endmenu
 menu "Power management options (EXPERIMENTAL)"
 depends on EXPERIMENTAL && SYS_SUPPORTS_PM
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !SMP
+
 source kernel/power/Kconfig
 
 endmenu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9c511dd..340e81a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -113,6 +113,10 @@ config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
 
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+	depends on !X86_VOYAGER
+
 config ZONE_DMA32
 	bool
 	default X86_64
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index fd76d54..f8153fd 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -85,7 +85,7 @@ config PM_TRACE_RTC
 config PM_SLEEP_SMP
 	bool
 	depends on SMP
-	depends on SUSPEND_SMP_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
+	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
 	default y
@@ -95,29 +95,14 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
-config SUSPEND_UP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) || PPC || ARM || BLACKFIN || MIPS \
-		   || SUPERH || FRV
-	depends on !SMP
-	default y
-
-config SUSPEND_SMP_POSSIBLE
-	bool
-	depends on (X86 && !X86_VOYAGER) \
-		   || (PPC && (PPC_PSERIES || PPC_PMAC)) || ARM
-	depends on SMP
-	default y
-
 config SUSPEND
 	bool "Suspend to RAM and standby"
-	depends on PM
-	depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
+	depends on PM && ARCH_SUSPEND_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
 	  powered and thus its contents are preserved, such as the
-	  suspend-to-RAM state (i.e. the ACPI S3 state).
+	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
-- 
1.5.4.rc5.16.gc0279


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZFWHO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZFWHO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZFWHOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:11 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:55156 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZFWHOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:10 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/8] SFI: Simple Firmware Interface - new Linux sub-system
Date: Tue, 23 Jun 2009 03:13:59 -0400
Message-id: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

CONFIG_SFI=y enables the kernel to boot and run optimally
on platforms that support the Simple Firmware Interface.

Thanks to Jacob Pan for prototyping the initial Linux SFI support,
and to Feng Tang for Linux bring-up and debug in emulation
and on hardware.

See http://simplefirmware.org for more information on SFI.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 MAINTAINERS                         |   12 ++++++++++++
 arch/x86/Kconfig                    |    2 ++
 drivers/sfi/Kconfig                 |   16 ++++++++++++++++
 4 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 drivers/sfi/Kconfig

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd5cac0..a4797d6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -92,6 +92,7 @@ parameter is applicable:
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	SERIAL	Serial support is enabled.
+	SFI	Simple Firmware Interface
 	SH	SuperH architecture is enabled.
 	SMP	The kernel is an SMP kernel.
 	SPARC	Sparc architecture is enabled.
@@ -2082,6 +2083,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			If enabled at boot time, /selinux/disable can be used
 			later to disable prior to initial policy load.
 
+	sfi=		[SFI,X86] Simple Firmware Interface
+			Format: { "off" }
+			off -- disable SFI
+
 	serialnumber	[BUGS=X86-32]
 
 	shapers=	[NET]
diff --git a/MAINTAINERS b/MAINTAINERS
index cf4abdd..1939b4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5105,6 +5105,18 @@ L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/shpchp*
 
+SIMPLE FIRMWARE INTERFACE (SFI)
+P:	Len Brown
+M:	lenb@kernel.org
+L:	sfi-devel@simplefirmware.org
+W:	http://simplefirmware.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
+S:	Supported
+F:	arch/x86/kernel/*sfi*
+F:	drivers/sfi/
+F:	include/linux/sfi*.h
+
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..06341a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1641,6 +1641,8 @@ source "kernel/power/Kconfig"
 
 source "drivers/acpi/Kconfig"
 
+source "drivers/sfi/Kconfig"
+
 config X86_APM_BOOT
 	bool
 	default y
diff --git a/drivers/sfi/Kconfig b/drivers/sfi/Kconfig
new file mode 100644
index 0000000..b217f32
--- /dev/null
+++ b/drivers/sfi/Kconfig
@@ -0,0 +1,16 @@
+#
+# SFI Configuration
+#
+
+menuconfig SFI
+	bool "SFI (Simple Firmware Interface) Support"
+	depends on X86
+	default n
+	---help---
+	The Simple Firmware Interface (SFI) provides a lightweight method
+	for platform firmware to pass information to the Operating System
+	via static tables in memory.
+
+	For more information, see http://simplefirmware.org
+
+	Say 'Y' here to enable the kernel to boot on SFI-only platforms.
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZHNUmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZHNUmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZHNUlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:41:40 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:53749 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZHNUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:39 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 01/11] ACPI: Move definition of PREFIX from acpi_bus.h to
 internal..h
Date: Fri, 14 Aug 2009 16:38:05 -0400
Message-id: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Linux/ACPI core files using internal.h all PREFIX "ACPI: ",
however, not all ACPI drivers use/want it -- and they
should not have to #undef PREFIX to define their own.

Add GPL commment to internal.h while we are there.

This does not change any actual console output,
asside from a whitespace fix.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/pci/mmconfig-shared.c        |    2 ++
 drivers/acpi/ac.c                     |    2 ++
 drivers/acpi/battery.c                |    2 ++
 drivers/acpi/blacklist.c              |    2 ++
 drivers/acpi/button.c                 |    2 ++
 drivers/acpi/cm_sbs.c                 |    2 ++
 drivers/acpi/container.c              |    2 ++
 drivers/acpi/dock.c                   |    2 ++
 drivers/acpi/ec.c                     |    1 -
 drivers/acpi/event.c                  |    2 ++
 drivers/acpi/fan.c                    |    2 ++
 drivers/acpi/glue.c                   |    2 ++
 drivers/acpi/internal.h               |   22 +++++++++++++++++++++-
 drivers/acpi/numa.c                   |    2 ++
 drivers/acpi/pci_irq.c                |    2 ++
 drivers/acpi/pci_link.c               |    2 ++
 drivers/acpi/pci_root.c               |    2 ++
 drivers/acpi/power.c                  |    2 ++
 drivers/acpi/processor_core.c         |    2 ++
 drivers/acpi/processor_idle.c         |    2 ++
 drivers/acpi/processor_perflib.c      |    2 ++
 drivers/acpi/processor_thermal.c      |    2 ++
 drivers/acpi/processor_throttling.c   |    2 ++
 drivers/acpi/sbs.c                    |    2 ++
 drivers/acpi/sbshc.c                  |    2 ++
 drivers/acpi/system.c                 |    2 ++
 drivers/acpi/thermal.c                |    2 ++
 drivers/acpi/utils.c                  |    2 ++
 drivers/acpi/video.c                  |    2 ++
 drivers/acpi/video_detect.c           |    2 ++
 drivers/pci/dmar.c                    |    3 +--
 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 drivers/platform/x86/wmi.c            |    1 -
 include/acpi/acpi_bus.h               |    2 --
 34 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 712443e..81d3466 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -18,6 +18,8 @@
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 
+#define PREFIX "ACPI: "
+
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 0df8fcb..98b9690 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -37,6 +37,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_AC_CLASS			"ac_adapter"
 #define ACPI_AC_DEVICE_NAME		"AC Adapter"
 #define ACPI_AC_FILE_STATE		"state"
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 58b4517..f8c3d1b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -45,6 +45,8 @@
 #include <linux/power_supply.h>
 #endif
 
+#define PREFIX "ACPI: "
+
 #define ACPI_BATTERY_VALUE_UNKNOWN 0xFFFFFFFF
 
 #define ACPI_BATTERY_CLASS		"battery"
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index f6baa77..19152ea 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -34,6 +34,8 @@
 #include <acpi/acpi_bus.h>
 #include <linux/dmi.h>
 
+#include "internal.h"
+
 enum acpi_blacklist_predicates {
 	all_versions,
 	less_than_or_equal,
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9195deb..d295bdc 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -33,6 +33,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_BUTTON_CLASS		"button"
 #define ACPI_BUTTON_FILE_INFO		"info"
 #define ACPI_BUTTON_FILE_STATE		"state"
diff --git a/drivers/acpi/cm_sbs.c b/drivers/acpi/cm_sbs.c
index 332fe4b..6c9ee68 100644
--- a/drivers/acpi/cm_sbs.c
+++ b/drivers/acpi/cm_sbs.c
@@ -28,6 +28,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 ACPI_MODULE_NAME("cm_sbs");
 #define ACPI_AC_CLASS		"ac_adapter"
 #define ACPI_BATTERY_CLASS	"battery"
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index fe0cdf8..5f2c3c0 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -35,6 +35,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/container.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_CONTAINER_DEVICE_NAME	"ACPI container device"
 #define ACPI_CONTAINER_CLASS		"container"
 
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index efb959d..9a85566 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -33,6 +33,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_DOCK_DRIVER_DESCRIPTION "ACPI Dock Station Driver"
 
 ACPI_MODULE_NAME("dock");
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 391f331..5180f0f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -47,7 +47,6 @@
 #define ACPI_EC_DEVICE_NAME		"Embedded Controller"
 #define ACPI_EC_FILE_INFO		"info"
 
-#undef PREFIX
 #define PREFIX				"ACPI: EC: "
 
 /* EC status register */
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index aeb7e5f..c511071 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -14,6 +14,8 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
+#include "internal.h"
+
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("event");
 
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 53698ea..f419849 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -34,6 +34,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_FAN_CLASS			"fan"
 #define ACPI_FAN_FILE_STATE		"state"
 
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index a8a5c29..dc36a44 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -12,6 +12,8 @@
 #include <linux/rwsem.h>
 #include <linux/acpi.h>
 
+#include "internal.h"
+
 #define ACPI_GLUE_DEBUG	0
 #if ACPI_GLUE_DEBUG
 #define DBG(x...) printk(PREFIX x)
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 11a69b5..074cf86 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -1,4 +1,24 @@
-/* For use by Linux/ACPI infrastructure, not drivers */
+/*
+ * acpi/internal.h
+ * For use by Linux/ACPI infrastructure, not drivers
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#define PREFIX "ACPI: "
 
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index d440ccd..202dd0c 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -30,6 +30,8 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_NUMA	0x80000000
 #define _COMPONENT	ACPI_NUMA
 ACPI_MODULE_NAME("numa");
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index b794eb8..843699e 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -40,6 +40,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_irq");
 
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 16e0f9d..394ae89 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -43,6 +43,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define _COMPONENT			ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_link");
 #define ACPI_PCI_LINK_CLASS		"pci_irq_routing"
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 55b5b90..dee9167 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -36,6 +36,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_root");
 #define ACPI_PCI_ROOT_CLASS		"pci_bridge"
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index d74365d..e86603f 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -44,6 +44,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define _COMPONENT			ACPI_POWER_COMPONENT
 ACPI_MODULE_NAME("power");
 #define ACPI_POWER_CLASS		"power_resource"
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 84e0f3c..5249840 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -59,6 +59,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_PROCESSOR_CLASS		"processor"
 #define ACPI_PROCESSOR_DEVICE_NAME	"Processor"
 #define ACPI_PROCESSOR_FILE_INFO	"info"
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0efa59e..e605a00 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -60,6 +60,8 @@
 #include <acpi/processor.h>
 #include <asm/processor.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_PROCESSOR_CLASS            "processor"
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_idle");
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 60e543d..11088cf 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -39,6 +39,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_PROCESSOR_CLASS		"processor"
 #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 39838c6..39ed8d1 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -40,6 +40,8 @@
 #include <acpi/processor.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_PROCESSOR_CLASS            "processor"
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_thermal");
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 2275437..e175042 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -41,6 +41,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_PROCESSOR_CLASS            "processor"
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_throttling");
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 4b214b7..52b9db8 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -46,6 +46,8 @@
 
 #include "sbshc.h"
 
+#define PREFIX "ACPI: "
+
 #define ACPI_SBS_CLASS			"sbs"
 #define ACPI_AC_CLASS			"ac_adapter"
 #define ACPI_BATTERY_CLASS		"battery"
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index 0619734..d933980 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -15,6 +15,8 @@
 #include <linux/interrupt.h>
 #include "sbshc.h"
 
+#define PREFIX "ACPI: "
+
 #define ACPI_SMB_HC_CLASS	"smbus_host_controller"
 #define ACPI_SMB_HC_DEVICE_NAME	"ACPI SMBus HC"
 
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 9c61ab2..d112829 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -31,6 +31,8 @@
 
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("system");
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 564ea14..65f6781 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -47,6 +47,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_THERMAL_CLASS		"thermal_zone"
 #define ACPI_THERMAL_DEVICE_NAME	"Thermal Zone"
 #define ACPI_THERMAL_FILE_STATE		"state"
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index f844941..811fec1 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -30,6 +30,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#include "internal.h"
+
 #define _COMPONENT		ACPI_BUS_COMPONENT
 ACPI_MODULE_NAME("utils");
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 8851315..a0fa394 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -44,6 +44,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_VIDEO_CLASS		"video"
 #define ACPI_VIDEO_BUS_NAME		"Video Bus"
 #define ACPI_VIDEO_DEVICE_NAME		"Video Device"
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 7cd2b63..7032f25 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -38,6 +38,8 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 
+#define PREFIX "ACPI: "
+
 ACPI_MODULE_NAME("video");
 #define _COMPONENT		ACPI_VIDEO_COMPONENT
 
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..998f02d 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -34,8 +34,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-#undef PREFIX
-#define PREFIX "DMAR:"
+#define PREFIX "DMAR: "
 
 /* No locks are needed as DMA remapping hardware unit
  * list is constructed at boot time and hotplug of
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 218b9a1..eabddc9 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -700,7 +700,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 		goto end;
 	}
 
-	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
+	printk(KERN_INFO "ACPI: %s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
@@ -874,7 +874,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 		goto end;
 	}
 
-	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
+	printk(KERN_INFO "ACPI: %s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 043b208..bd48c84 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -42,7 +42,6 @@ MODULE_LICENSE("GPL");
 
 #define ACPI_WMI_CLASS "wmi"
 
-#undef PREFIX
 #define PREFIX "ACPI: WMI: "
 
 static DEFINE_MUTEX(wmi_data_lock);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c65e4ce..f485107 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -30,8 +30,6 @@
 
 #include <acpi/acpi.h>
 
-#define PREFIX			"ACPI: "
-
 /* TBD: Make dynamic */
 #define ACPI_MAX_HANDLES	10
 struct acpi_handle_list {
-- 
1.6.0.6


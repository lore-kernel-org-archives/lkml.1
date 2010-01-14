Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052Ab0ANWd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0ANWd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346Ab0ANWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:33:35 -0500
Received: from kroah.org ([198.145.64.141]:60624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab0ANW2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Yong Wang <yong.y.wang@linux.intel.com>,
       Yong Wang <yong.y.wang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/52] hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510 CPUs
Date: Thu, 14 Jan 2010 14:27:14 -0800
Message-Id: <1263508051-7868-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-34-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Wang <yong.y.wang@linux.intel.com>

commit 1fe63ab47a617ee95f562eaa7ddbbc59981ff8c6 upstream.

The max junction temperature of Atom N450/D410/D510 CPUs is 100 degrees
Celsius. Since these CPUs are always coupled with Intel NM10 chipset in
one package, the best way to verify whether an Atom CPU is N450/D410/D510
is to check the host bridge device.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/Kconfig    |    2 +-
 drivers/hwmon/coretemp.c |   16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 700e93a..c1f7ea0 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -374,7 +374,7 @@ config SENSORS_GL520SM
 
 config SENSORS_CORETEMP
 	tristate "Intel Core/Core2/Atom temperature sensor"
-	depends on X86 && EXPERIMENTAL
+	depends on X86 && PCI && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Most of the family 6 CPUs
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index caef39c..2d7bcee 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/cpu.h>
+#include <linux/pci.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 
@@ -161,6 +162,7 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 	int usemsr_ee = 1;
 	int err;
 	u32 eax, edx;
+	struct pci_dev *host_bridge;
 
 	/* Early chips have no MSR for TjMax */
 
@@ -168,11 +170,21 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 		usemsr_ee = 0;
 	}
 
-	/* Atoms seems to have TjMax at 90C */
+	/* Atom CPUs */
 
 	if (c->x86_model == 0x1c) {
 		usemsr_ee = 0;
-		tjmax = 90000;
+
+		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+
+		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL
+		    && (host_bridge->device == 0xa000	/* NM10 based nettop */
+		    || host_bridge->device == 0xa010))	/* NM10 based netbook */
+			tjmax = 100000;
+		else
+			tjmax = 90000;
+
+		pci_dev_put(host_bridge);
 	}
 
 	if ((c->x86_model > 0xe) && (usemsr_ee)) {
-- 
1.6.6


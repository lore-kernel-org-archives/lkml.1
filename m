Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZFDQoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZFDQoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZFDQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:44:44 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38889 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZFDQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:44:43 -0400
Message-ID: <4A27FAB1.2000602@oracle.com>
Date: Thu, 04 Jun 2009 09:47:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: [PATCH -next] eeepc: fix pci & hotplug selects
References: <20090604175657.1565ecba.sfr@canb.auug.org.au>
In-Reply-To: <20090604175657.1565ecba.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A27F9F0.02B3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit another manifestation of this problem today.  Patch below.
Only the patch description (error log) has changed.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP selects HOTPLUG_PCI.  This causes failures (build error below)
when CONFIG_HOTPLUG is not enabled, so additionally select HOTPLUG since
kconfig 'select' doesn't follow its dependency chain.
Also, only select HOTPLUG_PCI if PCI is already enabled.

drivers/pci/hotplug/fakephp.c:55: error: implicit declaration of function 'pci_rescan_bus'
ERROR: "pci_scan_slot" [drivers/pci/hotplug/pciehp.ko] undefined!
ERROR: "pci_scan_bridge" [drivers/pci/hotplug/pciehp.ko] undefined!
ERROR: "pci_scan_slot" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
ERROR: "pci_add_new_bus" [drivers/pci/hotplug/pci_hotplug.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090604.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090604/drivers/platform/x86/Kconfig
@@ -340,7 +340,8 @@ config EEEPC_LAPTOP
 	depends on RFKILL || RFKILL = n
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
-	select HOTPLUG_PCI
+	select HOTPLUG
+	select HOTPLUG_PCI if PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZA0AiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZA0AiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZA0Ahu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:37:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43960 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbZA0Aht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:37:49 -0500
Date: Tue, 27 Jan 2009 00:37:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pcie hotplug: Change link order of pciehp
Message-ID: <20090127003743.GA27711@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware exposes PCIE slots in such a way that they can be claimed by
either the acpiphp or pciehp driver. pciehp is the preferred driver if the
firmware allows the OS to claim control via the _OSC method so should be
loaded first - if it fails to bind (either due to a missing _OSC method or
the firmware refusing to hand off control) then we can fall back to acpiphp or
a vendor-specific driver.

This patch simply changes the link order to ensure that pciehp will be
initialised before acpiphp if both are statically built into the kernel.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

--- 

diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index e31fb91..a024b44 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -5,11 +5,11 @@
 obj-$(CONFIG_HOTPLUG_PCI)		+= pci_hotplug.o
 obj-$(CONFIG_HOTPLUG_PCI_COMPAQ)	+= cpqphp.o
 obj-$(CONFIG_HOTPLUG_PCI_IBM)		+= ibmphp.o
+obj-$(CONFIG_HOTPLUG_PCI_PCIE)		+= pciehp.o
 obj-$(CONFIG_HOTPLUG_PCI_ACPI)		+= acpiphp.o
 obj-$(CONFIG_HOTPLUG_PCI_ACPI_IBM)	+= acpiphp_ibm.o
 obj-$(CONFIG_HOTPLUG_PCI_CPCI_ZT5550)	+= cpcihp_zt5550.o
 obj-$(CONFIG_HOTPLUG_PCI_CPCI_GENERIC)	+= cpcihp_generic.o
-obj-$(CONFIG_HOTPLUG_PCI_PCIE)		+= pciehp.o
 obj-$(CONFIG_HOTPLUG_PCI_SHPC)		+= shpchp.o
 obj-$(CONFIG_HOTPLUG_PCI_RPA)		+= rpaphp.o
 obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o

-- 
Matthew Garrett | mjg59@srcf.ucam.org

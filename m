Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbXICIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbXICIVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXICIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:20:23 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:14702 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbXICIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:20:19 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <20070903081736.805623000@amd.com>
References: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:41 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 5/5] x86: Set PCI config space size to extended for AMD
 Barcelona
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0699 (UTC)
 FILETIME=[03A7CE30:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C3B0X86399672-12-01
Content-Disposition: inline;
 filename=fam10h-pci-ext-cfg-dev-fixup.diff
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the config space size for AMD Barcelona PCI devices to
4096.

Signed-off-by: Robert Richter <robert.richter@amd.com>

---
 arch/i386/pci/fixup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/arch/i386/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/i386/pci/fixup.c
+++ linux-2.6/arch/i386/pci/fixup.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include "pci.h"
 
+#define PCI_CFG_SPACE_EXP_SIZE	4096
 
 static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 {
@@ -444,3 +445,16 @@ static void __devinit pci_siemens_interr
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Extend size of PCI configuration space for AMD CPUs
+ */
+static void __devinit pci_ext_cfg_space_access(struct pci_dev *dev)
+{
+	dev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_HT,   pci_ext_cfg_space_access);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_MAP,  pci_ext_cfg_space_access);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_DRAM, pci_ext_cfg_space_access);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_MISC, pci_ext_cfg_space_access);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_LINK, pci_ext_cfg_space_access);

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




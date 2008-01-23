Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYAWASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYAWASx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYAWASU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:18:20 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22203 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYAWASS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:18:18 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2/4] PCI ACPI: AER driver should only register PCIe devices
	with _OSC.
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, gregkh@suse.de,
       matthew@wil.cx, tom.l.nguyen@intel.com, linux-acpi@vger.kernel.org,
       Andrew Patterson <andrew.patterson@hp.com>
Date: Tue, 22 Jan 2008 17:18:17 -0700
Message-ID: <20080123001817.28190.42322.stgit@bluto.andrew>
In-Reply-To: <20080123001807.28190.32648.stgit@bluto.andrew>
References: <20080123001807.28190.32648.stgit@bluto.andrew>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Patterson <andrew.patterson@hp.com>

AER is only used with PCIe devices so we should only check PCIe devices for
_OSC support.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 1a1eb45..f685bf5 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -50,7 +50,7 @@ int aer_osc_setup(struct pcie_device *pciedev)
 	}
 
 	if (handle) {
-		pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
+		pcie_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
 		status = pci_osc_control_set(handle,
 					OSC_PCI_EXPRESS_AER_CONTROL |
 					OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);


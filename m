Return-Path: <linux-kernel-owner+w=401wt.eu-S936232AbYBCGRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232AbYBCGRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbYBCGRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:17:40 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36042 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYBCGRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:17:39 -0500
Date: Sat, 02 Feb 2008 22:24:47 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] pcie AER: don't check _OSC when acpi is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>, greg@kroah.com
Message-id: <200802022224.47400.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] pcie AER: don't check _OSC when acpi is disabled

when acpi=off or pci=noacpi, get warning

AER service couldn't init device 0000:00:0a.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0f.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0b.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0f.0:pcie01 - no _OSC support

so don't check _OSC in aer_osc_setup

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8c199ae..7e53fa5 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -33,6 +33,9 @@ int aer_osc_setup(struct pcie_device *pciedev)
 	struct pci_dev *pdev = pciedev->port;
 	acpi_handle handle = 0;
 
+	if (acpi_pci_disabled)
+		return -1;
+
 	/* Find root host bridge */
 	while (pdev->bus && pdev->bus->self)
 		pdev = pdev->bus->self;

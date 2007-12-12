Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXLLELA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXLLELA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXLLEKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:10:40 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48371 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXLLEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:10:38 -0500
Date: Tue, 11 Dec 2007 20:13:48 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] pcie AER: don't check _OSC when acpi is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200712112013.48346.yinghai.lu@sun.com>
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

when acpi=off and pci=nomsi, don't check _OSC in aer_osc_setup

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 1a1eb45..dd38777 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -34,6 +34,9 @@ int aer_osc_setup(struct pcie_device *pciedev)
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	struct pci_bus *parent;
 
+	if (acpi_pci_disabled)
+		return -1;
+
 	while (!handle) {
 		if (!pdev || !pdev->bus->parent)
 			break;

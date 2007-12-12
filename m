Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXLLEKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXLLEKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXLLEKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:10:38 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48372 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbXLLEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:10:38 -0500
Date: Tue, 11 Dec 2007 20:14:40 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] pci: don't load acpi_php when acpi is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200712112014.40923.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] pci: don't load acpi_php when acpi is disabled

when acpi=off and pci=nomsi, don't load acpiphp

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index c8c2638..84d66ba 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -392,6 +392,9 @@ static int __init acpiphp_init(void)
 {
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
+	if (acpi_pci_disabled)
+		return 0;
+
 	acpiphp_debug = debug;
 
 	/* read all the ACPI info from the system */
@@ -401,6 +404,9 @@ static int __init acpiphp_init(void)
 
 static void __exit acpiphp_exit(void)
 {
+	if (acpi_pci_disabled)
+		return 0;
+
 	/* deallocate internal data structures etc. */
 	acpiphp_glue_exit();
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1161527AbXBOWoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161527AbXBOWoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161593AbXBOWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:44:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:44164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161527AbXBOWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:44:09 -0500
Content-Disposition: inline
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <ak@suse.de>, linux-acpi@vger.kernel.org
Subject: [PATCH] add CONFIG_PNP=y to x86_64 defconfig
Date: Thu, 15 Feb 2007 17:42:14 -0500
User-Agent: KMail/1.9.5
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <abelay@novell.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702151742.15188.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI motherboard driver was removed from 2.6.20-git, and it handled
reserving resources for the CONFIG_ACPI=y CONFIG_PNP=n case.
Now that it is gone, CONFIG_PNP=y should be used for CONFIG_ACPI=y kernels,
and that brings CONFIG_PNPACPI=y.

Signed-off-by: Len Brown <len.brown@intel.com>
---
i386 defconfig already has this.
x86_64 Fedora Core 6 already has this.
x86_64 OpenSuse 10.2 does not yet have this.

Maybe we should select CONFIG_PNP from CONFIG_ACPI?

diff --git a/arch/x86_64/defconfig b/arch/x86_64/defconfig
index 293a4a4..9f2e1c4 100644
--- a/arch/x86_64/defconfig
+++ b/arch/x86_64/defconfig
@@ -421,7 +421,13 @@ CONFIG_FW_LOADER=y
 #
 # Plug and Play support
 #
-# CONFIG_PNP is not set
+CONFIG_PNP=y
+# CONFIG_PNP_DEBUG is not set
+
+#
+# Protocols
+#
+CONFIG_PNPACPI=y
 
 #
 # Block devices
@@ -477,6 +483,7 @@ CONFIG_BLK_DEV_IDEACPI=y
 #
 CONFIG_IDE_GENERIC=y
 # CONFIG_BLK_DEV_CMD640 is not set
+# CONFIG_BLK_DEV_IDEPNP is not set
 CONFIG_BLK_DEV_IDEPCI=y
 # CONFIG_IDEPCI_SHARE_IRQ is not set
 # CONFIG_BLK_DEV_OFFBOARD is not set
@@ -920,6 +927,7 @@ CONFIG_HW_CONSOLE=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_PCI=y
+CONFIG_SERIAL_8250_PNP=y
 CONFIG_SERIAL_8250_NR_UARTS=4
 CONFIG_SERIAL_8250_RUNTIME_UARTS=4
 # CONFIG_SERIAL_8250_EXTENDED is not set

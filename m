Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbXFLIzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbXFLIzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXFLIzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:55:25 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:54589 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbXFLIzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:55:23 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Tue, 12 Jun 2007 17:02:16 +0800
Message-Id: <1181638939310-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11816389393593-git-send-email-wei.zhang@freescale.com>
References: <11816389393593-git-send-email-wei.zhang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 Documentation/powerpc/booting-without-of.txt |   41 ++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index b49ce16..359c899 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1729,6 +1729,47 @@ platforms are moved over to use the flattened-device-tree model.
 
    More devices will be defined as this spec matures.
 
+   k) RapidIO
+
+   Required properties:
+
+    - device_type : Should be "rapidio"
+    - compatible : Should be "fsl,rapidio-v0.0" or "fsl,rapidio-v1.0"
+      and so on. The version number is got from IP Block Revision
+      Register of RapidIO controller.
+    - #address-cells : Address representation for "rapidio" devices.
+      This field represents the number of cells needed to represent
+      the RapidIO address of the registers.  For supporting more than
+      36-bits RapidIO address, this field should be <2>.
+      See 1) above for more details on defining #address-cells.
+    - reg : Offset and length of the register set for the device
+    - ranges : Should be defined as specified in 1) to describe the
+      translation of addresses for memory mapped RapidIO memory
+      space.
+    - interrupt-parent : the phandle for the interrupt controller that
+      services interrupts for this device.
+    - interrupts : <a b> where a is the interrupt number and b is a
+      field that represents an encoding of the sense and level
+      information for the interrupt.  This should be encoded based on
+      the information in section 2) depending on the type of interrupt
+      controller you have. For this sector, interrupts order should be
+      <err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
+      msg2_tx_irq msg2_rx_irq ... msgN_tx_irq msgN_rx_irq>.
+
+  Example:
+
+	srio@c0000{
+		device_type = "rapidio";
+		compatible = "fsl,rapidio-v1.0";
+		#address-cells = <2>;
+		reg = <c0000 20000>;
+		ranges = <0 0 c0000000 20000000>;
+		interrupt-parent = <&mpic>;
+		/* err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
+						      msg2_tx_irq msg2_rx_irq */
+		interrupts = <30 2 31 2 32 2 35 2 36 2 37 2 38 2>;
+	};
+
 VII - Specifying interrupt information for devices
 ===================================================
 
-- 
1.5.1


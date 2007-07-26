Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbXGZIfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbXGZIfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbXGZIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:34:47 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38847 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbXGZIep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:34:45 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: galak@kernel.crashing.org, mporter@kernel.crashing.org, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 1/5 v3] Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.
Date: Thu, 26 Jul 2007 16:42:48 +0800
Message-Id: <11854393733580-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11854393721520-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 26 Jul 2007 08:34:40.0031 (UTC) FILETIME=[CEB74AF0:01C7CF5F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 Documentation/powerpc/booting-without-of.txt |   37 ++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 76733a3..d89b805 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1824,6 +1824,43 @@ platforms are moved over to use the flattened-device-tree model.
 		fsl,has-rstcr;
 	};
 
+   l) RapidIO
+
+   RapidIO is a definition of a system interconnect. This node add
+   the support for RapidIO processor in kernel. The node name is
+   suggested to be 'rapidio'.
+
+   Required properties:
+
+    - compatible : Using "fsl,rapidio-delta" for Freescale PowerPC
+      RapidIO controller.
+    - #address-cells : Address representation for "rapidio" devices.
+      This field represents the number of cells needed to represent
+      the RapidIO address of the registers.
+      See 1) above for more details on defining #address-cells.
+    - reg : Offset and length of the register set for the device
+    - ranges : Should be defined as specified in 1) to describe the
+      translation of addresses for memory mapped RapidIO memory
+      space.
+    - interrupts : binding interrupts for this device node,
+      please follow below orders:
+      <err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
+      msg2_tx_irq msg2_rx_irq ... msgN_tx_irq msgN_rx_irq>.
+
+  Example:
+
+	rapidio@c0000 {
+		compatible = "fsl,rapidio-delta";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		reg = <c0000 20000>;
+		ranges = <0 0 c0000000 20000000>;
+		interrupt-parent = <&mpic>;
+		/* err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
+						      msg2_tx_irq msg2_rx_irq */
+		interrupts = <30 2 31 2 32 2 35 2 36 2 37 2 38 2>;
+	};
+
    More devices will be defined as this spec matures.
 
 VII - Specifying interrupt information for devices
-- 
1.5.1


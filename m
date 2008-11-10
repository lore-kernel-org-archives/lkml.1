Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKJVMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKJVMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYKJVMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:12:35 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:62718 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYKJVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:12:34 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linuxppc-dev@ozlabs.org
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       Trent Piepho <tpiepho@freescale.com>
Subject: [PATCH] powerpc: Repair device bindings documentation
Date: Mon, 10 Nov 2008 13:09:21 -0800
Message-Id: <1226351361-27115-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0fc2eaaf4c56a95f5ed29b6bfb609e19714fc16 "powerpc/fsl: Refactor
device bindings" split out a number of device bindings from
booting-without-of.txt into separate files.  Having them all in one file
was a frequent source of merge conflicts.

However, in the next merge, 49997d75152b3d23c53b0fa730599f2f74c92c65, there
was another conflict.  Some of the bindings removed from
booting-without-of.txt were mistakenly added back in and the copies in
dts-bindings were kept as well.

This patch re-removes "Freescale Display Interface" and "Freescale on board
FPGA" and fixes the table of contents.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
---

Maybe this should go in 2.6.28, since it fixes a doc bug and before
anyone modifies the version of the docs that should have been deleted.

 Documentation/powerpc/booting-without-of.txt |   65 ++++----------------------
 1 files changed, 10 insertions(+), 55 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 02ea9a9..0ab0230 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -41,25 +41,14 @@ Table of Contents
   VI - System-on-a-chip devices and nodes
     1) Defining child nodes of an SOC
     2) Representing devices without a current OF specification
-      a) MDIO IO device
-      b) Gianfar-compatible ethernet nodes
-      c) PHY nodes
-      d) Interrupt controllers
-      e) I2C
-      f) Freescale SOC USB controllers
-      g) Freescale SOC SEC Security Engines
-      h) Board Control and Status (BCSR)
-      i) Freescale QUICC Engine module (QE)
-      j) CFI or JEDEC memory-mapped NOR flash
-      k) Global Utilities Block
-      l) Freescale Communications Processor Module
-      m) Chipselect/Local Bus
-      n) 4xx/Axon EMAC ethernet nodes
-      o) Xilinx IP cores
-      p) Freescale Synchronous Serial Interface
-	  q) USB EHCI controllers
-      r) MDIO on GPIOs
-      s) SPI busses
+      a) PHY nodes
+      b) Interrupt controllers
+      c) CFI or JEDEC memory-mapped NOR flash
+      d) 4xx/Axon EMAC ethernet nodes
+      e) Xilinx IP cores
+      f) USB EHCI controllers
+      g) MDIO on GPIOs
+      h) SPI busses
 
   VII - Marvell Discovery mv64[345]6x System Controller chips
     1) The /system-controller node
@@ -1830,41 +1819,7 @@ platforms are moved over to use the flattened-device-tree model.
 		   big-endian;
 	   };
 
-    r) Freescale Display Interface Unit
-
-    The Freescale DIU is a LCD controller, with proper hardware, it can also
-    drive DVI monitors.
-
-    Required properties:
-    - compatible : should be "fsl-diu".
-    - reg : should contain at least address and length of the DIU register
-      set.
-    - Interrupts : one DIU interrupt should be describe here.
-
-    Example (MPC8610HPCD)
-	display@2c000 {
-		compatible = "fsl,diu";
-		reg = <0x2c000 100>;
-		interrupts = <72 2>;
-		interrupt-parent = <&mpic>;
-	};
-
-    s) Freescale on board FPGA
-
-    This is the memory-mapped registers for on board FPGA.
-
-    Required properities:
-    - compatible : should be "fsl,fpga-pixis".
-    - reg : should contain the address and the lenght of the FPPGA register
-      set.
-
-    Example (MPC8610HPCD)
-	board-control@e8000000 {
-		compatible = "fsl,fpga-pixis";
-		reg = <0xe8000000 32>;
-	};
-
-   r) MDIO on GPIOs
+   g) MDIO on GPIOs
 
    Currently defined compatibles:
    - virtual,gpio-mdio
@@ -1884,7 +1839,7 @@ platforms are moved over to use the flattened-device-tree model.
 			 &qe_pio_c 6>;
 	};
 
-    s) SPI (Serial Peripheral Interface) busses
+    h) SPI (Serial Peripheral Interface) busses
 
     SPI busses can be described with a node for the SPI master device
     and a set of child nodes for each SPI slave on the bus.  For this
-- 
1.5.4.1


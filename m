Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYGCBEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYGCBEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 21:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYGCBDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 21:03:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:60541 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYGCBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:03:12 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI busses
	and devices
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com, david-b@pacbell.net
Date: Wed, 02 Jul 2008 19:03:08 -0600
Message-ID: <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
In-Reply-To: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add documentation about how to describe SPI busses in the device tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 Documentation/powerpc/booting-without-of.txt |   60 ++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 1d2a772..7d3564f 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -58,6 +58,7 @@ Table of Contents
       o) Xilinx IP cores
       p) Freescale Synchronous Serial Interface
 	  q) USB EHCI controllers
+      t) SPI busses
 
   VII - Marvell Discovery mv64[345]6x System Controller chips
     1) The /system-controller node
@@ -2870,6 +2871,65 @@ platforms are moved over to use the flattened-device-tree model.
 		reg = <0xe8000000 32>;
 	};
 
+    t) SPI (Serial Peripheral Interface) busses
+
+    SPI busses can be described with a node for the SPI master device
+    and a set of child nodes for each SPI slave on the bus.  For this
+    discussion, it is assumed that the system's SPI controller is in
+    SPI master mode.  This binding does not describe SPI controllers
+    in slave mode.
+
+    The SPI master node requires the following properties:
+    - #address-cells  - number of cells required to define a chip select
+			address on the SPI bus.
+    - #size-cells     - should be zero.
+    - compatible      - name of SPI bus controller following generic names
+			recommended practice.
+    No other properties are required in the SPI bus node.  It is assumed
+    that a driver for an SPI bus device will understand that it is an SPI bus.
+    However, the binding does not attempt to define the specific method for
+    assigning chip select numbers.  Since SPI chip select configuration is
+    flexible and non-standardized, it is left out of this binding with the
+    assumption that board specific platform code will be used to manage
+    chip selects.  Individual drivers can define additional properties to
+    support describing the chip select layout.
+
+    SPI slave nodes must be children of the SPI master node and can
+    contain the following properties.
+    - reg             - (required) chip select address of device.
+    - compatible      - (required) name of SPI device following generic names
+			recommended practice
+    - max-speed       - (required) Maximum SPI clocking speed of device in Hz
+    - spi,cpol        - (optional) Device requires inverse clock polarity
+    - spi,cpha        - (optional) Device requires shifted clock phase
+    - linux,modalias  - (optional, Linux specific) Force binding of SPI device
+			to a particular spi_device driver.  Useful for changing
+			driver binding between spidev and a kernel SPI driver.
+
+    SPI example for an MPC5200 SPI bus:
+		spi@f00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
+			reg = <0xf00 0x20>;
+			interrupts = <2 13 0 2 14 0>;
+			interrupt-parent = <&mpc5200_pic>;
+
+			ethernet-switch@0 {
+				compatible = "micrel,ks8995m";
+				linux,modalias = "ks8995";
+				max-speed = <1000000>;
+				reg = <0>;
+			};
+
+			codec@1 {
+				compatible = "ti,tlv320aic26";
+				max-speed = <100000>;
+				reg = <1>;
+			};
+		};
+
+
 VII - Marvell Discovery mv64[345]6x System Controller chips
 ===========================================================
 


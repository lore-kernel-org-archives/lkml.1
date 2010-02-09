Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0BIVQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:16:36 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:49838 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0BIVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:16:33 -0500
X-Auth-Info: fz3/TN6HX+3hUShOFvf06Yra7SGG0Hbwt6wZg5x2lLY=
From: Anatolij Gustschin <agust@denx.de>
To: linuxppc-dev@ozlabs.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jcrigby@gmail.com, dzu@denx.de, wd@denx.de,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH v2 2/3] powerpc: doc/dts-bindings: document mpc5121 psc uart  dts-bindings
Date: Tue,  9 Feb 2010 22:13:51 +0100
Message-Id: <1265750032-2803-3-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265750032-2803-1-git-send-email-agust@denx.de>
References: <1265750032-2803-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for MPC5121 PSC UART in the mpc52xx_uart driver
added new DTS properties for FSL MPC5121 PSC FIFO Controller.
Provide documentation of the new properties and some examples.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
No changes since v1.

 .../powerpc/dts-bindings/fsl/mpc5121-psc.txt       |   70 ++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt

diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt b/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
new file mode 100644
index 0000000..8832e87
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
@@ -0,0 +1,70 @@
+MPC5121 PSC Device Tree Bindings
+
+PSC in UART mode
+----------------
+
+For PSC in UART mode the needed PSC serial devices
+are specified by fsl,mpc5121-psc-uart nodes in the
+fsl,mpc5121-immr SoC node. Additionally the PSC FIFO
+Controller node fsl,mpc5121-psc-fifo is requered there:
+
+fsl,mpc5121-psc-uart nodes
+--------------------------
+
+Required properties :
+ - compatible : Should contain "fsl,mpc5121-psc-uart" and "fsl,mpc5121-psc"
+ - cell-index : Index of the PSC in hardware
+ - reg : Offset and length of the register set for the PSC device
+ - interrupts : <a b> where a is the interrupt number of the
+   PSC FIFO Controller and b is a field that represents an
+   encoding of the sense and level information for the interrupt.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+
+Recommended properties :
+ - fsl,rx-fifo-size : the size of the RX fifo slice (a multiple of 4)
+ - fsl,tx-fifo-size : the size of the TX fifo slice (a multiple of 4)
+
+
+fsl,mpc5121-psc-fifo node
+-------------------------
+
+Required properties :
+ - compatible : Should be "fsl,mpc5121-psc-fifo"
+ - reg : Offset and length of the register set for the PSC
+         FIFO Controller
+ - interrupts : <a b> where a is the interrupt number of the
+   PSC FIFO Controller and b is a field that represents an
+   encoding of the sense and level information for the interrupt.
+ - interrupt-parent : the phandle for the interrupt controller that
+   services interrupts for this device.
+
+
+Example for a board using PSC0 and PSC1 devices in serial mode:
+
+serial@11000 {
+	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
+	cell-index = <0>;
+	reg = <0x11000 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+	fsl,rx-fifo-size = <16>;
+	fsl,tx-fifo-size = <16>;
+};
+
+serial@11100 {
+	compatible = "fsl,mpc5121-psc-uart", "fsl,mpc5121-psc";
+	cell-index = <1>;
+	reg = <0x11100 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+	fsl,rx-fifo-size = <16>;
+	fsl,tx-fifo-size = <16>;
+};
+
+pscfifo@11f00 {
+	compatible = "fsl,mpc5121-psc-fifo";
+	reg = <0x11f00 0x100>;
+	interrupts = <40 0x8>;
+	interrupt-parent = < &ipic >;
+};
-- 
1.6.3.3


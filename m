Return-Path: <linux-kernel-owner+w=401wt.eu-S934895AbXEHJv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895AbXEHJv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbXEHJvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:51:24 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:34820 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934877AbXEHJvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:51:21 -0400
To: linux-pcmcia@lists.infradead.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Date: Tue, 08 May 2007 13:50:49 +0400
Message-ID: <20070508095049.20018.56908.stgit@localhost.localdomain>
In-Reply-To: <20070508095001.20018.85403.stgit@localhost.localdomain>
References: <20070508095001.20018.85403.stgit@localhost.localdomain>
User-Agent: StGIT/0.11
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Removed explicit linux,phandle usage. Using references and labels now in
PQ and PQ2 boards currently supported in arch/powerpc.
Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

---

 arch/powerpc/boot/dts/mpc8272ads.dts |   42 +++++++++++---------------------
 arch/powerpc/boot/dts/mpc866ads.dts  |   31 ++++++++---------------
 arch/powerpc/boot/dts/mpc885ads.dts  |   45 +++++++++++++---------------------
 3 files changed, 43 insertions(+), 75 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
index 423eedc..1934b80 100644
--- a/arch/powerpc/boot/dts/mpc8272ads.dts
+++ b/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -14,12 +14,10 @@
        compatible = "MPC8260ADS";
        #address-cells = <1>;
        #size-cells = <1>;
-       linux,phandle = <100>;
 
        cpus {
                #address-cells = <1>;
                #size-cells = <0>;
-               linux,phandle = <200>;
 
                PowerPC,8272@0 {
                        device_type = "cpu";
@@ -32,12 +30,10 @@
                        bus-frequency = <0>;
                        clock-frequency = <0>;
                        32-bit;
-                       linux,phandle = <201>;
                };
        };
 
-       interrupt-controller@f8200000 {
-               linux,phandle = <f8200000>;
+		pci_pic: interrupt-controller@f8200000 {
                #address-cells = <0>;
                #interrupt-cells = <2>;
                interrupt-controller;
@@ -47,15 +43,13 @@
        };
        memory {
                device_type = "memory";
-               linux,phandle = <300>;
                reg = <00000000 4000000 f4500000 00000020>;
        };
 
        chosen {
                name = "chosen";
                linux,platform = <0>;
-               interrupt-controller = <10c00>;
-               linux,phandle = <400>;
+		interrupt-controller = <&Cpm_pic>;
        };
 
        soc8272@f0000000 {
@@ -70,20 +64,17 @@
                        device_type = "mdio";
                        compatible = "fs_enet";
                        reg = <0 0>;
-                       linux,phandle = <24520>;
                        #address-cells = <1>;
                        #size-cells = <0>;
-                       ethernet-phy@0 {
-                               linux,phandle = <2452000>;
-                               interrupt-parent = <10c00>;
+			phy0:ethernet-phy@0 {
+				interrupt-parent = <&Cpm_pic>;
                                interrupts = <17 4>;
                                reg = <0>;
                                bitbang = [ 12 12 13 02 02 01 ];
                                device_type = "ethernet-phy";
                        };
-                       ethernet-phy@1 {
-                               linux,phandle = <2452001>;
-                               interrupt-parent = <10c00>;
+			phy1:ethernet-phy@1 {
+				interrupt-parent = <&Cpm_pic>;
                                interrupts = <17 4>;
                                bitbang = [ 12 12 13 02 02 01 ];
                                reg = <3>;
@@ -101,8 +92,8 @@
                        reg = <11300 20 8400 100 11380 30>;
                        mac-address = [ 00 11 2F 99 43 54 ];
                        interrupts = <20 2>;
-                       interrupt-parent = <10c00>;
-                       phy-handle = <2452000>;
+			interrupt-parent = <&Cpm_pic>;
+			phy-handle = <&Phy0>;
                        rx-clock = <13>;
                        tx-clock = <12>;
                };
@@ -115,14 +106,13 @@
                        reg = <11320 20 8500 100 113b0 30>;
                        mac-address = [ 00 11 2F 99 44 54 ];
                        interrupts = <21 2>;
-                       interrupt-parent = <10c00>;
-                       phy-handle = <2452001>;
+			interrupt-parent = <&Cpm_pic>;
+			phy-handle = <&Phy1>;
                        rx-clock = <17>;
                        tx-clock = <18>;
                };
 
                cpm@f0000000 {
-                       linux,phandle = <f0000000>;
                        #address-cells = <1>;
                        #size-cells = <1>;
                        #interrupt-cells = <2>;
@@ -142,7 +132,7 @@
                                reg = <11a00 20 8000 100>;
                                current-speed = <1c200>;
                                interrupts = <28 2>;
-                               interrupt-parent = <10c00>;
+				interrupt-parent = <&Cpm_pic>;
                                clock-setup = <0 00ffffff>;
                                rx-clock = <1>;
                                tx-clock = <1>;
@@ -156,15 +146,14 @@
                                reg = <11a60 20 8300 100>;
                                current-speed = <1c200>;
                                interrupts = <2b 2>;
-                               interrupt-parent = <10c00>;
+				interrupt-parent = <&Cpm_pic>;
                                clock-setup = <1b ffffff00>;
                                rx-clock = <4>;
                                tx-clock = <4>;
                        };
 
                };
-               interrupt-controller@10c00 {
-                       linux,phandle = <10c00>;
+			cpm_pic:interrupt-controller@10c00 {
                        #address-cells = <0>;
                        #interrupt-cells = <2>;
                        interrupt-controller;
@@ -174,7 +163,6 @@
 		       compatible = "CPM2";
                };
                pci@0500 {
-                       linux,phandle = <0500>;
                        #interrupt-cells = <1>;
                        #size-cells = <2>;
                        #address-cells = <3>;
@@ -202,7 +190,7 @@
                                         c000 0 0 2 f8200000 43 8
                                         c000 0 0 3 f8200000 40 8
                                         c000 0 0 4 f8200000 41 8>;
-                       interrupt-parent = <10c00>;
+			interrupt-parent = <&Cpm_pic>;
                        interrupts = <14 8>;
                        bus-range = <0 0>;
                        ranges = <02000000 0 80000000 80000000 0 40000000
@@ -216,7 +204,7 @@
                        compatible = "talitos";
                        reg = <30000 10000>;
                        interrupts = <b 2>;
-                       interrupt-parent = <10c00>;
+			interrupt-parent = <&Cpm_pic>;
                        num-channels = <4>;
                        channel-fifo-len = <18>;
                        exec-units-mask = <0000007e>;
diff --git a/arch/powerpc/boot/dts/mpc866ads.dts b/arch/powerpc/boot/dts/mpc866ads.dts
index c0d06fd..e5e7726 100644
--- a/arch/powerpc/boot/dts/mpc866ads.dts
+++ b/arch/powerpc/boot/dts/mpc866ads.dts
@@ -15,12 +15,10 @@
 	compatible = "mpc8xx";
 	#address-cells = <1>;
 	#size-cells = <1>;
-	linux,phandle = <100>;
 
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		linux,phandle = <200>;
 
 		PowerPC,866@0 {
 			device_type = "cpu";
@@ -34,14 +32,12 @@
 			clock-frequency = <0>;
 			32-bit;
 			interrupts = <f 2>;	// decrementer interrupt
-			interrupt-parent = <ff000000>;
-			linux,phandle = <201>;
+			interrupt-parent = <&Mpc8xx_pic>;
 		};
 	};
 
 	memory {
 		device_type = "memory";
-		linux,phandle = <300>;
 		reg = <00000000 800000>;
 	};
 
@@ -57,11 +53,9 @@
 			device_type = "mdio";
 			compatible = "fs_enet";
 			reg = <e80 8>;
-			linux,phandle = <e80>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			ethernet-phy@f {
-				linux,phandle = <e800f>;
+			phy: ethernet-phy@f {
 				reg = <f>;
 				device_type = "ethernet-phy";
 			};
@@ -75,12 +69,11 @@
 			reg = <e00 188>;
 			mac-address = [ 00 00 0C 00 01 FD ];
 			interrupts = <3 1>;
-			interrupt-parent = <ff000000>;
-			phy-handle = <e800f>;
+			interrupt-parent = <&Mpc8xx_pic>;
+			phy-handle = <&Phy>;
 		};
 
-		pic@ff000000 {
-			linux,phandle = <ff000000>;
+		mpc8xx_pic: pic@ff000000 {
 			interrupt-controller;
 			#address-cells = <0>;
 			#interrupt-cells = <2>;
@@ -91,7 +84,6 @@
 		};
 
 		cpm@ff000000 {
-			linux,phandle = <ff000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			#interrupt-cells = <2>;
@@ -102,15 +94,14 @@
 			command-proc = <9c0>;
 			brg-frequency = <0>;
 			interrupts = <0 2>;	// cpm error interrupt
-			interrupt-parent = <930>;
+			interrupt-parent = <&Cpm_pic>;
 
-			pic@930 {
-				linux,phandle = <930>;
+			cpm_pic: pic@930 {
 				interrupt-controller;
 				#address-cells = <0>;
 				#interrupt-cells = <2>;
 				interrupts = <5 2 0 2>;
-				interrupt-parent = <ff000000>;
+				interrupt-parent = <&Mpc8xx_pic>;
 				reg = <930 20>;
 				built-in;
 				device_type = "cpm-pic";
@@ -128,7 +119,7 @@
 				tx-clock = <1>;
 				current-speed = <0>;
 				interrupts = <4 3>;
-				interrupt-parent = <930>;
+				interrupt-parent = <&Cpm_pic>;
 			};
 
 			smc@a90 {
@@ -142,7 +133,7 @@
 				tx-clock = <2>;
 				current-speed = <0>;
 				interrupts = <3 3>;
-				interrupt-parent = <930>;
+				interrupt-parent = <&Cpm_pic>;
 			};
 
 			scc@a00 {
@@ -153,7 +144,7 @@
 				reg = <a00 18 3c00 80>;
 				mac-address = [ 00 00 0C 00 03 FD ];
 				interrupts = <1e 3>;
-				interrupt-parent = <930>;
+				interrupt-parent = <&Cpm_pic>;
 			};
 		};
 	};
diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 0786ac1..2b2fec8 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -15,12 +15,10 @@
 	compatible = "mpc8xx";
 	#address-cells = <1>;
 	#size-cells = <1>;
-	linux,phandle = <100>;
 
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		linux,phandle = <200>;
 
 		PowerPC,885@0 {
 			device_type = "cpu";
@@ -34,14 +32,12 @@
 			clock-frequency = <0>;
 			32-bit;
 			interrupts = <f 2>;	// decrementer interrupt
-			interrupt-parent = <ff000000>;
-			linux,phandle = <201>;
+			interrupt-parent = <&Mpc8xx_pic>;
 		};
 	};
 
 	memory {
 		device_type = "memory";
-		linux,phandle = <300>;
 		reg = <00000000 800000>;
 	};
 
@@ -57,21 +53,17 @@
 			device_type = "mdio";
 			compatible = "fs_enet";
 			reg = <e80 8>;
-			linux,phandle = <e80>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			ethernet-phy@0 {
-				linux,phandle = <e8000>;
+			Phy0: ethernet-phy@0 {
 				reg = <0>;
 				device_type = "ethernet-phy";
 			};
-			ethernet-phy@1 {
-				linux,phandle = <e8001>;
+			Phy1: ethernet-phy@1 {
 				reg = <1>;
 				device_type = "ethernet-phy";
 			};
-			ethernet-phy@2 {
-				linux,phandle = <e8002>;
+			Phy2: ethernet-phy@2 {
 				reg = <2>;
 				device_type = "ethernet-phy";
 			};
@@ -85,8 +77,8 @@
 			reg = <e00 188>;
 			mac-address = [ 00 00 0C 00 01 FD ];
 			interrupts = <3 1>;
-			interrupt-parent = <ff000000>;
-			phy-handle = <e8000>;
+			interrupt-parent = <&Mpc8xx_pic>;
+			phy-handle = <&Phy1>;
 		};
 
 		fec@1e00 {
@@ -97,12 +89,11 @@
 			reg = <1e00 188>;
 			mac-address = [ 00 00 0C 00 02 FD ];
 			interrupts = <7 1>;
-			interrupt-parent = <ff000000>;
-			phy-handle = <e8001>;
+			interrupt-parent = <&Mpc8xx_pic>;
+			phy-handle = <&Phy2>;
 		};
 
-		pic@ff000000 {
-			linux,phandle = <ff000000>;
+		Mpc8xx_pic: pic@ff000000 {
 			interrupt-controller;
 			#address-cells = <0>;
 			#interrupt-cells = <2>;
@@ -120,12 +111,11 @@
 			device_type = "pcmcia";
 			reg = <80 80>;
 			clock-frequency = <2faf080>;
-			interrupt-parent = <&mpc8xx-pic>;
+			interrupt-parent = <&Mpc8xx_pic>;
 			interrupts = <d 1>;
 		};
 
 		cpm@ff000000 {
-			linux,phandle = <ff000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			#interrupt-cells = <2>;
@@ -136,15 +126,14 @@
 			command-proc = <9c0>;
 			brg-frequency = <0>;
 			interrupts = <0 2>;	// cpm error interrupt
-			interrupt-parent = <930>;
+			interrupt-parent = <&Cpm_pic>;
 
-			pic@930 {
-				linux,phandle = <930>;
+			Cpm_pic: pic@930 {
 				interrupt-controller;
 				#address-cells = <0>;
 				#interrupt-cells = <2>;
 				interrupts = <5 2 0 2>;
-				interrupt-parent = <ff000000>;
+				interrupt-parent = <&Mpc8xx_pic>;
 				reg = <930 20>;
 				built-in;
 				device_type = "cpm-pic";
@@ -162,7 +151,7 @@
 				tx-clock = <1>;
 				current-speed = <0>;
 				interrupts = <4 3>;
-				interrupt-parent = <930>;
+				interrupt-parent = <&Cpm_pic>;
 			};
 
 			smc@a90 {
@@ -176,7 +165,7 @@
 				tx-clock = <2>;
 				current-speed = <0>;
 				interrupts = <3 3>;
-				interrupt-parent = <930>;
+				interrupt-parent = <&Cpm_pic>;
 			};
 
 			scc@a40 {
@@ -187,8 +176,8 @@
 				reg = <a40 18 3e00 80>;
 				mac-address = [ 00 00 0C 00 03 FD ];
 				interrupts = <1c 3>;
-				interrupt-parent = <930>;
-				phy-handle = <e8002>;
+				interrupt-parent = <&Cpm_pic>;
+				phy-handle = <&Phy2>;
 			};
 		};
 	};

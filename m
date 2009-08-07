Return-Path: <linux-kernel-owner+w=401wt.eu-S933419AbZHGT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbZHGT6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbZHGT6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:58:11 -0400
Received: from ru.mvista.com ([213.79.90.228]:2257 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933270AbZHGT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:58:09 -0400
Date: Fri, 7 Aug 2009 23:58:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH 4/7] powerpc: Introduce and document sdhci,wp-inverted
 property for eSDHC
Message-ID: <20090807195810.GD2735@oksana.dev.rtsoft.ru>
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eSDHC block in MPC837x SOCs reports inverted write-protect state,
soon sdhci-of driver will look for sdhci,wp-inverted properties to
decide whether apply a specific quirk.

So, document the property and add it to device tree source files.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 Documentation/powerpc/dts-bindings/fsl/esdhc.txt |    2 ++
 arch/powerpc/boot/dts/mpc8377_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8377_rdb.dts            |    1 +
 arch/powerpc/boot/dts/mpc8377_wlan.dts           |    1 +
 arch/powerpc/boot/dts/mpc8378_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8378_rdb.dts            |    1 +
 arch/powerpc/boot/dts/mpc8379_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8379_rdb.dts            |    1 +
 8 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt b/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
index 3ed3797..8a00407 100644
--- a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
+++ b/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
@@ -10,6 +10,8 @@ Required properties:
   - interrupts : should contain eSDHC interrupt.
   - interrupt-parent : interrupt source phandle.
   - clock-frequency : specifies eSDHC base clock frequency.
+  - sdhci,wp-inverted : (optional) specifies that eSDHC controller
+    reports inverted write-protect state;
   - sdhci,1-bit-only : (optional) specifies that a controller can
     only handle 1-bit data transfers.
 
diff --git a/arch/powerpc/boot/dts/mpc8377_mds.dts b/arch/powerpc/boot/dts/mpc8377_mds.dts
index f32c281..855782c 100644
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -159,6 +159,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff --git a/arch/powerpc/boot/dts/mpc8377_rdb.dts b/arch/powerpc/boot/dts/mpc8377_rdb.dts
index 28e022a..9e2264b 100644
--- a/arch/powerpc/boot/dts/mpc8377_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8377_rdb.dts
@@ -173,6 +173,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
diff --git a/arch/powerpc/boot/dts/mpc8377_wlan.dts b/arch/powerpc/boot/dts/mpc8377_wlan.dts
index 3febc4e..9a60369 100644
--- a/arch/powerpc/boot/dts/mpc8377_wlan.dts
+++ b/arch/powerpc/boot/dts/mpc8377_wlan.dts
@@ -150,6 +150,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				clock-frequency = <133333333>;
 			};
 		};
diff --git a/arch/powerpc/boot/dts/mpc8378_mds.dts b/arch/powerpc/boot/dts/mpc8378_mds.dts
index f720ab9..f70cf60 100644
--- a/arch/powerpc/boot/dts/mpc8378_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8378_mds.dts
@@ -159,6 +159,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff --git a/arch/powerpc/boot/dts/mpc8378_rdb.dts b/arch/powerpc/boot/dts/mpc8378_rdb.dts
index a11ead8..4e6a1a4 100644
--- a/arch/powerpc/boot/dts/mpc8378_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8378_rdb.dts
@@ -173,6 +173,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
diff --git a/arch/powerpc/boot/dts/mpc8379_mds.dts b/arch/powerpc/boot/dts/mpc8379_mds.dts
index 4fa221f..645ec51 100644
--- a/arch/powerpc/boot/dts/mpc8379_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8379_mds.dts
@@ -157,6 +157,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff --git a/arch/powerpc/boot/dts/mpc8379_rdb.dts b/arch/powerpc/boot/dts/mpc8379_rdb.dts
index e35dfba..72336d5 100644
--- a/arch/powerpc/boot/dts/mpc8379_rdb.dts
+++ b/arch/powerpc/boot/dts/mpc8379_rdb.dts
@@ -171,6 +171,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
-- 
1.6.3.3


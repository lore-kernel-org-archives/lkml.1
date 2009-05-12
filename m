Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZELTGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZELTGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZELTGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:06:18 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56104 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZELTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:06:17 -0400
X-Auth-Info: k3T3G/Fq7O/YLaBabSNwGiDjPMJqKGI4/ZpxrfvbdvA=
From: Wolfgang Denk <wd@denx.de>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Wolfgang Denk <wd@denx.de>,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash size
Date: Tue, 12 May 2009 21:06:14 +0200
Message-Id: <1242155174-2513-1-git-send-email-wd@denx.de>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current device tree for the MPC8272ADS assumes a mapping of 32 MB
of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
the boards, mapped at 0xFF80.0000. When booting an uImage with such a
device tree, the kernel crashes because 0xFE00.0000 is not mapped.

Also introduce aliases for serial[01] and ethernet[01].

Signed-off-by: Wolfgang Denk <wd@denx.de>
Cc: Scott Wood <scottwood@freescale.com>
cc: Kumar Gala <galak@kernel.crashing.org>
---
I am not really sure what the typical flash size on MPC8272ADS boards
is. The board I used for testing is marked as "Prototype", so it may
not be the release configuration. On the other hand, the manual also
says 8 MB, Vitaly Borduk confirms 8 MB on his board, too, and Scott
Wood eventually tested only with cuImage which fixes up the localbus
mappings, thus eventually concealing the issue.

I'm posting this as reference in case the 8 MB should turn out to be
correct. -- wd

 arch/powerpc/boot/dts/mpc8272ads.dts |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
index 2a1929a..60f3327 100644
--- a/arch/powerpc/boot/dts/mpc8272ads.dts
+++ b/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -17,6 +17,13 @@
 	#address-cells = <1>;
 	#size-cells = <1>;
 
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+		serial0 = &scc1;
+		serial1 = &scc4;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -46,13 +53,13 @@
 		#size-cells = <1>;
 		reg = <0xf0010100 0x40>;
 
-		ranges = <0x0 0x0 0xfe000000 0x2000000
+		ranges = <0x0 0x0 0xff800000 0x00800000
 		          0x1 0x0 0xf4500000 0x8000
 		          0x3 0x0 0xf8200000 0x8000>;
 
 		flash@0,0 {
 			compatible = "jedec-flash";
-			reg = <0x0 0x0 0x2000000>;
+			reg = <0x0 0x0 0x00800000>;
 			bank-width = <4>;
 			device-width = <1>;
 		};
@@ -144,7 +151,7 @@
 				reg = <0x119f0 0x10 0x115f0 0x10>;
 			};
 
-			serial@11a00 {
+			scc1: serial@11a00 {
 				device_type = "serial";
 				compatible = "fsl,mpc8272-scc-uart",
 				             "fsl,cpm2-scc-uart";
@@ -155,7 +162,7 @@
 				fsl,cpm-command = <0x800000>;
 			};
 
-			serial@11a60 {
+			scc4: serial@11a60 {
 				device_type = "serial";
 				compatible = "fsl,mpc8272-scc-uart",
 				             "fsl,cpm2-scc-uart";
@@ -192,7 +199,7 @@
 				};
 			};
 
-			ethernet@11300 {
+			eth0: ethernet@11300 {
 				device_type = "network";
 				compatible = "fsl,mpc8272-fcc-enet",
 				             "fsl,cpm2-fcc-enet";
@@ -205,7 +212,7 @@
 				fsl,cpm-command = <0x12000300>;
 			};
 
-			ethernet@11320 {
+			eth1: ethernet@11320 {
 				device_type = "network";
 				compatible = "fsl,mpc8272-fcc-enet",
 				             "fsl,cpm2-fcc-enet";
-- 
1.6.0.6


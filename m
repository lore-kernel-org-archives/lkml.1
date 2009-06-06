Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZFFQPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZFFQPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFFQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:15:14 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55252 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZFFQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:to:from:subject;
        b=wjZSZNnnoi4568p8Jd39TbGFZR6z5gSZSnxugFlKmoAyxvFlQDXUp3nwmchWZzOGe7
         AVih+xN5wWs79gqJlNsjCbAvu/SSnxW15m1oOwtQc5PydKUgNnRbf9Q+mX7fw/29U5dQ
         oK2NLIthcOShBFKPmxkruk+V0J0lmhvRhxkKs=
Message-ID: <4a2a9611.06c8100a.49ae.ffff88e4@mx.google.com>
Date: Sat, 06 Jun 2009 09:15:13 -0700 (PDT)
To: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-kernel@vger.kernel.org
To: Leon Woestenberg <leon@sidebranch.com>
From: leon.woestenberg@gmail.com
Subject: [PATCH v2] Add MSI interrupts to DTS of MPC8315E-RDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe MSI interrupts are missing from the device tree source, and
thus were not enabled. This patch adds them.

v2 of the patch fixes inconsistent white space, reported by David Gibson.

Tested to work on MPC8315E-RDB with custom FPGA PCIe device.

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
Tested-by: Leon Woestenberg <leon@sidebranch.com>

Index: git/arch/powerpc/boot/dts/mpc8315erdb.dts
===================================================================
--- git.orig/arch/powerpc/boot/dts/mpc8315erdb.dts	2009-05-23 20:49:40.000000000 +0200
+++ git/arch/powerpc/boot/dts/mpc8315erdb.dts	2009-06-06 10:35:14.000000000 +0200
@@ -322,6 +322,21 @@
 			reg = <0x700 0x100>;
 			device_type = "ipic";
 		};
+
+		ipic-msi@7c0 {
+			compatible = "fsl,ipic-msi";
+			reg = <0x7c0 0x40>;
+			msi-available-ranges = <0 0x100>;
+			interrupts = <0x43 0x8
+				      0x4  0x8
+				      0x51 0x8
+				      0x52 0x8
+				      0x56 0x8
+				      0x57 0x8
+				      0x58 0x8
+				      0x59 0x8>;
+			interrupt-parent = < &ipic >;
+		};
 	};
 
 	pci0: pci@e0008500 {

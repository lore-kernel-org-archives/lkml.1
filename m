Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZFEOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZFEOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZFEOpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:45:41 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:36405 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZFEOpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:to:from:subject;
        b=YhsKgpJk0iB0Wf1CwE/S14OOBCAY50G++YTTNVSJKkI18sUTT88E9dZwqrPwHyiGcs
         o1jhyVSoKB45d42TYysgpkvAr+nYZjleKM5atS22dHrChdsZVwNkiGKUvlchIcGLbMbU
         ylvt4QHqlLhPJL3/u6aDOcsSYhoiMOQ//ZwZc=
Message-ID: <4a292f95.05a4100a.1a14.0a04@mx.google.com>
Date: Fri, 05 Jun 2009 07:45:41 -0700 (PDT)
To: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-kernel@vger.kernel.org
To: Leon Woestenberg <leon@sidebranch.com>
From: leon.woestenberg@gmail.com
Subject: [PATCH] Add MSI interrupts to DTS of MPC8315E-RDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe MSI interrupts are missing from the device tree source, and
thus were not enabled. This patch adds them.

Tested to work on MPC8315E-RDB with custom FPGA PCIe device.

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
Tested-by: Leon Woestenberg <leon@sidebranch.com>

diff --git a/arch/powerpc/boot/dts/mpc8315erdb.dts b/arch/powerpc/boot/dts/mpc8315erdb.dts
index 3f4c5fb..4f04667 100644
--- a/arch/powerpc/boot/dts/mpc8315erdb.dts
+++ b/arch/powerpc/boot/dts/mpc8315erdb.dts
@@ -322,6 +322,21 @@
 			reg = <0x700 0x100>;
 			device_type = "ipic";
 		};
+
+		ipic-msi@7c0 {
+			compatible = "fsl,ipic-msi";
+                        reg = <0x7c0 0x40>;
+                        msi-available-ranges = <0 0x100>;
+			interrupts = < 0x43 0x8
+						   0x4  0x8
+						   0x51 0x8
+						   0x52 0x8
+						   0x56 0x8
+						   0x57 0x8
+						   0x58 0x8
+						   0x59 0x8 >;
+			interrupt-parent = < &ipic >;
+		};
 	};
 
 	pci0: pci@e0008500 {

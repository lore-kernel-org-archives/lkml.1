Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbZHGT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbZHGT6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933467AbZHGT6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:58:23 -0400
Received: from ru.mvista.com ([213.79.90.228]:2286 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933270AbZHGT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:58:22 -0400
Date: Fri, 7 Aug 2009 23:58:22 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH 7/7] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Message-ID: <20090807195822.GG2735@oksana.dev.rtsoft.ru>
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply adds sdhci node to the device tree.

We specify clock-frequency manually, so that eSDHC will work without
upgrading U-Boot. Though, that'll only work for default setup (1500
MHz) on new board revisions. For non-default setups, it's recommended
to upgrade U-Boot, since it will fixup clock-frequency automatically.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/boot/dts/mpc8536ds.dts |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8536ds.dts b/arch/powerpc/boot/dts/mpc8536ds.dts
index 22caf69..815cebb 100644
--- a/arch/powerpc/boot/dts/mpc8536ds.dts
+++ b/arch/powerpc/boot/dts/mpc8536ds.dts
@@ -250,6 +250,14 @@
 			phy_type = "ulpi";
 		};
 
+		sdhci@2e000 {
+			compatible = "fsl,mpc8536-esdhc", "fsl,esdhc";
+			reg = <0x2e000 0x1000>;
+			interrupts = <72 0x2>;
+			interrupt-parent = <&mpic>;
+			clock-frequency = <250000000>;
+		};
+
 		serial0: serial@4500 {
 			cell-index = <0>;
 			device_type = "serial";
-- 
1.6.3.3

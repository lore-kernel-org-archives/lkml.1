Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZHRXiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZHRXiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZHRXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:38:20 -0400
Received: from ru.mvista.com ([213.79.90.228]:44487 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751603AbZHRXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:38:20 -0400
Date: Wed, 19 Aug 2009 03:38:18 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>, David Vrabel <david.vrabel@csr.com>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v2] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Message-ID: <20090818233818.GA29042@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
 <20090807195822.GG2735@oksana.dev.rtsoft.ru>
 <A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org>
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

On Tue, Aug 11, 2009 at 08:48:32AM -0500, Kumar Gala wrote:
> On Aug 7, 2009, at 2:58 PM, Anton Vorontsov wrote:
> >This patch simply adds sdhci node to the device tree.
> >
> >We specify clock-frequency manually, so that eSDHC will work without
> >upgrading U-Boot. Though, that'll only work for default setup (1500
> >MHz) on new board revisions. For non-default setups, it's recommended
> >to upgrade U-Boot, since it will fixup clock-frequency automatically.
> >
> >Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> >---
> >arch/powerpc/boot/dts/mpc8536ds.dts |    8 ++++++++
> >1 files changed, 8 insertions(+), 0 deletions(-)
> 
> Can you update the mpc8536ds_36b.dts as well (its in my next branch)

Sure thing.

 arch/powerpc/boot/dts/mpc8536ds.dts     |    8 ++++++++
 arch/powerpc/boot/dts/mpc8536ds_36b.dts |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

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
diff --git a/arch/powerpc/boot/dts/mpc8536ds_36b.dts b/arch/powerpc/boot/dts/mpc8536ds_36b.dts
index 113ed8b..d95b260 100644
--- a/arch/powerpc/boot/dts/mpc8536ds_36b.dts
+++ b/arch/powerpc/boot/dts/mpc8536ds_36b.dts
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


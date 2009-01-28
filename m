Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZA1Uo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZA1Uo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZA1Ua4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:56 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33012 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZA1Uaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:55 -0500
MBOX-Line: From nobody Tue Jan 27 19:13:09 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 07/10] OMAP: Add CSI2 clock struct for handling it with
	clock API.
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Sergio Aguirre <saaguirre@ti.com>, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:13:09 -0700
Message-ID: <20090128021305.7244.10176.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Aguirre <saaguirre@ti.com>

Add CSI2 clock struct for handling it with clock API when TI PM is disabled.

linux-omap source commit is 8b20f4498928459276bd3366e3381ad595d23432.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h       |   12 ++++++++++++
 arch/arm/mach-omap2/cm-regbits-34xx.h |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 63adfab..d19558d 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -2196,6 +2196,17 @@ static struct clk cam_ick = {
 	.recalc		= &followparent_recalc,
 };
 
+static struct clk csi2_96m_fck = {
+	.name		= "csi2_96m_fck",
+	.parent		= &core_96m_fck,
+	.init		= &omap2_init_clk_clkdm,
+	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_FCLKEN),
+	.enable_bit	= OMAP3430_EN_CSI2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X,
+	.clkdm_name	= "cam_clkdm",
+	.recalc		= &followparent_recalc,
+};
+
 /* USBHOST - 3430ES2 only */
 
 static struct clk usbhost_120m_fck = {
@@ -3176,6 +3187,7 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&dss_ick,
 	&cam_mclk,
 	&cam_ick,
+	&csi2_96m_fck,
 	&usbhost_120m_fck,
 	&usbhost_48m_fck,
 	&usbhost_ick,
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index f3c327b..aaf68a5 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -524,6 +524,8 @@
 #define OMAP3430_CLKACTIVITY_DSS_MASK			(1 << 0)
 
 /* CM_FCLKEN_CAM specific bits */
+#define OMAP3430_EN_CSI2				(1 << 1)
+#define OMAP3430_EN_CSI2_SHIFT				1
 
 /* CM_ICLKEN_CAM specific bits */
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZBFDyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZBFDyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZBFDw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:52:57 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:59990 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZBFDwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:54 -0500
MBOX-Line: From nobody Thu Feb  5 20:45:28 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3/3] OMAP3 powerdomains: make USBTLL SAR only available on
	ES3.1 and beyond
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, paul@pwsan.com,
       Richard Woodruff <r-woodruff2@ti.com>
Date: Thu, 05 Feb 2009 20:45:28 -0700
Message-ID: <20090206034525.31313.32758.stgit@localhost.localdomain>
In-Reply-To: <20090206033847.31313.45612.stgit@localhost.localdomain>
References: <20090206033847.31313.45612.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Woodruff writes that chip errata prevent USBTLL SAR from working
on OMAP3 ES levels before ES3.1:

http://marc.info/?l=linux-arm-kernel&m=123319614808833&w=2

Update the OMAP3 powerdomain structures appropriately.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
---
 arch/arm/mach-omap2/powerdomains.h     |    4 ++--
 arch/arm/mach-omap2/powerdomains34xx.h |   10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
index 51623e2..691470e 100644
--- a/arch/arm/mach-omap2/powerdomains.h
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -171,8 +171,8 @@ static struct powerdomain *powerdomains_omap[] __initdata = {
 	&iva2_pwrdm,
 	&mpu_34xx_pwrdm,
 	&neon_pwrdm,
-	&core_34xx_es1_pwrdm,
-	&core_34xx_es2_pwrdm,
+	&core_34xx_pre_es3_1_pwrdm,
+	&core_34xx_es3_1_pwrdm,
 	&cam_pwrdm,
 	&dss_pwrdm,
 	&per_pwrdm,
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index 6b9d126..4dcf94b 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -200,10 +200,12 @@ static struct powerdomain mpu_34xx_pwrdm = {
 };
 
 /* No wkdeps or sleepdeps for 34xx core apparently */
-static struct powerdomain core_34xx_es1_pwrdm = {
+static struct powerdomain core_34xx_pre_es3_1_pwrdm = {
 	.name		  = "core_pwrdm",
 	.prcm_offs	  = CORE_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1 |
+					   CHIP_IS_OMAP3430ES2 |
+					   CHIP_IS_OMAP3430ES3_0),
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.dep_bit	  = OMAP3430_EN_CORE_SHIFT,
 	.banks		  = 2,
@@ -218,10 +220,10 @@ static struct powerdomain core_34xx_es1_pwrdm = {
 };
 
 /* No wkdeps or sleepdeps for 34xx core apparently */
-static struct powerdomain core_34xx_es2_pwrdm = {
+static struct powerdomain core_34xx_es3_1_pwrdm = {
 	.name		  = "core_pwrdm",
 	.prcm_offs	  = CORE_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES3_1),
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.dep_bit	  = OMAP3430_EN_CORE_SHIFT,
 	.flags		  = PWRDM_HAS_HDWR_SAR, /* for USBTLL only */



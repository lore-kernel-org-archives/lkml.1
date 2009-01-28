Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZA1U2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZA1U2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZA1U1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:31 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60913 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZA1U1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:25 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:22 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 03/11] OMAP2 PRCM: clean up CM_IDLEST bits
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:22 -0700
Message-ID: <20090128191819.16688.61590.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few OMAP2xxx CM_IDLEST bits that were incorrectly
marked as being OMAP2xxx-wide, when they were actually 2420-specific.

Also, originally when the PRCM register macros were defined, bit shift
macros used a "_SHIFT" suffix, and mask macros used none.  This became
a source of bugs and confusion, as the mask macros were mistakenly
used for shift values.  Gradually, the mask macros have been updated,
piece by piece, to add a "_MASK" suffix on the end to clarify.  This
patch applies this change to the CM_IDLEST_* register bits.

The patch also adds a few bits that were missing, mostly from the 3430ES1
to ES2 revisions.

linux-omap source commits are d18eff5b5fa15e170794397a6a94486d1f774f77,
e1f1a5cc24615fb790cc763c96d1c5cfe6296f5b, and part of
9fe6b6cf8d9e0cbb429fd64553a4b3160a9e99e1

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/cm-regbits-24xx.h |   80 +++++++++----
 arch/arm/mach-omap2/cm-regbits-34xx.h |   96 ++++++++++++----
 arch/arm/mach-omap2/prcm-common.h     |  198 ++++++++++++++++++++++-----------
 3 files changed, 257 insertions(+), 117 deletions(-)

diff --git a/arch/arm/mach-omap2/cm-regbits-24xx.h b/arch/arm/mach-omap2/cm-regbits-24xx.h
index 1098ecf..297a2fe 100644
--- a/arch/arm/mach-omap2/cm-regbits-24xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-24xx.h
@@ -110,35 +110,56 @@
 #define OMAP24XX_EN_DES					(1 << 0)
 
 /* CM_IDLEST1_CORE specific bits */
-#define OMAP24XX_ST_MAILBOXES				(1 << 30)
-#define OMAP24XX_ST_WDT4				(1 << 29)
-#define OMAP2420_ST_WDT3				(1 << 28)
-#define OMAP24XX_ST_MSPRO				(1 << 27)
-#define OMAP24XX_ST_FAC					(1 << 25)
-#define OMAP2420_ST_EAC					(1 << 24)
-#define OMAP24XX_ST_HDQ					(1 << 23)
-#define OMAP24XX_ST_I2C2				(1 << 20)
-#define OMAP24XX_ST_I2C1				(1 << 19)
-#define OMAP24XX_ST_MCBSP2				(1 << 16)
-#define OMAP24XX_ST_MCBSP1				(1 << 15)
-#define OMAP24XX_ST_DSS					(1 << 0)
+#define OMAP24XX_ST_MAILBOXES_SHIFT			30
+#define OMAP24XX_ST_MAILBOXES_MASK			(1 << 30)
+#define OMAP24XX_ST_WDT4_SHIFT				29
+#define OMAP24XX_ST_WDT4_MASK				(1 << 29)
+#define OMAP2420_ST_WDT3_SHIFT				28
+#define OMAP2420_ST_WDT3_MASK				(1 << 28)
+#define OMAP24XX_ST_MSPRO_SHIFT				27
+#define OMAP24XX_ST_MSPRO_MASK				(1 << 27)
+#define OMAP24XX_ST_FAC_SHIFT				25
+#define OMAP24XX_ST_FAC_MASK				(1 << 25)
+#define OMAP2420_ST_EAC_SHIFT				24
+#define OMAP2420_ST_EAC_MASK				(1 << 24)
+#define OMAP24XX_ST_HDQ_SHIFT				23
+#define OMAP24XX_ST_HDQ_MASK				(1 << 23)
+#define OMAP2420_ST_I2C2_SHIFT				20
+#define OMAP2420_ST_I2C2_MASK				(1 << 20)
+#define OMAP2420_ST_I2C1_SHIFT				19
+#define OMAP2420_ST_I2C1_MASK				(1 << 19)
+#define OMAP24XX_ST_MCBSP2_SHIFT			16
+#define OMAP24XX_ST_MCBSP2_MASK				(1 << 16)
+#define OMAP24XX_ST_MCBSP1_SHIFT			15
+#define OMAP24XX_ST_MCBSP1_MASK				(1 << 15)
+#define OMAP24XX_ST_DSS_SHIFT				0
+#define OMAP24XX_ST_DSS_MASK				(1 << 0)
 
 /* CM_IDLEST2_CORE */
-#define OMAP2430_ST_MCBSP5				(1 << 5)
-#define OMAP2430_ST_MCBSP4				(1 << 4)
-#define OMAP2430_ST_MCBSP3				(1 << 3)
-#define OMAP24XX_ST_SSI					(1 << 1)
+#define OMAP2430_ST_MCBSP5_SHIFT			5
+#define OMAP2430_ST_MCBSP5_MASK				(1 << 5)
+#define OMAP2430_ST_MCBSP4_SHIFT				4
+#define OMAP2430_ST_MCBSP4_MASK				(1 << 4)
+#define OMAP2430_ST_MCBSP3_SHIFT				3
+#define OMAP2430_ST_MCBSP3_MASK				(1 << 3)
+#define OMAP24XX_ST_SSI_SHIFT				1
+#define OMAP24XX_ST_SSI_MASK				(1 << 1)
 
 /* CM_IDLEST3_CORE */
 /* 2430 only */
-#define OMAP2430_ST_SDRC				(1 << 2)
+#define OMAP2430_ST_SDRC_MASK				(1 << 2)
 
 /* CM_IDLEST4_CORE */
-#define OMAP24XX_ST_PKA					(1 << 4)
-#define OMAP24XX_ST_AES					(1 << 3)
-#define OMAP24XX_ST_RNG					(1 << 2)
-#define OMAP24XX_ST_SHA					(1 << 1)
-#define OMAP24XX_ST_DES					(1 << 0)
+#define OMAP24XX_ST_PKA_SHIFT				4
+#define OMAP24XX_ST_PKA_MASK				(1 << 4)
+#define OMAP24XX_ST_AES_SHIFT				3
+#define OMAP24XX_ST_AES_MASK				(1 << 3)
+#define OMAP24XX_ST_RNG_SHIFT				2
+#define OMAP24XX_ST_RNG_MASK				(1 << 2)
+#define OMAP24XX_ST_SHA_SHIFT				1
+#define OMAP24XX_ST_SHA_MASK				(1 << 1)
+#define OMAP24XX_ST_DES_SHIFT				0
+#define OMAP24XX_ST_DES_MASK				(1 << 0)
 
 /* CM_AUTOIDLE1_CORE */
 #define OMAP24XX_AUTO_CAM				(1 << 31)
@@ -275,11 +296,16 @@
 #define OMAP24XX_EN_32KSYNC				(1 << 1)
 
 /* CM_IDLEST_WKUP specific bits */
-#define OMAP2430_ST_ICR					(1 << 6)
-#define OMAP24XX_ST_OMAPCTRL				(1 << 5)
-#define OMAP24XX_ST_WDT1				(1 << 4)
-#define OMAP24XX_ST_MPU_WDT				(1 << 3)
-#define OMAP24XX_ST_32KSYNC				(1 << 1)
+#define OMAP2430_ST_ICR_SHIFT				6
+#define OMAP2430_ST_ICR_MASK				(1 << 6)
+#define OMAP24XX_ST_OMAPCTRL_SHIFT			5
+#define OMAP24XX_ST_OMAPCTRL_MASK			(1 << 5)
+#define OMAP24XX_ST_WDT1_SHIFT				4
+#define OMAP24XX_ST_WDT1_MASK				(1 << 4)
+#define OMAP24XX_ST_MPU_WDT_SHIFT			3
+#define OMAP24XX_ST_MPU_WDT_MASK			(1 << 3)
+#define OMAP24XX_ST_32KSYNC_SHIFT			1
+#define OMAP24XX_ST_32KSYNC_MASK			(1 << 1)
 
 /* CM_AUTOIDLE_WKUP */
 #define OMAP24XX_AUTO_OMAPCTRL				(1 << 5)
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index 844356c..6f3f5a3 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -183,29 +183,52 @@
 #define OMAP3430ES2_EN_CPEFUSE_MASK			(1 << 0)
 
 /* CM_IDLEST1_CORE specific bits */
-#define OMAP3430_ST_ICR					(1 << 29)
-#define OMAP3430_ST_AES2				(1 << 28)
-#define OMAP3430_ST_SHA12				(1 << 27)
-#define OMAP3430_ST_DES2				(1 << 26)
-#define OMAP3430_ST_MSPRO				(1 << 23)
-#define OMAP3430_ST_HDQ					(1 << 22)
-#define OMAP3430ES1_ST_FAC				(1 << 8)
-#define OMAP3430ES1_ST_MAILBOXES			(1 << 7)
-#define OMAP3430_ST_OMAPCTRL				(1 << 6)
-#define OMAP3430_ST_SDMA				(1 << 2)
-#define OMAP3430_ST_SDRC				(1 << 1)
-#define OMAP3430_ST_SSI					(1 << 0)
+#define OMAP3430ES2_ST_MMC3_SHIFT			30
+#define OMAP3430ES2_ST_MMC3_MASK			(1 << 30)
+#define OMAP3430_ST_ICR_SHIFT				29
+#define OMAP3430_ST_ICR_MASK				(1 << 29)
+#define OMAP3430_ST_AES2_SHIFT				28
+#define OMAP3430_ST_AES2_MASK				(1 << 28)
+#define OMAP3430_ST_SHA12_SHIFT				27
+#define OMAP3430_ST_SHA12_MASK				(1 << 27)
+#define OMAP3430_ST_DES2_SHIFT				26
+#define OMAP3430_ST_DES2_MASK				(1 << 26)
+#define OMAP3430_ST_MSPRO_SHIFT				23
+#define OMAP3430_ST_MSPRO_MASK				(1 << 23)
+#define OMAP3430_ST_HDQ_SHIFT				22
+#define OMAP3430_ST_HDQ_MASK				(1 << 22)
+#define OMAP3430ES1_ST_FAC_SHIFT			8
+#define OMAP3430ES1_ST_FAC_MASK				(1 << 8)
+#define OMAP3430ES2_ST_SSI_IDLE_SHIFT			8
+#define OMAP3430ES2_ST_SSI_IDLE_MASK			(1 << 8)
+#define OMAP3430_ST_MAILBOXES_SHIFT			7
+#define OMAP3430_ST_MAILBOXES_MASK			(1 << 7)
+#define OMAP3430_ST_OMAPCTRL_SHIFT			6
+#define OMAP3430_ST_OMAPCTRL_MASK			(1 << 6)
+#define OMAP3430_ST_SDMA_SHIFT				2
+#define OMAP3430_ST_SDMA_MASK				(1 << 2)
+#define OMAP3430_ST_SDRC_SHIFT				1
+#define OMAP3430_ST_SDRC_MASK				(1 << 1)
+#define OMAP3430_ST_SSI_STDBY_SHIFT			0
+#define OMAP3430_ST_SSI_STDBY_MASK			(1 << 0)
 
 /* CM_IDLEST2_CORE */
-#define OMAP3430_ST_PKA					(1 << 4)
-#define OMAP3430_ST_AES1				(1 << 3)
-#define OMAP3430_ST_RNG					(1 << 2)
-#define OMAP3430_ST_SHA11				(1 << 1)
-#define OMAP3430_ST_DES1				(1 << 0)
+#define OMAP3430_ST_PKA_SHIFT				4
+#define OMAP3430_ST_PKA_MASK				(1 << 4)
+#define OMAP3430_ST_AES1_SHIFT				3
+#define OMAP3430_ST_AES1_MASK				(1 << 3)
+#define OMAP3430_ST_RNG_SHIFT				2
+#define OMAP3430_ST_RNG_MASK				(1 << 2)
+#define OMAP3430_ST_SHA11_SHIFT				1
+#define OMAP3430_ST_SHA11_MASK				(1 << 1)
+#define OMAP3430_ST_DES1_SHIFT				0
+#define OMAP3430_ST_DES1_MASK				(1 << 0)
 
 /* CM_IDLEST3_CORE */
 #define OMAP3430ES2_ST_USBTLL_SHIFT			2
 #define OMAP3430ES2_ST_USBTLL_MASK			(1 << 2)
+#define OMAP3430ES2_ST_CPEFUSE_SHIFT			0
+#define OMAP3430ES2_ST_CPEFUSE_MASK			(1 << 0)
 
 /* CM_AUTOIDLE1_CORE */
 #define OMAP3430ES2_AUTO_MMC3				(1 << 30)
@@ -360,6 +383,7 @@
 
 /* CM_FCLKEN_WKUP specific bits */
 #define OMAP3430ES2_EN_USIMOCP_SHIFT			9
+#define OMAP3430ES2_EN_USIMOCP_MASK			(1 << 9)
 
 /* CM_ICLKEN_WKUP specific bits */
 #define OMAP3430_EN_WDT1				(1 << 4)
@@ -368,11 +392,18 @@
 #define OMAP3430_EN_32KSYNC_SHIFT			2
 
 /* CM_IDLEST_WKUP specific bits */
-#define OMAP3430_ST_WDT2				(1 << 5)
-#define OMAP3430_ST_WDT1				(1 << 4)
-#define OMAP3430_ST_32KSYNC				(1 << 2)
+#define OMAP3430ES2_ST_USIMOCP_SHIFT			9
+#define OMAP3430ES2_ST_USIMOCP_MASK			(1 << 9)
+#define OMAP3430_ST_WDT2_SHIFT				5
+#define OMAP3430_ST_WDT2_MASK				(1 << 5)
+#define OMAP3430_ST_WDT1_SHIFT				4
+#define OMAP3430_ST_WDT1_MASK				(1 << 4)
+#define OMAP3430_ST_32KSYNC_SHIFT			2
+#define OMAP3430_ST_32KSYNC_MASK			(1 << 2)
 
 /* CM_AUTOIDLE_WKUP */
+#define OMAP3430ES2_AUTO_USIMOCP				(1 << 9)
+#define OMAP3430ES2_AUTO_USIMOCP_SHIFT			9
 #define OMAP3430_AUTO_WDT2				(1 << 5)
 #define OMAP3430_AUTO_WDT2_SHIFT			5
 #define OMAP3430_AUTO_WDT1				(1 << 4)
@@ -437,6 +468,8 @@
 #define OMAP3430_ST_CORE_CLK_MASK			(1 << 0)
 
 /* CM_IDLEST2_CKGEN */
+#define OMAP3430ES2_ST_USIM_CLK_SHIFT			2
+#define OMAP3430ES2_ST_USIM_CLK_MASK			(1 << 2)
 #define OMAP3430ES2_ST_120M_CLK_SHIFT			1
 #define OMAP3430ES2_ST_120M_CLK_MASK			(1 << 1)
 #define OMAP3430ES2_ST_PERIPH2_CLK_SHIFT		0
@@ -508,7 +541,12 @@
 #define OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT		0
 
 /* CM_IDLEST_DSS */
-#define OMAP3430_ST_DSS					(1 << 0)
+#define OMAP3430ES2_ST_DSS_IDLE_SHIFT			1
+#define OMAP3430ES2_ST_DSS_IDLE_MASK			(1 << 1)
+#define OMAP3430ES2_ST_DSS_STDBY_SHIFT			0
+#define OMAP3430ES2_ST_DSS_STDBY_MASK			(1 << 0)
+#define OMAP3430ES1_ST_DSS_SHIFT			0
+#define OMAP3430ES1_ST_DSS_MASK				(1 << 0)
 
 /* CM_AUTOIDLE_DSS */
 #define OMAP3430_AUTO_DSS				(1 << 0)
@@ -562,10 +600,14 @@
 /* CM_ICLKEN_PER specific bits */
 
 /* CM_IDLEST_PER */
-#define OMAP3430_ST_WDT3				(1 << 12)
-#define OMAP3430_ST_MCBSP4				(1 << 2)
-#define OMAP3430_ST_MCBSP3				(1 << 1)
-#define OMAP3430_ST_MCBSP2				(1 << 0)
+#define OMAP3430_ST_WDT3_SHIFT				12
+#define OMAP3430_ST_WDT3_MASK				(1 << 12)
+#define OMAP3430_ST_MCBSP4_SHIFT			2
+#define OMAP3430_ST_MCBSP4_MASK				(1 << 2)
+#define OMAP3430_ST_MCBSP3_SHIFT			1
+#define OMAP3430_ST_MCBSP3_MASK				(1 << 1)
+#define OMAP3430_ST_MCBSP2_SHIFT			0
+#define OMAP3430_ST_MCBSP2_MASK				(1 << 0)
 
 /* CM_AUTOIDLE_PER */
 #define OMAP3430_AUTO_GPIO6				(1 << 17)
@@ -693,6 +735,10 @@
 #define OMAP3430ES2_EN_USBHOST_MASK			(1 << 0)
 
 /* CM_IDLEST_USBHOST */
+#define OMAP3430ES2_ST_USBHOST_IDLE_SHIFT		1
+#define OMAP3430ES2_ST_USBHOST_IDLE_MASK		(1 << 1)
+#define OMAP3430ES2_ST_USBHOST_STDBY_SHIFT		0
+#define OMAP3430ES2_ST_USBHOST_STDBY_MASK		(1 << 0)
 
 /* CM_AUTOIDLE_USBHOST */
 #define OMAP3430ES2_AUTO_USBHOST_SHIFT			0
diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index 4a32822..812d50e 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -113,33 +113,58 @@
 #define OMAP2430_EN_USBHS				(1 << 6)
 
 /* CM_IDLEST1_CORE, PM_WKST1_CORE shared bits */
-#define OMAP2420_ST_MMC					(1 << 26)
-#define OMAP24XX_ST_UART2				(1 << 22)
-#define OMAP24XX_ST_UART1				(1 << 21)
-#define OMAP24XX_ST_MCSPI2				(1 << 18)
-#define OMAP24XX_ST_MCSPI1				(1 << 17)
-#define OMAP24XX_ST_GPT12				(1 << 14)
-#define OMAP24XX_ST_GPT11				(1 << 13)
-#define OMAP24XX_ST_GPT10				(1 << 12)
-#define OMAP24XX_ST_GPT9				(1 << 11)
-#define OMAP24XX_ST_GPT8				(1 << 10)
-#define OMAP24XX_ST_GPT7				(1 << 9)
-#define OMAP24XX_ST_GPT6				(1 << 8)
-#define OMAP24XX_ST_GPT5				(1 << 7)
-#define OMAP24XX_ST_GPT4				(1 << 6)
-#define OMAP24XX_ST_GPT3				(1 << 5)
-#define OMAP24XX_ST_GPT2				(1 << 4)
-#define OMAP2420_ST_VLYNQ				(1 << 3)
+#define OMAP2420_ST_MMC_SHIFT				26
+#define OMAP2420_ST_MMC_MASK				(1 << 26)
+#define OMAP24XX_ST_UART2_SHIFT				22
+#define OMAP24XX_ST_UART2_MASK				(1 << 22)
+#define OMAP24XX_ST_UART1_SHIFT				21
+#define OMAP24XX_ST_UART1_MASK				(1 << 21)
+#define OMAP24XX_ST_MCSPI2_SHIFT			18
+#define OMAP24XX_ST_MCSPI2_MASK				(1 << 18)
+#define OMAP24XX_ST_MCSPI1_SHIFT			17
+#define OMAP24XX_ST_MCSPI1_MASK				(1 << 17)
+#define OMAP24XX_ST_GPT12_SHIFT				14
+#define OMAP24XX_ST_GPT12_MASK				(1 << 14)
+#define OMAP24XX_ST_GPT11_SHIFT				13
+#define OMAP24XX_ST_GPT11_MASK				(1 << 13)
+#define OMAP24XX_ST_GPT10_SHIFT				12
+#define OMAP24XX_ST_GPT10_MASK				(1 << 12)
+#define OMAP24XX_ST_GPT9_SHIFT				11
+#define OMAP24XX_ST_GPT9_MASK				(1 << 11)
+#define OMAP24XX_ST_GPT8_SHIFT				10
+#define OMAP24XX_ST_GPT8_MASK				(1 << 10)
+#define OMAP24XX_ST_GPT7_SHIFT				9
+#define OMAP24XX_ST_GPT7_MASK				(1 << 9)
+#define OMAP24XX_ST_GPT6_SHIFT				8
+#define OMAP24XX_ST_GPT6_MASK				(1 << 8)
+#define OMAP24XX_ST_GPT5_SHIFT				7
+#define OMAP24XX_ST_GPT5_MASK				(1 << 7)
+#define OMAP24XX_ST_GPT4_SHIFT				6
+#define OMAP24XX_ST_GPT4_MASK				(1 << 6)
+#define OMAP24XX_ST_GPT3_SHIFT				5
+#define OMAP24XX_ST_GPT3_MASK				(1 << 5)
+#define OMAP24XX_ST_GPT2_SHIFT				4
+#define OMAP24XX_ST_GPT2_MASK				(1 << 4)
+#define OMAP2420_ST_VLYNQ_SHIFT				3
+#define OMAP2420_ST_VLYNQ_MASK				(1 << 3)
 
 /* CM_IDLEST2_CORE, PM_WKST2_CORE shared bits */
-#define OMAP2430_ST_MDM_INTC				(1 << 11)
-#define OMAP2430_ST_GPIO5				(1 << 10)
-#define OMAP2430_ST_MCSPI3				(1 << 9)
-#define OMAP2430_ST_MMCHS2				(1 << 8)
-#define OMAP2430_ST_MMCHS1				(1 << 7)
-#define OMAP2430_ST_USBHS				(1 << 6)
-#define OMAP24XX_ST_UART3				(1 << 2)
-#define OMAP24XX_ST_USB					(1 << 0)
+#define OMAP2430_ST_MDM_INTC_SHIFT			11
+#define OMAP2430_ST_MDM_INTC_MASK			(1 << 11)
+#define OMAP2430_ST_GPIO5_SHIFT				10
+#define OMAP2430_ST_GPIO5_MASK				(1 << 10)
+#define OMAP2430_ST_MCSPI3_SHIFT			9
+#define OMAP2430_ST_MCSPI3_MASK				(1 << 9)
+#define OMAP2430_ST_MMCHS2_SHIFT			8
+#define OMAP2430_ST_MMCHS2_MASK				(1 << 8)
+#define OMAP2430_ST_MMCHS1_SHIFT			7
+#define OMAP2430_ST_MMCHS1_MASK				(1 << 7)
+#define OMAP2430_ST_USBHS_SHIFT				6
+#define OMAP2430_ST_USBHS_MASK				(1 << 6)
+#define OMAP24XX_ST_UART3_SHIFT				2
+#define OMAP24XX_ST_UART3_MASK				(1 << 2)
+#define OMAP24XX_ST_USB_SHIFT				0
+#define OMAP24XX_ST_USB_MASK				(1 << 0)
 
 /* CM_FCLKEN_WKUP, CM_ICLKEN_WKUP, PM_WKEN_WKUP shared bits */
 #define OMAP24XX_EN_GPIOS_SHIFT				2
@@ -148,11 +173,13 @@
 #define OMAP24XX_EN_GPT1				(1 << 0)
 
 /* PM_WKST_WKUP, CM_IDLEST_WKUP shared bits */
-#define OMAP24XX_ST_GPIOS				(1 << 2)
-#define OMAP24XX_ST_GPT1				(1 << 0)
+#define OMAP24XX_ST_GPIOS_SHIFT				(1 << 2)
+#define OMAP24XX_ST_GPIOS_MASK				2
+#define OMAP24XX_ST_GPT1_SHIFT				(1 << 0)
+#define OMAP24XX_ST_GPT1_MASK				0
 
 /* CM_IDLEST_MDM and PM_WKST_MDM shared bits */
-#define OMAP2430_ST_MDM					(1 << 0)
+#define OMAP2430_ST_MDM_SHIFT				(1 << 0)
 
 
 /* 3430 register bits shared between CM & PRM registers */
@@ -205,24 +232,46 @@
 #define OMAP3430_EN_HSOTGUSB_SHIFT				4
 
 /* PM_WKST1_CORE, CM_IDLEST1_CORE shared bits */
-#define OMAP3430_ST_MMC2				(1 << 25)
-#define OMAP3430_ST_MMC1				(1 << 24)
-#define OMAP3430_ST_MCSPI4				(1 << 21)
-#define OMAP3430_ST_MCSPI3				(1 << 20)
-#define OMAP3430_ST_MCSPI2				(1 << 19)
-#define OMAP3430_ST_MCSPI1				(1 << 18)
-#define OMAP3430_ST_I2C3				(1 << 17)
-#define OMAP3430_ST_I2C2				(1 << 16)
-#define OMAP3430_ST_I2C1				(1 << 15)
-#define OMAP3430_ST_UART2				(1 << 14)
-#define OMAP3430_ST_UART1				(1 << 13)
-#define OMAP3430_ST_GPT11				(1 << 12)
-#define OMAP3430_ST_GPT10				(1 << 11)
-#define OMAP3430_ST_MCBSP5				(1 << 10)
-#define OMAP3430_ST_MCBSP1				(1 << 9)
-#define OMAP3430_ST_FSHOSTUSB				(1 << 5)
-#define OMAP3430_ST_HSOTGUSB				(1 << 4)
-#define OMAP3430_ST_D2D					(1 << 3)
+#define OMAP3430_ST_MMC2_SHIFT				25
+#define OMAP3430_ST_MMC2_MASK				(1 << 25)
+#define OMAP3430_ST_MMC1_SHIFT				24
+#define OMAP3430_ST_MMC1_MASK				(1 << 24)
+#define OMAP3430_ST_MCSPI4_SHIFT			21
+#define OMAP3430_ST_MCSPI4_MASK				(1 << 21)
+#define OMAP3430_ST_MCSPI3_SHIFT			20
+#define OMAP3430_ST_MCSPI3_MASK				(1 << 20)
+#define OMAP3430_ST_MCSPI2_SHIFT			19
+#define OMAP3430_ST_MCSPI2_MASK				(1 << 19)
+#define OMAP3430_ST_MCSPI1_SHIFT			18
+#define OMAP3430_ST_MCSPI1_MASK				(1 << 18)
+#define OMAP3430_ST_I2C3_SHIFT				17
+#define OMAP3430_ST_I2C3_MASK				(1 << 17)
+#define OMAP3430_ST_I2C2_SHIFT				16
+#define OMAP3430_ST_I2C2_MASK				(1 << 16)
+#define OMAP3430_ST_I2C1_SHIFT				15
+#define OMAP3430_ST_I2C1_MASK				(1 << 15)
+#define OMAP3430_ST_UART2_SHIFT				14
+#define OMAP3430_ST_UART2_MASK				(1 << 14)
+#define OMAP3430_ST_UART1_SHIFT				13
+#define OMAP3430_ST_UART1_MASK				(1 << 13)
+#define OMAP3430_ST_GPT11_SHIFT				12
+#define OMAP3430_ST_GPT11_MASK				(1 << 12)
+#define OMAP3430_ST_GPT10_SHIFT				11
+#define OMAP3430_ST_GPT10_MASK				(1 << 11)
+#define OMAP3430_ST_MCBSP5_SHIFT			10
+#define OMAP3430_ST_MCBSP5_MASK				(1 << 10)
+#define OMAP3430_ST_MCBSP1_SHIFT			9
+#define OMAP3430_ST_MCBSP1_MASK				(1 << 9)
+#define OMAP3430ES1_ST_FSHOSTUSB_SHIFT			5
+#define OMAP3430ES1_ST_FSHOSTUSB_MASK			(1 << 5)
+#define OMAP3430ES1_ST_HSOTGUSB_SHIFT			4
+#define OMAP3430ES1_ST_HSOTGUSB_MASK			(1 << 4)
+#define OMAP3430ES2_ST_HSOTGUSB_IDLE_SHIFT		5
+#define OMAP3430ES2_ST_HSOTGUSB_IDLE_MASK		(1 << 5)
+#define OMAP3430ES2_ST_HSOTGUSB_STDBY_SHIFT		4
+#define OMAP3430ES2_ST_HSOTGUSB_STDBY_MASK		(1 << 4)
+#define OMAP3430_ST_D2D_SHIFT				3
+#define OMAP3430_ST_D2D_MASK				(1 << 3)
 
 /* CM_FCLKEN_WKUP, CM_ICLKEN_WKUP, PM_WKEN_WKUP shared bits */
 #define OMAP3430_EN_GPIO1				(1 << 3)
@@ -241,11 +290,16 @@
 #define OMAP3430_EN_GPT12_SHIFT				1
 
 /* CM_IDLEST_WKUP, PM_WKST_WKUP shared bits */
-#define OMAP3430_ST_SR2					(1 << 7)
-#define OMAP3430_ST_SR1					(1 << 6)
-#define OMAP3430_ST_GPIO1				(1 << 3)
-#define OMAP3430_ST_GPT12				(1 << 1)
-#define OMAP3430_ST_GPT1				(1 << 0)
+#define OMAP3430_ST_SR2_SHIFT				7
+#define OMAP3430_ST_SR2_MASK				(1 << 7)
+#define OMAP3430_ST_SR1_SHIFT				6
+#define OMAP3430_ST_SR1_MASK				(1 << 6)
+#define OMAP3430_ST_GPIO1_SHIFT				3
+#define OMAP3430_ST_GPIO1_MASK				(1 << 3)
+#define OMAP3430_ST_GPT12_SHIFT				1
+#define OMAP3430_ST_GPT12_MASK				(1 << 1)
+#define OMAP3430_ST_GPT1_SHIFT				0
+#define OMAP3430_ST_GPT1_MASK				(1 << 0)
 
 /*
  * CM_SLEEPDEP_GFX, CM_SLEEPDEP_DSS, CM_SLEEPDEP_CAM,
@@ -296,20 +350,34 @@
 #define OMAP3430_EN_MCBSP2_SHIFT			0
 
 /* CM_IDLEST_PER, PM_WKST_PER shared bits */
-#define OMAP3430_ST_GPIO6				(1 << 17)
-#define OMAP3430_ST_GPIO5				(1 << 16)
-#define OMAP3430_ST_GPIO4				(1 << 15)
-#define OMAP3430_ST_GPIO3				(1 << 14)
-#define OMAP3430_ST_GPIO2				(1 << 13)
-#define OMAP3430_ST_UART3				(1 << 11)
-#define OMAP3430_ST_GPT9				(1 << 10)
-#define OMAP3430_ST_GPT8				(1 << 9)
-#define OMAP3430_ST_GPT7				(1 << 8)
-#define OMAP3430_ST_GPT6				(1 << 7)
-#define OMAP3430_ST_GPT5				(1 << 6)
-#define OMAP3430_ST_GPT4				(1 << 5)
-#define OMAP3430_ST_GPT3				(1 << 4)
-#define OMAP3430_ST_GPT2				(1 << 3)
+#define OMAP3430_ST_GPIO6_SHIFT				17
+#define OMAP3430_ST_GPIO6_MASK				(1 << 17)
+#define OMAP3430_ST_GPIO5_SHIFT				16
+#define OMAP3430_ST_GPIO5_MASK				(1 << 16)
+#define OMAP3430_ST_GPIO4_SHIFT				15
+#define OMAP3430_ST_GPIO4_MASK				(1 << 15)
+#define OMAP3430_ST_GPIO3_SHIFT				14
+#define OMAP3430_ST_GPIO3_MASK				(1 << 14)
+#define OMAP3430_ST_GPIO2_SHIFT				13
+#define OMAP3430_ST_GPIO2_MASK				(1 << 13)
+#define OMAP3430_ST_UART3_SHIFT				11
+#define OMAP3430_ST_UART3_MASK				(1 << 11)
+#define OMAP3430_ST_GPT9_SHIFT				10
+#define OMAP3430_ST_GPT9_MASK				(1 << 10)
+#define OMAP3430_ST_GPT8_SHIFT				9
+#define OMAP3430_ST_GPT8_MASK				(1 << 9)
+#define OMAP3430_ST_GPT7_SHIFT				8
+#define OMAP3430_ST_GPT7_MASK				(1 << 8)
+#define OMAP3430_ST_GPT6_SHIFT				7
+#define OMAP3430_ST_GPT6_MASK				(1 << 7)
+#define OMAP3430_ST_GPT5_SHIFT				6
+#define OMAP3430_ST_GPT5_MASK				(1 << 6)
+#define OMAP3430_ST_GPT4_SHIFT				5
+#define OMAP3430_ST_GPT4_MASK				(1 << 5)
+#define OMAP3430_ST_GPT3_SHIFT				4
+#define OMAP3430_ST_GPT3_MASK				(1 << 4)
+#define OMAP3430_ST_GPT2_SHIFT				3
+#define OMAP3430_ST_GPT2_MASK				(1 << 3)
 
 /* CM_SLEEPDEP_PER, PM_WKDEP_IVA2, PM_WKDEP_MPU, PM_WKDEP_PER shared bits */
 #define OMAP3430_EN_CORE_SHIFT				0



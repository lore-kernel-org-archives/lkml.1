Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbYGPPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbYGPPU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbYGPPSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:18:52 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60857 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868AbYGPPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:18:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dIF4zz+UNrZ1H3hN38aQr
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 07/10] ARM: OMAP2: Clockdomain: Encode OMAP2/3 clockdomains
Date: Wed, 16 Jul 2008 18:19:12 +0300
Message-Id: <1216221555-18958-8-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-7-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
 <1216221555-18958-4-git-send-email-tony@atomide.com>
 <1216221555-18958-5-git-send-email-tony@atomide.com>
 <1216221555-18958-6-git-send-email-tony@atomide.com>
 <1216221555-18958-7-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Add clockdomain definitions for OMAP24xx and OMAP34xx chips.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
new file mode 100644
index 0000000..adbc170
--- /dev/null
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -0,0 +1,298 @@
+/*
+ * OMAP2/3 clockdomains
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Paul Walmsley
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_H
+#define __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_H
+
+#include <asm/arch/clockdomain.h>
+
+/*
+ * OMAP2/3-common clockdomains
+ */
+
+/* This is an implicit clockdomain - it is never defined as such in TRM */
+static struct clockdomain wkup_clkdm = {
+	.name		= "wkup_clkdm",
+	.pwrdm_name	= "wkup_pwrdm",
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
+};
+
+/*
+ * 2420-only clockdomains
+ */
+
+#if defined(CONFIG_ARCH_OMAP2420)
+
+static struct clockdomain mpu_2420_clkdm = {
+	.name		= "mpu_clkdm",
+	.pwrdm_name	= "mpu_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_MPU_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2420),
+};
+
+static struct clockdomain iva1_2420_clkdm = {
+	.name		= "iva1_clkdm",
+	.pwrdm_name	= "dsp_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP2420_AUTOSTATE_IVA_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2420),
+};
+
+#endif  /* CONFIG_ARCH_OMAP2420 */
+
+
+/*
+ * 2430-only clockdomains
+ */
+
+#if defined(CONFIG_ARCH_OMAP2430)
+
+static struct clockdomain mpu_2430_clkdm = {
+	.name		= "mpu_clkdm",
+	.pwrdm_name	= "mpu_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_MPU_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2430),
+};
+
+static struct clockdomain mdm_clkdm = {
+	.name		= "mdm_clkdm",
+	.pwrdm_name	= "mdm_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP2430_AUTOSTATE_MDM_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2430),
+};
+
+#endif    /* CONFIG_ARCH_OMAP2430 */
+
+
+/*
+ * 24XX-only clockdomains
+ */
+
+#if defined(CONFIG_ARCH_OMAP24XX)
+
+static struct clockdomain dsp_clkdm = {
+	.name		= "dsp_clkdm",
+	.pwrdm_name	= "dsp_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_DSP_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
+static struct clockdomain gfx_24xx_clkdm = {
+	.name		= "gfx_clkdm",
+	.pwrdm_name	= "gfx_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_GFX_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
+static struct clockdomain core_l3_24xx_clkdm = {
+	.name		= "core_l3_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_L3_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
+static struct clockdomain core_l4_24xx_clkdm = {
+	.name		= "core_l4_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_L4_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
+static struct clockdomain dss_24xx_clkdm = {
+	.name		= "dss_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP24XX_AUTOSTATE_DSS_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+};
+
+#endif   /* CONFIG_ARCH_OMAP24XX */
+
+
+/*
+ * 34xx clockdomains
+ */
+
+#if defined(CONFIG_ARCH_OMAP34XX)
+
+static struct clockdomain mpu_34xx_clkdm = {
+	.name		= "mpu_clkdm",
+	.pwrdm_name	= "mpu_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP | CLKDM_CAN_FORCE_WAKEUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_MPU_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain neon_clkdm = {
+	.name		= "neon_clkdm",
+	.pwrdm_name	= "neon_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_NEON_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain iva2_clkdm = {
+	.name		= "iva2_clkdm",
+	.pwrdm_name	= "iva2_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_IVA2_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain gfx_3430es1_clkdm = {
+	.name		= "gfx_clkdm",
+	.pwrdm_name	= "gfx_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430ES1_CLKTRCTRL_GFX_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
+};
+
+static struct clockdomain sgx_clkdm = {
+	.name		= "sgx_clkdm",
+	.pwrdm_name	= "sgx_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_SGX_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+};
+
+static struct clockdomain d2d_clkdm = {
+	.name		= "d2d_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP3430ES1_CLKTRCTRL_D2D_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
+};
+
+static struct clockdomain core_l3_34xx_clkdm = {
+	.name		= "core_l3_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_L3_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain core_l4_34xx_clkdm = {
+	.name		= "core_l4_clkdm",
+	.pwrdm_name	= "core_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_L4_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain dss_34xx_clkdm = {
+	.name		= "dss_clkdm",
+	.pwrdm_name	= "dss_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_DSS_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain cam_clkdm = {
+	.name		= "cam_clkdm",
+	.pwrdm_name	= "cam_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_CAM_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain usbhost_clkdm = {
+	.name		= "usbhost_clkdm",
+	.pwrdm_name	= "usbhost_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_USBHOST_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+};
+
+static struct clockdomain per_clkdm = {
+	.name		= "per_clkdm",
+	.pwrdm_name	= "per_pwrdm",
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_PER_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain emu_clkdm = {
+	.name		= "emu_clkdm",
+	.pwrdm_name	= "emu_pwrdm",
+	.flags		= CLKDM_CAN_ENABLE_AUTO | CLKDM_CAN_SWSUP,
+	.clktrctrl_mask = OMAP3430_CLKTRCTRL_EMU_MASK,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+#endif   /* CONFIG_ARCH_OMAP34XX */
+
+/*
+ * Clockdomain-powerdomain hwsup dependencies (34XX only)
+ */
+
+static struct clkdm_pwrdm_autodep clkdm_pwrdm_autodeps[] = {
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL }
+};
+
+/*
+ *
+ */
+
+static struct clockdomain *clockdomains_omap[] = {
+
+	&wkup_clkdm,
+
+#ifdef CONFIG_ARCH_OMAP2420
+	&mpu_2420_clkdm,
+	&iva1_2420_clkdm,
+#endif
+
+#ifdef CONFIG_ARCH_OMAP2430
+	&mpu_2430_clkdm,
+	&mdm_clkdm,
+#endif
+
+#ifdef CONFIG_ARCH_OMAP24XX
+	&dsp_clkdm,
+	&gfx_24xx_clkdm,
+	&core_l3_24xx_clkdm,
+	&core_l4_24xx_clkdm,
+	&dss_24xx_clkdm,
+#endif
+
+#ifdef CONFIG_ARCH_OMAP34XX
+	&mpu_34xx_clkdm,
+	&neon_clkdm,
+	&iva2_clkdm,
+	&gfx_3430es1_clkdm,
+	&sgx_clkdm,
+	&d2d_clkdm,
+	&core_l3_34xx_clkdm,
+	&core_l4_34xx_clkdm,
+	&dss_34xx_clkdm,
+	&cam_clkdm,
+	&usbhost_clkdm,
+	&per_clkdm,
+	&emu_clkdm,
+#endif
+
+	NULL,
+};
+
+#endif
diff --git a/arch/arm/mach-omap2/cm-regbits-24xx.h b/arch/arm/mach-omap2/cm-regbits-24xx.h
index 20ac381..1098ecf 100644
--- a/arch/arm/mach-omap2/cm-regbits-24xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-24xx.h
@@ -63,7 +63,8 @@
 #define OMAP24XX_CLKSEL_MPU_MASK			(0x1f << 0)
 
 /* CM_CLKSTCTRL_MPU */
-#define OMAP24XX_AUTOSTATE_MPU				(1 << 0)
+#define OMAP24XX_AUTOSTATE_MPU_SHIFT			0
+#define OMAP24XX_AUTOSTATE_MPU_MASK			(1 << 0)
 
 /* CM_FCLKEN1_CORE specific bits*/
 #define OMAP24XX_EN_TV_SHIFT				2
@@ -238,9 +239,12 @@
 #define OMAP24XX_CLKSEL_GPT2_MASK			(0x3 << 2)
 
 /* CM_CLKSTCTRL_CORE */
-#define OMAP24XX_AUTOSTATE_DSS				(1 << 2)
-#define OMAP24XX_AUTOSTATE_L4				(1 << 1)
-#define OMAP24XX_AUTOSTATE_L3				(1 << 0)
+#define OMAP24XX_AUTOSTATE_DSS_SHIFT			2
+#define OMAP24XX_AUTOSTATE_DSS_MASK			(1 << 2)
+#define OMAP24XX_AUTOSTATE_L4_SHIFT			1
+#define OMAP24XX_AUTOSTATE_L4_MASK			(1 << 1)
+#define OMAP24XX_AUTOSTATE_L3_SHIFT			0
+#define OMAP24XX_AUTOSTATE_L3_MASK			(1 << 0)
 
 /* CM_FCLKEN_GFX */
 #define OMAP24XX_EN_3D_SHIFT				2
@@ -255,7 +259,8 @@
 /* CM_CLKSEL_GFX specific bits */
 
 /* CM_CLKSTCTRL_GFX */
-#define OMAP24XX_AUTOSTATE_GFX				(1 << 0)
+#define OMAP24XX_AUTOSTATE_GFX_SHIFT			0
+#define OMAP24XX_AUTOSTATE_GFX_MASK			(1 << 0)
 
 /* CM_FCLKEN_WKUP specific bits */
 
@@ -367,8 +372,10 @@
 #define OMAP24XX_CLKSEL_DSP_MASK			(0x1f << 0)
 
 /* CM_CLKSTCTRL_DSP */
-#define OMAP2420_AUTOSTATE_IVA				(1 << 8)
-#define OMAP24XX_AUTOSTATE_DSP				(1 << 0)
+#define OMAP2420_AUTOSTATE_IVA_SHIFT			8
+#define OMAP2420_AUTOSTATE_IVA_MASK			(1 << 8)
+#define OMAP24XX_AUTOSTATE_DSP_SHIFT			0
+#define OMAP24XX_AUTOSTATE_DSP_MASK			(1 << 0)
 
 /* CM_FCLKEN_MDM */
 /* 2430 only */
@@ -396,6 +403,7 @@
 
 /* CM_CLKSTCTRL_MDM */
 /* 2430 only */
-#define OMAP2430_AUTOSTATE_MDM				(1 << 0)
+#define OMAP2430_AUTOSTATE_MDM_SHIFT			0
+#define OMAP2430_AUTOSTATE_MDM_MASK			(1 << 0)
 
 #endif
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index ee4c0ca..219f5c8 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -96,7 +96,8 @@
 #define OMAP3430_CLKTRCTRL_IVA2_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_IVA2 */
-#define OMAP3430_CLKACTIVITY_IVA2			(1 << 0)
+#define OMAP3430_CLKACTIVITY_IVA2_SHIFT			0
+#define OMAP3430_CLKACTIVITY_IVA2_MASK			(1 << 0)
 
 /* CM_REVISION specific bits */
 
@@ -140,7 +141,8 @@
 #define OMAP3430_CLKTRCTRL_MPU_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_MPU */
-#define OMAP3430_CLKACTIVITY_MPU			(1 << 0)
+#define OMAP3430_CLKACTIVITY_MPU_SHIFT			0
+#define OMAP3430_CLKACTIVITY_MPU_MASK			(1 << 0)
 
 /* CM_FCLKEN1_CORE specific bits */
 
@@ -300,9 +302,12 @@
 #define OMAP3430_CLKTRCTRL_L3_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_CORE */
-#define OMAP3430ES1_CLKACTIVITY_D2D			(1 << 2)
-#define OMAP3430_CLKACTIVITY_L4				(1 << 1)
-#define OMAP3430_CLKACTIVITY_L3				(1 << 0)
+#define OMAP3430ES1_CLKACTIVITY_D2D_SHIFT		2
+#define OMAP3430ES1_CLKACTIVITY_D2D_MASK		(1 << 2)
+#define OMAP3430_CLKACTIVITY_L4_SHIFT			1
+#define OMAP3430_CLKACTIVITY_L4_MASK			(1 << 1)
+#define OMAP3430_CLKACTIVITY_L3_SHIFT			0
+#define OMAP3430_CLKACTIVITY_L3_MASK			(1 << 0)
 
 /* CM_FCLKEN_GFX */
 #define OMAP3430ES1_EN_3D				(1 << 2)
@@ -323,7 +328,8 @@
 #define OMAP3430ES1_CLKTRCTRL_GFX_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_GFX */
-#define OMAP3430ES1_CLKACTIVITY_GFX			(1 << 0)
+#define OMAP3430ES1_CLKACTIVITY_GFX_SHIFT		0
+#define OMAP3430ES1_CLKACTIVITY_GFX_MASK		(1 << 0)
 
 /* CM_FCLKEN_SGX */
 #define OMAP3430ES2_EN_SGX_SHIFT			1
@@ -333,6 +339,14 @@
 #define OMAP3430ES2_CLKSEL_SGX_SHIFT			0
 #define OMAP3430ES2_CLKSEL_SGX_MASK			(0x7 << 0)
 
+/* CM_CLKSTCTRL_SGX */
+#define OMAP3430ES2_CLKTRCTRL_SGX_SHIFT			0
+#define OMAP3430ES2_CLKTRCTRL_SGX_MASK			(0x3 << 0)
+
+/* CM_CLKSTST_SGX */
+#define OMAP3430ES2_CLKACTIVITY_SGX_SHIFT		0
+#define OMAP3430ES2_CLKACTIVITY_SGX_MASK		(1 << 0)
+
 /* CM_FCLKEN_WKUP specific bits */
 #define OMAP3430ES2_EN_USIMOCP_SHIFT			9
 
@@ -498,7 +512,8 @@
 #define OMAP3430_CLKTRCTRL_DSS_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_DSS */
-#define OMAP3430_CLKACTIVITY_DSS			(1 << 0)
+#define OMAP3430_CLKACTIVITY_DSS_SHIFT			0
+#define OMAP3430_CLKACTIVITY_DSS_MASK			(1 << 0)
 
 /* CM_FCLKEN_CAM specific bits */
 
@@ -522,7 +537,8 @@
 #define OMAP3430_CLKTRCTRL_CAM_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_CAM */
-#define OMAP3430_CLKACTIVITY_CAM			(1 << 0)
+#define OMAP3430_CLKACTIVITY_CAM_SHIFT			0
+#define OMAP3430_CLKACTIVITY_CAM_MASK			(1 << 0)
 
 /* CM_FCLKEN_PER specific bits */
 
@@ -598,7 +614,8 @@
 #define OMAP3430_CLKTRCTRL_PER_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_PER */
-#define OMAP3430_CLKACTIVITY_PER			(1 << 0)
+#define OMAP3430_CLKACTIVITY_PER_SHIFT			0
+#define OMAP3430_CLKACTIVITY_PER_MASK			(1 << 0)
 
 /* CM_CLKSEL1_EMU */
 #define OMAP3430_DIV_DPLL4_SHIFT			24
@@ -623,7 +640,8 @@
 #define OMAP3430_CLKTRCTRL_EMU_MASK			(0x3 << 0)
 
 /* CM_CLKSTST_EMU */
-#define OMAP3430_CLKACTIVITY_EMU			(1 << 0)
+#define OMAP3430_CLKACTIVITY_EMU_SHIFT			0
+#define OMAP3430_CLKACTIVITY_EMU_MASK			(1 << 0)
 
 /* CM_CLKSEL2_EMU specific bits */
 #define OMAP3430_CORE_DPLL_EMU_MULT_SHIFT		8
@@ -673,6 +691,8 @@
 #define OMAP3430ES2_CLKTRCTRL_USBHOST_SHIFT		0
 #define OMAP3430ES2_CLKTRCTRL_USBHOST_MASK		(3 << 0)
 
-
+/* CM_CLKSTST_USBHOST */
+#define OMAP3430ES2_CLKACTIVITY_USBHOST_SHIFT		0
+#define OMAP3430ES2_CLKACTIVITY_USBHOST_MASK		(1 << 0)
 
 #endif
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 20ddfaa..a2d9ec8 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -28,6 +28,9 @@
 
 #include "powerdomains.h"
 
+#include <asm/arch/clockdomain.h>
+#include "clockdomains.h"
+
 extern void omap_sram_init(void);
 extern int omap2_clk_init(void);
 extern void omap2_check_revision(void);
@@ -106,6 +109,7 @@ void __init omap2_init_common_hw(void)
 {
 	omap2_mux_init();
 	pwrdm_init(powerdomains_omap);
+	clkdm_init(clockdomains_omap, clkdm_pwrdm_autodeps);
 	omap2_clk_init();
 /*
  * Need to Fix this for 2430

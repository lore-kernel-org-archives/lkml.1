Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbZGDBpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbZGDBpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbZGDBoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:39 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770AbZGDBo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:28 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:25 -0700
Subject: [PATCH v2 11/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 11/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SPXazBkPR7pMQCSfgxjH0lLT4g==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C19@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C704CG20368203-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From d4e2a34763798d42671ab257445b2b5f7e3e1cb9 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:07:59 -0700
Subject: [PATCH 11/18] include/mach/csp header files

add mach-bcmring/include/mach/csp header files
most of them are register definitions, and inline functions

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/include/mach/csp/cap.h       |   63 +
 .../arm/mach-bcmring/include/mach/csp/cap_inline.h |  409 +++++
 .../mach-bcmring/include/mach/csp/chipcHw_def.h    | 1123 +++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_inline.h | 1673 ++++++++++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h    |  530 +++++++
 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h   |  872 ++++++++++
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h    |   73 +
 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h |  100 ++
 .../mach-bcmring/include/mach/csp/secHw_inline.h   |   79 +
 .../mach-bcmring/include/mach/csp/uartHw_inline.h  |  361 +++++
 .../arm/mach-bcmring/include/mach/csp/uartHw_reg.h |  169 ++
 11 files changed, 5452 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h

diff --git a/arch/arm/mach-bcmring/include/mach/csp/cap.h b/arch/arm/mach-bcmring/include/mach/csp/cap.h
new file mode 100644
index 0000000..30fa2d5
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/cap.h
@@ -0,0 +1,63 @@
+/*****************************************************************************
+* Copyright 2009 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef CAP_H
+#define CAP_H
+
+/* ---- Include Files ---------------------------------------------------- */
+/* ---- Public Constants and Types --------------------------------------- */
+typedef enum {
+       CAP_NOT_PRESENT = 0,
+       CAP_PRESENT
+} CAP_RC_T;
+
+typedef enum {
+       CAP_VPM,
+       CAP_ETH_PHY,
+       CAP_ETH_GMII,
+       CAP_ETH_SGMII,
+       CAP_USB,
+       CAP_TSC,
+       CAP_EHSS,
+       CAP_SDIO,
+       CAP_UARTB,
+       CAP_KEYPAD,
+       CAP_CLCD,
+       CAP_GE,
+       CAP_LEDM,
+       CAP_BBL,
+       CAP_VDEC,
+       CAP_PIF,
+       CAP_APM,
+       CAP_SPU,
+       CAP_PKA,
+       CAP_RNG,
+} CAP_CAPABILITY_T;
+
+typedef enum {
+       CAP_LCD_WVGA = 0,
+       CAP_LCD_VGA = 0x1,
+       CAP_LCD_WQVGA = 0x2,
+       CAP_LCD_QVGA = 0x3
+} CAP_LCD_RES_T;
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+static inline CAP_RC_T cap_isPresent(CAP_CAPABILITY_T capability, int index);
+static inline uint32_t cap_getMaxArmSpeedHz(void);
+static inline uint32_t cap_getMaxVpmSpeedHz(void);
+static inline CAP_LCD_RES_T cap_getMaxLcdRes(void);
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h b/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
new file mode 100644
index 0000000..933ce68
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
@@ -0,0 +1,409 @@
+/*****************************************************************************
+* Copyright 2009 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef CAP_INLINE_H
+#define CAP_INLINE_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/csp/cap.h>
+#include <cfg_global.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+#define CAP_CONFIG0_VPM_DIS          0x00000001
+#define CAP_CONFIG0_ETH_PHY0_DIS     0x00000002
+#define CAP_CONFIG0_ETH_PHY1_DIS     0x00000004
+#define CAP_CONFIG0_ETH_GMII0_DIS    0x00000008
+#define CAP_CONFIG0_ETH_GMII1_DIS    0x00000010
+#define CAP_CONFIG0_ETH_SGMII0_DIS   0x00000020
+#define CAP_CONFIG0_ETH_SGMII1_DIS   0x00000040
+#define CAP_CONFIG0_USB0_DIS         0x00000080
+#define CAP_CONFIG0_USB1_DIS         0x00000100
+#define CAP_CONFIG0_TSC_DIS          0x00000200
+#define CAP_CONFIG0_EHSS0_DIS        0x00000400
+#define CAP_CONFIG0_EHSS1_DIS        0x00000800
+#define CAP_CONFIG0_SDIO0_DIS        0x00001000
+#define CAP_CONFIG0_SDIO1_DIS        0x00002000
+#define CAP_CONFIG0_UARTB_DIS        0x00004000
+#define CAP_CONFIG0_KEYPAD_DIS       0x00008000
+#define CAP_CONFIG0_CLCD_DIS         0x00010000
+#define CAP_CONFIG0_GE_DIS           0x00020000
+#define CAP_CONFIG0_LEDM_DIS         0x00040000
+#define CAP_CONFIG0_BBL_DIS          0x00080000
+#define CAP_CONFIG0_VDEC_DIS         0x00100000
+#define CAP_CONFIG0_PIF_DIS          0x00200000
+#define CAP_CONFIG0_RESERVED1_DIS    0x00400000
+#define CAP_CONFIG0_RESERVED2_DIS    0x00800000
+
+#define CAP_CONFIG1_APMA_DIS         0x00000001
+#define CAP_CONFIG1_APMB_DIS         0x00000002
+#define CAP_CONFIG1_APMC_DIS         0x00000004
+#define CAP_CONFIG1_CLCD_RES_MASK    0x00000600
+#define CAP_CONFIG1_CLCD_RES_SHIFT   9
+#define CAP_CONFIG1_CLCD_RES_WVGA    (CAP_LCD_WVGA << CAP_CONFIG1_CLCD_RES_SHIFT)
+#define CAP_CONFIG1_CLCD_RES_VGA     (CAP_LCD_VGA << CAP_CONFIG1_CLCD_RES_SHIFT)
+#define CAP_CONFIG1_CLCD_RES_WQVGA   (CAP_LCD_WQVGA << CAP_CONFIG1_CLCD_RES_SHIFT)
+#define CAP_CONFIG1_CLCD_RES_QVGA    (CAP_LCD_QVGA << CAP_CONFIG1_CLCD_RES_SHIFT)
+
+#define CAP_CONFIG2_SPU_DIS          0x00000010
+#define CAP_CONFIG2_PKA_DIS          0x00000020
+#define CAP_CONFIG2_RNG_DIS          0x00000080
+
+#if   (CFG_GLOBAL_CHIP == BCM11107)
+#define capConfig0 0
+#define capConfig1 CAP_CONFIG1_CLCD_RES_WVGA
+#define capConfig2 0
+#define CAP_APM_MAX_NUM_CHANS 3
+#elif (CFG_GLOBAL_CHIP == FPGA11107)
+#define capConfig0 0
+#define capConfig1 CAP_CONFIG1_CLCD_RES_WVGA
+#define capConfig2 0
+#define CAP_APM_MAX_NUM_CHANS 3
+#elif (CFG_GLOBAL_CHIP == BCM11109)
+#define capConfig0 (CAP_CONFIG0_USB1_DIS | CAP_CONFIG0_EHSS1_DIS | CAP_CONFIG0_SDIO1_DIS | CAP_CONFIG0_GE_DIS | CAP_CONFIG0_BBL_DIS | CAP_CONFIG0_VDEC_DIS)
+#define capConfig1 (CAP_CONFIG1_APMC_DIS | CAP_CONFIG1_CLCD_RES_WQVGA)
+#define capConfig2 (CAP_CONFIG2_SPU_DIS | CAP_CONFIG2_PKA_DIS)
+#define CAP_APM_MAX_NUM_CHANS 2
+#elif (CFG_GLOBAL_CHIP == BCM11170)
+#define capConfig0 (CAP_CONFIG0_ETH_GMII0_DIS | CAP_CONFIG0_ETH_GMII1_DIS | CAP_CONFIG0_USB0_DIS | CAP_CONFIG0_USB1_DIS | CAP_CONFIG0_TSC_DIS | CAP_CONFIG0_EHSS1_DIS | CAP_CONFIG0_SDIO0_DIS | CAP_CONFIG0_SDIO1_DIS | CAP_CONFIG0_UARTB_DIS | CAP_CONFIG0_CLCD_DIS | CAP_CONFIG0_GE_DIS | CAP_CONFIG0_BBL_DIS | CAP_CONFIG0_VDEC_DIS)
+#define capConfig1 (CAP_CONFIG1_APMC_DIS | CAP_CONFIG1_CLCD_RES_WQVGA)
+#define capConfig2 (CAP_CONFIG2_SPU_DIS | CAP_CONFIG2_PKA_DIS)
+#define CAP_APM_MAX_NUM_CHANS 2
+#elif (CFG_GLOBAL_CHIP == BCM11110)
+#define capConfig0 (CAP_CONFIG0_USB1_DIS | CAP_CONFIG0_TSC_DIS | CAP_CONFIG0_EHSS1_DIS | CAP_CONFIG0_SDIO0_DIS | CAP_CONFIG0_SDIO1_DIS | CAP_CONFIG0_UARTB_DIS | CAP_CONFIG0_GE_DIS | CAP_CONFIG0_BBL_DIS | CAP_CONFIG0_VDEC_DIS)
+#define capConfig1 CAP_CONFIG1_APMC_DIS
+#define capConfig2 (CAP_CONFIG2_SPU_DIS | CAP_CONFIG2_PKA_DIS)
+#define CAP_APM_MAX_NUM_CHANS 2
+#elif (CFG_GLOBAL_CHIP == BCM11211)
+#define capConfig0 (CAP_CONFIG0_ETH_PHY0_DIS | CAP_CONFIG0_ETH_GMII0_DIS | CAP_CONFIG0_ETH_GMII1_DIS | CAP_CONFIG0_ETH_SGMII0_DIS | CAP_CONFIG0_ETH_SGMII1_DIS | CAP_CONFIG0_CLCD_DIS)
+#define capConfig1 CAP_CONFIG1_APMC_DIS
+#define capConfig2 0
+#define CAP_APM_MAX_NUM_CHANS 2
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+
+#if   ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == FPGA11107))
+#define CAP_HW_CFG_ARM_CLK_HZ 500000000
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+#define CAP_HW_CFG_ARM_CLK_HZ 300000000
+#elif (CFG_GLOBAL_CHIP == BCM11211)
+#define CAP_HW_CFG_ARM_CLK_HZ 666666666
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+
+#if ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == BCM11211) || (CFG_GLOBAL_CHIP == FPGA11107))
+#define CAP_HW_CFG_VPM_CLK_HZ 333333333
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+#define CAP_HW_CFG_VPM_CLK_HZ 200000000
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+/****************************************************************************
+*  cap_isPresent -
+*
+*  PURPOSE:
+*     Determines if the chip has a certain capability present
+*
+*  PARAMETERS:
+*     capability - type of capability to determine if present
+*
+*  RETURNS:
+*     CAP_PRESENT or CAP_NOT_PRESENT
+****************************************************************************/
+static inline CAP_RC_T cap_isPresent(CAP_CAPABILITY_T capability, int index)
+{
+       CAP_RC_T returnVal = CAP_NOT_PRESENT;
+
+       switch (capability) {
+       case CAP_VPM:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_VPM_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_ETH_PHY:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_PHY0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_PHY1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_ETH_GMII:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_GMII0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_GMII1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_ETH_SGMII:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_SGMII0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_ETH_SGMII1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_USB:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_USB0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_USB1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_TSC:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_TSC_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_EHSS:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_EHSS0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_EHSS1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_SDIO:
+               {
+                       if ((index == 0)
+                           && (!(capConfig0 & CAP_CONFIG0_SDIO0_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig0 & CAP_CONFIG0_SDIO1_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_UARTB:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_UARTB_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_KEYPAD:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_KEYPAD_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_CLCD:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_CLCD_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_GE:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_GE_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_LEDM:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_LEDM_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_BBL:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_BBL_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_VDEC:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_VDEC_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_PIF:
+               {
+                       if (!(capConfig0 & CAP_CONFIG0_PIF_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_APM:
+               {
+                       if ((index == 0)
+                           && (!(capConfig1 & CAP_CONFIG1_APMA_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 1)
+                           && (!(capConfig1 & CAP_CONFIG1_APMB_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+                       if ((index == 2)
+                           && (!(capConfig1 & CAP_CONFIG1_APMC_DIS))) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_SPU:
+               {
+                       if (!(capConfig2 & CAP_CONFIG2_SPU_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_PKA:
+               {
+                       if (!(capConfig2 & CAP_CONFIG2_PKA_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       case CAP_RNG:
+               {
+                       if (!(capConfig2 & CAP_CONFIG2_RNG_DIS)) {
+                               returnVal = CAP_PRESENT;
+                       }
+               }
+               break;
+
+       default:
+               {
+               }
+               break;
+       }
+       return returnVal;
+}
+
+/****************************************************************************
+*  cap_getMaxArmSpeedHz -
+*
+*  PURPOSE:
+*     Determines the maximum speed of the ARM CPU
+*
+*  PARAMETERS:
+*     none
+*
+*  RETURNS:
+*     clock speed in Hz that the ARM processor is able to run at
+****************************************************************************/
+static inline uint32_t cap_getMaxArmSpeedHz(void)
+{
+#if   ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == FPGA11107))
+       return 500000000;
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+       return 300000000;
+#elif (CFG_GLOBAL_CHIP == BCM11211)
+       return 666666666;
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+}
+
+/****************************************************************************
+*  cap_getMaxVpmSpeedHz -
+*
+*  PURPOSE:
+*     Determines the maximum speed of the VPM
+*
+*  PARAMETERS:
+*     none
+*
+*  RETURNS:
+*     clock speed in Hz that the VPM is able to run at
+****************************************************************************/
+static inline uint32_t cap_getMaxVpmSpeedHz(void)
+{
+#if ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == BCM11211) || (CFG_GLOBAL_CHIP == FPGA11107))
+       return 333333333;
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+       return 200000000;
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+}
+
+/****************************************************************************
+*  cap_getMaxLcdRes -
+*
+*  PURPOSE:
+*     Determines the maximum LCD resolution capabilities
+*
+*  PARAMETERS:
+*     none
+*
+*  RETURNS:
+*   CAP_LCD_WVGA, CAP_LCD_VGA, CAP_LCD_WQVGA or CAP_LCD_QVGA
+*
+****************************************************************************/
+static inline CAP_LCD_RES_T cap_getMaxLcdRes(void)
+{
+       return (CAP_LCD_RES_T)
+               ((capConfig1 & CAP_CONFIG1_CLCD_RES_MASK) >>
+                CAP_CONFIG1_CLCD_RES_SHIFT);
+}
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
new file mode 100644
index 0000000..70eaea8
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
@@ -0,0 +1,1123 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef CHIPC_DEF_H
+#define CHIPC_DEF_H
+
+/* ---- Include Files ----------------------------------------------------- */
+
+#include <csp/stdint.h>
+#include <csp/errno.h>
+#include <csp/reg.h>
+#include <mach/csp/chipcHw_reg.h>
+
+/* ---- Public Constants and Types ---------------------------------------- */
+
+/* Set 1 to configure DDR/VPM phase alignment by HW */
+#define chipcHw_DDR_HW_PHASE_ALIGN    0
+#define chipcHw_VPM_HW_PHASE_ALIGN    0
+
+typedef uint32_t chipcHw_freq;
+
+/* Configurable miscellaneous clocks */
+typedef enum {
+       chipcHw_CLOCK_DDR,      /* DDR PHY Clock */
+       chipcHw_CLOCK_ARM,      /* ARM Clock */
+       chipcHw_CLOCK_ESW,      /* Ethernet Switch Clock */
+       chipcHw_CLOCK_VPM,      /* VPM Clock */
+       chipcHw_CLOCK_ESW125,   /* Ethernet MII Clock */
+       chipcHw_CLOCK_UART,     /* UART Clock */
+       chipcHw_CLOCK_SDIO0,    /* SDIO 0 Clock */
+       chipcHw_CLOCK_SDIO1,    /* SDIO 1 Clock */
+       chipcHw_CLOCK_SPI,      /* SPI Clock */
+       chipcHw_CLOCK_ETM,      /* ARM ETM Clock */
+
+       chipcHw_CLOCK_BUS,      /* BUS Clock */
+       chipcHw_CLOCK_OTP,      /* OTP Clock */
+       chipcHw_CLOCK_I2C,      /* I2C Host Clock */
+       chipcHw_CLOCK_I2S0,     /* I2S 0 Host Clock */
+       chipcHw_CLOCK_RTBUS,    /* DDR PHY Configuration Clock */
+       chipcHw_CLOCK_APM100,   /* APM100 Clock */
+       chipcHw_CLOCK_TSC,      /* Touch screen Clock */
+       chipcHw_CLOCK_LED,      /* LED Clock */
+
+       chipcHw_CLOCK_USB,      /* USB Clock */
+       chipcHw_CLOCK_LCD,      /* LCD CLock */
+       chipcHw_CLOCK_APM,      /* APM Clock */
+
+       chipcHw_CLOCK_I2S1,     /* I2S 1 Host Clock */
+} chipcHw_CLOCK_e;
+
+/* System booting strap options */
+typedef enum {
+       chipcHw_BOOT_DEVICE_UART = chipcHw_STRAPS_BOOT_DEVICE_UART,
+       chipcHw_BOOT_DEVICE_SERIAL_FLASH =
+           chipcHw_STRAPS_BOOT_DEVICE_SERIAL_FLASH,
+       chipcHw_BOOT_DEVICE_NOR_FLASH_16 =
+           chipcHw_STRAPS_BOOT_DEVICE_NOR_FLASH_16,
+       chipcHw_BOOT_DEVICE_NAND_FLASH_8 =
+           chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_8,
+       chipcHw_BOOT_DEVICE_NAND_FLASH_16 =
+           chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_16
+} chipcHw_BOOT_DEVICE_e;
+
+/* System booting modes */
+typedef enum {
+       chipcHw_BOOT_MODE_NORMAL = chipcHw_STRAPS_BOOT_MODE_NORMAL,
+       chipcHw_BOOT_MODE_DBG_SW = chipcHw_STRAPS_BOOT_MODE_DBG_SW,
+       chipcHw_BOOT_MODE_DBG_BOOT = chipcHw_STRAPS_BOOT_MODE_DBG_BOOT,
+       chipcHw_BOOT_MODE_NORMAL_QUIET = chipcHw_STRAPS_BOOT_MODE_NORMAL_QUIET
+} chipcHw_BOOT_MODE_e;
+
+/* NAND Flash page size strap options */
+typedef enum {
+       chipcHw_NAND_PAGESIZE_512 = chipcHw_STRAPS_NAND_PAGESIZE_512,
+       chipcHw_NAND_PAGESIZE_2048 = chipcHw_STRAPS_NAND_PAGESIZE_2048,
+       chipcHw_NAND_PAGESIZE_4096 = chipcHw_STRAPS_NAND_PAGESIZE_4096,
+       chipcHw_NAND_PAGESIZE_EXT = chipcHw_STRAPS_NAND_PAGESIZE_EXT
+} chipcHw_NAND_PAGESIZE_e;
+
+/* GPIO Pin function */
+typedef enum {
+       chipcHw_GPIO_FUNCTION_KEYPAD = chipcHw_REG_GPIO_MUX_KEYPAD,
+       chipcHw_GPIO_FUNCTION_I2CH = chipcHw_REG_GPIO_MUX_I2CH,
+       chipcHw_GPIO_FUNCTION_SPI = chipcHw_REG_GPIO_MUX_SPI,
+       chipcHw_GPIO_FUNCTION_UART = chipcHw_REG_GPIO_MUX_UART,
+       chipcHw_GPIO_FUNCTION_LEDMTXP = chipcHw_REG_GPIO_MUX_LEDMTXP,
+       chipcHw_GPIO_FUNCTION_LEDMTXS = chipcHw_REG_GPIO_MUX_LEDMTXS,
+       chipcHw_GPIO_FUNCTION_SDIO0 = chipcHw_REG_GPIO_MUX_SDIO0,
+       chipcHw_GPIO_FUNCTION_SDIO1 = chipcHw_REG_GPIO_MUX_SDIO1,
+       chipcHw_GPIO_FUNCTION_PCM = chipcHw_REG_GPIO_MUX_PCM,
+       chipcHw_GPIO_FUNCTION_I2S = chipcHw_REG_GPIO_MUX_I2S,
+       chipcHw_GPIO_FUNCTION_ETM = chipcHw_REG_GPIO_MUX_ETM,
+       chipcHw_GPIO_FUNCTION_DEBUG = chipcHw_REG_GPIO_MUX_DEBUG,
+       chipcHw_GPIO_FUNCTION_MISC = chipcHw_REG_GPIO_MUX_MISC,
+       chipcHw_GPIO_FUNCTION_GPIO = chipcHw_REG_GPIO_MUX_GPIO
+} chipcHw_GPIO_FUNCTION_e;
+
+/* PIN Output slew rate */
+typedef enum {
+       chipcHw_PIN_SLEW_RATE_HIGH = chipcHw_REG_SLEW_RATE_HIGH,
+       chipcHw_PIN_SLEW_RATE_NORMAL = chipcHw_REG_SLEW_RATE_NORMAL
+} chipcHw_PIN_SLEW_RATE_e;
+
+/* PIN Current drive strength */
+typedef enum {
+       chipcHw_PIN_CURRENT_STRENGTH_2mA = chipcHw_REG_CURRENT_STRENGTH_2mA,
+       chipcHw_PIN_CURRENT_STRENGTH_4mA = chipcHw_REG_CURRENT_STRENGTH_4mA,
+       chipcHw_PIN_CURRENT_STRENGTH_6mA = chipcHw_REG_CURRENT_STRENGTH_6mA,
+       chipcHw_PIN_CURRENT_STRENGTH_8mA = chipcHw_REG_CURRENT_STRENGTH_8mA,
+       chipcHw_PIN_CURRENT_STRENGTH_10mA = chipcHw_REG_CURRENT_STRENGTH_10mA,
+       chipcHw_PIN_CURRENT_STRENGTH_12mA = chipcHw_REG_CURRENT_STRENGTH_12mA
+} chipcHw_PIN_CURRENT_STRENGTH_e;
+
+/* PIN Pull up register settings */
+typedef enum {
+       chipcHw_PIN_PULL_NONE = chipcHw_REG_PULL_NONE,
+       chipcHw_PIN_PULL_UP = chipcHw_REG_PULL_UP,
+       chipcHw_PIN_PULL_DOWN = chipcHw_REG_PULL_DOWN
+} chipcHw_PIN_PULL_e;
+
+/* PIN input type settings */
+typedef enum {
+       chipcHw_PIN_INPUTTYPE_CMOS = chipcHw_REG_INPUTTYPE_CMOS,
+       chipcHw_PIN_INPUTTYPE_ST = chipcHw_REG_INPUTTYPE_ST
+} chipcHw_PIN_INPUTTYPE_e;
+
+/* Allow/Disalow the support of spread spectrum  */
+typedef enum {
+       chipcHw_SPREAD_SPECTRUM_DISALLOW,       /* Spread spectrum support is not allowed */
+       chipcHw_SPREAD_SPECTRUM_ALLOW   /* Spread spectrum support is allowed */
+} chipcHw_SPREAD_SPECTRUM_e;
+
+typedef struct {
+       chipcHw_SPREAD_SPECTRUM_e ssSupport;    /* Allow/Disalow to support spread spectrum.
+                                                  If supported, call chipcHw_enableSpreadSpectrum ()
+                                                  to activate the spread spectrum with desired spread. */
+       uint32_t pllVcoFreqHz;  /* PLL VCO frequency in Hz */
+       uint32_t pll2VcoFreqHz; /* PLL2 VCO frequency in Hz */
+       uint32_t busClockFreqHz;        /* Bus clock frequency in Hz */
+       uint32_t armBusRatio;   /* ARM clock : Bus clock */
+       uint32_t vpmBusRatio;   /* VPM clock : Bus clock */
+       uint32_t ddrBusRatio;   /* DDR clock : Bus clock */
+} chipcHw_INIT_PARAM_t;
+
+/* CHIP revision number */
+typedef enum {
+       chipcHw_REV_NUMBER_A0 = chipcHw_REG_REV_A0,
+       chipcHw_REV_NUMBER_B0 = chipcHw_REG_REV_B0
+} chipcHw_REV_NUMBER_e;
+
+typedef enum {
+       chipcHw_VPM_HW_PHASE_INTR_DISABLE = chipcHw_REG_VPM_INTR_DISABLE,
+       chipcHw_VPM_HW_PHASE_INTR_FAST = chipcHw_REG_VPM_INTR_FAST,
+       chipcHw_VPM_HW_PHASE_INTR_MEDIUM = chipcHw_REG_VPM_INTR_MEDIUM,
+       chipcHw_VPM_HW_PHASE_INTR_SLOW = chipcHw_REG_VPM_INTR_SLOW
+} chipcHw_VPM_HW_PHASE_INTR_e;
+
+typedef enum {
+       chipcHw_DDR_HW_PHASE_MARGIN_STRICT,     /*  Strict margin for DDR phase align condition */
+       chipcHw_DDR_HW_PHASE_MARGIN_MEDIUM,     /*  Medium margin for DDR phase align condition */
+       chipcHw_DDR_HW_PHASE_MARGIN_WIDE        /*  Wider margin for DDR phase align condition */
+} chipcHw_DDR_HW_PHASE_MARGIN_e;
+
+typedef enum {
+       chipcHw_VPM_HW_PHASE_MARGIN_STRICT,     /*  Strict margin for VPM phase align condition */
+       chipcHw_VPM_HW_PHASE_MARGIN_MEDIUM,     /*  Medium margin for VPM phase align condition */
+       chipcHw_VPM_HW_PHASE_MARGIN_WIDE        /*  Wider margin for VPM phase align condition */
+} chipcHw_VPM_HW_PHASE_MARGIN_e;
+
+#define chipcHw_XTAL_FREQ_Hz                    25000000       /* Reference clock frequency in Hz */
+
+/* Programable pin defines */
+#define chipcHw_PIN_GPIO(n)                     ((((n) >= 0) && ((n) < (chipcHw_GPIO_COUNT))) ? (n) : 0xFFFFFFFF)
+                                                                            /* GPIO pin 0 - 60 */
+#define chipcHw_PIN_UARTTXD                     (chipcHw_GPIO_COUNT + 0)       /* UART Transmit */
+#define chipcHw_PIN_NVI_A                       (chipcHw_GPIO_COUNT + 1)       /* NVI Interface */
+#define chipcHw_PIN_NVI_D                       (chipcHw_GPIO_COUNT + 2)       /* NVI Interface */
+#define chipcHw_PIN_NVI_OEB                     (chipcHw_GPIO_COUNT + 3)       /* NVI Interface */
+#define chipcHw_PIN_NVI_WEB                     (chipcHw_GPIO_COUNT + 4)       /* NVI Interface */
+#define chipcHw_PIN_NVI_CS                      (chipcHw_GPIO_COUNT + 5)       /* NVI Interface */
+#define chipcHw_PIN_NVI_NAND_CSB                (chipcHw_GPIO_COUNT + 6)       /* NVI Interface */
+#define chipcHw_PIN_NVI_FLASHWP                 (chipcHw_GPIO_COUNT + 7)       /* NVI Interface */
+#define chipcHw_PIN_NVI_NAND_RDYB               (chipcHw_GPIO_COUNT + 8)       /* NVI Interface */
+#define chipcHw_PIN_CL_DATA_0_17                (chipcHw_GPIO_COUNT + 9)       /* LCD Data 0 - 17 */
+#define chipcHw_PIN_CL_DATA_18_20               (chipcHw_GPIO_COUNT + 10)      /* LCD Data 18 - 20 */
+#define chipcHw_PIN_CL_DATA_21_23               (chipcHw_GPIO_COUNT + 11)      /* LCD Data 21 - 23 */
+#define chipcHw_PIN_CL_POWER                    (chipcHw_GPIO_COUNT + 12)      /* LCD Power */
+#define chipcHw_PIN_CL_ACK                      (chipcHw_GPIO_COUNT + 13)      /* LCD Ack */
+#define chipcHw_PIN_CL_FP                       (chipcHw_GPIO_COUNT + 14)      /* LCD FP */
+#define chipcHw_PIN_CL_LP                       (chipcHw_GPIO_COUNT + 15)      /* LCD LP */
+#define chipcHw_PIN_UARTRXD                     (chipcHw_GPIO_COUNT + 16)      /* UART Receive */
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the clock module
+*
+*/
+/****************************************************************************/
+void chipcHw_Init(chipcHw_INIT_PARAM_t *initParam      /*  [ IN ] Misc chip initialization parameter */
+    ) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief  Enables the PLL1
+*
+*  This function enables the PLL1
+*
+*/
+/****************************************************************************/
+void chipcHw_pll1Enable(uint32_t vcoFreqHz,    /*  [ IN ] VCO frequency in Hz */
+                       chipcHw_SPREAD_SPECTRUM_e ssSupport     /*  [ IN ] SS status */
+    ) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief  Enables the PLL2
+*
+*  This function enables the PLL2
+*
+*/
+/****************************************************************************/
+void chipcHw_pll2Enable(uint32_t vcoFreqHz     /*  [ IN ] VCO frequency in Hz */
+    ) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL1
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll1Disable(void);
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL2
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll2Disable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Set clock fequency for miscellaneous configurable clocks
+*
+*  This function sets clock frequency
+*
+*  @return  Configured clock frequency in KHz
+*
+*/
+/****************************************************************************/
+chipcHw_freq chipcHw_getClockFrequency(chipcHw_CLOCK_e clock   /*  [ IN ] Configurable clock */
+    ) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief   Set clock fequency for miscellaneous configurable clocks
+*
+*  This function sets clock frequency
+*
+*  @return  Configured clock frequency in Hz
+*
+*/
+/****************************************************************************/
+chipcHw_freq chipcHw_setClockFrequency(chipcHw_CLOCK_e clock,  /*  [ IN ] Configurable clock */
+                                      uint32_t freq    /*  [ IN ] Clock frequency in Hz */
+    ) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM clock in sync with BUS clock
+*
+*  This function does the phase adjustment between VPM and BUS clock
+*
+*  @return >= 0 : On success ( # of adjustment required )
+*            -1 : On failure
+*/
+/****************************************************************************/
+int chipcHw_vpmPhaseAlign(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enables core a clock of a certain device
+*
+*  This function enables a core clock
+*
+*  @return  void
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_setClockEnable(chipcHw_CLOCK_e clock        /*  [ IN ] Configurable clock */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Disabled a core clock of a certain device
+*
+*  This function disables a core clock
+*
+*  @return  void
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_setClockDisable(chipcHw_CLOCK_e clock       /*  [ IN ] Configurable clock */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Enables bypass clock of a certain device
+*
+*  This function enables bypass clock
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_bypassClockEnable(chipcHw_CLOCK_e clock     /*  [ IN ] Configurable clock */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Disabled bypass clock of a certain device
+*
+*  This function disables bypass clock
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_bypassClockDisable(chipcHw_CLOCK_e clock    /*  [ IN ] Configurable clock */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Get Numeric Chip ID
+*
+*  This function returns Chip ID that includes the revison number
+*
+*  @return  Complete numeric Chip ID
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getChipId(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get Chip Product ID
+*
+*  This function returns Chip Product ID
+*
+*  @return  Chip Product ID
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getChipProductId(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get revision number
+*
+*  This function returns revision number of the chip
+*
+*  @return  Revision number
+*/
+/****************************************************************************/
+static inline chipcHw_REV_NUMBER_e chipcHw_getChipRevisionNumber(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enables bus interface clock
+*
+*  Enables  bus interface clock of various device
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_BUS_CLOCK_XXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_busInterfaceClockEnable(uint32_t mask       /*  [ IN ] Bit map of type  chipcHw_REG_BUS_CLOCK_XXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Disables bus interface clock
+*
+*  Disables  bus interface clock of various device
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_BUS_CLOCK_XXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_busInterfaceClockDisable(uint32_t mask      /*  [ IN ] Bit map of type  chipcHw_REG_BUS_CLOCK_XXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Enables various audio channels
+*
+*  Enables audio channel
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_audioChannelEnable(uint32_t mask    /*  [ IN ] Bit map of type  chipcHw_REG_AUDIO_CHANNEL_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Disables various audio channels
+*
+*  Disables audio channel
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_audioChannelDisable(uint32_t mask   /*  [ IN ] Bit map of type  chipcHw_REG_AUDIO_CHANNEL_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Soft resets devices
+*
+*  Soft resets various devices
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_SOFT_RESET_XXXXXX defines
+*/
+/****************************************************************************/
+static inline void chipcHw_softReset(uint64_t mask     /*  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX */
+    );
+
+static inline void chipcHw_softResetDisable(uint64_t mask      /*  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX */
+    );
+
+static inline void chipcHw_softResetEnable(uint64_t mask       /*  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Configures misc CHIP functionality
+*
+*  Configures CHIP functionality
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_MISC_CTRL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_miscControl(uint32_t mask   /*  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX */
+    );
+
+static inline void chipcHw_miscControlDisable(uint32_t mask    /*  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX */
+    );
+
+static inline void chipcHw_miscControlEnable(uint32_t mask     /*  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Set OTP options
+*
+*  Set OTP options
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_OTP_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_setOTPOption(uint64_t mask  /*  [ IN ] Bit map of type chipcHw_REG_OTP_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Get sticky bits
+*
+*  @return   Sticky bit options of type chipcHw_REG_STICKY_XXXXXX
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getStickyBits(void);
+
+/****************************************************************************/
+/**
+*  @brief    Set sticky bits
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_STICKY_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_setStickyBits(uint32_t mask /*  [ IN ] Bit map of type chipcHw_REG_STICKY_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Clear sticky bits
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_STICKY_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_clearStickyBits(uint32_t mask       /*  [ IN ] Bit map of type chipcHw_REG_STICKY_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief    Get software override strap options
+*
+*  Retrieves software override strap options
+*
+*  @return   Software override strap value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getSoftStraps(void);
+
+/****************************************************************************/
+/**
+*  @brief    Set software override strap options
+*
+*  set software override strap options
+*
+*  @return   nothing
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setSoftStraps(uint32_t strapOptions);
+
+/****************************************************************************/
+/**
+*  @brief    Get pin strap options
+*
+*  Retrieves pin strap options
+*
+*  @return   Pin strap value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getPinStraps(void);
+
+/****************************************************************************/
+/**
+*  @brief    Get valid pin strap options
+*
+*  Retrieves valid pin strap options
+*
+*  @return   valid Pin strap value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getValidStraps(void);
+
+/****************************************************************************/
+/**
+*  @brief    Initialize valid pin strap options
+*
+*  Retrieves valid pin strap options by copying HW strap options to soft register
+*  (if chipcHw_STRAPS_SOFT_OVERRIDE not set)
+*
+*  @return   nothing
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_initValidStraps(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get status (enabled/disabled) of bus interface clock
+*
+*  This function returns the status of devices' bus interface clock
+*
+*  @return  Bus interface clock
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getBusInterfaceClockStatus(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get boot device
+*
+*  This function returns the device type used in booting the system
+*
+*  @return  Boot device of type chipcHw_BOOT_DEVICE_e
+*
+*/
+/****************************************************************************/
+static inline chipcHw_BOOT_DEVICE_e chipcHw_getBootDevice(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get boot mode
+*
+*  This function returns the way the system was booted
+*
+*  @return  Boot mode of type chipcHw_BOOT_MODE_e
+*
+*/
+/****************************************************************************/
+static inline chipcHw_BOOT_MODE_e chipcHw_getBootMode(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get NAND flash page size
+*
+*  This function returns the NAND device page size
+*
+*  @return  Boot NAND device page size
+*
+*/
+/****************************************************************************/
+static inline chipcHw_NAND_PAGESIZE_e chipcHw_getNandPageSize(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get NAND flash address cycle configuration
+*
+*  This function returns the NAND flash address cycle configuration
+*
+*  @return  0 = Do not extra address cycle, 1 = Add extra cycle
+*
+*/
+/****************************************************************************/
+static inline int chipcHw_getNandExtraCycle(void);
+
+/****************************************************************************/
+/**
+*  @brief   Activates PIF interface
+*
+*  This function activates PIF interface by taking control of LCD pins
+*
+*  @note
+*       When activated, LCD pins will be defined as follows for PIF operation
+*
+*       CLD[17:0]  = pif_data[17:0]
+*       CLD[23:18] = pif_address[5:0]
+*       CLPOWER    = pif_wr_str
+*       CLCP       = pif_rd_str
+*       CLAC       = pif_hat1
+*       CLFP       = pif_hrdy1
+*       CLLP       = pif_hat2
+*       GPIO[42]   = pif_hrdy2
+*
+*       In PIF mode, "pif_hrdy2" overrides other shared function for GPIO[42] pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_activatePifInterface(void);
+
+/****************************************************************************/
+/**
+*  @brief   Activates LCD interface
+*
+*  This function activates LCD interface
+*
+*  @note
+*       When activated, LCD pins will be defined as follows
+*
+*       CLD[17:0]  = LCD data
+*       CLD[23:18] = LCD data
+*       CLPOWER    = LCD power
+*       CLCP       =
+*       CLAC       = LCD ack
+*       CLFP       =
+*       CLLP       =
+*/
+/****************************************************************************/
+static inline void chipcHw_activateLcdInterface(void);
+
+/****************************************************************************/
+/**
+*  @brief   Deactivates PIF/LCD interface
+*
+*  This function deactivates PIF/LCD interface
+*
+*  @note
+*       When deactivated LCD pins will be in rti-stated
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_deactivatePifLcdInterface(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get to know the configuration of GPIO pin
+*
+*/
+/****************************************************************************/
+static inline chipcHw_GPIO_FUNCTION_e chipcHw_getGpioPinFunction(int pin       /* GPIO Pin number */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Configure GPIO pin function
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setGpioPinFunction(int pin, /* GPIO Pin number */
+                                             chipcHw_GPIO_FUNCTION_e func      /* Configuration function */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin slew rate
+*
+*  This function sets the slew of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinSlewRate(uint32_t pin,        /* Pin of type chipcHw_PIN_XXXXX */
+                                         chipcHw_PIN_SLEW_RATE_e slewRate      /* Pin slew rate */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin output drive current
+*
+*  This function sets output drive current of individual pin
+*
+*  Note: Avoid the use of the word 'current' since linux headers define this
+*        to be the current task.
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinOutputCurrent(uint32_t pin,   /* Pin of type chipcHw_PIN_XXXXX */
+                                              chipcHw_PIN_CURRENT_STRENGTH_e curr      /* Pin current rating */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin pullup register
+*
+*  This function sets pullup register of individual  pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinPullup(uint32_t pin,  /* Pin of type chipcHw_PIN_XXXXX */
+                                       chipcHw_PIN_PULL_e pullup       /* Pullup register settings */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin input type
+*
+*  This function sets input type of individual Pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinInputType(uint32_t pin,       /* Pin of type chipcHw_PIN_XXXXX */
+                                          chipcHw_PIN_INPUTTYPE_e inputType    /* Pin input type */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Retrieves a string representation of the mux setting for a pin.
+*
+*  @return  Pointer to a character string.
+*/
+/****************************************************************************/
+
+const char *chipcHw_getGpioPinFunctionStr(int pin);
+
+/****************************************************************************/
+/**  @brief issue warmReset
+ */
+/****************************************************************************/
+void chipcHw_reset(uint32_t mask);
+
+/****************************************************************************/
+/**  @brief clock reconfigure
+ */
+/****************************************************************************/
+void chipcHw_clockReconfig(uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio,
+                          uint32_t ddrRatio);
+
+/****************************************************************************/
+/**
+*  @brief   Enable Spread Spectrum
+*
+*  @note chipcHw_Init() must be called earlier
+*/
+/****************************************************************************/
+static inline void chipcHw_enableSpreadSpectrum(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disable Spread Spectrum
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_disableSpreadSpectrum(void);
+
+/****************************************************************************/
+/**  @brief Checks if software strap is enabled
+ *
+ *   @return 1 : When enable
+ *           0 : When disable
+ */
+/****************************************************************************/
+static inline int chipcHw_isSoftwareStrapsEnable(void);
+
+/****************************************************************************/
+/**  @brief Enable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsEnable(void);
+
+/****************************************************************************/
+/**  @brief Disable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsDisable(void);
+
+/****************************************************************************/
+/**  @brief PLL test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestEnable(void);
+
+/****************************************************************************/
+/**  @brief PLL2 test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestEnable(void);
+
+/****************************************************************************/
+/**  @brief PLL test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestDisable(void);
+
+/****************************************************************************/
+/**  @brief PLL2 test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestDisable(void);
+
+/****************************************************************************/
+/**  @brief Get PLL test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPllTestEnable(void);
+
+/****************************************************************************/
+/**  @brief Get PLL2 test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPll2TestEnable(void);
+
+/****************************************************************************/
+/**  @brief PLL test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestSelect(uint32_t val);
+
+/****************************************************************************/
+/**  @brief PLL2 test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestSelect(uint32_t val);
+
+/****************************************************************************/
+/**  @brief Get PLL test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPllTestSelected(void);
+
+/****************************************************************************/
+/**  @brief Get PLL2 test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPll2TestSelected(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM SW phase alignment interrupt mode
+*
+*  This function sets VPM phase alignment interrupt
+*
+*/
+/****************************************************************************/
+static inline void
+chipcHw_vpmPhaseAlignInterruptMode(chipcHw_VPM_HW_PHASE_INTR_e mode);
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Set DDR phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setDdrHwPhaseAlignMargin(chipcHw_DDR_HW_PHASE_MARGIN_e margin       /* Margin alinging DDR  phase */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setVpmHwPhaseAlignMargin(chipcHw_VPM_HW_PHASE_MARGIN_e margin       /* Margin alinging VPM  phase */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Checks DDR phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isDdrHwPhaseAligned(void);
+
+/****************************************************************************/
+/**
+*  @brief   Checks VPM phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isVpmHwPhaseAligned(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrHwPhaseAlignStatus(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmHwPhaseAlignStatus(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrPhaseControl(void);
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmPhaseControl(void);
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a DDR phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeout(uint32_t busCycle    /* Timeout in bus cycle */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a VPM phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeout(uint32_t busCycle    /* Timeout in bus cycle */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptEnable(void);
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptDisable(void);
+
+/****************************************************************************/
+/**
+*  @brief   Clear DDR phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptClear(void);
+
+/****************************************************************************/
+/**
+*  @brief   Clear VPM phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptClear(void);
+
+/* ---- Private Constants and Types -------------------------------------- */
+
+#endif /* CHIPC_DEF_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
new file mode 100644
index 0000000..c78833a
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
@@ -0,0 +1,1673 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef CHIPC_INLINE_H
+#define CHIPC_INLINE_H
+
+/* ---- Include Files ----------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/reg.h>
+#include <mach/csp/chipcHw_reg.h>
+#include <mach/csp/chipcHw_def.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+typedef enum {
+       chipcHw_OPTYPE_BYPASS,  /* Bypass operation */
+       chipcHw_OPTYPE_OUTPUT   /* Output operation */
+} chipcHw_OPTYPE_e;
+
+/* ---- Public Constants and Types ---------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------- */
+/* ---- Public Function Prototypes ---------------------------------------- */
+/* ---- Private Function Prototypes --------------------------------------- */
+static inline void chipcHw_setClock(chipcHw_CLOCK_e clock,
+                                   chipcHw_OPTYPE_e type, int mode);
+
+/****************************************************************************/
+/**
+*  @brief   Get Numeric Chip ID
+*
+*  This function returns Chip ID that includes the revison number
+*
+*  @return  Complete numeric Chip ID
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getChipId(void)
+{
+       return pChipcHw->ChipId;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable Spread Spectrum
+*
+*  @note chipcHw_Init() must be called earlier
+*/
+/****************************************************************************/
+static inline void chipcHw_enableSpreadSpectrum(void)
+{
+       if ((pChipcHw->
+            PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK) !=
+           chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER) {
+               ddrcReg_PHY_ADDR_CTL_REGP->ssCfg =
+                   (0xFFFF << ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_SHIFT) |
+                   (ddrcReg_PHY_ADDR_SS_CFG_MIN_CYCLE_PER_TICK <<
+                    ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_SHIFT);
+               ddrcReg_PHY_ADDR_CTL_REGP->ssCtl |=
+                   ddrcReg_PHY_ADDR_SS_CTRL_ENABLE;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable Spread Spectrum
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_disableSpreadSpectrum(void)
+{
+       ddrcReg_PHY_ADDR_CTL_REGP->ssCtl &= ~ddrcReg_PHY_ADDR_SS_CTRL_ENABLE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get Chip Product ID
+*
+*  This function returns Chip Product ID
+*
+*  @return  Chip Product ID
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getChipProductId(void)
+{
+       return (pChipcHw->
+                ChipId & chipcHw_REG_CHIPID_BASE_MASK) >>
+               chipcHw_REG_CHIPID_BASE_SHIFT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get revision number
+*
+*  This function returns revision number of the chip
+*
+*  @return  Revision number
+*/
+/****************************************************************************/
+static inline chipcHw_REV_NUMBER_e chipcHw_getChipRevisionNumber(void)
+{
+       return pChipcHw->ChipId & chipcHw_REG_CHIPID_REV_MASK;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables bus interface clock
+*
+*  Enables  bus interface clock of various device
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_BUS_CLOCK_XXXX for mask
+*/
+/****************************************************************************/
+static inline void chipcHw_busInterfaceClockEnable(uint32_t mask)
+{
+       reg32_modify_or(&pChipcHw->BusIntfClock, mask);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disables bus interface clock
+*
+*  Disables  bus interface clock of various device
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_BUS_CLOCK_XXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_busInterfaceClockDisable(uint32_t mask)
+{
+       reg32_modify_and(&pChipcHw->BusIntfClock, ~mask);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get status (enabled/disabled) of bus interface clock
+*
+*  This function returns the status of devices' bus interface clock
+*
+*  @return  Bus interface clock
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getBusInterfaceClockStatus(void)
+{
+       return pChipcHw->BusIntfClock;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables various audio channels
+*
+*  Enables audio channel
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_audioChannelEnable(uint32_t mask)
+{
+       reg32_modify_or(&pChipcHw->AudioEnable, mask);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disables various audio channels
+*
+*  Disables audio channel
+*
+*  @return  void
+*
+*  @note    use chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_audioChannelDisable(uint32_t mask)
+{
+       reg32_modify_and(&pChipcHw->AudioEnable, ~mask);
+}
+
+/****************************************************************************/
+/**
+*  @brief    Soft resets devices
+*
+*  Soft resets various devices
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_SOFT_RESET_XXXXXX defines
+*/
+/****************************************************************************/
+static inline void chipcHw_softReset(uint64_t mask)
+{
+       chipcHw_softResetEnable(mask);
+       chipcHw_softResetDisable(mask);
+}
+
+static inline void chipcHw_softResetDisable(uint64_t mask)
+{
+       uint32_t ctrl1 = (uint32_t) mask;
+       uint32_t ctrl2 = (uint32_t) (mask >> 32);
+
+       /* Deassert module soft reset */
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->SoftReset1 ^= ctrl1;
+       pChipcHw->SoftReset2 ^= (ctrl2 & (~chipcHw_REG_SOFT_RESET_UNHOLD_MASK));
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void chipcHw_softResetEnable(uint64_t mask)
+{
+       uint32_t ctrl1 = (uint32_t) mask;
+       uint32_t ctrl2 = (uint32_t) (mask >> 32);
+       uint32_t unhold = 0;
+
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->SoftReset1 |= ctrl1;
+       /* Mask out unhold request bits */
+       pChipcHw->SoftReset2 |= (ctrl2 & (~chipcHw_REG_SOFT_RESET_UNHOLD_MASK));
+
+       /* Process unhold requests */
+       if (ctrl2 & chipcHw_REG_SOFT_RESET_VPM_GLOBAL_UNHOLD) {
+               unhold = chipcHw_REG_SOFT_RESET_VPM_GLOBAL_HOLD;
+       }
+
+       if (ctrl2 & chipcHw_REG_SOFT_RESET_VPM_UNHOLD) {
+               unhold |= chipcHw_REG_SOFT_RESET_VPM_HOLD;
+       }
+
+       if (ctrl2 & chipcHw_REG_SOFT_RESET_ARM_UNHOLD) {
+               unhold |= chipcHw_REG_SOFT_RESET_ARM_HOLD;
+       }
+
+       if (unhold) {
+               /* Make sure unhold request is effective */
+               pChipcHw->SoftReset1 &= ~unhold;
+       }
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Configures misc CHIP functionality
+*
+*  Configures CHIP functionality
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_MISC_CTRL_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_miscControl(uint32_t mask)
+{
+       reg32_write(&pChipcHw->MiscCtrl, mask);
+}
+
+static inline void chipcHw_miscControlDisable(uint32_t mask)
+{
+       reg32_modify_and(&pChipcHw->MiscCtrl, ~mask);
+}
+
+static inline void chipcHw_miscControlEnable(uint32_t mask)
+{
+       reg32_modify_or(&pChipcHw->MiscCtrl, mask);
+}
+
+/****************************************************************************/
+/**
+*  @brief    Set OTP options
+*
+*  Set OTP options
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_OTP_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_setOTPOption(uint64_t mask)
+{
+       uint32_t ctrl1 = (uint32_t) mask;
+       uint32_t ctrl2 = (uint32_t) (mask >> 32);
+
+       reg32_modify_or(&pChipcHw->SoftOTP1, ctrl1);
+       reg32_modify_or(&pChipcHw->SoftOTP2, ctrl2);
+}
+
+/****************************************************************************/
+/**
+*  @brief    Get sticky bits
+*
+*  @return   Sticky bit options of type chipcHw_REG_STICKY_XXXXXX
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getStickyBits(void)
+{
+       return pChipcHw->Sticky;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Set sticky bits
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_STICKY_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_setStickyBits(uint32_t mask)
+{
+       uint32_t bits = 0;
+
+       REG_LOCAL_IRQ_SAVE;
+       if (mask & chipcHw_REG_STICKY_POR_BROM) {
+               bits |= chipcHw_REG_STICKY_POR_BROM;
+       } else {
+               uint32_t sticky;
+               sticky = pChipcHw->Sticky;
+
+               if ((mask & chipcHw_REG_STICKY_BOOT_DONE)
+                   && (sticky & chipcHw_REG_STICKY_BOOT_DONE) == 0) {
+                       bits |= chipcHw_REG_STICKY_BOOT_DONE;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_1)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_1) == 0) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_1;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_2)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_2) == 0) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_2;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_3)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_3) == 0) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_3;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_4)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_4) == 0) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_4;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_5)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_5) == 0) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_5;
+               }
+       }
+       pChipcHw->Sticky = bits;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Clear sticky bits
+*
+*  @return   void
+*
+*  @note     use chipcHw_REG_STICKY_XXXXXX
+*/
+/****************************************************************************/
+static inline void chipcHw_clearStickyBits(uint32_t mask)
+{
+       uint32_t bits = 0;
+
+       REG_LOCAL_IRQ_SAVE;
+       if (mask &
+           (chipcHw_REG_STICKY_BOOT_DONE | chipcHw_REG_STICKY_GENERAL_1 |
+            chipcHw_REG_STICKY_GENERAL_2 | chipcHw_REG_STICKY_GENERAL_3 |
+            chipcHw_REG_STICKY_GENERAL_4 | chipcHw_REG_STICKY_GENERAL_5)) {
+               uint32_t sticky = pChipcHw->Sticky;
+
+               if ((mask & chipcHw_REG_STICKY_BOOT_DONE)
+                   && (sticky & chipcHw_REG_STICKY_BOOT_DONE)) {
+                       bits = chipcHw_REG_STICKY_BOOT_DONE;
+                       mask &= ~chipcHw_REG_STICKY_BOOT_DONE;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_1)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_1)) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_1;
+                       mask &= ~chipcHw_REG_STICKY_GENERAL_1;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_2)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_2)) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_2;
+                       mask &= ~chipcHw_REG_STICKY_GENERAL_2;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_3)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_3)) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_3;
+                       mask &= ~chipcHw_REG_STICKY_GENERAL_3;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_4)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_4)) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_4;
+                       mask &= ~chipcHw_REG_STICKY_GENERAL_4;
+               }
+               if ((mask & chipcHw_REG_STICKY_GENERAL_5)
+                   && (sticky & chipcHw_REG_STICKY_GENERAL_5)) {
+                       bits |= chipcHw_REG_STICKY_GENERAL_5;
+                       mask &= ~chipcHw_REG_STICKY_GENERAL_5;
+               }
+       }
+       pChipcHw->Sticky = bits | mask;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Get software strap value
+*
+*  Retrieves software strap value
+*
+*  @return   Software strap value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getSoftStraps(void)
+{
+       return pChipcHw->SoftStraps;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Set software override strap options
+*
+*  set software override strap options
+*
+*  @return   nothing
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setSoftStraps(uint32_t strapOptions)
+{
+       reg32_write(&pChipcHw->SoftStraps, strapOptions);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get Pin Strap Options
+*
+*  This function returns the raw boot strap options
+*
+*  @return  strap options
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getPinStraps(void)
+{
+       return pChipcHw->PinStraps;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get Valid Strap Options
+*
+*  This function returns the valid raw boot strap options
+*
+*  @return  strap options
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getValidStraps(void)
+{
+       uint32_t softStraps;
+
+       /*
+        ** Always return the SoftStraps - bootROM calls chipcHw_initValidStraps
+        ** which copies HW straps to soft straps if there is no override
+        */
+       softStraps = chipcHw_getSoftStraps();
+
+       return softStraps;
+}
+
+/****************************************************************************/
+/**
+*  @brief    Initialize valid pin strap options
+*
+*  Retrieves valid pin strap options by copying HW strap options to soft register
+*  (if chipcHw_STRAPS_SOFT_OVERRIDE not set)
+*
+*  @return   nothing
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_initValidStraps(void)
+{
+       uint32_t softStraps;
+
+       REG_LOCAL_IRQ_SAVE;
+       softStraps = chipcHw_getSoftStraps();
+
+       if ((softStraps & chipcHw_STRAPS_SOFT_OVERRIDE) == 0) {
+               /* Copy HW straps to software straps */
+               chipcHw_setSoftStraps(chipcHw_getPinStraps());
+       }
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get boot device
+*
+*  This function returns the device type used in booting the system
+*
+*  @return  Boot device of type chipcHw_BOOT_DEVICE
+*
+*/
+/****************************************************************************/
+static inline chipcHw_BOOT_DEVICE_e chipcHw_getBootDevice(void)
+{
+       return chipcHw_getValidStraps() & chipcHw_STRAPS_BOOT_DEVICE_MASK;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get boot mode
+*
+*  This function returns the way the system was booted
+*
+*  @return  Boot mode of type chipcHw_BOOT_MODE
+*
+*/
+/****************************************************************************/
+static inline chipcHw_BOOT_MODE_e chipcHw_getBootMode(void)
+{
+       return chipcHw_getValidStraps() & chipcHw_STRAPS_BOOT_MODE_MASK;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get NAND flash page size
+*
+*  This function returns the NAND device page size
+*
+*  @return  Boot NAND device page size
+*
+*/
+/****************************************************************************/
+static inline chipcHw_NAND_PAGESIZE_e chipcHw_getNandPageSize(void)
+{
+       return chipcHw_getValidStraps() & chipcHw_STRAPS_NAND_PAGESIZE_MASK;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get NAND flash address cycle configuration
+*
+*  This function returns the NAND flash address cycle configuration
+*
+*  @return  0 = Do not extra address cycle, 1 = Add extra cycle
+*
+*/
+/****************************************************************************/
+static inline int chipcHw_getNandExtraCycle(void)
+{
+       if (chipcHw_getValidStraps() & chipcHw_STRAPS_NAND_EXTRA_CYCLE) {
+               return 1;
+       } else {
+               return 0;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Activates PIF interface
+*
+*  This function activates PIF interface by taking control of LCD pins
+*
+*  @note
+*       When activated, LCD pins will be defined as follows for PIF operation
+*
+*       CLD[17:0]  = pif_data[17:0]
+*       CLD[23:18] = pif_address[5:0]
+*       CLPOWER    = pif_wr_str
+*       CLCP       = pif_rd_str
+*       CLAC       = pif_hat1
+*       CLFP       = pif_hrdy1
+*       CLLP       = pif_hat2
+*       GPIO[42]   = pif_hrdy2
+*
+*       In PIF mode, "pif_hrdy2" overrides other shared function for GPIO[42] pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_activatePifInterface(void)
+{
+       reg32_write(&pChipcHw->LcdPifMode, chipcHw_REG_PIF_PIN_ENABLE);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Activates LCD interface
+*
+*  This function activates LCD interface
+*
+*  @note
+*       When activated, LCD pins will be defined as follows
+*
+*       CLD[17:0]  = LCD data
+*       CLD[23:18] = LCD data
+*       CLPOWER    = LCD power
+*       CLCP       =
+*       CLAC       = LCD ack
+*       CLFP       =
+*       CLLP       =
+*/
+/****************************************************************************/
+static inline void chipcHw_activateLcdInterface(void)
+{
+       reg32_write(&pChipcHw->LcdPifMode, chipcHw_REG_LCD_PIN_ENABLE);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Deactivates PIF/LCD interface
+*
+*  This function deactivates PIF/LCD interface
+*
+*  @note
+*       When deactivated LCD pins will be in rti-stated
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_deactivatePifLcdInterface(void)
+{
+       reg32_write(&pChipcHw->LcdPifMode, 0);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Select GE2
+*
+*  This function select GE2 as the graphic engine
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_selectGE2(void)
+{
+       reg32_modify_and(&pChipcHw->MiscCtrl, ~chipcHw_REG_MISC_CTRL_GE_SEL);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Select GE3
+*
+*  This function select GE3 as the graphic engine
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_selectGE3(void)
+{
+       reg32_modify_or(&pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_GE_SEL);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get to know the configuration of GPIO pin
+*
+*/
+/****************************************************************************/
+static inline chipcHw_GPIO_FUNCTION_e chipcHw_getGpioPinFunction(int pin)
+{
+       return (*((uint32_t *) chipcHw_REG_GPIO_MUX(pin)) &
+               (chipcHw_REG_GPIO_MUX_MASK <<
+                chipcHw_REG_GPIO_MUX_POSITION(pin))) >>
+           chipcHw_REG_GPIO_MUX_POSITION(pin);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Configure GPIO pin function
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setGpioPinFunction(int pin,
+                                             chipcHw_GPIO_FUNCTION_e func)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *((uint32_t *) chipcHw_REG_GPIO_MUX(pin)) &=
+           ~(chipcHw_REG_GPIO_MUX_MASK << chipcHw_REG_GPIO_MUX_POSITION(pin));
+       *((uint32_t *) chipcHw_REG_GPIO_MUX(pin)) |=
+           func << chipcHw_REG_GPIO_MUX_POSITION(pin);
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin slew rate
+*
+*  This function sets the slew of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinSlewRate(uint32_t pin,
+                                         chipcHw_PIN_SLEW_RATE_e slewRate)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *((uint32_t *) chipcHw_REG_SLEW_RATE(pin)) &=
+           ~(chipcHw_REG_SLEW_RATE_MASK <<
+             chipcHw_REG_SLEW_RATE_POSITION(pin));
+       *((uint32_t *) chipcHw_REG_SLEW_RATE(pin)) |=
+           (uint32_t) slewRate << chipcHw_REG_SLEW_RATE_POSITION(pin);
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin output drive current
+*
+*  This function sets output drive current of individual pin
+*
+*  Note: Avoid the use of the word 'current' since linux headers define this
+*        to be the current task.
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinOutputCurrent(uint32_t pin,
+                                              chipcHw_PIN_CURRENT_STRENGTH_e
+                                              curr)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *((uint32_t *) chipcHw_REG_CURRENT(pin)) &=
+           ~(chipcHw_REG_CURRENT_MASK << chipcHw_REG_CURRENT_POSITION(pin));
+       *((uint32_t *) chipcHw_REG_CURRENT(pin)) |=
+           (uint32_t) curr << chipcHw_REG_CURRENT_POSITION(pin);
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin pullup register
+*
+*  This function sets pullup register of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinPullup(uint32_t pin, chipcHw_PIN_PULL_e pullup)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *((uint32_t *) chipcHw_REG_PULLUP(pin)) &=
+           ~(chipcHw_REG_PULLUP_MASK << chipcHw_REG_PULLUP_POSITION(pin));
+       *((uint32_t *) chipcHw_REG_PULLUP(pin)) |=
+           (uint32_t) pullup << chipcHw_REG_PULLUP_POSITION(pin);
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin input type
+*
+*  This function sets input type of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinInputType(uint32_t pin,
+                                          chipcHw_PIN_INPUTTYPE_e inputType)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *((uint32_t *) chipcHw_REG_INPUTTYPE(pin)) &=
+           ~(chipcHw_REG_INPUTTYPE_MASK <<
+             chipcHw_REG_INPUTTYPE_POSITION(pin));
+       *((uint32_t *) chipcHw_REG_INPUTTYPE(pin)) |=
+           (uint32_t) inputType << chipcHw_REG_INPUTTYPE_POSITION(pin);
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Power up the USB PHY
+*
+*  This function powers up the USB PHY
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_powerUpUsbPhy(void)
+{
+       reg32_modify_and(&pChipcHw->MiscCtrl,
+                        chipcHw_REG_MISC_CTRL_USB_POWERON);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Power down the USB PHY
+*
+*  This function powers down the USB PHY
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_powerDownUsbPhy(void)
+{
+       reg32_modify_or(&pChipcHw->MiscCtrl,
+                       chipcHw_REG_MISC_CTRL_USB_POWEROFF);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set the 2nd USB as host
+*
+*  This function sets the 2nd USB as host
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setUsbHost(void)
+{
+       reg32_modify_or(&pChipcHw->MiscCtrl,
+                       chipcHw_REG_MISC_CTRL_USB_MODE_HOST);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set the 2nd USB as device
+*
+*  This function sets the 2nd USB as device
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setUsbDevice(void)
+{
+       reg32_modify_and(&pChipcHw->MiscCtrl,
+                        chipcHw_REG_MISC_CTRL_USB_MODE_DEVICE);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Lower layer funtion to enable/disable a clock of a certain device
+*
+*  This function enables/disables a core clock
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setClock(chipcHw_CLOCK_e clock,
+                                   chipcHw_OPTYPE_e type, int mode)
+{
+       volatile uint32_t *pPLLReg = (uint32_t *) 0x0;
+       volatile uint32_t *pClockCtrl = (uint32_t *) 0x0;
+
+       switch (clock) {
+       case chipcHw_CLOCK_DDR:
+               pPLLReg = &pChipcHw->DDRClock;
+               break;
+       case chipcHw_CLOCK_ARM:
+               pPLLReg = &pChipcHw->ARMClock;
+               break;
+       case chipcHw_CLOCK_ESW:
+               pPLLReg = &pChipcHw->ESWClock;
+               break;
+       case chipcHw_CLOCK_VPM:
+               pPLLReg = &pChipcHw->VPMClock;
+               break;
+       case chipcHw_CLOCK_ESW125:
+               pPLLReg = &pChipcHw->ESW125Clock;
+               break;
+       case chipcHw_CLOCK_UART:
+               pPLLReg = &pChipcHw->UARTClock;
+               break;
+       case chipcHw_CLOCK_SDIO0:
+               pPLLReg = &pChipcHw->SDIO0Clock;
+               break;
+       case chipcHw_CLOCK_SDIO1:
+               pPLLReg = &pChipcHw->SDIO1Clock;
+               break;
+       case chipcHw_CLOCK_SPI:
+               pPLLReg = &pChipcHw->SPIClock;
+               break;
+       case chipcHw_CLOCK_ETM:
+               pPLLReg = &pChipcHw->ETMClock;
+               break;
+       case chipcHw_CLOCK_USB:
+               pPLLReg = &pChipcHw->USBClock;
+               if (type == chipcHw_OPTYPE_OUTPUT) {
+                       if (mode) {
+                               reg32_modify_and(pPLLReg,
+                                                ~chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       } else {
+                               reg32_modify_or(pPLLReg,
+                                               chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       }
+               }
+               break;
+       case chipcHw_CLOCK_LCD:
+               pPLLReg = &pChipcHw->LCDClock;
+               if (type == chipcHw_OPTYPE_OUTPUT) {
+                       if (mode) {
+                               reg32_modify_and(pPLLReg,
+                                                ~chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       } else {
+                               reg32_modify_or(pPLLReg,
+                                               chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       }
+               }
+               break;
+       case chipcHw_CLOCK_APM:
+               pPLLReg = &pChipcHw->APMClock;
+               if (type == chipcHw_OPTYPE_OUTPUT) {
+                       if (mode) {
+                               reg32_modify_and(pPLLReg,
+                                                ~chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       } else {
+                               reg32_modify_or(pPLLReg,
+                                               chipcHw_REG_PLL_CLOCK_POWER_DOWN);
+                       }
+               }
+               break;
+       case chipcHw_CLOCK_BUS:
+               pClockCtrl = &pChipcHw->ACLKClock;
+               break;
+       case chipcHw_CLOCK_OTP:
+               pClockCtrl = &pChipcHw->OTPClock;
+               break;
+       case chipcHw_CLOCK_I2C:
+               pClockCtrl = &pChipcHw->I2CClock;
+               break;
+       case chipcHw_CLOCK_I2S0:
+               pClockCtrl = &pChipcHw->I2S0Clock;
+               break;
+       case chipcHw_CLOCK_RTBUS:
+               pClockCtrl = &pChipcHw->RTBUSClock;
+               break;
+       case chipcHw_CLOCK_APM100:
+               pClockCtrl = &pChipcHw->APM100Clock;
+               break;
+       case chipcHw_CLOCK_TSC:
+               pClockCtrl = &pChipcHw->TSCClock;
+               break;
+       case chipcHw_CLOCK_LED:
+               pClockCtrl = &pChipcHw->LEDClock;
+               break;
+       case chipcHw_CLOCK_I2S1:
+               pClockCtrl = &pChipcHw->I2S1Clock;
+               break;
+       }
+
+       if (pPLLReg) {
+               switch (type) {
+               case chipcHw_OPTYPE_OUTPUT:
+                       /* PLL clock output enable/disable */
+                       if (mode) {
+                               if (clock == chipcHw_CLOCK_DDR) {
+                                       /* DDR clock enable is inverted */
+                                       reg32_modify_and(pPLLReg,
+                                                        ~chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE);
+                               } else {
+                                       reg32_modify_or(pPLLReg,
+                                                       chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE);
+                               }
+                       } else {
+                               if (clock == chipcHw_CLOCK_DDR) {
+                                       /* DDR clock disable is inverted */
+                                       reg32_modify_or(pPLLReg,
+                                                       chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE);
+                               } else {
+                                       reg32_modify_and(pPLLReg,
+                                                        ~chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE);
+                               }
+                       }
+                       break;
+               case chipcHw_OPTYPE_BYPASS:
+                       /* PLL clock bypass enable/disable */
+                       if (mode) {
+                               reg32_modify_or(pPLLReg,
+                                               chipcHw_REG_PLL_CLOCK_BYPASS_SELECT);
+                       } else {
+                               reg32_modify_and(pPLLReg,
+                                                ~chipcHw_REG_PLL_CLOCK_BYPASS_SELECT);
+                       }
+                       break;
+               }
+       } else if (pClockCtrl) {
+               switch (type) {
+               case chipcHw_OPTYPE_OUTPUT:
+                       if (mode) {
+                               reg32_modify_or(pClockCtrl,
+                                               chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE);
+                       } else {
+                               reg32_modify_and(pClockCtrl,
+                                                ~chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE);
+                       }
+                       break;
+               case chipcHw_OPTYPE_BYPASS:
+                       if (mode) {
+                               reg32_modify_or(pClockCtrl,
+                                               chipcHw_REG_DIV_CLOCK_BYPASS_SELECT);
+                       } else {
+                               reg32_modify_and(pClockCtrl,
+                                                ~chipcHw_REG_DIV_CLOCK_BYPASS_SELECT);
+                       }
+                       break;
+               }
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disables a core clock of a certain device
+*
+*  This function disables a core clock
+*
+*  @note    no change in power consumption
+*/
+/****************************************************************************/
+static inline void chipcHw_setClockDisable(chipcHw_CLOCK_e clock)
+{
+
+       /* Disable output of the clock */
+       chipcHw_setClock(clock, chipcHw_OPTYPE_OUTPUT, 0);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable a core clock of a certain device
+*
+*  This function enables a core clock
+*
+*  @note    no change in power consumption
+*/
+/****************************************************************************/
+static inline void chipcHw_setClockEnable(chipcHw_CLOCK_e clock)
+{
+
+       /* Enable output of the clock */
+       chipcHw_setClock(clock, chipcHw_OPTYPE_OUTPUT, 1);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables bypass clock of a certain device
+*
+*  This function enables bypass clock
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_bypassClockEnable(chipcHw_CLOCK_e clock)
+{
+       /* Enable bypass clock */
+       chipcHw_setClock(clock, chipcHw_OPTYPE_BYPASS, 1);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disabled bypass clock of a certain device
+*
+*  This function disables bypass clock
+*
+*  @note    Doesnot affect the bus interface clock
+*/
+/****************************************************************************/
+static inline void chipcHw_bypassClockDisable(chipcHw_CLOCK_e clock)
+{
+       /* Disable bypass clock */
+       chipcHw_setClock(clock, chipcHw_OPTYPE_BYPASS, 0);
+
+}
+
+/****************************************************************************/
+/**  @brief Checks if software strap is enabled
+ *
+ *   @return 1 : When enable
+ *           0 : When disable
+ */
+/****************************************************************************/
+static inline int chipcHw_isSoftwareStrapsEnable(void)
+{
+       return pChipcHw->SoftStraps & 0x00000001;
+}
+
+/****************************************************************************/
+/**  @brief Enable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsEnable(void)
+{
+       reg32_modify_or(&pChipcHw->SoftStraps, 0x00000001);
+}
+
+/****************************************************************************/
+/**  @brief Disable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsDisable(void)
+{
+       reg32_modify_and(&pChipcHw->SoftStraps, (~0x00000001));
+}
+
+/****************************************************************************/
+/**  @brief PLL test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestEnable(void)
+{
+       reg32_modify_or(&pChipcHw->PLLConfig,
+                       chipcHw_REG_PLL_CONFIG_TEST_ENABLE);
+}
+
+/****************************************************************************/
+/**  @brief PLL2 test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestEnable(void)
+{
+       reg32_modify_or(&pChipcHw->PLLConfig2,
+                       chipcHw_REG_PLL_CONFIG_TEST_ENABLE);
+}
+
+/****************************************************************************/
+/**  @brief PLL test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestDisable(void)
+{
+       reg32_modify_and(&pChipcHw->PLLConfig,
+                        ~chipcHw_REG_PLL_CONFIG_TEST_ENABLE);
+}
+
+/****************************************************************************/
+/**  @brief PLL2 test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestDisable(void)
+{
+       reg32_modify_and(&pChipcHw->PLLConfig2,
+                        ~chipcHw_REG_PLL_CONFIG_TEST_ENABLE);
+}
+
+/****************************************************************************/
+/**  @brief Get PLL test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPllTestEnable(void)
+{
+       return pChipcHw->PLLConfig & chipcHw_REG_PLL_CONFIG_TEST_ENABLE;
+}
+
+/****************************************************************************/
+/**  @brief Get PLL2 test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPll2TestEnable(void)
+{
+       return pChipcHw->PLLConfig2 & chipcHw_REG_PLL_CONFIG_TEST_ENABLE;
+}
+
+/****************************************************************************/
+/**  @brief PLL test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestSelect(uint32_t val)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->PLLConfig &= ~chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK;
+       pChipcHw->PLLConfig |=
+           (val) << chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**  @brief PLL2 test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestSelect(uint32_t val)
+{
+
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->PLLConfig2 &= ~chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK;
+       pChipcHw->PLLConfig2 |=
+           (val) << chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**  @brief Get PLL test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPllTestSelected(void)
+{
+       return (uint8_t) ((pChipcHw->
+                          PLLConfig & chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK)
+                         >> chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT);
+}
+
+/****************************************************************************/
+/**  @brief Get PLL2 test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPll2TestSelected(void)
+{
+       return (uint8_t) ((pChipcHw->
+                          PLLConfig2 & chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK)
+                         >> chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT);
+}
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL1
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll1Disable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->PLLConfig |= chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL2
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll2Disable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->PLLConfig2 |= chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->Spare1 |= chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM SW phase alignment interrupt mode
+*
+*  This function sets VPM phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void
+chipcHw_vpmPhaseAlignInterruptMode(chipcHw_VPM_HW_PHASE_INTR_e mode)
+{
+       REG_LOCAL_IRQ_SAVE;
+       if (mode == chipcHw_VPM_HW_PHASE_INTR_DISABLE) {
+               pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE;
+       } else {
+               pChipcHw->Spare1 |= chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE;
+       }
+       pChipcHw->VPMPhaseCtrl2 =
+           (pChipcHw->
+            VPMPhaseCtrl2 & ~(chipcHw_REG_VPM_INTR_SELECT_MASK <<
+                              chipcHw_REG_VPM_INTR_SELECT_SHIFT)) | mode;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl1 |= chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl1 &= ~chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl1 |= chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl1 &= ~chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl1 |= chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl1 &= ~chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl1 |= chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl1 &= ~chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set DDR phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void
+chipcHw_setDdrHwPhaseAlignMargin(chipcHw_DDR_HW_PHASE_MARGIN_e margin)
+{
+       uint32_t ge = 0;
+       uint32_t le = 0;
+
+       switch (margin) {
+       case chipcHw_DDR_HW_PHASE_MARGIN_STRICT:
+               ge = 0x0F;
+               le = 0x0F;
+               break;
+       case chipcHw_DDR_HW_PHASE_MARGIN_MEDIUM:
+               ge = 0x03;
+               le = 0x3F;
+               break;
+       case chipcHw_DDR_HW_PHASE_MARGIN_WIDE:
+               ge = 0x01;
+               le = 0x7F;
+               break;
+       }
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+
+               pChipcHw->DDRPhaseCtrl1 &=
+                   ~((chipcHw_REG_DDR_PHASE_VALUE_GE_MASK <<
+                      chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT)
+                     || (chipcHw_REG_DDR_PHASE_VALUE_LE_MASK <<
+                         chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT));
+
+               pChipcHw->DDRPhaseCtrl1 |=
+                   ((ge << chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT)
+                    || (le << chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT));
+
+               REG_LOCAL_IRQ_RESTORE;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void
+chipcHw_setVpmHwPhaseAlignMargin(chipcHw_VPM_HW_PHASE_MARGIN_e margin)
+{
+       uint32_t ge = 0;
+       uint32_t le = 0;
+
+       switch (margin) {
+       case chipcHw_VPM_HW_PHASE_MARGIN_STRICT:
+               ge = 0x0F;
+               le = 0x0F;
+               break;
+       case chipcHw_VPM_HW_PHASE_MARGIN_MEDIUM:
+               ge = 0x03;
+               le = 0x3F;
+               break;
+       case chipcHw_VPM_HW_PHASE_MARGIN_WIDE:
+               ge = 0x01;
+               le = 0x7F;
+               break;
+       }
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+
+               pChipcHw->VPMPhaseCtrl1 &=
+                   ~((chipcHw_REG_VPM_PHASE_VALUE_GE_MASK <<
+                      chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT)
+                     || (chipcHw_REG_VPM_PHASE_VALUE_LE_MASK <<
+                         chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT));
+
+               pChipcHw->VPMPhaseCtrl1 |=
+                   ((ge << chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT)
+                    || (le << chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT));
+
+               REG_LOCAL_IRQ_RESTORE;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Checks DDR phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isDdrHwPhaseAligned(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_DDR_PHASE_ALIGNED) ? 1 : 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Checks VPM phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isVpmHwPhaseAligned(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_VPM_PHASE_ALIGNED) ? 1 : 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrHwPhaseAlignStatus(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_DDR_PHASE_STATUS_MASK) >>
+           chipcHw_REG_DDR_PHASE_STATUS_SHIFT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmHwPhaseAlignStatus(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_VPM_PHASE_STATUS_MASK) >>
+           chipcHw_REG_VPM_PHASE_STATUS_SHIFT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrPhaseControl(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_DDR_PHASE_CTRL_MASK) >>
+           chipcHw_REG_DDR_PHASE_CTRL_SHIFT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmPhaseControl(void)
+{
+       return (pChipcHw->
+               PhaseAlignStatus & chipcHw_REG_VPM_PHASE_CTRL_MASK) >>
+           chipcHw_REG_VPM_PHASE_CTRL_SHIFT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a DDR phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeout(uint32_t busCycle)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl2 &=
+           ~(chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK <<
+             chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT);
+       pChipcHw->DDRPhaseCtrl2 |=
+           (busCycle & chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK) <<
+           chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a VPM phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeout(uint32_t busCycle)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl2 &=
+           ~(chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK <<
+             chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT);
+       pChipcHw->VPMPhaseCtrl2 |=
+           (busCycle & chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK) <<
+           chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Clear DDR phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptClear(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       /* Clear timeout interrupt service bit */
+       pChipcHw->DDRPhaseCtrl2 |= chipcHw_REG_DDR_INTR_SERVICED;
+       pChipcHw->DDRPhaseCtrl2 &= ~chipcHw_REG_DDR_INTR_SERVICED;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Clear VPM phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptClear(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       /* Clear timeout interrupt service bit */
+       pChipcHw->VPMPhaseCtrl2 |= chipcHw_REG_VPM_INTR_SERVICED;
+       pChipcHw->VPMPhaseCtrl2 &= ~chipcHw_REG_VPM_INTR_SERVICED;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       chipcHw_ddrHwPhaseAlignTimeoutInterruptClear(); /* Recommended */
+       /* Enable timeout interrupt */
+       pChipcHw->DDRPhaseCtrl2 |= chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptEnable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       chipcHw_vpmHwPhaseAlignTimeoutInterruptClear(); /* Recommended */
+       /* Enable timeout interrupt */
+       pChipcHw->VPMPhaseCtrl2 |= chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->DDRPhaseCtrl2 &= ~chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptDisable(void)
+{
+       REG_LOCAL_IRQ_SAVE;
+       pChipcHw->VPMPhaseCtrl2 &= ~chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+#endif /* CHIPC_INLINE_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
new file mode 100644
index 0000000..b162448
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
@@ -0,0 +1,530 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    chipcHw_reg.h
+*
+*  @brief   Definitions for low level chip control registers
+*
+*/
+/****************************************************************************/
+#ifndef CHIPCHW_REG_H
+#define CHIPCHW_REG_H
+
+#include <mach/csp/mm_io.h>
+#include <csp/reg.h>
+#include <mach/csp/ddrcReg.h>
+
+#define chipcHw_BASE_ADDRESS    MM_IO_BASE_CHIPC
+
+typedef struct {
+       uint32_t ChipId;        /* Chip ID */
+       uint32_t DDRClock;      /* PLL1 Channel 1 for DDR clock */
+       uint32_t ARMClock;      /* PLL1 Channel 2 for ARM clock */
+       uint32_t ESWClock;      /* PLL1 Channel 3 for ESW system clock */
+       uint32_t VPMClock;      /* PLL1 Channel 4 for VPM clock */
+       uint32_t ESW125Clock;   /* PLL1 Channel 5 for ESW 125MHz clock */
+       uint32_t UARTClock;     /* PLL1 Channel 6 for UART clock */
+       uint32_t SDIO0Clock;    /* PLL1 Channel 7 for SDIO 0 clock */
+       uint32_t SDIO1Clock;    /* PLL1 Channel 8 for SDIO 1 clock */
+       uint32_t SPIClock;      /* PLL1 Channel 9 for SPI master Clock  */
+       uint32_t ETMClock;      /* PLL1 Channel 10 for ARM ETM Clock  */
+
+       uint32_t ACLKClock;     /* ACLK Clock (Divider) */
+       uint32_t OTPClock;      /* OTP Clock  (Divider) */
+       uint32_t I2CClock;      /* I2C Clock (CK_13m) (Divider) */
+       uint32_t I2S0Clock;     /* I2S0 Clock (Divider) */
+       uint32_t RTBUSClock;    /* RTBUS (DDR PHY Config.) Clock (Divider) */
+       uint32_t pad1;
+       uint32_t APM100Clock;   /* APM 100MHz CLK Clock (Divider) */
+       uint32_t TSCClock;      /* TSC Clock (Divider) */
+       uint32_t LEDClock;      /* LED Clock (Divider) */
+
+       uint32_t USBClock;      /* PLL2 Channel 1 for USB clock */
+       uint32_t LCDClock;      /* PLL2 Channel 2 for LCD clock */
+       uint32_t APMClock;      /* PLL2 Channel 3 for APM 200 MHz clock */
+
+       uint32_t BusIntfClock;  /* Bus interface clock */
+
+       uint32_t PLLStatus;     /* PLL status register (PLL1) */
+       uint32_t PLLConfig;     /* PLL configuration register  (PLL1) */
+       uint32_t PLLPreDivider; /* PLL pre-divider control register (PLL1) */
+       uint32_t PLLDivider;    /* PLL divider control register (PLL1) */
+       uint32_t PLLControl1;   /* PLL analog control register #1 (PLL1) */
+       uint32_t PLLControl2;   /* PLL analog control register #2 (PLL1) */
+
+       uint32_t I2S1Clock;     /* I2S1 Clock  */
+       uint32_t AudioEnable;   /* Enable/ disable audio channel */
+       uint32_t SoftReset1;    /* Reset blocks */
+       uint32_t SoftReset2;    /* Reset blocks */
+       uint32_t Spare1;        /* Phase align interrupts */
+       uint32_t Sticky;        /* Sticky bits */
+       uint32_t MiscCtrl;      /* Misc. control */
+       uint32_t pad3[3];
+
+       uint32_t PLLStatus2;    /* PLL status register (PLL2) */
+       uint32_t PLLConfig2;    /* PLL configuration register  (PLL2) */
+       uint32_t PLLPreDivider2;        /* PLL pre-divider control register (PLL2) */
+       uint32_t PLLDivider2;   /* PLL divider control register (PLL2) */
+       uint32_t PLLControl12;  /* PLL analog control register #1 (PLL2) */
+       uint32_t PLLControl22;  /* PLL analog control register #2 (PLL2) */
+
+       uint32_t DDRPhaseCtrl1; /* DDR Clock Phase Alignment control1 */
+       uint32_t VPMPhaseCtrl1; /* VPM Clock Phase Alignment control1 */
+       uint32_t PhaseAlignStatus;      /* DDR/VPM Clock Phase Alignment Status */
+       uint32_t PhaseCtrlStatus;       /* DDR/VPM Clock HW DDR/VPM ph_ctrl and load_ch Status */
+       uint32_t DDRPhaseCtrl2; /* DDR Clock Phase Alignment control2 */
+       uint32_t VPMPhaseCtrl2; /* VPM Clock Phase Alignment control2 */
+       uint32_t pad4[9];
+
+       uint32_t SoftOTP1;      /* Software OTP control */
+       uint32_t SoftOTP2;      /* Software OTP control */
+       uint32_t SoftStraps;    /* Software strap */
+       uint32_t PinStraps;     /* Pin Straps */
+       uint32_t DiffOscCtrl;   /* Diff oscillator control */
+       uint32_t DiagsCtrl;     /* Diagnostic control */
+       uint32_t DiagsOutputCtrl;       /* Diagnostic output enable */
+       uint32_t DiagsReadBackCtrl;     /* Diagnostic read back control */
+
+       uint32_t LcdPifMode;    /* LCD/PIF Pin Sharing MUX Mode */
+
+       uint32_t GpioMux_0_7;   /* Pin Sharing MUX0 Control */
+       uint32_t GpioMux_8_15;  /* Pin Sharing MUX1 Control */
+       uint32_t GpioMux_16_23; /* Pin Sharing MUX2 Control */
+       uint32_t GpioMux_24_31; /* Pin Sharing MUX3 Control */
+       uint32_t GpioMux_32_39; /* Pin Sharing MUX4 Control */
+       uint32_t GpioMux_40_47; /* Pin Sharing MUX5 Control */
+       uint32_t GpioMux_48_55; /* Pin Sharing MUX6 Control */
+       uint32_t GpioMux_56_63; /* Pin Sharing MUX7 Control */
+
+       uint32_t GpioSR_0_7;    /* Slew rate for GPIO 0 - 7 */
+       uint32_t GpioSR_8_15;   /* Slew rate for GPIO 8 - 15 */
+       uint32_t GpioSR_16_23;  /* Slew rate for GPIO 16 - 23 */
+       uint32_t GpioSR_24_31;  /* Slew rate for GPIO 24 - 31 */
+       uint32_t GpioSR_32_39;  /* Slew rate for GPIO 32 - 39 */
+       uint32_t GpioSR_40_47;  /* Slew rate for GPIO 40 - 47 */
+       uint32_t GpioSR_48_55;  /* Slew rate for GPIO 48 - 55 */
+       uint32_t GpioSR_56_63;  /* Slew rate for GPIO 56 - 63 */
+       uint32_t MiscSR_0_7;    /* Slew rate for MISC 0 - 7 */
+       uint32_t MiscSR_8_15;   /* Slew rate for MISC 8 - 15 */
+
+       uint32_t GpioPull_0_15; /* Pull up registers for GPIO 0 - 15 */
+       uint32_t GpioPull_16_31;        /* Pull up registers for GPIO 16 - 31 */
+       uint32_t GpioPull_32_47;        /* Pull up registers for GPIO 32 - 47 */
+       uint32_t GpioPull_48_63;        /* Pull up registers for GPIO 48 - 63 */
+       uint32_t MiscPull_0_15; /* Pull up registers for MISC 0 - 15 */
+
+       uint32_t GpioInput_0_31;        /* Input type for GPIO 0 - 31 */
+       uint32_t GpioInput_32_63;       /* Input type for GPIO 32 - 63 */
+       uint32_t MiscInput_0_15;        /* Input type for MISC 0 - 16 */
+} chipcHw_REG_t;
+
+#define pChipcHw  ((volatile chipcHw_REG_t *) chipcHw_BASE_ADDRESS)
+#define pChipcPhysical  ((volatile chipcHw_REG_t *) MM_ADDR_IO_CHIPC)
+
+#define chipcHw_REG_CHIPID_BASE_MASK                    0xFFFFF000
+#define chipcHw_REG_CHIPID_BASE_SHIFT                   12
+#define chipcHw_REG_CHIPID_REV_MASK                     0x00000FFF
+#define chipcHw_REG_REV_A0                              0xA00
+#define chipcHw_REG_REV_B0                              0x0B0
+
+#define chipcHw_REG_PLL_STATUS_CONTROL_ENABLE           0x80000000     /* Allow controlling PLL registers */
+#define chipcHw_REG_PLL_STATUS_LOCKED                   0x00000001     /* PLL is settled */
+#define chipcHw_REG_PLL_CONFIG_D_RESET                  0x00000008     /* Digital reset */
+#define chipcHw_REG_PLL_CONFIG_A_RESET                  0x00000004     /* Analog reset */
+#define chipcHw_REG_PLL_CONFIG_BYPASS_ENABLE            0x00000020     /* Bypass enable */
+#define chipcHw_REG_PLL_CONFIG_OUTPUT_ENABLE            0x00000010     /* Output enable */
+#define chipcHw_REG_PLL_CONFIG_POWER_DOWN               0x00000001     /* Power down */
+#define chipcHw_REG_PLL_CONFIG_VCO_SPLIT_FREQ           1600000000     /* 1.6GHz VCO split frequency */
+#define chipcHw_REG_PLL_CONFIG_VCO_800_1600             0x00000000     /* VCO range 800-1600 MHz */
+#define chipcHw_REG_PLL_CONFIG_VCO_1601_3200            0x00000080     /* VCO range 1601-3200 MHz */
+#define chipcHw_REG_PLL_CONFIG_TEST_ENABLE              0x00010000     /* PLL test output enable */
+#define chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK         0x003E0000     /* Mask to set test values */
+#define chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT        17
+
+#define chipcHw_REG_PLL_CLOCK_PHASE_COMP                0x00800000     /* Phase comparator output */
+#define chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK         0x00300000     /* Clock to bus ratio mask */
+#define chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT        20     /* Number of bits to be shifted */
+#define chipcHw_REG_PLL_CLOCK_POWER_DOWN                0x00080000     /* PLL channel power down */
+#define chipcHw_REG_PLL_CLOCK_SOURCE_GPIO               0x00040000     /* Use GPIO as source */
+#define chipcHw_REG_PLL_CLOCK_BYPASS_SELECT             0x00020000     /* Select bypass clock */
+#define chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE             0x00010000     /* Clock gated ON */
+#define chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE       0x00008000     /* Clock phase update enable */
+#define chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT       8      /* Number of bits to be shifted */
+#define chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK        0x00003F00     /* Phase control mask */
+#define chipcHw_REG_PLL_CLOCK_MDIV_MASK                 0x000000FF     /* Clock post divider mask
+
+                                                                          00000000 = divide-by-256
+                                                                          00000001 = divide-by-1
+                                                                          00000010 = divide-by-2
+                                                                          00000011 = divide-by-3
+                                                                          00000100 = divide-by-4
+                                                                          00000101 = divide-by-5
+                                                                          00000110 = divide-by-6
+                                                                          .
+                                                                          .
+                                                                          11111011 = divide-by-251
+                                                                          11111100 = divide-by-252
+                                                                          11111101 = divide-by-253
+                                                                          11111110 = divide-by-254
+                                                                        */
+
+#define chipcHw_REG_DIV_CLOCK_SOURCE_OTHER              0x00040000     /* NON-PLL clock source select */
+#define chipcHw_REG_DIV_CLOCK_BYPASS_SELECT             0x00020000     /* NON-PLL clock bypass enable */
+#define chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE             0x00010000     /* NON-PLL clock output enable */
+#define chipcHw_REG_DIV_CLOCK_DIV_MASK                  0x000000FF     /* NON-PLL clock post-divide mask */
+#define chipcHw_REG_DIV_CLOCK_DIV_256                   0x00000000     /* NON-PLL clock post-divide by 256 */
+
+#define chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT             0
+#define chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT             4
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT           8
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK            0x0001FF00
+#define chipcHw_REG_PLL_PREDIVIDER_POWER_DOWN           0x02000000
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK       0x00700000     /* Divider mask */
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER    0x00000000     /* Integer-N Mode */
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASH_UNIT  0x00100000     /* MASH Sigma-Delta Modulator Unit Mode */
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MFB_UNIT   0x00200000     /* MFB Sigma-Delta Modulator Unit Mode */
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASH_1_8   0x00300000     /* MASH Sigma-Delta Modulator 1/8 Mode */
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MFB_1_8    0x00400000     /* MFB Sigma-Delta Modulator 1/8 Mode */
+
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vco)          ((vco) / chipcHw_XTAL_FREQ_Hz)
+#define chipcHw_REG_PLL_PREDIVIDER_P1                   1
+#define chipcHw_REG_PLL_PREDIVIDER_P2                   1
+
+#define chipcHw_REG_PLL_DIVIDER_M1DIV                   0x03000000
+#define chipcHw_REG_PLL_DIVIDER_FRAC                    0x00FFFFFF     /* Fractional divider */
+
+#define chipcHw_REG_PLL_DIVIDER_NDIV_f_SS               (0x00FFFFFF)   /* To attain spread with max frequency */
+
+#define chipcHw_REG_PLL_DIVIDER_NDIV_f                  0      /* ndiv_frac = chipcHw_REG_PLL_DIVIDER_NDIV_f /
+                                                                  chipcHw_REG_PLL_DIVIDER_FRAC
+                                                                  = 0, when SS is disable
+                                                                */
+
+#define chipcHw_REG_PLL_DIVIDER_MDIV(vco, Hz)           ((chipcHw_divide((vco), (Hz)) > 255) ? 0 : chipcHw_divide((vco), (Hz)))
+
+#define chipcHw_REG_ACLKClock_CLK_DIV_MASK              0x3
+
+/* System booting strap options */
+#define chipcHw_STRAPS_SOFT_OVERRIDE                    0x00000001     /* Software Strap Override */
+
+#define chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_8         0x00000000     /* 8 bit NAND FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_NOR_FLASH_16         0x00000002     /* 16 bit NOR FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_SERIAL_FLASH         0x00000004     /* Serial FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_16        0x00000006     /* 16 bit NAND FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_UART                 0x00000008     /* UART Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_MASK                 0x0000000E     /* Mask */
+
+/* System boot option */
+#define chipcHw_STRAPS_BOOT_OPTION_BROM                 0x00000000     /* Boot from Boot ROM */
+#define chipcHw_STRAPS_BOOT_OPTION_ARAM                 0x00000020     /* Boot from ARAM */
+#define chipcHw_STRAPS_BOOT_OPTION_NOR                  0x00000030     /* Boot from NOR flash */
+
+/* NAND Flash page size strap options */
+#define chipcHw_STRAPS_NAND_PAGESIZE_512                0x00000000     /* NAND FLASH page size of 512 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_2048               0x00000040     /* NAND FLASH page size of 2048 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_4096               0x00000080     /* NAND FLASH page size of 4096 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_EXT                0x000000C0     /* NAND FLASH page of extened size */
+#define chipcHw_STRAPS_NAND_PAGESIZE_MASK               0x000000C0     /* Mask */
+
+#define chipcHw_STRAPS_NAND_EXTRA_CYCLE                 0x00000400     /* NAND FLASH address cycle configuration */
+#define chipcHw_STRAPS_REBOOT_TO_UART                   0x00000800     /* Reboot to UART on error */
+
+/* Secure boot mode strap options */
+#define chipcHw_STRAPS_BOOT_MODE_NORMAL                 0x00000000     /* Normal Boot */
+#define chipcHw_STRAPS_BOOT_MODE_DBG_SW                 0x00000100     /* Software debugging Boot */
+#define chipcHw_STRAPS_BOOT_MODE_DBG_BOOT               0x00000200     /* Boot rom debugging Boot */
+#define chipcHw_STRAPS_BOOT_MODE_NORMAL_QUIET           0x00000300     /* Normal Boot (Quiet BootRom) */
+#define chipcHw_STRAPS_BOOT_MODE_MASK                   0x00000300     /* Mask */
+
+/* Slave Mode straps */
+#define chipcHw_STRAPS_I2CS                             0x02000000     /* I2C Slave  */
+#define chipcHw_STRAPS_SPIS                             0x01000000     /* SPI Slave  */
+
+/* Strap pin options */
+#define chipcHw_REG_SW_STRAPS                           ((pChipcHw->PinStraps & 0x0000FC00) >> 10)
+
+/* PIF/LCD pin sharing defines */
+#define chipcHw_REG_LCD_PIN_ENABLE                      0x00000001     /* LCD Controller is used and the pins have LCD functions */
+#define chipcHw_REG_PIF_PIN_ENABLE                      0x00000002     /* LCD pins are used to perform PIF functions  */
+
+#define chipcHw_GPIO_COUNT                              61     /* Number of GPIO pin accessible thorugh CHIPC */
+
+/* NOTE: Any changes to these constants will require a corresponding change to chipcHw_str.c */
+#define chipcHw_REG_GPIO_MUX_KEYPAD                     0x00000001     /* GPIO mux for Keypad */
+#define chipcHw_REG_GPIO_MUX_I2CH                       0x00000002     /* GPIO mux for I2CH */
+#define chipcHw_REG_GPIO_MUX_SPI                        0x00000003     /* GPIO mux for SPI */
+#define chipcHw_REG_GPIO_MUX_UART                       0x00000004     /* GPIO mux for UART */
+#define chipcHw_REG_GPIO_MUX_LEDMTXP                    0x00000005     /* GPIO mux for LEDMTXP */
+#define chipcHw_REG_GPIO_MUX_LEDMTXS                    0x00000006     /* GPIO mux for LEDMTXS */
+#define chipcHw_REG_GPIO_MUX_SDIO0                      0x00000007     /* GPIO mux for SDIO0 */
+#define chipcHw_REG_GPIO_MUX_SDIO1                      0x00000008     /* GPIO mux for SDIO1 */
+#define chipcHw_REG_GPIO_MUX_PCM                        0x00000009     /* GPIO mux for PCM */
+#define chipcHw_REG_GPIO_MUX_I2S                        0x0000000A     /* GPIO mux for I2S */
+#define chipcHw_REG_GPIO_MUX_ETM                        0x0000000B     /* GPIO mux for ETM */
+#define chipcHw_REG_GPIO_MUX_DEBUG                      0x0000000C     /* GPIO mux for DEBUG */
+#define chipcHw_REG_GPIO_MUX_MISC                       0x0000000D     /* GPIO mux for MISC */
+#define chipcHw_REG_GPIO_MUX_GPIO                       0x00000000     /* GPIO mux for GPIO */
+#define chipcHw_REG_GPIO_MUX(pin)                       (&pChipcHw->GpioMux_0_7 + ((pin) >> 3))
+#define chipcHw_REG_GPIO_MUX_POSITION(pin)              (((pin) & 0x00000007) << 2)
+#define chipcHw_REG_GPIO_MUX_MASK                       0x0000000F     /* Mask */
+
+#define chipcHw_REG_SLEW_RATE_HIGH                      0x00000000     /* High speed slew rate */
+#define chipcHw_REG_SLEW_RATE_NORMAL                    0x00000008     /* Normal slew rate */
+                                                       /* Pins beyond 42 are defined by skipping 8 bits within the register */
+#define chipcHw_REG_SLEW_RATE(pin)                      (((pin) > 42) ? (&pChipcHw->GpioSR_0_7 + (((pin) + 2) >> 3)) : (&pChipcHw->GpioSR_0_7 + ((pin) >> 3)))
+#define chipcHw_REG_SLEW_RATE_POSITION(pin)             (((pin) > 42) ? ((((pin) + 2) & 0x00000007) << 2) : (((pin) & 0x00000007) << 2))
+#define chipcHw_REG_SLEW_RATE_MASK                      0x00000008     /* Mask */
+
+#define chipcHw_REG_CURRENT_STRENGTH_2mA                0x00000001     /* Current driving strength 2 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_4mA                0x00000002     /* Current driving strength 4 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_6mA                0x00000004     /* Current driving strength 6 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_8mA                0x00000005     /* Current driving strength 8 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_10mA               0x00000006     /* Current driving strength 10 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_12mA               0x00000007     /* Current driving strength 12 milli ampere */
+#define chipcHw_REG_CURRENT_MASK                        0x00000007     /* Mask */
+                                                       /* Pins beyond 42 are defined by skipping 8 bits */
+#define chipcHw_REG_CURRENT(pin)                        (((pin) > 42) ? (&pChipcHw->GpioSR_0_7 + (((pin) + 2) >> 3)) : (&pChipcHw->GpioSR_0_7 + ((pin) >> 3)))
+#define chipcHw_REG_CURRENT_POSITION(pin)               (((pin) > 42) ? ((((pin) + 2) & 0x00000007) << 2) : (((pin) & 0x00000007) << 2))
+
+#define chipcHw_REG_PULL_NONE                           0x00000000     /* No pull up register */
+#define chipcHw_REG_PULL_UP                             0x00000001     /* Pull up register enable */
+#define chipcHw_REG_PULL_DOWN                           0x00000002     /* Pull down register enable */
+#define chipcHw_REG_PULLUP_MASK                         0x00000003     /* Mask */
+                                                       /* Pins beyond 42 are defined by skipping 4 bits */
+#define chipcHw_REG_PULLUP(pin)                         (((pin) > 42) ? (&pChipcHw->GpioPull_0_15 + (((pin) + 2) >> 4)) : (&pChipcHw->GpioPull_0_15 + ((pin) >> 4)))
+#define chipcHw_REG_PULLUP_POSITION(pin)                (((pin) > 42) ? ((((pin) + 2) & 0x0000000F) << 1) : (((pin) & 0x0000000F) << 1))
+
+#define chipcHw_REG_INPUTTYPE_CMOS                      0x00000000     /* Normal CMOS logic */
+#define chipcHw_REG_INPUTTYPE_ST                        0x00000001     /* High speed Schmitt Trigger */
+#define chipcHw_REG_INPUTTYPE_MASK                      0x00000001     /* Mask */
+                                                       /* Pins beyond 42 are defined by skipping 2 bits */
+#define chipcHw_REG_INPUTTYPE(pin)                      (((pin) > 42) ? (&pChipcHw->GpioInput_0_31 + (((pin) + 2) >> 5)) : (&pChipcHw->GpioInput_0_31 + ((pin) >> 5)))
+#define chipcHw_REG_INPUTTYPE_POSITION(pin)             (((pin) > 42) ? ((((pin) + 2) & 0x0000001F)) : (((pin) & 0x0000001F)))
+
+/* Device connected to the bus clock */
+#define chipcHw_REG_BUS_CLOCK_ARM                       0x00000001     /* Bus interface clock for ARM */
+#define chipcHw_REG_BUS_CLOCK_VDEC                      0x00000002     /* Bus interface clock for VDEC */
+#define chipcHw_REG_BUS_CLOCK_ARAM                      0x00000004     /* Bus interface clock for ARAM */
+#define chipcHw_REG_BUS_CLOCK_HPM                       0x00000008     /* Bus interface clock for HPM */
+#define chipcHw_REG_BUS_CLOCK_DDRC                      0x00000010     /* Bus interface clock for DDRC */
+#define chipcHw_REG_BUS_CLOCK_DMAC0                     0x00000020     /* Bus interface clock for DMAC0 */
+#define chipcHw_REG_BUS_CLOCK_DMAC1                     0x00000040     /* Bus interface clock for DMAC1 */
+#define chipcHw_REG_BUS_CLOCK_NVI                       0x00000080     /* Bus interface clock for NVI */
+#define chipcHw_REG_BUS_CLOCK_ESW                       0x00000100     /* Bus interface clock for ESW */
+#define chipcHw_REG_BUS_CLOCK_GE                        0x00000200     /* Bus interface clock for GE */
+#define chipcHw_REG_BUS_CLOCK_I2CH                      0x00000400     /* Bus interface clock for I2CH */
+#define chipcHw_REG_BUS_CLOCK_I2S0                      0x00000800     /* Bus interface clock for I2S0 */
+#define chipcHw_REG_BUS_CLOCK_I2S1                      0x00001000     /* Bus interface clock for I2S1 */
+#define chipcHw_REG_BUS_CLOCK_VRAM                      0x00002000     /* Bus interface clock for VRAM */
+#define chipcHw_REG_BUS_CLOCK_CLCD                      0x00004000     /* Bus interface clock for CLCD */
+#define chipcHw_REG_BUS_CLOCK_LDK                       0x00008000     /* Bus interface clock for LDK */
+#define chipcHw_REG_BUS_CLOCK_LED                       0x00010000     /* Bus interface clock for LED */
+#define chipcHw_REG_BUS_CLOCK_OTP                       0x00020000     /* Bus interface clock for OTP */
+#define chipcHw_REG_BUS_CLOCK_PIF                       0x00040000     /* Bus interface clock for PIF */
+#define chipcHw_REG_BUS_CLOCK_SPU                       0x00080000     /* Bus interface clock for SPU */
+#define chipcHw_REG_BUS_CLOCK_SDIO0                     0x00100000     /* Bus interface clock for SDIO0 */
+#define chipcHw_REG_BUS_CLOCK_SDIO1                     0x00200000     /* Bus interface clock for SDIO1 */
+#define chipcHw_REG_BUS_CLOCK_SPIH                      0x00400000     /* Bus interface clock for SPIH */
+#define chipcHw_REG_BUS_CLOCK_SPIS                      0x00800000     /* Bus interface clock for SPIS */
+#define chipcHw_REG_BUS_CLOCK_UART0                     0x01000000     /* Bus interface clock for UART0 */
+#define chipcHw_REG_BUS_CLOCK_UART1                     0x02000000     /* Bus interface clock for UART1 */
+#define chipcHw_REG_BUS_CLOCK_BBL                       0x04000000     /* Bus interface clock for BBL */
+#define chipcHw_REG_BUS_CLOCK_I2CS                      0x08000000     /* Bus interface clock for I2CS */
+#define chipcHw_REG_BUS_CLOCK_USBH                      0x10000000     /* Bus interface clock for USB Host */
+#define chipcHw_REG_BUS_CLOCK_USBD                      0x20000000     /* Bus interface clock for USB Device */
+#define chipcHw_REG_BUS_CLOCK_BROM                      0x40000000     /* Bus interface clock for Boot ROM */
+#define chipcHw_REG_BUS_CLOCK_TSC                       0x80000000     /* Bus interface clock for Touch screen */
+
+/* Software resets defines */
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL_HOLD          0x0000000080000000ULL  /* Reset Global VPM and hold */
+#define chipcHw_REG_SOFT_RESET_VPM_HOLD                 0x0000000040000000ULL  /* Reset VPM and hold */
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL               0x0000000020000000ULL  /* Reset Global VPM */
+#define chipcHw_REG_SOFT_RESET_VPM                      0x0000000010000000ULL  /* Reset VPM */
+#define chipcHw_REG_SOFT_RESET_KEYPAD                   0x0000000008000000ULL  /* Reset Key pad */
+#define chipcHw_REG_SOFT_RESET_LED                      0x0000000004000000ULL  /* Reset LED */
+#define chipcHw_REG_SOFT_RESET_SPU                      0x0000000002000000ULL  /* Reset SPU */
+#define chipcHw_REG_SOFT_RESET_RNG                      0x0000000001000000ULL  /* Reset RNG */
+#define chipcHw_REG_SOFT_RESET_PKA                      0x0000000000800000ULL  /* Reset PKA */
+#define chipcHw_REG_SOFT_RESET_LCD                      0x0000000000400000ULL  /* Reset LCD */
+#define chipcHw_REG_SOFT_RESET_PIF                      0x0000000000200000ULL  /* Reset PIF */
+#define chipcHw_REG_SOFT_RESET_I2CS                     0x0000000000100000ULL  /* Reset I2C Slave */
+#define chipcHw_REG_SOFT_RESET_I2CH                     0x0000000000080000ULL  /* Reset I2C Host */
+#define chipcHw_REG_SOFT_RESET_SDIO1                    0x0000000000040000ULL  /* Reset SDIO 1 */
+#define chipcHw_REG_SOFT_RESET_SDIO0                    0x0000000000020000ULL  /* Reset SDIO 0 */
+#define chipcHw_REG_SOFT_RESET_BBL                      0x0000000000010000ULL  /* Reset BBL */
+#define chipcHw_REG_SOFT_RESET_I2S1                     0x0000000000008000ULL  /* Reset I2S1 */
+#define chipcHw_REG_SOFT_RESET_I2S0                     0x0000000000004000ULL  /* Reset I2S0 */
+#define chipcHw_REG_SOFT_RESET_SPIS                     0x0000000000002000ULL  /* Reset SPI Slave */
+#define chipcHw_REG_SOFT_RESET_SPIH                     0x0000000000001000ULL  /* Reset SPI Host */
+#define chipcHw_REG_SOFT_RESET_GPIO1                    0x0000000000000800ULL  /* Reset GPIO block 1 */
+#define chipcHw_REG_SOFT_RESET_GPIO0                    0x0000000000000400ULL  /* Reset GPIO block 0 */
+#define chipcHw_REG_SOFT_RESET_UART1                    0x0000000000000200ULL  /* Reset UART 1 */
+#define chipcHw_REG_SOFT_RESET_UART0                    0x0000000000000100ULL  /* Reset UART 0 */
+#define chipcHw_REG_SOFT_RESET_NVI                      0x0000000000000080ULL  /* Reset NVI */
+#define chipcHw_REG_SOFT_RESET_WDOG                     0x0000000000000040ULL  /* Reset Watch dog */
+#define chipcHw_REG_SOFT_RESET_TMR                      0x0000000000000020ULL  /* Reset Timer */
+#define chipcHw_REG_SOFT_RESET_ETM                      0x0000000000000010ULL  /* Reset ETM */
+#define chipcHw_REG_SOFT_RESET_ARM_HOLD                 0x0000000000000008ULL  /* Reset ARM and HOLD */
+#define chipcHw_REG_SOFT_RESET_ARM                      0x0000000000000004ULL  /* Reset ARM */
+#define chipcHw_REG_SOFT_RESET_CHIP_WARM                0x0000000000000002ULL  /* Chip warm reset */
+#define chipcHw_REG_SOFT_RESET_CHIP_SOFT                0x0000000000000001ULL  /* Chip soft reset */
+#define chipcHw_REG_SOFT_RESET_VDEC                     0x0000100000000000ULL  /* Video decoder */
+#define chipcHw_REG_SOFT_RESET_GE                       0x0000080000000000ULL  /* Graphics engine */
+#define chipcHw_REG_SOFT_RESET_OTP                      0x0000040000000000ULL  /* Reset OTP */
+#define chipcHw_REG_SOFT_RESET_USB2                     0x0000020000000000ULL  /* Reset USB2 */
+#define chipcHw_REG_SOFT_RESET_USB1                     0x0000010000000000ULL  /* Reset USB 1 */
+#define chipcHw_REG_SOFT_RESET_USB                      0x0000008000000000ULL  /* Reset USB 1 and USB2 soft reset */
+#define chipcHw_REG_SOFT_RESET_ESW                      0x0000004000000000ULL  /* Reset Ethernet switch */
+#define chipcHw_REG_SOFT_RESET_ESWCLK                   0x0000002000000000ULL  /* Reset Ethernet switch clock */
+#define chipcHw_REG_SOFT_RESET_DDRPHY                   0x0000001000000000ULL  /* Reset DDR Physical */
+#define chipcHw_REG_SOFT_RESET_DDR                      0x0000000800000000ULL  /* Reset DDR Controller */
+#define chipcHw_REG_SOFT_RESET_TSC                      0x0000000400000000ULL  /* Reset Touch screen */
+#define chipcHw_REG_SOFT_RESET_PCM                      0x0000000200000000ULL  /* Reset PCM device */
+#define chipcHw_REG_SOFT_RESET_APM                      0x0000200100000000ULL  /* Reset APM device */
+
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL_UNHOLD        0x8000000000000000ULL  /* Unhold Global VPM */
+#define chipcHw_REG_SOFT_RESET_VPM_UNHOLD               0x4000000000000000ULL  /* Unhold VPM */
+#define chipcHw_REG_SOFT_RESET_ARM_UNHOLD               0x2000000000000000ULL  /* Unhold ARM reset  */
+#define chipcHw_REG_SOFT_RESET_UNHOLD_MASK              0xF000000000000000ULL  /* Mask to handle unhold request */
+
+/* Audio channel control defines */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_ALL            0x00000001     /* Enable all audio channel */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_A              0x00000002     /* Enable channel A */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_B              0x00000004     /* Enable channel B */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_C              0x00000008     /* Enable channel C */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_NTP_CLOCK      0x00000010     /* Enable NTP clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_PCM0_CLOCK     0x00000020     /* Enable PCM0 clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_PCM1_CLOCK     0x00000040     /* Enable PCM1 clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_APM_CLOCK      0x00000080     /* Enable APM clock */
+
+/* Misc. chip control defines */
+#define chipcHw_REG_MISC_CTRL_GE_SEL                    0x00040000     /* Select GE2/GE3 */
+#define chipcHw_REG_MISC_CTRL_I2S1_CLOCK_ONCHIP         0x00000000     /* Use on chip clock for I2S1 */
+#define chipcHw_REG_MISC_CTRL_I2S1_CLOCK_GPIO           0x00020000     /* Use external clock via GPIO pin 26 for I2S1 */
+#define chipcHw_REG_MISC_CTRL_I2S0_CLOCK_ONCHIP         0x00000000     /* Use on chip clock for I2S0 */
+#define chipcHw_REG_MISC_CTRL_I2S0_CLOCK_GPIO           0x00010000     /* Use external clock via GPIO pin 45 for I2S0 */
+#define chipcHw_REG_MISC_CTRL_ARM_CP15_DISABLE          0x00008000     /* Disable ARM CP15 bit */
+#define chipcHw_REG_MISC_CTRL_RTC_DISABLE               0x00000008     /* Disable RTC registers */
+#define chipcHw_REG_MISC_CTRL_BBRAM_DISABLE             0x00000004     /* Disable Battery Backed RAM */
+#define chipcHw_REG_MISC_CTRL_USB_MODE_HOST             0x00000002     /* Set USB as host */
+#define chipcHw_REG_MISC_CTRL_USB_MODE_DEVICE           0xFFFFFFFD     /* Set USB as device */
+#define chipcHw_REG_MISC_CTRL_USB_POWERON               0xFFFFFFFE     /* Power up USB */
+#define chipcHw_REG_MISC_CTRL_USB_POWEROFF              0x00000001     /* Power down USB */
+
+/* OTP configuration defines */
+#define chipcHw_REG_OTP_SECURITY_OFF                    0x0000020000000000ULL  /* Security support is OFF */
+#define chipcHw_REG_OTP_SPU_SLOW                        0x0000010000000000ULL  /* Limited SPU throughput */
+#define chipcHw_REG_OTP_LCD_SPEED                       0x0000000600000000ULL  /* Set VPM speed one */
+#define chipcHw_REG_OTP_VPM_SPEED_1                     0x0000000100000000ULL  /* Set VPM speed one */
+#define chipcHw_REG_OTP_VPM_SPEED_0                     0x0000000080000000ULL  /* Set VPM speed zero */
+#define chipcHw_REG_OTP_AXI_SPEED                       0x0000000060000000ULL  /* Set maximum AXI bus speed */
+#define chipcHw_REG_OTP_APM_DISABLE                     0x000000001F000000ULL  /* Disable APM */
+#define chipcHw_REG_OTP_PIF_DISABLE                     0x0000000000200000ULL  /* Disable PIF */
+#define chipcHw_REG_OTP_VDEC_DISABLE                    0x0000000000100000ULL  /* Disable Video decoder */
+#define chipcHw_REG_OTP_BBL_DISABLE                     0x0000000000080000ULL  /* Disable RTC and BBRAM */
+#define chipcHw_REG_OTP_LED_DISABLE                     0x0000000000040000ULL  /* Disable LED */
+#define chipcHw_REG_OTP_GE_DISABLE                      0x0000000000020000ULL  /* Disable Graphics Engine */
+#define chipcHw_REG_OTP_LCD_DISABLE                     0x0000000000010000ULL  /* Disable LCD */
+#define chipcHw_REG_OTP_KEYPAD_DISABLE                  0x0000000000008000ULL  /* Disable keypad */
+#define chipcHw_REG_OTP_UART_DISABLE                    0x0000000000004000ULL  /* Disable UART */
+#define chipcHw_REG_OTP_SDIOH_DISABLE                   0x0000000000003000ULL  /* Disable SDIO host */
+#define chipcHw_REG_OTP_HSS_DISABLE                     0x0000000000000C00ULL  /* Disable HSS */
+#define chipcHw_REG_OTP_TSC_DISABLE                     0x0000000000000200ULL  /* Disable touch screen */
+#define chipcHw_REG_OTP_USB_DISABLE                     0x0000000000000180ULL  /* Disable USB */
+#define chipcHw_REG_OTP_SGMII_DISABLE                   0x0000000000000060ULL  /* Disable SGMII */
+#define chipcHw_REG_OTP_ETH_DISABLE                     0x0000000000000018ULL  /* Disable gigabit ethernet */
+#define chipcHw_REG_OTP_ETH_PHY_DISABLE                 0x0000000000000006ULL  /* Disable ethernet PHY */
+#define chipcHw_REG_OTP_VPM_DISABLE                     0x0000000000000001ULL  /* Disable VPM */
+
+/* Sticky bit defines */
+#define chipcHw_REG_STICKY_BOOT_DONE                    0x00000001     /* Boot done */
+#define chipcHw_REG_STICKY_SOFT_RESET                   0x00000002     /* ARM soft reset */
+#define chipcHw_REG_STICKY_GENERAL_1                    0x00000004     /* General purpose bit 1 */
+#define chipcHw_REG_STICKY_GENERAL_2                    0x00000008     /* General purpose bit 2 */
+#define chipcHw_REG_STICKY_GENERAL_3                    0x00000010     /* General purpose bit 3 */
+#define chipcHw_REG_STICKY_GENERAL_4                    0x00000020     /* General purpose bit 4 */
+#define chipcHw_REG_STICKY_GENERAL_5                    0x00000040     /* General purpose bit 5 */
+#define chipcHw_REG_STICKY_POR_BROM                     0x00000080     /* Special sticky bit for security - set in BROM to avoid other modes being entered */
+#define chipcHw_REG_STICKY_ARM_RESET                    0x00000100     /* ARM reset */
+#define chipcHw_REG_STICKY_CHIP_SOFT_RESET              0x00000200     /* Chip soft reset */
+#define chipcHw_REG_STICKY_CHIP_WARM_RESET              0x00000400     /* Chip warm reset */
+#define chipcHw_REG_STICKY_WDOG_RESET                   0x00000800     /* Watchdog reset */
+#define chipcHw_REG_STICKY_OTP_RESET                    0x00001000     /* OTP reset */
+
+                                                       /* HW phase alignment defines *//* Spare1 register definitions */
+#define chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE        0x80000000     /* Enable DDR phase align panic interrupt */
+#define chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE        0x40000000     /* Enable VPM phase align panic interrupt */
+#define chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE        0x00000002     /* Enable access to VPM using system BUS */
+#define chipcHw_REG_SPARE1_DDR_BUS_ACCESS_ENABLE        0x00000001     /* Enable access to DDR using system BUS */
+                                                       /* DDRPhaseCtrl1 register definitions */
+#define chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE            0x80000000     /* Enable DDR SW phase alignment */
+#define chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE            0x40000000     /* Enable DDR HW phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_GE_MASK             0x0000007F     /* DDR lower threshold for phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT            23
+#define chipcHw_REG_DDR_PHASE_VALUE_LE_MASK             0x0000007F     /* DDR upper threshold for phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT            16
+#define chipcHw_REG_DDR_PHASE_ALIGN_WAIT_CYCLE_MASK     0x0000FFFF     /* BUS Cycle to wait to run next DDR phase alignment */
+#define chipcHw_REG_DDR_PHASE_ALIGN_WAIT_CYCLE_SHIFT    0
+                                                       /* VPMPhaseCtrl1 register definitions */
+#define chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE            0x80000000     /* Enable VPM SW phase alignment */
+#define chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE            0x40000000     /* Enable VPM HW phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_GE_MASK             0x0000007F     /* VPM lower threshold for phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT            23
+#define chipcHw_REG_VPM_PHASE_VALUE_LE_MASK             0x0000007F     /* VPM upper threshold for phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT            16
+#define chipcHw_REG_VPM_PHASE_ALIGN_WAIT_CYCLE_MASK     0x0000FFFF     /* BUS Cycle to wait to complete the VPM phase alignment */
+#define chipcHw_REG_VPM_PHASE_ALIGN_WAIT_CYCLE_SHIFT    0
+                                                       /* PhaseAlignStatus register definitions */
+#define chipcHw_REG_DDR_TIMEOUT_INTR_STATUS             0x80000000     /* DDR time out interrupt status */
+#define chipcHw_REG_DDR_PHASE_STATUS_MASK               0x0000007F     /* DDR phase status value */
+#define chipcHw_REG_DDR_PHASE_STATUS_SHIFT              24
+#define chipcHw_REG_DDR_PHASE_ALIGNED                   0x00800000     /* DDR Phase aligned status */
+#define chipcHw_REG_DDR_LOAD                            0x00400000     /* Load DDR phase status */
+#define chipcHw_REG_DDR_PHASE_CTRL_MASK                 0x0000003F     /* DDR phase control value */
+#define chipcHw_REG_DDR_PHASE_CTRL_SHIFT                16
+#define chipcHw_REG_VPM_TIMEOUT_INTR_STATUS             0x80000000     /* VPM time out interrupt status */
+#define chipcHw_REG_VPM_PHASE_STATUS_MASK               0x0000007F     /* VPM phase status value */
+#define chipcHw_REG_VPM_PHASE_STATUS_SHIFT              8
+#define chipcHw_REG_VPM_PHASE_ALIGNED                   0x00000080     /* VPM Phase aligned status */
+#define chipcHw_REG_VPM_LOAD                            0x00000040     /* Load VPM phase status */
+#define chipcHw_REG_VPM_PHASE_CTRL_MASK                 0x0000003F     /* VPM phase control value */
+#define chipcHw_REG_VPM_PHASE_CTRL_SHIFT                0
+                                                       /* DDRPhaseCtrl2 register definitions */
+#define chipcHw_REG_DDR_INTR_SERVICED                   0x02000000     /* Acknowledge that interrupt was serviced */
+#define chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE             0x01000000     /* Enable time out interrupt */
+#define chipcHw_REG_DDR_LOAD_COUNT_PHASE_CTRL_MASK      0x0000000F     /* Wait before toggling load_ch */
+#define chipcHw_REG_DDR_LOAD_COUNT_PHASE_CTRL_SHIFT     20
+#define chipcHw_REG_DDR_TOTAL_LOAD_COUNT_CTRL_MASK      0x0000000F     /* Total wait to settle ph_ctrl and load_ch */
+#define chipcHw_REG_DDR_TOTAL_LOAD_COUNT_CTRL_SHIFT     16
+#define chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK        0x0000FFFF     /* Time out value for DDR HW phase alignment */
+#define chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT       0
+                                                       /* VPMPhaseCtrl2 register definitions */
+#define chipcHw_REG_VPM_INTR_SELECT_MASK                0x00000003     /* Interrupt select */
+#define chipcHw_REG_VPM_INTR_SELECT_SHIFT               26
+#define chipcHw_REG_VPM_INTR_DISABLE                    0x00000000
+#define chipcHw_REG_VPM_INTR_FAST                       (0x1 << chipcHw_REG_VPM_INTR_SELECT_SHIFT)
+#define chipcHw_REG_VPM_INTR_MEDIUM                     (0x2 << chipcHw_REG_VPM_INTR_SELECT_SHIFT)
+#define chipcHw_REG_VPM_INTR_SLOW                       (0x3 << chipcHw_REG_VPM_INTR_SELECT_SHIFT)
+#define chipcHw_REG_VPM_INTR_SERVICED                   0x02000000     /* Acknowledge that interrupt was serviced */
+#define chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE             0x01000000     /* Enable time out interrupt */
+#define chipcHw_REG_VPM_LOAD_COUNT_PHASE_CTRL_MASK      0x0000000F     /* Wait before toggling load_ch */
+#define chipcHw_REG_VPM_LOAD_COUNT_PHASE_CTRL_SHIFT     20
+#define chipcHw_REG_VPM_TOTAL_LOAD_COUNT_CTRL_MASK      0x0000000F     /* Total wait cycle to settle ph_ctrl and load_ch */
+#define chipcHw_REG_VPM_TOTAL_LOAD_COUNT_CTRL_SHIFT     16
+#define chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK        0x0000FFFF     /* Time out value for VPM HW phase alignment */
+#define chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT       0
+
+#endif /* CHIPCHW_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h b/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
new file mode 100644
index 0000000..f1b68e2
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
@@ -0,0 +1,872 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    ddrcReg.h
+*
+*  @brief   Register definitions for BCMRING DDR2 Controller and PHY
+*
+*/
+/****************************************************************************/
+
+#ifndef DDRC_REG_H
+#define DDRC_REG_H
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/reg.h>
+#include <csp/stdint.h>
+
+#include <mach/csp/mm_io.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+/*********************************************************************/
+/* DDR2 Controller (ARM PL341) register definitions */
+/*********************************************************************/
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* ARM PL341 DDR2 configuration registers, offset 0x000 */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+       typedef struct {
+               uint32_t memcStatus;
+               uint32_t memcCmd;
+               uint32_t directCmd;
+               uint32_t memoryCfg;
+               uint32_t refreshPrd;
+               uint32_t casLatency;
+               uint32_t writeLatency;
+               uint32_t tMrd;
+               uint32_t tRas;
+               uint32_t tRc;
+               uint32_t tRcd;
+               uint32_t tRfc;
+               uint32_t tRp;
+               uint32_t tRrd;
+               uint32_t tWr;
+               uint32_t tWtr;
+               uint32_t tXp;
+               uint32_t tXsr;
+               uint32_t tEsr;
+               uint32_t memoryCfg2;
+               uint32_t memoryCfg3;
+               uint32_t tFaw;
+       } ddrcReg_CTLR_MEMC_REG_t;
+
+#define ddrcReg_CTLR_MEMC_REG_OFFSET                    0x0000
+#define ddrcReg_CTLR_MEMC_REGP                          ((volatile ddrcReg_CTLR_MEMC_REG_t *)  (MM_IO_BASE_DDRC + ddrcReg_CTLR_MEMC_REG_OFFSET))
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_MEMC_STATUS_BANKS_MASK             (0x3 << 12)
+#define ddrcReg_CTLR_MEMC_STATUS_BANKS_4                (0x0 << 12)
+#define ddrcReg_CTLR_MEMC_STATUS_BANKS_8                (0x3 << 12)
+
+#define ddrcReg_CTLR_MEMC_STATUS_MONITORS_MASK          (0x3 << 10)
+#define ddrcReg_CTLR_MEMC_STATUS_MONITORS_0             (0x0 << 10)
+#define ddrcReg_CTLR_MEMC_STATUS_MONITORS_1             (0x1 << 10)
+#define ddrcReg_CTLR_MEMC_STATUS_MONITORS_2             (0x2 << 10)
+#define ddrcReg_CTLR_MEMC_STATUS_MONITORS_4             (0x3 << 10)
+
+#define ddrcReg_CTLR_MEMC_STATUS_CHIPS_MASK             (0x3 << 7)
+#define ddrcReg_CTLR_MEMC_STATUS_CHIPS_1                (0x0 << 7)
+#define ddrcReg_CTLR_MEMC_STATUS_CHIPS_2                (0x1 << 7)
+#define ddrcReg_CTLR_MEMC_STATUS_CHIPS_3                (0x2 << 7)
+#define ddrcReg_CTLR_MEMC_STATUS_CHIPS_4                (0x3 << 7)
+
+#define ddrcReg_CTLR_MEMC_STATUS_TYPE_MASK              (0x7 << 4)
+#define ddrcReg_CTLR_MEMC_STATUS_TYPE_DDR2              (0x5 << 4)
+
+#define ddrcReg_CTLR_MEMC_STATUS_WIDTH_MASK             (0x3 << 2)
+#define ddrcReg_CTLR_MEMC_STATUS_WIDTH_16               (0x0 << 2)
+#define ddrcReg_CTLR_MEMC_STATUS_WIDTH_32               (0x1 << 2)
+#define ddrcReg_CTLR_MEMC_STATUS_WIDTH_64               (0x2 << 2)
+#define ddrcReg_CTLR_MEMC_STATUS_WIDTH_128              (0x3 << 2)
+
+#define ddrcReg_CTLR_MEMC_STATUS_STATE_MASK             (0x3 << 0)
+#define ddrcReg_CTLR_MEMC_STATUS_STATE_CONFIG           (0x0 << 0)
+#define ddrcReg_CTLR_MEMC_STATUS_STATE_READY            (0x1 << 0)
+#define ddrcReg_CTLR_MEMC_STATUS_STATE_PAUSED           (0x2 << 0)
+#define ddrcReg_CTLR_MEMC_STATUS_STATE_LOWPWR           (0x3 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_MEMC_CMD_MASK                      (0x7 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_GO                        (0x0 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_SLEEP                     (0x1 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_WAKEUP                    (0x2 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_PAUSE                     (0x3 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_CONFIGURE                 (0x4 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_ACTIVE_PAUSE              (0x7 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_DIRECT_CMD_CHIP_SHIFT              20
+#define ddrcReg_CTLR_DIRECT_CMD_CHIP_MASK               (0x3 << ddrcReg_CTLR_DIRECT_CMD_CHIP_SHIFT)
+
+#define ddrcReg_CTLR_DIRECT_CMD_TYPE_PRECHARGEALL       (0x0 << 18)
+#define ddrcReg_CTLR_DIRECT_CMD_TYPE_AUTOREFRESH        (0x1 << 18)
+#define ddrcReg_CTLR_DIRECT_CMD_TYPE_MODEREG            (0x2 << 18)
+#define ddrcReg_CTLR_DIRECT_CMD_TYPE_NOP                (0x3 << 18)
+
+#define ddrcReg_CTLR_DIRECT_CMD_BANK_SHIFT              16
+#define ddrcReg_CTLR_DIRECT_CMD_BANK_MASK               (0x3 << ddrcReg_CTLR_DIRECT_CMD_BANK_SHIFT)
+
+#define ddrcReg_CTLR_DIRECT_CMD_ADDR_SHIFT              0
+#define ddrcReg_CTLR_DIRECT_CMD_ADDR_MASK               (0x1ffff << ddrcReg_CTLR_DIRECT_CMD_ADDR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_MEMORY_CFG_CHIP_CNT_MASK           (0x3 << 21)
+#define ddrcReg_CTLR_MEMORY_CFG_CHIP_CNT_1              (0x0 << 21)
+#define ddrcReg_CTLR_MEMORY_CFG_CHIP_CNT_2              (0x1 << 21)
+#define ddrcReg_CTLR_MEMORY_CFG_CHIP_CNT_3              (0x2 << 21)
+#define ddrcReg_CTLR_MEMORY_CFG_CHIP_CNT_4              (0x3 << 21)
+
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_MASK           (0x7 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_3_0            (0x0 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_4_1            (0x1 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_5_2            (0x2 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_6_3            (0x3 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_7_4            (0x4 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_8_5            (0x5 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_9_6            (0x6 << 18)
+#define ddrcReg_CTLR_MEMORY_CFG_QOS_ARID_10_7           (0x7 << 18)
+
+#define ddrcReg_CTLR_MEMORY_CFG_BURST_LEN_MASK          (0x7 << 15)
+#define ddrcReg_CTLR_MEMORY_CFG_BURST_LEN_4             (0x2 << 15)
+#define ddrcReg_CTLR_MEMORY_CFG_BURST_LEN_8             (0x3 << 15)    /* @note Not supported in PL341 */
+
+#define ddrcReg_CTLR_MEMORY_CFG_PWRDOWN_ENABLE          (0x1 << 13)
+
+#define ddrcReg_CTLR_MEMORY_CFG_PWRDOWN_CYCLES_SHIFT    7
+#define ddrcReg_CTLR_MEMORY_CFG_PWRDOWN_CYCLES_MASK     (0x3f << ddrcReg_CTLR_MEMORY_CFG_PWRDOWN_CYCLES_SHIFT)
+
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_MASK       (0x7 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_11         (0x0 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_12         (0x1 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_13         (0x2 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_14         (0x3 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_15         (0x4 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_ROW_BITS_16         (0x5 << 3)
+
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_COL_BITS_MASK       (0x7 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_COL_BITS_9          (0x1 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_COL_BITS_10         (0x2 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG_AXI_COL_BITS_11         (0x3 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_REFRESH_PRD_SHIFT                  0
+#define ddrcReg_CTLR_REFRESH_PRD_MASK                   (0x7fff << ddrcReg_CTLR_REFRESH_PRD_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_CAS_LATENCY_SHIFT                  1
+#define ddrcReg_CTLR_CAS_LATENCY_MASK                   (0x7 << ddrcReg_CTLR_CAS_LATENCY_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_WRITE_LATENCY_SHIFT                0
+#define ddrcReg_CTLR_WRITE_LATENCY_MASK                 (0x7 << ddrcReg_CTLR_WRITE_LATENCY_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_MRD_SHIFT                        0
+#define ddrcReg_CTLR_T_MRD_MASK                         (0x7f << ddrcReg_CTLR_T_MRD_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RAS_SHIFT                        0
+#define ddrcReg_CTLR_T_RAS_MASK                         (0x1f << ddrcReg_CTLR_T_RAS_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RC_SHIFT                         0
+#define ddrcReg_CTLR_T_RC_MASK                          (0x1f << ddrcReg_CTLR_T_RC_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_MASK          (0x7 << ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RCD_SHIFT                        0
+#define ddrcReg_CTLR_T_RCD_MASK                         (0x7 << ddrcReg_CTLR_T_RCD_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_MASK          (0x7f << ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RFC_SHIFT                        0
+#define ddrcReg_CTLR_T_RFC_MASK                         (0x7f << ddrcReg_CTLR_T_RFC_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_SHIFT          8
+#define ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_MASK           (0x7 << ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RP_SHIFT                         0
+#define ddrcReg_CTLR_T_RP_MASK                          (0xf << ddrcReg_CTLR_T_RP_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_RRD_SHIFT                        0
+#define ddrcReg_CTLR_T_RRD_MASK                         (0xf << ddrcReg_CTLR_T_RRD_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_WR_SHIFT                         0
+#define ddrcReg_CTLR_T_WR_MASK                          (0x7 << ddrcReg_CTLR_T_WR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_WTR_SHIFT                        0
+#define ddrcReg_CTLR_T_WTR_MASK                         (0x7 << ddrcReg_CTLR_T_WTR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_XP_SHIFT                         0
+#define ddrcReg_CTLR_T_XP_MASK                          (0xff << ddrcReg_CTLR_T_XP_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_XSR_SHIFT                        0
+#define ddrcReg_CTLR_T_XSR_MASK                         (0xff << ddrcReg_CTLR_T_XSR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_ESR_SHIFT                        0
+#define ddrcReg_CTLR_T_ESR_MASK                         (0xff << ddrcReg_CTLR_T_ESR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_MEMORY_CFG2_WIDTH_MASK             (0x3 << 6)
+#define ddrcReg_CTLR_MEMORY_CFG2_WIDTH_16BITS           (0 << 6)
+#define ddrcReg_CTLR_MEMORY_CFG2_WIDTH_32BITS           (1 << 6)
+#define ddrcReg_CTLR_MEMORY_CFG2_WIDTH_64BITS           (2 << 6)
+
+#define ddrcReg_CTLR_MEMORY_CFG2_AXI_BANK_BITS_MASK     (0x3 << 4)
+#define ddrcReg_CTLR_MEMORY_CFG2_AXI_BANK_BITS_2        (0 << 4)
+#define ddrcReg_CTLR_MEMORY_CFG2_AXI_BANK_BITS_3        (3 << 4)
+
+#define ddrcReg_CTLR_MEMORY_CFG2_CKE_INIT_STATE_LOW     (0 << 3)
+#define ddrcReg_CTLR_MEMORY_CFG2_CKE_INIT_STATE_HIGH    (1 << 3)
+
+#define ddrcReg_CTLR_MEMORY_CFG2_DQM_INIT_STATE_LOW     (0 << 2)
+#define ddrcReg_CTLR_MEMORY_CFG2_DQM_INIT_STATE_HIGH    (1 << 2)
+
+#define ddrcReg_CTLR_MEMORY_CFG2_CLK_MASK               (0x3 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG2_CLK_ASYNC              (0 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG2_CLK_SYNC_A_LE_M        (1 << 0)
+#define ddrcReg_CTLR_MEMORY_CFG2_CLK_SYNC_A_GT_M        (3 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_SHIFT       0
+#define ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_MASK        (0x7 << ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_MASK          (0x1f << ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_FAW_PERIOD_SHIFT                 0
+#define ddrcReg_CTLR_T_FAW_PERIOD_MASK                  (0x1f << ddrcReg_CTLR_T_FAW_PERIOD_SHIFT)
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* ARM PL341 AXI ID QOS configuration registers, offset 0x100 */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+#define ddrcReg_CTLR_QOS_CNT                            16
+#define ddrcReg_CTLR_QOS_MAX                            (ddrcReg_CTLR_QOS_CNT - 1)
+
+       typedef struct {
+               uint32_t cfg[ddrcReg_CTLR_QOS_CNT];
+       } ddrcReg_CTLR_QOS_REG_t;
+
+#define ddrcReg_CTLR_QOS_REG_OFFSET                     0x100
+#define ddrcReg_CTLR_QOS_REGP                           ((volatile ddrcReg_CTLR_QOS_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_QOS_REG_OFFSET))
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_QOS_CFG_MAX_SHIFT                  2
+#define ddrcReg_CTLR_QOS_CFG_MAX_MASK                   (0xff << ddrcReg_CTLR_QOS_CFG_MAX_SHIFT)
+
+#define ddrcReg_CTLR_QOS_CFG_MIN_SHIFT                  1
+#define ddrcReg_CTLR_QOS_CFG_MIN_MASK                   (1 << ddrcReg_CTLR_QOS_CFG_MIN_SHIFT)
+
+#define ddrcReg_CTLR_QOS_CFG_ENABLE                     (1 << 0)
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* ARM PL341 Memory chip configuration registers, offset 0x200 */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+#define ddrcReg_CTLR_CHIP_CNT                           4
+#define ddrcReg_CTLR_CHIP_MAX                           (ddrcReg_CTLR_CHIP_CNT - 1)
+
+       typedef struct {
+               uint32_t cfg[ddrcReg_CTLR_CHIP_CNT];
+       } ddrcReg_CTLR_CHIP_REG_t;
+
+#define ddrcReg_CTLR_CHIP_REG_OFFSET                    0x200
+#define ddrcReg_CTLR_CHIP_REGP                          ((volatile ddrcReg_CTLR_CHIP_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_CHIP_REG_OFFSET))
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_CHIP_CFG_MEM_ORG_MASK              (1 << 16)
+#define ddrcReg_CTLR_CHIP_CFG_MEM_ORG_ROW_BANK_COL      (0 << 16)
+#define ddrcReg_CTLR_CHIP_CFG_MEM_ORG_BANK_ROW_COL      (1 << 16)
+
+#define ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MATCH_SHIFT      8
+#define ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MATCH_MASK       (0xff << ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MATCH_SHIFT)
+
+#define ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MASK_SHIFT       0
+#define ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MASK_MASK        (0xff << ddrcReg_CTLR_CHIP_CFG_AXI_ADDR_MASK_SHIFT)
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* ARM PL341 User configuration registers, offset 0x300 */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+#define ddrcReg_CTLR_USER_OUTPUT_CNT                    2
+
+       typedef struct {
+               uint32_t input;
+               uint32_t output[ddrcReg_CTLR_USER_OUTPUT_CNT];
+               uint32_t feature;
+       } ddrcReg_CTLR_USER_REG_t;
+
+#define ddrcReg_CTLR_USER_REG_OFFSET                    0x300
+#define ddrcReg_CTLR_USER_REGP                          ((volatile ddrcReg_CTLR_USER_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_USER_REG_OFFSET))
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_USER_INPUT_STATUS_SHIFT            0
+#define ddrcReg_CTLR_USER_INPUT_STATUS_MASK             (0xff << ddrcReg_CTLR_USER_INPUT_STATUS_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_USER_OUTPUT_CFG_SHIFT              0
+#define ddrcReg_CTLR_USER_OUTPUT_CFG_MASK               (0xff << ddrcReg_CTLR_USER_OUTPUT_CFG_SHIFT)
+
+#define ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_SHIFT      1
+#define ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_MASK       (1 << ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_BP134      (0 << ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_PL301      (1 << ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_REGISTERED ddrcReg_CTLR_USER_OUTPUT_0_CFG_SYNC_BRIDGE_PL301
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_CTLR_FEATURE_WRITE_BLOCK_DISABLE        (1 << 2)
+#define ddrcReg_CTLR_FEATURE_EARLY_BURST_RSP_DISABLE    (1 << 0)
+
+/*********************************************************************/
+/* Broadcom DDR23 PHY register definitions */
+/*********************************************************************/
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* Broadcom DDR23 PHY Address and Control register definitions */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+       typedef struct {
+               uint32_t revision;
+               uint32_t pmCtl;
+                REG32_RSVD(0x0008, 0x0010);
+               uint32_t pllStatus;
+               uint32_t pllCfg;
+               uint32_t pllPreDiv;
+               uint32_t pllDiv;
+               uint32_t pllCtl1;
+               uint32_t pllCtl2;
+               uint32_t ssCtl;
+               uint32_t ssCfg;
+               uint32_t vdlStatic;
+               uint32_t vdlDynamic;
+               uint32_t padIdle;
+               uint32_t pvtComp;
+               uint32_t padDrive;
+               uint32_t clkRgltrCtl;
+       } ddrcReg_PHY_ADDR_CTL_REG_t;
+
+#define ddrcReg_PHY_ADDR_CTL_REG_OFFSET                 0x0400
+#define ddrcReg_PHY_ADDR_CTL_REGP                       ((volatile ddrcReg_PHY_ADDR_CTL_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_ADDR_CTL_REG_OFFSET))
+
+/* @todo These SS definitions are duplicates of ones below */
+
+#define ddrcReg_PHY_ADDR_SS_CTRL_ENABLE                 0x00000001
+#define ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_MASK     0xFFFF0000
+#define ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_SHIFT    16
+#define ddrcReg_PHY_ADDR_SS_CFG_MIN_CYCLE_PER_TICK      10     /* Higher the value, lower the SS modulation frequency */
+#define ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_MASK     0x0000FFFF
+#define ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_SHIFT    0
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_SHIFT       8
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_MASK        (0xff << ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_SHIFT       0
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_MASK        (0xff << ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_CLK_PM_CTL_DDR_CLK_DISABLE (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_STATUS_LOCKED          (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_DIV2_CLK_RESET     (1 << 31)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_TEST_SEL_SHIFT     17
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_TEST_SEL_MASK      (0x1f << ddrcReg_PHY_ADDR_CTL_PLL_CFG_TEST_SEL_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_TEST_ENABLE        (1 << 16)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_BGAP_ADJ_SHIFT     12
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_BGAP_ADJ_MASK      (0xf << ddrcReg_PHY_ADDR_CTL_PLL_CFG_BGAP_ADJ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_VCO_RNG            (1 << 7)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_CH1_PWRDWN         (1 << 6)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_BYPASS_ENABLE      (1 << 5)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_CLKOUT_ENABLE      (1 << 4)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_D_RESET            (1 << 3)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_A_RESET            (1 << 2)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CFG_PWRDWN             (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_DITHER_MFB     (1 << 26)
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_PWRDWN         (1 << 25)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_MODE_SHIFT     20
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_MODE_MASK      (0x7 << ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_MODE_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_INT_SHIFT      8
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_INT_MASK       (0x1ff << ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_INT_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P2_SHIFT       4
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P2_MASK        (0xf << ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P2_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P1_SHIFT       0
+#define ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P1_MASK        (0xf << ddrcReg_PHY_ADDR_CTL_PLL_PRE_DIV_P1_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_SHIFT           24
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_MASK            (0xff << ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_SHIFT         0
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_MASK          (0xffffff << ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_TESTA_SHIFT       30
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_TESTA_MASK        (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_TESTA_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XS_SHIFT     27
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XS_MASK      (0x7 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XS_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XF_SHIFT     24
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XF_MASK      (0x7 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_KVCO_XF_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_LPF_BW_SHIFT      22
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_LPF_BW_MASK       (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_LPF_BW_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_LF_ORDER          (0x1 << 21)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CN_SHIFT          19
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CN_MASK           (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CN_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RN_SHIFT          17
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RN_MASK           (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RN_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CP_SHIFT          15
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CP_MASK           (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CP_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CZ_SHIFT          13
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CZ_MASK           (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_CZ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RZ_SHIFT          10
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RZ_MASK           (0x7 << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_RZ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICPX_SHIFT        5
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICPX_MASK         (0x1f << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICPX_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICP_OFF_SHIFT     0
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICP_OFF_MASK      (0x1f << ddrcReg_PHY_ADDR_CTL_PLL_CTL1_ICP_OFF_SHIFT)
+
+/* ----------------------------------------------------- */
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_SHIFT    4
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_MASK     (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_SHIFT    2
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_MASK     (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_LOWCUR_ENABLE     (0x1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_BIASIN_ENABLE     (0x1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_EN_ENABLE           (0x1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_SHIFT  16
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_MASK   (0xffff << ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_SHIFT      0
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_MASK       (0xffff << ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_FORCE           (1 << 20)
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_ENABLE          (1 << 16)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_FALL_SHIFT      12
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_FALL_MASK       (0x3 << ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_FALL_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_RISE_SHIFT      8
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_RISE_MASK       (0x3 << ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_RISE_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_STEP_SHIFT      0
+#define ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_STEP_MASK       (0x3f << ddrcReg_PHY_ADDR_CTL_VDL_STATIC_OVR_STEP_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_ENABLE         (1 << 16)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_FALL_SHIFT     12
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_FALL_MASK      (0x3 << ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_FALL_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_RISE_SHIFT     8
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_RISE_MASK      (0x3 << ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_RISE_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_STEP_SHIFT     0
+#define ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_STEP_MASK      (0x3f << ddrcReg_PHY_ADDR_CTL_VDL_DYNAMIC_OVR_STEP_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_ENABLE            (1u << 31)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_RXENB_DISABLE     (1 << 8)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CTL_IDDQ_DISABLE  (1 << 6)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CTL_REB_DISABLE   (1 << 5)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CTL_OEB_DISABLE   (1 << 4)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CKE_IDDQ_DISABLE  (1 << 2)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CKE_REB_DISABLE   (1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_PAD_IDLE_CKE_OEB_DISABLE   (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_PD_DONE           (1 << 30)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ND_DONE           (1 << 29)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_SAMPLE_DONE       (1 << 28)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_SAMPLE_AUTO_ENABLE    (1 << 27)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_SAMPLE_ENABLE     (1 << 26)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_OVR_ENABLE   (1 << 25)
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_OVR_ENABLE     (1 << 24)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_PD_SHIFT          20
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_PD_MASK           (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_PD_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ND_SHIFT          16
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ND_MASK           (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_ND_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_PD_SHIFT     12
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_PD_MASK      (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_PD_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_ND_SHIFT     8
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_ND_MASK      (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_ADDR_ND_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_PD_SHIFT       4
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_PD_MASK        (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_PD_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_ND_SHIFT       0
+#define ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_ND_MASK        (0xf << ddrcReg_PHY_ADDR_CTL_PVT_COMP_DQ_ND_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_RT60B            (1 << 4)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SEL_SSTL18       (1 << 3)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SELTXDRV_CI      (1 << 2)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SELRXDRV         (1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SLEW             (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_ADDR_CTL_CLK_RGLTR_CTL_PWR_HALF     (1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_CLK_RGLTR_CTL_PWR_OFF      (1 << 0)
+
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+/* Broadcom DDR23 PHY Byte Lane register definitions */
+/* -------------------------------------------------------------------- */
+/* -------------------------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_CNT                       2
+#define ddrcReg_PHY_BYTE_LANE_MAX                       (ddrcReg_CTLR_BYTE_LANE_CNT - 1)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_CNT               8
+
+       typedef struct {
+               uint32_t revision;
+               uint32_t vdlCalibrate;
+               uint32_t vdlStatus;
+                REG32_RSVD(0x000c, 0x0010);
+               uint32_t vdlOverride[ddrcReg_PHY_BYTE_LANE_VDL_OVR_CNT];
+               uint32_t readCtl;
+               uint32_t readStatus;
+               uint32_t readClear;
+               uint32_t padIdleCtl;
+               uint32_t padDriveCtl;
+               uint32_t padClkCtl;
+               uint32_t writeCtl;
+               uint32_t clkRegCtl;
+       } ddrcReg_PHY_BYTE_LANE_REG_t;
+
+/* There are 2 instances of the byte Lane registers, one for each byte lane. */
+#define ddrcReg_PHY_BYTE_LANE_1_REG_OFFSET              0x0500
+#define ddrcReg_PHY_BYTE_LANE_2_REG_OFFSET              0x0600
+
+#define ddrcReg_PHY_BYTE_LANE_1_REGP                    ((volatile ddrcReg_PHY_BYTE_LANE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_BYTE_LANE_1_REG_OFFSET))
+#define ddrcReg_PHY_BYTE_LANE_2_REGP                    ((volatile ddrcReg_PHY_BYTE_LANE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_BYTE_LANE_2_REG_OFFSET))
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_SHIFT      8
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_MASK       (0xff << ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_SHIFT      0
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_MASK       (0xff << ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_CLK_2CYCLE      (1 << 4)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_CLK_1CYCLE      (0 << 4)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_TEST            (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_ALWAYS          (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_ONCE            (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_FAST            (1 << 0)
+
+/* ----------------------------------------------------- */
+
+/* The byte lane VDL status calibTotal[9:0] is comprised of [9:4] step value, [3:2] fine fall */
+/* and [1:0] fine rise. Note that calibTotal[9:0] is located at bit 4 in the VDL status */
+/* register. The fine rise and fall are no longer used, so add some definitions for just */
+/* the step setting to simplify things. */
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_STEP_SHIFT     8
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_STEP_MASK      (0x3f << ddrcReg_PHY_BYTE_LANE_VDL_STATUS_STEP_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_TOTAL_SHIFT    4
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_TOTAL_MASK     (0x3ff << ddrcReg_PHY_BYTE_LANE_VDL_STATUS_TOTAL_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_LOCK           (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_VDL_STATUS_IDLE           (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_ENABLE            (1 << 16)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_FALL_SHIFT        12
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_FALL_MASK         (0x3 << ddrcReg_PHY_BYTE_LANE_VDL_OVR_FALL_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_RISE_SHIFT        8
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_RISE_MASK         (0x3 << ddrcReg_PHY_BYTE_LANE_VDL_OVR_RISE_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_STEP_SHIFT        0
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_STEP_MASK         (0x3f << ddrcReg_PHY_BYTE_LANE_VDL_OVR_STEP_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_STATIC_READ_DQS_P     0
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_STATIC_READ_DQS_N     1
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_STATIC_READ_EN        2
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_STATIC_WRITE_DQ_DQM   3
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_DYNAMIC_READ_DQS_P    4
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_DYNAMIC_READ_DQS_N    5
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_DYNAMIC_READ_EN       6
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_IDX_DYNAMIC_WRITE_DQ_DQM  7
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_SHIFT      8
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_MASK       (0x3 << ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DQ_ODT_ENABLE    (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DQ_ODT_ADJUST    (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_RD_ODT_ENABLE    (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_RD_ODT_ADJUST    (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_SHIFT   0
+#define ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_MASK    (0xf << ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_SHIFT)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CLEAR_STATUS         (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_ENABLE                   (1u << 31)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DM_RXENB_DISABLE         (1 << 19)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DM_IDDQ_DISABLE          (1 << 18)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DM_REB_DISABLE           (1 << 17)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DM_OEB_DISABLE           (1 << 16)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQ_RXENB_DISABLE         (1 << 15)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQ_IDDQ_DISABLE          (1 << 14)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQ_REB_DISABLE           (1 << 13)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQ_OEB_DISABLE           (1 << 12)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_READ_ENB_RXENB_DISABLE   (1 << 11)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_READ_ENB_IDDQ_DISABLE    (1 << 10)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_READ_ENB_REB_DISABLE     (1 << 9)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_READ_ENB_OEB_DISABLE     (1 << 8)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQS_RXENB_DISABLE        (1 << 7)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQS_IDDQ_DISABLE         (1 << 6)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQS_REB_DISABLE          (1 << 5)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_DQS_OEB_DISABLE          (1 << 4)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_CLK_RXENB_DISABLE        (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_CLK_IDDQ_DISABLE         (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_CLK_REB_DISABLE          (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_PAD_IDLE_CTL_CLK_OEB_DISABLE          (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_RT60B_DDR_READ_ENB      (1 << 5)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_RT60B                   (1 << 4)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SEL_SSTL18              (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SELTXDRV_CI             (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SELRXDRV                (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SLEW                    (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_PAD_CLK_CTL_DISABLE                   (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_WRITE_CTL_PREAMBLE_DDR3               (1 << 0)
+
+/* ----------------------------------------------------- */
+
+#define ddrcReg_PHY_BYTE_LANE_CLK_REG_CTL_PWR_HALF                  (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_CLK_REG_CTL_PWR_OFF                   (1 << 0)
+
+/*********************************************************************/
+/* ARM PL341 DDRC to Broadcom DDR23 PHY glue register definitions */
+/*********************************************************************/
+
+       typedef struct {
+               uint32_t cfg;
+               uint32_t actMonCnt;
+               uint32_t ctl;
+               uint32_t lbistCtl;
+               uint32_t lbistSeed;
+               uint32_t lbistStatus;
+               uint32_t tieOff;
+               uint32_t actMonClear;
+               uint32_t status;
+               uint32_t user;
+       } ddrcReg_CTLR_PHY_GLUE_REG_t;
+
+#define ddrcReg_CTLR_PHY_GLUE_OFFSET                            0x0700
+#define ddrcReg_CTLR_PHY_GLUE_REGP                              ((volatile ddrcReg_CTLR_PHY_GLUE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_PHY_GLUE_OFFSET))
+
+/* ----------------------------------------------------- */
+
+/* DDR2 / AXI block phase alignment interrupt control */
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT                     18
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_MASK                      (0x3 << ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_OFF                       (0 << ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_ON_TIGHT                  (1 << ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_ON_MEDIUM                 (2 << ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_INT_ON_LOOSE                  (3 << ddrcReg_CTLR_PHY_GLUE_CFG_INT_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_SHIFT              17
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_MASK               (1 << ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_DIFFERENTIAL       (0 << ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_CMOS               (1 << ddrcReg_CTLR_PHY_GLUE_CFG_PLL_REFCLK_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHIFT            16
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_MASK             (1 << ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_DEEP             (0 << ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHALLOW          (1 << ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_HW_FIXED_ALIGNMENT_DISABLED   ddrcReg_CTLR_PHY_GLUE_CFG_DIV2CLK_TREE_SHALLOW
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_SHIFT             15
+#define ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_MASK              (1 << ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_BP134             (0 << ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_PL301             (1 << ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_REGISTERED        ddrcReg_CTLR_PHY_GLUE_CFG_SYNC_BRIDGE_PL301
+
+/* Software control of PHY VDL updates from control register settings. Bit 13 enables the use of Bit 14. */
+/* If software control is not enabled, then updates occur when a refresh command is issued by the hardware */
+/* controller. If 2 chips selects are being used, then software control must be enabled. */
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_VDL_UPDATE_SW_CTL_LOAD    (1 << 14)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_VDL_UPDATE_SW_CTL_ENABLE  (1 << 13)
+
+/* Use these to bypass a pipeline stage. By default the ADDR is off but the BYTE LANE in / out are on. */
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_ADDR_CTL_IN_BYPASS_PIPELINE_STAGE (1 << 12)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_BYTE_LANE_IN_BYPASS_PIPELINE_STAGE (1 << 11)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_BYTE_LANE_OUT_BYPASS_PIPELINE_STAGE (1 << 10)
+
+/* Chip select count */
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_SHIFT                  9
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_MASK                   (1 << ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_1                      (0 << ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_2                      (1 << ddrcReg_CTLR_PHY_GLUE_CFG_CS_CNT_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CLK_SHIFT                     8
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CLK_ASYNC                     (0 << ddrcReg_CTLR_PHY_GLUE_CFG_CLK_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CLK_SYNC                      (1 << ddrcReg_CTLR_PHY_GLUE_CFG_CLK_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CKE_INIT_SHIFT                7
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CKE_INIT_LOW                  (0 << ddrcReg_CTLR_PHY_GLUE_CFG_CKE_INIT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CKE_INIT_HIGH                 (1 << ddrcReg_CTLR_PHY_GLUE_CFG_CKE_INIT_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DQM_INIT_SHIFT                6
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DQM_INIT_LOW                  (0 << ddrcReg_CTLR_PHY_GLUE_CFG_DQM_INIT_SHIFT)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_DQM_INIT_HIGH                 (1 << ddrcReg_CTLR_PHY_GLUE_CFG_DQM_INIT_SHIFT)
+
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CAS_LATENCY_SHIFT             0
+#define ddrcReg_CTLR_PHY_GLUE_CFG_CAS_LATENCY_MASK              (0x7 << ddrcReg_CTLR_PHY_GLUE_CFG_CAS_LATENCY_SHIFT)
+
+/* ----------------------------------------------------- */
+#define ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_SHIFT                0
+#define ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_MASK                 (0x7f << ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_SHIFT)
+
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#ifdef __cplusplus
+}                              /* end extern "C" */
+#endif
+#endif                         /* DDRC_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h b/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
new file mode 100644
index 0000000..cfa91be
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
@@ -0,0 +1,73 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+#ifndef CSP_HW_CFG_H
+#define CSP_HW_CFG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <cfg_global.h>
+#include <mach/csp/cap_inline.h>
+
+#if defined(__KERNEL__)
+#include <mach/memory_settings.h>
+#else
+#include <hw_cfg.h>
+#endif
+
+/* Some items that can be defined externally, but will be set to default values */
+/* if they are not defined. */
+/*      HW_CFG_PLL_SPREAD_SPECTRUM_DISABLE   Default undefined and SS is enabled. */
+/*      HW_CFG_SDRAM_CAS_LATENCY        5    Default 5, Values [3..6] */
+/*      HW_CFG_SDRAM_CHIP_SELECT_CNT    1    Default 1, Vaules [1..2] */
+/*      HW_CFG_SDRAM_SPEED_GRADE        667  Default 667, Values [400,533,667,800] */
+/*      HW_CFG_SDRAM_WIDTH_BITS         16   Default 16, Vaules [8,16] */
+/*      HW_CFG_SDRAM_ADDR_BRC                Default undefined and Row-Bank-Col (RBC) addressing used. Define to use Bank-Row-Col (BRC). */
+/*      HW_CFG_SDRAM_CLK_ASYNC               Default undefined and DDR clock is synchronous with AXI BUS clock. Define for ASYNC mode. */
+
+#if defined(CFG_GLOBAL_CHIP)
+  #if (CFG_GLOBAL_CHIP == FPGA11107)
+     #define HW_CFG_BUS_CLK_HZ            5000000
+     #define HW_CFG_DDR_CTLR_CLK_HZ      10000000
+     #define HW_CFG_DDR_PHY_OMIT
+     #define HW_CFG_UART_CLK_HZ           7500000
+  #else
+     #define HW_CFG_PLL_VCO_HZ           2000000000
+     #define HW_CFG_PLL2_VCO_HZ          1800000000
+     #define HW_CFG_ARM_CLK_HZ            CAP_HW_CFG_ARM_CLK_HZ
+     #define HW_CFG_BUS_CLK_HZ            166666666
+     #define HW_CFG_DDR_CTLR_CLK_HZ       333333333
+     #define HW_CFG_DDR_PHY_CLK_HZ        (2 * HW_CFG_DDR_CTLR_CLK_HZ)
+     #define HW_CFG_UART_CLK_HZ           142857142
+     #define HW_CFG_VPM_CLK_HZ            CAP_HW_CFG_VPM_CLK_HZ
+  #endif
+#else
+   #define HW_CFG_PLL_VCO_HZ           1800000000
+   #define HW_CFG_PLL2_VCO_HZ          1800000000
+   #define HW_CFG_ARM_CLK_HZ            450000000
+   #define HW_CFG_BUS_CLK_HZ            150000000
+   #define HW_CFG_DDR_CTLR_CLK_HZ       300000000
+   #define HW_CFG_DDR_PHY_CLK_HZ        (2 * HW_CFG_DDR_CTLR_CLK_HZ)
+   #define HW_CFG_UART_CLK_HZ           150000000
+   #define HW_CFG_VPM_CLK_HZ            300000000
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif /* CSP_HW_CFG_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h b/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
new file mode 100644
index 0000000..d15f5f3
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
@@ -0,0 +1,100 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    secHw_def.h
+*
+*  @brief   Definitions for configuring/testing secure blocks
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef SECHW_DEF_H
+#define SECHW_DEF_H
+
+#include <mach/csp/mm_io.h>
+
+/* Bit mask for various secure device */
+#define secHw_BLK_MASK_CHIP_CONTROL     0x00000001
+#define secHw_BLK_MASK_KEY_SCAN         0x00000002
+#define secHw_BLK_MASK_TOUCH_SCREEN     0x00000004
+#define secHw_BLK_MASK_UART0            0x00000008
+#define secHw_BLK_MASK_UART1            0x00000010
+#define secHw_BLK_MASK_WATCHDOG         0x00000020
+#define secHw_BLK_MASK_SPUM             0x00000040
+#define secHw_BLK_MASK_DDR2             0x00000080
+#define secHw_BLK_MASK_EXT_MEM          0x00000100
+#define secHw_BLK_MASK_ESW              0x00000200
+#define secHw_BLK_MASK_SPU              0x00010000
+#define secHw_BLK_MASK_PKA              0x00020000
+#define secHw_BLK_MASK_RNG              0x00040000
+#define secHw_BLK_MASK_RTC              0x00080000
+#define secHw_BLK_MASK_OTP              0x00100000
+#define secHw_BLK_MASK_BOOT             0x00200000
+#define secHw_BLK_MASK_MPU              0x00400000
+#define secHw_BLK_MASK_TZCTRL           0x00800000
+#define secHw_BLK_MASK_INTR             0x01000000
+
+/* Trustzone register set */
+typedef struct {
+       volatile uint32_t status;       /* read only - reflects status of writes of 2 write registers */
+       volatile uint32_t setUnsecure;  /* write only. reads back as 0 */
+       volatile uint32_t setSecure;    /* write only. reads back as 0 */
+} secHw_TZREG_t;
+
+/* There are 2 register sets. The first is for the lower 16 bits, the 2nd */
+/* is for the higher 16 bits. */
+
+typedef enum {
+       secHw_IDX_LS = 0,
+       secHw_IDX_MS = 1,
+       secHw_IDX_NUM
+} secHw_IDX_e;
+
+typedef struct {
+       volatile secHw_TZREG_t reg[secHw_IDX_NUM];
+} secHw_REGS_t;
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setSecure(uint32_t mask       /*  mask of type secHw_BLK_MASK_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a non-secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setUnsecure(uint32_t mask     /*  mask of type secHw_BLK_MASK_XXXXXX */
+    );
+
+/****************************************************************************/
+/**
+*  @brief  Get the trustzone status for all components. 1 = non-secure, 0 = secure
+*
+*/
+/****************************************************************************/
+static inline uint32_t secHw_getStatus(void);
+
+#include <mach/csp/secHw_inline.h>
+
+#endif /* SECHW_DEF_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
new file mode 100644
index 0000000..9cd6a03
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
@@ -0,0 +1,79 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    secHw_inline.h
+*
+*  @brief   Definitions for configuring/testing secure blocks
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef SECHW_INLINE_H
+#define SECHW_INLINE_H
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setSecure(uint32_t mask       /*  mask of type secHw_BLK_MASK_XXXXXX */
+    ) {
+       secHw_REGS_t *regp = (secHw_REGS_t *) MM_IO_BASE_TZPC;
+
+       if (mask & 0x0000FFFF) {
+               regp->reg[secHw_IDX_LS].setSecure = mask & 0x0000FFFF;
+       }
+
+       if (mask & 0xFFFF0000) {
+               regp->reg[secHw_IDX_MS].setSecure = mask >> 16;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a non-secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setUnsecure(uint32_t mask     /*  mask of type secHw_BLK_MASK_XXXXXX */
+    ) {
+       secHw_REGS_t *regp = (secHw_REGS_t *) MM_IO_BASE_TZPC;
+
+       if (mask & 0x0000FFFF) {
+               regp->reg[secHw_IDX_LS].setUnsecure = mask & 0x0000FFFF;
+       }
+       if (mask & 0xFFFF0000) {
+               regp->reg[secHw_IDX_MS].setUnsecure = mask >> 16;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief  Get the trustzone status for all components. 1 = non-secure, 0 = secure
+*
+*/
+/****************************************************************************/
+static inline uint32_t secHw_getStatus(void)
+{
+       secHw_REGS_t *regp = (secHw_REGS_t *) MM_IO_BASE_TZPC;
+
+       return (regp->reg[1].status << 16) + regp->reg[0].status;
+}
+
+#endif /* SECHW_INLINE_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
new file mode 100644
index 0000000..a928b84
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
@@ -0,0 +1,361 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef _UARTHW_INLINE_H
+#define _UARTHW_INLINE_H
+
+#ifndef _UARTHW_H
+#error *** Do not include uartHw_inline.h directly. Use uartHw.h instead. ***
+#endif
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/reg.h>
+#include <csp/uartHw.h>
+#include <mach/csp/uartHw_reg.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define uartHw_DEV_MIN          0
+#define uartHw_DEV_MAX          1
+#define uartHw_DEV_CNT          (uartHw_DEV_MAX - uartHw_DEV_MIN + 1)
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+/*****************************************************************************
+* CTS signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_CtsFlowCtrlDisable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_HW_FLOWCTRL_CTS;
+}
+
+static inline void uartHw_CtsFlowCtrlEnable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_HW_FLOWCTRL_CTS;
+}
+
+static inline int uartHw_CtsStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               flag & UARTHW_REG_FLAG_CTS ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+/*****************************************************************************
+* DCD signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DcdStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               flag & UARTHW_REG_FLAG_DCD ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+/*****************************************************************************
+* DSR signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DsrStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               flag & UARTHW_REG_FLAG_DSR ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+/*****************************************************************************
+* DTR signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DtrStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               ctrl & UARTHW_REG_CTRL_DTR_ACTIVE ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+static inline void uartHw_DtrStateSet(unsigned uartNum, unsigned state)
+{
+       if (state == uartHw_STATE_ACTIVE) {
+               uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_DTR_ACTIVE;
+       } else {
+               uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_DTR_ACTIVE;
+       }
+}
+
+/*****************************************************************************
+* Loopback mode routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_LoopbackDisable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_LOOPBK_ENABLE;
+}
+
+static inline void uartHw_LoopbackEnable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_LOOPBK_ENABLE;
+}
+
+/*****************************************************************************
+* RI signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_RiStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               flag & UARTHW_REG_FLAG_RI ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+/*****************************************************************************
+* RTS signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RtsFlowCtrlDisable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_HW_FLOWCTRL_RTS;
+}
+
+static inline void uartHw_RtsFlowCtrlEnable(unsigned uartNum)
+{
+       uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_HW_FLOWCTRL_RTS;
+}
+
+static inline int uartHw_RtsStateGet(unsigned uartNum)
+{
+       return uartRegP(uartNum)->
+               ctrl & UARTHW_REG_CTRL_RTS_ACTIVE ? uartHw_STATE_ACTIVE :
+               uartHw_STATE_INACTIVE;
+}
+
+static inline void uartHw_RtsStateSet(unsigned uartNum, unsigned state)
+{
+       if (state == uartHw_STATE_ACTIVE) {
+               uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_RTS_ACTIVE;
+       } else {
+               uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_RTS_ACTIVE;
+       }
+}
+
+/*****************************************************************************
+* UART Rx FIFO DMA routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RxFifoDmaDisable(unsigned uartNum)
+{
+       uartRegP(uartNum)->dmaCtrl &= ~UARTHW_REG_DMA_CTRL_RX_ENABLE;
+}
+
+static inline void uartHw_RxFifoDmaEnable(unsigned uartNum)
+{
+       uartRegP(uartNum)->dmaCtrl |= UARTHW_REG_DMA_CTRL_RX_ENABLE;
+}
+
+static inline uint32_t uartHw_RxFifoDmaAddrGet(unsigned uartNum)
+{
+       //* @todo Ensure physical address returned */
+       return (uint32_t) &uartRegP(uartNum)->fifo;
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_RxFifoFull(unsigned uartNum)
+{
+       return uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_FULL;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Test if byte available to read from Fifo
+*
+*  @note
+*
+*  @return
+*   1 : data available
+*   0 : no data available
+*
+*/
+/****************************************************************************/
+static inline int uartHw_RxFifoReady(unsigned uartNum  /* [IN]  uart number (0 .. max) */
+    ) {
+       if (uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_EMPTY) {
+               return 0;
+       } else {
+               return 1;
+       }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Read Rx data from specified UART
+*
+*  @note    Blocks until Rx data is available
+*
+*  @return
+*   On success: Rx data value
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_RxFifoGet(unsigned uartNum    /* [IN]  uart number (0 .. max) */
+    ) {
+       while (uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_EMPTY) {
+               /* wait until rx fifo not empty */
+       }
+       return uartRegP(uartNum)->fifo & UARTHW_REG_FIFO_DATA_MASK;
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RxFifoThresholdSet(unsigned uartNum, unsigned byteCnt)
+{
+       uint32_t level;
+
+       switch (byteCnt) {
+       case 4:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_8;
+               break;
+       case 8:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_4;
+               break;
+       case 16:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_2;
+               break;
+       case 24:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_3_4;
+               break;
+       case 28:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_7_8;
+               break;
+
+       default:
+               //* @todo Maybe return an -errno to handle this situation. */
+               return;
+       }
+
+       uartRegP(uartNum)->intrFifoLevel &= ~UARTHW_REG_INTR_FIFO_LEVEL_RX_MASK;
+       uartRegP(uartNum)->intrFifoLevel |=
+           ((level << UARTHW_REG_INTR_FIFO_LEVEL_RX_SHIFT) &
+            UARTHW_REG_INTR_FIFO_LEVEL_RX_MASK);
+}
+
+/*****************************************************************************
+* UART Rx FIFO DMA routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_TxFifoDmaDisable(unsigned uartNum)
+{
+       uartRegP(uartNum)->dmaCtrl &= ~UARTHW_REG_DMA_CTRL_TX_ENABLE;
+}
+
+static inline void uartHw_TxFifoDmaEnable(unsigned uartNum)
+{
+       uartRegP(uartNum)->dmaCtrl |= UARTHW_REG_DMA_CTRL_TX_ENABLE;
+}
+
+static inline uint32_t uartHw_TxFifoDmaAddrGet(unsigned uartNum)
+{
+       //* @todo Ensure physical address returned */
+       return (uint32_t) &uartRegP(uartNum)->fifo;
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_TxFifoEmpty(unsigned uartNum)
+{
+       return uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_EMPTY;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Write Tx data to specified UART
+*
+*  @note    Blocks until able to write Tx data.  This does not append a newling
+*
+*  @return
+*   On success: 0
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_TxFifoPut(unsigned uartNum,   /* [IN]  uart number (0 .. max) */
+                                  unsigned value       /* [IN]  output value */
+    ) {
+       while (uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_FULL) {
+       }
+
+       uartRegP(uartNum)->fifo = value;
+       return 0;
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_TxFifoThresholdSet(unsigned uartNum, unsigned byteCnt)
+{
+       uint32_t level;
+
+       switch (byteCnt) {
+       case 4:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_8;
+               break;
+       case 8:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_4;
+               break;
+       case 16:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_1_2;
+               break;
+       case 24:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_3_4;
+               break;
+       case 28:
+               level = UARTHW_REG_INTR_FIFO_LEVEL_7_8;
+               break;
+
+       default:
+               //* @todo Maybe return an -errno to handle this situation. */
+               return;
+       }
+
+       uartRegP(uartNum)->intrFifoLevel &= ~UARTHW_REG_INTR_FIFO_LEVEL_TX_MASK;
+       uartRegP(uartNum)->intrFifoLevel |=
+           ((level << UARTHW_REG_INTR_FIFO_LEVEL_TX_SHIFT) &
+            UARTHW_REG_INTR_FIFO_LEVEL_TX_MASK);
+}
+
+/****************************************************************************/
+/**
+*  @brief   Wait util specified UART has finished Tx
+*
+*  @note    Blocks until Tx line is idle and Tx FIFO empty.
+*
+*  @return
+*   On success: 0
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_TxWaitIdle(unsigned uartNum   /* [IN]  uart number (0 .. max) */
+    ) {
+       /* Wait for the tx fifo to be empty */
+       while ((uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_EMPTY) == 0) {
+       }
+
+       /* Wait for the final character to be sent on the txd line */
+       while (uartRegP(uartNum)->flag & UARTHW_REG_FLAG_BUSY) {
+       }
+
+       return 0;
+}
+
+#endif /* _UARTHW_INLINE_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h
new file mode 100644
index 0000000..ead7ddd
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h
@@ -0,0 +1,169 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    xxx.h
+*
+*  @brief   short desc
+*
+*  more detail.
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _UARTHW_REG_H
+#define _UARTHW_REG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/reg.h>
+
+#include <mach/csp/mm_io.h>
+#include <mach/csp/uartHw_reg.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define UARTHW_REG_FIFO_OFFSET                0x0000
+#define UARTHW_REG_FIFO_ERR_OVERRUN           (1 << 11)
+#define UARTHW_REG_FIFO_ERR_BREAK             (1 << 10)
+#define UARTHW_REG_FIFO_ERR_PARITY            (1 << 9)
+#define UARTHW_REG_FIFO_ERR_FRAME             (1 << 8)
+#define UARTHW_REG_FIFO_DATA_MASK             0xff
+
+#define UARTHW_REG_RX_STATUS_OFFSET           0x0004
+#define UARTHW_REG_RX_STATUS_ERR_OVERRUN      (1 << 3)
+#define UARTHW_REG_RX_STATUS_ERR_BREAK        (1 << 2)
+#define UARTHW_REG_RX_STATUS_ERR_PARITY       (1 << 1)
+#define UARTHW_REG_RX_STATUS_ERR_FRAME        (1 << 0)
+
+#define UARTHW_REG_RSVD_1_OFFSET              0x0008
+#define UARTHW_REG_RSVD_2_OFFSET              0x000c
+#define UARTHW_REG_RSVD_3_OFFSET              0x0010
+#define UARTHW_REG_RSVD_4_OFFSET              0x0014
+
+#define UARTHW_REG_FLAG_OFFSET                0x0018
+#define UARTHW_REG_FLAG_RI                    (1 << 8)
+#define UARTHW_REG_FLAG_TX_EMPTY              (1 << 7)
+#define UARTHW_REG_FLAG_RX_FULL               (1 << 6)
+#define UARTHW_REG_FLAG_TX_FULL               (1 << 5)
+#define UARTHW_REG_FLAG_RX_EMPTY              (1 << 4)
+#define UARTHW_REG_FLAG_BUSY                  (1 << 3)
+#define UARTHW_REG_FLAG_DCD                   (1 << 2)
+#define UARTHW_REG_FLAG_DSR                   (1 << 1)
+#define UARTHW_REG_FLAG_CTS                   (1 << 0)
+
+#define UARTHW_REG_RSVD_5_OFFSET              0x001c
+
+#define UARTHW_REG_IRDA_LOWPWR_OFFSET         0x0020
+
+#define UARTHW_REG_BAUD_INT_OFFSET            0x0024
+#define UARTHW_REG_BAUD_INT_MASK              0xffff
+
+#define UARTHW_REG_BAUD_FRAC_OFFSET           0x0028
+#define UARTHW_REG_BAUD_FRAC_MASK             0x3f
+
+#define UARTHW_REG_LINECTRL_OFFSET            0x002c
+#define UARTHW_REG_LINECTRL_PARITY_STICK      (1 << 7)
+#define UARTHW_REG_LINECTRL_WORDLEN_MASK      (0x3 << 5)
+#define UARTHW_REG_LINECTRL_WORDLEN_BITS_8    (0x3 << 5)
+#define UARTHW_REG_LINECTRL_WORDLEN_BITS_7    (0x2 << 5)
+#define UARTHW_REG_LINECTRL_WORDLEN_BITS_6    (0x1 << 5)
+#define UARTHW_REG_LINECTRL_WORDLEN_BITS_5    (0x0 << 5)
+#define UARTHW_REG_LINECTRL_FIFO_ENABLE       (1 << 4)
+#define UARTHW_REG_LINECTRL_STOP_BITS_2       (1 << 3)
+#define UARTHW_REG_LINECTRL_STOP_BITS_1       0
+#define UARTHW_REG_LINECTRL_PARITY_EVEN       (1 << 2)
+#define UARTHW_REG_LINECTRL_PARITY_ENABLE     (1 << 1)
+#define UARTHW_REG_LINECTRL_PARITY_DISABLE    0
+#define UARTHW_REG_LINECTRL_BREAK_ENABLE      (1 << 0)
+
+#define UARTHW_REG_CTRL_OFFSET                0x0030
+#define UARTHW_REG_CTRL_HW_FLOWCTRL_CTS       (1 << 15)
+#define UARTHW_REG_CTRL_HW_FLOWCTRL_RTS       (1 << 14)
+#define UARTHW_REG_CTRL_OUT2_ACTIVE           (1 << 13)
+#define UARTHW_REG_CTRL_OUT1_ACTIVE           (1 << 12)
+#define UARTHW_REG_CTRL_RTS_ACTIVE            (1 << 11)
+#define UARTHW_REG_CTRL_DTR_ACTIVE            (1 << 10)
+#define UARTHW_REG_CTRL_RX_ENABLE             (1 << 9)
+#define UARTHW_REG_CTRL_TX_ENABLE             (1 << 8)
+#define UARTHW_REG_CTRL_LOOPBK_ENABLE         (1 << 7)
+#define UARTHW_REG_CTRL_SIR_LOWPWR            (1 << 2)
+#define UARTHW_REG_CTRL_SIR_ENABLE            (1 << 1)
+#define UARTHW_REG_CTRL_UART_ENABLE           (1 << 0)
+
+#define UARTHW_REG_INTR_FIFO_LEVEL_OFFSET     0x0034
+#define UARTHW_REG_INTR_FIFO_LEVEL_RX_SHIFT   3
+#define UARTHW_REG_INTR_FIFO_LEVEL_RX_MASK    (0x7 << UARTHW_REG_INTR_FIFO_LEVEL_RX_SHIFT)
+#define UARTHW_REG_INTR_FIFO_LEVEL_TX_SHIFT   0
+#define UARTHW_REG_INTR_FIFO_LEVEL_TX_MASK    (0x7 << UARTHW_REG_INTR_FIFO_LEVEL_TX_SHIFT)
+
+#define UARTHW_REG_INTR_FIFO_LEVEL_1_8        0
+#define UARTHW_REG_INTR_FIFO_LEVEL_1_4        1
+#define UARTHW_REG_INTR_FIFO_LEVEL_1_2        2
+#define UARTHW_REG_INTR_FIFO_LEVEL_3_4        3
+#define UARTHW_REG_INTR_FIFO_LEVEL_7_8        4
+
+/** @todo: bit field definitions for the following registers */
+
+#define UARTHW_REG_INTR_CTRL_MASK_OFFSET      0x0038
+
+#define UARTHW_REG_INTR_STATUS_RAW_OFFSET     0x003c
+
+#define UARTHW_REG_INTR_STATUS_MASK_OFFSET    0x0040
+
+#define UARTHW_REG_INTR_CLEAR_OFFSET          0x0044
+
+#define UARTHW_REG_DMA_CTRL_OFFSET            0x0048
+#define UARTHW_REG_DMA_CTRL_RX_ON_ERROR       (1 << 2)
+#define UARTHW_REG_DMA_CTRL_TX_ENABLE         (1 << 1)
+#define UARTHW_REG_DMA_CTRL_RX_ENABLE         (1 << 0)
+
+typedef struct {
+       uint32_t fifo;
+       uint32_t rxStatus;
+
+        REG32_RSVD(0x0008, 0x0018);
+
+       uint32_t flag;
+
+        REG32_RSVD(0x001c, 0x0020);
+
+       uint32_t irdaLowPwr;
+       uint32_t baudInteger;
+       uint32_t baudFraction;
+       uint32_t lineCtrl;
+       uint32_t ctrl;
+       uint32_t intrFifoLevel;
+       uint32_t intrCtrlMask;
+       uint32_t intrStatusRaw;
+       uint32_t intrStatusMask;
+       uint32_t intrClear;
+       uint32_t dmaCtrl;
+
+        REG32_RSVD(0x004c, 0x0100);
+
+       /* Although a dmaFifo is defined and accessible, it is not part of the PL011 IP nor is it necessary. */
+       /* DMA operations work just fine with the standard PL011 fifo, so this is not used. */
+       uint32_t dmaFifo;
+} UARTHW_REG_t;
+
+#define  uartRegP(x) (x ? ((volatile UARTHW_REG_t *)MM_IO_BASE_UARTB) : ((volatile UARTHW_REG_t *)MM_IO_BASE_UARTA))
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /* _UARTHW_REG_H */
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.



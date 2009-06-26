Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZFZXbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZFZXbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZFZXb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:31:28 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3188 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061AbZFZXbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:31:12 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 16:30:58 -0700
Subject: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn2tiie9oZgr/i4QByVFXooHgK/lg==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665B85B24CG6976764-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The last patch. This big patch includes the minimal set of our CSP (chip support package), which is our OS independent chip supporting code and headers.  All the codes are under arch/arm/mach-bcmring directory.

>From 115e0e92a73253291b00ebb5eabdc133e27c8d37 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 15:48:25 -0700
Subject: [PATCH 6/6] add bcmring csp source and headers under arch/arm/mach-bcmring

---
 arch/arm/mach-bcmring/csp/Makefile                 |    3 +
 arch/arm/mach-bcmring/csp/chipc/Makefile           |    1 +
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |  857 ++++++++++
 .../mach-bcmring/csp/chipc/chipcHw_clkreconfig.c   |  247 +++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c     |  280 ++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c    |  127 ++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |   67 +
 arch/arm/mach-bcmring/csp/dmac/Makefile            |    1 +
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c            | 1007 ++++++++++++
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c      | 1040 ++++++++++++
 arch/arm/mach-bcmring/csp/tmr/Makefile             |    1 +
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c              |  676 ++++++++
 arch/arm/mach-bcmring/include/csp/cache.h          |   37 +
 arch/arm/mach-bcmring/include/csp/delay.h          |   40 +
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |  703 ++++++++
 arch/arm/mach-bcmring/include/csp/errno.h          |   36 +
 arch/arm/mach-bcmring/include/csp/intcHw.h         |   46 +
 arch/arm/mach-bcmring/include/csp/module.h         |   33 +
 arch/arm/mach-bcmring/include/csp/reg.h            |  120 ++
 arch/arm/mach-bcmring/include/csp/secHw.h          |   79 +
 arch/arm/mach-bcmring/include/csp/stdint.h         |   34 +
 arch/arm/mach-bcmring/include/csp/tmrHw.h          |  319 ++++
 arch/arm/mach-bcmring/include/csp/uartHw.h         |  329 ++++
 arch/arm/mach-bcmring/include/mach/csp/cap.h       |   66 +
 .../arm/mach-bcmring/include/mach/csp/cap_inline.h |  421 +++++
 .../mach-bcmring/include/mach/csp/chipcHw_def.h    | 1293 +++++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_inline.h | 1702 ++++++++++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h    |  552 +++++++
 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h   |  901 +++++++++++
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |  164 ++
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |  430 +++++
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h    |   78 +
 .../arm/mach-bcmring/include/mach/csp/intcHw_reg.h |  260 +++
 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h   |  105 ++
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h     |  166 ++
 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h |  122 ++
 .../mach-bcmring/include/mach/csp/secHw_inline.h   |   93 ++
 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h |   88 +
 .../mach-bcmring/include/mach/csp/uartHw_inline.h  |  358 ++++
 .../arm/mach-bcmring/include/mach/csp/uartHw_reg.h |  177 ++
 40 files changed, 13059 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/csp/Makefile
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/Makefile
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
 create mode 100644 arch/arm/mach-bcmring/csp/dmac/Makefile
 create mode 100644 arch/arm/mach-bcmring/csp/dmac/dmacHw.c
 create mode 100644 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
 create mode 100644 arch/arm/mach-bcmring/csp/tmr/Makefile
 create mode 100644 arch/arm/mach-bcmring/csp/tmr/tmrHw.c
 create mode 100644 arch/arm/mach-bcmring/include/csp/cache.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/delay.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/dmacHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/errno.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/intcHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/module.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/reg.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/secHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/stdint.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/tmrHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/uartHw.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_io.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h

diff --git a/arch/arm/mach-bcmring/csp/Makefile b/arch/arm/mach-bcmring/csp/Makefile
new file mode 100644
index 0000000..648c037
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/Makefile
@@ -0,0 +1,3 @@
+obj-y += dmac/
+obj-y += tmr/
+obj-y += chipc/
diff --git a/arch/arm/mach-bcmring/csp/chipc/Makefile b/arch/arm/mach-bcmring/csp/chipc/Makefile
new file mode 100644
index 0000000..6739527
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/Makefile
@@ -0,0 +1 @@
+obj-y += chipcHw.o chipcHw_str.o chipcHw_reset.o chipcHw_init.o
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
new file mode 100644
index 0000000..f358d26
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
@@ -0,0 +1,857 @@
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
+/****************************************************************************/
+/**
+*  @file    chipcHw.c
+*
+*  @brief   Low level Various CHIP clock controlling routines
+*
+*  @note
+*
+*   These routines provide basic clock controlling functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/stdint.h>
+#include <csp/module.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <csp/reg.h>
+#include <csp/delay.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+
+// VPM alignment algorithm uses this
+#define MAX_PHASE_ADJUST_COUNT         0xFFFF         /* Max number of times allowed to adjust the phase */
+#define MAX_PHASE_ALIGN_ATTEMPTS       10              /* Max number of attempt to align the phase */
+
+/* Local definition of clock type */
+#define PLL_CLOCK                      1              /* PLL Clock */
+#define NON_PLL_CLOCK                  2              /* Divider clock */
+
+
+#define WAIT()       asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop"); \
+                     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop"); \
+                     asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop");asm("nop")
+
+
+static int chipcHw_divide(int num, int denom) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief   Set clock fequency for miscellaneous configurable clocks
+*
+*  This function sets clock frequency
+*
+*  @return  Configured clock frequency in hertz
+*
+*/
+/****************************************************************************/
+chipcHw_freq  chipcHw_getClockFrequency
+(
+    chipcHw_CLOCK_e clock         ///<  [ IN ] Configurable clock
+)
+{
+   volatile uint32_t *pPLLReg = (uint32_t*)0x0;
+   volatile uint32_t *pClockCtrl = (uint32_t*)0x0;
+   volatile uint32_t *pDependentClock = (uint32_t*)0x0;
+   uint32_t vcoFreqPll1Hz = 0;    /* Effective VCO frequency for PLL1 in Hz */
+   uint32_t vcoFreqPll2Hz = 0;    /* Effective VCO frequency for PLL2 in Hz */
+   uint32_t dependentClockType = 0;
+   uint32_t vcoHz = 0;
+
+   /* Get VCO frequencies */
+   if ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK ) != chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER )
+   {
+      uint64_t adjustFreq = 0;
+
+      vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                      ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+
+      /* Adjusted frequency due to chipcHw_REG_PLL_DIVIDER_NDIV_f_SS */
+      adjustFreq = (uint64_t) chipcHw_XTAL_FREQ_Hz * (uint64_t) chipcHw_REG_PLL_DIVIDER_NDIV_f_SS *
+                   chipcHw_divide (chipcHw_REG_PLL_PREDIVIDER_P1, ( chipcHw_REG_PLL_PREDIVIDER_P2 * (uint64_t)chipcHw_REG_PLL_DIVIDER_FRAC ));
+      vcoFreqPll1Hz += (uint32_t) adjustFreq;
+   }
+   else
+   {
+      vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                      ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+   }
+   vcoFreqPll2Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                   ( ( pChipcHw->PLLPreDivider2 & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+
+   switch ( clock )
+   {
+      case chipcHw_CLOCK_DDR:
+         pPLLReg = &pChipcHw->DDRClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ARM:
+         pPLLReg = &pChipcHw->ARMClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ESW:
+         pPLLReg = &pChipcHw->ESWClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_VPM:
+         pPLLReg = &pChipcHw->VPMClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+     case chipcHw_CLOCK_ESW125:
+         pPLLReg = &pChipcHw->ESW125Clock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_UART:
+         pPLLReg = &pChipcHw->UARTClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SDIO0:
+         pPLLReg = &pChipcHw->SDIO0Clock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SDIO1:
+         pPLLReg = &pChipcHw->SDIO1Clock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SPI:
+         pPLLReg = &pChipcHw->SPIClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ETM:
+         pPLLReg = &pChipcHw->ETMClock;
+         vcoHz = vcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_USB:
+         pPLLReg = &pChipcHw->USBClock;
+         vcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_LCD:
+         pPLLReg = &pChipcHw->LCDClock;
+         vcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_APM:
+         pPLLReg = &pChipcHw->APMClock;
+         vcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_BUS:
+         pClockCtrl = &pChipcHw->ACLKClock;
+         pDependentClock = &pChipcHw->ARMClock;
+         vcoHz = vcoFreqPll1Hz;
+         dependentClockType = PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_OTP:
+         pClockCtrl = &pChipcHw->OTPClock;
+         break;
+      case chipcHw_CLOCK_I2C:
+         pClockCtrl = &pChipcHw->I2CClock;
+         break;
+      case chipcHw_CLOCK_I2S0:
+         pClockCtrl = &pChipcHw->I2S0Clock;
+         break;
+      case chipcHw_CLOCK_RTBUS:
+         pClockCtrl = &pChipcHw->RTBUSClock;
+         pDependentClock = &pChipcHw->ACLKClock;
+         dependentClockType = NON_PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_APM100:
+         pClockCtrl = &pChipcHw->APM100Clock;
+         pDependentClock = &pChipcHw->APMClock;
+         vcoHz = vcoFreqPll2Hz;
+         dependentClockType = PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_TSC:
+         pClockCtrl = &pChipcHw->TSCClock;
+         break;
+      case chipcHw_CLOCK_LED:
+         pClockCtrl = &pChipcHw->LEDClock;
+         break;
+      case chipcHw_CLOCK_I2S1:
+         pClockCtrl = &pChipcHw->I2S1Clock;
+         break;
+   }
+
+   if ( pPLLReg )
+   {
+      /* Obtain PLL clock frequency */
+      if ( *pPLLReg & chipcHw_REG_PLL_CLOCK_BYPASS_SELECT )
+      {
+         /* Return crystal clock frequency when bypassed */
+         return chipcHw_XTAL_FREQ_Hz;
+      }
+      else if ( clock == chipcHw_CLOCK_DDR )
+      {
+         /* DDR frequency is configured in PLLDivider register */
+         return  ( chipcHw_divide( vcoHz, ( ( ( pChipcHw->PLLDivider & 0xFF000000 ) >> 24 ) ? ( ( pChipcHw->PLLDivider & 0xFF000000 ) >> 24 ) : 256 ) ));
+      }
+      else
+      {
+         /* From chip revision number B0, LCD clock is internally divided by 2 */
+        if ( ( pPLLReg == &pChipcHw->LCDClock ) && ( chipcHw_getChipRevisionNumber() != chipcHw_REV_NUMBER_A0 ) )
+         {
+            vcoHz >>= 1;
+         }
+         /* Obtain PLL clock frequency using VCO dividers */
+     return chipcHw_divide( vcoHz, ( ( *pPLLReg & chipcHw_REG_PLL_CLOCK_MDIV_MASK ) ?  ( *pPLLReg & chipcHw_REG_PLL_CLOCK_MDIV_MASK ) : 256 ) );
+      }
+   }
+   else if ( pClockCtrl )
+   {
+      /* Obtain divider clock frequency */
+      uint32_t div;
+      uint32_t freq = 0;
+
+      if ( *pClockCtrl & chipcHw_REG_DIV_CLOCK_BYPASS_SELECT )
+      {
+         /* Return crystal clock frequency when bypassed */
+         return chipcHw_XTAL_FREQ_Hz;
+      }
+      else if ( pDependentClock )
+      {
+         /* Identify the dependent clock frequency */
+         switch ( dependentClockType )
+         {
+         case PLL_CLOCK:
+            if ( *pDependentClock & chipcHw_REG_PLL_CLOCK_BYPASS_SELECT )
+            {
+               /* Use crystal clock frequency when dependent PLL clock is bypassed */
+               freq = chipcHw_XTAL_FREQ_Hz;
+            }
+            else
+            {
+               /* Obtain PLL clock frequency using VCO dividers */
+              div = *pDependentClock & chipcHw_REG_PLL_CLOCK_MDIV_MASK;
+              freq = div ? chipcHw_divide( vcoHz, div ) : 0;
+            }
+            break;
+         case NON_PLL_CLOCK:
+            if ( pDependentClock == (uint32_t*)&pChipcHw->ACLKClock )
+            {
+               freq = chipcHw_getClockFrequency ( chipcHw_CLOCK_BUS );
+            }
+            else
+            {
+               if ( *pDependentClock & chipcHw_REG_DIV_CLOCK_BYPASS_SELECT )
+               {
+                  /* Use crystal clock frequency when dependent divider clock is bypassed */
+                  freq = chipcHw_XTAL_FREQ_Hz;
+               }
+               else
+               {
+                  /* Obtain divider clock frequency using XTAL dividers */
+                  div = *pDependentClock & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+                  freq = chipcHw_divide( chipcHw_XTAL_FREQ_Hz, ( div ? div : 256 ));
+               }
+            }
+            break;
+         }
+      }
+      else
+      {
+         /* Dependent on crystal clock */
+         freq = chipcHw_XTAL_FREQ_Hz;
+      }
+
+      div = *pClockCtrl & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+      return chipcHw_divide(freq , ( div ? div : 256 ));
+   }
+   return 0;
+}
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
+chipcHw_freq  chipcHw_setClockFrequency
+(
+   chipcHw_CLOCK_e clock,          ///<  [ IN ] Configurable clock
+   uint32_t freq                   ///<  [ IN ] Clock frequency in Hz
+)
+{
+   volatile uint32_t *pPLLReg = (uint32_t*)0x0;
+   volatile uint32_t *pClockCtrl = (uint32_t*)0x0;
+   volatile uint32_t *pDependentClock = (uint32_t*)0x0;
+   uint32_t vcoFreqPll1Hz = 0;    /* Effective VCO frequency for PLL1 in Hz */
+   uint32_t desVcoFreqPll1Hz = 0; /* Desired VCO frequency for PLL1 in Hz */
+   uint32_t vcoFreqPll2Hz = 0;    /* Effective VCO frequency for PLL2 in Hz */
+   uint32_t dependentClockType = 0;
+   uint32_t vcoHz = 0;
+   uint32_t desVcoHz = 0;
+
+   /* Get VCO frequencies */
+   if ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK ) != chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER )
+   {
+      uint64_t adjustFreq = 0;
+
+      vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                      ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+
+      /* Adjusted frequency due to chipcHw_REG_PLL_DIVIDER_NDIV_f_SS */
+      adjustFreq = (uint64_t) chipcHw_XTAL_FREQ_Hz * (uint64_t) chipcHw_REG_PLL_DIVIDER_NDIV_f_SS *
+                   chipcHw_divide ( chipcHw_REG_PLL_PREDIVIDER_P1, ( chipcHw_REG_PLL_PREDIVIDER_P2 * (uint64_t)chipcHw_REG_PLL_DIVIDER_FRAC ));
+      vcoFreqPll1Hz += (uint32_t) adjustFreq;
+
+      /* Desired VCO frequency */
+      desVcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                        ( (( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT) + 1 );
+   }
+   else
+   {
+      vcoFreqPll1Hz = desVcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                      ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+   }
+   vcoFreqPll2Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide( chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2 ) *
+                   ( ( pChipcHw->PLLPreDivider2 & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK ) >> chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT );
+
+   switch ( clock )
+   {
+      case chipcHw_CLOCK_DDR:
+         /* Configure the DDR_ctrl:BUS ratio settings */
+         {
+            REG_LOCAL_IRQ_SAVE;
+            /* Dvide DDR_phy by two to obtain DDR_ctrl clock */
+            pChipcHw->DDRClock = ( pChipcHw->DDRClock & ~chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK ) |
+                                 ( ( ( ( freq / 2 ) / chipcHw_getClockFrequency ( chipcHw_CLOCK_BUS ) ) - 1) << chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT );
+            REG_LOCAL_IRQ_RESTORE;
+         }
+         pPLLReg = &pChipcHw->DDRClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ARM:
+         pPLLReg = &pChipcHw->ARMClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ESW:
+         pPLLReg = &pChipcHw->ESWClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_VPM:
+         /* Configure the VPM:BUS ratio settings */
+         {
+            REG_LOCAL_IRQ_SAVE;
+            pChipcHw->VPMClock = ( pChipcHw->VPMClock & ~chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK ) |
+                                 ( ( chipcHw_divide( freq, chipcHw_getClockFrequency ( chipcHw_CLOCK_BUS ) ) - 1) << chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT );
+            REG_LOCAL_IRQ_RESTORE;
+         }
+         pPLLReg = &pChipcHw->VPMClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+     case chipcHw_CLOCK_ESW125:
+         pPLLReg = &pChipcHw->ESW125Clock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_UART:
+         pPLLReg = &pChipcHw->UARTClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SDIO0:
+         pPLLReg = &pChipcHw->SDIO0Clock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SDIO1:
+         pPLLReg = &pChipcHw->SDIO1Clock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_SPI:
+         pPLLReg = &pChipcHw->SPIClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_ETM:
+         pPLLReg = &pChipcHw->ETMClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         break;
+      case chipcHw_CLOCK_USB:
+         pPLLReg = &pChipcHw->USBClock;
+         vcoHz = vcoFreqPll2Hz;
+         desVcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_LCD:
+         pPLLReg = &pChipcHw->LCDClock;
+         vcoHz = vcoFreqPll2Hz;
+         desVcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_APM:
+         pPLLReg = &pChipcHw->APMClock;
+         vcoHz = vcoFreqPll2Hz;
+         desVcoHz = vcoFreqPll2Hz;
+         break;
+      case chipcHw_CLOCK_BUS:
+         pClockCtrl = &pChipcHw->ACLKClock;
+         pDependentClock = &pChipcHw->ARMClock;
+         vcoHz = vcoFreqPll1Hz;
+         desVcoHz = desVcoFreqPll1Hz;
+         dependentClockType = PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_OTP:
+         pClockCtrl = &pChipcHw->OTPClock;
+         break;
+      case chipcHw_CLOCK_I2C:
+         pClockCtrl = &pChipcHw->I2CClock;
+         break;
+      case chipcHw_CLOCK_I2S0:
+         pClockCtrl = &pChipcHw->I2S0Clock;
+         break;
+      case chipcHw_CLOCK_RTBUS:
+         pClockCtrl = &pChipcHw->RTBUSClock;
+         pDependentClock = &pChipcHw->ACLKClock;
+         dependentClockType = NON_PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_APM100:
+         pClockCtrl = &pChipcHw->APM100Clock;
+         pDependentClock = &pChipcHw->APMClock;
+         vcoHz = vcoFreqPll2Hz;
+         desVcoHz = vcoFreqPll2Hz;
+         dependentClockType = PLL_CLOCK;
+         break;
+      case chipcHw_CLOCK_TSC:
+         pClockCtrl = &pChipcHw->TSCClock;
+         break;
+      case chipcHw_CLOCK_LED:
+         pClockCtrl = &pChipcHw->LEDClock;
+         break;
+      case chipcHw_CLOCK_I2S1:
+         pClockCtrl = &pChipcHw->I2S1Clock;
+         break;
+   }
+
+   if ( pPLLReg )
+   {
+      /* Select XTAL as bypass source */
+      reg32_modify_and( pPLLReg, ~chipcHw_REG_PLL_CLOCK_SOURCE_GPIO);
+      reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_BYPASS_SELECT);
+      /* For DDR settings use only the PLL divider clock */
+      if (pPLLReg == &pChipcHw->DDRClock)
+      {
+         /* Set M1DIV for PLL1, which controls the DDR clock */
+         reg32_write ( &pChipcHw->PLLDivider, ( pChipcHw->PLLDivider & 0x00FFFFFF ) | ( (chipcHw_REG_PLL_DIVIDER_MDIV ( desVcoHz, freq ) )   << 24 ) );
+         /* Calculate expected frequency */
+         freq =  chipcHw_divide( vcoHz, ( ( ( pChipcHw->PLLDivider & 0xFF000000 ) >> 24 ) ? ( ( pChipcHw->PLLDivider & 0xFF000000 ) >> 24 ) : 256 ));
+      }
+      else
+      {
+         /* From chip revision number B0, LCD clock is internally divided by 2 */
+        if ( ( pPLLReg == &pChipcHw->LCDClock ) && ( chipcHw_getChipRevisionNumber() != chipcHw_REV_NUMBER_A0 ) )
+         {
+            desVcoHz >>= 1;
+            vcoHz >>= 1;
+         }
+         /* Set MDIV to change the frequency */
+         reg32_modify_and( pPLLReg, ~(chipcHw_REG_PLL_CLOCK_MDIV_MASK ));
+         reg32_modify_or( pPLLReg, chipcHw_REG_PLL_DIVIDER_MDIV ( desVcoHz, freq ));
+         /* Calculate expected frequency */
+         freq = chipcHw_divide ( vcoHz, ( ( *(pPLLReg) & chipcHw_REG_PLL_CLOCK_MDIV_MASK ) ? ( *(pPLLReg) & chipcHw_REG_PLL_CLOCK_MDIV_MASK ) : 256 ));
+      }
+      /* Wait for for atleast 200ns as per the protocol to change frequency */
+      udelay ( 1 );
+      /* Do not bypass */
+      reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_BYPASS_SELECT );
+      /* Return the configured frequency */
+      return freq;
+   }
+   else if ( pClockCtrl )
+   {
+      uint32_t divider = 0;
+
+      /* Divider clock should not be bypassed  */
+      reg32_modify_and( pClockCtrl, ~chipcHw_REG_DIV_CLOCK_BYPASS_SELECT );
+
+      /* Identify the clock source */
+      if ( pDependentClock )
+      {
+         switch ( dependentClockType )
+         {
+            case PLL_CLOCK:
+               divider = chipcHw_divide( chipcHw_divide( desVcoHz, ( *pDependentClock & chipcHw_REG_PLL_CLOCK_MDIV_MASK ) ), freq);
+               break;
+            case NON_PLL_CLOCK:
+               {
+                  uint32_t sourceClock = 0;
+
+                  if ( pDependentClock == (uint32_t*)&pChipcHw->ACLKClock )
+                  {
+                     sourceClock = chipcHw_getClockFrequency ( chipcHw_CLOCK_BUS );
+                  }
+                  else
+                  {
+                     uint32_t div = *pDependentClock & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+                     sourceClock = chipcHw_divide( chipcHw_XTAL_FREQ_Hz, ( ( div ) ? div : 256 ));
+                  }
+                  divider = chipcHw_divide( sourceClock, freq);
+               }
+               break;
+         }
+      }
+      else
+      {
+         divider = chipcHw_divide( chipcHw_XTAL_FREQ_Hz, freq);
+      }
+
+      if ( divider )
+      {
+         REG_LOCAL_IRQ_SAVE;
+         /* Set the divider to obtain the required frequency */
+         *pClockCtrl = ( *pClockCtrl & (~ chipcHw_REG_DIV_CLOCK_DIV_MASK) ) |
+                       ( ( ( divider > 256 ) ? chipcHw_REG_DIV_CLOCK_DIV_256 : divider ) & chipcHw_REG_DIV_CLOCK_DIV_MASK );
+         REG_LOCAL_IRQ_RESTORE;
+         return freq;
+      }
+   }
+
+   return 0;
+}
+EXPORT_SYMBOL( chipcHw_setClockFrequency );
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM clock in sync with BUS clock for Chip Rev #A0
+*
+*  This function does the phase adjustment between VPM and BUS clock
+*
+*  @return >= 0 : On success ( # of adjustment required )
+*            -1 : On failure
+*
+*/
+/****************************************************************************/
+static int vpmPhaseAlignA0 ( void )
+{
+  uint32_t phaseControl;
+  uint32_t phaseValue;
+  uint32_t prevPhaseComp;
+  int iter = 0;
+  int adjustCount = 0;
+  int count = 0;
+
+  for ( iter = 0; ( iter < MAX_PHASE_ALIGN_ATTEMPTS ) && ( adjustCount < MAX_PHASE_ADJUST_COUNT ); iter ++ )
+  {
+     phaseControl   = (pChipcHw->VPMClock & chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) >> chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT;
+     phaseValue     = 0;
+     prevPhaseComp  = 0;
+
+
+     // Step 1: Look for falling PH_COMP transition
+
+     // Read the contents of VPM Clock resgister
+     phaseValue = pChipcHw->VPMClock;
+     do
+     {
+        // Store previous value of phase comparator
+        prevPhaseComp = phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP;
+        // Change the value of PH_CTRL.
+        reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+        // Wait atleast 20 ns
+        WAIT();
+        // Toggle the LOAD_CH after phase control is written.
+        pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+        // Read the contents of  VPM Clock resgister.
+        phaseValue = pChipcHw->VPMClock;
+
+        if ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) == 0x0 )
+        {
+           phaseControl = (0x3F & (phaseControl - 1));
+        }
+        else
+        {
+           // Increment to the Phase count value for next write, if Phase is not stable.
+           phaseControl = (0x3F & (phaseControl + 1));
+        }
+        // Count number of adjustment made
+        adjustCount ++;
+     } while ( ( ( prevPhaseComp == ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) ) ||   // Look for a transition
+                 ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) != 0x0 ) ) &&           // Look for a falling edge
+               ( adjustCount < MAX_PHASE_ADJUST_COUNT )                                      // Do not exceed the limit while trying
+             );
+
+     if ( adjustCount >= MAX_PHASE_ADJUST_COUNT )
+     {
+        /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+        return -1;
+     }
+
+
+     // Step 2: Keep moving forward to make sure falling PH_COMP transition was valid
+
+     for ( count = 0; ( count < 5 ) && ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) == 0); count ++ )
+     {
+        phaseControl = (0x3F & (phaseControl + 1));
+        reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+        // Wait atleast 20 ns
+        WAIT();
+        // Toggle the LOAD_CH after phase control is written.
+        pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+        phaseValue = pChipcHw->VPMClock;
+        // Count number of adjustment made
+        adjustCount ++;
+     }
+
+     if ( adjustCount >= MAX_PHASE_ADJUST_COUNT )
+     {
+        /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+        return -1;
+     }
+
+     if ( count != 5 )
+     {
+        // Detected false transition
+        continue;
+     }
+
+     // Step 3: Keep moving backward to make sure falling PH_COMP transition was stable
+
+     for ( count = 0; ( count < 3 ) && ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) == 0); count ++ )
+     {
+        phaseControl = (0x3F & (phaseControl - 1));
+        reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+        // Wait atleast 20 ns
+        WAIT();
+        // Toggle the LOAD_CH after phase control is written.
+        pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+        phaseValue = pChipcHw->VPMClock;
+        // Count number of adjustment made
+        adjustCount ++;
+     }
+
+     if ( adjustCount >= MAX_PHASE_ADJUST_COUNT )
+     {
+        /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+        return -1;
+     }
+
+     if ( count != 3 )
+     {
+        // Detected noisy transition
+        continue;
+     }
+
+     // Step 4: Keep moving backward before the original transition took place.
+
+     for ( count = 0; ( count < 5 ); count ++ )
+     {
+        phaseControl = (0x3F & (phaseControl - 1));
+        reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+        // Wait atleast 20 ns
+        WAIT();
+        // Toggle the LOAD_CH after phase control is written.
+        pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+        phaseValue = pChipcHw->VPMClock;
+        // Count number of adjustment made
+        adjustCount ++;
+     }
+
+     if ( adjustCount >= MAX_PHASE_ADJUST_COUNT )
+     {
+        /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+        return -1;
+     }
+
+     if (( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) == 0 )
+     {
+        // Detected false transition
+        continue;
+     }
+
+     // Step 5: Re discover the valid transition
+
+     do
+     {
+        // Store previous value of phase comparator
+        prevPhaseComp = phaseValue;
+        // Change the value of PH_CTRL.
+        reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+        // Wait atleast 20 ns
+        WAIT();
+        // Toggle the LOAD_CH after phase control is written.
+        pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+        // Read the contents of  VPM Clock resgister.
+        phaseValue = pChipcHw->VPMClock;
+
+        if ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) == 0x0 )
+        {
+           phaseControl = (0x3F & (phaseControl - 1));
+        }
+        else
+        {
+           // Increment to the Phase count value for next write, if Phase is not stable.
+           phaseControl = (0x3F & (phaseControl + 1));
+        }
+
+        // Count number of adjustment made
+        adjustCount ++;
+     } while ( ( ( prevPhaseComp == ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) ) ||
+                 ( ( phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP ) != 0x0 ) ) &&
+               ( adjustCount < MAX_PHASE_ADJUST_COUNT )
+             );
+
+     if ( adjustCount >= MAX_PHASE_ADJUST_COUNT )
+     {
+       // Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries
+        return -1;
+     }
+     else
+     {
+        // Valid phase must have detected
+        break;
+     }
+  }
+
+  // For VPM Phase should be perfectly aligned.
+  phaseControl = (((pChipcHw->VPMClock >> chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT) - 1) & 0x3F );
+  {
+     REG_LOCAL_IRQ_SAVE;
+
+     pChipcHw->VPMClock = ( pChipcHw->VPMClock & ~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT );
+     // Load new phase value
+     pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+
+     REG_LOCAL_IRQ_RESTORE;
+  }
+  // Return the status
+  return (int)adjustCount;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM clock in sync with BUS clock
+*
+*  This function does the phase adjustment between VPM and BUS clock
+*
+*  @return >= 0 : On success ( # of adjustment required )
+*            -1 : On failure
+*
+*/
+/****************************************************************************/
+int chipcHw_vpmPhaseAlign ( void )
+{
+
+   if ( chipcHw_getChipRevisionNumber() == chipcHw_REV_NUMBER_A0 )
+   {
+      return vpmPhaseAlignA0 ();
+   }
+   else
+   {
+      uint32_t phaseControl = chipcHw_getVpmPhaseControl ();
+      uint32_t phaseValue = 0;
+      int adjustCount = 0;
+
+      // Disable VPM access
+      pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+      // Disable HW VPM phase alignment
+      chipcHw_vpmHwPhaseAlignDisable ();
+      // Enable SW VPM phase alignment
+      chipcHw_vpmSwPhaseAlignEnable ();
+      // Adjust VPM phase
+      while ( adjustCount < MAX_PHASE_ADJUST_COUNT )
+      {
+         phaseValue = chipcHw_getVpmHwPhaseAlignStatus ();
+
+         // Adjust phase control value
+         if ( phaseValue > 0xF )
+         {
+            // Increment phase control value
+            phaseControl++;
+         }
+         else if ( phaseValue < 0xF)
+         {
+            // Decrement phase control value
+            phaseControl--;
+         }
+         else
+         {
+            // Enable VPM access
+            pChipcHw->Spare1 |= chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+            // Return adjust count
+            return adjustCount;
+         }
+         // Change the value of PH_CTRL.
+         reg32_write ( &pChipcHw->VPMClock, ( pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) ) | ( phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT ) );
+         // Wait atleast 20 ns
+         WAIT();
+         // Toggle the LOAD_CH after phase control is written.
+         pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+         // Count adjustment
+         adjustCount++;
+      }
+   }
+
+   // Disable VPM access
+   pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+   return -1;
+}
+/****************************************************************************/
+/**
+*  @brief   Local Divide function
+*
+*  This function does the divide
+*
+*  @return divide value
+*
+*/
+/****************************************************************************/
+static int chipcHw_divide(int num, int denom)
+{
+  int r;
+  int t=1;
+
+  /* Shift denom and t up to the largest value to optimize algorithm */
+  /* t contains the units of each divide */
+  while( (denom & 0x40000000) == 0 ) /* fails if denom=0 */
+  {
+     denom =denom << 1;
+     t = t << 1;
+  }
+
+  /* Intialize the result */
+  r=0;
+
+  do
+  {
+     /* Determine if there exists a positive remainder */
+     if( (num-denom) >= 0 )
+     {
+        /* Accumlate t to the result and calculate a new remainder */
+        num = num - denom;
+        r = r + t;
+     }
+     /* Continue to shift denom and shift t down to 0 */
+     denom = denom >> 1;
+     t = t >> 1;
+  } while ( t!=0 );
+
+  return r;
+}
+
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
new file mode 100644
index 0000000..5cd179a
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
@@ -0,0 +1,247 @@
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
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+#include <mach/csp/sdramHw_phaseAlign.h>
+#include <csp/intcHw.h>
+#include <csp/vpmHw.h>
+#include <csp/cache.h>
+#include <csp/delay.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+/* The following varaibles are defined in the linker file which contain the
+ * start and end address of the aramtext section.  The aramtext section links to
+ * DDR and however is relocatable and can be executed completely within ARAM */
+char _aramtext_start, _aramtext_end;
+
+#define ARAM_STACKSIZE 0x400
+
+/* ---- Private Variables ------------------------------------------------- */
+void chipcHw_run_from_aram( uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio, uint32_t ddrRatio ) __attribute__ ((section(".aramtext")));
+
+typedef void (*RUNFUNC)( uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio, uint32_t ddrRatio );
+
+
+/*
+ * Get current state.
+ */
+static inline uint32_t get_flags( void )
+{
+   uint32_t flags;
+
+   __asm__ __volatile__( "mrs    %0, cpsr " : "=r" (flags) : : "memory", "cc");
+   return flags;
+}
+
+/*
+ * restore saved state
+ */
+static inline void restore_flags( uint32_t flags )
+{
+   __asm__ __volatile__( "msr    cpsr_c, %0 " : : "r" (flags) : "memory", "cc");
+}
+
+/*
+ * Enable IRQs
+ */
+static inline void enable_irq(void)
+{
+   uint32_t flags = get_flags() ;
+   // clear IRQ disable bit (enable IRQ)
+   flags &= ~0x00000080;
+   restore_flags (flags);
+}
+
+/*
+ * Disable IRQs
+ */
+static inline void disable_irq(void)
+{
+   uint32_t flags = get_flags() ;
+   // set IRQ disable bit (disable IRQ)
+   flags |= 0x00000080;
+   restore_flags (flags);
+}
+
+
+/*
+ * Enable FIQs
+ */
+static inline void enable_fiq(void)
+{
+   uint32_t flags = get_flags() ;
+   // clear FIQ disable bit (enable FIQ)
+   flags &= ~0x00000040;
+   restore_flags (flags);
+}
+
+/*
+ * Disable FIQs
+ */
+static inline void disable_fiq(void)
+{
+   uint32_t flags = get_flags() ;
+   // set FIQ disable bit (disable FIQ)
+   flags |= 0x00000040;
+   restore_flags (flags);
+}
+
+/****************************************************************************/
+/**
+*  @brief   chipcHw_clockReconfig
+*
+*  @note chipcHw_clockReconfig configures the clock.
+*   To do so it needs to copy the code into internal
+*   memory to change the ARM clock and not execute from DDR.
+*   ARAM is used for code and stack.  The contents of ARAM are not
+*   preserved.
+*/
+/****************************************************************************/
+void chipcHw_clockReconfig( uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio, uint32_t ddrRatio )
+{
+   RUNFUNC runFunc;
+   char *src;
+   char *dst;
+   unsigned int *stackFill;
+   unsigned long flags;
+
+   /* Disable IRQ and FIQ */
+   flags = get_flags();
+   disable_irq();
+   disable_fiq();
+   {
+      REG_LOCAL_IRQ_SAVE;
+
+      /* Halt the VPM, prior to clock reconfiguration */
+      vpmHw_Halt();
+
+      src = &_aramtext_start;
+      dst = (char*)MM_IO_BASE_ARAM+ARAM_STACKSIZE;
+
+      /* Copy code currently in DDR to ARAM */
+      while (src < &_aramtext_end) {
+        *dst++ = *src++;
+      }
+
+      /* Fill Stack with known pattern to allow measurement of usage if required */
+      stackFill = (unsigned int*)MM_IO_BASE_ARAM;
+      while (stackFill < (unsigned int*)(MM_IO_BASE_ARAM+ARAM_STACKSIZE)) {
+        *stackFill++ = 0xdeaddead;
+      }
+
+      /* -----------
+       * |         |
+       * |         |
+       * |         |   <- start run here; ARAM BASE + ARAM_STACKSIZE + ( chipcHw_run_from_aram - _aramtext_start)
+       * |         |
+       * | code    |
+       * |---------|   <- ARAM BASE + ARAM_STACKSIZE
+       * | stack   |  /\
+       * |   ||    |   | Top of stack
+       * |   ||    |   |
+       * |   ||    |   | ARAM_STACKSIZE
+       * |   \/    |   |
+       * |         |  \/
+       * -----------   <- ARAM BASE (0x30100000)
+       * */
+
+      /* Save stack pointer in DDR to known location in ARAM */
+      asm(" ldr r2, =0x30100400-4                                          ");
+      asm(" str sp, [r2]                                                   ");
+      /* Use new stack pointer now located in ARAM */
+      asm(" ldr sp, =0x30100400-8                                          ");
+
+      /* Calculate the offset into ARAM to ensure that chipcHw_run_from_aram() is called */
+      runFunc = (RUNFUNC)(unsigned long) MM_ADDR_IO_ARAM+ARAM_STACKSIZE+(unsigned long)&chipcHw_run_from_aram-(unsigned long)&_aramtext_start;
+
+      CSP_CACHE_FLUSH_ALL;
+
+      /* run the function from ARAM */
+      runFunc( busHz, armRatio, vpmRatio, ddrRatio );
+
+      /* Restore stack pointer in DDR */
+      asm(" ldr r2, =0x30100400-4                                          ");
+      asm(" ldr sp, [r2]                                                   ");
+
+      /* Re-enable the VPM */
+      vpmHw_Run();
+
+      REG_LOCAL_IRQ_RESTORE;
+   }
+   /* Re-enable IRQ and FIQ */
+   restore_flags ( flags );
+}
+
+/****************************************************************************/
+/**
+*  @brief   chipcHw_run_from_aram
+*
+*  @note This function must run from internal memory ARAM because DDR access
+*        is restricted when the clocks are reconfigured.  All of the functions and subfunctions
+*        called in this routine, *must* be located in the .aramtext section
+*        to ensure that DDR access does not occur.
+*/
+/****************************************************************************/
+void chipcHw_run_from_aram( uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio, uint32_t ddrRatio )
+{
+   chipcHw_INIT_PARAM_t param;
+   int uartHz = 0;
+
+   if ( busHz == 166666666 )
+   {
+      param.pllVcoFreqHz  = 2000000000;  /* VCO must be integer multiple of bus.  VCO = 12 * bus */
+      uartHz = 142857142;                /* UART must be < 150MHz and multiple divided by VCO.   UART = VCO / 14 */
+   }
+   else if ( busHz == 150000000 )
+   {
+      param.pllVcoFreqHz  = 1800000000;  /* VCO must be integer multiple of bus.  VCO = 12 * bus */
+      uartHz = 138461538;                /* UART must be < 150MHz and multiple divided by VCO.   UART = VCO / 13 */
+   }
+   else
+   {
+      /* Bus speed not supported */
+      return;
+   }
+
+   param.pll2VcoFreqHz = 1800000000; /* Always 1.8GHz */
+
+   param.ssSupport = 0;
+   param.busClockFreqHz = busHz;
+   param.armBusRatio = armRatio;  /* ARM Clock = Ratio * BUS Clock */
+   param.vpmBusRatio = vpmRatio;  /* VPM Clock = Ratio * BUS Clock */
+   param.ddrBusRatio = ddrRatio;  /* DDR Clock = Ratio * BUS Clock */
+
+   /* Disable branch prediction.  Workaround for GNATS 8270 */
+   asm(" mrc p15, 0, r5, c1, c0, 0       ");  /* read control reg */
+   asm(" and r5, r5, #0xFFFFF7FF         ");  /* branch prediction off for ARM11 */
+   asm(" mcr p15, 0, r5, c1, c0, 0       ");  /* write control reg */
+
+   /* Program the PLL and major clocks */
+   chipcHw_Init ( &param );
+
+   /* Re-enable branch prediction.  Workaround for GNATS 8270 */
+   asm(" mrc p15, 0, r5, c1, c0, 0       ");  /* read control reg */
+   asm(" orr r5, r5, #0x800              ");  /* branch prediction on for ARM11 */
+   asm(" mcr p15, 0, r5, c1, c0, 0       ");  /* write control reg */
+
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_UART, uartHz );
+
+   /* Set DDR clock in sync with BUS clock */
+   sdramHw_phaseAlignLowLevel( );
+}
+
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
new file mode 100644
index 0000000..9bddc23
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
@@ -0,0 +1,280 @@
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
+/****************************************************************************/
+/**
+*  @file    chipcHw_init.c
+*
+*  @brief   Low level CHIPC PLL configuration functions
+*
+*  @note
+*
+*   These routines provide basic PLL controlling functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/stdint.h>
+#include <csp/module.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <csp/reg.h>
+#include <csp/delay.h>
+/* ---- Private Constants and Types --------------------------------------- */
+
+/*
+    Calculation for NDIV_i to obtain VCO frequency
+    -----------------------------------------------
+
+    Freq_vco = Freq_ref * (P2 / P1) * (PLL_NDIV_i + PLL_NDIV_f)
+    for Freq_vco = VCO_FREQ_MHz
+        Freq_ref = chipcHw_XTAL_FREQ_Hz
+        PLL_P1 = PLL_P2 = 1
+        and
+        PLL_NDIV_f = 0
+
+        We get:
+        PLL_NDIV_i = Freq_vco / Freq_ref = VCO_FREQ_MHz / chipcHw_XTAL_FREQ_Hz
+
+    Calculation for PLL MDIV to obtain frequency Freq_x for channel x
+    -----------------------------------------------------------------
+        Freq_x = chipcHw_XTAL_FREQ_Hz * PLL_NDIV_i / PLL_MDIV_x
+               = VCO_FREQ_MHz / PLL_MDIV_x
+
+        PLL_MDIV_x = VCO_FREQ_MHz / Freq_x
+*/
+
+
+/* ---- Private Variables ------------------------------------------------- */
+/****************************************************************************/
+/**
+*  @brief  Initializes the PLL2
+*
+*  This function initializes the PLL2
+*
+*/
+/****************************************************************************/
+void chipcHw_pll2Enable ( uint32_t vcoFreqHz )
+{
+   uint32_t pllPreDivider2 = 0;
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+      pChipcHw->PLLConfig2 = chipcHw_REG_PLL_CONFIG_D_RESET | chipcHw_REG_PLL_CONFIG_A_RESET;
+
+      pllPreDivider2 = chipcHw_REG_PLL_PREDIVIDER_POWER_DOWN |
+                       chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER |
+                       ( chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) << chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT ) |
+                       ( chipcHw_REG_PLL_PREDIVIDER_P1 << chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT ) |
+                       ( chipcHw_REG_PLL_PREDIVIDER_P2 << chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT );
+
+      /* Enable CHIPC registers to control the PLL */
+      pChipcHw->PLLStatus |= chipcHw_REG_PLL_STATUS_CONTROL_ENABLE;
+
+      /* Set pre divider to get desired VCO frequency */
+      pChipcHw->PLLPreDivider2 = pllPreDivider2;
+      /* Set NDIV Frac */
+      pChipcHw->PLLDivider2 = chipcHw_REG_PLL_DIVIDER_NDIV_f;
+
+      // This has to be removed once the default values are fixed for PLL2.
+      pChipcHw->PLLControl12 = 0x38000700;
+      pChipcHw->PLLControl22 = 0x00000015;
+
+      /* Reset PLL2 */
+      if ( vcoFreqHz > chipcHw_REG_PLL_CONFIG_VCO_SPLIT_FREQ )
+      {
+         pChipcHw->PLLConfig2 = chipcHw_REG_PLL_CONFIG_D_RESET | \
+                                chipcHw_REG_PLL_CONFIG_A_RESET | \
+                                chipcHw_REG_PLL_CONFIG_VCO_1601_3200 | \
+                                chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+      }
+      else
+      {
+         pChipcHw->PLLConfig2 = chipcHw_REG_PLL_CONFIG_D_RESET | \
+                                chipcHw_REG_PLL_CONFIG_A_RESET | \
+                                chipcHw_REG_PLL_CONFIG_VCO_800_1600 | \
+                                chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+      }
+      REG_LOCAL_IRQ_RESTORE;
+   }
+
+   /* Insert certain amount of delay before deasserting ARESET. */
+   udelay ( 1 );
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+      /* Remove analog reset and Power on the PLL */
+      pChipcHw->PLLConfig2 &= ~ ( chipcHw_REG_PLL_CONFIG_A_RESET | chipcHw_REG_PLL_CONFIG_POWER_DOWN );
+
+      REG_LOCAL_IRQ_RESTORE;
+
+   }
+
+   /* Wait until PLL is locked */
+   while ( !(pChipcHw->PLLStatus2 & chipcHw_REG_PLL_STATUS_LOCKED) ) ;
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+      /* Remove digital reset */
+      pChipcHw->PLLConfig2 &= ~ chipcHw_REG_PLL_CONFIG_D_RESET;
+
+      REG_LOCAL_IRQ_RESTORE;
+   }
+}
+EXPORT_SYMBOL( chipcHw_pll2Enable );
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the PLL1
+*
+*  This function initializes the PLL1
+*
+*/
+/****************************************************************************/
+void chipcHw_pll1Enable ( uint32_t vcoFreqHz,  chipcHw_SPREAD_SPECTRUM_e ssSupport )
+{
+   uint32_t pllPreDivider = 0;
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+
+      pChipcHw->PLLConfig = chipcHw_REG_PLL_CONFIG_D_RESET | chipcHw_REG_PLL_CONFIG_A_RESET;
+      /* Setting VCO frequency */
+      if ( ssSupport == chipcHw_SPREAD_SPECTRUM_ALLOW )
+      {
+         pllPreDivider = chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASH_1_8 |
+                         ( ( chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) - 1 ) << chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT ) |
+                         ( chipcHw_REG_PLL_PREDIVIDER_P1 << chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT ) |
+                         ( chipcHw_REG_PLL_PREDIVIDER_P2 << chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT );
+      }
+      else
+      {
+         pllPreDivider = chipcHw_REG_PLL_PREDIVIDER_POWER_DOWN |
+                         chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER |
+                         ( chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) << chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT ) |
+                         ( chipcHw_REG_PLL_PREDIVIDER_P1 << chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT ) |
+                         ( chipcHw_REG_PLL_PREDIVIDER_P2 << chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT );
+      }
+
+      /* Enable CHIPC registers to control the PLL */
+      pChipcHw->PLLStatus |= chipcHw_REG_PLL_STATUS_CONTROL_ENABLE;
+
+      /* Set pre divider to get desired VCO frequency */
+      pChipcHw->PLLPreDivider = pllPreDivider;
+      /* Set NDIV Frac */
+      if ( ssSupport == chipcHw_SPREAD_SPECTRUM_ALLOW )
+      {
+         pChipcHw->PLLDivider = chipcHw_REG_PLL_DIVIDER_M1DIV |
+                                chipcHw_REG_PLL_DIVIDER_NDIV_f_SS;
+      }
+      else
+      {
+         pChipcHw->PLLDivider = chipcHw_REG_PLL_DIVIDER_M1DIV |
+                                chipcHw_REG_PLL_DIVIDER_NDIV_f;
+      }
+
+      /* Reset PLL1 */
+      if ( vcoFreqHz > chipcHw_REG_PLL_CONFIG_VCO_SPLIT_FREQ )
+      {
+         pChipcHw->PLLConfig = chipcHw_REG_PLL_CONFIG_D_RESET | \
+                               chipcHw_REG_PLL_CONFIG_A_RESET | \
+                               chipcHw_REG_PLL_CONFIG_VCO_1601_3200 | \
+                               chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+      }
+      else
+      {
+         pChipcHw->PLLConfig = chipcHw_REG_PLL_CONFIG_D_RESET | \
+                               chipcHw_REG_PLL_CONFIG_A_RESET | \
+                               chipcHw_REG_PLL_CONFIG_VCO_800_1600 | \
+                               chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+      }
+
+      REG_LOCAL_IRQ_RESTORE;
+
+      /* Insert certain amount of delay before deasserting ARESET. */
+      udelay ( 1 );
+
+      {
+         REG_LOCAL_IRQ_SAVE;
+         /* Remove analog reset and Power on the PLL */
+         pChipcHw->PLLConfig &=  ~ ( chipcHw_REG_PLL_CONFIG_A_RESET  | chipcHw_REG_PLL_CONFIG_POWER_DOWN );
+         REG_LOCAL_IRQ_RESTORE;
+      }
+
+      /* Wait until PLL is locked */
+      while ( !(pChipcHw->PLLStatus & chipcHw_REG_PLL_STATUS_LOCKED) || !(pChipcHw->PLLStatus2 & chipcHw_REG_PLL_STATUS_LOCKED) ) ;
+
+      /* Remove digital reset */
+      {
+         REG_LOCAL_IRQ_SAVE;
+         pChipcHw->PLLConfig &= ~ chipcHw_REG_PLL_CONFIG_D_RESET;
+         REG_LOCAL_IRQ_RESTORE;
+      }
+   }
+}
+EXPORT_SYMBOL( chipcHw_pll1Enable );
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the chipc module
+*
+*  This function initializes the PLLs and core system clocks
+*
+*/
+/****************************************************************************/
+
+void chipcHw_Init
+(
+  chipcHw_INIT_PARAM_t *initParam    ///<  [ IN ] Misc chip initialization parameter
+)
+{
+#if !(defined(__KERNEL__) && !defined(STANDALONE))
+   delay_init();
+#endif
+
+   /* Do not program PLL, when warm reset */
+   if ( ! ( chipcHw_getStickyBits () & chipcHw_REG_STICKY_CHIP_WARM_RESET ) )
+   {
+      chipcHw_pll1Enable ( initParam->pllVcoFreqHz, initParam->ssSupport );
+      chipcHw_pll2Enable ( initParam->pll2VcoFreqHz);
+   }
+   else
+   {
+      /* Clear sticky bits */
+      chipcHw_clearStickyBits( chipcHw_REG_STICKY_CHIP_WARM_RESET );
+   }
+   /* Clear sticky bits */
+   chipcHw_clearStickyBits( chipcHw_REG_STICKY_CHIP_SOFT_RESET );
+
+   /* Before configuring the ARM clock, atleast we need to make sure BUS clock maintains the proper ratio with ARM clock */
+   pChipcHw->ACLKClock = (pChipcHw->ACLKClock & ~chipcHw_REG_ACLKClock_CLK_DIV_MASK) |
+                         ( initParam->armBusRatio & chipcHw_REG_ACLKClock_CLK_DIV_MASK );
+
+   // Set various core component frequencies. The order in which this is done is important for some.
+   // The RTBUS (DDR PHY) is derived from the BUS, and the BUS from the ARM, and VPM needs to know BUS
+   // frequency to find its ratio with the BUS.  Hence we must set the ARM first, followed by the BUS,
+   // then VPM and RTBUS.
+
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_ARM, initParam->busClockFreqHz * initParam->armBusRatio );
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_BUS, initParam->busClockFreqHz );
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_VPM, initParam->busClockFreqHz * initParam->vpmBusRatio );
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_DDR, initParam->busClockFreqHz * initParam->ddrBusRatio );
+   chipcHw_setClockFrequency ( chipcHw_CLOCK_RTBUS, initParam->busClockFreqHz / 2);
+}
+
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
new file mode 100644
index 0000000..9af0b46
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
@@ -0,0 +1,127 @@
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
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+#include <csp/intcHw.h>
+#include <csp/cache.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+/* ---- Private Variables ------------------------------------------------- */
+void chipcHw_reset_run_from_aram( void );
+
+typedef void (*RUNFUNC)(void);
+
+/****************************************************************************/
+/**
+*  @brief   warmReset
+*
+*  @note warmReset configures the clocks which are not reset back to the state
+*   required to execute on reset.  To do so we need to copy the code into internal
+*   memory to change the ARM clock while we are not executing from DDR.
+*/
+/****************************************************************************/
+void chipcHw_reset( uint32_t mask )
+{
+   int i = 0;
+   RUNFUNC runFunc = (RUNFUNC)(unsigned long) MM_ADDR_IO_ARAM;
+
+   /* Disable all interrupts */
+   intcHw_irq_disable( INTCHW_INTC0, 0xffffffff );
+   intcHw_irq_disable( INTCHW_INTC1, 0xffffffff );
+   intcHw_irq_disable( INTCHW_SINTC, 0xffffffff );
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+      if (mask & chipcHw_REG_SOFT_RESET_CHIP_SOFT)
+      {
+         chipcHw_softReset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+      }
+      /* Bypass the PLL clocks before reboot */
+      pChipcHw->UARTClock |= chipcHw_REG_PLL_CLOCK_BYPASS_SELECT;
+      pChipcHw->SPIClock |= chipcHw_REG_PLL_CLOCK_BYPASS_SELECT;
+
+      /* Copy the chipcHw_warmReset_run_from_aram function into ARAM */
+      do
+      {
+         ((uint32_t *)MM_IO_BASE_ARAM)[i] = ((uint32_t *)&chipcHw_reset_run_from_aram)[i];
+         i++;
+      }
+      while (( (uint32_t *)MM_IO_BASE_ARAM)[i-1] != 0xe1a0f00f); // 0xe1a0f00f == asm ("mov r15, r15");
+
+      CSP_CACHE_FLUSH_ALL;
+
+      /* run the function from ARAM */
+      runFunc();
+
+      // Code will never get here, but include it to balance REG_LOCAL_IRQ_SAVE above
+      REG_LOCAL_IRQ_RESTORE;
+   }
+}
+
+/* This function must run from internal memory */
+void chipcHw_reset_run_from_aram( void )
+{
+/* Make sure, pipeline is filled with instructions coming from ARAM */
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+#if defined( __KERNEL__ ) && !defined( STANDALONE )
+asm(" MRC      p15,#0x0,r0,c1,c0,#0        ");
+asm(" BIC      r0,r0,#0xd                                            ");
+asm(" MCR      p15,#0x0,r0,c1,c0,#0       ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+#endif
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+   /* Bypass the ARM clock and switch to XTAL clock */
+asm(" MOV      r2,#0x80000000                                        ");
+asm(" LDR      r3,[r2,#8]                                            ");
+asm(" ORR      r3,r3,#0x20000                                        ");
+asm(" STR      r3,[r2,#8]                                            ");
+
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+asm(" nop                                                            ");
+   /* Issue reset */
+asm(" MOV      r3,#0x2                                                 ");
+asm(" STR      r3,[r2,#0x80]                                         ");
+   /* End here */
+asm(" MOV      pc,pc                                                 ");
+// 0xe1a0f00f ==  asm ("mov r15, r15");
+   ;
+}
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
new file mode 100644
index 0000000..5f02d7e
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
@@ -0,0 +1,67 @@
+/*****************************************************************************
+* Copyright 2008 Broadcom Corporation.  All rights reserved.
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
+/****************************************************************************/
+/**
+*  @file    chipcHw_str.c
+*
+*  @brief   Contains strings which are useful to linux and csp
+*
+*  @note
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <mach/csp/chipcHw_inline.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+
+static const char *gMuxStr[] =
+{
+    "GPIO",         // 0
+    "KeyPad",       // 1
+    "I2C-Host",     // 2
+    "SPI",          // 3
+    "Uart",         // 4
+    "LED-Mtx-P",    // 5
+    "LED-Mtx-S",    // 6
+    "SDIO-0",       // 7
+    "SDIO-1",       // 8
+    "PCM",          // 9
+    "I2S",          // 10
+    "ETM",          // 11
+    "Debug",        // 12
+    "Misc",         // 13
+    "0xE",          // 14
+    "0xF",          // 15
+};
+
+/****************************************************************************/
+/**
+*  @brief   Retrieves a string representation of the mux setting for a pin.
+*
+*  @return  Pointer to a character string.
+*/
+/****************************************************************************/
+
+const char *chipcHw_getGpioPinFunctionStr( int pin )
+{
+    if (( pin < 0 ) || ( pin >= chipcHw_GPIO_COUNT ))
+    {
+        return "";
+    }
+
+    return gMuxStr[ chipcHw_getGpioPinFunction( pin )];
+}
+
diff --git a/arch/arm/mach-bcmring/csp/dmac/Makefile b/arch/arm/mach-bcmring/csp/dmac/Makefile
new file mode 100644
index 0000000..fb1104f
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/dmac/Makefile
@@ -0,0 +1 @@
+obj-y += dmacHw.o dmacHw_extra.o
\ No newline at end of file
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
new file mode 100644
index 0000000..2af0b4f
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
@@ -0,0 +1,1007 @@
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
+
+/****************************************************************************/
+/**
+*  @file    dmacHw.c
+*
+*  @brief   Low level DMA controller driver routines
+*
+*  @note
+*
+*   These routines provide basic DMA functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+#include <stddef.h>
+
+#include <csp/dmacHw.h>
+#include <mach/csp/dmacHw_reg.h>
+#include <mach/csp/dmacHw_priv.h>
+#include <mach/csp/chipcHw_inline.h>
+
+/* ---- External Function Prototypes ------------------------------------- */
+
+/* Allocate DMA control blocks */
+dmacHw_CBLK_t dmacHw_gCblk[dmacHw_MAX_CHANNEL_COUNT];
+
+uint32_t dmaChannelCount_0 = dmacHw_MAX_CHANNEL_COUNT / 2;
+uint32_t dmaChannelCount_1 = dmacHw_MAX_CHANNEL_COUNT / 2;
+
+/****************************************************************************/
+/**
+*  @brief   Get maximum FIFO for a DMA channel
+*
+*  @return  Maximum allowable FIFO size
+*
+*
+*/
+/****************************************************************************/
+static uint32_t GetFifoSize
+(
+   dmacHw_HANDLE_t handle                     ///<   [ IN ] DMA Channel handle
+)
+{
+   uint32_t val = 0;
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK( handle );
+   dmacHw_MISC_t *pMiscReg = (dmacHw_MISC_t*) dmacHw_REG_MISC_BASE ( pCblk->module );
+
+   switch ( pCblk->channel )
+   {
+      case 0:
+         val =  ( pMiscReg->CompParm2.lo & 0x70000000 ) >> 28;
+         break;
+      case 1:
+         val =  ( pMiscReg->CompParm3.hi & 0x70000000 ) >> 28;
+         break;
+      case 2:
+         val =  ( pMiscReg->CompParm3.lo & 0x70000000 ) >> 28;
+         break;
+      case 3:
+         val =  ( pMiscReg->CompParm4.hi & 0x70000000 ) >> 28;
+         break;
+      case 4:
+         val =  ( pMiscReg->CompParm4.lo & 0x70000000 ) >> 28;
+         break;
+      case 5:
+         val =  ( pMiscReg->CompParm5.hi & 0x70000000 ) >> 28;
+         break;
+      case 6:
+         val =  ( pMiscReg->CompParm5.lo & 0x70000000 ) >> 28;
+         break;
+      case 7:
+         val =  ( pMiscReg->CompParm6.hi & 0x70000000 ) >> 28;
+         break;
+   }
+
+   if ( val <= 0x4 )
+   {
+      return 8 << val;
+   }
+   else
+   {
+      dmacHw_ASSERT (0);
+   }
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Function to initialize memory
+*
+*  @return
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static void Memset
+(
+   void* mem,                                ///<   [ IN ] Memory address
+   char val,                                 ///<   [ IN ] Initialization value
+   uint32_t len                              ///<   [ IN ] Length of the memory
+)
+{
+   uint32_t i = 0;
+   char* ptr = (char*) mem;
+
+   for ( i = 0; i < len; i++ )
+   {
+      *ptr = val;
+      ptr++;
+   }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to initiate transfer
+*
+*  @return  void
+*
+*
+*  @note
+*     - Descriptor buffer MUST ALWAYS be flushed before calling this function
+*     - This function should also be called from ISR to program the channel with
+*       pending descriptors
+*/
+/****************************************************************************/
+void dmacHw_initiateTransfer
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+)
+{
+   dmacHw_DESC_RING_t *pRing;
+   dmacHw_DESC_t *pProg;
+   dmacHw_CBLK_t* pCblk;
+
+   pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+   pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+
+   if ( CHANNEL_BUSY ( pCblk->module, pCblk->channel ) )
+   {
+      /* Not safe yet to program the channel */
+     return;
+   }
+
+   if ( pCblk->varDataStarted )
+   {
+      if ( pCblk->descUpdated )
+      {
+         pCblk->descUpdated = 0;
+         pProg = (dmacHw_DESC_t*)((uint32_t)dmacHw_REG_LLP ( pCblk->module, pCblk->channel) + pRing->virt2PhyOffset);
+
+         /* Load descriptor if not loaded */
+         if ( ! (pProg->ctl.hi & dmacHw_REG_CTL_DONE ) )
+         {
+            dmacHw_SET_SAR ( pCblk->module, pCblk->channel, pProg->sar );
+            dmacHw_SET_DAR ( pCblk->module, pCblk->channel, pProg->dar );
+            dmacHw_REG_CTL_LO ( pCblk->module, pCblk->channel ) = pProg->ctl.lo;
+            dmacHw_REG_CTL_HI ( pCblk->module, pCblk->channel ) = pProg->ctl.hi;
+         }
+         else if ( pProg  == (dmacHw_DESC_t*)pRing->pEnd->llp )
+         {
+            /* Return as end descriptor is processed */
+            return;
+         }
+         else
+         {
+            dmacHw_ASSERT ( 0 );
+         }
+      }
+      else
+      {
+         return;
+      }
+   }
+   else
+   {
+      if ( pConfig->transferMode == dmacHw_TRANSFER_MODE_PERIODIC )
+      {
+         /* Do not make a single chain, rather process one descriptor at a time */
+         pProg = pRing->pHead;
+         /* Point to the next descriptor for next iteration */
+         dmacHw_NEXT_DESC ( pRing, pHead );
+      }
+      else
+      {
+         /* Return if no more pending descriptor */
+         if ( pRing->pEnd == NULL )
+         {
+            return;
+         }
+
+         pProg = pRing->pProg;
+         if (pConfig->transferMode == dmacHw_TRANSFER_MODE_CONTINUOUS)
+         {
+            /* Make sure a complete ring can be formed */
+            dmacHw_ASSERT ( (dmacHw_DESC_t *)pRing->pEnd->llp == pRing->pProg );
+            /* Make sure pProg pointing to the pHead */
+            dmacHw_ASSERT ( (dmacHw_DESC_t *)pRing->pProg == pRing->pHead );
+            /* Make a complete ring */
+            do
+            {
+               pRing->pProg->ctl.lo |= (dmacHw_REG_CTL_LLP_DST_EN | dmacHw_REG_CTL_LLP_SRC_EN);
+               pRing->pProg = (dmacHw_DESC_t*)pRing->pProg->llp;
+            }while (pRing->pProg != pRing->pHead);
+         }
+         else
+         {
+            /* Make a single long chain */
+            while ( pRing->pProg != pRing->pEnd )
+            {
+               pRing->pProg->ctl.lo |= (dmacHw_REG_CTL_LLP_DST_EN | dmacHw_REG_CTL_LLP_SRC_EN);
+               pRing->pProg = (dmacHw_DESC_t*)pRing->pProg->llp;
+            }
+         }
+      }
+
+      /* Program the channel registers */
+      dmacHw_SET_SAR ( pCblk->module, pCblk->channel, pProg->sar );
+      dmacHw_SET_DAR ( pCblk->module, pCblk->channel, pProg->dar );
+      dmacHw_SET_LLP ( pCblk->module, pCblk->channel, (uint32_t)pProg - pRing->virt2PhyOffset );
+      dmacHw_REG_CTL_LO ( pCblk->module, pCblk->channel ) = pProg->ctl.lo;
+      dmacHw_REG_CTL_HI ( pCblk->module, pCblk->channel ) = pProg->ctl.hi;
+      if (  pRing->pEnd )
+      {
+         /* Remember the descriptor to use next */
+         pRing->pProg = (dmacHw_DESC_t *) pRing->pEnd->llp;
+      }
+      /* Indicate no more pending descriptor  */
+      pRing->pEnd = (dmacHw_DESC_t *) NULL;
+   }
+   /* Start DMA operation */
+   dmacHw_DMA_START ( pCblk->module, pCblk->channel );
+}
+
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Initializes DMA
+*
+*  This function initializes DMA CSP driver
+*
+*  @note
+*     Must be called before using any DMA channel
+*/
+/****************************************************************************/
+void dmacHw_initDma ( void )
+{
+
+   uint32_t i = 0;
+
+   dmaChannelCount_0 = dmacHw_GET_NUM_CHANNEL(0);
+   dmaChannelCount_1 = dmacHw_GET_NUM_CHANNEL(1);
+
+   /* Enable access to the DMA block */
+   chipcHw_busInterfaceClockEnable ( chipcHw_REG_BUS_CLOCK_DMAC0 );
+   chipcHw_busInterfaceClockEnable ( chipcHw_REG_BUS_CLOCK_DMAC1 );
+
+   if ( (dmaChannelCount_0 + dmaChannelCount_1) > dmacHw_MAX_CHANNEL_COUNT )
+   {
+      dmacHw_ASSERT ( 0 );
+   }
+
+   Memset ((void*)dmacHw_gCblk, 0, sizeof (dmacHw_CBLK_t) * ( dmaChannelCount_0 + dmaChannelCount_1 ) );
+   for ( i = 0; i < dmaChannelCount_0; i++ )
+   {
+      dmacHw_gCblk[i].module = 0;
+      dmacHw_gCblk[i].channel = i;
+   }
+   for ( i = 0; i < dmaChannelCount_1; i++ )
+   {
+      dmacHw_gCblk[i + dmaChannelCount_0].module = 1;
+      dmacHw_gCblk[i + dmaChannelCount_0].channel = i;
+   }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Exit function for  DMA
+*
+*  This function isolates DMA from the system
+*
+*/
+/****************************************************************************/
+void dmacHw_exitDma ( void )
+{
+   /* Disable access to the DMA block */
+   chipcHw_busInterfaceClockDisable ( chipcHw_REG_BUS_CLOCK_DMAC0 );
+   chipcHw_busInterfaceClockDisable ( chipcHw_REG_BUS_CLOCK_DMAC1 );
+}
+
+/****************************************************************************/
+/**
+*  @brief   Gets a handle to a DMA channel
+*
+*  This function returns a handle, representing a control block of a particular DMA channel
+*
+*  @return  -1       - On Failure
+*            handle  - On Success, representing a channel control block
+*
+*  @note
+*     None  Channel ID must be created using "dmacHw_MAKE_CHANNEL_ID" macro
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getChannelHandle
+(
+   dmacHw_ID_t channelId                    ///< [ IN ] DMA Channel Id
+)
+{
+  int idx;
+
+  switch ( (channelId >> 8) )
+  {
+     case 0:
+        dmacHw_ASSERT ( (channelId & 0xff) < dmaChannelCount_0 );
+        idx = ( channelId & 0xff );
+        break;
+     case 1:
+        dmacHw_ASSERT ( (channelId & 0xff) < dmaChannelCount_1 );
+        idx = dmaChannelCount_0 + ( channelId & 0xff );
+        break;
+     default:
+        dmacHw_ASSERT (0);
+        return (dmacHw_HANDLE_t)-1;
+  }
+
+  return dmacHw_CBLK_TO_HANDLE ( & dmacHw_gCblk[idx] );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Initializes a DMA channel for use
+*
+*  This function initializes and resets a DMA channel for use
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_initChannel
+(
+   dmacHw_HANDLE_t handle                    ///<   [ IN ] DMA Channel handle
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+   int module = pCblk->module;
+   int channel = pCblk->channel;
+
+   /* Reinitialize the control block */
+   Memset ( (void*)pCblk, 0, sizeof (dmacHw_CBLK_t ) );
+   pCblk->module = module;
+   pCblk->channel = channel;
+
+   /* Enable DMA controller */
+   dmacHw_DMA_ENABLE ( pCblk->module );
+   /* Reset DMA channel */
+   dmacHw_RESET_CONTROL_LO ( pCblk->module, pCblk->channel );
+   dmacHw_RESET_CONTROL_HI ( pCblk->module, pCblk->channel );
+   dmacHw_RESET_CONFIG_LO ( pCblk->module, pCblk->channel );
+   dmacHw_RESET_CONFIG_HI ( pCblk->module, pCblk->channel );
+
+   /* Clear all raw interrupt status */
+   dmacHw_TRAN_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_BLOCK_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_ERROR_INT_CLEAR ( pCblk->module, pCblk->channel );
+
+   /* Mask event specific interrupts */
+   dmacHw_TRAN_INT_DISABLE ( pCblk->module, pCblk->channel );
+   dmacHw_BLOCK_INT_DISABLE ( pCblk->module, pCblk->channel );
+   dmacHw_STRAN_INT_DISABLE ( pCblk->module, pCblk->channel );
+   dmacHw_DTRAN_INT_DISABLE ( pCblk->module, pCblk->channel );
+   dmacHw_ERROR_INT_DISABLE ( pCblk->module, pCblk->channel );
+
+  return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief  Finds amount of memory required to form a descriptor ring
+*
+*
+*  @return   Number of bytes required to form a descriptor ring
+*
+*
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorLen
+(
+   uint32_t descCnt                               ///< [ IN ] Number of descriptor in the ring
+)
+{
+   /* Need extra 4 byte to ensure 32 bit alignment  */
+   return ( ( descCnt * sizeof(dmacHw_DESC_t) ) + sizeof (dmacHw_DESC_RING_t) + sizeof(uint32_t) );
+}
+
+/****************************************************************************/
+/**
+*  @brief   Initializes descriptor ring
+*
+*  This function will initializes the descriptor ring of a DMA channel
+*
+*
+*  @return   -1 - On failure
+*             0 - On success
+*  @note
+*     - "len" parameter should be obtained from "dmacHw_descriptorLen"
+*     - Descriptor buffer MUST be 32 bit aligned and uncached as it is
+*       accessed by ARM and DMA
+*/
+/****************************************************************************/
+int dmacHw_initDescriptor
+(
+   void     *pDescriptorVirt,        ///<  [ IN ] Virtual address of uncahced buffer allocated to form descriptor ring
+   uint32_t descriptorPhyAddr,       ///<  [ IN ] Physical address of pDescriptorVirt (descriptor buffer)
+   uint32_t len,                     ///<  [ IN ] Size of the pBuf
+   uint32_t num                      ///<  [ IN ] Number of descriptor in the ring
+)
+{
+   uint32_t i;
+   dmacHw_DESC_RING_t *pRing;
+   dmacHw_DESC_t *pDesc;
+
+   /* Check the alignment of the descriptor */
+   if ((uint32_t)pDescriptorVirt & 0x00000003 )
+   {
+      dmacHw_ASSERT (0);
+      return -1;
+   }
+
+   /* Check if enough space has been allocated for descriptor ring */
+   if ( len < dmacHw_descriptorLen ( num ) )
+   {
+      return -1;
+   }
+
+   pRing = dmacHw_GET_DESC_RING ( pDescriptorVirt );
+   pRing->pHead = (dmacHw_DESC_t *) ( (uint32_t)pRing + sizeof(dmacHw_DESC_RING_t) );
+   pRing->pFree = pRing->pTail = pRing->pEnd = pRing->pHead;
+   pRing->pProg = dmacHw_DESC_INIT;
+   /* Initialize link item chain, starting from the head */
+   pDesc = pRing->pHead;
+   /* Find the offset between virtual to physical address */
+   pRing->virt2PhyOffset = (uint32_t)pDescriptorVirt - descriptorPhyAddr;
+
+   /* Form the descriptor ring */
+   for( i = 0; i < num - 1; i++ )
+   {
+      /* Clear link list item */
+      Memset ( (void*)pDesc, 0, sizeof(dmacHw_DESC_t) );
+      /* Point to the next item in the physical address */
+      pDesc->llpPhy = (uint32_t)(pDesc + 1) - pRing->virt2PhyOffset;
+      /* Point to the next item in the virtual address */
+      pDesc->llp = (uint32_t)(pDesc + 1);
+      /* Mark descriptor is ready to use */
+      pDesc->ctl.hi = dmacHw_DESC_FREE;
+      /* Look into next link list item */
+      pDesc ++;
+   }
+
+   /* Clear last link list item */
+   Memset ( (void*) pDesc, 0, sizeof(dmacHw_DESC_t) );
+   /* Last item pointing to the first item in the
+      physical address to complete the ring */
+   pDesc->llpPhy = (uint32_t)pRing->pHead - pRing->virt2PhyOffset;
+   /* Last item pointing to the first item in the
+      virtual address to complete the ring
+   */
+   pDesc->llp = (uint32_t)pRing->pHead;
+   /* Mark descriptor is ready to use */
+   pDesc->ctl.hi = dmacHw_DESC_FREE;
+   /* Set the number of descriptors in the ring */
+   pRing->num = num;
+   return 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Configure DMA channel
+*
+*  @return  0  : On success
+*           -1 : On failure
+*/
+/****************************************************************************/
+int dmacHw_configChannel
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig                  ///<   [ IN ] Configuration settings
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+   uint32_t cfgHigh = 0;
+   int srcTrSize;
+   int dstTrSize;
+
+   pCblk->varDataStarted = 0;
+   pCblk->userData = NULL;
+
+   /* Configure
+      - Burst transaction when enough data in available in FIFO
+      - AHB Access protection 1
+      - Source and destination peripheral ports
+    */
+   cfgHigh = dmacHw_REG_CFG_HI_FIFO_ENOUGH | dmacHw_REG_CFG_HI_AHB_HPROT_1 | dmacHw_SRC_PERI_INTF(pConfig->srcPeripheralPort) | dmacHw_DST_PERI_INTF(pConfig->dstPeripheralPort);
+   /* Set priority */
+   dmacHw_SET_CHANNEL_PRIORITY ( pCblk->module, pCblk->channel, pConfig->channelPriority );
+
+   if ( pConfig->dstStatusRegisterAddress != 0 )
+   {
+      /* Destination status update enable */
+      cfgHigh |= dmacHw_REG_CFG_HI_UPDATE_DST_STAT;
+      /* Configure status registers */
+      dmacHw_SET_DSTATAR ( pCblk->module, pCblk->channel, pConfig->dstStatusRegisterAddress );
+   }
+
+   if ( pConfig->srcStatusRegisterAddress != 0 )
+   {
+      /* Source status update enable */
+      cfgHigh |= dmacHw_REG_CFG_HI_UPDATE_SRC_STAT;
+      /* Source status update enable */
+      dmacHw_SET_SSTATAR ( pCblk->module, pCblk->channel, pConfig->srcStatusRegisterAddress );
+   }
+   /* Configure the config high register */
+   dmacHw_GET_CONFIG_HI(pCblk->module, pCblk->channel) = cfgHigh;
+
+   /* Clear all raw interrupt status */
+   dmacHw_TRAN_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_BLOCK_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_ERROR_INT_CLEAR ( pCblk->module, pCblk->channel );
+
+   /* Configure block interrupt */
+   if ( pConfig->blockTransferInterrupt == dmacHw_INTERRUPT_ENABLE )
+   {
+      dmacHw_BLOCK_INT_ENABLE ( pCblk->module, pCblk->channel );
+   }
+   else
+   {
+      dmacHw_BLOCK_INT_DISABLE ( pCblk->module, pCblk->channel );
+   }
+   /* Configure complete transfer interrupt */
+   if ( pConfig->completeTransferInterrupt == dmacHw_INTERRUPT_ENABLE )
+   {
+      dmacHw_TRAN_INT_ENABLE ( pCblk->module, pCblk->channel );
+   }
+   else
+   {
+      dmacHw_TRAN_INT_DISABLE ( pCblk->module, pCblk->channel );
+   }
+   /* Configure error interrupt */
+   if ( pConfig->errorInterrupt == dmacHw_INTERRUPT_ENABLE )
+   {
+      dmacHw_ERROR_INT_ENABLE ( pCblk->module, pCblk->channel );
+   }
+   else
+   {
+      dmacHw_ERROR_INT_DISABLE ( pCblk->module, pCblk->channel );
+   }
+   /* Configure gather register */
+   if (pConfig->srcGatherWidth )
+   {
+      srcTrSize = dmacHw_GetTrWidthInBytes ( pConfig->srcMaxTransactionWidth );
+      if ( ! (( pConfig->srcGatherWidth % srcTrSize ) && ( pConfig->srcGatherJump % srcTrSize )) )
+      {
+         dmacHw_REG_SGR_LO(pCblk->module, pCblk->channel) = ( (pConfig->srcGatherWidth / srcTrSize) << 20 ) | ( pConfig->srcGatherJump / srcTrSize );
+      }
+      else
+      {
+         return -1;
+      }
+   }
+   /* Configure scatter register */
+   if ( pConfig->dstScatterWidth )
+   {
+      dstTrSize = dmacHw_GetTrWidthInBytes ( pConfig->dstMaxTransactionWidth );
+      if (  ! (( pConfig->dstScatterWidth % dstTrSize ) && ( pConfig->dstScatterJump % dstTrSize )) )
+      {
+         dmacHw_REG_DSR_LO(pCblk->module, pCblk->channel) = ( (pConfig->dstScatterWidth / dstTrSize) << 20 ) | ( pConfig->dstScatterJump / dstTrSize );
+      }
+      else
+      {
+         return -1;
+      }
+   }
+   return 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Indicates whether DMA transfer is in progress or completed
+*
+*  @return   DMA transfer status
+*          dmacHw_TRANSFER_STATUS_BUSY:         DMA Transfer ongoing
+*          dmacHw_TRANSFER_STATUS_DONE:         DMA Transfer completed
+*          dmacHw_TRANSFER_STATUS_ERROR:        DMA Transfer error
+*
+*/
+/****************************************************************************/
+dmacHw_TRANSFER_STATUS_e dmacHw_transferCompleted
+(
+   dmacHw_HANDLE_t handle                    ///<   [ IN ] DMA Channel handle
+)
+{
+  dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+  if ( CHANNEL_BUSY ( pCblk->module, pCblk->channel ) )
+  {
+     return dmacHw_TRANSFER_STATUS_BUSY;
+  }
+  else if ( dmacHw_REG_INT_RAW_ERROR ( pCblk->module ) & ( 0x00000001 << pCblk->channel ) )
+  {
+     return dmacHw_TRANSFER_STATUS_ERROR;
+  }
+
+  return dmacHw_TRANSFER_STATUS_DONE;
+}
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptors for known data length
+*
+*  When DMA has to work as a flow controller, this function prepares the
+*  descriptor chain to transfer data
+*
+*  from:
+*          - Memory to memory
+*          - Peripheral to memory
+*          - Memory to Peripheral
+*          - Peripheral to Peripheral
+*
+*  @return   -1 - On failure
+*             0 - On success
+*
+*/
+/****************************************************************************/
+int dmacHw_setDataDescriptor
+(
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   void* pSrcAddr,                           ///<   [ IN ] Source (Peripheral/Memory) address
+   void* pDstAddr,                           ///<   [ IN ] Destination (Peripheral/Memory) address
+   size_t dataLen                            ///<   [ IN ] Data length in bytes
+)
+{
+   dmacHw_TRANSACTION_WIDTH_e dstTrWidth;
+   dmacHw_TRANSACTION_WIDTH_e srcTrWidth;
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+   dmacHw_DESC_t *pStart;
+   dmacHw_DESC_t *pProg;
+   int srcTs = 0;
+   int blkTs = 0;
+   int oddSize = 0;
+   int descCount = 0;
+   int count = 0;
+   int dstTrSize = 0;
+   int srcTrSize = 0;
+   uint32_t maxBlockSize = dmacHw_MAX_BLOCKSIZE;
+
+   dstTrSize = dmacHw_GetTrWidthInBytes ( pConfig->dstMaxTransactionWidth );
+   srcTrSize = dmacHw_GetTrWidthInBytes ( pConfig->srcMaxTransactionWidth );
+
+   /* Skip Tx if buffer is NULL  or length is unknown */
+   if (( pSrcAddr == NULL ) || ( pDstAddr == NULL ) || ( dataLen == 0 ))
+   {
+      /* Do not initiate transfer */
+      return -1;
+   }
+
+   /* Ensure scatter and gather are transaction aligned */
+   if ( ( pConfig->srcGatherWidth % srcTrSize ) || ( pConfig->dstScatterWidth % dstTrSize ) )
+   {
+      return -2;
+   }
+
+   /*
+      Background 1: DMAC can not perform DMA if source and destination addresses are
+      not properly aligned with the channel's transaction width. So, for successful
+      DMA transfer, transaction width must be set according to the alignment of the
+      source and destination address.
+   */
+
+   /* Adjust destination transaction width if destination address is not aligned properly */
+   dstTrWidth = pConfig->dstMaxTransactionWidth;
+   while ( dmacHw_ADDRESS_MASK ( dstTrSize ) & (uint32_t) pDstAddr )
+   {
+      dstTrWidth = dmacHw_GetNextTrWidth ( dstTrWidth );
+      dstTrSize = dmacHw_GetTrWidthInBytes ( dstTrWidth );
+   }
+
+   /* Adjust source transaction width if source address is not aligned properly */
+   srcTrWidth = pConfig->srcMaxTransactionWidth;
+   while ( dmacHw_ADDRESS_MASK ( srcTrSize ) & (uint32_t) pSrcAddr )
+   {
+      srcTrWidth = dmacHw_GetNextTrWidth ( srcTrWidth );
+      srcTrSize = dmacHw_GetTrWidthInBytes ( srcTrWidth );
+   }
+
+   /* Find the maximum transaction per descriptor */
+   if ( pConfig->maxDataPerBlock && (( pConfig->maxDataPerBlock / srcTrSize ) < dmacHw_MAX_BLOCKSIZE ) )
+   {
+      maxBlockSize = pConfig->maxDataPerBlock / srcTrSize;
+   }
+
+   /* Find number of source transactions needed to complete the DMA transfer */
+   srcTs = dataLen / srcTrSize;
+   /* Find the odd number of bytes that need to be transferred as single byte transaction width */
+   if ( srcTs && ( dstTrSize > srcTrSize ) )
+   {
+      oddSize = dataLen % dstTrSize;
+      /* Adjust source transaction count due to "oddSize" */
+      srcTs   = srcTs - ( oddSize / srcTrSize );
+   }
+   else
+   {
+      oddSize = dataLen % srcTrSize;
+   }
+   /* Adjust "descCount" due to "oddSize" */
+   if ( oddSize )
+   {
+      descCount ++;
+   }
+   /* Find the number of descriptor needed for total "srcTs" */
+   if ( srcTs )
+   {
+     descCount += ( ( srcTs - 1 ) / maxBlockSize ) + 1;
+   }
+
+   /* Check the availability of "descCount" discriptors in the ring */
+   pProg = pRing->pHead;
+   for ( count = 0; ( descCount <= pRing->num ) && ( count < descCount ); count ++ )
+   {
+      if ( ( pProg->ctl.hi & dmacHw_DESC_FREE ) == 0 )
+      {
+         /* Sufficient descriptors are not available */
+         return -3;
+      }
+      pProg = (dmacHw_DESC_t*) pProg->llp;
+   }
+
+   /* Remember the link list item to program the channel registers */
+   pStart = pProg = pRing->pHead;
+   /* Make a link list with "descCount(=count)" number of descriptors */
+   while ( count )
+   {
+      /* Reset channel control information */
+      pProg->ctl.lo = 0;
+      /* Enable source gather if configured */
+      if ( pConfig->srcGatherWidth )
+      {
+         pProg->ctl.lo |= dmacHw_REG_CTL_SG_ENABLE;
+      }
+      /* Enable destination scatter if configured */
+      if ( pConfig->dstScatterWidth )
+      {
+         pProg->ctl.lo |= dmacHw_REG_CTL_DS_ENABLE;
+      }
+      /* Set source and destination address */
+      pProg->sar = (uint32_t) pSrcAddr;
+      pProg->dar = (uint32_t) pDstAddr;
+      /* Use "devCtl" to mark that user memory need to be freed later if needed */
+      if ( pProg == pRing->pHead )
+      {
+         pProg->devCtl = dmacHw_FREE_USER_MEMORY;
+      }
+      else
+      {
+         pProg->devCtl = 0;
+      }
+
+      blkTs = srcTs;
+
+      /* Special treatmeant for last descriptor */
+      if ( count == 1 )
+      {
+         /* Mark the last descriptor */
+         pProg->ctl.lo &= ~( dmacHw_REG_CTL_LLP_DST_EN | dmacHw_REG_CTL_LLP_SRC_EN );
+         /* Treatment for odd data bytes */
+         if ( oddSize )
+         {
+            /* Adjust for single byte transaction width */
+            switch ( pConfig->transferType )
+            {
+               case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM:
+                  dstTrWidth = dmacHw_DST_TRANSACTION_WIDTH_8;
+                  blkTs = ( oddSize / srcTrSize ) + ( ( oddSize % srcTrSize ) ? 1 : 0 );
+                  break;
+               case dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL:
+                  srcTrWidth = dmacHw_SRC_TRANSACTION_WIDTH_8;
+                  blkTs = oddSize;
+                  break;
+               case dmacHw_TRANSFER_TYPE_MEM_TO_MEM:
+                  srcTrWidth = dmacHw_SRC_TRANSACTION_WIDTH_8;
+                  dstTrWidth = dmacHw_DST_TRANSACTION_WIDTH_8;
+                  blkTs = oddSize;
+                  break;
+               case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_PERIPHERAL:
+                  /* Do not adjust the transaction width  */
+                  break;
+            }
+         }
+         else
+         {
+            srcTs -= blkTs;
+         }
+      }
+      else
+      {
+         if ( srcTs / maxBlockSize )
+         {
+            blkTs = maxBlockSize;
+         }
+         /* Remaining source transactions for next iteration */
+         srcTs -= blkTs;
+      }
+      /* Must have a valid source transactions */
+      dmacHw_ASSERT ( blkTs > 0 );
+      /* Set control information */
+      if ( pConfig->flowControler == dmacHw_FLOW_CONTROL_DMA )
+      {
+         pProg->ctl.lo |= pConfig->transferType |
+                          pConfig->srcUpdate |
+                          pConfig->dstUpdate |
+                          srcTrWidth |
+                          dstTrWidth |
+                          pConfig->srcMaxBurstWidth |
+                          pConfig->dstMaxBurstWidth |
+                          pConfig->srcMasterInterface |
+                          pConfig->dstMasterInterface |
+                          dmacHw_REG_CTL_INT_EN;
+      }
+      else
+      {
+         uint32_t transferType = 0;
+         switch ( pConfig->transferType )
+         {
+            case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM:
+               transferType = dmacHw_REG_CTL_TTFC_PM_PERI;
+               break;
+            case dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL:
+               transferType = dmacHw_REG_CTL_TTFC_MP_PERI;
+               break;
+            default:
+               dmacHw_ASSERT (0);
+         }
+         pProg->ctl.lo |= transferType |
+                          pConfig->srcUpdate |
+                          pConfig->dstUpdate |
+                          srcTrWidth |
+                          dstTrWidth |
+                          pConfig->srcMaxBurstWidth |
+                          pConfig->dstMaxBurstWidth |
+                          pConfig->srcMasterInterface |
+                          pConfig->dstMasterInterface |
+                          dmacHw_REG_CTL_INT_EN;
+      }
+
+      /* Set block transaction size */
+      pProg->ctl.hi = blkTs  & dmacHw_REG_CTL_BLOCK_TS_MASK;
+      /* Look for next descriptor */
+      if ( count > 1 )
+      {
+         /* Point to the next descriptor */
+         pProg = (dmacHw_DESC_t*) pProg->llp;
+
+         /* Update source and destination address for next iteration */
+         switch ( pConfig->transferType )
+         {
+            case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM:
+               if ( pConfig->dstScatterWidth )
+               {
+                  pDstAddr = (char*)pDstAddr + blkTs * srcTrSize + ( ( (blkTs * srcTrSize ) / pConfig->dstScatterWidth ) * pConfig->dstScatterJump );
+               }
+               else
+               {
+                  pDstAddr = (char*)pDstAddr + blkTs * srcTrSize;
+               }
+               break;
+            case dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL:
+               if ( pConfig->srcGatherWidth )
+               {
+                  pSrcAddr = (char*)pDstAddr + blkTs * srcTrSize + ( ( (blkTs * srcTrSize ) / pConfig->srcGatherWidth ) * pConfig->srcGatherJump );
+               }
+               else
+               {
+                  pSrcAddr = (char*)pSrcAddr + blkTs * srcTrSize;
+               }
+               break;
+            case dmacHw_TRANSFER_TYPE_MEM_TO_MEM:
+               if ( pConfig->dstScatterWidth )
+               {
+                  pDstAddr = (char*)pDstAddr + blkTs * srcTrSize + ( ( (blkTs * srcTrSize ) / pConfig->dstScatterWidth ) * pConfig->dstScatterJump );
+               }
+               else
+               {
+                  pDstAddr = (char*)pDstAddr + blkTs * srcTrSize;
+               }
+
+               if ( pConfig->srcGatherWidth )
+               {
+                  pSrcAddr = (char*)pDstAddr + blkTs * srcTrSize + ( ( (blkTs * srcTrSize ) / pConfig->srcGatherWidth ) * pConfig->srcGatherJump );
+               }
+               else
+               {
+                  pSrcAddr = (char*)pSrcAddr + blkTs * srcTrSize;
+               }
+               break;
+            case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_PERIPHERAL:
+               /* Do not adjust the address */
+               break;
+            default:
+               dmacHw_ASSERT (0);
+         }
+      }
+      else
+      {
+         /* At the end of transfer "srcTs" must be zero */
+         dmacHw_ASSERT ( srcTs == 0 );
+      }
+      count --;
+   }
+
+   /* Remember the descriptor to initialize the registers */
+   if ( pRing->pProg == dmacHw_DESC_INIT )
+   {
+      pRing->pProg = pStart;
+   }
+   /* Indicate that the descriptor is updated */
+   pRing->pEnd = pProg;
+   /* Head pointing to the next descriptor */
+   pRing->pHead = (dmacHw_DESC_t*) pProg->llp;
+   /* Update Tail pointer if destination is a peripheral,
+      because no one is going to read from the pTail
+   */
+   if ( ! dmacHw_DST_IS_MEMORY ( pConfig->transferType ) )
+   {
+      pRing->pTail = pRing->pHead;
+   }
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Provides DMA controller attributes
+*
+*
+*  @return  DMA controller attributes
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+uint32_t dmacHw_getDmaControllerAttribute
+(
+   dmacHw_HANDLE_t handle,             ///<  [ IN ]  DMA Channel handle
+   dmacHw_CONTROLLER_ATTRIB_e  attr    ///<  [ IN ]  DMA Controler attribute of type  dmacHw_CONTROLLER_ATTRIB_e
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+   switch ( attr )
+   {
+      case dmacHw_CONTROLLER_ATTRIB_CHANNEL_NUM:
+         return dmacHw_GET_NUM_CHANNEL ( pCblk->module );
+      case dmacHw_CONTROLLER_ATTRIB_CHANNEL_MAX_BLOCK_SIZE:
+         return ((1 << (dmacHw_GET_MAX_BLOCK_SIZE ( pCblk->module, pCblk->module ) + 2)) - 8);
+      case dmacHw_CONTROLLER_ATTRIB_MASTER_INTF_NUM:
+         return dmacHw_GET_NUM_INTERFACE ( pCblk->module );
+      case dmacHw_CONTROLLER_ATTRIB_CHANNEL_BUS_WIDTH:
+        return 32 << dmacHw_GET_CHANNEL_DATA_WIDTH ( pCblk->module, pCblk->channel );
+      case dmacHw_CONTROLLER_ATTRIB_CHANNEL_FIFO_SIZE:
+         return GetFifoSize ( handle );
+   }
+   dmacHw_ASSERT (0);
+   return 0;
+}
+
+
+
+
+
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
new file mode 100644
index 0000000..53bfeec
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
@@ -0,0 +1,1040 @@
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
+
+/****************************************************************************/
+/**
+*  @file    dmacHw_extra.c
+*
+*  @brief   Extra Low level DMA controller driver routines
+*
+*  @note
+*
+*   These routines provide basic DMA functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/stdint.h>
+#include <stddef.h>
+
+#include <csp/dmacHw.h>
+#include <mach/csp/dmacHw_reg.h>
+#include <mach/csp/dmacHw_priv.h>
+
+extern dmacHw_CBLK_t dmacHw_gCblk[dmacHw_MAX_CHANNEL_COUNT]; /* Declared in dmacHw.c */
+
+/* ---- External Function Prototypes ------------------------------------- */
+
+/* ---- Internal Use Function Prototypes --------------------------------- */
+/****************************************************************************/
+/**
+*  @brief   Overwrites data length in the descriptor
+*
+*  This function overwrites data length in the descriptor
+*
+*
+*  @return   void
+*
+*  @note
+*          This is only used for PCM channel
+*/
+/****************************************************************************/
+void dmacHw_setDataLength
+(
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   size_t dataLen                            ///<   [ IN ] Data length in bytes
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Helper function to display DMA registers
+*
+*  @return  void
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static void DisplayRegisterContents
+(
+   int module,                               ///<   [ IN ] DMA Controller unit  (0-1)
+   int channel,                              ///<   [ IN ] DMA Channel          (0-7) / -1(all)
+   int (*fpPrint) (const char *, ...)                 ///<   [ IN ] Callback to the print function
+)
+{
+   int chan;
+
+   (*fpPrint) ( "Displaying register content \n\n");
+   (*fpPrint) ( "Module %d: Interrupt raw transfer              0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_RAW_TRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt raw block                 0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_RAW_BLOCK ( module )));
+   (*fpPrint) ( "Module %d: Interrupt raw src transfer          0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_RAW_STRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt raw dst transfer          0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_RAW_DTRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt raw error                 0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_RAW_ERROR ( module )));
+   (*fpPrint) ( "--------------------------------------------------\n");
+   (*fpPrint) ( "Module %d: Interrupt stat transfer             0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_STAT_TRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt stat block                0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_STAT_BLOCK ( module )));
+   (*fpPrint) ( "Module %d: Interrupt stat src transfer         0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_STAT_STRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt stat dst transfer         0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_STAT_DTRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt stat error                0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_STAT_ERROR ( module )));
+   (*fpPrint) ( "--------------------------------------------------\n");
+   (*fpPrint) ( "Module %d: Interrupt mask transfer             0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_MASK_TRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt mask block                0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_MASK_BLOCK ( module )));
+   (*fpPrint) ( "Module %d: Interrupt mask src transfer         0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_MASK_STRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt mask dst transfer         0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_MASK_DTRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt mask error                0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_MASK_ERROR ( module )));
+   (*fpPrint) ( "--------------------------------------------------\n");
+   (*fpPrint) ( "Module %d: Interrupt clear transfer            0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_CLEAR_TRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt clear block               0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_CLEAR_BLOCK ( module )));
+   (*fpPrint) ( "Module %d: Interrupt clear src transfer        0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_CLEAR_STRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt clear dst transfer        0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_CLEAR_DTRAN ( module )));
+   (*fpPrint) ( "Module %d: Interrupt clear error               0x%X\n",         module, (uint32_t)(dmacHw_REG_INT_CLEAR_ERROR ( module )));
+   (*fpPrint) ( "--------------------------------------------------\n");
+   (*fpPrint) ( "Module %d: SW source req                       0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_SRC_REQ ( module )));
+   (*fpPrint) ( "Module %d: SW dest req                         0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_DST_REQ ( module )));
+   (*fpPrint) ( "Module %d: SW source signal                    0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_SRC_SGL_REQ ( module )));
+   (*fpPrint) ( "Module %d: SW dest signal                      0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_DST_SGL_REQ ( module )));
+   (*fpPrint) ( "Module %d: SW source last                      0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_SRC_LST_REQ ( module )));
+   (*fpPrint) ( "Module %d: SW dest last                        0x%X\n",         module, (uint32_t)(dmacHw_REG_SW_HS_DST_LST_REQ ( module )));
+   (*fpPrint) ( "--------------------------------------------------\n");
+   (*fpPrint) ( "Module %d: misc config                         0x%X\n",         module, (uint32_t)(dmacHw_REG_MISC_CFG ( module )));
+   (*fpPrint) ( "Module %d: misc channel enable                 0x%X\n",         module, (uint32_t)(dmacHw_REG_MISC_CH_ENABLE ( module )));
+   (*fpPrint) ( "Module %d: misc ID                             0x%X\n",         module, (uint32_t)(dmacHw_REG_MISC_ID ( module )));
+   (*fpPrint) ( "Module %d: misc test                           0x%X\n",         module, (uint32_t)(dmacHw_REG_MISC_TEST ( module )));
+
+   if ( channel == -1 )
+   {
+      for ( chan = 0; chan < 8; chan ++ )
+      {
+         (*fpPrint) ( "--------------------------------------------------\n");
+         (*fpPrint) ( "Module %d: Channel %d Source                   0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SAR ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Destination              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DAR ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d LLP                      0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_LLP ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Control (LO)             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CTL_LO ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Control (HI)             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CTL_HI ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Source Stats             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SSTAT ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Dest Stats               0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DSTAT ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Source Stats Addr        0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SSTATAR ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Dest Stats Addr          0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DSTATAR ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Config (LO)              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CFG_LO ( module, chan )));
+         (*fpPrint) ( "Module %d: Channel %d Config (HI)              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CFG_HI ( module, chan )));
+      }
+   }
+   else
+   {
+      chan = channel;
+      (*fpPrint) ( "--------------------------------------------------\n");
+      (*fpPrint) ( "Module %d: Channel %d Source                   0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SAR ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Destination              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DAR ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d LLP                      0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_LLP ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Control (LO)             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CTL_LO ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Control (HI)             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CTL_HI ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Source Stats             0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SSTAT ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Dest Stats               0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DSTAT ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Source Stats Addr        0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_SSTATAR ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Dest Stats Addr          0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_DSTATAR ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Config (LO)              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CFG_LO ( module, chan )));
+      (*fpPrint) ( "Module %d: Channel %d Config (HI)              0x%X\n",         module, chan, (uint32_t)(dmacHw_REG_CFG_HI ( module, chan )));
+   }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Helper function to display descriptor ring
+*
+*  @return  void
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static void DisplayDescRing
+(
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   int (*fpPrint) (const char *, ...)                 ///<   [ IN ] Callback to the print function
+)
+{
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+   dmacHw_DESC_t* pStart;
+
+   if ( pRing->pHead == NULL )
+   {
+      return;
+   }
+
+   pStart = pRing->pHead;
+
+   while ( (dmacHw_DESC_t*) pStart->llp != pRing->pHead )
+   {
+      if ( pStart == pRing->pHead )
+      {
+        (*fpPrint) ( "Head\n");
+      }
+      if ( pStart == pRing->pTail )
+      {
+        (*fpPrint) ( "Tail\n");
+      }
+      if ( pStart == pRing->pProg )
+      {
+        (*fpPrint) ( "Prog\n");
+      }
+      if ( pStart == pRing->pEnd )
+      {
+        (*fpPrint) ( "End\n");
+      }
+      if ( pStart == pRing->pFree )
+      {
+        (*fpPrint) ( "Free\n");
+      }
+      (*fpPrint) ( "0x%X:\n", (uint32_t)pStart);
+      (*fpPrint) ( "sar    0x%0X\n", pStart->sar );
+      (*fpPrint) ( "dar    0x%0X\n", pStart->dar );
+      (*fpPrint) ( "llp    0x%0X\n", pStart->llp );
+      (*fpPrint) ( "ctl.lo 0x%0X\n", pStart->ctl.lo );
+      (*fpPrint) ( "ctl.hi 0x%0X\n", pStart->ctl.hi );
+      (*fpPrint) ( "sstat  0x%0X\n", pStart->sstat );
+      (*fpPrint) ( "dstat  0x%0X\n", pStart->dstat );
+      (*fpPrint) ( "devCtl 0x%0X\n", pStart->devCtl );
+
+      pStart = (dmacHw_DESC_t*)pStart->llp;
+   }
+   if ( pStart == pRing->pHead )
+   {
+      (*fpPrint) ( "Head\n");
+   }
+   if ( pStart == pRing->pTail )
+   {
+      (*fpPrint) ( "Tail\n");
+   }
+   if ( pStart == pRing->pProg )
+   {
+      (*fpPrint) ( "Prog\n");
+   }
+   if ( pStart == pRing->pEnd )
+   {
+      (*fpPrint) ( "End\n");
+   }
+   if ( pStart == pRing->pFree )
+   {
+      (*fpPrint) ( "Free\n");
+   }
+   (*fpPrint) ( "0x%X:\n", (uint32_t)pStart);
+   (*fpPrint) ( "sar    0x%0X\n", pStart->sar );
+   (*fpPrint) ( "dar    0x%0X\n", pStart->dar );
+   (*fpPrint) ( "llp    0x%0X\n", pStart->llp );
+   (*fpPrint) ( "ctl.lo 0x%0X\n", pStart->ctl.lo );
+   (*fpPrint) ( "ctl.hi 0x%0X\n", pStart->ctl.hi );
+   (*fpPrint) ( "sstat  0x%0X\n", pStart->sstat );
+   (*fpPrint) ( "dstat  0x%0X\n", pStart->dstat );
+   (*fpPrint) ( "devCtl 0x%0X\n", pStart->devCtl );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Check if DMA channel is the flow controller
+*
+*  @return  1 : If DMA is a flow controler
+*           0 : Peripheral is the flow controller
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static inline int DmaIsFlowController
+(
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+)
+{
+   uint32_t ttfc = (dmacHw_GET_DESC_RING ( pDescriptor ))->pTail->ctl.lo & dmacHw_REG_CTL_TTFC_MASK;
+
+   switch ( ttfc )
+   {
+      case dmacHw_REG_CTL_TTFC_MM_DMAC:
+      case dmacHw_REG_CTL_TTFC_MP_DMAC:
+      case dmacHw_REG_CTL_TTFC_PM_DMAC:
+      case dmacHw_REG_CTL_TTFC_PP_DMAC:
+         return 1;
+   }
+
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Overwrites data length in the descriptor
+*
+*  This function overwrites data length in the descriptor
+*
+*
+*  @return   void
+*
+*  @note
+*          This is only used for PCM channel
+*/
+/****************************************************************************/
+void dmacHw_setDataLength
+(
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   size_t dataLen                            ///<   [ IN ] Data length in bytes
+)
+{
+   dmacHw_DESC_t *pProg;
+   dmacHw_DESC_t *pHead;
+   int srcTs = 0;
+   int srcTrSize = 0;
+
+   pHead = (dmacHw_GET_DESC_RING ( pDescriptor ))->pHead;
+   pProg = pHead;
+
+   srcTrSize = dmacHw_GetTrWidthInBytes ( pConfig->srcMaxTransactionWidth );
+   srcTs = dataLen / srcTrSize;
+   do
+   {
+      pProg->ctl.hi = srcTs  & dmacHw_REG_CTL_BLOCK_TS_MASK;
+      pProg = (dmacHw_DESC_t *)pProg->llp;
+   }while (pProg != pHead);
+}
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Clears the interrupt
+*
+*  This function clears the DMA channel specific interrupt
+*
+*
+*  @return   void
+*
+*  @note
+*     Must be called under the context of ISR
+*/
+/****************************************************************************/
+void dmacHw_clearInterrupt
+(
+   dmacHw_HANDLE_t handle                    ///< [ IN ] DMA Channel handle
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+   dmacHw_TRAN_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_BLOCK_INT_CLEAR ( pCblk->module, pCblk->channel );
+   dmacHw_ERROR_INT_CLEAR ( pCblk->module, pCblk->channel );
+}
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Returns the cause of channel specific DMA interrupt
+*
+*  This function returns the cause of interrupt
+*
+*  @return  Interrupt status, each bit representing a specific type of interrupt
+*
+*  @note
+*     Should be called under the context of ISR
+*/
+/****************************************************************************/
+dmacHw_INTERRUPT_STATUS_e dmacHw_getInterruptStatus
+(
+   dmacHw_HANDLE_t handle                    ///< [ IN ] DMA Channel handle
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+   dmacHw_INTERRUPT_STATUS_e status = dmacHw_INTERRUPT_STATUS_NONE;
+
+   if ( dmacHw_REG_INT_STAT_TRAN ( pCblk->module ) & ( (0x00000001 << pCblk->channel) ) )
+   {
+      status |= dmacHw_INTERRUPT_STATUS_TRANS;
+   }
+   if ( dmacHw_REG_INT_STAT_BLOCK ( pCblk->module ) & ( (0x00000001 << pCblk->channel) ) )
+   {
+      status |= dmacHw_INTERRUPT_STATUS_BLOCK;
+   }
+   if ( dmacHw_REG_INT_STAT_ERROR ( pCblk->module ) & ( (0x00000001 << pCblk->channel) ) )
+   {
+      status |= dmacHw_INTERRUPT_STATUS_ERROR;
+   }
+
+   return status;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Indentifies a DMA channel causing interrupt
+*
+*  This functions returns a channel causing interrupt of type dmacHw_INTERRUPT_STATUS_e
+*
+*  @return  NULL   : No channel causing DMA interrupt
+*           ! NULL : Handle to a channel causing DMA interrupt
+*  @note
+*     dmacHw_clearInterrupt() must be called with a valid handle after calling this function
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getInterruptSource( void )
+{
+   uint32_t i;
+
+   for ( i = 0; i < dmaChannelCount_0 + dmaChannelCount_1; i++ )
+   {
+      if ( (dmacHw_REG_INT_STAT_TRAN ( dmacHw_gCblk[i].module ) & ( (0x00000001 << dmacHw_gCblk[i].channel) )) ||
+           (dmacHw_REG_INT_STAT_BLOCK ( dmacHw_gCblk[i].module ) & ( (0x00000001 << dmacHw_gCblk[i].channel) )) ||
+           (dmacHw_REG_INT_STAT_ERROR ( dmacHw_gCblk[i].module ) & ( (0x00000001 << dmacHw_gCblk[i].channel) ))
+           )
+      {
+         return dmacHw_CBLK_TO_HANDLE ( & dmacHw_gCblk[i] );
+      }
+   }
+   return dmacHw_CBLK_TO_HANDLE ( NULL );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief  Estimates number of descriptor needed to perform certain DMA transfer
+*
+*
+*  @return  On failure : -1
+*           On success : Number of descriptor count
+*
+*
+*/
+/****************************************************************************/
+int dmacHw_calculateDescriptorCount
+(
+  dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+  void* pSrcAddr,                           ///<   [ IN ] Source (Peripheral/Memory) address
+  void* pDstAddr,                           ///<   [ IN ] Destination (Peripheral/Memory) address
+  size_t dataLen                            ///<   [ IN ] Data length in bytes
+)
+{
+   int srcTs = 0;
+   int oddSize = 0;
+   int descCount = 0;
+   int dstTrSize = 0;
+   int srcTrSize = 0;
+   uint32_t maxBlockSize = dmacHw_MAX_BLOCKSIZE;
+   dmacHw_TRANSACTION_WIDTH_e dstTrWidth;
+   dmacHw_TRANSACTION_WIDTH_e srcTrWidth;
+
+   dstTrSize = dmacHw_GetTrWidthInBytes ( pConfig->dstMaxTransactionWidth );
+   srcTrSize = dmacHw_GetTrWidthInBytes ( pConfig->srcMaxTransactionWidth );
+
+   /* Skip Tx if buffer is NULL  or length is unknown */
+   if (( pSrcAddr == NULL ) || ( pDstAddr == NULL ) || ( dataLen == 0 ))
+   {
+      /* Do not initiate transfer */
+      return -1;
+   }
+
+   /* Ensure scatter and gather are transaction aligned */
+   if ( pConfig->srcGatherWidth % srcTrSize || pConfig->dstScatterWidth % dstTrSize )
+   {
+      return -1;
+   }
+
+   /*
+      Background 1: DMAC can not perform DMA if source and destination addresses are
+      not properly aligned with the channel's transaction width. So, for successful
+      DMA transfer, transaction width must be set according to the alignment of the
+      source and destination address.
+   */
+
+   /* Adjust destination transaction width if destination address is not aligned properly */
+   dstTrWidth = pConfig->dstMaxTransactionWidth;
+   while ( dmacHw_ADDRESS_MASK ( dstTrSize ) & (uint32_t) pDstAddr )
+   {
+      dstTrWidth = dmacHw_GetNextTrWidth ( dstTrWidth );
+      dstTrSize = dmacHw_GetTrWidthInBytes ( dstTrWidth );
+   }
+
+   /* Adjust source transaction width if source address is not aligned properly */
+   srcTrWidth = pConfig->srcMaxTransactionWidth;
+   while ( dmacHw_ADDRESS_MASK( srcTrSize ) & (uint32_t) pSrcAddr )
+   {
+      srcTrWidth = dmacHw_GetNextTrWidth ( srcTrWidth );
+      srcTrSize = dmacHw_GetTrWidthInBytes ( srcTrWidth );
+   }
+
+   /* Find the maximum transaction per descriptor */
+   if ( pConfig->maxDataPerBlock && (( pConfig->maxDataPerBlock / srcTrSize ) < dmacHw_MAX_BLOCKSIZE ) )
+   {
+      maxBlockSize = pConfig->maxDataPerBlock / srcTrSize;
+   }
+
+   /* Find number of source transactions needed to complete the DMA transfer */
+   srcTs = dataLen / srcTrSize;
+   /* Find the odd number of bytes that need to be transferred as single byte transaction width */
+   if ( srcTs && ( dstTrSize > srcTrSize ) )
+   {
+      oddSize = dataLen % dstTrSize;
+      /* Adjust source transaction count due to "oddSize" */
+      srcTs   = srcTs - ( oddSize / srcTrSize );
+   }
+   else
+   {
+      oddSize = dataLen % srcTrSize;
+   }
+   /* Adjust "descCount" due to "oddSize" */
+   if ( oddSize )
+   {
+      descCount ++;
+   }
+
+   /* Find the number of descriptor needed for total "srcTs" */
+   if ( srcTs )
+   {
+      descCount += ( ( srcTs - 1 ) / maxBlockSize ) + 1;
+   }
+
+   return descCount;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Check the existance of pending descriptor
+*
+*  This function confirmes if there is any pending descriptor in the chain
+*  to program the channel
+*
+*  @return  1 : Channel need to be programmed with pending descriptor
+*           0 : No more pending descriptor to programe the channel
+*
+*  @note
+*     - This function should be called from ISR in case there are pending
+*       descriptor to program the channel.
+*
+*     Example:
+*
+*     dmac_isr ()
+*     {
+*         ...
+*         if ( dmacHw_descriptorPending ( handle ) )
+*         {
+*            dmacHw_initiateTransfer ( handle );
+*         }
+*     }
+*
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorPending
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK(handle);
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+
+   /* Make sure channel is not busy */
+   if ( ! CHANNEL_BUSY ( pCblk->module, pCblk->channel ) )
+   {
+      /* Check if pEnd is not processed */
+      if ( pRing->pEnd )
+      {
+         /* Something left for processing */
+         return 1;
+      }
+   }
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to stop transfer
+*
+*  Ensures the channel is not doing any transfer after calling this function
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+void dmacHw_stopTransfer
+(
+   dmacHw_HANDLE_t handle                    ///<   [ IN ] DMA Channel handle
+)
+{
+   dmacHw_CBLK_t* pCblk;
+
+   pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+   /* Stop the channel */
+   dmacHw_DMA_STOP ( pCblk->module, pCblk->channel );
+}
+
+/****************************************************************************/
+/**
+*  @brief   Deallocates source or destination memory, allocated
+*
+*  This function can be called to deallocate data memory that was DMAed successfully
+*
+*  @return  On failure : -1
+*           On success : Number of buffer freed
+*
+*  @note
+*     This function will be called ONLY, when source OR destination address is pointing
+*     to dynamic memory
+*/
+/****************************************************************************/
+int dmacHw_freeMem
+(
+   dmacHw_CONFIG_t *pConfig,              ///<   [ IN ] Configuration settings
+   void* pDescriptor,                     ///<   [ IN ] Descriptor buffer
+   void (*fpFree) ( void* )               ///<   [ IN ] Function pointer to free data memory
+)
+{
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+   uint32_t count = 0;
+
+   if ( fpFree == NULL )
+   {
+      return -1;
+   }
+
+   while ( ( pRing->pFree != pRing->pTail ) && ( pRing->pFree->ctl.lo & dmacHw_DESC_FREE ) )
+   {
+      if ( pRing->pFree->devCtl == dmacHw_FREE_USER_MEMORY )
+      {
+         /* Identify, which memory to free */
+         if ( dmacHw_DST_IS_MEMORY ( pConfig->transferType ) )
+         {
+            (*fpFree) ( (void*) pRing->pFree->dar );
+         }
+         else
+         {
+            /* Destination was a peripheral */
+            (*fpFree) ( (void*) pRing->pFree->sar );
+         }
+         /* Unmark user memory to indicate it is freed */
+         pRing->pFree->devCtl = ~ dmacHw_FREE_USER_MEMORY;
+      }
+      dmacHw_NEXT_DESC ( pRing, pFree );
+
+      count++;
+   }
+
+   return count;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Prepares descriptor ring, when source peripheral working as a flow controller
+*
+*  This function will update the discriptor ring by allocating buffers, when source peripheral
+*  has to work as a flow controller to transfer data from:
+*           - Peripheral to memory.
+*
+*  @return  On failure : -1
+*           On success : Number of descriptor updated
+*
+*
+*  @note
+*     Channel must be configured for peripheral to memory transfer
+*
+*/
+/****************************************************************************/
+int dmacHw_setVariableDataDescriptor
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   uint32_t srcAddr,                         ///<   [ IN ] Source peripheral address
+   void *(*fpAlloc)( int len ),              ///<   [ IN ] Function pointer  that provides destination memory
+   int len,                                  ///<   [ IN ] Number of bytes "fpAlloc" will allocate for destination
+   int num                                   ///<   [ IN ] Number of descriptor to set
+)
+{
+   dmacHw_CBLK_t *pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+   dmacHw_DESC_t *pProg = NULL;
+   dmacHw_DESC_t *pLast = NULL;
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+   uint32_t dstAddr;
+   uint32_t controlParam;
+   int i;
+
+   dmacHw_ASSERT ( pConfig->transferType == dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM );
+
+   if ( num > pRing->num)
+   {
+      return -1;
+   }
+
+   pLast = pRing->pEnd;   /* Last descriptor updated */
+   pProg = pRing->pHead;  /* First descriptor in the new list */
+
+   controlParam =  pConfig->srcUpdate |
+                   pConfig->dstUpdate |
+                   pConfig->srcMaxTransactionWidth |
+                   pConfig->dstMaxTransactionWidth |
+                   pConfig->srcMasterInterface |
+                   pConfig->dstMasterInterface |
+                   pConfig->srcMaxBurstWidth |
+                   pConfig->dstMaxBurstWidth |
+                   dmacHw_REG_CTL_TTFC_PM_PERI |
+                   dmacHw_REG_CTL_LLP_DST_EN |
+                   dmacHw_REG_CTL_LLP_SRC_EN |
+                   dmacHw_REG_CTL_INT_EN;
+
+   for( i = 0; i < num; i++ )
+   {
+      /* Allocate Rx buffer only for idle descriptor */
+      if ( ( ( pRing->pHead->ctl.hi & dmacHw_DESC_FREE ) == 0 ) ||
+           ( (dmacHw_DESC_t*)pRing->pHead->llp == pRing->pTail )
+         )
+      {
+         /* Rx descriptor is not idle */
+         break;
+      }
+      /* Set source address */
+      pRing->pHead->sar = srcAddr;
+      if ( fpAlloc )
+      {
+         /* Allocate memory for buffer in descriptor */
+         dstAddr = (uint32_t) (*fpAlloc)( len );
+         /* Check the destination address */
+         if( dstAddr == 0 )
+         {
+           if ( i == 0 )
+           {
+              /* Not a single descriptor is available */
+              return -1;
+           }
+           break;
+         }
+         /* Set destination address */
+         pRing->pHead->dar = dstAddr;
+      }
+      /* Set control information */
+      pRing->pHead->ctl.lo = controlParam;
+      /* Use "devCtl" to mark the memory that need to be freed later */
+      pRing->pHead->devCtl = dmacHw_FREE_USER_MEMORY;
+      /* Descriptor is now owned by the channel */
+      pRing->pHead->ctl.hi = 0;
+      /* Remember the descriptor last updated */
+      pRing->pEnd = pRing->pHead;
+      /* Update next descriptor */
+      dmacHw_NEXT_DESC ( pRing, pHead );
+   }
+
+   /* Mark the end of the list */
+   pRing->pEnd->ctl.lo &= ~( dmacHw_REG_CTL_LLP_DST_EN | dmacHw_REG_CTL_LLP_SRC_EN );
+   /* Connect the list */
+   if ( pLast != pProg )
+   {
+      pLast->ctl.lo |= dmacHw_REG_CTL_LLP_DST_EN | dmacHw_REG_CTL_LLP_SRC_EN ;
+   }
+   /* Mark the descriptors are updated */
+   pCblk->descUpdated = 1;
+   if ( ! pCblk->varDataStarted )
+   {
+      /* LLP must be pointing to the first descriptor */
+      dmacHw_SET_LLP ( pCblk->module, pCblk->channel, (uint32_t)pProg - pRing->virt2PhyOffset);
+      /* Channel, handling variable data started */
+      pCblk->varDataStarted = 1;
+   }
+
+   return i;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Read data DMAed to memory
+*
+*  This function will read data that has been DMAed to memory while transfering from:
+*          - Memory to memory
+*          - Peripheral to memory
+*
+*  @param    handle     -
+*  @param    ppBbuf     -
+*  @param    pLen       -
+*
+*  @return  0 - No more data is available to read
+*           1 - More data might be available to read
+*
+*/
+/****************************************************************************/
+int dmacHw_readTransferredData
+(
+   dmacHw_HANDLE_t handle,                   ///<  [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ]  Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   void** ppBbuf,                            ///<   [ OUT ] Data received
+   size_t *pLlen                             ///<   [ OUT ] Length of the data received
+)
+{
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+
+  (void)handle;
+
+   if (pConfig->transferMode != dmacHw_TRANSFER_MODE_CONTINUOUS)
+   {
+      if ( ( ( pRing->pTail->ctl.hi & dmacHw_DESC_FREE ) == 0 ) ||
+           ( pRing->pTail == pRing->pHead )
+         )
+      {
+         /* No receive data available */
+         *ppBbuf = (char*) NULL;
+         *pLlen = 0;
+
+         return (0);
+      }
+   }
+
+   /* Return read buffer and length */
+   *ppBbuf = (char*) pRing->pTail->dar;
+
+   /* Extract length of the received data */
+   if ( DmaIsFlowController ( pDescriptor ) )
+   {
+      uint32_t srcTrSize = 0;
+
+      switch ( pRing->pTail->ctl.lo & dmacHw_REG_CTL_SRC_TR_WIDTH_MASK )
+      {
+         case dmacHw_REG_CTL_SRC_TR_WIDTH_8:
+            srcTrSize = 1;
+            break;
+         case dmacHw_REG_CTL_SRC_TR_WIDTH_16:
+            srcTrSize = 2;
+            break;
+         case dmacHw_REG_CTL_SRC_TR_WIDTH_32:
+            srcTrSize = 4;
+            break;
+         case dmacHw_REG_CTL_SRC_TR_WIDTH_64:
+            srcTrSize = 8;
+            break;
+         default:
+           dmacHw_ASSERT ( 0 );
+      }
+      /* Calculate length from the block size */
+      *pLlen = ( pRing->pTail->ctl.hi & dmacHw_REG_CTL_BLOCK_TS_MASK ) * srcTrSize;
+   }
+   else
+   {
+      /* Extract length from the source peripheral */
+      *pLlen = pRing->pTail->sstat;
+   }
+
+   /* Advance tail to next descriptor */
+   dmacHw_NEXT_DESC ( pRing, pTail );
+
+   return 1;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptor carrying control information
+*
+*  This function will be used to send specific control information to the device
+*  using the DMA channel
+*
+*
+*  @return  -1 - On failure
+*            0 - On success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_setControlDescriptor
+(
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   uint32_t ctlAddress,                      ///<   [ IN ] Address of the device control register
+   uint32_t control                          ///<   [ IN ] Device control information
+)
+{
+   dmacHw_DESC_RING_t *pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+
+   if ( ctlAddress == 0 )
+   {
+      return -1;
+   }
+
+   /* Check the availability of descriptors in the ring */
+   if ( ( pRing->pHead->ctl.hi & dmacHw_DESC_FREE )  == 0 )
+   {
+      return -1;
+   }
+   /* Set control information */
+   pRing->pHead->devCtl = control;
+   /* Set source and destination address */
+   pRing->pHead->sar = (uint32_t) & pRing->pHead->devCtl;
+   pRing->pHead->dar = ctlAddress;
+   /* Set control parameters */
+   if ( pConfig->flowControler == dmacHw_FLOW_CONTROL_DMA )
+   {
+      pRing->pHead->ctl.lo  = pConfig->transferType |
+                              dmacHw_SRC_ADDRESS_UPDATE_MODE_INC |
+                              dmacHw_DST_ADDRESS_UPDATE_MODE_INC |
+                              dmacHw_SRC_TRANSACTION_WIDTH_32 |
+                              pConfig->dstMaxTransactionWidth |
+                              dmacHw_SRC_BURST_WIDTH_0 |
+                              dmacHw_DST_BURST_WIDTH_0 |
+                              pConfig->srcMasterInterface |
+                              pConfig->dstMasterInterface |
+                              dmacHw_REG_CTL_INT_EN;
+   }
+   else
+   {
+         uint32_t transferType = 0;
+         switch ( pConfig->transferType )
+         {
+            case dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM:
+               transferType = dmacHw_REG_CTL_TTFC_PM_PERI;
+               break;
+            case dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL:
+               transferType = dmacHw_REG_CTL_TTFC_MP_PERI;
+               break;
+            default:
+               dmacHw_ASSERT (0);
+         }
+         pRing->pHead->ctl.lo  = transferType |
+                                 dmacHw_SRC_ADDRESS_UPDATE_MODE_INC |
+                                 dmacHw_DST_ADDRESS_UPDATE_MODE_INC |
+                                 dmacHw_SRC_TRANSACTION_WIDTH_32 |
+                                 pConfig->dstMaxTransactionWidth |
+                                 dmacHw_SRC_BURST_WIDTH_0 |
+                                 dmacHw_DST_BURST_WIDTH_0 |
+                                 pConfig->srcMasterInterface |
+                                 pConfig->dstMasterInterface |
+                                 pConfig->flowControler |
+                                 dmacHw_REG_CTL_INT_EN;
+   }
+
+   /* Set block transaction size to one 32 bit transaction */
+   pRing->pHead->ctl.hi = dmacHw_REG_CTL_BLOCK_TS_MASK & 1;
+
+   /* Remember the descriptor to initialize the registers */
+   if ( pRing->pProg == dmacHw_DESC_INIT )
+   {
+      pRing->pProg = pRing->pHead;
+   }
+   pRing->pEnd = pRing->pHead;
+
+   /* Advance the descriptor */
+   dmacHw_NEXT_DESC ( pRing, pHead );
+
+   /* Update Tail pointer if destination is a peripheral */
+   if ( ! dmacHw_DST_IS_MEMORY ( pConfig->transferType ) )
+   {
+      pRing->pTail = pRing->pHead;
+   }
+   return  0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Sets channel specific user data
+*
+*  This function associates user data to a specif DMA channel
+*
+*/
+/****************************************************************************/
+void dmacHw_setChannelUserData
+(
+  dmacHw_HANDLE_t handle,       ///<  [ IN ] DMA Channel handle
+  void            *userData     ///<  [ IN ] User data
+)
+{
+  dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+  pCblk->userData = userData;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Gets channel specific user data
+*
+*  This function returns user data specific to a DMA channel
+*
+*  @return   user data
+*/
+/****************************************************************************/
+void *dmacHw_getChannelUserData
+(
+   dmacHw_HANDLE_t handle     ///<  [ IN ] DMA Channel handle
+)
+{
+   dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+   return pCblk->userData;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Resets descriptor control information
+*
+*  @return  void
+*/
+/****************************************************************************/
+void dmacHw_resetDescriptorControl
+(
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+)
+{
+   int i;
+   dmacHw_DESC_RING_t *pRing;
+   dmacHw_DESC_t *pDesc;
+
+   pRing = dmacHw_GET_DESC_RING ( pDescriptor );
+   pDesc = pRing->pHead;
+
+   for( i = 0; i < pRing->num; i++ )
+   {
+      /* Mark descriptor is ready to use */
+      pDesc->ctl.hi = dmacHw_DESC_FREE;
+      /* Look into next link list item */
+      pDesc ++;
+   }
+   pRing->pFree = pRing->pTail = pRing->pEnd = pRing->pHead;
+   pRing->pProg = dmacHw_DESC_INIT;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Displays channel specific registers and other control parameters
+*
+*  @return  void
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+void dmacHw_printDebugInfo
+(
+   dmacHw_HANDLE_t handle,                   ///<  [ IN ] DMA Channel handle
+   void* pDescriptor,                        ///<   [ IN ] Descriptor buffer
+   int (*fpPrint) (const char *, ...)                 ///<  [ IN ] Print callback function
+)
+{
+   dmacHw_CBLK_t *pCblk = dmacHw_HANDLE_TO_CBLK ( handle );
+
+   DisplayRegisterContents ( pCblk->module, pCblk->channel, fpPrint );
+   DisplayDescRing ( pDescriptor, fpPrint );
+}
+
diff --git a/arch/arm/mach-bcmring/csp/tmr/Makefile b/arch/arm/mach-bcmring/csp/tmr/Makefile
new file mode 100644
index 0000000..c1bbdcf
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/tmr/Makefile
@@ -0,0 +1 @@
+obj-y += tmrHw.o
diff --git a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
new file mode 100644
index 0000000..26db37a
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
@@ -0,0 +1,676 @@
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
+
+/****************************************************************************/
+/**
+*  @file    tmrHw.c
+*
+*  @brief   Low level Timer driver routines
+*
+*  @note
+*
+*   These routines provide basic timer functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/stdint.h>
+
+#include <csp/tmrHw.h>
+#include <mach/csp/tmrHw_reg.h>
+
+
+#define tmrHw_ASSERT(a)                     if (!(a)) *(char*) 0 = 0
+#define tmrHw_MILLISEC_PER_SEC              ( 1000  )
+
+#define tmrHw_LOW_1_RESOLUTION_COUNT        ( tmrHw_LOW_RESOLUTION_CLOCK / tmrHw_MILLISEC_PER_SEC )
+#define tmrHw_LOW_1_MAX_MILLISEC            ( 0xFFFFFFFF / tmrHw_LOW_1_RESOLUTION_COUNT )
+#define tmrHw_LOW_16_RESOLUTION_COUNT       ( tmrHw_LOW_1_RESOLUTION_COUNT / 16 )
+#define tmrHw_LOW_16_MAX_MILLISEC           ( 0xFFFFFFFF / tmrHw_LOW_16_RESOLUTION_COUNT )
+#define tmrHw_LOW_256_RESOLUTION_COUNT      ( tmrHw_LOW_1_RESOLUTION_COUNT / 256 )
+#define tmrHw_LOW_256_MAX_MILLISEC          ( 0xFFFFFFFF / tmrHw_LOW_256_RESOLUTION_COUNT )
+
+#define tmrHw_HIGH_1_RESOLUTION_COUNT       ( tmrHw_HIGH_RESOLUTION_CLOCK / tmrHw_MILLISEC_PER_SEC )
+#define tmrHw_HIGH_1_MAX_MILLISEC           ( 0xFFFFFFFF / tmrHw_HIGH_1_RESOLUTION_COUNT )
+#define tmrHw_HIGH_16_RESOLUTION_COUNT      ( tmrHw_HIGH_1_RESOLUTION_COUNT / 16 )
+#define tmrHw_HIGH_16_MAX_MILLISEC          ( 0xFFFFFFFF / tmrHw_HIGH_16_RESOLUTION_COUNT )
+#define tmrHw_HIGH_256_RESOLUTION_COUNT     ( tmrHw_HIGH_1_RESOLUTION_COUNT / 256 )
+#define tmrHw_HIGH_256_MAX_MILLISEC         ( 0xFFFFFFFF / tmrHw_HIGH_256_RESOLUTION_COUNT )
+
+static void ResetTimer (tmrHw_ID_t  timerId) __attribute__ ((section(".aramtext")));
+static int tmrHw_divide(int num, int denom) __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief   Get timer capability
+*
+*  This function returns various capabilities/attributes of a timer
+*
+*  @return  Capability
+*
+*/
+/****************************************************************************/
+uint32_t tmrHw_getTimerCapability
+(
+   tmrHw_ID_t           timerId,        //<  [ IN ] Timer Id
+   tmrHw_CAPABILITY_e   capability      //<  [ IN ] Timer capability
+)
+{
+   switch ( capability )
+   {
+      case tmrHw_CAPABILITY_CLOCK:
+         return ( timerId <= 1 ) ? tmrHw_LOW_RESOLUTION_CLOCK : tmrHw_HIGH_RESOLUTION_CLOCK;
+      case tmrHw_CAPABILITY_RESOLUTION:
+         return 32;
+      default:
+         return 0;
+   }
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Resets a timer
+*
+*  This function initializes  timer
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+static void ResetTimer
+(
+   tmrHw_ID_t  timerId              //<  [ IN ] Timer Id
+)
+{
+   /* Reset timer */
+   pTmrHw[timerId].LoadValue = 0;
+   pTmrHw[timerId].CurrentValue = 0xFFFFFFFF;
+   pTmrHw[timerId].Control = 0;
+   pTmrHw[timerId].BackgroundLoad = 0;
+   /* Always configure as a 32 bit timer */
+   pTmrHw[timerId].Control |= tmrHw_CONTROL_32BIT;
+   /* Clear interrupt only if raw status interrupt is set */
+   if ( pTmrHw[timerId].RawInterruptStatus )
+   {
+      pTmrHw[timerId].InterruptClear = 0xFFFFFFFF;
+   }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Sets counter value for an interval in ms
+*
+*  @return   On success: Effective counter value set
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+static tmrHw_INTERVAL_t SetTimerPeriod
+(
+   tmrHw_ID_t         timerId,        //<  [ IN ] Timer Id
+   tmrHw_INTERVAL_t   msec            //<  [ IN ] Interval in milli-second
+)
+{
+   uint32_t scale = 0;
+   uint32_t count = 0;
+
+   if ( timerId == 0 || timerId == 1 )
+   {
+      if ( msec <= tmrHw_LOW_1_MAX_MILLISEC  )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_1;
+         scale = tmrHw_LOW_1_RESOLUTION_COUNT;
+      }
+      else if ( msec <= tmrHw_LOW_16_MAX_MILLISEC )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_16;
+         scale = tmrHw_LOW_16_RESOLUTION_COUNT;
+      }
+      else if ( msec <= tmrHw_LOW_256_MAX_MILLISEC )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_256;
+         scale = tmrHw_LOW_256_RESOLUTION_COUNT;
+      }
+      else
+      {
+         return 0;
+      }
+
+      count = msec * scale;
+      /* Set counter value */
+      pTmrHw[timerId].LoadValue = count;
+      pTmrHw[timerId].BackgroundLoad = count;
+
+   }
+   else if ( timerId == 2 || timerId == 3 )
+   {
+      if ( msec <= tmrHw_HIGH_1_MAX_MILLISEC  )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_1;
+         scale = tmrHw_HIGH_1_RESOLUTION_COUNT;
+      }
+      else if ( msec <= tmrHw_HIGH_16_MAX_MILLISEC )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_16;
+         scale = tmrHw_HIGH_16_RESOLUTION_COUNT;
+      }
+      else if ( msec <= tmrHw_HIGH_256_MAX_MILLISEC )
+      {
+         pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_256;
+         scale = tmrHw_HIGH_256_RESOLUTION_COUNT;
+      }
+      else
+      {
+         return 0;
+      }
+
+      count = msec * scale;
+      /* Set counter value */
+      pTmrHw[timerId].LoadValue = count;
+      pTmrHw[timerId].BackgroundLoad = count;
+   }
+   return count / scale;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer in terms of timer interrupt rate
+*
+*  This function initializes a periodic timer to generate specific number of
+*  timer interrupt per second
+*
+*  @return   On success: Effective timer frequency
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_setPeriodicTimerRate
+(
+   tmrHw_ID_t           timerId,        //<  [ IN ] Timer Id
+   tmrHw_RATE_t         rate            //<  [ IN ] Number of timer interrupt per second
+)
+{
+   uint32_t resolution = 0;
+   uint32_t count = 0;
+   ResetTimer ( timerId );
+
+   /* Set timer mode periodic */
+   pTmrHw[timerId].Control |=  tmrHw_CONTROL_PERIODIC;
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_ONESHOT;
+   /* Set timer in highest resolution */
+   pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_1;
+
+   if ( rate && ( timerId == 0 || timerId == 1 ) )
+   {
+      if ( rate > tmrHw_LOW_RESOLUTION_CLOCK )
+      {
+         return 0;
+      }
+      resolution = tmrHw_LOW_RESOLUTION_CLOCK;
+   }
+   else if ( rate && ( timerId == 2 || timerId == 3 ) )
+   {
+      if ( rate > tmrHw_HIGH_RESOLUTION_CLOCK )
+      {
+         return 0;
+      }
+      else
+      {
+         resolution = tmrHw_HIGH_RESOLUTION_CLOCK;
+      }
+   }
+   else
+   {
+      return 0;
+   }
+   /* Find the counter value */
+   count = resolution / rate;
+   /* Set counter value */
+   pTmrHw[timerId].LoadValue = count;
+   pTmrHw[timerId].BackgroundLoad = count;
+
+   return resolution / count;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer to generate timer interrupt after
+*           certain time interval
+*
+*  This function initializes a periodic timer to generate timer interrupt
+*  after every time interval in millisecond
+*
+*  @return   On success: Effective interval set in milli-second
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_INTERVAL_t tmrHw_setPeriodicTimerInterval
+(
+   tmrHw_ID_t         timerId,        //<  [ IN ] Timer Id
+   tmrHw_INTERVAL_t   msec            //<  [ IN ] Interval in milli-second
+)
+{
+   ResetTimer ( timerId );
+
+   /* Set timer mode periodic */
+   pTmrHw[timerId].Control |=  tmrHw_CONTROL_PERIODIC;
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_ONESHOT;
+
+   return SetTimerPeriod ( timerId, msec );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer to generate timer interrupt just once
+*           after certain time interval
+*
+*  This function initializes a periodic timer to generate a single ticks after
+*  certain time interval in millisecond
+*
+*  @return   On success: Effective interval set in milli-second
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_INTERVAL_t tmrHw_setOneshotTimerInterval
+(
+   tmrHw_ID_t         timerId,        //<  [ IN ] Timer Id
+   tmrHw_INTERVAL_t   msec            //<  [ IN ] Interval in milli-second
+)
+{
+   ResetTimer ( timerId );
+
+   /* Set timer mode oneshot */
+   pTmrHw[timerId].Control |=  tmrHw_CONTROL_PERIODIC;
+   pTmrHw[timerId].Control |=  tmrHw_CONTROL_ONESHOT;
+
+   return SetTimerPeriod ( timerId, msec );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Configures a timer to run as a free running timer
+*
+*  This function initializes a timer to run as a free running timer
+*
+*  @return   Timer resolution ( count / sec )
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_setFreeRunningTimer
+(
+   tmrHw_ID_t               timerId,        //<  [ IN ] Timer Id
+   uint32_t                 divider         //<  [ IN ] Dividing the clock frequency
+)
+{
+   uint32_t scale = 0;
+
+   ResetTimer ( timerId );
+   /* Set timer as free running mode */
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_PERIODIC;
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_ONESHOT;
+
+   if ( divider >= 64 )
+   {
+      pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_256;
+      scale = 256;
+   }
+   else if ( divider >= 8 )
+   {
+      pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_16;
+      scale = 16;
+   }
+   else
+   {
+      pTmrHw[timerId].Control |= tmrHw_CONTROL_PRESCALE_1;
+      scale = 1;
+   }
+
+   if ( timerId == 0 || timerId == 1 )
+   {
+      return tmrHw_divide( tmrHw_LOW_RESOLUTION_CLOCK, scale);
+   }
+   else  if ( timerId == 2 || timerId == 3 )
+   {
+      return tmrHw_divide( tmrHw_HIGH_RESOLUTION_CLOCK, scale);
+   }
+
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Starts a timer
+*
+*  This function starts a preconfigured timer
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*
+*/
+/****************************************************************************/
+int tmrHw_startTimer
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   pTmrHw[timerId].Control |= tmrHw_CONTROL_TIMER_ENABLE;
+   return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Stops a timer
+*
+*  This function stops a running timer
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*
+*/
+/****************************************************************************/
+int tmrHw_stopTimer
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_TIMER_ENABLE;
+   return 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Gets current timer count
+*
+*  This function returns the current timer value
+*
+*  @return  Current downcounting timer value
+*
+*/
+/****************************************************************************/
+uint32_t tmrHw_GetCurrentCount
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   /* return 32 bit timer value */
+  switch ( pTmrHw[timerId].Control & tmrHw_CONTROL_MODE_MASK )
+  {
+     case tmrHw_CONTROL_FREE_RUNNING:
+        if ( pTmrHw[timerId].CurrentValue )
+        {
+           return tmrHw_MAX_COUNT - pTmrHw[timerId].CurrentValue;
+        }
+        break;
+     case tmrHw_CONTROL_PERIODIC:
+     case tmrHw_CONTROL_ONESHOT:
+        return pTmrHw[timerId].BackgroundLoad - pTmrHw[timerId].CurrentValue;
+  }
+  return 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Gets timer count rate
+*
+*  This function returns the number of counts per second
+*
+*  @return  Count rate
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_getCountRate
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   uint32_t divider = 0;
+
+   switch ( pTmrHw[timerId].Control & tmrHw_CONTROL_PRESCALE_MASK )
+   {
+      case tmrHw_CONTROL_PRESCALE_1:
+         divider = 1;
+         break;
+      case tmrHw_CONTROL_PRESCALE_16:
+         divider = 16;
+         break;
+      case tmrHw_CONTROL_PRESCALE_256:
+         divider = 256;
+         break;
+      default:
+         tmrHw_ASSERT (0);
+   }
+
+   if ( timerId == 0 || timerId == 1 )
+   {
+      return tmrHw_divide( tmrHw_LOW_RESOLUTION_CLOCK, divider);
+   }
+   else
+   {
+      return tmrHw_divide( tmrHw_HIGH_RESOLUTION_CLOCK, divider);
+   }
+   return 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables timer interrupt
+*
+*  This function enables the timer interrupt
+*
+*  @return   N/A
+*
+*/
+/****************************************************************************/
+void tmrHw_enableInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   pTmrHw[timerId].Control |= tmrHw_CONTROL_INTERRUPT_ENABLE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disables timer interrupt
+*
+*  This function disable the timer interrupt
+*
+*  @return   N/A
+*
+*/
+/****************************************************************************/
+void tmrHw_disableInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   pTmrHw[timerId].Control &= ~ tmrHw_CONTROL_INTERRUPT_ENABLE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Clears the interrupt
+*
+*  This function clears the timer interrupt
+*
+*  @return   N/A
+*
+*  @note
+*     Must be called under the context of ISR
+*/
+/****************************************************************************/
+void tmrHw_clearInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   pTmrHw[timerId].InterruptClear = 0x1;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Gets the interrupt status
+*
+*  This function returns timer interrupt status
+*
+*  @return   Interrupt status
+*/
+/****************************************************************************/
+tmrHw_INTERRUPT_STATUS_e tmrHw_getInterruptStatus
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)
+{
+   if ( pTmrHw[timerId].InterruptStatus )
+   {
+      return tmrHw_INTERRUPT_STATUS_SET;
+   }
+   else
+   {
+      return tmrHw_INTERRUPT_STATUS_UNSET;
+   }
+}
+
+/****************************************************************************/
+/**
+*  @brief   Indentifies a timer causing interrupt
+*
+*  This functions returns a timer causing interrupt
+*
+*  @return  0xFFFFFFFF   : No timer causing an interrupt
+*           ! 0xFFFFFFFF : timer causing an interrupt
+*  @note
+*     tmrHw_clearIntrrupt() must be called with a valid timer id after calling this function
+*/
+/****************************************************************************/
+tmrHw_ID_t tmrHw_getInterruptSource
+(
+   void                                 //<  void
+)
+{
+   int i ;
+
+   for ( i = 0; i < tmrHw_TIMER_NUM_COUNT; i ++ )
+   {
+      if ( pTmrHw[i].InterruptStatus )
+      {
+         return i;
+      }
+   }
+
+   return 0xFFFFFFFF;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Displays specific timer registers
+*
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+void tmrHw_printDebugInfo
+(
+   tmrHw_ID_t timerId,                  //<  [ IN ] Timer id
+   int (*fpPrint) (const char *, ...)   //<  [ IN ] Print callback function
+)
+{
+   (*fpPrint) ( "Displaying register contents \n\n");
+   (*fpPrint) ( "Timer %d: Load value              0x%X\n", timerId, pTmrHw[timerId].LoadValue );
+   (*fpPrint) ( "Timer %d: Background load value   0x%X\n", timerId, pTmrHw[timerId].BackgroundLoad );
+   (*fpPrint) ( "Timer %d: Control                 0x%X\n", timerId, pTmrHw[timerId].Control );
+   (*fpPrint) ( "Timer %d: Interrupt clear         0x%X\n", timerId, pTmrHw[timerId].InterruptClear );
+   (*fpPrint) ( "Timer %d: Interrupt raw interrupt 0x%X\n", timerId, pTmrHw[timerId].RawInterruptStatus );
+   (*fpPrint) ( "Timer %d: Interrupt status        0x%X\n", timerId, pTmrHw[timerId].InterruptStatus );
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Use a timer to perform a busy wait delay for a number of usecs.
+*
+*  @return   N/A
+*/
+/****************************************************************************/
+void tmrHw_udelay
+(
+   tmrHw_ID_t timerId,        ///<  [ IN ] Timer id
+   unsigned long usecs        ///<  [ IN ] usec to delay */
+)
+{
+   tmrHw_RATE_t     usec_tick_rate;
+   tmrHw_COUNT_t    start_time;
+   tmrHw_COUNT_t    delta_time;
+
+   start_time     = tmrHw_GetCurrentCount( timerId );
+   usec_tick_rate = tmrHw_divide( tmrHw_getCountRate( timerId ), 1000000);
+   delta_time     = usecs * usec_tick_rate;
+
+   /* Busy wait */
+   while ( delta_time > ( tmrHw_GetCurrentCount( timerId ) - start_time ));
+}
+
+/****************************************************************************/
+/**
+*  @brief   Local Divide function
+*
+*  This function does the divide
+*
+*  @return divide value
+*
+*/
+/****************************************************************************/
+static int tmrHw_divide(int num, int denom)
+{
+  int r;
+  int t=1;
+
+  /* Shift denom and t up to the largest value to optimize algorithm */
+  /* t contains the units of each divide */
+  while( (denom&0x40000000) == 0 ) {  /* fails if denom=0 */
+    denom=denom<<1;
+    t=t<<1;
+  }
+
+  /* Intialize the result */
+  r=0;
+
+  do {
+    /* Determine if there exists a positive remainder */
+    if((num-denom)>=0) {
+      /* Accumlate t to the result and calculate a new remainder */
+      num=num-denom;
+      r=r+t;
+    }
+    /* Continue to shift denom and shift t down to 0 */
+    denom=denom>>1;
+    t=t>>1;
+  } while(t!=0);
+  return r;
+}
diff --git a/arch/arm/mach-bcmring/include/csp/cache.h b/arch/arm/mach-bcmring/include/csp/cache.h
new file mode 100644
index 0000000..9b65a84
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/cache.h
@@ -0,0 +1,37 @@
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
+#ifndef CSP_CACHE_H
+#define CSP_CACHE_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/stdint.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#if defined( __KERNEL__ ) && !defined( STANDALONE )
+#include <asm/cacheflush.h>
+
+#define CSP_CACHE_FLUSH_ALL      flush_cache_all()
+
+#else
+
+#define CSP_CACHE_FLUSH_ALL
+
+#endif
+
+
+#endif /* CSP_CACHE_H */
+
diff --git a/arch/arm/mach-bcmring/include/csp/delay.h b/arch/arm/mach-bcmring/include/csp/delay.h
new file mode 100644
index 0000000..1f1f6a8
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/delay.h
@@ -0,0 +1,40 @@
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
+
+#ifndef CSP_DELAY_H
+#define CSP_DELAY_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+// Some CSP routines require use of the following delay routines. Use the OS
+// version if available, otherwise use a CSP specific definition.
+//
+// void udelay(unsigned long usecs);
+// void mdelay(unsigned long msecs);
+//
+
+#if defined(__KERNEL__) && !defined(STANDALONE)
+   #include <linux/delay.h>
+#else
+   #include <mach/csp/delay.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /*  CSP_DELAY_H */
+
diff --git a/arch/arm/mach-bcmring/include/csp/dmacHw.h b/arch/arm/mach-bcmring/include/csp/dmacHw.h
new file mode 100644
index 0000000..aae8eb1
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/dmacHw.h
@@ -0,0 +1,703 @@
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
+
+
+/****************************************************************************/
+/**
+*  @file    dmacHw.h
+*
+*  @brief   API definitions for low level DMA controller driver
+*
+*/
+/****************************************************************************/
+#ifndef _DMACHW_H
+#define _DMACHW_H
+
+#include <stddef.h>
+
+#include <csp/stdint.h>
+#include <mach/csp/dmacHw_reg.h>
+
+/* Define DMA Channel ID using DMA controller number (m) and channel number (c).
+
+   System specific channel ID should be defined as follows
+
+   For example:
+
+   #include <dmacHw.h>
+   ...
+   #define systemHw_LCD_CHANNEL_ID                dmacHw_MAKE_CHANNEL_ID(0,5)
+   #define systemHw_SWITCH_RX_CHANNEL_ID          dmacHw_MAKE_CHANNEL_ID(0,0)
+   #define systemHw_SWITCH_TX_CHANNEL_ID          dmacHw_MAKE_CHANNEL_ID(0,1)
+   #define systemHw_APM_RX_CHANNEL_ID             dmacHw_MAKE_CHANNEL_ID(0,3)
+   #define systemHw_APM_TX_CHANNEL_ID             dmacHw_MAKE_CHANNEL_ID(0,4)
+   ...
+   #define systemHw_SHARED1_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(1,4)
+   #define systemHw_SHARED2_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(1,5)
+   #define systemHw_SHARED3_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(0,6)
+   ...
+*/
+#define dmacHw_MAKE_CHANNEL_ID(m,c)         ( m << 8 | c )
+
+typedef enum
+{
+   dmacHw_CHANNEL_PRIORITY_0 = dmacHw_REG_CFG_LO_CH_PRIORITY_0,          /* Channel priority 0. Lowest priority DMA channel */
+   dmacHw_CHANNEL_PRIORITY_1 = dmacHw_REG_CFG_LO_CH_PRIORITY_1,          /* Channel priority 1 */
+   dmacHw_CHANNEL_PRIORITY_2 = dmacHw_REG_CFG_LO_CH_PRIORITY_2,          /* Channel priority 2 */
+   dmacHw_CHANNEL_PRIORITY_3 = dmacHw_REG_CFG_LO_CH_PRIORITY_3,          /* Channel priority 3 */
+   dmacHw_CHANNEL_PRIORITY_4 = dmacHw_REG_CFG_LO_CH_PRIORITY_4,          /* Channel priority 4 */
+   dmacHw_CHANNEL_PRIORITY_5 = dmacHw_REG_CFG_LO_CH_PRIORITY_5,          /* Channel priority 5 */
+   dmacHw_CHANNEL_PRIORITY_6 = dmacHw_REG_CFG_LO_CH_PRIORITY_6,          /* Channel priority 6 */
+   dmacHw_CHANNEL_PRIORITY_7 = dmacHw_REG_CFG_LO_CH_PRIORITY_7           /* Channel priority 7. Highest priority DMA channel */
+}dmacHw_CHANNEL_PRIORITY_e;
+
+
+/* Source destination master interface */
+typedef enum
+{
+  dmacHw_SRC_MASTER_INTERFACE_1 = dmacHw_REG_CTL_SMS_1,                  /* Source DMA master interface 1 */
+  dmacHw_SRC_MASTER_INTERFACE_2 = dmacHw_REG_CTL_SMS_2,                  /* Source DMA master interface 2 */
+  dmacHw_DST_MASTER_INTERFACE_1 = dmacHw_REG_CTL_DMS_1,                  /* Destination DMA master interface 1 */
+  dmacHw_DST_MASTER_INTERFACE_2 = dmacHw_REG_CTL_DMS_2                   /* Destination DMA master interface 2 */
+}dmacHw_MASTER_INTERFACE_e;
+
+
+typedef enum
+{
+   dmacHw_SRC_TRANSACTION_WIDTH_8  = dmacHw_REG_CTL_SRC_TR_WIDTH_8,      /* Source 8 bit  (1 byte) per transaction */
+   dmacHw_SRC_TRANSACTION_WIDTH_16 = dmacHw_REG_CTL_SRC_TR_WIDTH_16,     /* Source 16 bit (2 byte) per transaction */
+   dmacHw_SRC_TRANSACTION_WIDTH_32 = dmacHw_REG_CTL_SRC_TR_WIDTH_32,     /* Source 32 bit (4 byte) per transaction */
+   dmacHw_SRC_TRANSACTION_WIDTH_64 = dmacHw_REG_CTL_SRC_TR_WIDTH_64,     /* Source 64 bit (8 byte) per transaction */
+   dmacHw_DST_TRANSACTION_WIDTH_8  = dmacHw_REG_CTL_DST_TR_WIDTH_8,      /* Destination 8 bit  (1 byte) per transaction */
+   dmacHw_DST_TRANSACTION_WIDTH_16 = dmacHw_REG_CTL_DST_TR_WIDTH_16,     /* Destination 16 bit (2 byte) per transaction */
+   dmacHw_DST_TRANSACTION_WIDTH_32 = dmacHw_REG_CTL_DST_TR_WIDTH_32,     /* Destination 32 bit (4 byte) per transaction */
+   dmacHw_DST_TRANSACTION_WIDTH_64 = dmacHw_REG_CTL_DST_TR_WIDTH_64      /* Destination 64 bit (8 byte) per transaction */
+}dmacHw_TRANSACTION_WIDTH_e;
+
+
+typedef enum
+{
+   dmacHw_SRC_BURST_WIDTH_0    = dmacHw_REG_CTL_SRC_MSIZE_0,             /* Source No burst */
+   dmacHw_SRC_BURST_WIDTH_4    = dmacHw_REG_CTL_SRC_MSIZE_4,             /* Source 4  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+   dmacHw_SRC_BURST_WIDTH_8    = dmacHw_REG_CTL_SRC_MSIZE_8,             /* Source 8  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+   dmacHw_SRC_BURST_WIDTH_16   = dmacHw_REG_CTL_SRC_MSIZE_16,            /* Source 16 X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+   dmacHw_DST_BURST_WIDTH_0    = dmacHw_REG_CTL_DST_MSIZE_0,             /* Destination No burst */
+   dmacHw_DST_BURST_WIDTH_4    = dmacHw_REG_CTL_DST_MSIZE_4,             /* Destination 4  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+   dmacHw_DST_BURST_WIDTH_8    = dmacHw_REG_CTL_DST_MSIZE_8,             /* Destination 8  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+   dmacHw_DST_BURST_WIDTH_16   = dmacHw_REG_CTL_DST_MSIZE_16             /* Destination 16 X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+}dmacHw_BURST_WIDTH_e;
+
+
+typedef enum
+{
+   dmacHw_TRANSFER_TYPE_MEM_TO_MEM               = dmacHw_REG_CTL_TTFC_MM_DMAC,    /* Memory to memory transfer */
+   dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM        = dmacHw_REG_CTL_TTFC_PM_DMAC,    /* Peripheral to memory transfer */
+   dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL        = dmacHw_REG_CTL_TTFC_MP_DMAC,    /* Memory to peripheral transfer */
+   dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_PERIPHERAL = dmacHw_REG_CTL_TTFC_PP_DMAC     /* Peripheral to peripheral transfer */
+}dmacHw_TRANSFER_TYPE_e;
+
+
+typedef enum
+{
+   dmacHw_TRANSFER_MODE_PERREQUEST,                                     /* Block transfer per DMA request */
+   dmacHw_TRANSFER_MODE_CONTINUOUS,                                     /* Continuous transfer of streaming data */
+   dmacHw_TRANSFER_MODE_PERIODIC                                        /* Periodic transfer of streaming data */
+}dmacHw_TRANSFER_MODE_e;
+
+
+typedef enum
+{
+   dmacHw_SRC_ADDRESS_UPDATE_MODE_INC = dmacHw_REG_CTL_SINC_INC,        /* Increment source address after every transaction */
+   dmacHw_SRC_ADDRESS_UPDATE_MODE_DEC = dmacHw_REG_CTL_SINC_DEC,        /* Decrement source address after every transaction */
+   dmacHw_DST_ADDRESS_UPDATE_MODE_INC = dmacHw_REG_CTL_DINC_INC,        /* Increment destination address after every transaction */
+   dmacHw_DST_ADDRESS_UPDATE_MODE_DEC = dmacHw_REG_CTL_DINC_DEC,        /* Decrement destination address after every transaction */
+   dmacHw_SRC_ADDRESS_UPDATE_MODE_NC  = dmacHw_REG_CTL_SINC_NC,         /* No change in source address after every transaction */
+   dmacHw_DST_ADDRESS_UPDATE_MODE_NC  = dmacHw_REG_CTL_DINC_NC          /* No change in destination address after every transaction */
+}dmacHw_ADDRESS_UPDATE_MODE_e;
+
+
+typedef enum
+{
+   dmacHw_FLOW_CONTROL_DMA,                                             /* DMA working as flow controller (default) */
+   dmacHw_FLOW_CONTROL_PERIPHERAL                                       /* Peripheral working as flow controller */
+}dmacHw_FLOW_CONTROL_e;
+
+
+typedef enum
+{
+   dmacHw_TRANSFER_STATUS_BUSY,                                         /* DMA Transfer ongoing */
+   dmacHw_TRANSFER_STATUS_DONE,                                         /* DMA Transfer completed */
+   dmacHw_TRANSFER_STATUS_ERROR                                         /* DMA Transfer error */
+}dmacHw_TRANSFER_STATUS_e;
+
+
+typedef enum
+{
+  dmacHw_INTERRUPT_DISABLE,                                             /* Interrupt disable  */
+  dmacHw_INTERRUPT_ENABLE                                               /* Interrupt enable */
+}dmacHw_INTERRUPT_e;
+
+
+typedef enum
+{
+   dmacHw_INTERRUPT_STATUS_NONE  = 0x0,                                 /* No DMA interrupt */
+   dmacHw_INTERRUPT_STATUS_TRANS = 0x1,                                 /* End of DMA transfer interrupt */
+   dmacHw_INTERRUPT_STATUS_BLOCK = 0x2,                                 /* End of block transfer interrupt */
+   dmacHw_INTERRUPT_STATUS_ERROR = 0x4                                  /* Error interrupt */
+}dmacHw_INTERRUPT_STATUS_e;
+
+
+typedef enum
+{
+   dmacHw_CONTROLLER_ATTRIB_CHANNEL_NUM,                                /* Number of DMA channel */
+   dmacHw_CONTROLLER_ATTRIB_CHANNEL_MAX_BLOCK_SIZE,                     /* Maximum channel burst size */
+   dmacHw_CONTROLLER_ATTRIB_MASTER_INTF_NUM,                            /* Number of DMA master interface */
+   dmacHw_CONTROLLER_ATTRIB_CHANNEL_BUS_WIDTH,                          /* Channel Data bus width */
+   dmacHw_CONTROLLER_ATTRIB_CHANNEL_FIFO_SIZE                           /* Channel FIFO size */
+}dmacHw_CONTROLLER_ATTRIB_e;
+
+
+
+typedef unsigned long dmacHw_HANDLE_t;                                  /* DMA channel handle */
+typedef uint32_t dmacHw_ID_t;                                           /* DMA channel Id.  Must be created using
+                                                                           "dmacHw_MAKE_CHANNEL_ID" macro
+                                                                       */
+/* DMA channel configuration parameters */
+typedef struct
+{
+   uint32_t srcPeripheralPort;                                           /* Source peripheral port */
+   uint32_t dstPeripheralPort;                                           /* Destination peripheral port */
+   uint32_t srcStatusRegisterAddress;                                    /* Source status register address */
+   uint32_t dstStatusRegisterAddress;                                    /* Destination status register address of type  */
+
+   uint32_t srcGatherWidth;                                              /* Number of bytes gathered before successive gather opearation */
+   uint32_t srcGatherJump;                                               /* Number of bytes jumpped before successive gather opearation */
+   uint32_t dstScatterWidth;                                             /* Number of bytes sacattered before successive scatter opearation */
+   uint32_t dstScatterJump;                                              /* Number of bytes jumpped  before successive scatter opearation */
+   uint32_t maxDataPerBlock;                                             /* Maximum number of bytes to be transferred per block/descrptor.
+                                                                            0 = Maximum possible.
+                                                                          */
+
+   dmacHw_ADDRESS_UPDATE_MODE_e srcUpdate;                               /* Source address update mode */
+   dmacHw_ADDRESS_UPDATE_MODE_e dstUpdate;                               /* Destination address update mode */
+   dmacHw_TRANSFER_TYPE_e transferType;                                  /* DMA transfer type  */
+   dmacHw_TRANSFER_MODE_e transferMode;                                  /* DMA transfer mode */
+   dmacHw_MASTER_INTERFACE_e srcMasterInterface;                         /* DMA source interface  */
+   dmacHw_MASTER_INTERFACE_e dstMasterInterface;                         /* DMA destination interface */
+   dmacHw_TRANSACTION_WIDTH_e srcMaxTransactionWidth;                    /* Source transaction width   */
+   dmacHw_TRANSACTION_WIDTH_e dstMaxTransactionWidth;                    /* Destination transaction width */
+   dmacHw_BURST_WIDTH_e srcMaxBurstWidth;                                /* Source burst width */
+   dmacHw_BURST_WIDTH_e dstMaxBurstWidth;                                /* Destination burst width */
+   dmacHw_INTERRUPT_e blockTransferInterrupt;                            /* Block trsnafer interrupt */
+   dmacHw_INTERRUPT_e completeTransferInterrupt;                         /* Complete DMA trsnafer interrupt */
+   dmacHw_INTERRUPT_e errorInterrupt;                                    /* Error interrupt */
+   dmacHw_CHANNEL_PRIORITY_e channelPriority;                            /* Channel priority */
+   dmacHw_FLOW_CONTROL_e flowControler;                                  /* Data flow controller */
+}dmacHw_CONFIG_t;
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Initializes DMA
+*
+*  This function initializes DMA CSP driver
+*
+*  @note
+*     Must be called before using any DMA channel
+*/
+/****************************************************************************/
+void dmacHw_initDma ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Exit function for  DMA
+*
+*  This function isolates DMA from the system
+*
+*/
+/****************************************************************************/
+void dmacHw_exitDma ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Gets a handle to a DMA channel
+*
+*  This function returns a handle, representing a control block of a particular DMA channel
+*
+*  @return  -1       - On Failure
+*            handle  - On Success, representing a channel control block
+*
+*  @note
+*     None  Channel ID must be created using "dmacHw_MAKE_CHANNEL_ID" macro
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getChannelHandle
+(
+   dmacHw_ID_t channelId                    ///< [ IN ] DMA Channel Id
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Initializes a DMA channel for use
+*
+*  This function initializes and resets a DMA channel for use
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_initChannel
+(
+   dmacHw_HANDLE_t handle            ///<  [ IN ] DMA Channel handle
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief  Estimates number of descriptor needed to perform certain DMA transfer
+*
+*
+*  @return  On failure : -1
+*           On success : Number of descriptor count
+*
+*
+*/
+/****************************************************************************/
+int dmacHw_calculateDescriptorCount
+(
+  dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+  void* pSrcAddr,                           ///<   [ IN ] Source (Peripheral/Memory) address
+  void* pDstAddr,                           ///<   [ IN ] Destination (Peripheral/Memory) address
+  size_t dataLen                            ///<   [ IN ] Data length in bytes
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Initializes descriptor ring
+*
+*  This function will initializes the descriptor ring of a DMA channel
+*
+*
+*  @return   -1 - On failure
+*             0 - On success
+*  @note
+*     - "len" parameter should be obtained from "dmacHw_descriptorLen"
+*     - Descriptor buffer MUST be 32 bit aligned and uncached as it
+*       is accessed by ARM and DMA
+*/
+/****************************************************************************/
+int dmacHw_initDescriptor
+(
+   void     *pDescriptorVirt,        ///<  [ IN ] Virtual address of uncahced buffer allocated to form descriptor ring
+   uint32_t descriptorPhyAddr,       ///<  [ IN ] Physical address of pDescriptorVirt (descriptor buffer)
+   uint32_t len,                     ///<  [ IN ] Size of the pBuf
+   uint32_t num                      ///<  [ IN ] Number of descriptor in the ring
+);
+
+
+/****************************************************************************/
+/**
+*  @brief  Finds amount of memory required to form a descriptor ring
+*
+*
+*  @return   Number of bytes required to form a descriptor ring
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorLen
+(
+   uint32_t descCnt                      ///<  [ IN ] Number of descriptor in the ring
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Configure DMA channel
+*
+*  @return  0  : On success
+*           -1 : On failure
+*/
+/****************************************************************************/
+int dmacHw_configChannel
+(
+   dmacHw_HANDLE_t handle,         ///<  [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig        ///<   [ IN ] Configuration settings
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptors for known data length
+*
+*  When DMA has to work as a flow controller, this function prepares the
+*  descriptor chain to transfer data
+*
+*  from:
+*          - Memory to memory
+*          - Peripheral to memory
+*          - Memory to Peripheral
+*          - Peripheral to Peripheral
+*
+*  @return   -1 - On failure
+*             0 - On success
+*
+*/
+/****************************************************************************/
+int dmacHw_setDataDescriptor
+(
+   dmacHw_CONFIG_t *pConfig,        ///<  [ IN ] Configuration settings
+   void*  pDescriptor,              ///<  [ IN ] Descriptor buffer
+   void*  pSrcAddr,                 ///<  [ IN ] Source (Peripheral/Memory) address
+   void*  pDstAddr,                 ///<  [ IN ] Destination (Peripheral/Memory) address
+   size_t dataLen                   ///<  [ IN ] Length in bytes
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Indicates whether DMA transfer is in progress or completed
+*
+*  @return   DMA transfer status
+*          dmacHw_TRANSFER_STATUS_BUSY:         DMA Transfer ongoing
+*          dmacHw_TRANSFER_STATUS_DONE:         DMA Transfer completed
+*          dmacHw_TRANSFER_STATUS_ERROR:        DMA Transfer error
+*
+*/
+/****************************************************************************/
+dmacHw_TRANSFER_STATUS_e dmacHw_transferCompleted
+(
+   dmacHw_HANDLE_t handle                    ///<   [ IN ] DMA Channel handle
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptor carrying control information
+*
+*  This function will be used to send specific control information to the device
+*  using the DMA channel
+*
+*
+*  @return  -1 - On failure
+*            0 - On success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_setControlDescriptor
+(
+   dmacHw_CONFIG_t *pConfig,          ///<  [ IN ] Configuration settings
+   void* pDescriptor,                 ///<  [ IN ] Descriptor buffer
+   uint32_t ctlAddress,               ///<  [ IN ] Address of the device control register
+   uint32_t control                   ///<  [ IN ] Device control information
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Read data DMA transferred to memory
+*
+*  This function will read data that has been DMAed to memory while transfering from:
+*          - Memory to memory
+*          - Peripheral to memory
+*
+*  @return  0 - No more data is available to read
+*           1 - More data might be available to read
+*
+*/
+/****************************************************************************/
+int dmacHw_readTransferredData
+(
+   dmacHw_HANDLE_t handle,           ///<  [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,         ///<  [ IN ]  Configuration settings
+   void* pDescriptor,                ///<  [ IN ] Descriptor buffer
+   void** ppBbuf,                    ///<  [ OUT ] Data received
+   size_t *pLlen                     ///<  [ OUT ] Length of the data received
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Prepares descriptor ring, when source peripheral working as a flow controller
+*
+*  This function will form the descriptor ring by allocating buffers, when source peripheral
+*  has to work as a flow controller to transfer data from:
+*           - Peripheral to memory.
+*
+*  @return  -1 - On failure
+*            0 - On success
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_setVariableDataDescriptor
+(
+   dmacHw_HANDLE_t handle,            ///<  [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,          ///<  [ IN ] Configuration settings
+   void* pDescriptor,                 ///<  [ IN ] Descriptor buffer
+   uint32_t srcAddr,                  ///<  [ IN ] Source peripheral address
+   void *(*fpAlloc)( int len ),       ///<  [ IN ] Function pointer  that provides destination memory
+   int len,                           ///<  [ IN ] Number of bytes "fpAlloc" will allocate for destination
+   int num                            ///<  [ IN ] Number of descriptor to set
+);
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to initiate transfer
+*
+*  @return  void
+*
+*
+*  @note
+*     - Descriptor buffer MUST ALWAYS be flushed before calling this function
+*     - This function should also be called from ISR to program the channel with
+*       pending descriptors
+*/
+/****************************************************************************/
+void dmacHw_initiateTransfer
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   dmacHw_CONFIG_t *pConfig,                 ///<   [ IN ] Configuration settings
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Resets descriptor control information
+*
+*  @return  void
+*/
+/****************************************************************************/
+void dmacHw_resetDescriptorControl
+(
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to stop transfer
+*
+*  Ensures the channel is not doing any transfer after calling this function
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+void dmacHw_stopTransfer
+(
+   dmacHw_HANDLE_t handle                    ///<   [ IN ] DMA Channel handle
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Check the existance of pending descriptor
+*
+*  This function confirmes if there is any pending descriptor in the chain
+*  to program the channel
+*
+*  @return  1 : Channel need to be programmed with pending descriptor
+*           0 : No more pending descriptor to programe the channel
+*
+*  @note
+*     - This function should be called from ISR in case there are pending
+*       descriptor to program the channel.
+*
+*     Example:
+*
+*     dmac_isr ()
+*     {
+*         ...
+*         if ( dmacHw_descriptorPending ( handle ) )
+*         {
+*            dmacHw_initiateTransfer ( handle );
+*         }
+*     }
+*
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorPending
+(
+   dmacHw_HANDLE_t handle,                   ///<   [ IN ] DMA Channel handle
+   void* pDescriptor                         ///<   [ IN ] Descriptor buffer
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Deallocates source or destination memory, allocated
+*
+*  This function can be called to deallocate data memory that was DMAed successfully
+*
+*  @return  -1  - On failure
+*            0  - On success
+*
+*  @note
+*     This function will be called ONLY, when source OR destination address is pointing
+*     to dynamic memory
+*/
+/****************************************************************************/
+int dmacHw_freeMem
+(
+   dmacHw_CONFIG_t *pConfig,           ///<  [ IN ] Configuration settings
+   void* pDescriptor,                  ///<  [ IN ] Descriptor buffer
+   void (*fpFree) ( void* )            ///<  [ IN ] Function pointer to free data memory
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Clears the interrupt
+*
+*  This function clears the DMA channel specific interrupt
+*
+*  @return   N/A
+*
+*  @note
+*     Must be called under the context of ISR
+*/
+/****************************************************************************/
+void dmacHw_clearInterrupt
+(
+   dmacHw_HANDLE_t handle              ///<  [ IN ] DMA Channel handle
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Returns the cause of channel specific DMA interrupt
+*
+*  This function returns the cause of interrupt
+*
+*  @return  Interrupt status, each bit representing a specific type of interrupt
+*           of type dmacHw_INTERRUPT_STATUS_e
+*  @note
+*           This function should be called under the context of ISR
+*/
+/****************************************************************************/
+dmacHw_INTERRUPT_STATUS_e dmacHw_getInterruptStatus
+(
+   dmacHw_HANDLE_t handle              ///<  [ IN ] DMA Channel handle
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Indentifies a DMA channel causing interrupt
+*
+*  This functions returns a channel causing interrupt of type dmacHw_INTERRUPT_STATUS_e
+*
+*  @return  NULL   : No channel causing DMA interrupt
+*           ! NULL : Handle to a channel causing DMA interrupt
+*  @note
+*     dmacHw_clearInterrupt() must be called with a valid handle after calling this function
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getInterruptSource ( void );
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Sets channel specific user data
+*
+*  This function associates user data to a specif DMA channel
+*
+*/
+/****************************************************************************/
+void dmacHw_setChannelUserData
+(
+  dmacHw_HANDLE_t handle,       ///<  [ IN ] DMA Channel handle
+  void            *userData     ///<  [ IN ] User data
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Gets channel specific user data
+*
+*  This function returns user data specific to a DMA channel
+*
+*  @return   user data
+*/
+/****************************************************************************/
+void *dmacHw_getChannelUserData
+(
+   dmacHw_HANDLE_t handle     ///<  [ IN ] DMA Channel handle
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Displays channel specific registers and other control parameters
+*
+*
+*  @return  void
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+void dmacHw_printDebugInfo
+(
+   dmacHw_HANDLE_t handle,              ///<  [ IN ] DMA Channel handle
+   void* pDescriptor,                   ///<  [ IN ] Descriptor buffer
+   int (*fpPrint) (const char *, ...)            ///<  [ IN ] Print callback function
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Provides DMA controller attributes
+*
+*
+*  @return  DMA controller attributes
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+uint32_t dmacHw_getDmaControllerAttribute
+(
+   dmacHw_HANDLE_t handle,             ///<  [ IN ]  DMA Channel handle
+   dmacHw_CONTROLLER_ATTRIB_e  attr    ///<  [ IN ]  DMA Controler attribute of type  dmacHw_CONTROLLER_ATTRIB_e
+);
+
+
+#endif /* _DMACHW_H */
+
+
diff --git a/arch/arm/mach-bcmring/include/csp/errno.h b/arch/arm/mach-bcmring/include/csp/errno.h
new file mode 100644
index 0000000..4af30dc
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/errno.h
@@ -0,0 +1,36 @@
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
+
+#ifndef CSP_ERRNO_H
+#define CSP_ERRNO_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#if   defined( __KERNEL__ )
+    #include <linux/errno.h>
+#elif defined( CSP_SIMULATION )
+    #include <asm-generic/errno.h>
+#else
+    #include <errno.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif // CSP_ERRNO_H
+
diff --git a/arch/arm/mach-bcmring/include/csp/intcHw.h b/arch/arm/mach-bcmring/include/csp/intcHw.h
new file mode 100644
index 0000000..13a232c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/intcHw.h
@@ -0,0 +1,46 @@
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
+
+/****************************************************************************/
+/**
+*  @file    intcHw.h
+*
+*  @brief   generic interrupt controller API
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _INTCHW_H
+#define _INTCHW_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/csp/intcHw_reg.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+static inline void intcHw_irq_disable(void *basep, uint32_t mask);
+static inline void intcHw_irq_enable(void *basep, uint32_t mask);
+static inline void intcHw_irq_type(void *basep, uint32_t mask);
+static inline uint32_t intcHw_rawstatus(void *basep);
+static inline uint32_t intcHw_irq_status(void *basep);
+static inline uint32_t intcHw_fiq_status(void *basep);
+
+
+#endif /* _INTCHW_H */
+
diff --git a/arch/arm/mach-bcmring/include/csp/module.h b/arch/arm/mach-bcmring/include/csp/module.h
new file mode 100644
index 0000000..5b559d2
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/module.h
@@ -0,0 +1,33 @@
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
+
+#ifndef CSP_MODULE_H
+#define CSP_MODULE_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#ifdef __KERNEL__
+    #include <linux/module.h>
+#else
+    #define EXPORT_SYMBOL(symbol)
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif // CSP_MODULE_H
diff --git a/arch/arm/mach-bcmring/include/csp/reg.h b/arch/arm/mach-bcmring/include/csp/reg.h
new file mode 100644
index 0000000..9469cee
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/reg.h
@@ -0,0 +1,120 @@
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
+
+/****************************************************************************/
+/**
+*  @file    reg.h
+*
+*  @brief   Generic register defintions used in CSP
+*/
+/****************************************************************************/
+
+#ifndef CSP_REG_H
+#define CSP_REG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/stdint.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define __REG32(x)      ( *((volatile uint32_t *)(x)) )
+#define __REG16(x)      ( *((volatile uint16_t *)(x)) )
+#define __REG8(x)       ( *((volatile uint8_t *) (x)) )
+
+
+// Macros used to define a sequence of reserved registers. The start / end
+// are byte offsets in the particular register definition, with the "end"
+// being the offset of the next un-reserved register. E.g. if offsets
+// 0x10 through to 0x1f are reserved, then this reserved area could be
+// specified as follows.
+//
+//  typedef struct
+//  {
+//      uint32_t reg1;          // offset 0x00
+//      uint32_t reg2;          // offset 0x04
+//      uint32_t reg3;          // offset 0x08
+//      uint32_t reg4;          // offset 0x0c
+//      REG32_RSVD(0x10, 0x20);
+//      uint32_t reg5;          // offset 0x20
+//      ...
+//  } EXAMPLE_REG_t;
+//
+#define REG8_RSVD(start, end)   uint8_t rsvd_##start[ (end - start) / sizeof(uint8_t) ]
+#define REG16_RSVD(start, end)  uint16_t rsvd_##start[ (end - start) / sizeof(uint16_t) ]
+#define REG32_RSVD(start, end)  uint32_t rsvd_##start[ (end - start) / sizeof(uint32_t) ]
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+//
+// Note: When protecting multiple statements, the REG_LOCAL_IRQ_SAVE and
+// REG_LOCAL_IRQ_RESTORE must be enclosed in { } to allow the
+// flags variable to be declared locally.
+// e.g.
+//    statement1;
+//    {
+//       REG_LOCAL_IRQ_SAVE;
+//       <multiple statements here>
+//       REG_LOCAL_IRQ_RESTORE;
+//    }
+//    statement2;
+//
+
+
+#if defined( __KERNEL__ ) && !defined( STANDALONE )
+#include <linux/interrupt.h>
+
+#define REG_LOCAL_IRQ_SAVE      unsigned long flags; local_irq_save( flags )
+#define REG_LOCAL_IRQ_RESTORE   local_irq_restore( flags )
+
+#else
+
+#define REG_LOCAL_IRQ_SAVE
+#define REG_LOCAL_IRQ_RESTORE
+
+#endif
+
+static inline void reg32_modify_and( volatile uint32_t *reg, uint32_t value )
+{
+    REG_LOCAL_IRQ_SAVE;
+    *reg &= value;
+    REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_modify_or( volatile uint32_t *reg, uint32_t value )
+{
+    REG_LOCAL_IRQ_SAVE;
+    *reg |= value;
+    REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_modify_mask( volatile uint32_t *reg, uint32_t mask, uint32_t value )
+{
+    REG_LOCAL_IRQ_SAVE;
+    *reg = (*reg & mask) | value;
+    REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_write( volatile uint32_t *reg, uint32_t value )
+{
+    REG_LOCAL_IRQ_SAVE;
+    *reg = value;
+    REG_LOCAL_IRQ_RESTORE;
+}
+
+#endif /* CSP_REG_H */
+
diff --git a/arch/arm/mach-bcmring/include/csp/secHw.h b/arch/arm/mach-bcmring/include/csp/secHw.h
new file mode 100644
index 0000000..49beee0
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/secHw.h
@@ -0,0 +1,79 @@
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
+
+
+
+/****************************************************************************/
+/**
+*  @file    secHw.h
+*
+*  @brief   Definitions for accessing low level security features
+*
+*/
+/****************************************************************************/
+#ifndef SECHW_H
+#define SECHW_H
+
+
+typedef void ( *secHw_FUNC_t ) ( void );
+
+typedef enum
+{
+   secHw_MODE_SECURE     = 0x0,       /* Switches processor into secure mode */
+   secHw_MODE_NONSECURE  = 0x1        /* Switches processor into non-secure mode */
+}secHw_MODE;
+
+/****************************************************************************/
+/**
+*  @brief   Requesting to execute the function in secure mode
+*
+*  This function requests the given function to run in secure mode
+*
+*/
+/****************************************************************************/
+void secHw_RunSecure
+(
+   secHw_FUNC_t   ///< Function to run in secure mode
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Sets the  mode
+*
+*  his function sets the processor mode (secure/non-secure)
+*
+*/
+/****************************************************************************/
+void  secHw_SetMode
+(
+   secHw_MODE    ///< Processor mode
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Get the current mode
+*
+*  This function retieves the processor mode (secure/non-secure)
+*
+*/
+/****************************************************************************/
+void secHw_GetMode ( secHw_MODE* );
+
+
+#endif /* SECHW_H */
+
diff --git a/arch/arm/mach-bcmring/include/csp/stdint.h b/arch/arm/mach-bcmring/include/csp/stdint.h
new file mode 100644
index 0000000..1c059f1
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/stdint.h
@@ -0,0 +1,34 @@
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
+
+#ifndef CSP_STDINT_H
+#define CSP_STDINT_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#ifdef __KERNEL__
+    #include <linux/types.h>
+#else
+    #include <stdint.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif // CSP_STDINT_H
+
diff --git a/arch/arm/mach-bcmring/include/csp/tmrHw.h b/arch/arm/mach-bcmring/include/csp/tmrHw.h
new file mode 100644
index 0000000..60f9cae
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/tmrHw.h
@@ -0,0 +1,319 @@
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
+
+
+
+/****************************************************************************/
+/**
+*  @file    tmrHw.h
+*
+*  @brief   API definitions for low level Timer driver
+*
+*/
+/****************************************************************************/
+#ifndef _TMRHW_H
+#define _TMRHW_H
+
+#include <csp/stdint.h>
+
+typedef uint32_t tmrHw_ID_t;           /* Timer ID */
+typedef uint32_t tmrHw_COUNT_t;        /* Timer count */
+typedef uint32_t tmrHw_INTERVAL_t;     /* Timer interval */
+typedef uint32_t tmrHw_RATE_t;         /* Timer event (count/interrupt) rate */
+
+typedef enum
+{
+   tmrHw_INTERRUPT_STATUS_SET,         /* Interrupted  */
+   tmrHw_INTERRUPT_STATUS_UNSET        /* No Interrupt */
+}tmrHw_INTERRUPT_STATUS_e;
+
+typedef enum
+{
+   tmrHw_CAPABILITY_CLOCK,             /* Clock speed in HHz */
+   tmrHw_CAPABILITY_RESOLUTION         /* Timer resolution in bits */
+}tmrHw_CAPABILITY_e;
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Get timer capability
+*
+*  This function returns various capabilities/attributes of a timer
+*
+*  @return  Numeric capability
+*
+*/
+/****************************************************************************/
+uint32_t tmrHw_getTimerCapability
+(
+   tmrHw_ID_t           timerId,        //<  [ IN ] Timer Id
+   tmrHw_CAPABILITY_e   capability      //<  [ IN ] Timer capability
+);
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer in terms of timer interrupt rate
+*
+*  This function initializes a periodic timer to generate specific number of
+*  timer interrupt per second
+*
+*  @return   On success: Effective timer frequency
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_setPeriodicTimerRate
+(
+   tmrHw_ID_t           timerId,        //<  [ IN ] Timer Id
+   tmrHw_RATE_t         rate            //<  [ IN ] Number of timer interrupt per second
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer to generate timer interrupt after
+*           certain time interval
+*
+*  This function initializes a periodic timer to generate timer interrupt
+*  after every time interval in milisecond
+*
+*  @return   On success: Effective interval set in mili-second
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_INTERVAL_t tmrHw_setPeriodicTimerInterval
+(
+   tmrHw_ID_t         timerId,        //<  [ IN ] Timer Id
+   tmrHw_INTERVAL_t   msec            //<  [ IN ] Interval in mili-second
+);
+
+/****************************************************************************/
+/**
+*  @brief   Configures a periodic timer to generate timer interrupt just once
+*           after certain time interval
+*
+*  This function initializes a periodic timer to generate a single ticks after
+*  certain time interval in milisecond
+*
+*  @return   On success: Effective interval set in mili-second
+*            On failure: 0
+*
+*/
+/****************************************************************************/
+tmrHw_INTERVAL_t tmrHw_setOneshotTimerInterval
+(
+   tmrHw_ID_t         timerId,        //<  [ IN ] Timer Id
+   tmrHw_INTERVAL_t   msec            //<  [ IN ] Interval in mili-second
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Configures a timer to run as a free running timer
+*
+*  This function initializes a timer to run as a free running timer
+*
+*  @return   Timer resolution ( count / sec )
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_setFreeRunningTimer
+(
+   tmrHw_ID_t               timerId,        //<  [ IN ] Timer Id
+   uint32_t                 divider         //<  [ IN ] Dividing the clock frequency
+)   __attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief   Starts a timer
+*
+*  This function starts a preconfigured timer
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*/
+/****************************************************************************/
+int tmrHw_startTimer
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)   __attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief   Stops a timer
+*
+*  This function stops a running timer
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*/
+/****************************************************************************/
+int tmrHw_stopTimer
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Gets current timer count
+*
+*  This function returns the current timer value
+*
+*  @return  Current downcounting timer value
+*
+*/
+/****************************************************************************/
+tmrHw_COUNT_t tmrHw_GetCurrentCount
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)  __attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief   Gets timer count rate
+*
+*  This function returns the number of counts per second
+*
+*  @return  Count rate
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_getCountRate
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+)  __attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief   Enables timer interrupt
+*
+*  This function enables the timer interrupt
+*
+*  @return   N/A
+*
+*/
+/****************************************************************************/
+void tmrHw_enableInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+);
+
+/****************************************************************************/
+/**
+*  @brief   Disables timer interrupt
+*
+*  This function disable the timer interrupt
+*
+*  @return   N/A
+*/
+/****************************************************************************/
+void tmrHw_disableInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+);
+
+/****************************************************************************/
+/**
+*  @brief   Clears the interrupt
+*
+*  This function clears the timer interrupt
+*
+*  @return   N/A
+*
+*  @note
+*     Must be called under the context of ISR
+*/
+/****************************************************************************/
+void tmrHw_clearInterrupt
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+);
+
+/****************************************************************************/
+/**
+*  @brief   Gets the interrupt status
+*
+*  This function returns timer interrupt status
+*
+*  @return   Interrupt status
+*/
+/****************************************************************************/
+tmrHw_INTERRUPT_STATUS_e tmrHw_getInterruptStatus
+(
+   tmrHw_ID_t timerId        //<  [ IN ] Timer id
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Indentifies a timer causing interrupt
+*
+*  This functions returns a timer causing interrupt
+*
+*  @return  0xFFFFFFFF   : No timer causing an interrupt
+*           ! 0xFFFFFFFF : timer causing an interrupt
+*  @note
+*     tmrHw_clearIntrrupt() must be called with a valid timer id after calling this function
+*/
+/****************************************************************************/
+tmrHw_ID_t tmrHw_getInterruptSource ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Displays specific timer registers
+*
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+void tmrHw_printDebugInfo
+(
+   tmrHw_ID_t timerId,                  //<  [ IN ] Timer id
+   int (*fpPrint) (const char *, ...)   //<  [ IN ] Print callback function
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Use a timer to perform a busy wait delay for a number of usecs.
+*
+*  @return   N/A
+*/
+/****************************************************************************/
+void tmrHw_udelay
+(
+   tmrHw_ID_t timerId,        ///<  [ IN ] Timer id
+   unsigned long usecs        ///<  [ IN ] usec to delay
+)  __attribute__ ((section(".aramtext")));
+
+
+#endif /* _TMRHW_H */
+
+
+
+
+
+
+
+
diff --git a/arch/arm/mach-bcmring/include/csp/uartHw.h b/arch/arm/mach-bcmring/include/csp/uartHw.h
new file mode 100644
index 0000000..bdef718
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/uartHw.h
@@ -0,0 +1,329 @@
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
+
+/****************************************************************************/
+/**
+*  @file    uart.h
+*
+*  @brief   API definitions for low level UART driver.
+*
+*  @note
+*/
+/****************************************************************************/
+
+#ifndef _UARTHW_H
+#define _UARTHW_H
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/stdint.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define uartHw_STATE_INACTIVE       0
+#define uartHw_STATE_ACTIVE         1
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+/****************************************************************************/
+/**
+*  @brief   Initializes specified UART at a desired baud rate
+*
+*  @note    Data framing is fixed at 8N1.
+*
+*  @return
+*   On success: Effective baud rate
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+long uartHw_Init
+(
+    unsigned        uartNum,    ///< [IN]  uart number (0 .. max)
+    unsigned long   baudRate    ///< [IN]  baud rate (9600, 115200, ...)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Enable / Disable UART loopback mode
+*
+*/
+/****************************************************************************/
+static inline void uartHw_LoopbackDisable
+(
+    unsigned        uartNum    ///< [IN]  uart number (0 .. max)
+);
+
+static inline void uartHw_LoopbackEnable
+(
+    unsigned        uartNum    ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   UART control signal operations (RTS/CTS, DTR/DSR, RI, DCD)
+*
+*   RTS is output, CTS is input. These also provide h/w flow control.
+*   DTR is output, DSR is input
+*   RI / DCD are input
+*
+*  @params  uartNum         [IN]  uart number (0 .. max)
+*  @params  state           [IN]  uart signal state (uartHw_STATE_ACTIVE, uartHw_STATE_INACTIVE)
+*
+*  @return
+*   (where applicable)
+*   state: uartHw_STATE_ACTIVE, uartHw_STATE_INACTIVE
+*/
+/****************************************************************************/
+static inline void uartHw_CtsFlowCtrlDisable( unsigned uartNum );
+static inline void uartHw_CtsFlowCtrlEnable( unsigned uartNum );
+static inline int uartHw_CtsStateGet( unsigned uartNum );
+
+static inline int uartHw_DcdStateGet( unsigned uartNum );
+
+static inline int uartHw_DsrStateGet( unsigned uartNum );
+
+static inline int uartHw_DtrStateGet( unsigned uartNum );
+static inline void uartHw_DtrStateSet( unsigned uartNum, unsigned state );
+
+static inline int uartHw_RiStateGet( unsigned uartNum );
+
+static inline void uartHw_RtsFlowCtrlDisable( unsigned uartNum );
+static inline void uartHw_RtsFlowCtrlEnable( unsigned uartNum );
+static inline int uartHw_RtsStateGet( unsigned uartNum );
+static inline void uartHw_RtsStateSet( unsigned uartNum, unsigned state );
+
+/****************************************************************************/
+/**
+*  @brief   UART Rx FIFO DMA operations
+*
+*  @params  uartNum         [IN]  uart number (0 .. max)
+*
+*  @return
+*   (where applicable)
+*   DmaAddr: physical address to use for DMA operations (source address)
+*/
+/****************************************************************************/
+static inline void uartHw_RxFifoDmaDisable( unsigned uartNum );
+static inline void uartHw_RxFifoDmaEnable( unsigned uartNum );
+static inline uint32_t uartHw_RxFifoDmaAddrGet( unsigned uartNum );
+
+/****************************************************************************/
+/**
+*  @brief   Indicates if specified UART has no Rx data available
+*
+*  @return
+*   On success: 0
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+int uartHw_RxFifoEmpty
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Indicates if specified UART Rx FIFO is full
+*
+*  @return
+*   On success: 0 if not full, > 0 otherwise
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_RxFifoFull
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Flushes (discards) all available Rx data from specified UART
+*
+*  @return
+*   On success: 0
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+int uartHw_RxFifoFlush
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
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
+static inline int uartHw_RxFifoGet
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
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
+static inline int uartHw_RxFifoReady
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Sets UART Rx FIFO threshold level. Used for flow control, DMA, etc.
+*
+*  @return
+*   On success: 0 if not full, > 0 otherwise
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline void uartHw_RxFifoThresholdSet
+(
+    unsigned uartNum,       ///< [IN]  uart number (0 .. max)
+    unsigned byteCnt        ///< [IN]  threshold level in bytes
+);
+
+/****************************************************************************/
+/**
+*  @brief   UART Tx FIFO DMA operations
+*
+*  @params  uartNum         [IN]  uart number (0 .. max)
+*
+*  @return
+*   (where applicable)
+*   DmaAddr: physical address to use for DMA operations (destination address)
+*/
+/****************************************************************************/
+static inline void uartHw_TxFifoDmaDisable( unsigned uartNum );
+static inline void uartHw_TxFifoDmaEnable( unsigned uartNum );
+static inline uint32_t uartHw_TxFifoDmaAddrGet( unsigned uartNum );
+
+/****************************************************************************/
+/**
+*  @brief   Indicates if specified UART Tx FIFO is empty
+*
+*  @return
+*   On success: 0 if not full, > 0 otherwise
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_TxFifoEmpty
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Indicates if specified UART has no Tx space available
+*
+*  @return
+*   On success: 0 if not full, > 0 otherwise
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+int uartHw_TxFifoFull
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+/****************************************************************************/
+/**
+*  @brief   Sets UART Tx FIFO threshold level. Used for flow control, DMA, etc.
+*
+*  @return
+*   On success: 0 if not full, > 0 otherwise
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline void uartHw_TxFifoThresholdSet
+(
+    unsigned uartNum,       ///< [IN]  uart number (0 .. max)
+    unsigned byteCnt        ///< [IN]  threshold level in bytes
+);
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
+static inline int uartHw_TxFifoPut
+(
+    unsigned    uartNum,    ///< [IN]  uart number (0 .. max)
+    unsigned    value       ///< [IN]  output value
+);
+
+/****************************************************************************/
+/**
+*  @brief   Wait util specified UART has finished Tx
+*
+*  @note    Blocks until Tx line is idle or Tx FIFO empty.
+*
+*  @return
+*   On success: 0
+*   On failure: -errno
+*
+*/
+/****************************************************************************/
+static inline int uartHw_TxWaitIdle
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+);
+
+#include <mach/csp/uartHw_inline.h>
+
+#ifdef __cplusplus
+// end extern "C"
+}
+#endif
+
+#endif /* _UARTHW_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/cap.h b/arch/arm/mach-bcmring/include/mach/csp/cap.h
new file mode 100644
index 0000000..fd809fa
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/cap.h
@@ -0,0 +1,66 @@
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
+typedef enum
+{
+   CAP_NOT_PRESENT = 0,
+   CAP_PRESENT
+} CAP_RC_T;
+
+typedef enum
+{
+   CAP_VPM,
+   CAP_ETH_PHY,
+   CAP_ETH_GMII,
+   CAP_ETH_SGMII,
+   CAP_USB,
+   CAP_TSC,
+   CAP_EHSS,
+   CAP_SDIO,
+   CAP_UARTB,
+   CAP_KEYPAD,
+   CAP_CLCD,
+   CAP_GE,
+   CAP_LEDM,
+   CAP_BBL,
+   CAP_VDEC,
+   CAP_PIF,
+   CAP_APM,
+   CAP_SPU,
+   CAP_PKA,
+   CAP_RNG,
+} CAP_CAPABILITY_T;
+
+typedef enum
+{
+   CAP_LCD_WVGA = 0,
+   CAP_LCD_VGA = 0x1,
+   CAP_LCD_WQVGA = 0x2,
+   CAP_LCD_QVGA = 0x3
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
\ No newline at end of file
diff --git a/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h b/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
new file mode 100644
index 0000000..9f548cd
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
@@ -0,0 +1,421 @@
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
+#define capConfig1 (CAP_CONFIG1_APMC_DIS| CAP_CONFIG1_CLCD_RES_WQVGA)
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
+#if   ((CFG_GLOBAL_CHIP == BCM11107) ||(CFG_GLOBAL_CHIP == FPGA11107))
+#define CAP_HW_CFG_ARM_CLK_HZ 500000000
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+#define CAP_HW_CFG_ARM_CLK_HZ 300000000
+#elif (CFG_GLOBAL_CHIP == BCM11211)
+#define CAP_HW_CFG_ARM_CLK_HZ 666666666
+#else
+#error CFG_GLOBAL_CHIP type capabilities not defined
+#endif
+
+#if ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == BCM11211) ||(CFG_GLOBAL_CHIP == FPGA11107))
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
+   CAP_RC_T returnVal = CAP_NOT_PRESENT;
+
+   switch (capability)
+   {
+      case CAP_VPM:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_VPM_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_ETH_PHY:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_ETH_PHY0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_ETH_PHY1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_ETH_GMII:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_ETH_GMII0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_ETH_GMII1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_ETH_SGMII:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_ETH_SGMII0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_ETH_SGMII1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_USB:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_USB0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_USB1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_TSC:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_TSC_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_EHSS:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_EHSS0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_EHSS1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_SDIO:
+      {
+         if ((index == 0) && (!(capConfig0 & CAP_CONFIG0_SDIO0_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig0 & CAP_CONFIG0_SDIO1_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_UARTB:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_UARTB_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_KEYPAD:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_KEYPAD_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_CLCD:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_CLCD_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_GE:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_GE_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_LEDM:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_LEDM_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_BBL:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_BBL_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_VDEC:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_VDEC_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_PIF:
+      {
+         if (!(capConfig0 & CAP_CONFIG0_PIF_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_APM:
+      {
+         if ((index == 0) && (!(capConfig1 & CAP_CONFIG1_APMA_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 1) && (!(capConfig1 & CAP_CONFIG1_APMB_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+         if ((index == 2) && (!(capConfig1 & CAP_CONFIG1_APMC_DIS)))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_SPU:
+      {
+         if (!(capConfig2 & CAP_CONFIG2_SPU_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_PKA:
+      {
+         if (!(capConfig2 & CAP_CONFIG2_PKA_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      case CAP_RNG:
+      {
+         if (!(capConfig2 & CAP_CONFIG2_RNG_DIS))
+         {
+            returnVal = CAP_PRESENT;
+         }
+      }
+      break;
+
+      default:
+      {
+      }
+      break;
+   }
+   return( returnVal );
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
+#if   ((CFG_GLOBAL_CHIP == BCM11107) ||(CFG_GLOBAL_CHIP == FPGA11107))
+   return( 500000000 );
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+   return( 300000000 );
+#elif (CFG_GLOBAL_CHIP == BCM11211)
+   return( 666666666 );
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
+#if ((CFG_GLOBAL_CHIP == BCM11107) || (CFG_GLOBAL_CHIP == BCM11211) ||(CFG_GLOBAL_CHIP == FPGA11107))
+   return( 333333333 );
+#elif ((CFG_GLOBAL_CHIP == BCM11109) || (CFG_GLOBAL_CHIP == BCM11170) || (CFG_GLOBAL_CHIP == BCM11110))
+   return( 200000000 );
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
+   return( (CAP_LCD_RES_T)((capConfig1 & CAP_CONFIG1_CLCD_RES_MASK) >> CAP_CONFIG1_CLCD_RES_SHIFT) );
+}
+
+#endif
\ No newline at end of file
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
new file mode 100644
index 0000000..db880da
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
@@ -0,0 +1,1293 @@
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
+
+/* ---- Public Constants and Types ---------------------------------------- */
+
+// Set 1 to configure DDR/VPM phase alignment by HW
+#define chipcHw_DDR_HW_PHASE_ALIGN    0
+#define chipcHw_VPM_HW_PHASE_ALIGN    0
+
+typedef uint32_t chipcHw_freq;
+
+
+/* Configurable miscellaneous clocks */
+typedef enum
+{
+  chipcHw_CLOCK_DDR,                      /* DDR PHY Clock */
+  chipcHw_CLOCK_ARM,                      /* ARM Clock */
+  chipcHw_CLOCK_ESW,                      /* Ethernet Switch Clock */
+  chipcHw_CLOCK_VPM,                      /* VPM Clock */
+  chipcHw_CLOCK_ESW125,                   /* Ethernet MII Clock */
+  chipcHw_CLOCK_UART,                     /* UART Clock */
+  chipcHw_CLOCK_SDIO0,                    /* SDIO 0 Clock */
+  chipcHw_CLOCK_SDIO1,                    /* SDIO 1 Clock */
+  chipcHw_CLOCK_SPI,                      /* SPI Clock */
+  chipcHw_CLOCK_ETM,                      /* ARM ETM Clock */
+
+  chipcHw_CLOCK_BUS,                      /* BUS Clock */
+  chipcHw_CLOCK_OTP,                      /* OTP Clock */
+  chipcHw_CLOCK_I2C,                      /* I2C Host Clock */
+  chipcHw_CLOCK_I2S0,                     /* I2S 0 Host Clock */
+  chipcHw_CLOCK_RTBUS,                    /* DDR PHY Configuration Clock */
+  chipcHw_CLOCK_APM100,                   /* APM100 Clock */
+  chipcHw_CLOCK_TSC,                      /* Touch screen Clock */
+  chipcHw_CLOCK_LED,                      /* LED Clock */
+
+  chipcHw_CLOCK_USB,                      /* USB Clock */
+  chipcHw_CLOCK_LCD,                      /* LCD CLock */
+  chipcHw_CLOCK_APM,                      /* APM Clock */
+
+  chipcHw_CLOCK_I2S1,                     /* I2S 1 Host Clock */
+}chipcHw_CLOCK_e;
+
+/* System booting strap options */
+typedef enum
+{
+  chipcHw_BOOT_DEVICE_UART            =    chipcHw_STRAPS_BOOT_DEVICE_UART,
+  chipcHw_BOOT_DEVICE_SERIAL_FLASH    =    chipcHw_STRAPS_BOOT_DEVICE_SERIAL_FLASH,
+  chipcHw_BOOT_DEVICE_NOR_FLASH_16    =    chipcHw_STRAPS_BOOT_DEVICE_NOR_FLASH_16,
+  chipcHw_BOOT_DEVICE_NAND_FLASH_8    =    chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_8,
+  chipcHw_BOOT_DEVICE_NAND_FLASH_16   =    chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_16
+}chipcHw_BOOT_DEVICE_e;
+
+
+/* System booting modes */
+typedef enum
+{
+  chipcHw_BOOT_MODE_NORMAL            =    chipcHw_STRAPS_BOOT_MODE_NORMAL,
+  chipcHw_BOOT_MODE_DBG_SW            =    chipcHw_STRAPS_BOOT_MODE_DBG_SW,
+  chipcHw_BOOT_MODE_DBG_BOOT          =    chipcHw_STRAPS_BOOT_MODE_DBG_BOOT,
+  chipcHw_BOOT_MODE_NORMAL_QUIET      =    chipcHw_STRAPS_BOOT_MODE_NORMAL_QUIET
+}chipcHw_BOOT_MODE_e;
+
+
+/* NAND Flash page size strap options */
+typedef enum
+{
+  chipcHw_NAND_PAGESIZE_512           =    chipcHw_STRAPS_NAND_PAGESIZE_512,
+  chipcHw_NAND_PAGESIZE_2048          =    chipcHw_STRAPS_NAND_PAGESIZE_2048,
+  chipcHw_NAND_PAGESIZE_4096          =    chipcHw_STRAPS_NAND_PAGESIZE_4096,
+  chipcHw_NAND_PAGESIZE_EXT           =    chipcHw_STRAPS_NAND_PAGESIZE_EXT
+}chipcHw_NAND_PAGESIZE_e;
+
+
+/* GPIO Pin function */
+typedef enum
+{
+  chipcHw_GPIO_FUNCTION_KEYPAD        =     chipcHw_REG_GPIO_MUX_KEYPAD,
+  chipcHw_GPIO_FUNCTION_I2CH          =     chipcHw_REG_GPIO_MUX_I2CH,
+  chipcHw_GPIO_FUNCTION_SPI           =     chipcHw_REG_GPIO_MUX_SPI,
+  chipcHw_GPIO_FUNCTION_UART          =     chipcHw_REG_GPIO_MUX_UART,
+  chipcHw_GPIO_FUNCTION_LEDMTXP       =     chipcHw_REG_GPIO_MUX_LEDMTXP,
+  chipcHw_GPIO_FUNCTION_LEDMTXS       =     chipcHw_REG_GPIO_MUX_LEDMTXS,
+  chipcHw_GPIO_FUNCTION_SDIO0         =     chipcHw_REG_GPIO_MUX_SDIO0,
+  chipcHw_GPIO_FUNCTION_SDIO1         =     chipcHw_REG_GPIO_MUX_SDIO1,
+  chipcHw_GPIO_FUNCTION_PCM           =     chipcHw_REG_GPIO_MUX_PCM,
+  chipcHw_GPIO_FUNCTION_I2S           =     chipcHw_REG_GPIO_MUX_I2S,
+  chipcHw_GPIO_FUNCTION_ETM           =     chipcHw_REG_GPIO_MUX_ETM,
+  chipcHw_GPIO_FUNCTION_DEBUG         =     chipcHw_REG_GPIO_MUX_DEBUG,
+  chipcHw_GPIO_FUNCTION_MISC          =     chipcHw_REG_GPIO_MUX_MISC,
+  chipcHw_GPIO_FUNCTION_GPIO          =     chipcHw_REG_GPIO_MUX_GPIO
+}chipcHw_GPIO_FUNCTION_e;
+
+/* PIN Output slew rate */
+typedef enum
+{
+  chipcHw_PIN_SLEW_RATE_HIGH          =    chipcHw_REG_SLEW_RATE_HIGH,
+  chipcHw_PIN_SLEW_RATE_NORMAL        =    chipcHw_REG_SLEW_RATE_NORMAL
+}chipcHw_PIN_SLEW_RATE_e;
+
+/* PIN Current drive strength */
+typedef enum
+{
+  chipcHw_PIN_CURRENT_STRENGTH_2mA    =    chipcHw_REG_CURRENT_STRENGTH_2mA,
+  chipcHw_PIN_CURRENT_STRENGTH_4mA    =    chipcHw_REG_CURRENT_STRENGTH_4mA,
+  chipcHw_PIN_CURRENT_STRENGTH_6mA    =    chipcHw_REG_CURRENT_STRENGTH_6mA,
+  chipcHw_PIN_CURRENT_STRENGTH_8mA    =    chipcHw_REG_CURRENT_STRENGTH_8mA,
+  chipcHw_PIN_CURRENT_STRENGTH_10mA   =    chipcHw_REG_CURRENT_STRENGTH_10mA,
+  chipcHw_PIN_CURRENT_STRENGTH_12mA   =    chipcHw_REG_CURRENT_STRENGTH_12mA
+}chipcHw_PIN_CURRENT_STRENGTH_e;
+
+
+/* PIN Pull up register settings */
+typedef enum
+{
+  chipcHw_PIN_PULL_NONE               =    chipcHw_REG_PULL_NONE,
+  chipcHw_PIN_PULL_UP                 =    chipcHw_REG_PULL_UP,
+  chipcHw_PIN_PULL_DOWN               =    chipcHw_REG_PULL_DOWN
+}chipcHw_PIN_PULL_e;
+
+
+/* PIN input type settings */
+typedef enum
+{
+  chipcHw_PIN_INPUTTYPE_CMOS          =    chipcHw_REG_INPUTTYPE_CMOS,
+  chipcHw_PIN_INPUTTYPE_ST            =    chipcHw_REG_INPUTTYPE_ST
+}chipcHw_PIN_INPUTTYPE_e;
+
+/* Allow/Disalow the support of spread spectrum  */
+typedef enum
+{
+  chipcHw_SPREAD_SPECTRUM_DISALLOW,       /* Spread spectrum support is not allowed */
+  chipcHw_SPREAD_SPECTRUM_ALLOW           /* Spread spectrum support is allowed */
+}chipcHw_SPREAD_SPECTRUM_e;
+
+typedef struct
+{
+   chipcHw_SPREAD_SPECTRUM_e ssSupport;   /* Allow/Disalow to support spread spectrum.
+                                             If supported, call chipcHw_enableSpreadSpectrum ()
+                                             to activate the spread spectrum with desired spread. */
+   uint32_t pllVcoFreqHz;                 /* PLL VCO frequency in Hz */
+   uint32_t pll2VcoFreqHz;                /* PLL2 VCO frequency in Hz */
+   uint32_t busClockFreqHz;               /* Bus clock frequency in Hz */
+   uint32_t armBusRatio;                  /* ARM clock : Bus clock */
+   uint32_t vpmBusRatio;                  /* VPM clock : Bus clock */
+   uint32_t ddrBusRatio;                  /* DDR clock : Bus clock */
+}chipcHw_INIT_PARAM_t;
+
+/* CHIP revision number */
+typedef enum
+{
+  chipcHw_REV_NUMBER_A0                 = chipcHw_REG_REV_A0,
+  chipcHw_REV_NUMBER_B0                 = chipcHw_REG_REV_B0
+}chipcHw_REV_NUMBER_e;
+
+
+typedef enum
+{
+  chipcHw_VPM_HW_PHASE_INTR_DISABLE     = chipcHw_REG_VPM_INTR_DISABLE,
+  chipcHw_VPM_HW_PHASE_INTR_FAST        = chipcHw_REG_VPM_INTR_FAST,
+  chipcHw_VPM_HW_PHASE_INTR_MEDIUM      = chipcHw_REG_VPM_INTR_MEDIUM,
+  chipcHw_VPM_HW_PHASE_INTR_SLOW        = chipcHw_REG_VPM_INTR_SLOW
+}chipcHw_VPM_HW_PHASE_INTR_e;
+
+
+typedef enum
+{
+  chipcHw_DDR_HW_PHASE_MARGIN_STRICT,   /*  Strict margin for DDR phase align condition */
+  chipcHw_DDR_HW_PHASE_MARGIN_MEDIUM,   /*  Medium margin for DDR phase align condition */
+  chipcHw_DDR_HW_PHASE_MARGIN_WIDE      /*  Wider margin for DDR phase align condition */
+}chipcHw_DDR_HW_PHASE_MARGIN_e;
+
+typedef enum
+{
+  chipcHw_VPM_HW_PHASE_MARGIN_STRICT,   /*  Strict margin for VPM phase align condition */
+  chipcHw_VPM_HW_PHASE_MARGIN_MEDIUM,   /*  Medium margin for VPM phase align condition */
+  chipcHw_VPM_HW_PHASE_MARGIN_WIDE      /*  Wider margin for VPM phase align condition */
+}chipcHw_VPM_HW_PHASE_MARGIN_e;
+
+
+#define chipcHw_XTAL_FREQ_Hz                    25000000      /* Reference clock frequency in Hz */
+
+/* Programable pin defines */
+#define chipcHw_PIN_GPIO(n)                     ((((n) >= 0) && ((n) < (chipcHw_GPIO_COUNT))) ? (n) : 0xFFFFFFFF)
+                                                                             /* GPIO pin 0 - 60 */
+#define chipcHw_PIN_UARTTXD                     (chipcHw_GPIO_COUNT + 0)     /* UART Transmit */
+#define chipcHw_PIN_NVI_A                       (chipcHw_GPIO_COUNT + 1)     /* NVI Interface */
+#define chipcHw_PIN_NVI_D                       (chipcHw_GPIO_COUNT + 2)     /* NVI Interface */
+#define chipcHw_PIN_NVI_OEB                     (chipcHw_GPIO_COUNT + 3)     /* NVI Interface */
+#define chipcHw_PIN_NVI_WEB                     (chipcHw_GPIO_COUNT + 4)     /* NVI Interface */
+#define chipcHw_PIN_NVI_CS                      (chipcHw_GPIO_COUNT + 5)     /* NVI Interface */
+#define chipcHw_PIN_NVI_NAND_CSB                (chipcHw_GPIO_COUNT + 6)     /* NVI Interface */
+#define chipcHw_PIN_NVI_FLASHWP                 (chipcHw_GPIO_COUNT + 7)     /* NVI Interface */
+#define chipcHw_PIN_NVI_NAND_RDYB               (chipcHw_GPIO_COUNT + 8)     /* NVI Interface */
+#define chipcHw_PIN_CL_DATA_0_17                (chipcHw_GPIO_COUNT + 9)     /* LCD Data 0 - 17 */
+#define chipcHw_PIN_CL_DATA_18_20               (chipcHw_GPIO_COUNT + 10)    /* LCD Data 18 - 20 */
+#define chipcHw_PIN_CL_DATA_21_23               (chipcHw_GPIO_COUNT + 11)    /* LCD Data 21 - 23 */
+#define chipcHw_PIN_CL_POWER                    (chipcHw_GPIO_COUNT + 12)    /* LCD Power */
+#define chipcHw_PIN_CL_ACK                      (chipcHw_GPIO_COUNT + 13)    /* LCD Ack */
+#define chipcHw_PIN_CL_FP                       (chipcHw_GPIO_COUNT + 14)    /* LCD FP */
+#define chipcHw_PIN_CL_LP                       (chipcHw_GPIO_COUNT + 15)    /* LCD LP */
+#define chipcHw_PIN_UARTRXD                     (chipcHw_GPIO_COUNT + 16)    /* UART Receive */
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the clock module
+*
+*/
+/****************************************************************************/
+void chipcHw_Init
+(
+  chipcHw_INIT_PARAM_t *initParam    ///<  [ IN ] Misc chip initialization parameter
+)  __attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief  Enables the PLL1
+*
+*  This function enables the PLL1
+*
+*/
+/****************************************************************************/
+void chipcHw_pll1Enable
+(
+   uint32_t vcoFreqHz,                 ///<  [ IN ] VCO frequency in Hz
+   chipcHw_SPREAD_SPECTRUM_e ssSupport ///<  [ IN ] SS status
+)__attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief  Enables the PLL2
+*
+*  This function enables the PLL2
+*
+*/
+/****************************************************************************/
+void chipcHw_pll2Enable
+(
+   uint32_t vcoFreqHz              ///<  [ IN ] VCO frequency in Hz
+)__attribute__ ((section(".aramtext")));
+
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL1
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll1Disable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL2
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll2Disable ( void );
+
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
+chipcHw_freq  chipcHw_getClockFrequency
+(
+    chipcHw_CLOCK_e clock         ///<  [ IN ] Configurable clock
+)  __attribute__ ((section(".aramtext")));
+
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
+chipcHw_freq  chipcHw_setClockFrequency
+(
+   chipcHw_CLOCK_e clock,          ///<  [ IN ] Configurable clock
+   uint32_t freq                   ///<  [ IN ] Clock frequency in Hz
+)  __attribute__ ((section(".aramtext")));
+
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
+int chipcHw_vpmPhaseAlign ( void ) ;
+
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
+static inline void  chipcHw_setClockEnable
+(
+   chipcHw_CLOCK_e clock         ///<  [ IN ] Configurable clock
+);
+
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
+static inline void  chipcHw_setClockDisable
+(
+   chipcHw_CLOCK_e clock        ///<  [ IN ] Configurable clock
+);
+
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
+static inline void  chipcHw_bypassClockEnable
+(
+   chipcHw_CLOCK_e clock         ///<  [ IN ] Configurable clock
+);
+
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
+static inline void  chipcHw_bypassClockDisable
+(
+   chipcHw_CLOCK_e clock        ///<  [ IN ] Configurable clock
+);
+
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
+static inline uint32_t chipcHw_getChipId ( void );
+
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
+static inline uint32_t chipcHw_getChipProductId ( void );
+
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
+static inline chipcHw_REV_NUMBER_e chipcHw_getChipRevisionNumber ( void );
+
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
+static inline void  chipcHw_busInterfaceClockEnable
+(
+   uint32_t mask              ///<  [ IN ] Bit map of type  chipcHw_REG_BUS_CLOCK_XXXXX
+);
+
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
+static inline void  chipcHw_busInterfaceClockDisable
+(
+   uint32_t mask              ///<  [ IN ] Bit map of type  chipcHw_REG_BUS_CLOCK_XXXXX
+);
+
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
+static inline void  chipcHw_audioChannelEnable
+(
+   uint32_t mask              ///<  [ IN ] Bit map of type  chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+);
+
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
+static inline void  chipcHw_audioChannelDisable
+(
+   uint32_t mask              ///<  [ IN ] Bit map of type  chipcHw_REG_AUDIO_CHANNEL_XXXXXX
+);
+
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
+static inline void  chipcHw_softReset
+(
+   uint64_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX
+);
+
+static inline void  chipcHw_softResetDisable
+(
+   uint64_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX
+);
+
+static inline void  chipcHw_softResetEnable
+(
+   uint64_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_SOFT_RESET_XXXXXX
+);
+
+
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
+static inline void  chipcHw_miscControl
+(
+   uint32_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX
+);
+
+static inline void  chipcHw_miscControlDisable
+(
+   uint32_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX
+);
+
+static inline void  chipcHw_miscControlEnable
+(
+   uint32_t mask             ///<  [ IN ] Bit map of type chipcHw_REG_MISC_CTRL_XXXXXX
+);
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
+static inline void chipcHw_setOTPOption
+(
+   uint64_t mask            ///<  [ IN ] Bit map of type chipcHw_REG_OTP_XXXXXX
+);
+
+
+/****************************************************************************/
+/**
+*  @brief    Get sticky bits
+*
+*  @return   Sticky bit options of type chipcHw_REG_STICKY_XXXXXX
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getStickyBits ( void );
+
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
+static inline void chipcHw_setStickyBits
+(
+   uint32_t mask            ///<  [ IN ] Bit map of type chipcHw_REG_STICKY_XXXXXX
+);
+
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
+static inline void chipcHw_clearStickyBits
+(
+   uint32_t mask            ///<  [ IN ] Bit map of type chipcHw_REG_STICKY_XXXXXX
+);
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
+static inline uint32_t chipcHw_getSoftStraps ( void );
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
+static inline void chipcHw_setSoftStraps ( uint32_t strapOptions );
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
+static inline uint32_t chipcHw_getPinStraps ( void );
+
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
+static inline uint32_t chipcHw_getValidStraps ( void );
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
+static inline void chipcHw_initValidStraps ( void );
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
+static inline uint32_t chipcHw_getBusInterfaceClockStatus ( void  );
+
+
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
+static inline chipcHw_BOOT_DEVICE_e chipcHw_getBootDevice ( void );
+
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
+static inline chipcHw_BOOT_MODE_e chipcHw_getBootMode ( void );
+
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
+static inline chipcHw_NAND_PAGESIZE_e chipcHw_getNandPageSize ( void );
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
+static inline int chipcHw_getNandExtraCycle ( void );
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
+static inline void chipcHw_activatePifInterface ( void );
+
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
+static inline void chipcHw_activateLcdInterface ( void );
+
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
+static inline void chipcHw_deactivatePifLcdInterface ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Get to know the configuration of GPIO pin
+*
+*/
+/****************************************************************************/
+static inline chipcHw_GPIO_FUNCTION_e chipcHw_getGpioPinFunction
+(
+   int pin                          ///< GPIO Pin number
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Configure GPIO pin function
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setGpioPinFunction
+(
+   int pin,                          ///< GPIO Pin number
+   chipcHw_GPIO_FUNCTION_e func      ///< Configuration function
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin slew rate
+*
+*  This function sets the slew of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinSlewRate
+(
+   uint32_t pin,                      ///< Pin of type chipcHw_PIN_XXXXX
+   chipcHw_PIN_SLEW_RATE_e slewRate   ///< Pin slew rate
+);
+
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
+static inline void chipcHw_setPinOutputCurrent
+(
+   uint32_t pin,                             ///< Pin of type chipcHw_PIN_XXXXX
+   chipcHw_PIN_CURRENT_STRENGTH_e curr       ///< Pin current rating
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin pullup register
+*
+*  This function sets pullup register of individual  pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinPullup
+(
+   uint32_t                     pin,       ///< Pin of type chipcHw_PIN_XXXXX
+   chipcHw_PIN_PULL_e           pullup     ///< Pullup register settings
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin input type
+*
+*  This function sets input type of individual Pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinInputType
+(
+   uint32_t pin,                        ///< Pin of type chipcHw_PIN_XXXXX
+   chipcHw_PIN_INPUTTYPE_e inputType    ///< Pin input type
+);
+
+/****************************************************************************/
+/**
+*  @brief   Retrieves a string representation of the mux setting for a pin.
+*
+*  @return  Pointer to a character string.
+*/
+/****************************************************************************/
+
+const char *chipcHw_getGpioPinFunctionStr( int pin );
+
+
+/****************************************************************************/
+/**  @brief issue warmReset
+ */
+/****************************************************************************/
+void chipcHw_reset( uint32_t mask );
+
+/****************************************************************************/
+/**  @brief clock reconfigure
+ */
+/****************************************************************************/
+void chipcHw_clockReconfig( uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio, uint32_t ddrRatio );
+
+/****************************************************************************/
+/**
+*  @brief   Enable Spread Spectrum
+*
+*  @note chipcHw_Init() must be called earlier
+*/
+/****************************************************************************/
+static inline void chipcHw_enableSpreadSpectrum ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable Spread Spectrum
+*
+*/
+/****************************************************************************/
+static inline void  chipcHw_disableSpreadSpectrum ( void );
+
+
+/****************************************************************************/
+/**  @brief Checks if software strap is enabled
+ *
+ *   @return 1 : When enable
+ *           0 : When disable
+ */
+/****************************************************************************/
+static inline int chipcHw_isSoftwareStrapsEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief Enable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief Disable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsDisable ( void );
+
+
+/****************************************************************************/
+/**  @brief PLL test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief PLL2 test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief PLL test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestDisable ( void );
+
+
+/****************************************************************************/
+/**  @brief PLL2 test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestDisable ( void );
+
+
+/****************************************************************************/
+/**  @brief Get PLL test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPllTestEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief Get PLL2 test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPll2TestEnable ( void );
+
+
+/****************************************************************************/
+/**  @brief PLL test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestSelect ( uint32_t val );
+
+
+/****************************************************************************/
+/**  @brief PLL2 test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestSelect ( uint32_t val );
+
+
+/****************************************************************************/
+/**  @brief Get PLL test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPllTestSelected ( void );
+
+
+/****************************************************************************/
+/**  @brief Get PLL2 test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPll2TestSelected ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Enables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM SW phase alignment interrupt mode
+*
+*  This function sets VPM phase alignment interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmPhaseAlignInterruptMode ( chipcHw_VPM_HW_PHASE_INTR_e mode );
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Set DDR phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setDdrHwPhaseAlignMargin
+(
+   chipcHw_DDR_HW_PHASE_MARGIN_e margin   ///< Margin alinging DDR  phase
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setVpmHwPhaseAlignMargin
+(
+   chipcHw_VPM_HW_PHASE_MARGIN_e margin ///< Margin alinging VPM  phase
+);
+
+/****************************************************************************/
+/**
+*  @brief   Checks DDR phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isDdrHwPhaseAligned ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Checks VPM phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isVpmHwPhaseAligned ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrHwPhaseAlignStatus ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmHwPhaseAlignStatus ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrPhaseControl ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmPhaseControl ( void );
+
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a DDR phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeout
+(
+   uint32_t busCycle              ///< Timeout in bus cycle
+);
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a VPM phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeout
+(
+   uint32_t busCycle             ///< Timeout in bus cycle
+);
+
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptEnable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptDisable ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Clear DDR phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptClear ( void );
+
+
+/****************************************************************************/
+/**
+*  @brief   Clear VPM phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptClear ( void );
+
+/* ---- Private Constants and Types -------------------------------------- */
+
+#endif /* CHIPC_DEF_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
new file mode 100644
index 0000000..3a182ca
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
@@ -0,0 +1,1702 @@
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
+typedef enum
+{
+  chipcHw_OPTYPE_BYPASS,     /* Bypass operation */
+  chipcHw_OPTYPE_OUTPUT      /* Output operation */
+}chipcHw_OPTYPE_e;
+
+/* ---- Public Constants and Types ---------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------- */
+/* ---- Public Function Prototypes ---------------------------------------- */
+/* ---- Private Function Prototypes --------------------------------------- */
+static inline void  chipcHw_setClock ( chipcHw_CLOCK_e clock, chipcHw_OPTYPE_e type, int mode );
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
+static inline uint32_t  chipcHw_getChipId ( void )
+{
+  return pChipcHw->ChipId;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable Spread Spectrum
+*
+*  @note chipcHw_Init() must be called earlier
+*/
+/****************************************************************************/
+static inline void  chipcHw_enableSpreadSpectrum ( void )
+{
+   if ( ( pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK ) != chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER )
+   {
+      ddrcReg_PHY_ADDR_CTL_REGP->ssCfg = ( 0xFFFF << ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_SHIFT ) |
+                                        ( ddrcReg_PHY_ADDR_SS_CFG_MIN_CYCLE_PER_TICK << ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_SHIFT );
+      ddrcReg_PHY_ADDR_CTL_REGP->ssCtl |= ddrcReg_PHY_ADDR_SS_CTRL_ENABLE;
+   }
+}
+
+
+
+
+/****************************************************************************/
+/**
+*  @brief   Disable Spread Spectrum
+*
+*/
+/****************************************************************************/
+static inline void  chipcHw_disableSpreadSpectrum ( void )
+{
+   ddrcReg_PHY_ADDR_CTL_REGP->ssCtl &= ~ddrcReg_PHY_ADDR_SS_CTRL_ENABLE;
+}
+
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
+static inline uint32_t chipcHw_getChipProductId ( void )
+{
+   return ( ( pChipcHw->ChipId & chipcHw_REG_CHIPID_BASE_MASK ) >> chipcHw_REG_CHIPID_BASE_SHIFT );
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
+static inline chipcHw_REV_NUMBER_e chipcHw_getChipRevisionNumber ( void )
+{
+   return ( pChipcHw->ChipId & chipcHw_REG_CHIPID_REV_MASK );
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
+static inline void  chipcHw_busInterfaceClockEnable ( uint32_t mask )
+{
+   reg32_modify_or( &pChipcHw->BusIntfClock, mask );
+}
+
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
+static inline void  chipcHw_busInterfaceClockDisable ( uint32_t mask )
+{
+   reg32_modify_and( &pChipcHw->BusIntfClock, ~ mask );
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
+static inline uint32_t chipcHw_getBusInterfaceClockStatus (  void )
+{
+   return pChipcHw->BusIntfClock;
+}
+
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
+static inline void  chipcHw_audioChannelEnable ( uint32_t mask )
+{
+   reg32_modify_or( &pChipcHw->AudioEnable, mask );
+}
+
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
+static inline void  chipcHw_audioChannelDisable ( uint32_t mask )
+{
+   reg32_modify_and( &pChipcHw->AudioEnable, ~ mask );
+}
+
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
+static inline void  chipcHw_softReset  ( uint64_t mask )
+{
+   chipcHw_softResetEnable( mask );
+   chipcHw_softResetDisable( mask );
+}
+
+static inline void  chipcHw_softResetDisable  ( uint64_t mask )
+{
+   uint32_t ctrl1 = (uint32_t) mask;
+   uint32_t ctrl2 = (uint32_t) ( mask  >> 32 );
+
+   /* Deassert module soft reset */
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->SoftReset1 ^= ctrl1;
+   pChipcHw->SoftReset2 ^= ( ctrl2 & (~ chipcHw_REG_SOFT_RESET_UNHOLD_MASK) );
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void  chipcHw_softResetEnable  ( uint64_t mask )
+{
+   uint32_t ctrl1 = (uint32_t) mask;
+   uint32_t ctrl2 = (uint32_t) ( mask  >> 32 );
+   uint32_t unhold = 0;
+
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->SoftReset1 |= ctrl1;
+   /* Mask out unhold request bits */
+   pChipcHw->SoftReset2 |= ( ctrl2 & (~ chipcHw_REG_SOFT_RESET_UNHOLD_MASK)) ;
+
+   /* Process unhold requests */
+   if ( ctrl2 & chipcHw_REG_SOFT_RESET_VPM_GLOBAL_UNHOLD )
+   {
+      unhold = chipcHw_REG_SOFT_RESET_VPM_GLOBAL_HOLD;
+   }
+
+   if ( ctrl2 & chipcHw_REG_SOFT_RESET_VPM_UNHOLD )
+   {
+      unhold |= chipcHw_REG_SOFT_RESET_VPM_HOLD;
+   }
+
+   if ( ctrl2 & chipcHw_REG_SOFT_RESET_ARM_UNHOLD )
+   {
+      unhold |= chipcHw_REG_SOFT_RESET_ARM_HOLD;
+   }
+
+   if ( unhold )
+   {
+      /* Make sure unhold request is effective */
+      pChipcHw->SoftReset1 &= ~ unhold;
+   }
+   REG_LOCAL_IRQ_RESTORE;
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
+static inline void  chipcHw_miscControl ( uint32_t mask )
+{
+   reg32_write( &pChipcHw->MiscCtrl, mask );
+}
+
+static inline void  chipcHw_miscControlDisable ( uint32_t mask )
+{
+   reg32_modify_and( &pChipcHw->MiscCtrl, ~mask );
+}
+
+static inline void  chipcHw_miscControlEnable ( uint32_t mask )
+{
+   reg32_modify_or( &pChipcHw->MiscCtrl, mask );
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
+static inline void chipcHw_setOTPOption ( uint64_t mask )
+{
+   uint32_t ctrl1 = (uint32_t) mask;
+   uint32_t ctrl2 = (uint32_t) ( mask  >> 32 );
+
+   reg32_modify_or( &pChipcHw->SoftOTP1, ctrl1 );
+   reg32_modify_or( &pChipcHw->SoftOTP2, ctrl2 );
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
+static inline uint32_t chipcHw_getStickyBits ( void )
+{
+   return pChipcHw->Sticky;
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
+static inline void chipcHw_setStickyBits ( uint32_t mask )
+{
+   uint32_t bits = 0;
+
+   REG_LOCAL_IRQ_SAVE;
+   if ( mask & chipcHw_REG_STICKY_POR_BROM )
+   {
+      bits |= chipcHw_REG_STICKY_POR_BROM;
+   }
+   else
+   {
+      uint32_t sticky;
+      sticky = pChipcHw->Sticky;
+
+      if ( ( mask & chipcHw_REG_STICKY_BOOT_DONE ) && ( sticky & chipcHw_REG_STICKY_BOOT_DONE ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_BOOT_DONE;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_1 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_1 ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_1;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_2 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_2 ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_2;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_3 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_3 ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_3;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_4 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_4 ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_4;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_5 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_5 ) == 0 )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_5;
+      }
+   }
+   pChipcHw->Sticky = bits;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
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
+static inline void chipcHw_clearStickyBits ( uint32_t mask )
+{
+   uint32_t bits = 0;
+
+   REG_LOCAL_IRQ_SAVE;
+   if ( mask & (chipcHw_REG_STICKY_BOOT_DONE | chipcHw_REG_STICKY_GENERAL_1 |
+                chipcHw_REG_STICKY_GENERAL_2 | chipcHw_REG_STICKY_GENERAL_3 |
+                chipcHw_REG_STICKY_GENERAL_4 | chipcHw_REG_STICKY_GENERAL_5) )
+   {
+      uint32_t sticky = pChipcHw->Sticky;
+
+      if ( ( mask & chipcHw_REG_STICKY_BOOT_DONE ) && ( sticky & chipcHw_REG_STICKY_BOOT_DONE ) )
+      {
+         bits = chipcHw_REG_STICKY_BOOT_DONE;
+         mask &= ~chipcHw_REG_STICKY_BOOT_DONE;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_1 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_1 ) )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_1;
+         mask &= ~chipcHw_REG_STICKY_GENERAL_1;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_2 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_2 ) )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_2;
+         mask &= ~chipcHw_REG_STICKY_GENERAL_2;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_3 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_3 ) )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_3;
+         mask &= ~chipcHw_REG_STICKY_GENERAL_3;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_4 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_4 ) )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_4;
+         mask &= ~chipcHw_REG_STICKY_GENERAL_4;
+      }
+      if ( ( mask & chipcHw_REG_STICKY_GENERAL_5 ) && ( sticky & chipcHw_REG_STICKY_GENERAL_5 ) )
+      {
+         bits |= chipcHw_REG_STICKY_GENERAL_5;
+         mask &= ~chipcHw_REG_STICKY_GENERAL_5;
+      }
+   }
+   pChipcHw->Sticky = bits | mask;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
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
+static inline uint32_t chipcHw_getSoftStraps ( void )
+{
+  return ( pChipcHw->SoftStraps );
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
+static inline void chipcHw_setSoftStraps ( uint32_t strapOptions )
+{
+   reg32_write( &pChipcHw->SoftStraps, strapOptions );
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
+static inline uint32_t chipcHw_getPinStraps ( void )
+{
+   return ( pChipcHw->PinStraps );
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
+static inline uint32_t chipcHw_getValidStraps ( void )
+{
+   uint32_t softStraps;
+
+   /*
+   ** Always return the SoftStraps - bootROM calls chipcHw_initValidStraps
+   ** which copies HW straps to soft straps if there is no override
+   */
+   softStraps = chipcHw_getSoftStraps();
+
+   return ( softStraps );
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
+static inline void chipcHw_initValidStraps ( void )
+{
+   uint32_t softStraps;
+
+   REG_LOCAL_IRQ_SAVE;
+   softStraps = chipcHw_getSoftStraps();
+
+   if ( (softStraps & chipcHw_STRAPS_SOFT_OVERRIDE) == 0 )
+   {
+      /* Copy HW straps to software straps */
+      chipcHw_setSoftStraps( chipcHw_getPinStraps() );
+   }
+   REG_LOCAL_IRQ_RESTORE;
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
+static inline chipcHw_BOOT_DEVICE_e chipcHw_getBootDevice ( void )
+{
+   return ( chipcHw_getValidStraps() & chipcHw_STRAPS_BOOT_DEVICE_MASK );
+}
+
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
+static inline chipcHw_BOOT_MODE_e chipcHw_getBootMode ( void )
+{
+   return ( chipcHw_getValidStraps() & chipcHw_STRAPS_BOOT_MODE_MASK );
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
+static inline chipcHw_NAND_PAGESIZE_e chipcHw_getNandPageSize ( void )
+{
+   return ( chipcHw_getValidStraps() & chipcHw_STRAPS_NAND_PAGESIZE_MASK );
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
+static inline int chipcHw_getNandExtraCycle ( void )
+{
+   if ( chipcHw_getValidStraps() & chipcHw_STRAPS_NAND_EXTRA_CYCLE )
+   {
+      return( 1 );
+   }
+   else
+   {
+      return( 0 );
+   }
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
+static inline void chipcHw_activatePifInterface ( void )
+{
+   reg32_write( &pChipcHw->LcdPifMode, chipcHw_REG_PIF_PIN_ENABLE );
+}
+
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
+static inline void chipcHw_activateLcdInterface ( void )
+{
+   reg32_write( &pChipcHw->LcdPifMode, chipcHw_REG_LCD_PIN_ENABLE );
+}
+
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
+static inline void chipcHw_deactivatePifLcdInterface ( void )
+{
+   reg32_write( &pChipcHw->LcdPifMode, 0 );
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
+static inline void chipcHw_selectGE2 ( void )
+{
+   reg32_modify_and( &pChipcHw->MiscCtrl, ~chipcHw_REG_MISC_CTRL_GE_SEL );
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
+static inline void chipcHw_selectGE3 ( void )
+{
+   reg32_modify_or( &pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_GE_SEL );
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get to know the configuration of GPIO pin
+*
+*/
+/****************************************************************************/
+static inline chipcHw_GPIO_FUNCTION_e chipcHw_getGpioPinFunction ( int pin )
+{
+   return ( *((uint32_t*)chipcHw_REG_GPIO_MUX(pin)) & ( chipcHw_REG_GPIO_MUX_MASK << chipcHw_REG_GPIO_MUX_POSITION(pin) )) >> chipcHw_REG_GPIO_MUX_POSITION(pin);
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Configure GPIO pin function
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setGpioPinFunction ( int pin, chipcHw_GPIO_FUNCTION_e func )
+{
+  REG_LOCAL_IRQ_SAVE;
+  *((uint32_t*)chipcHw_REG_GPIO_MUX(pin)) &= ~ (chipcHw_REG_GPIO_MUX_MASK << chipcHw_REG_GPIO_MUX_POSITION(pin));
+  *((uint32_t*)chipcHw_REG_GPIO_MUX(pin)) |=  func << chipcHw_REG_GPIO_MUX_POSITION(pin);
+  REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin slew rate
+*
+*  This function sets the slew of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinSlewRate ( uint32_t pin, chipcHw_PIN_SLEW_RATE_e slewRate )
+{
+  REG_LOCAL_IRQ_SAVE;
+  *((uint32_t*)chipcHw_REG_SLEW_RATE(pin)) &= ~ ( chipcHw_REG_SLEW_RATE_MASK << chipcHw_REG_SLEW_RATE_POSITION(pin) );
+  *((uint32_t*)chipcHw_REG_SLEW_RATE(pin)) |=  (uint32_t)slewRate << chipcHw_REG_SLEW_RATE_POSITION(pin);
+  REG_LOCAL_IRQ_RESTORE;
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
+static inline void chipcHw_setPinOutputCurrent ( uint32_t pin, chipcHw_PIN_CURRENT_STRENGTH_e curr )
+{
+  REG_LOCAL_IRQ_SAVE;
+  *((uint32_t*)chipcHw_REG_CURRENT(pin)) &= ~ ( chipcHw_REG_CURRENT_MASK << chipcHw_REG_CURRENT_POSITION(pin) );
+  *((uint32_t*)chipcHw_REG_CURRENT(pin)) |=  (uint32_t)curr << chipcHw_REG_CURRENT_POSITION(pin);
+  REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set Pin pullup register
+*
+*  This function sets pullup register of individual pin
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setPinPullup ( uint32_t pin, chipcHw_PIN_PULL_e pullup )
+{
+  REG_LOCAL_IRQ_SAVE;
+  *((uint32_t*)chipcHw_REG_PULLUP(pin)) &= ~ ( chipcHw_REG_PULLUP_MASK << chipcHw_REG_PULLUP_POSITION(pin) );
+  *((uint32_t*)chipcHw_REG_PULLUP(pin)) |=  (uint32_t)pullup << chipcHw_REG_PULLUP_POSITION(pin);
+  REG_LOCAL_IRQ_RESTORE;
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
+static inline void chipcHw_setPinInputType ( uint32_t pin, chipcHw_PIN_INPUTTYPE_e inputType )
+{
+  REG_LOCAL_IRQ_SAVE;
+  *((uint32_t*)chipcHw_REG_INPUTTYPE(pin)) &= ~ ( chipcHw_REG_INPUTTYPE_MASK << chipcHw_REG_INPUTTYPE_POSITION(pin));
+  *((uint32_t*)chipcHw_REG_INPUTTYPE(pin)) |=  (uint32_t)inputType << chipcHw_REG_INPUTTYPE_POSITION(pin);
+  REG_LOCAL_IRQ_RESTORE;
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
+static inline void chipcHw_powerUpUsbPhy ( void )
+{
+   reg32_modify_and( &pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_USB_POWERON );
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
+static inline void chipcHw_powerDownUsbPhy ( void )
+{
+   reg32_modify_or( &pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_USB_POWEROFF );
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
+static inline void chipcHw_setUsbHost ( void )
+{
+   reg32_modify_or( &pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_USB_MODE_HOST );
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
+static inline void chipcHw_setUsbDevice ( void )
+{
+   reg32_modify_and( &pChipcHw->MiscCtrl, chipcHw_REG_MISC_CTRL_USB_MODE_DEVICE );
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
+static inline void  chipcHw_setClock ( chipcHw_CLOCK_e clock, chipcHw_OPTYPE_e type,  int mode )
+{
+   volatile uint32_t *pPLLReg = (uint32_t*)0x0;
+   volatile uint32_t *pClockCtrl = (uint32_t*)0x0;
+
+   switch ( clock )
+   {
+      case chipcHw_CLOCK_DDR:
+         pPLLReg = &pChipcHw->DDRClock;
+         break;
+      case chipcHw_CLOCK_ARM:
+         pPLLReg = &pChipcHw->ARMClock;
+         break;
+      case chipcHw_CLOCK_ESW:
+         pPLLReg = &pChipcHw->ESWClock;
+         break;
+      case chipcHw_CLOCK_VPM:
+         pPLLReg = &pChipcHw->VPMClock;
+         break;
+      case chipcHw_CLOCK_ESW125:
+         pPLLReg = &pChipcHw->ESW125Clock;
+         break;
+      case chipcHw_CLOCK_UART:
+         pPLLReg = &pChipcHw->UARTClock;
+         break;
+      case chipcHw_CLOCK_SDIO0:
+         pPLLReg = &pChipcHw->SDIO0Clock;
+         break;
+      case chipcHw_CLOCK_SDIO1:
+         pPLLReg = &pChipcHw->SDIO1Clock;
+         break;
+      case chipcHw_CLOCK_SPI:
+         pPLLReg = &pChipcHw->SPIClock;
+         break;
+      case chipcHw_CLOCK_ETM:
+         pPLLReg = &pChipcHw->ETMClock;
+         break;
+      case chipcHw_CLOCK_USB:
+         pPLLReg = &pChipcHw->USBClock;
+         if ( type == chipcHw_OPTYPE_OUTPUT )
+         {
+            if ( mode )
+            {
+               reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+            else
+            {
+               reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+         }
+         break;
+      case chipcHw_CLOCK_LCD:
+         pPLLReg = &pChipcHw->LCDClock;
+         if ( type == chipcHw_OPTYPE_OUTPUT )
+         {
+            if ( mode )
+            {
+               reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+            else
+            {
+               reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+         }
+         break;
+      case chipcHw_CLOCK_APM:
+         pPLLReg = &pChipcHw->APMClock;
+         if ( type == chipcHw_OPTYPE_OUTPUT )
+         {
+            if ( mode )
+            {
+               reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+            else
+            {
+               reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_POWER_DOWN );
+            }
+         }
+         break;
+      case chipcHw_CLOCK_BUS:
+         pClockCtrl = &pChipcHw->ACLKClock;
+         break;
+      case chipcHw_CLOCK_OTP:
+         pClockCtrl = &pChipcHw->OTPClock;
+         break;
+      case chipcHw_CLOCK_I2C:
+         pClockCtrl = &pChipcHw->I2CClock;
+         break;
+      case chipcHw_CLOCK_I2S0:
+         pClockCtrl = &pChipcHw->I2S0Clock;
+         break;
+      case chipcHw_CLOCK_RTBUS:
+         pClockCtrl = &pChipcHw->RTBUSClock;
+         break;
+      case chipcHw_CLOCK_APM100:
+         pClockCtrl = &pChipcHw->APM100Clock;
+         break;
+      case chipcHw_CLOCK_TSC:
+         pClockCtrl = &pChipcHw->TSCClock;
+         break;
+      case chipcHw_CLOCK_LED:
+         pClockCtrl = &pChipcHw->LEDClock;
+         break;
+      case chipcHw_CLOCK_I2S1:
+         pClockCtrl = &pChipcHw->I2S1Clock;
+         break;
+   }
+
+   if ( pPLLReg )
+   {
+       switch ( type )
+       {
+       case chipcHw_OPTYPE_OUTPUT:
+          /* PLL clock output enable/disable */
+          if ( mode )
+          {
+             if ( clock == chipcHw_CLOCK_DDR )
+             {
+                /* DDR clock enable is inverted */
+                reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE );
+             }
+             else
+             {
+                reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE );
+             }
+          }
+          else
+          {
+             if ( clock == chipcHw_CLOCK_DDR )
+             {
+                /* DDR clock disable is inverted */
+                reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE );
+             }
+             else
+             {
+                reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE );
+             }
+          }
+          break;
+       case chipcHw_OPTYPE_BYPASS:
+          /* PLL clock bypass enable/disable */
+          if ( mode )
+          {
+             reg32_modify_or( pPLLReg, chipcHw_REG_PLL_CLOCK_BYPASS_SELECT );
+          }
+          else
+          {
+             reg32_modify_and( pPLLReg, ~ chipcHw_REG_PLL_CLOCK_BYPASS_SELECT );
+          }
+          break;
+       }
+   }
+   else if ( pClockCtrl )
+   {
+       switch ( type )
+       {
+       case chipcHw_OPTYPE_OUTPUT:
+          if ( mode )
+          {
+             reg32_modify_or( pClockCtrl, chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE );
+          }
+          else
+          {
+             reg32_modify_and( pClockCtrl, ~ chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE );
+          }
+          break;
+       case chipcHw_OPTYPE_BYPASS:
+          if ( mode )
+          {
+             reg32_modify_or( pClockCtrl, chipcHw_REG_DIV_CLOCK_BYPASS_SELECT );
+          }
+          else
+          {
+             reg32_modify_and( pClockCtrl, ~ chipcHw_REG_DIV_CLOCK_BYPASS_SELECT );
+          }
+          break;
+       }
+   }
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
+static inline void  chipcHw_setClockDisable ( chipcHw_CLOCK_e clock )
+{
+
+   /* Disable output of the clock */
+   chipcHw_setClock ( clock, chipcHw_OPTYPE_OUTPUT, 0 );
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
+static inline void  chipcHw_setClockEnable ( chipcHw_CLOCK_e clock )
+{
+
+   /* Enable output of the clock */
+   chipcHw_setClock ( clock, chipcHw_OPTYPE_OUTPUT, 1 );
+}
+
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
+static inline void  chipcHw_bypassClockEnable ( chipcHw_CLOCK_e clock )
+{
+   /* Enable bypass clock */
+   chipcHw_setClock ( clock, chipcHw_OPTYPE_BYPASS, 1 );
+}
+
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
+static inline void  chipcHw_bypassClockDisable ( chipcHw_CLOCK_e clock )
+{
+   /* Disable bypass clock */
+   chipcHw_setClock ( clock, chipcHw_OPTYPE_BYPASS, 0 );
+
+}
+
+
+
+/****************************************************************************/
+/**  @brief Checks if software strap is enabled
+ *
+ *   @return 1 : When enable
+             0 : When disable
+ */
+/****************************************************************************/
+static inline int chipcHw_isSoftwareStrapsEnable ( void )
+{
+  return ( pChipcHw->SoftStraps & 0x00000001 );
+}
+
+
+/****************************************************************************/
+/**  @brief Enable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsEnable ( void )
+{
+  reg32_modify_or ( &pChipcHw->SoftStraps, 0x00000001 );
+}
+
+
+/****************************************************************************/
+/**  @brief Disable software strap
+ */
+/****************************************************************************/
+static inline void chipcHw_softwareStrapsDisable ( void )
+{
+  reg32_modify_and ( &pChipcHw->SoftStraps, (~0x00000001) );
+}
+
+
+/****************************************************************************/
+/**  @brief PLL test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestEnable ( void )
+{
+  reg32_modify_or ( &pChipcHw->PLLConfig, chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+/****************************************************************************/
+/**  @brief PLL2 test enable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestEnable ( void )
+{
+   reg32_modify_or ( &pChipcHw->PLLConfig2, chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+/****************************************************************************/
+/**  @brief PLL test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestDisable ( void )
+{
+  reg32_modify_and ( &pChipcHw->PLLConfig, ~chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+
+/****************************************************************************/
+/**  @brief PLL2 test disable
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestDisable ( void )
+{
+  reg32_modify_and ( &pChipcHw->PLLConfig2, ~chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+/****************************************************************************/
+/**  @brief Get PLL test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPllTestEnable ( void )
+{
+  return ( pChipcHw->PLLConfig & chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+/****************************************************************************/
+/**  @brief Get PLL2 test status
+ */
+/****************************************************************************/
+static inline int chipcHw_isPll2TestEnable ( void )
+{
+  return ( pChipcHw->PLLConfig2 & chipcHw_REG_PLL_CONFIG_TEST_ENABLE );
+}
+
+
+
+/****************************************************************************/
+/**  @brief PLL test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pllTestSelect ( uint32_t val )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->PLLConfig &= ~chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK;
+   pChipcHw->PLLConfig |= (val) << chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**  @brief PLL2 test select
+ */
+/****************************************************************************/
+static inline void chipcHw_pll2TestSelect ( uint32_t val )
+{
+
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->PLLConfig2 &= ~chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK;
+   pChipcHw->PLLConfig2 |= (val) << chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**  @brief Get PLL test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPllTestSelected ( void )
+{
+  return (uint8_t) (( pChipcHw->PLLConfig & chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK ) >> chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT );
+}
+
+
+/****************************************************************************/
+/**  @brief Get PLL2 test selected option
+ */
+/****************************************************************************/
+static inline uint8_t chipcHw_getPll2TestSelected ( void )
+{
+  return (uint8_t) (( pChipcHw->PLLConfig2 & chipcHw_REG_PLL_CONFIG_TEST_SELECT_MASK ) >> chipcHw_REG_PLL_CONFIG_TEST_SELECT_SHIFT );
+}
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL1
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll1Disable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->PLLConfig |= chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief  Disable the PLL2
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_pll2Disable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->PLLConfig2 |= chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->Spare1 |= chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Disables DDR SW phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrPhaseAlignInterruptDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM SW phase alignment interrupt mode
+*
+*  This function sets VPM phase alignment interrupt
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmPhaseAlignInterruptMode ( chipcHw_VPM_HW_PHASE_INTR_e mode )
+{
+   REG_LOCAL_IRQ_SAVE;
+   if ( mode == chipcHw_VPM_HW_PHASE_INTR_DISABLE )
+   {
+      pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE;
+   }
+   else
+   {
+      pChipcHw->Spare1 |= chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE;
+   }
+   pChipcHw->VPMPhaseCtrl2 = ( pChipcHw->VPMPhaseCtrl2  & ~ ( chipcHw_REG_VPM_INTR_SELECT_MASK << chipcHw_REG_VPM_INTR_SELECT_SHIFT ) ) | mode;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl1 |= chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrSwPhaseAlignDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl1 &= ~chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl1 |= chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable DDR phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl1 &= ~chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl1 |= chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in software
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmSwPhaseAlignDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl1 &= ~chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Enable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl1 |= chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Disable VPM phase alignment in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl1 &= ~chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set DDR phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setDdrHwPhaseAlignMargin (  chipcHw_DDR_HW_PHASE_MARGIN_e margin )
+{
+   uint32_t ge = 0;
+   uint32_t le = 0;
+
+   switch (margin)
+   {
+      case chipcHw_DDR_HW_PHASE_MARGIN_STRICT:
+         ge = 0x0F;
+         le = 0x0F;
+         break;
+      case chipcHw_DDR_HW_PHASE_MARGIN_MEDIUM:
+         ge = 0x03;
+         le = 0x3F;
+         break;
+      case chipcHw_DDR_HW_PHASE_MARGIN_WIDE:
+         ge = 0x01;
+         le = 0x7F;
+         break;
+   }
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+
+      pChipcHw->DDRPhaseCtrl1 &= ~( ( chipcHw_REG_DDR_PHASE_VALUE_GE_MASK << chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT ) ||
+                                    ( chipcHw_REG_DDR_PHASE_VALUE_LE_MASK << chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT ) );
+
+      pChipcHw->DDRPhaseCtrl1 |=  ( ( ge << chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT ) ||
+                                    ( le << chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT ) );
+
+      REG_LOCAL_IRQ_RESTORE;
+   }
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM phase alignment margin in hardware
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_setVpmHwPhaseAlignMargin (  chipcHw_VPM_HW_PHASE_MARGIN_e margin )
+{
+   uint32_t ge = 0;
+   uint32_t le = 0;
+
+   switch (margin)
+   {
+      case chipcHw_VPM_HW_PHASE_MARGIN_STRICT:
+         ge = 0x0F;
+         le = 0x0F;
+         break;
+      case chipcHw_VPM_HW_PHASE_MARGIN_MEDIUM:
+         ge = 0x03;
+         le = 0x3F;
+         break;
+      case chipcHw_VPM_HW_PHASE_MARGIN_WIDE:
+         ge = 0x01;
+         le = 0x7F;
+         break;
+   }
+
+   {
+      REG_LOCAL_IRQ_SAVE;
+
+      pChipcHw->VPMPhaseCtrl1 &= ~( ( chipcHw_REG_VPM_PHASE_VALUE_GE_MASK << chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT ) ||
+                                    ( chipcHw_REG_VPM_PHASE_VALUE_LE_MASK << chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT ) );
+
+      pChipcHw->VPMPhaseCtrl1 |=  ( ( ge << chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT ) ||
+                                    ( le << chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT ) );
+
+      REG_LOCAL_IRQ_RESTORE;
+   }
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Checks DDR phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isDdrHwPhaseAligned ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_DDR_PHASE_ALIGNED ) ? 1 : 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Checks VPM phase aligned status done by HW
+*
+*  @return  1: When aligned
+*           0: When not aligned
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_isVpmHwPhaseAligned ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_VPM_PHASE_ALIGNED ) ? 1 : 0;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrHwPhaseAlignStatus ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_DDR_PHASE_STATUS_MASK ) >> chipcHw_REG_DDR_PHASE_STATUS_SHIFT;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase aligned status done by HW
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmHwPhaseAlignStatus ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_VPM_PHASE_STATUS_MASK ) >> chipcHw_REG_VPM_PHASE_STATUS_SHIFT;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Get DDR phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getDdrPhaseControl ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_DDR_PHASE_CTRL_MASK ) >> chipcHw_REG_DDR_PHASE_CTRL_SHIFT;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Get VPM phase control value
+*
+*/
+/****************************************************************************/
+static inline uint32_t chipcHw_getVpmPhaseControl ( void )
+{
+   return ( pChipcHw->PhaseAlignStatus & chipcHw_REG_VPM_PHASE_CTRL_MASK ) >> chipcHw_REG_VPM_PHASE_CTRL_SHIFT;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a DDR phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeout ( uint32_t busCycle )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl2 &= ~ ( chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK << chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT );
+   pChipcHw->DDRPhaseCtrl2 |= ( busCycle & chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK ) << chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout count
+*
+*  @note    If HW fails to perform the phase alignment, it will trigger
+*           a VPM phase alignment timeout interrupt.
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeout ( uint32_t busCycle )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl2 &= ~ ( chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK << chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT );
+   pChipcHw->VPMPhaseCtrl2 |= ( busCycle & chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK ) << chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Clear DDR phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptClear ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   /* Clear timeout interrupt service bit*/
+   pChipcHw->DDRPhaseCtrl2 |= chipcHw_REG_DDR_INTR_SERVICED;
+   pChipcHw->DDRPhaseCtrl2 &= ~chipcHw_REG_DDR_INTR_SERVICED;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Clear VPM phase alignment timeout interrupt
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptClear ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   /* Clear timeout interrupt service bit*/
+   pChipcHw->VPMPhaseCtrl2 |= chipcHw_REG_VPM_INTR_SERVICED;
+   pChipcHw->VPMPhaseCtrl2 &= ~chipcHw_REG_VPM_INTR_SERVICED;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   chipcHw_ddrHwPhaseAlignTimeoutInterruptClear ();  // Recommended
+   /* Enable timeout interrupt */
+   pChipcHw->DDRPhaseCtrl2 |= chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt enable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptEnable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   chipcHw_vpmHwPhaseAlignTimeoutInterruptClear ();  // Recommended
+   /* Enable timeout interrupt */
+   pChipcHw->VPMPhaseCtrl2 |= chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   DDR phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_ddrHwPhaseAlignTimeoutInterruptDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->DDRPhaseCtrl2 &= ~chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   VPM phase alignment timeout interrupt disable
+*
+*/
+/****************************************************************************/
+static inline void chipcHw_vpmHwPhaseAlignTimeoutInterruptDisable ( void )
+{
+   REG_LOCAL_IRQ_SAVE;
+   pChipcHw->VPMPhaseCtrl2 &= ~chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE;
+   REG_LOCAL_IRQ_RESTORE;
+}
+
+#endif /* CHIPC_INLINE_H */
+
+
+
+
+
+
+
+
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
new file mode 100644
index 0000000..6b319a4
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
@@ -0,0 +1,552 @@
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
+
+
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
+typedef struct
+{
+    uint32_t ChipId;            /* Chip ID */
+    uint32_t DDRClock;          /* PLL1 Channel 1 for DDR clock */
+    uint32_t ARMClock;          /* PLL1 Channel 2 for ARM clock */
+    uint32_t ESWClock;          /* PLL1 Channel 3 for ESW system clock */
+    uint32_t VPMClock;          /* PLL1 Channel 4 for VPM clock */
+    uint32_t ESW125Clock;       /* PLL1 Channel 5 for ESW 125MHz clock */
+    uint32_t UARTClock;         /* PLL1 Channel 6 for UART clock */
+    uint32_t SDIO0Clock;        /* PLL1 Channel 7 for SDIO 0 clock */
+    uint32_t SDIO1Clock;        /* PLL1 Channel 8 for SDIO 1 clock */
+    uint32_t SPIClock;          /* PLL1 Channel 9 for SPI master Clock  */
+    uint32_t ETMClock;          /* PLL1 Channel 10 for ARM ETM Clock  */
+
+    uint32_t ACLKClock;         /* ACLK Clock (Divider) */
+    uint32_t OTPClock;          /* OTP Clock  (Divider)*/
+    uint32_t I2CClock;          /* I2C Clock (CK_13m) (Divider) */
+    uint32_t I2S0Clock;         /* I2S0 Clock (Divider) */
+    uint32_t RTBUSClock;        /* RTBUS (DDR PHY Config.) Clock (Divider) */
+    uint32_t pad1;              /////////////////////////////////////
+    uint32_t APM100Clock;       /* APM 100MHz CLK Clock (Divider) */
+    uint32_t TSCClock;          /* TSC Clock (Divider) */
+    uint32_t LEDClock;          /* LED Clock (Divider) */
+
+    uint32_t USBClock;          /* PLL2 Channel 1 for USB clock */
+    uint32_t LCDClock;          /* PLL2 Channel 2 for LCD clock */
+    uint32_t APMClock;          /* PLL2 Channel 3 for APM 200 MHz clock */
+
+    uint32_t BusIntfClock;      /* Bus interface clock */
+
+
+
+    uint32_t PLLStatus;         /* PLL status register (PLL1) */
+    uint32_t PLLConfig;         /* PLL configuration register  (PLL1) */
+    uint32_t PLLPreDivider;     /* PLL pre-divider control register (PLL1) */
+    uint32_t PLLDivider;        /* PLL divider control register (PLL1) */
+    uint32_t PLLControl1;       /* PLL analog control register #1 (PLL1) */
+    uint32_t PLLControl2;       /* PLL analog control register #2 (PLL1) */
+
+    uint32_t I2S1Clock;         /* I2S1 Clock  */
+    uint32_t AudioEnable;       /* Enable/ disable audio channel */
+    uint32_t SoftReset1;        /* Reset blocks */
+    uint32_t SoftReset2;        /* Reset blocks */
+    uint32_t Spare1;            /* Phase align interrupts */
+    uint32_t Sticky;            /* Sticky bits */
+    uint32_t MiscCtrl;          /* Misc. control */
+    uint32_t pad3[3];           ///////////////////////////////////////
+
+    uint32_t PLLStatus2;        /* PLL status register (PLL2) */
+    uint32_t PLLConfig2;        /* PLL configuration register  (PLL2) */
+    uint32_t PLLPreDivider2;    /* PLL pre-divider control register (PLL2) */
+    uint32_t PLLDivider2;       /* PLL divider control register (PLL2) */
+    uint32_t PLLControl12;      /* PLL analog control register #1 (PLL2) */
+    uint32_t PLLControl22;      /* PLL analog control register #2 (PLL2) */
+
+    uint32_t DDRPhaseCtrl1;     /* DDR Clock Phase Alignment control1 */
+    uint32_t VPMPhaseCtrl1;     /* VPM Clock Phase Alignment control1 */
+    uint32_t PhaseAlignStatus;  /* DDR/VPM Clock Phase Alignment Status */
+    uint32_t PhaseCtrlStatus;   /* DDR/VPM Clock HW DDR/VPM ph_ctrl and load_ch Status */
+    uint32_t DDRPhaseCtrl2;     /* DDR Clock Phase Alignment control2 */
+    uint32_t VPMPhaseCtrl2;     /* VPM Clock Phase Alignment control2 */
+    uint32_t pad4[9];           ////////////////////////////////////////
+
+    uint32_t SoftOTP1;          /* Software OTP control */
+    uint32_t SoftOTP2;          /* Software OTP control */
+    uint32_t SoftStraps;        /* Software strap */
+    uint32_t PinStraps;         /* Pin Straps */
+    uint32_t DiffOscCtrl;       /* Diff oscillator control */
+    uint32_t DiagsCtrl;         /* Diagnostic control */
+    uint32_t DiagsOutputCtrl;   /* Diagnostic output enable */
+    uint32_t DiagsReadBackCtrl; /* Diagnostic read back control */
+
+    uint32_t LcdPifMode;        /* LCD/PIF Pin Sharing MUX Mode */
+
+    uint32_t GpioMux_0_7;       /* Pin Sharing MUX0 Control */
+    uint32_t GpioMux_8_15;      /* Pin Sharing MUX1 Control */
+    uint32_t GpioMux_16_23;     /* Pin Sharing MUX2 Control */
+    uint32_t GpioMux_24_31;     /* Pin Sharing MUX3 Control */
+    uint32_t GpioMux_32_39;     /* Pin Sharing MUX4 Control */
+    uint32_t GpioMux_40_47;     /* Pin Sharing MUX5 Control */
+    uint32_t GpioMux_48_55;     /* Pin Sharing MUX6 Control */
+    uint32_t GpioMux_56_63;     /* Pin Sharing MUX7 Control */
+
+    uint32_t GpioSR_0_7;        /* Slew rate for GPIO 0 - 7 */
+    uint32_t GpioSR_8_15;       /* Slew rate for GPIO 8 - 15 */
+    uint32_t GpioSR_16_23;      /* Slew rate for GPIO 16 - 23 */
+    uint32_t GpioSR_24_31;      /* Slew rate for GPIO 24 - 31 */
+    uint32_t GpioSR_32_39;      /* Slew rate for GPIO 32 - 39 */
+    uint32_t GpioSR_40_47;      /* Slew rate for GPIO 40 - 47 */
+    uint32_t GpioSR_48_55;      /* Slew rate for GPIO 48 - 55 */
+    uint32_t GpioSR_56_63;      /* Slew rate for GPIO 56 - 63 */
+    uint32_t MiscSR_0_7;        /* Slew rate for MISC 0 - 7 */
+    uint32_t MiscSR_8_15;       /* Slew rate for MISC 8 - 15 */
+
+    uint32_t GpioPull_0_15;     /* Pull up registers for GPIO 0 - 15 */
+    uint32_t GpioPull_16_31;    /* Pull up registers for GPIO 16 - 31 */
+    uint32_t GpioPull_32_47;    /* Pull up registers for GPIO 32 - 47 */
+    uint32_t GpioPull_48_63;    /* Pull up registers for GPIO 48 - 63 */
+    uint32_t MiscPull_0_15;     /* Pull up registers for MISC 0 - 15 */
+
+    uint32_t GpioInput_0_31;    /* Input type for GPIO 0 - 31 */
+    uint32_t GpioInput_32_63;   /* Input type for GPIO 32 - 63 */
+    uint32_t MiscInput_0_15;    /* Input type for MISC 0 - 16 */
+}chipcHw_REG_t;
+
+#define pChipcHw  ( ( volatile chipcHw_REG_t* ) chipcHw_BASE_ADDRESS)
+#define pChipcPhysical  ( ( volatile chipcHw_REG_t* ) MM_ADDR_IO_CHIPC)
+
+
+#define chipcHw_REG_CHIPID_BASE_MASK                    0xFFFFF000
+#define chipcHw_REG_CHIPID_BASE_SHIFT                   12
+#define chipcHw_REG_CHIPID_REV_MASK                     0x00000FFF
+#define chipcHw_REG_REV_A0                              0xA00
+#define chipcHw_REG_REV_B0                              0x0B0
+
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
+
+#define chipcHw_REG_PLL_CLOCK_PHASE_COMP                0x00800000     /* Phase comparator output */
+#define chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK         0x00300000     /* Clock to bus ratio mask */
+#define chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT        20             /* Number of bits to be shifted */
+#define chipcHw_REG_PLL_CLOCK_POWER_DOWN                0x00080000     /* PLL channel power down */
+#define chipcHw_REG_PLL_CLOCK_SOURCE_GPIO               0x00040000     /* Use GPIO as source */
+#define chipcHw_REG_PLL_CLOCK_BYPASS_SELECT             0x00020000     /* Select bypass clock */
+#define chipcHw_REG_PLL_CLOCK_OUTPUT_ENABLE             0x00010000     /* Clock gated ON */
+#define chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE       0x00008000     /* Clock phase update enable */
+#define chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT       8              /* Number of bits to be shifted */
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
+                                               */
+
+#define chipcHw_REG_DIV_CLOCK_SOURCE_OTHER              0x00040000     /* NON-PLL clock source select */
+#define chipcHw_REG_DIV_CLOCK_BYPASS_SELECT             0x00020000     /* NON-PLL clock bypass enable */
+#define chipcHw_REG_DIV_CLOCK_OUTPUT_ENABLE             0x00010000     /* NON-PLL clock output enable */
+#define chipcHw_REG_DIV_CLOCK_DIV_MASK                  0x000000FF     /* NON-PLL clock post-divide mask */
+#define chipcHw_REG_DIV_CLOCK_DIV_256                   0x00000000     /* NON-PLL clock post-divide by 256 */
+
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
+#define chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vco)          ( (vco) / chipcHw_XTAL_FREQ_Hz )
+#define chipcHw_REG_PLL_PREDIVIDER_P1                   1
+#define chipcHw_REG_PLL_PREDIVIDER_P2                   1
+
+
+#define chipcHw_REG_PLL_DIVIDER_M1DIV                   0x03000000
+#define chipcHw_REG_PLL_DIVIDER_FRAC                    0x00FFFFFF         /* Fractional divider */
+
+#define chipcHw_REG_PLL_DIVIDER_NDIV_f_SS               ( 0x00FFFFFF )     /* To attain spread with max frequency */
+
+#define chipcHw_REG_PLL_DIVIDER_NDIV_f                  0                  /* ndiv_frac = chipcHw_REG_PLL_DIVIDER_NDIV_f /
+                                                                                          chipcHw_REG_PLL_DIVIDER_FRAC
+                                                                                        = 0, when SS is disable
+                                                                           */
+
+#define chipcHw_REG_PLL_DIVIDER_MDIV(vco,Hz)            ( (chipcHw_divide((vco), (Hz)) > 255) ? 0 : chipcHw_divide((vco), (Hz)))
+
+
+#define chipcHw_REG_ACLKClock_CLK_DIV_MASK              0x3
+
+/* System booting strap options */
+#define chipcHw_STRAPS_SOFT_OVERRIDE                    0x00000001    /* Software Strap Override */
+
+#define chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_8         0x00000000    /* 8 bit NAND FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_NOR_FLASH_16         0x00000002    /* 16 bit NOR FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_SERIAL_FLASH         0x00000004    /* Serial FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_NAND_FLASH_16        0x00000006    /* 16 bit NAND FLASH Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_UART                 0x00000008    /* UART Boot */
+#define chipcHw_STRAPS_BOOT_DEVICE_MASK                 0x0000000E    /* Mask */
+
+/* System boot option */
+#define chipcHw_STRAPS_BOOT_OPTION_BROM                 0x00000000    /* Boot from Boot ROM */
+#define chipcHw_STRAPS_BOOT_OPTION_ARAM                 0x00000020    /* Boot from ARAM */
+#define chipcHw_STRAPS_BOOT_OPTION_NOR                  0x00000030    /* Boot from NOR flash */
+
+/* NAND Flash page size strap options */
+#define chipcHw_STRAPS_NAND_PAGESIZE_512                0x00000000    /* NAND FLASH page size of 512 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_2048               0x00000040    /* NAND FLASH page size of 2048 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_4096               0x00000080    /* NAND FLASH page size of 4096 bytes */
+#define chipcHw_STRAPS_NAND_PAGESIZE_EXT                0x000000C0    /* NAND FLASH page of extened size */
+#define chipcHw_STRAPS_NAND_PAGESIZE_MASK               0x000000C0    /* Mask */
+
+#define chipcHw_STRAPS_NAND_EXTRA_CYCLE                 0x00000400   /* NAND FLASH address cycle configuration */
+#define chipcHw_STRAPS_REBOOT_TO_UART                   0x00000800   /* Reboot to UART on error */
+
+/* Secure boot mode strap options */
+#define chipcHw_STRAPS_BOOT_MODE_NORMAL                 0x00000000    /* Normal Boot */
+#define chipcHw_STRAPS_BOOT_MODE_DBG_SW                 0x00000100    /* Software debugging Boot */
+#define chipcHw_STRAPS_BOOT_MODE_DBG_BOOT               0x00000200    /* Boot rom debugging Boot */
+#define chipcHw_STRAPS_BOOT_MODE_NORMAL_QUIET           0x00000300    /* Normal Boot (Quiet BootRom) */
+#define chipcHw_STRAPS_BOOT_MODE_MASK                   0x00000300    /* Mask */
+
+/* Slave Mode straps */
+#define chipcHw_STRAPS_I2CS                             0x02000000    /* I2C Slave  */
+#define chipcHw_STRAPS_SPIS                             0x01000000    /* SPI Slave  */
+
+/* Strap pin options */
+#define chipcHw_REG_SW_STRAPS                           (( pChipcHw->PinStraps & 0x0000FC00 ) >> 10)
+
+/* PIF/LCD pin sharing defines */
+#define chipcHw_REG_LCD_PIN_ENABLE                      0x00000001   /* LCD Controller is used and the pins have LCD functions */
+#define chipcHw_REG_PIF_PIN_ENABLE                      0x00000002   /* LCD pins are used to perform PIF functions  */
+
+
+#define chipcHw_GPIO_COUNT                              61            /* Number of GPIO pin accessible thorugh CHIPC */
+
+// NOTE: Any changes to these constants will require a corresponding change to chipcHw_str.c
+#define chipcHw_REG_GPIO_MUX_KEYPAD                     0x00000001    /* GPIO mux for Keypad */
+#define chipcHw_REG_GPIO_MUX_I2CH                       0x00000002    /* GPIO mux for I2CH */
+#define chipcHw_REG_GPIO_MUX_SPI                        0x00000003    /* GPIO mux for SPI */
+#define chipcHw_REG_GPIO_MUX_UART                       0x00000004    /* GPIO mux for UART */
+#define chipcHw_REG_GPIO_MUX_LEDMTXP                    0x00000005    /* GPIO mux for LEDMTXP */
+#define chipcHw_REG_GPIO_MUX_LEDMTXS                    0x00000006    /* GPIO mux for LEDMTXS */
+#define chipcHw_REG_GPIO_MUX_SDIO0                      0x00000007    /* GPIO mux for SDIO0 */
+#define chipcHw_REG_GPIO_MUX_SDIO1                      0x00000008    /* GPIO mux for SDIO1 */
+#define chipcHw_REG_GPIO_MUX_PCM                        0x00000009    /* GPIO mux for PCM */
+#define chipcHw_REG_GPIO_MUX_I2S                        0x0000000A    /* GPIO mux for I2S */
+#define chipcHw_REG_GPIO_MUX_ETM                        0x0000000B    /* GPIO mux for ETM */
+#define chipcHw_REG_GPIO_MUX_DEBUG                      0x0000000C    /* GPIO mux for DEBUG */
+#define chipcHw_REG_GPIO_MUX_MISC                       0x0000000D    /* GPIO mux for MISC*/
+#define chipcHw_REG_GPIO_MUX_GPIO                       0x00000000    /* GPIO mux for GPIO */
+#define chipcHw_REG_GPIO_MUX(pin)                       (&pChipcHw->GpioMux_0_7 + ((pin) >> 3))
+#define chipcHw_REG_GPIO_MUX_POSITION(pin)              (((pin) & 0x00000007) << 2)
+#define chipcHw_REG_GPIO_MUX_MASK                       0x0000000F    /* Mask */
+
+#define chipcHw_REG_SLEW_RATE_HIGH                      0x00000000    /* High speed slew rate */
+#define chipcHw_REG_SLEW_RATE_NORMAL                    0x00000008    /* Normal slew rate */
+                                                        /* Pins beyond 42 are defined by skipping 8 bits within the register */
+#define chipcHw_REG_SLEW_RATE(pin)                      (((pin) > 42) ? (&pChipcHw->GpioSR_0_7 + (((pin) + 2) >> 3)) : (&pChipcHw->GpioSR_0_7 + ((pin) >> 3) ))
+#define chipcHw_REG_SLEW_RATE_POSITION(pin)             (((pin) > 42) ? ((((pin) + 2) & 0x00000007) << 2) : (((pin) & 0x00000007) << 2))
+#define chipcHw_REG_SLEW_RATE_MASK                      0x00000008    /* Mask */
+
+#define chipcHw_REG_CURRENT_STRENGTH_2mA                0x00000001    /* Current driving strength 2 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_4mA                0x00000002    /* Current driving strength 4 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_6mA                0x00000004    /* Current driving strength 6 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_8mA                0x00000005    /* Current driving strength 8 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_10mA               0x00000006    /* Current driving strength 10 milli ampere */
+#define chipcHw_REG_CURRENT_STRENGTH_12mA               0x00000007    /* Current driving strength 12 milli ampere */
+#define chipcHw_REG_CURRENT_MASK                        0x00000007    /* Mask */
+                                                        /* Pins beyond 42 are defined by skipping 8 bits */
+#define chipcHw_REG_CURRENT(pin)                        (((pin) > 42) ? (&pChipcHw->GpioSR_0_7 + (((pin) + 2) >> 3)) : (&pChipcHw->GpioSR_0_7 + ((pin) >> 3)))
+#define chipcHw_REG_CURRENT_POSITION(pin)               (((pin) > 42) ? ((((pin) + 2) & 0x00000007 ) << 2) : (((pin) & 0x00000007 ) << 2))
+
+#define chipcHw_REG_PULL_NONE                           0x00000000    /* No pull up register */
+#define chipcHw_REG_PULL_UP                             0x00000001    /* Pull up register enable */
+#define chipcHw_REG_PULL_DOWN                           0x00000002    /* Pull down register enable */
+#define chipcHw_REG_PULLUP_MASK                         0x00000003    /* Mask */
+                                                        /* Pins beyond 42 are defined by skipping 4 bits */
+#define chipcHw_REG_PULLUP(pin)                         (((pin) > 42) ? (&pChipcHw->GpioPull_0_15 + (((pin)+ 2) >> 4)) : (&pChipcHw->GpioPull_0_15 + ((pin) >> 4)))
+#define chipcHw_REG_PULLUP_POSITION(pin)                (((pin) > 42) ? ((((pin) + 2) & 0x0000000F) << 1) : (((pin) & 0x0000000F) << 1))
+
+
+#define chipcHw_REG_INPUTTYPE_CMOS                      0x00000000    /* Normal CMOS logic */
+#define chipcHw_REG_INPUTTYPE_ST                        0x00000001    /* High speed Schmitt Trigger */
+#define chipcHw_REG_INPUTTYPE_MASK                      0x00000001    /* Mask */
+                                                        /* Pins beyond 42 are defined by skipping 2 bits */
+#define chipcHw_REG_INPUTTYPE(pin)                      (((pin) > 42) ? (&pChipcHw->GpioInput_0_31 + (((pin) + 2) >> 5)) : (&pChipcHw->GpioInput_0_31 + ((pin) >> 5)))
+#define chipcHw_REG_INPUTTYPE_POSITION(pin)             (((pin) > 42) ? ((((pin) + 2) & 0x0000001F)) : (((pin) & 0x0000001F)))
+
+/* Device connected to the bus clock */
+#define chipcHw_REG_BUS_CLOCK_ARM                       0x00000001    /* Bus interface clock for ARM */
+#define chipcHw_REG_BUS_CLOCK_VDEC                      0x00000002    /* Bus interface clock for VDEC */
+#define chipcHw_REG_BUS_CLOCK_ARAM                      0x00000004    /* Bus interface clock for ARAM */
+#define chipcHw_REG_BUS_CLOCK_HPM                       0x00000008    /* Bus interface clock for HPM */
+#define chipcHw_REG_BUS_CLOCK_DDRC                      0x00000010    /* Bus interface clock for DDRC */
+#define chipcHw_REG_BUS_CLOCK_DMAC0                     0x00000020    /* Bus interface clock for DMAC0 */
+#define chipcHw_REG_BUS_CLOCK_DMAC1                     0x00000040    /* Bus interface clock for DMAC1 */
+#define chipcHw_REG_BUS_CLOCK_NVI                       0x00000080    /* Bus interface clock for NVI */
+#define chipcHw_REG_BUS_CLOCK_ESW                       0x00000100    /* Bus interface clock for ESW */
+#define chipcHw_REG_BUS_CLOCK_GE                        0x00000200    /* Bus interface clock for GE */
+#define chipcHw_REG_BUS_CLOCK_I2CH                      0x00000400    /* Bus interface clock for I2CH */
+#define chipcHw_REG_BUS_CLOCK_I2S0                      0x00000800    /* Bus interface clock for I2S0 */
+#define chipcHw_REG_BUS_CLOCK_I2S1                      0x00001000    /* Bus interface clock for I2S1 */
+#define chipcHw_REG_BUS_CLOCK_VRAM                      0x00002000    /* Bus interface clock for VRAM */
+#define chipcHw_REG_BUS_CLOCK_CLCD                      0x00004000    /* Bus interface clock for CLCD */
+#define chipcHw_REG_BUS_CLOCK_LDK                       0x00008000    /* Bus interface clock for LDK */
+#define chipcHw_REG_BUS_CLOCK_LED                       0x00010000    /* Bus interface clock for LED */
+#define chipcHw_REG_BUS_CLOCK_OTP                       0x00020000    /* Bus interface clock for OTP */
+#define chipcHw_REG_BUS_CLOCK_PIF                       0x00040000    /* Bus interface clock for PIF */
+#define chipcHw_REG_BUS_CLOCK_SPU                       0x00080000    /* Bus interface clock for SPU */
+#define chipcHw_REG_BUS_CLOCK_SDIO0                     0x00100000    /* Bus interface clock for SDIO0 */
+#define chipcHw_REG_BUS_CLOCK_SDIO1                     0x00200000    /* Bus interface clock for SDIO1 */
+#define chipcHw_REG_BUS_CLOCK_SPIH                      0x00400000    /* Bus interface clock for SPIH */
+#define chipcHw_REG_BUS_CLOCK_SPIS                      0x00800000    /* Bus interface clock for SPIS */
+#define chipcHw_REG_BUS_CLOCK_UART0                     0x01000000    /* Bus interface clock for UART0 */
+#define chipcHw_REG_BUS_CLOCK_UART1                     0x02000000    /* Bus interface clock for UART1 */
+#define chipcHw_REG_BUS_CLOCK_BBL                       0x04000000    /* Bus interface clock for BBL */
+#define chipcHw_REG_BUS_CLOCK_I2CS                      0x08000000    /* Bus interface clock for I2CS */
+#define chipcHw_REG_BUS_CLOCK_USBH                      0x10000000    /* Bus interface clock for USB Host */
+#define chipcHw_REG_BUS_CLOCK_USBD                      0x20000000    /* Bus interface clock for USB Device */
+#define chipcHw_REG_BUS_CLOCK_BROM                      0x40000000    /* Bus interface clock for Boot ROM */
+#define chipcHw_REG_BUS_CLOCK_TSC                       0x80000000    /* Bus interface clock for Touch screen */
+
+
+/* Software resets defines */
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL_HOLD          0x0000000080000000ULL /* Reset Global VPM and hold */
+#define chipcHw_REG_SOFT_RESET_VPM_HOLD                 0x0000000040000000ULL /* Reset VPM and hold*/
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL               0x0000000020000000ULL /* Reset Global VPM */
+#define chipcHw_REG_SOFT_RESET_VPM                      0x0000000010000000ULL /* Reset VPM */
+#define chipcHw_REG_SOFT_RESET_KEYPAD                   0x0000000008000000ULL /* Reset Key pad */
+#define chipcHw_REG_SOFT_RESET_LED                      0x0000000004000000ULL /* Reset LED */
+#define chipcHw_REG_SOFT_RESET_SPU                      0x0000000002000000ULL /* Reset SPU */
+#define chipcHw_REG_SOFT_RESET_RNG                      0x0000000001000000ULL /* Reset RNG */
+#define chipcHw_REG_SOFT_RESET_PKA                      0x0000000000800000ULL /* Reset PKA */
+#define chipcHw_REG_SOFT_RESET_LCD                      0x0000000000400000ULL /* Reset LCD */
+#define chipcHw_REG_SOFT_RESET_PIF                      0x0000000000200000ULL /* Reset PIF */
+#define chipcHw_REG_SOFT_RESET_I2CS                     0x0000000000100000ULL /* Reset I2C Slave */
+#define chipcHw_REG_SOFT_RESET_I2CH                     0x0000000000080000ULL /* Reset I2C Host */
+#define chipcHw_REG_SOFT_RESET_SDIO1                    0x0000000000040000ULL /* Reset SDIO 1 */
+#define chipcHw_REG_SOFT_RESET_SDIO0                    0x0000000000020000ULL /* Reset SDIO 0 */
+#define chipcHw_REG_SOFT_RESET_BBL                      0x0000000000010000ULL /* Reset BBL */
+#define chipcHw_REG_SOFT_RESET_I2S1                     0x0000000000008000ULL /* Reset I2S1 */
+#define chipcHw_REG_SOFT_RESET_I2S0                     0x0000000000004000ULL /* Reset I2S0 */
+#define chipcHw_REG_SOFT_RESET_SPIS                     0x0000000000002000ULL /* Reset SPI Slave */
+#define chipcHw_REG_SOFT_RESET_SPIH                     0x0000000000001000ULL /* Reset SPI Host */
+#define chipcHw_REG_SOFT_RESET_GPIO1                    0x0000000000000800ULL /* Reset GPIO block 1 */
+#define chipcHw_REG_SOFT_RESET_GPIO0                    0x0000000000000400ULL /* Reset GPIO block 0 */
+#define chipcHw_REG_SOFT_RESET_UART1                    0x0000000000000200ULL /* Reset UART 1*/
+#define chipcHw_REG_SOFT_RESET_UART0                    0x0000000000000100ULL /* Reset UART 0 */
+#define chipcHw_REG_SOFT_RESET_NVI                      0x0000000000000080ULL /* Reset NVI */
+#define chipcHw_REG_SOFT_RESET_WDOG                     0x0000000000000040ULL /* Reset Watch dog*/
+#define chipcHw_REG_SOFT_RESET_TMR                      0x0000000000000020ULL /* Reset Timer */
+#define chipcHw_REG_SOFT_RESET_ETM                      0x0000000000000010ULL /* Reset ETM */
+#define chipcHw_REG_SOFT_RESET_ARM_HOLD                 0x0000000000000008ULL /* Reset ARM and HOLD */
+#define chipcHw_REG_SOFT_RESET_ARM                      0x0000000000000004ULL /* Reset ARM */
+#define chipcHw_REG_SOFT_RESET_CHIP_WARM                0x0000000000000002ULL /* Chip warm reset */
+#define chipcHw_REG_SOFT_RESET_CHIP_SOFT                0x0000000000000001ULL /* Chip soft reset */
+#define chipcHw_REG_SOFT_RESET_VDEC                     0x0000100000000000ULL /* Video decoder */
+#define chipcHw_REG_SOFT_RESET_GE                       0x0000080000000000ULL /* Graphics engine */
+#define chipcHw_REG_SOFT_RESET_OTP                      0x0000040000000000ULL /* Reset OTP */
+#define chipcHw_REG_SOFT_RESET_USB2                     0x0000020000000000ULL /* Reset USB2 */
+#define chipcHw_REG_SOFT_RESET_USB1                     0x0000010000000000ULL /* Reset USB 1*/
+#define chipcHw_REG_SOFT_RESET_USB                      0x0000008000000000ULL /* Reset USB 1 and USB2 soft reset */
+#define chipcHw_REG_SOFT_RESET_ESW                      0x0000004000000000ULL /* Reset Ethernet switch */
+#define chipcHw_REG_SOFT_RESET_ESWCLK                   0x0000002000000000ULL /* Reset Ethernet switch clock */
+#define chipcHw_REG_SOFT_RESET_DDRPHY                   0x0000001000000000ULL /* Reset DDR Physical */
+#define chipcHw_REG_SOFT_RESET_DDR                      0x0000000800000000ULL /* Reset DDR Controller */
+#define chipcHw_REG_SOFT_RESET_TSC                      0x0000000400000000ULL /* Reset Touch screen */
+#define chipcHw_REG_SOFT_RESET_PCM                      0x0000000200000000ULL /* Reset PCM device */
+#define chipcHw_REG_SOFT_RESET_APM                      0x0000200100000000ULL /* Reset APM device */
+
+#define chipcHw_REG_SOFT_RESET_VPM_GLOBAL_UNHOLD        0x8000000000000000ULL /* Unhold Global VPM */
+#define chipcHw_REG_SOFT_RESET_VPM_UNHOLD               0x4000000000000000ULL /* Unhold VPM */
+#define chipcHw_REG_SOFT_RESET_ARM_UNHOLD               0x2000000000000000ULL /* Unhold ARM reset  */
+#define chipcHw_REG_SOFT_RESET_UNHOLD_MASK              0xF000000000000000ULL /* Mask to handle unhold request */
+
+/* Audio channel control defines */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_ALL            0x00000001  /* Enable all audio channel */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_A              0x00000002  /* Enable channel A */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_B              0x00000004  /* Enable channel B */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_C              0x00000008  /* Enable channel C */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_NTP_CLOCK      0x00000010  /* Enable NTP clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_PCM0_CLOCK     0x00000020  /* Enable PCM0 clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_PCM1_CLOCK     0x00000040  /* Enable PCM1 clock */
+#define chipcHw_REG_AUDIO_CHANNEL_ENABLE_APM_CLOCK      0x00000080  /* Enable APM clock */
+
+
+/* Misc. chip control defines */
+#define chipcHw_REG_MISC_CTRL_GE_SEL                    0x00040000  /* Select GE2/GE3 */
+#define chipcHw_REG_MISC_CTRL_I2S1_CLOCK_ONCHIP         0x00000000  /* Use on chip clock for I2S1 */
+#define chipcHw_REG_MISC_CTRL_I2S1_CLOCK_GPIO           0x00020000  /* Use external clock via GPIO pin 26 for I2S1 */
+#define chipcHw_REG_MISC_CTRL_I2S0_CLOCK_ONCHIP         0x00000000  /* Use on chip clock for I2S0 */
+#define chipcHw_REG_MISC_CTRL_I2S0_CLOCK_GPIO           0x00010000  /* Use external clock via GPIO pin 45 for I2S0 */
+#define chipcHw_REG_MISC_CTRL_ARM_CP15_DISABLE          0x00008000  /* Disable ARM CP15 bit */
+#define chipcHw_REG_MISC_CTRL_RTC_DISABLE               0x00000008  /* Disable RTC registers */
+#define chipcHw_REG_MISC_CTRL_BBRAM_DISABLE             0x00000004  /* Disable Battery Backed RAM */
+#define chipcHw_REG_MISC_CTRL_USB_MODE_HOST             0x00000002  /* Set USB as host */
+#define chipcHw_REG_MISC_CTRL_USB_MODE_DEVICE           0xFFFFFFFD  /* Set USB as device */
+#define chipcHw_REG_MISC_CTRL_USB_POWERON               0xFFFFFFFE  /* Power up USB */
+#define chipcHw_REG_MISC_CTRL_USB_POWEROFF              0x00000001  /* Power down USB */
+
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
+
+/* Sticky bit defines */
+#define chipcHw_REG_STICKY_BOOT_DONE                    0x00000001  /* Boot done */
+#define chipcHw_REG_STICKY_SOFT_RESET                   0x00000002  /* ARM soft reset */
+#define chipcHw_REG_STICKY_GENERAL_1                    0x00000004  /* General purpose bit 1 */
+#define chipcHw_REG_STICKY_GENERAL_2                    0x00000008  /* General purpose bit 2 */
+#define chipcHw_REG_STICKY_GENERAL_3                    0x00000010  /* General purpose bit 3 */
+#define chipcHw_REG_STICKY_GENERAL_4                    0x00000020  /* General purpose bit 4 */
+#define chipcHw_REG_STICKY_GENERAL_5                    0x00000040  /* General purpose bit 5 */
+#define chipcHw_REG_STICKY_POR_BROM                     0x00000080  /* Special sticky bit for security - set in BROM to avoid other modes being entered */
+#define chipcHw_REG_STICKY_ARM_RESET                    0x00000100  /* ARM reset */
+#define chipcHw_REG_STICKY_CHIP_SOFT_RESET              0x00000200  /* Chip soft reset */
+#define chipcHw_REG_STICKY_CHIP_WARM_RESET              0x00000400  /* Chip warm reset */
+#define chipcHw_REG_STICKY_WDOG_RESET                   0x00000800  /* Watchdog reset */
+#define chipcHw_REG_STICKY_OTP_RESET                    0x00001000  /* OTP reset */
+
+
+/* HW phase alignment defines */                        /* Spare1 register definitions */
+#define chipcHw_REG_SPARE1_DDR_PHASE_INTR_ENABLE        0x80000000  /* Enable DDR phase align panic interrupt */
+#define chipcHw_REG_SPARE1_VPM_PHASE_INTR_ENABLE        0x40000000  /* Enable VPM phase align panic interrupt */
+#define chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE        0x00000002  /* Enable access to VPM using system BUS */
+#define chipcHw_REG_SPARE1_DDR_BUS_ACCESS_ENABLE        0x00000001  /* Enable access to DDR using system BUS */
+                                                        /* DDRPhaseCtrl1 register definitions */
+#define chipcHw_REG_DDR_SW_PHASE_CTRL_ENABLE            0x80000000  /* Enable DDR SW phase alignment */
+#define chipcHw_REG_DDR_HW_PHASE_CTRL_ENABLE            0x40000000  /* Enable DDR HW phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_GE_MASK             0x0000007F  /* DDR lower threshold for phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_GE_SHIFT            23
+#define chipcHw_REG_DDR_PHASE_VALUE_LE_MASK             0x0000007F  /* DDR upper threshold for phase alignment */
+#define chipcHw_REG_DDR_PHASE_VALUE_LE_SHIFT            16
+#define chipcHw_REG_DDR_PHASE_ALIGN_WAIT_CYCLE_MASK     0x0000FFFF  /* BUS Cycle to wait to run next DDR phase alignment */
+#define chipcHw_REG_DDR_PHASE_ALIGN_WAIT_CYCLE_SHIFT    0
+                                                        /* VPMPhaseCtrl1 register definitions */
+#define chipcHw_REG_VPM_SW_PHASE_CTRL_ENABLE            0x80000000  /* Enable VPM SW phase alignment */
+#define chipcHw_REG_VPM_HW_PHASE_CTRL_ENABLE            0x40000000  /* Enable VPM HW phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_GE_MASK             0x0000007F  /* VPM lower threshold for phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_GE_SHIFT            23
+#define chipcHw_REG_VPM_PHASE_VALUE_LE_MASK             0x0000007F  /* VPM upper threshold for phase alignment */
+#define chipcHw_REG_VPM_PHASE_VALUE_LE_SHIFT            16
+#define chipcHw_REG_VPM_PHASE_ALIGN_WAIT_CYCLE_MASK     0x0000FFFF  /* BUS Cycle to wait to complete the VPM phase alignment */
+#define chipcHw_REG_VPM_PHASE_ALIGN_WAIT_CYCLE_SHIFT    0
+                                                        /* PhaseAlignStatus register definitions */
+#define chipcHw_REG_DDR_TIMEOUT_INTR_STATUS             0x80000000  /* DDR time out interrupt status */
+#define chipcHw_REG_DDR_PHASE_STATUS_MASK               0x0000007F  /* DDR phase status value */
+#define chipcHw_REG_DDR_PHASE_STATUS_SHIFT              24
+#define chipcHw_REG_DDR_PHASE_ALIGNED                   0x00800000  /* DDR Phase aligned status */
+#define chipcHw_REG_DDR_LOAD                            0x00400000  /* Load DDR phase status */
+#define chipcHw_REG_DDR_PHASE_CTRL_MASK                 0x0000003F  /* DDR phase control value */
+#define chipcHw_REG_DDR_PHASE_CTRL_SHIFT                16
+#define chipcHw_REG_VPM_TIMEOUT_INTR_STATUS             0x80000000  /* VPM time out interrupt status */
+#define chipcHw_REG_VPM_PHASE_STATUS_MASK               0x0000007F  /* VPM phase status value */
+#define chipcHw_REG_VPM_PHASE_STATUS_SHIFT              8
+#define chipcHw_REG_VPM_PHASE_ALIGNED                   0x00000080  /* VPM Phase aligned status */
+#define chipcHw_REG_VPM_LOAD                            0x00000040  /* Load VPM phase status */
+#define chipcHw_REG_VPM_PHASE_CTRL_MASK                 0x0000003F  /* VPM phase control value */
+#define chipcHw_REG_VPM_PHASE_CTRL_SHIFT                0
+                                                        /* DDRPhaseCtrl2 register definitions */
+#define chipcHw_REG_DDR_INTR_SERVICED                   0x02000000  /* Acknowledge that interrupt was serviced */
+#define chipcHw_REG_DDR_TIMEOUT_INTR_ENABLE             0x01000000  /* Enable time out interrupt */
+#define chipcHw_REG_DDR_LOAD_COUNT_PHASE_CTRL_MASK      0x0000000F  /* Wait before toggling load_ch */
+#define chipcHw_REG_DDR_LOAD_COUNT_PHASE_CTRL_SHIFT     20
+#define chipcHw_REG_DDR_TOTAL_LOAD_COUNT_CTRL_MASK      0x0000000F  /* Total wait to settle ph_ctrl and load_ch */
+#define chipcHw_REG_DDR_TOTAL_LOAD_COUNT_CTRL_SHIFT     16
+#define chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_MASK        0x0000FFFF  /* Time out value for DDR HW phase alignment */
+#define chipcHw_REG_DDR_PHASE_TIMEOUT_COUNT_SHIFT       0
+                                                        /* VPMPhaseCtrl2 register definitions */
+#define chipcHw_REG_VPM_INTR_SELECT_MASK                0x00000003  /* Interrupt select */
+#define chipcHw_REG_VPM_INTR_SELECT_SHIFT               26
+#define chipcHw_REG_VPM_INTR_DISABLE                    0x00000000
+#define chipcHw_REG_VPM_INTR_FAST                       ( 0x1 << chipcHw_REG_VPM_INTR_SELECT_SHIFT )
+#define chipcHw_REG_VPM_INTR_MEDIUM                     ( 0x2 << chipcHw_REG_VPM_INTR_SELECT_SHIFT )
+#define chipcHw_REG_VPM_INTR_SLOW                       ( 0x3 << chipcHw_REG_VPM_INTR_SELECT_SHIFT )
+#define chipcHw_REG_VPM_INTR_SERVICED                   0x02000000  /* Acknowledge that interrupt was serviced */
+#define chipcHw_REG_VPM_TIMEOUT_INTR_ENABLE             0x01000000  /* Enable time out interrupt */
+#define chipcHw_REG_VPM_LOAD_COUNT_PHASE_CTRL_MASK      0x0000000F  /* Wait before toggling load_ch */
+#define chipcHw_REG_VPM_LOAD_COUNT_PHASE_CTRL_SHIFT     20
+#define chipcHw_REG_VPM_TOTAL_LOAD_COUNT_CTRL_MASK      0x0000000F  /* Total wait cycle to settle ph_ctrl and load_ch */
+#define chipcHw_REG_VPM_TOTAL_LOAD_COUNT_CTRL_SHIFT     16
+#define chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_MASK        0x0000FFFF  /* Time out value for VPM HW phase alignment */
+#define chipcHw_REG_VPM_PHASE_TIMEOUT_COUNT_SHIFT       0
+
+#endif /* CHIPCHW_REG_H */
+
+
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h b/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
new file mode 100644
index 0000000..05275ff
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
@@ -0,0 +1,901 @@
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
+extern "C"
+{
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
+//*********************************************************************
+// DDR2 Controller (ARM PL341) register definitions
+//*********************************************************************
+
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// ARM PL341 DDR2 configuration registers, offset 0x000
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+typedef struct
+{
+    uint32_t memcStatus;
+    uint32_t memcCmd;
+    uint32_t directCmd;
+    uint32_t memoryCfg;
+    uint32_t refreshPrd;
+    uint32_t casLatency;
+    uint32_t writeLatency;
+    uint32_t tMrd;
+    uint32_t tRas;
+    uint32_t tRc;
+    uint32_t tRcd;
+    uint32_t tRfc;
+    uint32_t tRp;
+    uint32_t tRrd;
+    uint32_t tWr;
+    uint32_t tWtr;
+    uint32_t tXp;
+    uint32_t tXsr;
+    uint32_t tEsr;
+    uint32_t memoryCfg2;
+    uint32_t memoryCfg3;
+    uint32_t tFaw;
+}
+ddrcReg_CTLR_MEMC_REG_t;
+
+#define ddrcReg_CTLR_MEMC_REG_OFFSET                    0x0000
+#define ddrcReg_CTLR_MEMC_REGP                          ((volatile ddrcReg_CTLR_MEMC_REG_t *)  (MM_IO_BASE_DDRC + ddrcReg_CTLR_MEMC_REG_OFFSET))
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_MEMC_CMD_MASK                      (0x7 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_GO                        (0x0 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_SLEEP                     (0x1 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_WAKEUP                    (0x2 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_PAUSE                     (0x3 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_CONFIGURE                 (0x4 << 0)
+#define ddrcReg_CTLR_MEMC_CMD_ACTIVE_PAUSE              (0x7 << 0)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
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
+#define ddrcReg_CTLR_MEMORY_CFG_BURST_LEN_8             (0x3 << 15) /// @note Not supported in PL341
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
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_REFRESH_PRD_SHIFT                  0
+#define ddrcReg_CTLR_REFRESH_PRD_MASK                   (0x7fff << ddrcReg_CTLR_REFRESH_PRD_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_CAS_LATENCY_SHIFT                  1
+#define ddrcReg_CTLR_CAS_LATENCY_MASK                   (0x7 << ddrcReg_CTLR_CAS_LATENCY_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_WRITE_LATENCY_SHIFT                0
+#define ddrcReg_CTLR_WRITE_LATENCY_MASK                 (0x7 << ddrcReg_CTLR_WRITE_LATENCY_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_MRD_SHIFT                        0
+#define ddrcReg_CTLR_T_MRD_MASK                         (0x7f << ddrcReg_CTLR_T_MRD_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RAS_SHIFT                        0
+#define ddrcReg_CTLR_T_RAS_MASK                         (0x1f << ddrcReg_CTLR_T_RAS_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RC_SHIFT                         0
+#define ddrcReg_CTLR_T_RC_MASK                          (0x1f << ddrcReg_CTLR_T_RC_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_MASK          (0x7 << ddrcReg_CTLR_T_RCD_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RCD_SHIFT                        0
+#define ddrcReg_CTLR_T_RCD_MASK                         (0x7 << ddrcReg_CTLR_T_RCD_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_MASK          (0x7f << ddrcReg_CTLR_T_RFC_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RFC_SHIFT                        0
+#define ddrcReg_CTLR_T_RFC_MASK                         (0x7f << ddrcReg_CTLR_T_RFC_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_SHIFT          8
+#define ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_MASK           (0x7 << ddrcReg_CTLR_T_RP_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_RP_SHIFT                         0
+#define ddrcReg_CTLR_T_RP_MASK                          (0xf << ddrcReg_CTLR_T_RP_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_RRD_SHIFT                        0
+#define ddrcReg_CTLR_T_RRD_MASK                         (0xf << ddrcReg_CTLR_T_RRD_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_WR_SHIFT                         0
+#define ddrcReg_CTLR_T_WR_MASK                          (0x7 << ddrcReg_CTLR_T_WR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_WTR_SHIFT                        0
+#define ddrcReg_CTLR_T_WTR_MASK                         (0x7 << ddrcReg_CTLR_T_WTR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_XP_SHIFT                         0
+#define ddrcReg_CTLR_T_XP_MASK                          (0xff << ddrcReg_CTLR_T_XP_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_XSR_SHIFT                        0
+#define ddrcReg_CTLR_T_XSR_MASK                         (0xff << ddrcReg_CTLR_T_XSR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_ESR_SHIFT                        0
+#define ddrcReg_CTLR_T_ESR_MASK                         (0xff << ddrcReg_CTLR_T_ESR_SHIFT)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_SHIFT       0
+#define ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_MASK        (0x7 << ddrcReg_CTLR_MEMORY_CFG3_REFRESH_TO_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_SHIFT         8
+#define ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_MASK          (0x1f << ddrcReg_CTLR_T_FAW_SCHEDULE_DELAY_SHIFT)
+
+#define ddrcReg_CTLR_T_FAW_PERIOD_SHIFT                 0
+#define ddrcReg_CTLR_T_FAW_PERIOD_MASK                  (0x1f << ddrcReg_CTLR_T_FAW_PERIOD_SHIFT)
+
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// ARM PL341 AXI ID QOS configuration registers, offset 0x100
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+#define ddrcReg_CTLR_QOS_CNT                            16
+#define ddrcReg_CTLR_QOS_MAX                            (ddrcReg_CTLR_QOS_CNT - 1)
+
+typedef struct
+{
+    uint32_t cfg[ddrcReg_CTLR_QOS_CNT];
+}
+ddrcReg_CTLR_QOS_REG_t;
+
+#define ddrcReg_CTLR_QOS_REG_OFFSET                     0x100
+#define ddrcReg_CTLR_QOS_REGP                           ((volatile ddrcReg_CTLR_QOS_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_QOS_REG_OFFSET))
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_QOS_CFG_MAX_SHIFT                  2
+#define ddrcReg_CTLR_QOS_CFG_MAX_MASK                   (0xff << ddrcReg_CTLR_QOS_CFG_MAX_SHIFT)
+
+#define ddrcReg_CTLR_QOS_CFG_MIN_SHIFT                  1
+#define ddrcReg_CTLR_QOS_CFG_MIN_MASK                   (1 << ddrcReg_CTLR_QOS_CFG_MIN_SHIFT)
+
+#define ddrcReg_CTLR_QOS_CFG_ENABLE                     (1 << 0)
+
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// ARM PL341 Memory chip configuration registers, offset 0x200
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+#define ddrcReg_CTLR_CHIP_CNT                           4
+#define ddrcReg_CTLR_CHIP_MAX                           (ddrcReg_CTLR_CHIP_CNT - 1)
+
+typedef struct
+{
+    uint32_t cfg[ddrcReg_CTLR_CHIP_CNT];
+}
+ddrcReg_CTLR_CHIP_REG_t;
+
+#define ddrcReg_CTLR_CHIP_REG_OFFSET                    0x200
+#define ddrcReg_CTLR_CHIP_REGP                          ((volatile ddrcReg_CTLR_CHIP_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_CHIP_REG_OFFSET))
+
+// -----------------------------------------------------
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
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// ARM PL341 User configuration registers, offset 0x300
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+#define ddrcReg_CTLR_USER_OUTPUT_CNT                    2
+
+typedef struct
+{
+    uint32_t input;
+    uint32_t output[ddrcReg_CTLR_USER_OUTPUT_CNT];
+    uint32_t feature;
+}
+ddrcReg_CTLR_USER_REG_t;
+
+#define ddrcReg_CTLR_USER_REG_OFFSET                    0x300
+#define ddrcReg_CTLR_USER_REGP                          ((volatile ddrcReg_CTLR_USER_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_USER_REG_OFFSET))
+
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_USER_INPUT_STATUS_SHIFT            0
+#define ddrcReg_CTLR_USER_INPUT_STATUS_MASK             (0xff << ddrcReg_CTLR_USER_INPUT_STATUS_SHIFT)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_CTLR_FEATURE_WRITE_BLOCK_DISABLE        (1 << 2)
+#define ddrcReg_CTLR_FEATURE_EARLY_BURST_RSP_DISABLE    (1 << 0)
+
+
+//*********************************************************************
+// Broadcom DDR23 PHY register definitions
+//*********************************************************************
+
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// Broadcom DDR23 PHY Address and Control register definitions
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+typedef struct
+{
+    uint32_t revision;
+    uint32_t pmCtl;
+    REG32_RSVD(0x0008, 0x0010);
+    uint32_t pllStatus;
+    uint32_t pllCfg;
+    uint32_t pllPreDiv;
+    uint32_t pllDiv;
+    uint32_t pllCtl1;
+    uint32_t pllCtl2;
+    uint32_t ssCtl;
+    uint32_t ssCfg;
+    uint32_t vdlStatic;
+    uint32_t vdlDynamic;
+    uint32_t padIdle;
+    uint32_t pvtComp;
+    uint32_t padDrive;
+    uint32_t clkRgltrCtl;
+}
+ddrcReg_PHY_ADDR_CTL_REG_t;
+
+#define ddrcReg_PHY_ADDR_CTL_REG_OFFSET                 0x0400
+#define ddrcReg_PHY_ADDR_CTL_REGP                       ((volatile ddrcReg_PHY_ADDR_CTL_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_ADDR_CTL_REG_OFFSET))
+
+/// @todo These SS definitions are duplicates of ones below
+
+#define ddrcReg_PHY_ADDR_SS_CTRL_ENABLE                 0x00000001
+#define ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_MASK     0xFFFF0000
+#define ddrcReg_PHY_ADDR_SS_CFG_CYCLE_PER_TICK_SHIFT    16
+#define ddrcReg_PHY_ADDR_SS_CFG_MIN_CYCLE_PER_TICK      10            // Higher the value, lower the SS modulation frequency
+#define ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_MASK     0x0000FFFF
+#define ddrcReg_PHY_ADDR_SS_CFG_NDIV_AMPLITUDE_SHIFT    0
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_SHIFT       8
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_MASK        (0xff << ddrcReg_PHY_ADDR_CTL_REVISION_MAJOR_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_SHIFT       0
+#define ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_MASK        (0xff << ddrcReg_PHY_ADDR_CTL_REVISION_MINOR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_CLK_PM_CTL_DDR_CLK_DISABLE (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_STATUS_LOCKED          (1 << 0)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_SHIFT           24
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_MASK            (0xff << ddrcReg_PHY_ADDR_CTL_PLL_DIV_M1_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_SHIFT         0
+#define ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_MASK          (0xffffff << ddrcReg_PHY_ADDR_CTL_PLL_DIV_FRAC_SHIFT)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_SHIFT    4
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_MASK     (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL2_PTAP_ADJ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_SHIFT    2
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_MASK     (0x3 << ddrcReg_PHY_ADDR_CTL_PLL_CTL2_CTAP_ADJ_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_LOWCUR_ENABLE     (0x1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_PLL_CTL2_BIASIN_ENABLE     (0x1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_EN_ENABLE           (0x1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_SHIFT  16
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_MASK   (0xffff << ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_CYC_PER_TICK_SHIFT)
+
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_SHIFT      0
+#define ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_MASK       (0xffff << ddrcReg_PHY_ADDR_CTL_PLL_SS_CFG_NDIV_AMP_SHIFT)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
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
+// -----------------------------------------------------
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
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_RT60B            (1 << 4)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SEL_SSTL18       (1 << 3)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SELTXDRV_CI      (1 << 2)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SELRXDRV         (1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_PAD_DRIVE_SLEW             (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_ADDR_CTL_CLK_RGLTR_CTL_PWR_HALF     (1 << 1)
+#define ddrcReg_PHY_ADDR_CTL_CLK_RGLTR_CTL_PWR_OFF      (1 << 0)
+
+
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+// Broadcom DDR23 PHY Byte Lane register definitions
+// --------------------------------------------------------------------
+// --------------------------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_CNT                       2
+#define ddrcReg_PHY_BYTE_LANE_MAX                       (ddrcReg_CTLR_BYTE_LANE_CNT - 1)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_OVR_CNT               8
+
+typedef struct
+{
+    uint32_t revision;
+    uint32_t vdlCalibrate;
+    uint32_t vdlStatus;
+    REG32_RSVD(0x000c, 0x0010);
+    uint32_t vdlOverride[ddrcReg_PHY_BYTE_LANE_VDL_OVR_CNT];
+    uint32_t readCtl;
+    uint32_t readStatus;
+    uint32_t readClear;
+    uint32_t padIdleCtl;
+    uint32_t padDriveCtl;
+    uint32_t padClkCtl;
+    uint32_t writeCtl;
+    uint32_t clkRegCtl;
+}
+ddrcReg_PHY_BYTE_LANE_REG_t;
+
+// There are 2 instances of the byte Lane registers, one for each byte lane.
+//
+#define ddrcReg_PHY_BYTE_LANE_1_REG_OFFSET              0x0500
+#define ddrcReg_PHY_BYTE_LANE_2_REG_OFFSET              0x0600
+
+#define ddrcReg_PHY_BYTE_LANE_1_REGP                    ((volatile ddrcReg_PHY_BYTE_LANE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_BYTE_LANE_1_REG_OFFSET))
+#define ddrcReg_PHY_BYTE_LANE_2_REGP                    ((volatile ddrcReg_PHY_BYTE_LANE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_PHY_BYTE_LANE_2_REG_OFFSET))
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_SHIFT      8
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_MASK       (0xff << ddrcReg_PHY_BYTE_LANE_REVISION_MAJOR_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_SHIFT      0
+#define ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_MASK       (0xff << ddrcReg_PHY_BYTE_LANE_REVISION_MINOR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_CLK_2CYCLE      (1 << 4)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_CLK_1CYCLE      (0 << 4)
+
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_TEST            (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_ALWAYS          (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_ONCE            (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_VDL_CALIB_FAST            (1 << 0)
+
+// -----------------------------------------------------
+
+// The byte lane VDL status calibTotal[9:0] is comprised of [9:4] step value, [3:2] fine fall
+// and [1:0] fine rise. Note that calibTotal[9:0] is located at bit 4 in the VDL status
+// register. The fine rise and fall are no longer used, so add some definitions for just
+// the step setting to simplify things.
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
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_SHIFT      8
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_MASK       (0x3 << ddrcReg_PHY_BYTE_LANE_READ_CTL_DELAY_SHIFT)
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DQ_ODT_ENABLE    (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_DQ_ODT_ADJUST    (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_RD_ODT_ENABLE    (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_READ_CTL_RD_ODT_ADJUST    (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_SHIFT   0
+#define ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_MASK    (0xf << ddrcReg_PHY_BYTE_LANE_READ_STATUS_ERROR_SHIFT)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_READ_CLEAR_STATUS         (1 << 0)
+
+// -----------------------------------------------------
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
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_RT60B_DDR_READ_ENB      (1 << 5)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_RT60B                   (1 << 4)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SEL_SSTL18              (1 << 3)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SELTXDRV_CI             (1 << 2)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SELRXDRV                (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_PAD_DRIVE_CTL_SLEW                    (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_PAD_CLK_CTL_DISABLE                   (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_WRITE_CTL_PREAMBLE_DDR3               (1 << 0)
+
+// -----------------------------------------------------
+
+#define ddrcReg_PHY_BYTE_LANE_CLK_REG_CTL_PWR_HALF                  (1 << 1)
+#define ddrcReg_PHY_BYTE_LANE_CLK_REG_CTL_PWR_OFF                   (1 << 0)
+
+//*********************************************************************
+// ARM PL341 DDRC to Broadcom DDR23 PHY glue register definitions
+//*********************************************************************
+
+typedef struct
+{
+    uint32_t cfg;
+    uint32_t actMonCnt;
+    uint32_t ctl;
+    uint32_t lbistCtl;
+    uint32_t lbistSeed;
+    uint32_t lbistStatus;
+    uint32_t tieOff;
+    uint32_t actMonClear;
+    uint32_t status;
+    uint32_t user;
+}
+ddrcReg_CTLR_PHY_GLUE_REG_t;
+
+#define ddrcReg_CTLR_PHY_GLUE_OFFSET                            0x0700
+#define ddrcReg_CTLR_PHY_GLUE_REGP                              ((volatile ddrcReg_CTLR_PHY_GLUE_REG_t *) (MM_IO_BASE_DDRC + ddrcReg_CTLR_PHY_GLUE_OFFSET))
+
+// -----------------------------------------------------
+
+// DDR2 / AXI block phase alignment interrupt control
+//
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
+// Software control of PHY VDL updates from control register settings. Bit 13 enables the use of Bit 14.
+// If software control is not enabled, then updates occur when a refresh command is issued by the hardware
+// controller. If 2 chips selects are being used, then software control must be enabled.
+//
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_VDL_UPDATE_SW_CTL_LOAD    (1 << 14)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_VDL_UPDATE_SW_CTL_ENABLE  (1 << 13)
+
+// Use these to bypass a pipeline stage. By default the ADDR is off but the BYTE LANE in / out are on.
+//
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_ADDR_CTL_IN_BYPASS_PIPELINE_STAGE (1 << 12)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_BYTE_LANE_IN_BYPASS_PIPELINE_STAGE (1 << 11)
+#define ddrcReg_CTLR_PHY_GLUE_CFG_PHY_BYTE_LANE_OUT_BYPASS_PIPELINE_STAGE (1 << 10)
+
+// Chip select count
+//
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
+// -----------------------------------------------------
+//
+#define ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_SHIFT                0
+#define ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_MASK                 (0x7f << ddrcReg_CTLR_PHY_GLUE_STATUS_PHASE_SHIFT)
+
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+
+#ifdef __cplusplus
+} // end extern "C"
+#endif
+
+#endif // DDRC_REG_H
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
new file mode 100644
index 0000000..e09fb80
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -0,0 +1,164 @@
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
+
+
+
+/****************************************************************************/
+/**
+*  @file    dmacHw_priv.h
+*
+*  @brief   Private Definitions for low level DMA driver
+*
+*/
+/****************************************************************************/
+
+#ifndef _DMACHW_PRIV_H
+#define _DMACHW_PRIV_H
+
+#include <csp/stdint.h>
+
+/* Data type for DMA Link List Item */
+typedef struct
+{
+   uint32_t sar;        /* Source Adress Register.
+                           Address must be aligned to CTLx.SRC_TR_WIDTH.             */
+   uint32_t dar;        /* Destination Address Register.
+                           Address must be aligned to CTLx.DST_TR_WIDTH.             */
+   uint32_t llpPhy;     /* LLP contains the physical address of the next descriptor for block chaining using linked lists.
+                           Address MUST be aligned to a 32-bit boundary.             */
+   dmacHw_REG64_t ctl;  /* Control Register. 64 bits */
+   uint32_t sstat;      /* Source Status Register */
+   uint32_t dstat;      /* Destination Status Register */
+   uint32_t devCtl;     /* Device specific control information */
+   uint32_t llp;        /* LLP contains the virtual address of the next descriptor for block chaining using linked lists. */
+} dmacHw_DESC_t;
+
+
+/*
+ *  Descriptor ring pointers
+ */
+typedef struct
+{
+   int    num;               /* Number of link items */
+   dmacHw_DESC_t *pHead;     /* Head of descriptor ring (for writing) */
+   dmacHw_DESC_t *pTail;     /* Tail of descriptor ring (for reading) */
+   dmacHw_DESC_t *pProg;     /* Descriptor to program the channel (for programming the channel register) */
+   dmacHw_DESC_t *pEnd;      /* End of current descriptor chain */
+   dmacHw_DESC_t *pFree;     /* Descriptor to free memory (freeing dynamic memory) */
+   uint32_t virt2PhyOffset;  /* Virtual to physical address offset for the descriptor ring */
+} dmacHw_DESC_RING_t;
+
+
+/*
+ *  DMA channel control block
+ */
+typedef struct
+{
+   uint32_t                    module;              /* DMA controller module (0-1) */
+   uint32_t                    channel;             /* DMA channel (0-7) */
+   volatile uint32_t           varDataStarted;      /* Flag indicating variable data channel is enabled */
+   volatile uint32_t           descUpdated;         /* Flag to indicate descriptor update is complete */
+   void*                       userData;            /* Channel specifc user data */
+} dmacHw_CBLK_t;
+
+
+#define dmacHw_ASSERT(a)                  if (!(a)) while(1)
+#define dmacHw_MAX_CHANNEL_COUNT          16
+#define dmacHw_FREE_USER_MEMORY           0xFFFFFFFF
+#define dmacHw_DESC_FREE                  dmacHw_REG_CTL_DONE
+#define dmacHw_DESC_INIT                  ((dmacHw_DESC_t *) 0xFFFFFFFF)
+#define dmacHw_MAX_BLOCKSIZE              4064
+#define dmacHw_GET_DESC_RING(addr)        (dmacHw_DESC_RING_t *)(addr)
+#define dmacHw_ADDRESS_MASK(byte)         ((byte) - 1)
+#define dmacHw_NEXT_DESC(rp,dp)           ((rp)->dp = (dmacHw_DESC_t*)(rp)->dp->llp)
+#define dmacHw_HANDLE_TO_CBLK(handle)     ((dmacHw_CBLK_t *) (handle))
+#define dmacHw_CBLK_TO_HANDLE(cblkp)      ((dmacHw_HANDLE_t) (cblkp))
+#define dmacHw_DST_IS_MEMORY(tt)          (((tt) ==  dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM) || ((tt) == dmacHw_TRANSFER_TYPE_MEM_TO_MEM)) ? 1 : 0
+
+
+/****************************************************************************/
+/**
+*  @brief   Get next available transaction width
+*
+*
+*  @return  On sucess  : Next avail able transaction width
+*           On failure : dmacHw_TRANSACTION_WIDTH_8
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static inline dmacHw_TRANSACTION_WIDTH_e dmacHw_GetNextTrWidth
+(
+   dmacHw_TRANSACTION_WIDTH_e tw             ///<   [ IN ] Current transaction width
+)
+{
+    if ( tw & dmacHw_REG_CTL_SRC_TR_WIDTH_MASK )
+    {
+       return ( ( ( tw >> dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT ) - 1 ) << dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT );
+    }
+    else if ( tw & dmacHw_REG_CTL_DST_TR_WIDTH_MASK )
+    {
+       return ( ( ( tw >> dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT ) - 1 ) << dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT );
+    }
+
+    /* Default return  */
+    return dmacHw_SRC_TRANSACTION_WIDTH_8;
+}
+
+
+/****************************************************************************/
+/**
+*  @brief   Get number of bytes per transaction
+*
+*  @return  Number of bytes per transaction
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static inline int dmacHw_GetTrWidthInBytes
+(
+   dmacHw_TRANSACTION_WIDTH_e tw             ///<   [ IN ]  Transaction width
+)
+{
+   int width = 1;
+   switch ( tw )
+   {
+      case dmacHw_SRC_TRANSACTION_WIDTH_8:
+         width = 1;
+         break;
+      case dmacHw_SRC_TRANSACTION_WIDTH_16:
+      case dmacHw_DST_TRANSACTION_WIDTH_16:
+         width = 2;
+         break;
+      case dmacHw_SRC_TRANSACTION_WIDTH_32:
+      case dmacHw_DST_TRANSACTION_WIDTH_32:
+         width = 4;
+         break;
+      case dmacHw_SRC_TRANSACTION_WIDTH_64:
+      case dmacHw_DST_TRANSACTION_WIDTH_64:
+         width = 8;
+         break;
+      default: dmacHw_ASSERT ( 0 );
+   }
+
+   /* Default transaction width */
+   return width;
+}
+
+
+#endif /* _DMACHW_PRIV_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
new file mode 100644
index 0000000..ec3dccc
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
@@ -0,0 +1,430 @@
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
+
+
+
+/****************************************************************************/
+/**
+*  @file    dmacHw_reg.h
+*
+*  @brief   Definitions for low level DMA registers
+*
+*/
+/****************************************************************************/
+
+#ifndef _DMACHW_REG_H
+#define _DMACHW_REG_H
+
+#include <csp/stdint.h>
+#include <mach/csp/mm_io.h>
+
+/* Data type for 64 bit little endian register */
+typedef struct
+{
+   volatile uint32_t lo;                  /* Lower 32 bit in little endian mode */
+   volatile uint32_t hi;                  /* Upper 32 bit in little endian mode */
+}dmacHw_REG64_t;
+
+
+/* Data type representing DMA channel registers */
+typedef struct
+{
+   dmacHw_REG64_t ChannelSar;       /*  Source Adress Register. 64 bits (upper 32 bits are reserved)
+                                        Address must be aligned to CTLx.SRC_TR_WIDTH.
+                                    */
+   dmacHw_REG64_t ChannelDar;       /*  Destination Address Register.64 bits (upper 32 bits are reserved)
+                                        Address must be aligned to CTLx.DST_TR_WIDTH.
+                                    */
+   dmacHw_REG64_t ChannelLlp;       /*  Link List Pointer.64 bits (upper 32 bits are reserved)
+                                        LLP contains the pointer to the next LLI for block chaining using linked lists.
+                                        If LLPis set to 0x0, then transfers using linked lists are not enabled.
+                                        Address MUST be aligned to a 32-bit boundary.
+                                    */
+   dmacHw_REG64_t ChannelCtl;       /* Control Register. 64 bits */
+   dmacHw_REG64_t ChannelSstat;     /* Source Status Register */
+   dmacHw_REG64_t ChannelDstat;     /* Destination Status Register */
+   dmacHw_REG64_t ChannelSstatAddr; /* Source Status Address Register */
+   dmacHw_REG64_t ChannelDstatAddr; /* Destination Status Address Register */
+   dmacHw_REG64_t ChannelConfig;    /* Channel Configuration Register */
+   dmacHw_REG64_t SrcGather;        /* Source gather register */
+   dmacHw_REG64_t DstScatter;       /* Destination scatter register */
+}dmacHw_CH_REG_t;
+
+
+/* Data type for RAW interrupt status registers */
+typedef struct
+{
+   dmacHw_REG64_t RawTfr;       /* Raw Status for IntTfr Interrupt */
+   dmacHw_REG64_t RawBlock;     /* Raw Status for IntBlock Interrupt */
+   dmacHw_REG64_t RawSrcTran;   /* Raw Status for IntSrcTran Interrupt */
+   dmacHw_REG64_t RawDstTran;   /* Raw Status for IntDstTran Interrupt */
+   dmacHw_REG64_t RawErr;       /* Raw Status for IntErr Interrupt */
+}dmacHw_INT_RAW_t;
+
+/* Data type for interrupt status registers */
+typedef struct
+{
+   dmacHw_REG64_t StatusTfr;     /* Status for IntTfr Interrupt */
+   dmacHw_REG64_t StatusBlock;   /* Status for IntBlock Interrupt */
+   dmacHw_REG64_t StatusSrcTran; /* Status for IntSrcTran Interrupt */
+   dmacHw_REG64_t StatusDstTran; /* Status for IntDstTran Interrupt */
+   dmacHw_REG64_t StatusErr;     /* Status for IntErr Interrupt */
+}dmacHw_INT_STATUS_t;
+
+
+/* Data type for interrupt mask registers*/
+typedef struct
+{
+   dmacHw_REG64_t MaskTfr;      /* Mask for IntTfr Interrupt */
+   dmacHw_REG64_t MaskBlock;    /* Mask for IntBlock Interrupt */
+   dmacHw_REG64_t MaskSrcTran;  /* Mask for IntSrcTran Interrupt */
+   dmacHw_REG64_t MaskDstTran;  /* Mask for IntDstTran Interrupt */
+   dmacHw_REG64_t MaskErr;      /* Mask for IntErr Interrupt */
+}dmacHw_INT_MASK_t;
+
+
+/* Data type for interrupt clear registers */
+typedef struct
+{
+   dmacHw_REG64_t ClearTfr;      /* Clear for IntTfr Interrupt */
+   dmacHw_REG64_t ClearBlock;    /* Clear for IntBlock Interrupt */
+   dmacHw_REG64_t ClearSrcTran;  /* Clear for IntSrcTran Interrupt */
+   dmacHw_REG64_t ClearDstTran;  /* Clear for IntDstTran Interrupt */
+   dmacHw_REG64_t ClearErr;      /* Clear for IntErr Interrupt */
+   dmacHw_REG64_t StatusInt;     /* Status for each interrupt type */
+}dmacHw_INT_CLEAR_t;
+
+
+/* Data type for software handshaking registers */
+typedef struct
+{
+   dmacHw_REG64_t ReqSrcReg;     /* Source Software Transaction Request Register */
+   dmacHw_REG64_t ReqDstReg;     /* Destination Software Transaction Request Register */
+   dmacHw_REG64_t SglReqSrcReg;  /* Single Source Transaction Request Register */
+   dmacHw_REG64_t SglReqDstReg;  /* Single Destination Transaction Request Register */
+   dmacHw_REG64_t LstSrcReg;     /* Last Source Transaction Request Register */
+   dmacHw_REG64_t LstDstReg;     /* Last Destination Transaction Request Register */
+}dmacHw_SW_HANDSHAKE_t;
+
+
+/* Data type for misc. registers */
+typedef struct
+{
+   dmacHw_REG64_t DmaCfgReg;     /* DMA Configuration Register */
+   dmacHw_REG64_t ChEnReg;       /* DMA Channel Enable Register */
+   dmacHw_REG64_t DmaIdReg;      /* DMA ID Register */
+   dmacHw_REG64_t DmaTestReg;    /* DMA Test Register */
+   dmacHw_REG64_t Reserved0;     /* Reserved*/
+   dmacHw_REG64_t Reserved1;     /* Reserved*/
+   dmacHw_REG64_t CompParm6;     /* Component Parameter 6 */
+   dmacHw_REG64_t CompParm5;     /* Component Parameter 5 */
+   dmacHw_REG64_t CompParm4;     /* Component Parameter 4 */
+   dmacHw_REG64_t CompParm3;     /* Component Parameter 3 */
+   dmacHw_REG64_t CompParm2;     /* Component Parameter 2 */
+   dmacHw_REG64_t CompParm1;     /* Component Parameter 1 */
+   dmacHw_REG64_t CompId;        /* Compoent ID */
+}dmacHw_MISC_t;
+
+
+
+/* Base registers */
+#define dmacHw_0_MODULE_BASE_ADDR        (char*) MM_IO_BASE_DMA0 /* DMAC 0 module's base address */
+#define dmacHw_1_MODULE_BASE_ADDR        (char*) MM_IO_BASE_DMA1 /* DMAC 1 module's base address */
+
+extern uint32_t dmaChannelCount_0;
+extern uint32_t dmaChannelCount_1;
+
+/* Define channel specific registers */
+#define dmacHw_CHAN_BASE(module, chan)          ((dmacHw_CH_REG_t*) ( (char*)((module) ? dmacHw_1_MODULE_BASE_ADDR : dmacHw_0_MODULE_BASE_ADDR) + ((chan) * sizeof(dmacHw_CH_REG_t))))
+
+/* Raw interrupt status registers */
+#define dmacHw_REG_INT_RAW_BASE(module)         ((char*)dmacHw_CHAN_BASE((module), ((module) ? dmaChannelCount_1 : dmaChannelCount_0)))
+#define dmacHw_REG_INT_RAW_TRAN(module)         (((dmacHw_INT_RAW_t*) dmacHw_REG_INT_RAW_BASE((module)))->RawTfr.lo)
+#define dmacHw_REG_INT_RAW_BLOCK(module)        (((dmacHw_INT_RAW_t*) dmacHw_REG_INT_RAW_BASE((module)))->RawBlock.lo)
+#define dmacHw_REG_INT_RAW_STRAN(module)        (((dmacHw_INT_RAW_t*) dmacHw_REG_INT_RAW_BASE((module)))->RawSrcTran.lo)
+#define dmacHw_REG_INT_RAW_DTRAN(module)        (((dmacHw_INT_RAW_t*) dmacHw_REG_INT_RAW_BASE((module)))->RawDstTran.lo)
+#define dmacHw_REG_INT_RAW_ERROR(module)        (((dmacHw_INT_RAW_t*) dmacHw_REG_INT_RAW_BASE((module)))->RawErr.lo)
+
+/* Interrupt status registers */
+#define dmacHw_REG_INT_STAT_BASE(module)        ((char*)(dmacHw_REG_INT_RAW_BASE((module)) + sizeof(dmacHw_INT_RAW_t)))
+#define dmacHw_REG_INT_STAT_TRAN(module)        (((dmacHw_INT_STATUS_t*) dmacHw_REG_INT_STAT_BASE((module)))->StatusTfr.lo)
+#define dmacHw_REG_INT_STAT_BLOCK(module)       (((dmacHw_INT_STATUS_t*) dmacHw_REG_INT_STAT_BASE((module)))->StatusBlock.lo)
+#define dmacHw_REG_INT_STAT_STRAN(module)       (((dmacHw_INT_STATUS_t*) dmacHw_REG_INT_STAT_BASE((module)))->StatusSrcTran.lo)
+#define dmacHw_REG_INT_STAT_DTRAN(module)       (((dmacHw_INT_STATUS_t*) dmacHw_REG_INT_STAT_BASE((module)))->StatusDstTran.lo)
+#define dmacHw_REG_INT_STAT_ERROR(module)       (((dmacHw_INT_STATUS_t*) dmacHw_REG_INT_STAT_BASE((module)))->StatusErr.lo)
+
+/* Interrupt status registers */
+#define dmacHw_REG_INT_MASK_BASE(module)        ((char*)(dmacHw_REG_INT_STAT_BASE((module)) + sizeof(dmacHw_INT_STATUS_t)))
+#define dmacHw_REG_INT_MASK_TRAN(module)        (((dmacHw_INT_MASK_t*) dmacHw_REG_INT_MASK_BASE((module)))->MaskTfr.lo)
+#define dmacHw_REG_INT_MASK_BLOCK(module)       (((dmacHw_INT_MASK_t*) dmacHw_REG_INT_MASK_BASE((module)))->MaskBlock.lo)
+#define dmacHw_REG_INT_MASK_STRAN(module)       (((dmacHw_INT_MASK_t*) dmacHw_REG_INT_MASK_BASE((module)))->MaskSrcTran.lo)
+#define dmacHw_REG_INT_MASK_DTRAN(module)       (((dmacHw_INT_MASK_t*) dmacHw_REG_INT_MASK_BASE((module)))->MaskDstTran.lo)
+#define dmacHw_REG_INT_MASK_ERROR(module)       (((dmacHw_INT_MASK_t*) dmacHw_REG_INT_MASK_BASE((module)))->MaskErr.lo)
+
+/* Interrupt clear registers */
+#define dmacHw_REG_INT_CLEAR_BASE(module)       ((char*)(dmacHw_REG_INT_MASK_BASE((module)) + sizeof(dmacHw_INT_MASK_t)))
+#define dmacHw_REG_INT_CLEAR_TRAN(module)       (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearTfr.lo)
+#define dmacHw_REG_INT_CLEAR_BLOCK(module)      (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearBlock.lo)
+#define dmacHw_REG_INT_CLEAR_STRAN(module)      (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearSrcTran.lo)
+#define dmacHw_REG_INT_CLEAR_DTRAN(module)      (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearDstTran.lo)
+#define dmacHw_REG_INT_CLEAR_ERROR(module)      (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearErr.lo)
+#define dmacHw_REG_INT_STATUS(module)           (((dmacHw_INT_CLEAR_t*) dmacHw_REG_INT_CLEAR_BASE((module)))->StatusInt.lo)
+
+/* Software handshaking registers */
+#define dmacHw_REG_SW_HS_BASE(module)           ((char*)(dmacHw_REG_INT_CLEAR_BASE((module)) + sizeof(dmacHw_INT_CLEAR_t)))
+#define dmacHw_REG_SW_HS_SRC_REQ(module)        (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->ReqSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_REQ(module)        (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->ReqDstReg.lo)
+#define dmacHw_REG_SW_HS_SRC_SGL_REQ(module)    (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->SglReqSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_SGL_REQ(module)    (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->SglReqDstReg.lo)
+#define dmacHw_REG_SW_HS_SRC_LST_REQ(module)    (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->LstSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_LST_REQ(module)    (((dmacHw_SW_HANDSHAKE_t*) dmacHw_REG_SW_HS_BASE((module)))->LstDstReg.lo)
+
+/* Miscellaneous registers */
+#define dmacHw_REG_MISC_BASE(module)            ((char*)(dmacHw_REG_SW_HS_BASE((module)) + sizeof(dmacHw_SW_HANDSHAKE_t)))
+#define dmacHw_REG_MISC_CFG(module)             (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->DmaCfgReg.lo)
+#define dmacHw_REG_MISC_CH_ENABLE(module)       (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->ChEnReg.lo)
+#define dmacHw_REG_MISC_ID(module)              (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->DmaIdReg.lo)
+#define dmacHw_REG_MISC_TEST(module)            (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->DmaTestReg.lo)
+#define dmacHw_REG_MISC_COMP_PARAM1_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm1.lo)
+#define dmacHw_REG_MISC_COMP_PARAM1_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm1.hi)
+#define dmacHw_REG_MISC_COMP_PARAM2_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm2.lo)
+#define dmacHw_REG_MISC_COMP_PARAM2_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm2.hi)
+#define dmacHw_REG_MISC_COMP_PARAM3_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm3.lo)
+#define dmacHw_REG_MISC_COMP_PARAM3_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm3.hi)
+#define dmacHw_REG_MISC_COMP_PARAM4_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm4.lo)
+#define dmacHw_REG_MISC_COMP_PARAM4_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm4.hi)
+#define dmacHw_REG_MISC_COMP_PARAM5_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm5.lo)
+#define dmacHw_REG_MISC_COMP_PARAM5_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm5.hi)
+#define dmacHw_REG_MISC_COMP_PARAM6_LO(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm6.lo)
+#define dmacHw_REG_MISC_COMP_PARAM6_HI(module)  (((dmacHw_MISC_t*) dmacHw_REG_MISC_BASE((module)))->CompParm6.hi)
+
+
+/* Channel control registers */
+#define dmacHw_REG_SAR(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelSar.lo)
+#define dmacHw_REG_DAR(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelDar.lo)
+#define dmacHw_REG_LLP(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelLlp.lo)
+
+#define dmacHw_REG_CTL_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelCtl.lo)
+#define dmacHw_REG_CTL_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelCtl.hi)
+
+#define dmacHw_REG_SSTAT(module, chan)          (dmacHw_CHAN_BASE((module), (chan))->ChannelSstat.lo)
+#define dmacHw_REG_DSTAT(module, chan)          (dmacHw_CHAN_BASE((module), (chan))->ChannelDstat.lo)
+#define dmacHw_REG_SSTATAR(module, chan)        (dmacHw_CHAN_BASE((module), (chan))->ChannelSstatAddr.lo)
+#define dmacHw_REG_DSTATAR(module, chan)        (dmacHw_CHAN_BASE((module), (chan))->ChannelDstatAddr.lo)
+
+#define dmacHw_REG_CFG_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelConfig.lo)
+#define dmacHw_REG_CFG_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelConfig.hi)
+
+#define dmacHw_REG_SGR_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->SrcGather.lo)
+#define dmacHw_REG_SGR_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->SrcGather.hi)
+
+#define dmacHw_REG_DSR_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->DstScatter.lo)
+#define dmacHw_REG_DSR_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->DstScatter.hi)
+
+
+
+#define INT_STATUS_MASK(channel)                (0x00000001 << (channel))
+#define CHANNEL_BUSY(mod, channel)              (dmacHw_REG_MISC_CH_ENABLE((mod)) & (0x00000001 << (channel)))
+
+/* Bit mask for REG_DMACx_CTL_LO */
+
+#define dmacHw_REG_CTL_INT_EN                       0x00000001   /* Channel interrupt enable */
+
+#define dmacHw_REG_CTL_DST_TR_WIDTH_MASK            0x0000000E   /* Destination transaction width mask */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT           1
+#define dmacHw_REG_CTL_DST_TR_WIDTH_8               0x00000000   /* Destination transaction width 8 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_16              0x00000002   /* Destination transaction width 16 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_32              0x00000004   /* Destination transaction width 32 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_64              0x00000006   /* Destination transaction width 64 bit */
+
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_MASK            0x00000070   /* Source transaction width mask */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT           4
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_8               0x00000000   /* Source transaction width 8 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_16              0x00000010   /* Source transaction width 16 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_32              0x00000020   /* Source transaction width 32 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_64              0x00000030   /* Source transaction width 64 bit */
+
+#define dmacHw_REG_CTL_DS_ENABLE                    0x00040000   /* Destination scatter enable */
+#define dmacHw_REG_CTL_SG_ENABLE                    0x00020000   /* Source gather enable */
+
+#define dmacHw_REG_CTL_DINC_MASK                    0x00000180   /* Destination address inc/dec mask */
+#define dmacHw_REG_CTL_DINC_INC                     0x00000000   /* Destination address increment */
+#define dmacHw_REG_CTL_DINC_DEC                     0x00000080   /* Destination address decrement */
+#define dmacHw_REG_CTL_DINC_NC                      0x00000100   /* Destination address no change */
+
+#define dmacHw_REG_CTL_SINC_MASK                    0x00000600   /* Source address inc/dec mask */
+#define dmacHw_REG_CTL_SINC_INC                     0x00000000   /* Source address increment */
+#define dmacHw_REG_CTL_SINC_DEC                     0x00000200   /* Source address decrement */
+#define dmacHw_REG_CTL_SINC_NC                      0x00000400   /* Source address no change */
+
+#define dmacHw_REG_CTL_DST_MSIZE_MASK               0x00003800   /* Destination burst transaction length */
+#define dmacHw_REG_CTL_DST_MSIZE_0                  0x00000000   /* No Destination burst */
+#define dmacHw_REG_CTL_DST_MSIZE_4                  0x00000800   /* Destination burst transaction length 4 */
+#define dmacHw_REG_CTL_DST_MSIZE_8                  0x00001000   /* Destination burst transaction length 8 */
+#define dmacHw_REG_CTL_DST_MSIZE_16                 0x00001800   /* Destination burst transaction length 16 */
+
+#define dmacHw_REG_CTL_SRC_MSIZE_MASK               0x0001C000   /* Source burst transaction length */
+#define dmacHw_REG_CTL_SRC_MSIZE_0                  0x00000000   /* No Source burst */
+#define dmacHw_REG_CTL_SRC_MSIZE_4                  0x00004000   /* Source burst transaction length 4 */
+#define dmacHw_REG_CTL_SRC_MSIZE_8                  0x00008000   /* Source burst transaction length 8 */
+#define dmacHw_REG_CTL_SRC_MSIZE_16                 0x0000C000   /* Source burst transaction length 16 */
+
+#define dmacHw_REG_CTL_TTFC_MASK                    0x00700000   /* Transfer type and flow controller */
+#define dmacHw_REG_CTL_TTFC_MM_DMAC                 0x00000000   /* Memory to Memory with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_MP_DMAC                 0x00100000   /* Memory to Peripheral with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PM_DMAC                 0x00200000   /* Peripheral to Memory with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_DMAC                 0x00300000   /* Peripheral to Peripheral with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PM_PERI                 0x00400000   /* Peripheral to Memory with Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_SPERI                0x00500000   /* Peripheral to Peripheral with Source Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_MP_PERI                 0x00600000   /* Memory to Peripheral with Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_DPERI                0x00700000   /* Peripheral to Peripheral with Destination Peripheral as flow controller */
+
+#define dmacHw_REG_CTL_DMS_MASK                     0x01800000   /* Destination AHB master interface */
+#define dmacHw_REG_CTL_DMS_1                        0x00000000   /* Destination AHB master interface 1 */
+#define dmacHw_REG_CTL_DMS_2                        0x00800000   /* Destination AHB master interface 2 */
+
+#define dmacHw_REG_CTL_SMS_MASK                     0x06000000   /* Source AHB master interface */
+#define dmacHw_REG_CTL_SMS_1                        0x00000000   /* Source AHB master interface 1 */
+#define dmacHw_REG_CTL_SMS_2                        0x02000000   /* Source AHB master interface 2 */
+
+#define dmacHw_REG_CTL_LLP_DST_EN                   0x08000000   /* Block chaining enable for destination side */
+#define dmacHw_REG_CTL_LLP_SRC_EN                   0x10000000   /* Block chaining enable for source side */
+
+/* Bit mask for REG_DMACx_CTL_HI */
+#define dmacHw_REG_CTL_BLOCK_TS_MASK                0x00000FFF   /* Block transfer size */
+#define dmacHw_REG_CTL_DONE                         0x00001000   /* Block trasnfer done */
+
+
+/* Bit mask for REG_DMACx_CFG_LO */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_SHIFT                  5   /* Channel priority shift */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_MASK          0x000000E0   /* Channel priority mask */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_0             0x00000000   /* Channel priority 0 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_1             0x00000020   /* Channel priority 1 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_2             0x00000040   /* Channel priority 2 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_3             0x00000060   /* Channel priority 3 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_4             0x00000080   /* Channel priority 4 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_5             0x000000A0   /* Channel priority 5 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_6             0x000000C0   /* Channel priority 6 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_7             0x000000E0   /* Channel priority 7 */
+
+#define dmacHw_REG_CFG_LO_CH_SUSPEND                0x00000100   /* Channel suspend */
+#define dmacHw_REG_CFG_LO_CH_FIFO_EMPTY             0x00000200   /* Channel FIFO empty */
+#define dmacHw_REG_CFG_LO_DST_CH_SW_HS              0x00000400   /* Destination channel SW handshaking */
+#define dmacHw_REG_CFG_LO_SRC_CH_SW_HS              0x00000800   /* Source channel SW handshaking */
+
+#define dmacHw_REG_CFG_LO_CH_LOCK_MASK              0x00003000   /* Channel locking mask */
+#define dmacHw_REG_CFG_LO_CH_LOCK_DMA               0x00000000   /* Channel lock over the entire DMA transfer operation */
+#define dmacHw_REG_CFG_LO_CH_LOCK_BLOCK             0x00001000   /* Channel lock over the block transfer operation */
+#define dmacHw_REG_CFG_LO_CH_LOCK_TRANS             0x00002000   /* Channel lock over the transaction */
+#define dmacHw_REG_CFG_LO_CH_LOCK_ENABLE            0x00010000   /* Channel lock enable */
+
+#define dmacHw_REG_CFG_LO_BUS_LOCK_MASK             0x0000C000   /* Bus locking mask */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_DMA              0x00000000   /* Bus lock over the entire DMA transfer operation */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_BLOCK            0x00004000   /* Bus lock over the block transfer operation */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_TRANS            0x00008000   /* Bus lock over the transaction */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_ENABLE           0x00020000   /* Bus lock enable */
+
+#define dmacHw_REG_CFG_LO_DST_HS_POLARITY_LOW       0x00040000   /* Destination channel handshaking signal polarity low */
+#define dmacHw_REG_CFG_LO_SRC_HS_POLARITY_LOW       0x00080000   /* Source channel handshaking signal polarity low */
+
+#define dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK   0x3FF00000   /* Maximum AMBA burst length */
+
+#define dmacHw_REG_CFG_LO_AUTO_RELOAD_SRC           0x40000000   /* Source address auto reload */
+#define dmacHw_REG_CFG_LO_AUTO_RELOAD_DST           0x80000000   /* Destination address auto reload */
+
+/* Bit mask for REG_DMACx_CFG_HI */
+#define dmacHw_REG_CFG_HI_FC_DST_READY              0x00000001   /* Source transaction request is serviced when destination is ready */
+#define dmacHw_REG_CFG_HI_FIFO_ENOUGH               0x00000002   /* Initiate burst transaction when enough data in available in FIFO */
+
+#define dmacHw_REG_CFG_HI_AHB_HPROT_MASK            0x0000001C   /* AHB protection mask */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_1               0x00000004   /* AHB protection 1 */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_2               0x00000008   /* AHB protection 2 */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_3               0x00000010   /* AHB protection 3 */
+
+#define dmacHw_REG_CFG_HI_UPDATE_DST_STAT           0x00000020   /* Destination status update enable */
+#define dmacHw_REG_CFG_HI_UPDATE_SRC_STAT           0x00000040   /* Source status update enable */
+
+#define dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK        0x00000780   /* Source peripheral hardware interface mask */
+#define dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK        0x00007800   /* Destination peripheral hardware interface mask */
+
+/* DMA Configuration Parameters */
+#define dmacHw_REG_COMP_PARAM_NUM_CHANNELS          0x00000700   /* Number of channels */
+#define dmacHw_REG_COMP_PARAM_NUM_INTERFACE         0x00001800   /* Number of master interface */
+#define dmacHw_REG_COMP_PARAM_MAX_BLK_SIZE          0x0000000f   /* Maximum brust size */
+#define dmacHw_REG_COMP_PARAM_DATA_WIDTH            0x00006000   /* Data transfer width */
+
+/* Define GET/SET macros to program the registers */
+#define dmacHw_SET_SAR(module, channel, addr)          (dmacHw_REG_SAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_DAR(module, channel, addr)          (dmacHw_REG_DAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_LLP(module, channel, ptr)           (dmacHw_REG_LLP((module), (channel)) = (uint32_t) (ptr))
+
+#define dmacHw_GET_SSTAT(module, channel)              (dmacHw_REG_SSTAT((module), (channel)))
+#define dmacHw_GET_DSTAT(module, channel)              (dmacHw_REG_DSTAT((module), (channel)))
+
+#define dmacHw_SET_SSTATAR(module, channel, addr)      (dmacHw_REG_SSTATAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_DSTATAR(module, channel, addr)      (dmacHw_REG_DSTATAR((module), (channel)) = (uint32_t) (addr))
+
+#define dmacHw_SET_CONTROL_LO(module, channel, ctl)    (dmacHw_REG_CTL_LO((module), (channel)) |= (ctl))
+#define dmacHw_RESET_CONTROL_LO(module, channel)       (dmacHw_REG_CTL_LO((module), (channel)) = 0)
+#define dmacHw_GET_CONTROL_LO(module, channel)         (dmacHw_REG_CTL_LO((module), (channel)))
+
+#define dmacHw_SET_CONTROL_HI(module, channel, ctl)    (dmacHw_REG_CTL_HI((module), (channel)) |= (ctl))
+#define dmacHw_RESET_CONTROL_HI(module, channel)       (dmacHw_REG_CTL_HI((module), (channel)) = 0)
+#define dmacHw_GET_CONTROL_HI(module, channel)         (dmacHw_REG_CTL_HI((module), (channel)))
+
+#define dmacHw_GET_BLOCK_SIZE(module, channel)         (dmacHw_REG_CTL_HI((module), (channel)) & dmacHw_REG_CTL_BLOCK_TS_MASK)
+#define dmacHw_DMA_COMPLETE(module, channel)           (dmacHw_REG_CTL_HI((module), (channel)) & dmacHw_REG_CTL_DONE)
+
+#define dmacHw_SET_CONFIG_LO(module, channel, cfg)     (dmacHw_REG_CFG_LO((module), (channel)) |= (cfg))
+#define dmacHw_RESET_CONFIG_LO(module, channel)        (dmacHw_REG_CFG_LO((module), (channel)) = 0)
+#define dmacHw_GET_CONFIG_LO(module, channel)          (dmacHw_REG_CFG_LO((module), (channel)))
+#define dmacHw_SET_AMBA_BUSRT_LEN(module, channel, len)    (dmacHw_REG_CFG_LO((module), (channel)) = (dmacHw_REG_CFG_LO((module), (channel)) & ~(dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK)) | (((len) << 20) & dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK))
+#define dmacHw_SET_CHANNEL_PRIORITY(module, channel, prio) (dmacHw_REG_CFG_LO((module), (channel)) = (dmacHw_REG_CFG_LO((module), (channel)) & ~(dmacHw_REG_CFG_LO_CH_PRIORITY_MASK)) | (prio))
+#define dmacHw_SET_AHB_HPROT(module, channel, protect)  (dmacHw_REG_CFG_HI(module, channel) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_AHB_HPROT_MASK    )) | (protect))
+
+#define dmacHw_SET_CONFIG_HI(module, channel, cfg)      (dmacHw_REG_CFG_HI((module), (channel)) |= (cfg))
+#define dmacHw_RESET_CONFIG_HI(module, channel)         (dmacHw_REG_CFG_HI((module), (channel)) = 0)
+#define dmacHw_GET_CONFIG_HI(module, channel)           (dmacHw_REG_CFG_HI((module), (channel)))
+#define dmacHw_SET_SRC_PERI_INTF(module, channel, intf) (dmacHw_REG_CFG_HI((module), (channel)) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK)) | (((intf) << 7) & dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK))
+#define dmacHw_SRC_PERI_INTF(intf)                      (((intf) << 7) & dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK)
+#define dmacHw_SET_DST_PERI_INTF(module, channel, intf) (dmacHw_REG_CFG_HI((module), (channel)) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK)) | (((intf) << 11) & dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK))
+#define dmacHw_DST_PERI_INTF(intf)                      (((intf) << 11) & dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK)
+
+#define dmacHw_DMA_START(module, channel)              (dmacHw_REG_MISC_CH_ENABLE((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_DMA_STOP(module, channel)               (dmacHw_REG_MISC_CH_ENABLE((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_DMA_ENABLE(module)                      (dmacHw_REG_MISC_CFG((module)) = 1)
+#define dmacHw_DMA_DISABLE(module)                     (dmacHw_REG_MISC_CFG((module)) = 0)
+
+#define dmacHw_TRAN_INT_ENABLE(module, channel)        (dmacHw_REG_INT_MASK_TRAN((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_BLOCK_INT_ENABLE(module, channel)       (dmacHw_REG_INT_MASK_BLOCK((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_ERROR_INT_ENABLE(module, channel)       (dmacHw_REG_INT_MASK_ERROR((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+
+#define dmacHw_TRAN_INT_DISABLE(module, channel)       (dmacHw_REG_INT_MASK_TRAN((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_BLOCK_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_BLOCK((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_ERROR_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_ERROR((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_STRAN_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_STRAN((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_DTRAN_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_DTRAN((module)) = (0x00000001 << ((channel) + 8)))
+
+#define dmacHw_TRAN_INT_CLEAR(module, channel)         (dmacHw_REG_INT_CLEAR_TRAN((module)) = (0x00000001 << (channel)))
+#define dmacHw_BLOCK_INT_CLEAR(module, channel)        (dmacHw_REG_INT_CLEAR_BLOCK((module)) = (0x00000001 << (channel)))
+#define dmacHw_ERROR_INT_CLEAR(module, channel)        (dmacHw_REG_INT_CLEAR_ERROR((module)) = (0x00000001 << (channel)))
+
+
+#define dmacHw_GET_NUM_CHANNEL(module)                 (((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_NUM_CHANNELS) >> 8) + 1)
+#define dmacHw_GET_NUM_INTERFACE(module)               (((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_NUM_INTERFACE) >> 11) + 1)
+#define dmacHw_GET_MAX_BLOCK_SIZE(module, channel)     ((dmacHw_REG_MISC_COMP_PARAM1_LO((module)) >> (4 * (channel))) & dmacHw_REG_COMP_PARAM_MAX_BLK_SIZE )
+#define dmacHw_GET_CHANNEL_DATA_WIDTH(module, channel) ((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_DATA_WIDTH) >> 13)
+
+#endif /* _DMACHW_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h b/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
new file mode 100644
index 0000000..189d98e
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
@@ -0,0 +1,78 @@
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
+
+#ifndef CSP_HW_CFG_H
+#define CSP_HW_CFG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <cfg_global.h>
+#include <mach/csp/cap_inline.h>
+
+#if defined( __KERNEL__ )
+#include <mach/memory_settings.h>
+#else
+#include <hw_cfg.h>
+#endif
+
+// Some items that can be defined externally, but will be set to default values
+// if they are not defined.
+//
+//      HW_CFG_PLL_SPREAD_SPECTRUM_DISABLE  // Default undefined and SS is enabled.
+//      HW_CFG_SDRAM_CAS_LATENCY        5   // Default 5, Values [3..6]
+//      HW_CFG_SDRAM_CHIP_SELECT_CNT    1   // Default 1, Vaules [1..2]
+//      HW_CFG_SDRAM_SPEED_GRADE        667 // Default 667, Values [400,533,667,800]
+//      HW_CFG_SDRAM_WIDTH_BITS         16  // Default 16, Vaules [8,16]
+//      HW_CFG_SDRAM_ADDR_BRC               // Default undefined and Row-Bank-Col (RBC) addressing used. Define to use Bank-Row-Col (BRC).
+//      HW_CFG_SDRAM_CLK_ASYNC              // Default undefined and DDR clock is synchronous with AXI BUS clock. Define for ASYNC mode.
+
+//#define HW_CFG_PLL_SPREAD_SPECTRUM_DISABLE
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
+     //#define HW_CFG_UART_CLK_HZ           166666666
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
+#endif // CSP_HW_CFG_H
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
new file mode 100644
index 0000000..fdbd33d
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
@@ -0,0 +1,260 @@
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
+
+/****************************************************************************/
+/**
+*  @file    intcHw_reg.h
+*
+*  @brief   platform specific interrupt controller bit assignments
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _INTCHW_REG_H
+#define _INTCHW_REG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+#include <csp/reg.h>
+#include <mach/csp/mm_io.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define INTCHW_NUM_IRQ_PER_INTC   32    // Maximum number of interrupt controllers
+#define INTCHW_NUM_INTC           3
+
+// Defines for interrupt controllers. This simplifies and cleans up the function calls.
+#define INTCHW_INTC0    ((void *)MM_IO_BASE_INTC0)
+#define INTCHW_INTC1    ((void *)MM_IO_BASE_INTC1)
+#define INTCHW_SINTC    ((void *)MM_IO_BASE_SINTC)
+
+// INTC0 - interrupt controller 0
+#define INTCHW_INTC0_PIF_BITNUM           31     // Peripheral interface interrupt
+#define INTCHW_INTC0_CLCD_BITNUM          30     // LCD Controller interrupt
+#define INTCHW_INTC0_GE_BITNUM            29     // Graphic engine interrupt
+#define INTCHW_INTC0_APM_BITNUM           28     // Audio process module interrupt
+#define INTCHW_INTC0_ESW_BITNUM           27     // Ethernet switch interrupt
+#define INTCHW_INTC0_SPIH_BITNUM          26     // SPI host interrupt
+#define INTCHW_INTC0_TIMER3_BITNUM        25     // Timer3 interrupt
+#define INTCHW_INTC0_TIMER2_BITNUM        24     // Timer2 interrupt
+#define INTCHW_INTC0_TIMER1_BITNUM        23     // Timer1 interrupt
+#define INTCHW_INTC0_TIMER0_BITNUM        22     // Timer0 interrupt
+#define INTCHW_INTC0_SDIOH1_BITNUM        21     // SDIO1 host interrupt
+#define INTCHW_INTC0_SDIOH0_BITNUM        20     // SDIO0 host interrupt
+#define INTCHW_INTC0_USBD_BITNUM          19     // USB device interrupt
+#define INTCHW_INTC0_USBH1_BITNUM         18     // USB1 host interrupt
+#define INTCHW_INTC0_USBHD2_BITNUM        17     // USB host2/device2 interrupt
+#define INTCHW_INTC0_VPM_BITNUM           16     // Voice process module interrupt
+#define INTCHW_INTC0_DMA1C7_BITNUM        15     // DMA1 channel 7 interrupt
+#define INTCHW_INTC0_DMA1C6_BITNUM        14     // DMA1 channel 6 interrupt
+#define INTCHW_INTC0_DMA1C5_BITNUM        13     // DMA1 channel 5 interrupt
+#define INTCHW_INTC0_DMA1C4_BITNUM        12     // DMA1 channel 4 interrupt
+#define INTCHW_INTC0_DMA1C3_BITNUM        11     // DMA1 channel 3 interrupt
+#define INTCHW_INTC0_DMA1C2_BITNUM        10     // DMA1 channel 2 interrupt
+#define INTCHW_INTC0_DMA1C1_BITNUM         9     // DMA1 channel 1 interrupt
+#define INTCHW_INTC0_DMA1C0_BITNUM         8     // DMA1 channel 0 interrupt
+#define INTCHW_INTC0_DMA0C7_BITNUM         7     // DMA0 channel 7 interrupt
+#define INTCHW_INTC0_DMA0C6_BITNUM         6     // DMA0 channel 6 interrupt
+#define INTCHW_INTC0_DMA0C5_BITNUM         5     // DMA0 channel 5 interrupt
+#define INTCHW_INTC0_DMA0C4_BITNUM         4     // DMA0 channel 4 interrupt
+#define INTCHW_INTC0_DMA0C3_BITNUM         3     // DMA0 channel 3 interrupt
+#define INTCHW_INTC0_DMA0C2_BITNUM         2     // DMA0 channel 2 interrupt
+#define INTCHW_INTC0_DMA0C1_BITNUM         1     // DMA0 channel 1 interrupt
+#define INTCHW_INTC0_DMA0C0_BITNUM         0     // DMA0 channel 0 interrupt
+
+#define INTCHW_INTC0_PIF                  (1<<INTCHW_INTC0_PIF_BITNUM   )
+#define INTCHW_INTC0_CLCD                 (1<<INTCHW_INTC0_CLCD_BITNUM  )
+#define INTCHW_INTC0_GE                   (1<<INTCHW_INTC0_GE_BITNUM    )
+#define INTCHW_INTC0_APM                  (1<<INTCHW_INTC0_APM_BITNUM   )
+#define INTCHW_INTC0_ESW                  (1<<INTCHW_INTC0_ESW_BITNUM   )
+#define INTCHW_INTC0_SPIH                 (1<<INTCHW_INTC0_SPIH_BITNUM  )
+#define INTCHW_INTC0_TIMER3               (1<<INTCHW_INTC0_TIMER3_BITNUM)
+#define INTCHW_INTC0_TIMER2               (1<<INTCHW_INTC0_TIMER2_BITNUM)
+#define INTCHW_INTC0_TIMER1               (1<<INTCHW_INTC0_TIMER1_BITNUM)
+#define INTCHW_INTC0_TIMER0               (1<<INTCHW_INTC0_TIMER0_BITNUM)
+#define INTCHW_INTC0_SDIOH1               (1<<INTCHW_INTC0_SDIOH1_BITNUM)
+#define INTCHW_INTC0_SDIOH0               (1<<INTCHW_INTC0_SDIOH0_BITNUM)
+#define INTCHW_INTC0_USBD                 (1<<INTCHW_INTC0_USBD_BITNUM  )
+#define INTCHW_INTC0_USBH1                (1<<INTCHW_INTC0_USBH1_BITNUM )
+#define INTCHW_INTC0_USBHD2               (1<<INTCHW_INTC0_USBHD2_BITNUM)
+#define INTCHW_INTC0_VPM                  (1<<INTCHW_INTC0_VPM_BITNUM   )
+#define INTCHW_INTC0_DMA1C7               (1<<INTCHW_INTC0_DMA1C7_BITNUM)
+#define INTCHW_INTC0_DMA1C6               (1<<INTCHW_INTC0_DMA1C6_BITNUM)
+#define INTCHW_INTC0_DMA1C5               (1<<INTCHW_INTC0_DMA1C5_BITNUM)
+#define INTCHW_INTC0_DMA1C4               (1<<INTCHW_INTC0_DMA1C4_BITNUM)
+#define INTCHW_INTC0_DMA1C3               (1<<INTCHW_INTC0_DMA1C3_BITNUM)
+#define INTCHW_INTC0_DMA1C2               (1<<INTCHW_INTC0_DMA1C2_BITNUM)
+#define INTCHW_INTC0_DMA1C1               (1<<INTCHW_INTC0_DMA1C1_BITNUM)
+#define INTCHW_INTC0_DMA1C0               (1<<INTCHW_INTC0_DMA1C0_BITNUM)
+#define INTCHW_INTC0_DMA0C7               (1<<INTCHW_INTC0_DMA0C7_BITNUM)
+#define INTCHW_INTC0_DMA0C6               (1<<INTCHW_INTC0_DMA0C6_BITNUM)
+#define INTCHW_INTC0_DMA0C5               (1<<INTCHW_INTC0_DMA0C5_BITNUM)
+#define INTCHW_INTC0_DMA0C4               (1<<INTCHW_INTC0_DMA0C4_BITNUM)
+#define INTCHW_INTC0_DMA0C3               (1<<INTCHW_INTC0_DMA0C3_BITNUM)
+#define INTCHW_INTC0_DMA0C2               (1<<INTCHW_INTC0_DMA0C2_BITNUM)
+#define INTCHW_INTC0_DMA0C1               (1<<INTCHW_INTC0_DMA0C1_BITNUM)
+#define INTCHW_INTC0_DMA0C0               (1<<INTCHW_INTC0_DMA0C0_BITNUM)
+
+
+// INTC1 - interrupt controller 1
+#define INTCHW_INTC1_DDRVPMP_BITNUM       27     // DDR and VPM PLL clock phase relationship interupt (Not for A0)
+#define INTCHW_INTC1_DDRVPMT_BITNUM       26     // DDR and VPM HW phase align timeout interrupt (Not for A0)
+#define INTCHW_INTC1_DDRP_BITNUM          26     // DDR and PLL clock phase relationship interupt (For A0 only))
+#define INTCHW_INTC1_RTC2_BITNUM          25     // Real time clock tamper interrupt
+#define INTCHW_INTC1_VDEC_BITNUM          24     // Hantro Video Decoder interrupt
+// Bits 13-23 are non-secure versions of the corresponding secure bits in SINTC bits 0-10.
+#define INTCHW_INTC1_SPUM_BITNUM          23     // Secure process module interrupt
+#define INTCHW_INTC1_RTC1_BITNUM          22     // Real time clock one-shot interrupt
+#define INTCHW_INTC1_RTC0_BITNUM          21     // Real time clock periodic interrupt
+#define INTCHW_INTC1_RNG_BITNUM           20     // Random number generator interrupt
+#define INTCHW_INTC1_FMPU_BITNUM          19     // Flash memory parition unit interrupt
+#define INTCHW_INTC1_VMPU_BITNUM          18     // VRAM memory partition interrupt
+#define INTCHW_INTC1_DMPU_BITNUM          17     // DDR2 memory partition interrupt
+#define INTCHW_INTC1_KEYC_BITNUM          16     // Key pad controller interrupt
+#define INTCHW_INTC1_TSC_BITNUM           15     // Touch screen controller interrupt
+#define INTCHW_INTC1_UART0_BITNUM         14     // UART 0
+#define INTCHW_INTC1_WDOG_BITNUM          13     // Watchdog timer interrupt
+
+#define INTCHW_INTC1_UART1_BITNUM         12     // UART 1
+#define INTCHW_INTC1_PMUIRQ_BITNUM        11     // ARM performance monitor interrupt
+#define INTCHW_INTC1_COMMRX_BITNUM        10     // ARM DDC receive interrupt
+#define INTCHW_INTC1_COMMTX_BITNUM         9     // ARM DDC transmit interrupt
+#define INTCHW_INTC1_FLASHC_BITNUM         8     // Flash controller interrupt
+#define INTCHW_INTC1_GPHY_BITNUM           7     // Gigabit Phy interrupt
+#define INTCHW_INTC1_SPIS_BITNUM           6     // SPI slave interrupt
+#define INTCHW_INTC1_I2CS_BITNUM           5     // I2C slave interrupt
+#define INTCHW_INTC1_I2CH_BITNUM           4     // I2C host interrupt
+#define INTCHW_INTC1_I2S1_BITNUM           3     // I2S1 interrupt
+#define INTCHW_INTC1_I2S0_BITNUM           2     // I2S0 interrupt
+#define INTCHW_INTC1_GPIO1_BITNUM          1     // GPIO bit 64//32 combined interrupt
+#define INTCHW_INTC1_GPIO0_BITNUM          0     // GPIO bit 31//0 combined interrupt
+
+#define INTCHW_INTC1_DDRVPMT              (1<<INTCHW_INTC1_DDRVPMT_BITNUM)
+#define INTCHW_INTC1_DDRVPMP              (1<<INTCHW_INTC1_DDRVPMP_BITNUM)
+#define INTCHW_INTC1_DDRP                 (1<<INTCHW_INTC1_DDRP_BITNUM  )
+#define INTCHW_INTC1_VDEC                 (1<<INTCHW_INTC1_VDEC_BITNUM  )
+#define INTCHW_INTC1_SPUM                 (1<<INTCHW_INTC1_SPUM_BITNUM  )
+#define INTCHW_INTC1_RTC2                 (1<<INTCHW_INTC1_RTC2_BITNUM  )
+#define INTCHW_INTC1_RTC1                 (1<<INTCHW_INTC1_RTC1_BITNUM  )
+#define INTCHW_INTC1_RTC0                 (1<<INTCHW_INTC1_RTC0_BITNUM  )
+#define INTCHW_INTC1_RNG                  (1<<INTCHW_INTC1_RNG_BITNUM   )
+#define INTCHW_INTC1_FMPU                 (1<<INTCHW_INTC1_FMPU_BITNUM  )
+#define INTCHW_INTC1_IMPU                 (1<<INTCHW_INTC1_IMPU_BITNUM  )
+#define INTCHW_INTC1_DMPU                 (1<<INTCHW_INTC1_DMPU_BITNUM  )
+#define INTCHW_INTC1_KEYC                 (1<<INTCHW_INTC1_KEYC_BITNUM  )
+#define INTCHW_INTC1_TSC                  (1<<INTCHW_INTC1_TSC_BITNUM   )
+#define INTCHW_INTC1_UART0                (1<<INTCHW_INTC1_UART0_BITNUM )
+#define INTCHW_INTC1_WDOG                 (1<<INTCHW_INTC1_WDOG_BITNUM  )
+#define INTCHW_INTC1_UART1                (1<<INTCHW_INTC1_UART1_BITNUM )
+#define INTCHW_INTC1_PMUIRQ               (1<<INTCHW_INTC1_PMUIRQ_BITNUM)
+#define INTCHW_INTC1_COMMRX               (1<<INTCHW_INTC1_COMMRX_BITNUM)
+#define INTCHW_INTC1_COMMTX               (1<<INTCHW_INTC1_COMMTX_BITNUM)
+#define INTCHW_INTC1_FLASHC               (1<<INTCHW_INTC1_FLASHC_BITNUM)
+#define INTCHW_INTC1_GPHY                 (1<<INTCHW_INTC1_GPHY_BITNUM  )
+#define INTCHW_INTC1_SPIS                 (1<<INTCHW_INTC1_SPIS_BITNUM  )
+#define INTCHW_INTC1_I2CS                 (1<<INTCHW_INTC1_I2CS_BITNUM  )
+#define INTCHW_INTC1_I2CH                 (1<<INTCHW_INTC1_I2CH_BITNUM  )
+#define INTCHW_INTC1_I2S1                 (1<<INTCHW_INTC1_I2S1_BITNUM  )
+#define INTCHW_INTC1_I2S0                 (1<<INTCHW_INTC1_I2S0_BITNUM  )
+#define INTCHW_INTC1_GPIO1                (1<<INTCHW_INTC1_GPIO1_BITNUM )
+#define INTCHW_INTC1_GPIO0                (1<<INTCHW_INTC1_GPIO0_BITNUM )
+
+// SINTC secure int controller
+#define INTCHW_SINTC_RTC2_BITNUM          15     // Real time clock tamper interrupt
+#define INTCHW_SINTC_TIMER3_BITNUM        14     // Secure timer3 interrupt
+#define INTCHW_SINTC_TIMER2_BITNUM        13     // Secure timer2 interrupt
+#define INTCHW_SINTC_TIMER1_BITNUM        12     // Secure timer1 interrupt
+#define INTCHW_SINTC_TIMER0_BITNUM        11     // Secure timer0 interrupt
+#define INTCHW_SINTC_SPUM_BITNUM          10     // Secure process module interrupt
+#define INTCHW_SINTC_RTC1_BITNUM           9     // Real time clock one-shot interrupt
+#define INTCHW_SINTC_RTC0_BITNUM           8     // Real time clock periodic interrupt
+#define INTCHW_SINTC_RNG_BITNUM            7     // Random number generator interrupt
+#define INTCHW_SINTC_FMPU_BITNUM           6     // Flash memory parition unit interrupt
+#define INTCHW_SINTC_VMPU_BITNUM           5     // VRAM memory partition interrupt
+#define INTCHW_SINTC_DMPU_BITNUM           4     // DDR2 memory partition interrupt
+#define INTCHW_SINTC_KEYC_BITNUM           3     // Key pad controller interrupt
+#define INTCHW_SINTC_TSC_BITNUM            2     // Touch screen controller interrupt
+#define INTCHW_SINTC_UART0_BITNUM          1     // UART0 interrupt
+#define INTCHW_SINTC_WDOG_BITNUM           0     // Watchdog timer interrupt
+
+#define INTCHW_SINTC_TIMER3               (1<<INTCHW_SINTC_TIMER3_BITNUM)
+#define INTCHW_SINTC_TIMER2               (1<<INTCHW_SINTC_TIMER2_BITNUM)
+#define INTCHW_SINTC_TIMER1               (1<<INTCHW_SINTC_TIMER1_BITNUM)
+#define INTCHW_SINTC_TIMER0               (1<<INTCHW_SINTC_TIMER0_BITNUM)
+#define INTCHW_SINTC_SPUM                 (1<<INTCHW_SINTC_SPUM_BITNUM  )
+#define INTCHW_SINTC_RTC2                 (1<<INTCHW_SINTC_RTC2_BITNUM  )
+#define INTCHW_SINTC_RTC1                 (1<<INTCHW_SINTC_RTC1_BITNUM  )
+#define INTCHW_SINTC_RTC0                 (1<<INTCHW_SINTC_RTC0_BITNUM  )
+#define INTCHW_SINTC_RNG                  (1<<INTCHW_SINTC_RNG_BITNUM   )
+#define INTCHW_SINTC_FMPU                 (1<<INTCHW_SINTC_FMPU_BITNUM  )
+#define INTCHW_SINTC_IMPU                 (1<<INTCHW_SINTC_IMPU_BITNUM  )
+#define INTCHW_SINTC_DMPU                 (1<<INTCHW_SINTC_DMPU_BITNUM  )
+#define INTCHW_SINTC_KEYC                 (1<<INTCHW_SINTC_KEYC_BITNUM  )
+#define INTCHW_SINTC_TSC                  (1<<INTCHW_SINTC_TSC_BITNUM   )
+#define INTCHW_SINTC_UART0                (1<<INTCHW_SINTC_UART0_BITNUM )
+#define INTCHW_SINTC_WDOG                 (1<<INTCHW_SINTC_WDOG_BITNUM  )
+
+
+
+// PL192 Vectored Interrupt Controller (VIC) layout
+#define INTCHW_IRQSTATUS      0x00                    /* IRQ status register */
+#define INTCHW_FIQSTATUS      0x04                    /* FIQ status register */
+#define INTCHW_RAWINTR        0x08                    /* Raw Interrupt Status register */
+#define INTCHW_INTSELECT      0x0c                    /* Interrupt Select Register */
+#define INTCHW_INTENABLE      0x10                    /* Interrupt Enable Register */
+#define INTCHW_INTENCLEAR     0x14                    /* Interrupt Enable Clear Register */
+#define INTCHW_SOFTINT        0x18                    /* Soft Interrupt Register */
+#define INTCHW_SOFTINTCLEAR   0x1c                    /* Soft Interrupt Clear Register */
+#define INTCHW_PROTECTION     0x20                    /* Protection Enable Register */
+#define INTCHW_SWPRIOMASK     0x24                    /* Software Priority Mask Register */
+#define INTCHW_PRIODAISY      0x28                    /* Priority Daisy Chain Register */
+#define INTCHW_VECTADDR0      0x100                   /* Vector Address Registers */
+#define INTCHW_VECTPRIO0      0x200                   /* Vector Priority Registers 0-31*/
+#define INTCHW_ADDRESS        0xf00                   /* Vector Address Register 0-31 */
+#define INTCHW_PID            0xfe0                   /* Peripheral ID Register 0-3 */
+#define INTCHW_PCELLID        0xff0                   /* PrimeCell ID Register 0-3 */
+
+
+// Example Usage: intcHw_irq_enable(INTCHW_INTC0, INTCHW_INTC0_TIMER0);
+//                intcHw_irq_clear(INTCHW_INTC0, INTCHW_INTC0_TIMER0);
+//                uint32_t bits = intcHw_irq_status(INTCHW_INTC0);
+//                uint32_t bits = intcHw_irq_raw_status(INTCHW_INTC0);
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+// Clear one or more IRQ interrupts.
+static inline void intcHw_irq_disable(void *basep, uint32_t mask) {__REG32(basep+INTCHW_INTENCLEAR) = mask;}
+
+// Enables one or more IRQ interrupts.
+static inline void intcHw_irq_enable(void *basep, uint32_t mask) {__REG32(basep+INTCHW_INTENABLE) = mask;}
+
+// Select interrupt (IRQ/FIQ) type
+static inline void intcHw_irq_type(void *basep, uint32_t mask) {__REG32(basep+INTCHW_INTSELECT) = mask;}
+
+// Get raw status bits.
+static inline uint32_t intcHw_rawstatus(void *basep) {return __REG32(basep+INTCHW_RAWINTR);}
+
+// Get irq masked status bits.
+static inline uint32_t intcHw_irq_status(void *basep) {return __REG32(basep+INTCHW_IRQSTATUS);}
+
+// Get fiq masked status bits.
+static inline uint32_t intcHw_fiq_status(void *basep) {return __REG32(basep+INTCHW_FIQSTATUS);}
+
+
+#endif /* _INTCHW_REG_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h b/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
new file mode 100644
index 0000000..d4bbb48
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
@@ -0,0 +1,105 @@
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
+
+/****************************************************************************/
+/**
+*  @file    mm_addr.h
+*
+*  @brief   Memory Map address defintions
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _MM_ADDR_H
+#define _MM_ADDR_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#if !defined( CSP_SIMULATION )
+#include <cfg_global.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+/*  Memory Map address definitions */
+
+#define MM_ADDR_DDR                0x00000000
+
+#define MM_ADDR_IO_VPM_EXTMEM_RSVD 0x0F000000  // 16 MB - Reserved external memory for VPM use
+
+#define MM_ADDR_IO_FLASHC          0x20000000
+#define MM_ADDR_IO_BROM            0x30000000
+#define MM_ADDR_IO_ARAM            0x30100000  // 64 KB - extra cycle latency - WS switch
+#define MM_ADDR_IO_DMA0            0x30200000
+#define MM_ADDR_IO_DMA1            0x30300000
+#define MM_ADDR_IO_ESW             0x30400000
+#define MM_ADDR_IO_CLCD            0x30500000
+#define MM_ADDR_IO_PIF             0x30580000
+#define MM_ADDR_IO_APM             0x30600000
+#define MM_ADDR_IO_SPUM            0x30700000
+#define MM_ADDR_IO_VPM_PROG        0x30800000
+#define MM_ADDR_IO_VPM_DATA        0x30A00000
+#define MM_ADDR_IO_VRAM            0x40000000  // 64 KB  - security block in front of it
+#define MM_ADDR_IO_CHIPC           0x80000000
+#define MM_ADDR_IO_UMI             0x80001000
+#define MM_ADDR_IO_NAND            0x80001800
+#define MM_ADDR_IO_LEDM            0x80002000
+#define MM_ADDR_IO_PWM             0x80002040
+#define MM_ADDR_IO_VINTC           0x80003000
+#define MM_ADDR_IO_GPIO0           0x80004000
+#define MM_ADDR_IO_GPIO1           0x80004800
+#define MM_ADDR_IO_I2CS            0x80005000
+#define MM_ADDR_IO_SPIS            0x80006000
+#define MM_ADDR_IO_HPM             0x80007400
+#define MM_ADDR_IO_HPM_REMAP       0x80007800
+#define MM_ADDR_IO_TZPC            0x80008000
+#define MM_ADDR_IO_MPU             0x80009000
+#define MM_ADDR_IO_SPUMP           0x8000a000
+#define MM_ADDR_IO_PKA             0x8000b000
+#define MM_ADDR_IO_RNG             0x8000c000
+#define MM_ADDR_IO_KEYC            0x8000d000
+#define MM_ADDR_IO_BBL             0x8000e000
+#define MM_ADDR_IO_OTP             0x8000f000
+#define MM_ADDR_IO_I2S0            0x80010000
+#define MM_ADDR_IO_I2S1            0x80011000
+#define MM_ADDR_IO_UARTA           0x80012000
+#define MM_ADDR_IO_UARTB           0x80013000
+#define MM_ADDR_IO_I2CH            0x80014020
+#define MM_ADDR_IO_SPIH            0x80015000
+#define MM_ADDR_IO_TSC             0x80016000
+#define MM_ADDR_IO_TMR             0x80017000
+#define MM_ADDR_IO_WATCHDOG        0x80017800
+#define MM_ADDR_IO_ETM             0x80018000
+#define MM_ADDR_IO_DDRC            0x80019000
+#define MM_ADDR_IO_SINTC           0x80100000
+#define MM_ADDR_IO_INTC0           0x80200000
+#define MM_ADDR_IO_INTC1           0x80201000
+#define MM_ADDR_IO_GE              0x80300000
+#define MM_ADDR_IO_USB_CTLR0       0x80400000
+#define MM_ADDR_IO_USB_CTLR1       0x80410000
+#define MM_ADDR_IO_USB_PHY         0x80420000
+#define MM_ADDR_IO_SDIOH0          0x80500000
+#define MM_ADDR_IO_SDIOH1          0x80600000
+#define MM_ADDR_IO_VDEC            0x80700000
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif /* _MM_ADDR_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/mm_io.h b/arch/arm/mach-bcmring/include/mach/csp/mm_io.h
new file mode 100644
index 0000000..8296e83
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/mm_io.h
@@ -0,0 +1,166 @@
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
+
+/****************************************************************************/
+/**
+*  @file    mm_io.h
+*
+*  @brief   Memory Map I/O definitions
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _MM_IO_H
+#define _MM_IO_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/csp/mm_addr.h>
+
+#if !defined( CSP_SIMULATION )
+#include <cfg_global.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#if defined( CONFIG_MMU )
+
+// This macro is referenced in <mach/io.h>
+
+#ifndef MM_IO_PHYS_TO_VIRT
+
+#ifdef __ASSEMBLY__
+
+#define MM_IO_PHYS_TO_VIRT(phys) (0xF0000000 | (((phys) >> 4) & 0x0F000000) | ((phys) & 0xFFFFFF))
+
+#else
+
+#define MM_IO_PHYS_TO_VIRT(phys)                                           \
+( (((phys) >= 0x20000000) && ((phys) < 0x30000000)) ?                      \
+/* Phys to Virtual 0x2xxxxxxx => 0xExxxxxxx */                             \
+((phys) | 0xC0000000) :                                                    \
+/* Explicitly map phys addr MM_ADDR_IO_VPM_EXTMEM_RSVD to virt addr 0xF0000000. This */   \
+/* address range is reserved for VPM external prog and data memories. */   \
+( ((phys) == MM_ADDR_IO_VPM_EXTMEM_RSVD) ? 0xF0000000 :                                    \
+/* Phys to Virtual 0xNyxxxxxx => 0xFNxxxxxx where N != 2 */                \
+(0xF0000000 | (((phys) >> 4) & 0x0F000000) | ((phys) & 0xFFFFFF)) ))
+
+#endif
+
+#endif
+
+#ifndef MM_IO_VIRT_TO_PHYS
+
+#ifdef __ASSEMBLY__
+#define MM_IO_VIRT_TO_PHYS(virt) ((((virt) & 0x0F000000) << 4) | ((virt) & 0xFFFFFF))
+#else
+#define MM_IO_VIRT_TO_PHYS(virt) ((((virt) & 0xF0000000) == 0xE0000000) ?  \
+/* Virtual to Physical 0xExxxxxxx => 0x2xxxxxxx */                         \
+(((virt) & ~0xF0000000) | 0x20000000)  :                                   \
+/* Explicitly map phys addr MM_ADDR_IO_VPM_EXTMEM_RSVD to virt addr 0xF0000000. This */   \
+/* address range is reserved for VPM external prog and data memories. */   \
+(((virt) == 0xF0000000) ? MM_ADDR_IO_VPM_EXTMEM_RSVD : \
+/* Virtual to Physical 0xFNxxxxxx => 0xN0xxxxxx */                         \
+((((virt) & 0x0F000000) << 4) | ((virt) & 0xFFFFFF))) )
+
+#endif
+#endif
+
+#else
+
+#ifndef MM_IO_PHYS_TO_VIRT
+#define MM_IO_PHYS_TO_VIRT(phys)       (phys)
+#endif
+
+#ifndef MM_IO_VIRT_TO_PHYS
+#define MM_IO_VIRT_TO_PHYS(virt)       (virt)
+#endif
+
+#endif
+
+/* Registers in 0xExxxxxxx that should be moved to 0xFxxxxxxx */
+#define MM_IO_BASE_FLASHC              MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_FLASHC )
+#define MM_IO_BASE_NAND                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_NAND )
+#define MM_IO_BASE_UMI                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_UMI )
+
+#define MM_IO_START MM_ADDR_IO_FLASHC  // Physical beginning of IO mapped memory
+#define MM_IO_BASE  MM_IO_BASE_FLASHC  // Virtual beginning of IO mapped memory
+
+#define MM_IO_BASE_BROM                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_BROM )
+#define MM_IO_BASE_ARAM                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_ARAM )
+#define MM_IO_BASE_DMA0                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_DMA0 )
+#define MM_IO_BASE_DMA1                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_DMA1 )
+#define MM_IO_BASE_ESW                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_ESW )
+#define MM_IO_BASE_CLCD                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_CLCD )
+#define MM_IO_BASE_PIF                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_PIF )
+#define MM_IO_BASE_APM                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_APM )
+#define MM_IO_BASE_SPUM                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SPUM )
+#define MM_IO_BASE_VPM_PROG            MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VPM_PROG )
+#define MM_IO_BASE_VPM_DATA            MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VPM_DATA )
+
+#define MM_IO_BASE_VRAM                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VRAM )
+
+#define MM_IO_BASE_CHIPC               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_CHIPC )
+#define MM_IO_BASE_DDRC                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_DDRC )
+#define MM_IO_BASE_LEDM                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_LEDM )
+#define MM_IO_BASE_PWM                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_PWM )
+#define MM_IO_BASE_VINTC               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VINTC )
+#define MM_IO_BASE_GPIO0               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_GPIO0 )
+#define MM_IO_BASE_GPIO1               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_GPIO1 )
+#define MM_IO_BASE_TMR                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_TMR )
+#define MM_IO_BASE_WATCHDOG            MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_WATCHDOG )
+#define MM_IO_BASE_ETM                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_ETM )
+#define MM_IO_BASE_HPM                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_HPM )
+#define MM_IO_BASE_HPM_REMAP           MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_HPM_REMAP )
+#define MM_IO_BASE_TZPC                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_TZPC )
+#define MM_IO_BASE_MPU                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_MPU )
+#define MM_IO_BASE_SPUMP               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SPUMP )
+#define MM_IO_BASE_PKA                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_PKA )
+#define MM_IO_BASE_RNG                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_RNG )
+#define MM_IO_BASE_KEYC                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_KEYC )
+#define MM_IO_BASE_BBL                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_BBL )
+#define MM_IO_BASE_OTP                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_OTP )
+#define MM_IO_BASE_I2S0                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_I2S0 )
+#define MM_IO_BASE_I2S1                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_I2S1 )
+#define MM_IO_BASE_UARTA               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_UARTA )
+#define MM_IO_BASE_UARTB               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_UARTB )
+#define MM_IO_BASE_I2CH                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_I2CH )
+#define MM_IO_BASE_SPIH                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SPIH )
+#define MM_IO_BASE_TSC                 MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_TSC )
+#define MM_IO_BASE_I2CS                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_I2CS )
+#define MM_IO_BASE_SPIS                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SPIS )
+#define MM_IO_BASE_SINTC               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SINTC )
+#define MM_IO_BASE_INTC0               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_INTC0 )
+#define MM_IO_BASE_INTC1               MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_INTC1 )
+#define MM_IO_BASE_GE                  MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_GE )
+#define MM_IO_BASE_USB_CTLR0           MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_USB_CTLR0 )
+#define MM_IO_BASE_USB_CTLR1           MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_USB_CTLR1 )
+#define MM_IO_BASE_USB_PHY             MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_USB_PHY )
+#define MM_IO_BASE_SDIOH0              MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SDIOH0 )
+#define MM_IO_BASE_SDIOH1              MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_SDIOH1 )
+#define MM_IO_BASE_VDEC                MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VDEC )
+
+
+
+#define MM_IO_BASE_VPM_EXTMEM_RSVD     MM_IO_PHYS_TO_VIRT( MM_ADDR_IO_VPM_EXTMEM_RSVD )
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif /* _MM_IO_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h b/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
new file mode 100644
index 0000000..ed3b32c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
@@ -0,0 +1,122 @@
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
+
+// Trustzone register set
+typedef struct
+{
+   volatile uint32_t status;        // read only - reflects status of writes of 2 write registers
+   volatile uint32_t setUnsecure;   // write only. reads back as 0
+   volatile uint32_t setSecure;     // write only. reads back as 0
+}
+secHw_TZREG_t;
+
+// There are 2 register sets. The first is for the lower 16 bits, the 2nd
+// is for the higher 16 bits.
+
+typedef enum
+{
+   secHw_IDX_LS = 0,
+   secHw_IDX_MS = 1,
+   secHw_IDX_NUM
+}
+secHw_IDX_e;
+
+typedef struct
+{
+   volatile secHw_TZREG_t reg[secHw_IDX_NUM];
+}
+secHw_REGS_t;
+
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setSecure
+(
+  uint32_t mask   ///<  mask of type secHw_BLK_MASK_XXXXXX
+);
+
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a non-secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setUnsecure
+(
+    uint32_t mask  ///<  mask of type secHw_BLK_MASK_XXXXXX
+);
+
+
+/****************************************************************************/
+/**
+*  @brief  Get the trustzone status for all components. 1 = non-secure, 0 = secure
+*
+*/
+/****************************************************************************/
+static inline uint32_t secHw_getStatus(void);
+
+
+
+#include <mach/csp/secHw_inline.h>
+
+
+
+#endif /* SECHW_DEF_H */
+
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
new file mode 100644
index 0000000..9246aeb
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
@@ -0,0 +1,93 @@
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
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setSecure
+(
+  uint32_t mask   ///<  mask of type secHw_BLK_MASK_XXXXXX
+)
+{
+  secHw_REGS_t *regp = (secHw_REGS_t *)MM_IO_BASE_TZPC;
+
+  if ( mask & 0x0000FFFF )
+  {
+     regp->reg[secHw_IDX_LS].setSecure = mask & 0x0000FFFF;
+  }
+
+  if (mask & 0xFFFF0000)
+  {
+     regp->reg[secHw_IDX_MS].setSecure = mask >> 16;
+  }
+}
+
+
+/****************************************************************************/
+/**
+*  @brief  Configures a device as a non-secure device
+*
+*/
+/****************************************************************************/
+static inline void secHw_setUnsecure
+(
+    uint32_t mask  ///<  mask of type secHw_BLK_MASK_XXXXXX
+)
+{
+  secHw_REGS_t *regp = (secHw_REGS_t *)MM_IO_BASE_TZPC;
+
+  if ( mask & 0x0000FFFF )
+  {
+     regp->reg[secHw_IDX_LS].setUnsecure = mask & 0x0000FFFF;
+  }
+  if (mask & 0xFFFF0000)
+  {
+     regp->reg[secHw_IDX_MS].setUnsecure = mask >> 16;
+  }
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
+  secHw_REGS_t *regp = (secHw_REGS_t *)MM_IO_BASE_TZPC;
+
+  return (regp->reg[1].status << 16) + regp->reg[0].status;
+}
+
+#endif /* SECHW_INLINE_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
new file mode 100644
index 0000000..50b4ff4
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
@@ -0,0 +1,88 @@
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
+
+
+
+/****************************************************************************/
+/**
+*  @file    tmrHw_reg.h
+*
+*  @brief   Definitions for low level Timer registers
+*
+*/
+/****************************************************************************/
+#ifndef _TMRHW_REG_H
+#define _TMRHW_REG_H
+
+#include <mach/csp/mm_io.h>
+#include <mach/csp/hw_cfg.h>
+/* Base address */
+#define tmrHw_MODULE_BASE_ADDR          MM_IO_BASE_TMR
+
+
+/*
+This platform has four different timers running at different clock speed
+
+Timer one   (Timer ID 0) runs at  25 MHz
+Timer two   (Timer ID 1) runs at  25 MHz
+Timer three (Timer ID 2) runs at 150 MHz
+Timer four  (Timer ID 3) runs at 150 MHz
+*/
+#define tmrHw_LOW_FREQUENCY_MHZ         25     /* Always 25MHz from XTAL */
+#define tmrHw_LOW_FREQUENCY_HZ          25000000
+
+#if defined(CFG_GLOBAL_CHIP) && (CFG_GLOBAL_CHIP == FPGA11107)
+#define tmrHw_HIGH_FREQUENCY_MHZ        150     /* Always 150MHz for FPGA */
+#define tmrHw_HIGH_FREQUENCY_HZ         150000000
+#else
+#define tmrHw_HIGH_FREQUENCY_HZ         HW_CFG_BUS_CLK_HZ
+#define tmrHw_HIGH_FREQUENCY_MHZ        ( HW_CFG_BUS_CLK_HZ / 1000000 )
+#endif
+
+#define tmrHw_LOW_RESOLUTION_CLOCK      tmrHw_LOW_FREQUENCY_HZ
+#define tmrHw_HIGH_RESOLUTION_CLOCK     tmrHw_HIGH_FREQUENCY_HZ
+#define tmrHw_MAX_COUNT                 ( 0xFFFFFFFF )        /* maximum number of count a timer can count */
+#define tmrHw_TIMER_NUM_COUNT           ( 4 )                 /* Number of timer module supported */
+
+typedef struct
+{
+   uint32_t LoadValue;                /* Load value for timer */
+   uint32_t CurrentValue;             /* Current value for timer */
+   uint32_t Control;                  /* Control register */
+   uint32_t InterruptClear;           /* Interrupt clear register */
+   uint32_t RawInterruptStatus;       /* Raw interrupt status */
+   uint32_t InterruptStatus;          /* Masked interrupt status */
+   uint32_t BackgroundLoad;           /* Background load value */
+   uint32_t padding;                  /* Padding register */
+}tmrHw_REG_t;
+
+/* Control bot masks */
+#define tmrHw_CONTROL_TIMER_ENABLE            0x00000080
+#define tmrHw_CONTROL_PERIODIC                0x00000040
+#define tmrHw_CONTROL_INTERRUPT_ENABLE        0x00000020
+#define tmrHw_CONTROL_PRESCALE_MASK           0x0000000C
+#define tmrHw_CONTROL_PRESCALE_1              0x00000000
+#define tmrHw_CONTROL_PRESCALE_16             0x00000004
+#define tmrHw_CONTROL_PRESCALE_256            0x00000008
+#define tmrHw_CONTROL_32BIT                   0x00000002
+#define tmrHw_CONTROL_ONESHOT                 0x00000001
+#define tmrHw_CONTROL_FREE_RUNNING            0x00000000
+
+#define tmrHw_CONTROL_MODE_MASK               (tmrHw_CONTROL_PERIODIC | tmrHw_CONTROL_ONESHOT)
+
+
+#define pTmrHw ((volatile tmrHw_REG_t *)tmrHw_MODULE_BASE_ADDR)
+
+#endif /* _TMRHW_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h b/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
new file mode 100644
index 0000000..f469d73
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/uartHw_inline.h
@@ -0,0 +1,358 @@
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
+static inline void uartHw_CtsFlowCtrlDisable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_HW_FLOWCTRL_CTS;
+}
+
+static inline void uartHw_CtsFlowCtrlEnable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_HW_FLOWCTRL_CTS;
+}
+
+static inline int uartHw_CtsStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_CTS ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+/*****************************************************************************
+* DCD signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DcdStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_DCD ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+/*****************************************************************************
+* DSR signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DsrStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_DSR ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+/*****************************************************************************
+* DTR signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_DtrStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->ctrl & UARTHW_REG_CTRL_DTR_ACTIVE ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+static inline void uartHw_DtrStateSet( unsigned uartNum, unsigned state )
+{
+    if ( state == uartHw_STATE_ACTIVE )
+    {
+        uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_DTR_ACTIVE;
+    }
+    else
+    {
+        uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_DTR_ACTIVE;
+    }
+}
+
+/*****************************************************************************
+* Loopback mode routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_LoopbackDisable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_LOOPBK_ENABLE;
+}
+
+static inline void uartHw_LoopbackEnable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_LOOPBK_ENABLE;
+}
+
+/*****************************************************************************
+* RI signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_RiStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RI ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+/*****************************************************************************
+* RTS signal routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RtsFlowCtrlDisable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_HW_FLOWCTRL_RTS;
+}
+
+static inline void uartHw_RtsFlowCtrlEnable( unsigned uartNum )
+{
+    uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_HW_FLOWCTRL_RTS;
+}
+
+static inline int uartHw_RtsStateGet( unsigned uartNum )
+{
+    return( uartRegP(uartNum)->ctrl & UARTHW_REG_CTRL_RTS_ACTIVE ? uartHw_STATE_ACTIVE : uartHw_STATE_INACTIVE );
+}
+
+static inline void uartHw_RtsStateSet( unsigned uartNum, unsigned state )
+{
+    if ( state == uartHw_STATE_ACTIVE )
+    {
+        uartRegP(uartNum)->ctrl |= UARTHW_REG_CTRL_RTS_ACTIVE;
+    }
+    else
+    {
+        uartRegP(uartNum)->ctrl &= ~UARTHW_REG_CTRL_RTS_ACTIVE;
+    }
+}
+
+/*****************************************************************************
+* UART Rx FIFO DMA routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RxFifoDmaDisable( unsigned uartNum )
+{
+    uartRegP(uartNum)->dmaCtrl &= ~UARTHW_REG_DMA_CTRL_RX_ENABLE;
+}
+
+static inline void uartHw_RxFifoDmaEnable( unsigned uartNum )
+{
+    uartRegP(uartNum)->dmaCtrl |= UARTHW_REG_DMA_CTRL_RX_ENABLE;
+}
+
+static inline uint32_t uartHw_RxFifoDmaAddrGet( unsigned uartNum )
+{
+    /// @todo Ensure physical address returned
+    return( (uint32_t)&uartRegP(uartNum)->fifo );
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_RxFifoFull( unsigned uartNum )
+{
+    return ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_FULL );
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
+static inline int uartHw_RxFifoReady
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+)
+{
+   if ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_EMPTY )
+   {
+      return( 0 );
+   }
+   else
+   {
+      return( 1 );
+   }
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
+static inline int uartHw_RxFifoGet
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+)
+{
+   while ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_RX_EMPTY )
+   {
+      /* wait until rx fifo not empty */
+   }
+   return( uartRegP(uartNum)->fifo & UARTHW_REG_FIFO_DATA_MASK );
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_RxFifoThresholdSet( unsigned uartNum, unsigned byteCnt )
+{
+    uint32_t level;
+
+
+    switch( byteCnt )
+    {
+        case 4:  level = UARTHW_REG_INTR_FIFO_LEVEL_1_8; break;
+        case 8:  level = UARTHW_REG_INTR_FIFO_LEVEL_1_4; break;
+        case 16: level = UARTHW_REG_INTR_FIFO_LEVEL_1_2; break;
+        case 24: level = UARTHW_REG_INTR_FIFO_LEVEL_3_4; break;
+        case 28: level = UARTHW_REG_INTR_FIFO_LEVEL_7_8; break;
+
+        default:
+            /// @todo Maybe return an -errno to handle this situation.
+            return;
+    }
+
+    uartRegP(uartNum)->intrFifoLevel &= ~UARTHW_REG_INTR_FIFO_LEVEL_RX_MASK;
+    uartRegP(uartNum)->intrFifoLevel |=  ((level << UARTHW_REG_INTR_FIFO_LEVEL_RX_SHIFT) & UARTHW_REG_INTR_FIFO_LEVEL_RX_MASK);
+}
+
+/*****************************************************************************
+* UART Rx FIFO DMA routines. See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_TxFifoDmaDisable( unsigned uartNum )
+{
+    uartRegP(uartNum)->dmaCtrl &= ~UARTHW_REG_DMA_CTRL_TX_ENABLE;
+}
+
+static inline void uartHw_TxFifoDmaEnable( unsigned uartNum )
+{
+    uartRegP(uartNum)->dmaCtrl |= UARTHW_REG_DMA_CTRL_TX_ENABLE;
+}
+
+static inline uint32_t uartHw_TxFifoDmaAddrGet( unsigned uartNum )
+{
+    /// @todo Ensure physical address returned
+    return( (uint32_t)&uartRegP(uartNum)->fifo );
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline int uartHw_TxFifoEmpty( unsigned uartNum )
+{
+    return ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_EMPTY );
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
+static inline int uartHw_TxFifoPut
+(
+    unsigned    uartNum,    ///< [IN]  uart number (0 .. max)
+    unsigned    value       ///< [IN]  output value
+)
+{
+   while ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_FULL )
+   {
+   }
+
+   uartRegP(uartNum)->fifo = value;
+   return 0;
+}
+
+/*****************************************************************************
+* See uartHw.h for API documentation
+*****************************************************************************/
+static inline void uartHw_TxFifoThresholdSet( unsigned uartNum, unsigned byteCnt )
+{
+    uint32_t level;
+
+
+    switch( byteCnt )
+    {
+        case 4:  level = UARTHW_REG_INTR_FIFO_LEVEL_1_8; break;
+        case 8:  level = UARTHW_REG_INTR_FIFO_LEVEL_1_4; break;
+        case 16: level = UARTHW_REG_INTR_FIFO_LEVEL_1_2; break;
+        case 24: level = UARTHW_REG_INTR_FIFO_LEVEL_3_4; break;
+        case 28: level = UARTHW_REG_INTR_FIFO_LEVEL_7_8; break;
+
+        default:
+            /// @todo Maybe return an -errno to handle this situation.
+            return;
+    }
+
+    uartRegP(uartNum)->intrFifoLevel &= ~UARTHW_REG_INTR_FIFO_LEVEL_TX_MASK;
+    uartRegP(uartNum)->intrFifoLevel |=  ((level << UARTHW_REG_INTR_FIFO_LEVEL_TX_SHIFT) & UARTHW_REG_INTR_FIFO_LEVEL_TX_MASK);
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
+static inline int uartHw_TxWaitIdle
+(
+    unsigned    uartNum     ///< [IN]  uart number (0 .. max)
+)
+{
+   // Wait for the tx fifo to be empty
+   while (( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_TX_EMPTY ) == 0 )
+   {
+   }
+
+   // Wait for the final character to be sent on the txd line
+   while ( uartRegP(uartNum)->flag & UARTHW_REG_FLAG_BUSY )
+   {
+   }
+
+   return 0;
+}
+
+
+#endif /* _UARTHW_INLINE_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h
new file mode 100644
index 0000000..b58417d
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/uartHw_reg.h
@@ -0,0 +1,177 @@
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
+
+typedef struct
+{
+    uint32_t fifo;
+    uint32_t rxStatus;
+
+    REG32_RSVD(0x0008, 0x0018);
+
+    uint32_t flag;
+
+    REG32_RSVD(0x001c, 0x0020);
+
+    uint32_t irdaLowPwr;
+    uint32_t baudInteger;
+    uint32_t baudFraction;
+    uint32_t lineCtrl;
+    uint32_t ctrl;
+    uint32_t intrFifoLevel;
+    uint32_t intrCtrlMask;
+    uint32_t intrStatusRaw;
+    uint32_t intrStatusMask;
+    uint32_t intrClear;
+    uint32_t dmaCtrl;
+
+    REG32_RSVD(0x004c, 0x0100);
+
+    // Although a dmaFifo is defined and accessible, it is not part of the PL011 IP nor is it necessary.
+    // DMA operations work just fine with the standard PL011 fifo, so this is not used.
+    //
+    uint32_t dmaFifo;
+}
+UARTHW_REG_t;
+
+#define  uartRegP(x) (x ? ((volatile UARTHW_REG_t *)MM_IO_BASE_UARTB) : ((volatile UARTHW_REG_t *)MM_IO_BASE_UARTA))
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+
+#endif /* _UARTHW_REG_H */
+
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.



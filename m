Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZGDBq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZGDBq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbZGDBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:42 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774AbZGDBod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:33 -0400
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
Date: Fri, 3 Jul 2009 18:44:31 -0700
Subject: [PATCH v2 12/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 12/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SPm7pJNx8Tv7RpOMVhfszZn9vw==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C1A@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506B8A4CG20368320-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 650d9f18f145bae788fb7992c1a9c559132f6a1e Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:08:52 -0700
Subject: [PATCH 12/18] add mach-bcmring/include/csp header files

add mach-bcmring/include/csp header files, they are function prototypes

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/include/csp/cache.h  |   35 ++++
 arch/arm/mach-bcmring/include/csp/delay.h  |   36 ++++
 arch/arm/mach-bcmring/include/csp/errno.h  |   32 +++
 arch/arm/mach-bcmring/include/csp/module.h |   32 +++
 arch/arm/mach-bcmring/include/csp/reg.h    |  113 +++++++++++
 arch/arm/mach-bcmring/include/csp/secHw.h  |   65 ++++++
 arch/arm/mach-bcmring/include/csp/stdint.h |   30 +++
 arch/arm/mach-bcmring/include/csp/tmrHw.h  |  263 ++++++++++++++++++++++++
 arch/arm/mach-bcmring/include/csp/uartHw.h |  296 ++++++++++++++++++++++++++++
 9 files changed, 902 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/include/csp/cache.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/delay.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/errno.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/module.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/reg.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/secHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/stdint.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/tmrHw.h
 create mode 100644 arch/arm/mach-bcmring/include/csp/uartHw.h

diff --git a/arch/arm/mach-bcmring/include/csp/cache.h b/arch/arm/mach-bcmring/include/csp/cache.h
new file mode 100644
index 0000000..caa20e5
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/cache.h
@@ -0,0 +1,35 @@
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
+#if defined(__KERNEL__) && !defined(STANDALONE)
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
+#endif /* CSP_CACHE_H */
diff --git a/arch/arm/mach-bcmring/include/csp/delay.h b/arch/arm/mach-bcmring/include/csp/delay.h
new file mode 100644
index 0000000..8b3d803
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/delay.h
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
+#ifndef CSP_DELAY_H
+#define CSP_DELAY_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+/* Some CSP routines require use of the following delay routines. Use the OS */
+/* version if available, otherwise use a CSP specific definition. */
+/* void udelay(unsigned long usecs); */
+/* void mdelay(unsigned long msecs); */
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
diff --git a/arch/arm/mach-bcmring/include/csp/errno.h b/arch/arm/mach-bcmring/include/csp/errno.h
new file mode 100644
index 0000000..51357dd
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/errno.h
@@ -0,0 +1,32 @@
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
+#ifndef CSP_ERRNO_H
+#define CSP_ERRNO_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#if   defined(__KERNEL__)
+#include <linux/errno.h>
+#elif defined(CSP_SIMULATION)
+#include <asm-generic/errno.h>
+#else
+#include <errno.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /* CSP_ERRNO_H */
diff --git a/arch/arm/mach-bcmring/include/csp/module.h b/arch/arm/mach-bcmring/include/csp/module.h
new file mode 100644
index 0000000..c30d2a5
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/module.h
@@ -0,0 +1,32 @@
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
+#endif /* CSP_MODULE_H */
diff --git a/arch/arm/mach-bcmring/include/csp/reg.h b/arch/arm/mach-bcmring/include/csp/reg.h
new file mode 100644
index 0000000..f0a5bf7
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/reg.h
@@ -0,0 +1,113 @@
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
+#define __REG32(x)      (*((volatile uint32_t *)(x)))
+#define __REG16(x)      (*((volatile uint16_t *)(x)))
+#define __REG8(x)       (*((volatile uint8_t *) (x)))
+
+/* Macros used to define a sequence of reserved registers. The start / end */
+/* are byte offsets in the particular register definition, with the "end" */
+/* being the offset of the next un-reserved register. E.g. if offsets */
+/* 0x10 through to 0x1f are reserved, then this reserved area could be */
+/* specified as follows. */
+/*  typedef struct */
+/*  { */
+/*      uint32_t reg1;           offset 0x00 */
+/*      uint32_t reg2;           offset 0x04 */
+/*      uint32_t reg3;           offset 0x08 */
+/*      uint32_t reg4;           offset 0x0c */
+/*      REG32_RSVD(0x10, 0x20); */
+/*      uint32_t reg5;           offset 0x20 */
+/*      ... */
+/*  } EXAMPLE_REG_t; */
+#define REG8_RSVD(start, end)   uint8_t rsvd_##start[(end - start) / sizeof(uint8_t)]
+#define REG16_RSVD(start, end)  uint16_t rsvd_##start[(end - start) / sizeof(uint16_t)]
+#define REG32_RSVD(start, end)  uint32_t rsvd_##start[(end - start) / sizeof(uint32_t)]
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+/* Note: When protecting multiple statements, the REG_LOCAL_IRQ_SAVE and */
+/* REG_LOCAL_IRQ_RESTORE must be enclosed in { } to allow the  */
+/* flags variable to be declared locally. */
+/* e.g. */
+/*    statement1; */
+/*    { */
+/*       REG_LOCAL_IRQ_SAVE; */
+/*       <multiple statements here> */
+/*       REG_LOCAL_IRQ_RESTORE; */
+/*    } */
+/*    statement2; */
+/*  */
+
+#if defined(__KERNEL__) && !defined(STANDALONE)
+#include <linux/interrupt.h>
+
+#define REG_LOCAL_IRQ_SAVE      unsigned long flags; local_irq_save(flags)
+#define REG_LOCAL_IRQ_RESTORE   local_irq_restore(flags)
+
+#else
+
+#define REG_LOCAL_IRQ_SAVE
+#define REG_LOCAL_IRQ_RESTORE
+
+#endif
+
+static inline void reg32_modify_and(volatile uint32_t *reg, uint32_t value)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *reg &= value;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_modify_or(volatile uint32_t *reg, uint32_t value)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *reg |= value;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_modify_mask(volatile uint32_t *reg, uint32_t mask,
+                                    uint32_t value)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *reg = (*reg & mask) | value;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+static inline void reg32_write(volatile uint32_t *reg, uint32_t value)
+{
+       REG_LOCAL_IRQ_SAVE;
+       *reg = value;
+       REG_LOCAL_IRQ_RESTORE;
+}
+
+#endif /* CSP_REG_H */
diff --git a/arch/arm/mach-bcmring/include/csp/secHw.h b/arch/arm/mach-bcmring/include/csp/secHw.h
new file mode 100644
index 0000000..b9d7e07
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/secHw.h
@@ -0,0 +1,65 @@
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
+*  @file    secHw.h
+*
+*  @brief   Definitions for accessing low level security features
+*
+*/
+/****************************************************************************/
+#ifndef SECHW_H
+#define SECHW_H
+
+typedef void (*secHw_FUNC_t) (void);
+
+typedef enum {
+       secHw_MODE_SECURE = 0x0,        /* Switches processor into secure mode */
+       secHw_MODE_NONSECURE = 0x1      /* Switches processor into non-secure mode */
+} secHw_MODE;
+
+/****************************************************************************/
+/**
+*  @brief   Requesting to execute the function in secure mode
+*
+*  This function requests the given function to run in secure mode
+*
+*/
+/****************************************************************************/
+void secHw_RunSecure(secHw_FUNC_t      /* Function to run in secure mode */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Sets the  mode
+*
+*  his function sets the processor mode (secure/non-secure)
+*
+*/
+/****************************************************************************/
+void secHw_SetMode(secHw_MODE  /* Processor mode */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Get the current mode
+*
+*  This function retieves the processor mode (secure/non-secure)
+*
+*/
+/****************************************************************************/
+void secHw_GetMode(secHw_MODE *);
+
+#endif /* SECHW_H */
diff --git a/arch/arm/mach-bcmring/include/csp/stdint.h b/arch/arm/mach-bcmring/include/csp/stdint.h
new file mode 100644
index 0000000..3a8718b
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/stdint.h
@@ -0,0 +1,30 @@
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
+#ifndef CSP_STDINT_H
+#define CSP_STDINT_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /* CSP_STDINT_H */
diff --git a/arch/arm/mach-bcmring/include/csp/tmrHw.h b/arch/arm/mach-bcmring/include/csp/tmrHw.h
new file mode 100644
index 0000000..f1236d0
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/tmrHw.h
@@ -0,0 +1,263 @@
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
+typedef uint32_t tmrHw_ID_t;   /* Timer ID */
+typedef uint32_t tmrHw_COUNT_t;        /* Timer count */
+typedef uint32_t tmrHw_INTERVAL_t;     /* Timer interval */
+typedef uint32_t tmrHw_RATE_t; /* Timer event (count/interrupt) rate */
+
+typedef enum {
+       tmrHw_INTERRUPT_STATUS_SET,     /* Interrupted  */
+       tmrHw_INTERRUPT_STATUS_UNSET    /* No Interrupt */
+} tmrHw_INTERRUPT_STATUS_e;
+
+typedef enum {
+       tmrHw_CAPABILITY_CLOCK, /* Clock speed in HHz */
+       tmrHw_CAPABILITY_RESOLUTION     /* Timer resolution in bits */
+} tmrHw_CAPABILITY_e;
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
+uint32_t tmrHw_getTimerCapability(tmrHw_ID_t timerId,  /*  [ IN ] Timer Id */
+                                 tmrHw_CAPABILITY_e capability /*  [ IN ] Timer capability */
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
+tmrHw_RATE_t tmrHw_setPeriodicTimerRate(tmrHw_ID_t timerId,    /*  [ IN ] Timer Id */
+                                       tmrHw_RATE_t rate       /*  [ IN ] Number of timer interrupt per second */
+);
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
+tmrHw_INTERVAL_t tmrHw_setPeriodicTimerInterval(tmrHw_ID_t timerId,    /*  [ IN ] Timer Id */
+                                               tmrHw_INTERVAL_t msec   /*  [ IN ] Interval in mili-second */
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
+tmrHw_INTERVAL_t tmrHw_setOneshotTimerInterval(tmrHw_ID_t timerId,     /*  [ IN ] Timer Id */
+                                              tmrHw_INTERVAL_t msec    /*  [ IN ] Interval in mili-second */
+);
+
+/****************************************************************************/
+/**
+*  @brief   Configures a timer to run as a free running timer
+*
+*  This function initializes a timer to run as a free running timer
+*
+*  @return   Timer resolution (count / sec)
+*
+*/
+/****************************************************************************/
+tmrHw_RATE_t tmrHw_setFreeRunningTimer(tmrHw_ID_t timerId,     /*  [ IN ] Timer Id */
+                                      uint32_t divider /*  [ IN ] Dividing the clock frequency */
+) __attribute__ ((section(".aramtext")));
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
+int tmrHw_startTimer(tmrHw_ID_t timerId        /*  [ IN ] Timer id */
+) __attribute__ ((section(".aramtext")));
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
+int tmrHw_stopTimer(tmrHw_ID_t timerId /*  [ IN ] Timer id */
+);
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
+tmrHw_COUNT_t tmrHw_GetCurrentCount(tmrHw_ID_t timerId /*  [ IN ] Timer id */
+) __attribute__ ((section(".aramtext")));
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
+tmrHw_RATE_t tmrHw_getCountRate(tmrHw_ID_t timerId     /*  [ IN ] Timer id */
+) __attribute__ ((section(".aramtext")));
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
+void tmrHw_enableInterrupt(tmrHw_ID_t timerId  /*  [ IN ] Timer id */
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
+void tmrHw_disableInterrupt(tmrHw_ID_t timerId /*  [ IN ] Timer id */
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
+void tmrHw_clearInterrupt(tmrHw_ID_t timerId   /*  [ IN ] Timer id */
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
+tmrHw_INTERRUPT_STATUS_e tmrHw_getInterruptStatus(tmrHw_ID_t timerId   /*  [ IN ] Timer id */
+);
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
+tmrHw_ID_t tmrHw_getInterruptSource(void);
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
+void tmrHw_printDebugInfo(tmrHw_ID_t timerId,  /*  [ IN ] Timer id */
+                         int (*fpPrint) (const char *, ...)    /*  [ IN ] Print callback function */
+);
+
+/****************************************************************************/
+/**
+*  @brief   Use a timer to perform a busy wait delay for a number of usecs.
+*
+*  @return   N/A
+*/
+/****************************************************************************/
+void tmrHw_udelay(tmrHw_ID_t timerId,  /*  [ IN ] Timer id */
+                 unsigned long usecs   /*  [ IN ] usec to delay */
+) __attribute__ ((section(".aramtext")));
+
+#endif /* _TMRHW_H */
diff --git a/arch/arm/mach-bcmring/include/csp/uartHw.h b/arch/arm/mach-bcmring/include/csp/uartHw.h
new file mode 100644
index 0000000..8f66c50
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/uartHw.h
@@ -0,0 +1,296 @@
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
+extern "C" {
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
+       long uartHw_Init(unsigned uartNum,      /* [IN]  uart number (0 .. max) */
+                        unsigned long baudRate /* [IN]  baud rate (9600, 115200, ...) */
+           );
+
+/****************************************************************************/
+/**
+*  @brief   Enable / Disable UART loopback mode
+*
+*/
+/****************************************************************************/
+       static inline void uartHw_LoopbackDisable(unsigned uartNum      /* [IN]  uart number (0 .. max) */
+           );
+
+       static inline void uartHw_LoopbackEnable(unsigned uartNum       /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline void uartHw_CtsFlowCtrlDisable(unsigned uartNum);
+       static inline void uartHw_CtsFlowCtrlEnable(unsigned uartNum);
+       static inline int uartHw_CtsStateGet(unsigned uartNum);
+
+       static inline int uartHw_DcdStateGet(unsigned uartNum);
+
+       static inline int uartHw_DsrStateGet(unsigned uartNum);
+
+       static inline int uartHw_DtrStateGet(unsigned uartNum);
+       static inline void uartHw_DtrStateSet(unsigned uartNum, unsigned state);
+
+       static inline int uartHw_RiStateGet(unsigned uartNum);
+
+       static inline void uartHw_RtsFlowCtrlDisable(unsigned uartNum);
+       static inline void uartHw_RtsFlowCtrlEnable(unsigned uartNum);
+       static inline int uartHw_RtsStateGet(unsigned uartNum);
+       static inline void uartHw_RtsStateSet(unsigned uartNum, unsigned state);
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
+       static inline void uartHw_RxFifoDmaDisable(unsigned uartNum);
+       static inline void uartHw_RxFifoDmaEnable(unsigned uartNum);
+       static inline uint32_t uartHw_RxFifoDmaAddrGet(unsigned uartNum);
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
+       int uartHw_RxFifoEmpty(unsigned uartNum /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline int uartHw_RxFifoFull(unsigned uartNum    /* [IN]  uart number (0 .. max) */
+           );
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
+       int uartHw_RxFifoFlush(unsigned uartNum /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline int uartHw_RxFifoGet(unsigned uartNum     /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline int uartHw_RxFifoReady(unsigned uartNum   /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline void uartHw_RxFifoThresholdSet(unsigned uartNum,  /* [IN]  uart number (0 .. max) */
+                                                    unsigned byteCnt   /* [IN]  threshold level in bytes */
+           );
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
+       static inline void uartHw_TxFifoDmaDisable(unsigned uartNum);
+       static inline void uartHw_TxFifoDmaEnable(unsigned uartNum);
+       static inline uint32_t uartHw_TxFifoDmaAddrGet(unsigned uartNum);
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
+       static inline int uartHw_TxFifoEmpty(unsigned uartNum   /* [IN]  uart number (0 .. max) */
+           );
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
+       int uartHw_TxFifoFull(unsigned uartNum  /* [IN]  uart number (0 .. max) */
+           );
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
+       static inline void uartHw_TxFifoThresholdSet(unsigned uartNum,  /* [IN]  uart number (0 .. max) */
+                                                    unsigned byteCnt   /* [IN]  threshold level in bytes */
+           );
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
+       static inline int uartHw_TxFifoPut(unsigned uartNum,    /* [IN]  uart number (0 .. max) */
+                                          unsigned value       /* [IN]  output value */
+           );
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
+       static inline int uartHw_TxWaitIdle(unsigned uartNum    /* [IN]  uart number (0 .. max) */
+           );
+
+#include <mach/csp/uartHw_inline.h>
+
+#ifdef __cplusplus
+/* end extern "C" */
+}
+#endif
+#endif                         /* _UARTHW_H */
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.



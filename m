Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZDIRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZDIRQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZDIRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:16:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZDIRQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:16:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Separate out the proc and unit header dirs from
	the general headers
To: torvalds@osdl.org, akpm@linux-foundation.org, sam@ravnborg.org
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Apr 2009 18:14:52 +0100
Message-ID: <20090409171452.3119.39988.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090409171447.3119.48356.stgit@warthog.procyon.org.uk>
References: <20090409171447.3119.48356.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the proc- and unit-specific header directories from the general
MN10300 arch headers and dangle them instead from the same directories as
contain the .c files for the processor and unit implementations.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Makefile                             |   40 ------
 arch/mn10300/include/asm/cache.h                  |    2 
 arch/mn10300/include/asm/irq.h                    |    2 
 arch/mn10300/include/asm/proc-mn103e010/cache.h   |   33 -----
 arch/mn10300/include/asm/proc-mn103e010/clock.h   |   18 ---
 arch/mn10300/include/asm/proc-mn103e010/irq.h     |   34 -----
 arch/mn10300/include/asm/proc-mn103e010/proc.h    |   18 ---
 arch/mn10300/include/asm/serial.h                 |    2 
 arch/mn10300/include/asm/timex.h                  |    2 
 arch/mn10300/include/asm/unit-asb2303/clock.h     |   45 -------
 arch/mn10300/include/asm/unit-asb2303/leds.h      |   43 -------
 arch/mn10300/include/asm/unit-asb2303/serial.h    |  136 ---------------------
 arch/mn10300/include/asm/unit-asb2303/smc91111.h  |   50 --------
 arch/mn10300/include/asm/unit-asb2303/timex.h     |  135 ---------------------
 arch/mn10300/include/asm/unit-asb2305/clock.h     |   45 -------
 arch/mn10300/include/asm/unit-asb2305/leds.h      |   51 --------
 arch/mn10300/include/asm/unit-asb2305/serial.h    |  120 -------------------
 arch/mn10300/include/asm/unit-asb2305/timex.h     |  135 ---------------------
 arch/mn10300/kernel/entry.S                       |    2 
 arch/mn10300/kernel/gdb-io-serial-low.S           |    2 
 arch/mn10300/kernel/gdb-io-serial.c               |    2 
 arch/mn10300/kernel/gdb-io-ttysm-low.S            |    2 
 arch/mn10300/kernel/gdb-io-ttysm.c                |    2 
 arch/mn10300/kernel/gdb-stub.c                    |    4 -
 arch/mn10300/kernel/head.S                        |    2 
 arch/mn10300/kernel/mn10300-serial-low.S          |    4 -
 arch/mn10300/kernel/mn10300-serial.c              |    2 
 arch/mn10300/kernel/mn10300-watchdog.c            |    2 
 arch/mn10300/kernel/setup.c                       |    2 
 arch/mn10300/kernel/traps.c                       |    2 
 arch/mn10300/proc-mn103e010/include/proc/cache.h  |   33 +++++
 arch/mn10300/proc-mn103e010/include/proc/clock.h  |   18 +++
 arch/mn10300/proc-mn103e010/include/proc/irq.h    |   34 +++++
 arch/mn10300/proc-mn103e010/include/proc/proc.h   |   18 +++
 arch/mn10300/unit-asb2303/include/unit/clock.h    |   45 +++++++
 arch/mn10300/unit-asb2303/include/unit/leds.h     |   43 +++++++
 arch/mn10300/unit-asb2303/include/unit/serial.h   |  136 +++++++++++++++++++++
 arch/mn10300/unit-asb2303/include/unit/smc91111.h |   50 ++++++++
 arch/mn10300/unit-asb2303/include/unit/timex.h    |  135 +++++++++++++++++++++
 arch/mn10300/unit-asb2303/leds.c                  |    2 
 arch/mn10300/unit-asb2303/smc91111.c              |    2 
 arch/mn10300/unit-asb2305/include/unit/clock.h    |   45 +++++++
 arch/mn10300/unit-asb2305/include/unit/leds.h     |   51 ++++++++
 arch/mn10300/unit-asb2305/include/unit/serial.h   |  120 +++++++++++++++++++
 arch/mn10300/unit-asb2305/include/unit/timex.h    |  135 +++++++++++++++++++++
 arch/mn10300/unit-asb2305/leds.c                  |    2 
 arch/mn10300/unit-asb2305/unit-init.c             |    2 
 47 files changed, 888 insertions(+), 922 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/proc-mn103e010/cache.h
 delete mode 100644 arch/mn10300/include/asm/proc-mn103e010/clock.h
 delete mode 100644 arch/mn10300/include/asm/proc-mn103e010/irq.h
 delete mode 100644 arch/mn10300/include/asm/proc-mn103e010/proc.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2303/clock.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2303/leds.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2303/serial.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2303/smc91111.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2303/timex.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2305/clock.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2305/leds.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2305/serial.h
 delete mode 100644 arch/mn10300/include/asm/unit-asb2305/timex.h
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/cache.h
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/clock.h
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/irq.h
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/proc.h
 create mode 100644 arch/mn10300/unit-asb2303/include/unit/clock.h
 create mode 100644 arch/mn10300/unit-asb2303/include/unit/leds.h
 create mode 100644 arch/mn10300/unit-asb2303/include/unit/serial.h
 create mode 100644 arch/mn10300/unit-asb2303/include/unit/smc91111.h
 create mode 100644 arch/mn10300/unit-asb2303/include/unit/timex.h
 create mode 100644 arch/mn10300/unit-asb2305/include/unit/clock.h
 create mode 100644 arch/mn10300/unit-asb2305/include/unit/leds.h
 create mode 100644 arch/mn10300/unit-asb2305/include/unit/serial.h
 create mode 100644 arch/mn10300/unit-asb2305/include/unit/timex.h


diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index a5985ee..dd0c8ff 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -94,42 +94,8 @@ ifdef CONFIG_DEBUG_INFO
 KBUILD_AFLAGS	+= -Wa,--gdwarf2
 endif
 
-###################################################################################################
 #
-# juggle some symlinks in the MN10300 asm include dir
+# include the appropriate processor- and unit-specific headers
 #
-#	Update machine proc and unit symlinks if something which affects
-#	them changed.  We use .proc / .unit to indicate when they were
-#	updated last, otherwise make uses the target directory mtime.
-#
-###################################################################################################
-
-# processor specific definitions
-arch/mn10300/include/asm/.proc: $(wildcard include/config/proc/*.h) include/config/auto.conf
-	@echo '  SYMLINK arch/mn10300/include/asm/proc -> arch/mn10300/include/asm/proc-$(PROCESSOR)'
-ifneq ($(KBUILD_SRC),)
-	$(Q)mkdir -p arch/mn10300/include/asm
-	$(Q)ln -fsn $(srctree)/arch/mn10300/include/asm/proc-$(PROCESSOR) arch/mn10300/include/asm/proc
-else
-	$(Q)ln -fsn proc-$(PROCESSOR) arch/mn10300/include/asm/proc
-endif
-	@touch $@
-
-CLEAN_FILES += arch/mn10300/include/asm/proc arch/mn10300/include/asm/.proc
-
-prepare: arch/mn10300/include/asm/.proc
-
-# unit specific definitions
-arch/mn10300/include/asm/.unit: $(wildcard include/config/unit/*.h) include/config/auto.conf
-	@echo '  SYMLINK arch/mn10300/include/asm/unit -> arch/mn10300/include/asm/unit-$(UNIT)'
-ifneq ($(KBUILD_SRC),)
-	$(Q)mkdir -p arch/mn10300/include/asm
-	$(Q)ln -fsn $(srctree)/arch/mn10300/include/asm/unit-$(UNIT) arch/mn10300/include/asm/unit
-else
-	$(Q)ln -fsn unit-$(UNIT) arch/mn10300/include/asm/unit
-endif
-	@touch $@
-
-CLEAN_FILES += arch/mn10300/include/asm/unit arch/mn10300/include/asm/.unit
-
-prepare: arch/mn10300/include/asm/.unit
+KBUILD_CPPFLAGS += -I$(srctree)/arch/mn10300/proc-$(PROCESSOR)/include
+KBUILD_CPPFLAGS += -I$(srctree)/arch/mn10300/unit-$(UNIT)/include
diff --git a/arch/mn10300/include/asm/cache.h b/arch/mn10300/include/asm/cache.h
index 9e01122..e03cfa2 100644
--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -13,7 +13,7 @@
 #define _ASM_CACHE_H
 
 #include <asm/cpu-regs.h>
-#include <asm/proc/cache.h>
+#include <proc/cache.h>
 
 #ifndef __ASSEMBLY__
 #define L1_CACHE_DISPARITY	(L1_CACHE_NENTRIES * L1_CACHE_BYTES)
diff --git a/arch/mn10300/include/asm/irq.h b/arch/mn10300/include/asm/irq.h
index 53b3801..25c045d 100644
--- a/arch/mn10300/include/asm/irq.h
+++ b/arch/mn10300/include/asm/irq.h
@@ -16,7 +16,7 @@
 
 #include <asm/intctl-regs.h>
 #include <asm/reset-regs.h>
-#include <asm/proc/irq.h>
+#include <proc/irq.h>
 
 /* this number is used when no interrupt has been assigned */
 #define NO_IRQ		INT_MAX
diff --git a/arch/mn10300/include/asm/proc-mn103e010/cache.h b/arch/mn10300/include/asm/proc-mn103e010/cache.h
deleted file mode 100644
index bdc1f9a..0000000
--- a/arch/mn10300/include/asm/proc-mn103e010/cache.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* MN103E010 Cache specification
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_PROC_CACHE_H
-#define _ASM_PROC_CACHE_H
-
-/* L1 cache */
-
-#define L1_CACHE_NWAYS		4	/* number of ways in caches */
-#define L1_CACHE_NENTRIES	256	/* number of entries in each way */
-#define L1_CACHE_BYTES		16	/* bytes per entry */
-#define L1_CACHE_SHIFT		4	/* shift for bytes per entry */
-#define L1_CACHE_WAYDISP	0x1000	/* displacement of one way from the next */
-
-#define L1_CACHE_TAG_VALID	0x00000001	/* cache tag valid bit */
-#define L1_CACHE_TAG_DIRTY	0x00000008	/* data cache tag dirty bit */
-#define L1_CACHE_TAG_ENTRY	0x00000ff0	/* cache tag entry address mask */
-#define L1_CACHE_TAG_ADDRESS	0xfffff000	/* cache tag line address mask */
-
-/*
- * specification of the interval between interrupt checking intervals whilst
- * managing the cache with the interrupts disabled
- */
-#define MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL	4
-
-#endif /* _ASM_PROC_CACHE_H */
diff --git a/arch/mn10300/include/asm/proc-mn103e010/clock.h b/arch/mn10300/include/asm/proc-mn103e010/clock.h
deleted file mode 100644
index caf9983..0000000
--- a/arch/mn10300/include/asm/proc-mn103e010/clock.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* MN103E010-specific clocks
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_PROC_CLOCK_H
-#define _ASM_PROC_CLOCK_H
-
-#include <asm/unit/clock.h>
-
-#define MN10300_WDCLK		MN10300_IOCLK
-
-#endif /* _ASM_PROC_CLOCK_H */
diff --git a/arch/mn10300/include/asm/proc-mn103e010/irq.h b/arch/mn10300/include/asm/proc-mn103e010/irq.h
deleted file mode 100644
index aa6ee8f..0000000
--- a/arch/mn10300/include/asm/proc-mn103e010/irq.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* MN103E010 On-board interrupt controller numbers
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_PROC_IRQ_H
-#define _ASM_PROC_IRQ_H
-
-#ifdef __KERNEL__
-
-#define GxICR_NUM_IRQS		42
-
-#define GxICR_NUM_XIRQS		8
-
-#define XIRQ0		34
-#define XIRQ1		35
-#define XIRQ2		36
-#define XIRQ3		37
-#define XIRQ4		38
-#define XIRQ5		39
-#define XIRQ6		40
-#define XIRQ7		41
-
-#define XIRQ2IRQ(num)	(XIRQ0 + num)
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_PROC_IRQ_H */
diff --git a/arch/mn10300/include/asm/proc-mn103e010/proc.h b/arch/mn10300/include/asm/proc-mn103e010/proc.h
deleted file mode 100644
index 22a2b93..0000000
--- a/arch/mn10300/include/asm/proc-mn103e010/proc.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* MN103E010 Processor description
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_PROC_PROC_H
-#define _ASM_PROC_PROC_H
-
-#define PROCESSOR_VENDOR_NAME	"Matsushita"
-#define PROCESSOR_MODEL_NAME	"mn103e010"
-
-#endif /* _ASM_PROC_PROC_H */
diff --git a/arch/mn10300/include/asm/serial.h b/arch/mn10300/include/asm/serial.h
index 99785a9..a29445c 100644
--- a/arch/mn10300/include/asm/serial.h
+++ b/arch/mn10300/include/asm/serial.h
@@ -33,4 +33,4 @@
 #define RS_TABLE_SIZE
 #endif
 
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
diff --git a/arch/mn10300/include/asm/timex.h b/arch/mn10300/include/asm/timex.h
index 3944277..8d031f9 100644
--- a/arch/mn10300/include/asm/timex.h
+++ b/arch/mn10300/include/asm/timex.h
@@ -12,7 +12,7 @@
 #define _ASM_TIMEX_H
 
 #include <asm/hardirq.h>
-#include <asm/unit/timex.h>
+#include <unit/timex.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
diff --git a/arch/mn10300/include/asm/unit-asb2303/clock.h b/arch/mn10300/include/asm/unit-asb2303/clock.h
deleted file mode 100644
index 8b450e9..0000000
--- a/arch/mn10300/include/asm/unit-asb2303/clock.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* ASB2303-specific clocks
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNIT_CLOCK_H
-#define _ASM_UNIT_CLOCK_H
-
-#ifndef __ASSEMBLY__
-
-#ifdef CONFIG_MN10300_RTC
-
-extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
-extern unsigned long mn10300_iobclk;
-extern unsigned long mn10300_tsc_per_HZ;
-
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
-/* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
-
-#else /* !CONFIG_MN10300_RTC */
-
-#define MN10300_IOCLK		33333333UL
-/* #define MN10300_IOBCLK	66666666UL */
-
-#endif /* !CONFIG_MN10300_RTC */
-
-#define MN10300_JCCLK		MN10300_IOCLK
-#define MN10300_TSCCLK		MN10300_IOCLK
-
-#ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
-#else /* !CONFIG_MN10300_RTC */
-#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
-#endif /* !CONFIG_MN10300_RTC */
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/include/asm/unit-asb2303/leds.h b/arch/mn10300/include/asm/unit-asb2303/leds.h
deleted file mode 100644
index 3a7543e..0000000
--- a/arch/mn10300/include/asm/unit-asb2303/leds.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/* ASB2303-specific LEDs
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNIT_LEDS_H
-#define _ASM_UNIT_LEDS_H
-
-#include <asm/pio-regs.h>
-#include <asm/cpu-regs.h>
-#include <asm/exceptions.h>
-
-#define ASB2303_GPIO0DEF	__SYSREG(0xDB000000, u32)
-#define ASB2303_7SEGLEDS	__SYSREG(0xDB000008, u32)
-
-/*
- * use the 7-segment LEDs to indicate states
- */
-
-/* flip the 7-segment LEDs between "G" and "-" */
-#define mn10300_set_gdbleds(ONOFF)			\
-do {							\
-	ASB2303_7SEGLEDS = (ONOFF) ? 0x85 : 0x7f;	\
-} while (0)
-
-/* indicate double-fault by displaying "d" on the LEDs */
-#define mn10300_set_dbfleds			\
-	mov	0x43,d0			;	\
-	movbu	d0,(ASB2303_7SEGLEDS)
-
-#ifndef __ASSEMBLY__
-extern void peripheral_leds_display_exception(enum exception_code code);
-extern void peripheral_leds_led_chase(void);
-extern void debug_to_serial(const char *p, int n);
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_LEDS_H */
diff --git a/arch/mn10300/include/asm/unit-asb2303/serial.h b/arch/mn10300/include/asm/unit-asb2303/serial.h
deleted file mode 100644
index 0d55cf5..0000000
--- a/arch/mn10300/include/asm/unit-asb2303/serial.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/* ASB2303-specific 8250 serial ports
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNIT_SERIAL_H
-#define _ASM_UNIT_SERIAL_H
-
-#include <asm/cpu-regs.h>
-#include <asm/proc/irq.h>
-#include <linux/serial_reg.h>
-
-#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
-#define SERIAL_PORT1_BASE_ADDRESS	0xA6FC0000
-
-#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
-
-/*
- * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
- */
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
-
-#define SERIAL_PORT_DFNS						\
-	{								\
-	.baud_base		= BASE_BAUD,				\
-	.irq			= SERIAL_IRQ,				\
-	.flags			= STD_COM_FLAGS,			\
-	.iomem_base		= (u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
-	.iomem_reg_shift	= 2,					\
-	.io_type		= SERIAL_IO_MEM,			\
-	},								\
-	{								\
-	.baud_base		= BASE_BAUD,				\
-	.irq			= SERIAL_IRQ,				\
-	.flags			= STD_COM_FLAGS,			\
-	.iomem_base		= (u8 *) SERIAL_PORT1_BASE_ADDRESS,	\
-	.iomem_reg_shift	= 2,					\
-	.io_type		= SERIAL_IO_MEM,			\
-	},
-
-#ifndef __ASSEMBLY__
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#else /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#define SERIAL_PORT_DFNS /* both stolen by gdb-stub because they share an IRQ */
-
-#if defined(CONFIG_GDBSTUB_ON_TTYS0)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-
-#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-#endif
-
-#ifndef __ASSEMBLY__
-
-#define LSR_WAIT_FOR(STATE)					\
-do {								\
-	while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE)) {}	\
-} while (0)
-#define FLOWCTL_WAIT_FOR(LINE)					\
-do {								\
-	while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE)) {}	\
-} while (0)
-#define FLOWCTL_CLEAR(LINE)			\
-do {						\
-	GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE;	\
-} while (0)
-#define FLOWCTL_SET(LINE)			\
-do {						\
-	GDBPORT_SERIAL_MCR |= UART_MCR_##LINE;	\
-} while (0)
-#define FLOWCTL_QUERY(LINE)	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-	char ch;
-
-	FLOWCTL_SET(DTR);
-
-	for (; n > 0; n--) {
-		LSR_WAIT_FOR(THRE);
-		FLOWCTL_WAIT_FOR(CTS);
-
-		ch = *p++;
-		if (ch == 0x0a) {
-			GDBPORT_SERIAL_TX = 0x0d;
-			LSR_WAIT_FOR(THRE);
-			FLOWCTL_WAIT_FOR(CTS);
-		}
-		GDBPORT_SERIAL_TX = ch;
-	}
-
-	FLOWCTL_CLEAR(DTR);
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/include/asm/unit-asb2303/smc91111.h b/arch/mn10300/include/asm/unit-asb2303/smc91111.h
deleted file mode 100644
index dd456e9..0000000
--- a/arch/mn10300/include/asm/unit-asb2303/smc91111.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* Support for the SMC91C111 NIC on an ASB2303
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_UNIT_SMC91111_H
-#define _ASM_UNIT_SMC91111_H
-
-#include <asm/intctl-regs.h>
-
-#define SMC91111_BASE		0xAA000300UL
-#define SMC91111_BASE_END	0xAA000400UL
-#define SMC91111_IRQ		XIRQ3
-
-#define SMC_CAN_USE_8BIT	0
-#define SMC_CAN_USE_16BIT	1
-#define SMC_CAN_USE_32BIT	0
-#define SMC_NOWAIT		1
-#define SMC_IRQ_FLAGS		(0)
-
-#if SMC_CAN_USE_8BIT
-#define SMC_inb(a, r)		inb((unsigned long) ((a) + (r)))
-#define SMC_outb(v, a, r)	outb(v, (unsigned long) ((a) + (r)))
-#endif
-
-#if SMC_CAN_USE_16BIT
-#define SMC_inw(a, r)		inw((unsigned long) ((a) + (r)))
-#define SMC_outw(v, a, r)	outw(v, (unsigned long) ((a) + (r)))
-#define SMC_insw(a, r, p, l)	insw((unsigned long) ((a) + (r)), (p), (l))
-#define SMC_outsw(a, r, p, l)	outsw((unsigned long) ((a) + (r)), (p), (l))
-#endif
-
-#if SMC_CAN_USE_32BIT
-#define SMC_inl(a, r)		inl((unsigned long) ((a) + (r)))
-#define SMC_outl(v, a, r)	outl(v, (unsigned long) ((a) + (r)))
-#define SMC_insl(a, r, p, l)	insl((unsigned long) ((a) + (r)), (p), (l))
-#define SMC_outsl(a, r, p, l)	outsl((unsigned long) ((a) + (r)), (p), (l))
-#endif
-
-#define RPC_LSA_DEFAULT		RPC_LED_100_10
-#define RPC_LSB_DEFAULT		RPC_LED_TX_RX
-
-#define set_irq_type(irq, type)
-
-#endif /*  _ASM_UNIT_SMC91111_H */
diff --git a/arch/mn10300/include/asm/unit-asb2303/timex.h b/arch/mn10300/include/asm/unit-asb2303/timex.h
deleted file mode 100644
index 7e54b0c..0000000
--- a/arch/mn10300/include/asm/unit-asb2303/timex.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/* ASB2303-specific timer specifcations
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_UNIT_TIMEX_H
-#define _ASM_UNIT_TIMEX_H
-
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
-#include <asm/timer-regs.h>
-#include <asm/unit/clock.h>
-
-/*
- * jiffies counter specifications
- */
-
-#define	TMJCBR_MAX		0xffff
-#define	TMJCBC			TM01BC
-
-#define	TMJCMD			TM01MD
-#define	TMJCBR			TM01BR
-#define	TMJCIRQ			TM1IRQ
-#define	TMJCICR			TM1ICR
-#define	TMJCICR_LEVEL		GxICR_LEVEL_5
-
-#ifndef __ASSEMBLY__
-
-static inline void startup_jiffies_counter(void)
-{
-	unsigned rate;
-	u16 md, t16;
-
-	/* use as little prescaling as possible to avoid losing accuracy */
-	md = TM0MD_SRC_IOCLK;
-	rate = MN10300_JCCLK / HZ;
-
-	if (rate > TMJCBR_MAX) {
-		md = TM0MD_SRC_IOCLK_8;
-		rate = MN10300_JCCLK / 8 / HZ;
-
-		if (rate > TMJCBR_MAX) {
-			md = TM0MD_SRC_IOCLK_32;
-			rate = MN10300_JCCLK / 32 / HZ;
-
-			if (rate > TMJCBR_MAX)
-				BUG();
-		}
-	}
-
-	TMJCBR = rate - 1;
-	t16 = TMJCBR;
-
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_INIT_COUNTER |
-		TM1MD_INIT_COUNTER << 8;
-
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_COUNT_ENABLE |
-		TM1MD_COUNT_ENABLE << 8;
-
-	t16 = TMJCMD;
-
-	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	t16 = TMJCICR;
-}
-
-static inline void shutdown_jiffies_counter(void)
-{
-}
-
-#endif /* !__ASSEMBLY__ */
-
-
-/*
- * timestamp counter specifications
- */
-
-#define	TMTSCBR_MAX		0xffffffff
-#define	TMTSCBC			TM45BC
-
-#ifndef __ASSEMBLY__
-
-static inline void startup_timestamp_counter(void)
-{
-	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
-	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
-	 */
-	TM45BR = TMTSCBR_MAX;
-
-	TM4MD = TM4MD_SRC_IOCLK;
-	TM4MD |= TM4MD_INIT_COUNTER;
-	TM4MD &= ~TM4MD_INIT_COUNTER;
-	TM4ICR = 0;
-
-	TM5MD = TM5MD_SRC_TM4CASCADE;
-	TM5MD |= TM5MD_INIT_COUNTER;
-	TM5MD &= ~TM5MD_INIT_COUNTER;
-	TM5ICR = 0;
-
-	TM5MD |= TM5MD_COUNT_ENABLE;
-	TM4MD |= TM4MD_COUNT_ENABLE;
-}
-
-static inline void shutdown_timestamp_counter(void)
-{
-	TM4MD = 0;
-	TM5MD = 0;
-}
-
-/*
- * we use a cascaded pair of 16-bit down-counting timers to count I/O
- * clock cycles for the purposes of time keeping
- */
-typedef unsigned long cycles_t;
-
-static inline cycles_t read_timestamp_counter(void)
-{
-	return (cycles_t)TMTSCBC;
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_TIMEX_H */
diff --git a/arch/mn10300/include/asm/unit-asb2305/clock.h b/arch/mn10300/include/asm/unit-asb2305/clock.h
deleted file mode 100644
index 7d51484..0000000
--- a/arch/mn10300/include/asm/unit-asb2305/clock.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* ASB2305-specific clocks
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNIT_CLOCK_H
-#define _ASM_UNIT_CLOCK_H
-
-#ifndef __ASSEMBLY__
-
-#ifdef CONFIG_MN10300_RTC
-
-extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
-extern unsigned long mn10300_iobclk;
-extern unsigned long mn10300_tsc_per_HZ;
-
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
-/* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
-
-#else /* !CONFIG_MN10300_RTC */
-
-#define MN10300_IOCLK		33333333UL
-/* #define MN10300_IOBCLK	66666666UL */
-
-#endif /* !CONFIG_MN10300_RTC */
-
-#define MN10300_JCCLK		MN10300_IOCLK
-#define MN10300_TSCCLK		MN10300_IOCLK
-
-#ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
-#else /* !CONFIG_MN10300_RTC */
-#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
-#endif /* !CONFIG_MN10300_RTC */
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/include/asm/unit-asb2305/leds.h b/arch/mn10300/include/asm/unit-asb2305/leds.h
deleted file mode 100644
index bc471f6..0000000
--- a/arch/mn10300/include/asm/unit-asb2305/leds.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* ASB2305-specific LEDs
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNIT_LEDS_H
-#define _ASM_UNIT_LEDS_H
-
-#include <asm/pio-regs.h>
-#include <asm/cpu-regs.h>
-#include <asm/exceptions.h>
-
-#define ASB2305_7SEGLEDS	__SYSREG(0xA6F90000, u32)
-
-/* perform a hard reset by driving PIO06 low */
-#define mn10300_unit_hard_reset()		\
-do {						\
-	P0OUT &= 0xbf;				\
-	P0MD = (P0MD & P0MD_6) | P0MD_6_OUT;	\
-} while (0)
-
-/*
- * use the 7-segment LEDs to indicate states
- */
-/* indicate double-fault by displaying "db-f" on the LEDs */
-#define mn10300_set_dbfleds			\
-	mov	0x43077f1d,d0		;	\
-	mov	d0,(ASB2305_7SEGLEDS)
-
-/* flip the 7-segment LEDs between "Gdb-" and "----" */
-#define mn10300_set_gdbleds(ONOFF)				\
-do {								\
-	ASB2305_7SEGLEDS = (ONOFF) ? 0x8543077f : 0x7f7f7f7f;	\
-} while (0)
-
-#ifndef __ASSEMBLY__
-extern void peripheral_leds_display_exception(enum exception_code);
-extern void peripheral_leds_led_chase(void);
-extern void peripheral_leds7x4_display_dec(unsigned int, unsigned int);
-extern void peripheral_leds7x4_display_hex(unsigned int, unsigned int);
-extern void peripheral_leds7x4_display_minssecs(unsigned int, unsigned int);
-extern void peripheral_leds7x4_display_rtc(void);
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_LEDS_H */
diff --git a/arch/mn10300/include/asm/unit-asb2305/serial.h b/arch/mn10300/include/asm/unit-asb2305/serial.h
deleted file mode 100644
index 73d31d6..0000000
--- a/arch/mn10300/include/asm/unit-asb2305/serial.h
+++ /dev/null
@@ -1,120 +0,0 @@
-/* ASB2305-specific 8250 serial ports
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_UNIT_SERIAL_H
-#define _ASM_UNIT_SERIAL_H
-
-#include <asm/cpu/cpu-regs.h>
-#include <asm/proc/irq.h>
-#include <linux/serial_reg.h>
-
-#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
-#define ASB2305_DEBUG_MCR	__SYSREG(0xA6FB0000 + UART_MCR * 2, u8)
-
-#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
-
-/*
- * dispose of the /dev/ttyS0 serial port
- */
-#ifndef CONFIG_GDBSTUB_ON_TTYSx
-
-#define SERIAL_PORT_DFNS						\
-	{								\
-	.baud_base		= BASE_BAUD,				\
-	.irq			= SERIAL_IRQ,				\
-	.flags			= STD_COM_FLAGS,			\
-	.iomem_base		= (u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
-	.iomem_reg_shift	= 2,					\
-	.io_type		= SERIAL_IO_MEM,			\
-	},
-
-#ifndef __ASSEMBLY__
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#else /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
-
-#if defined(CONFIG_GDBSTUB_ON_TTYS0)
-#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
-#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
-#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
-#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
-#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
-#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
-#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
-#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
-#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
-
-#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
-#error The ASB2305 doesnt have a /dev/ttyS1
-#endif
-
-#ifndef __ASSEMBLY__
-
-#define TTYS0_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
-#define TTYS0_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
-#define TTYS0_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
-#define TTYS0_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
-
-#define LSR_WAIT_FOR(STATE)				\
-do {							\
-	while (!(TTYS0_LSR & UART_LSR_##STATE)) {}	\
-} while (0)
-#define FLOWCTL_WAIT_FOR(LINE)				\
-do {							\
-	while (!(TTYS0_MSR & UART_MSR_##LINE)) {}	\
-} while (0)
-#define FLOWCTL_CLEAR(LINE)			\
-do {						\
-	TTYS0_MCR &= ~UART_MCR_##LINE;		\
-} while (0)
-#define FLOWCTL_SET(LINE)			\
-do {						\
-	TTYS0_MCR |= UART_MCR_##LINE;		\
-} while (0)
-#define FLOWCTL_QUERY(LINE)	({ TTYS0_MSR & UART_MSR_##LINE; })
-
-static inline void __debug_to_serial(const char *p, int n)
-{
-	char ch;
-
-	FLOWCTL_SET(DTR);
-
-	for (; n > 0; n--) {
-		LSR_WAIT_FOR(THRE);
-		FLOWCTL_WAIT_FOR(CTS);
-
-		ch = *p++;
-		if (ch == 0x0a) {
-			TTYS0_TX = 0x0d;
-			LSR_WAIT_FOR(THRE);
-			FLOWCTL_WAIT_FOR(CTS);
-		}
-		TTYS0_TX = ch;
-	}
-
-	FLOWCTL_CLEAR(DTR);
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* CONFIG_GDBSTUB_ON_TTYSx */
-
-#endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/include/asm/unit-asb2305/timex.h b/arch/mn10300/include/asm/unit-asb2305/timex.h
deleted file mode 100644
index 10e1bfe..0000000
--- a/arch/mn10300/include/asm/unit-asb2305/timex.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/* ASB2305 timer specifcations
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_UNIT_TIMEX_H
-#define _ASM_UNIT_TIMEX_H
-
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
-#include <asm/cpu/timer-regs.h>
-#include <asm/unit/clock.h>
-
-/*
- * jiffies counter specifications
- */
-
-#define	TMJCBR_MAX		0xffff
-#define	TMJCBC			TM01BC
-
-#define	TMJCMD			TM01MD
-#define	TMJCBR			TM01BR
-#define	TMJCIRQ			TM1IRQ
-#define	TMJCICR			TM1ICR
-#define	TMJCICR_LEVEL		GxICR_LEVEL_5
-
-#ifndef __ASSEMBLY__
-
-static inline void startup_jiffies_counter(void)
-{
-	unsigned rate;
-	u16 md, t16;
-
-	/* use as little prescaling as possible to avoid losing accuracy */
-	md = TM0MD_SRC_IOCLK;
-	rate = MN10300_JCCLK / HZ;
-
-	if (rate > TMJCBR_MAX) {
-		md = TM0MD_SRC_IOCLK_8;
-		rate = MN10300_JCCLK / 8 / HZ;
-
-		if (rate > TMJCBR_MAX) {
-			md = TM0MD_SRC_IOCLK_32;
-			rate = MN10300_JCCLK / 32 / HZ;
-
-			if (rate > TMJCBR_MAX)
-				BUG();
-		}
-	}
-
-	TMJCBR = rate - 1;
-	t16 = TMJCBR;
-
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_INIT_COUNTER |
-		TM1MD_INIT_COUNTER << 8;
-
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_COUNT_ENABLE |
-		TM1MD_COUNT_ENABLE << 8;
-
-	t16 = TMJCMD;
-
-	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	t16 = TMJCICR;
-}
-
-static inline void shutdown_jiffies_counter(void)
-{
-}
-
-#endif /* !__ASSEMBLY__ */
-
-
-/*
- * timestamp counter specifications
- */
-
-#define	TMTSCBR_MAX		0xffffffff
-#define	TMTSCBC			TM45BC
-
-#ifndef __ASSEMBLY__
-
-static inline void startup_timestamp_counter(void)
-{
-	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
-	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
-	 */
-	TM45BR = TMTSCBR_MAX;
-
-	TM4MD = TM4MD_SRC_IOCLK;
-	TM4MD |= TM4MD_INIT_COUNTER;
-	TM4MD &= ~TM4MD_INIT_COUNTER;
-	TM4ICR = 0;
-
-	TM5MD = TM5MD_SRC_TM4CASCADE;
-	TM5MD |= TM5MD_INIT_COUNTER;
-	TM5MD &= ~TM5MD_INIT_COUNTER;
-	TM5ICR = 0;
-
-	TM5MD |= TM5MD_COUNT_ENABLE;
-	TM4MD |= TM4MD_COUNT_ENABLE;
-}
-
-static inline void shutdown_timestamp_counter(void)
-{
-	TM4MD = 0;
-	TM5MD = 0;
-}
-
-/*
- * we use a cascaded pair of 16-bit down-counting timers to count I/O
- * clock cycles for the purposes of time keeping
- */
-typedef unsigned long cycles_t;
-
-static inline cycles_t read_timestamp_counter(void)
-{
-	return (cycles_t) TMTSCBC;
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_UNIT_TIMEX_H */
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index ceeaaaa..34ab5a2 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -20,7 +20,7 @@
 #include <asm/intctl-regs.h>
 #include <asm/busctl-regs.h>
 #include <asm/timer-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/errno.h>
diff --git a/arch/mn10300/kernel/gdb-io-serial-low.S b/arch/mn10300/kernel/gdb-io-serial-low.S
index c68dcd0..4998b24 100644
--- a/arch/mn10300/kernel/gdb-io-serial-low.S
+++ b/arch/mn10300/kernel/gdb-io-serial-low.S
@@ -18,7 +18,7 @@
 #include <asm/thread_info.h>
 #include <asm/frame.inc>
 #include <asm/intctl-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 	.text
 
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index 11584c5..ae663dc 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -22,7 +22,7 @@
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/serial-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 /*
  * initialise the GDB stub
diff --git a/arch/mn10300/kernel/gdb-io-ttysm-low.S b/arch/mn10300/kernel/gdb-io-ttysm-low.S
index 677c787..060b7cc 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm-low.S
+++ b/arch/mn10300/kernel/gdb-io-ttysm-low.S
@@ -18,7 +18,7 @@
 #include <asm/cpu-regs.h>
 #include <asm/frame.inc>
 #include <asm/intctl-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 #include "mn10300-serial.h"
 
 	.text
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index e94c25e..a560bbc 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -20,7 +20,7 @@
 #include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
-#include <asm/unit/clock.h>
+#include <unit/clock.h>
 #include "mn10300-serial.h"
 
 #if defined(CONFIG_GDBSTUB_ON_TTYSM0)
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 0ea7482..41b1170 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -136,8 +136,8 @@
 #include <asm/cacheflush.h>
 #include <asm/serial-regs.h>
 #include <asm/busctl-regs.h>
-#include <asm/unit/leds.h>
-#include <asm/unit/serial.h>
+#include <unit/leds.h>
+#include <unit/serial.h>
 
 /* define to use F7F7 rather than FF which is subverted by JTAG debugger */
 #undef GDBSTUB_USE_F7F7_AS_BREAKPOINT
diff --git a/arch/mn10300/kernel/head.S b/arch/mn10300/kernel/head.S
index 606bd8c..8a8309f 100644
--- a/arch/mn10300/kernel/head.S
+++ b/arch/mn10300/kernel/head.S
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/frame.inc>
 #include <asm/param.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 	.section .text.head,"ax"
 
diff --git a/arch/mn10300/kernel/mn10300-serial-low.S b/arch/mn10300/kernel/mn10300-serial-low.S
index ef3f4c1..2244853 100644
--- a/arch/mn10300/kernel/mn10300-serial-low.S
+++ b/arch/mn10300/kernel/mn10300-serial-low.S
@@ -18,8 +18,8 @@
 #include <asm/cpu-regs.h>
 #include <asm/frame.inc>
 #include <asm/timer-regs.h>
-#include <asm/proc/cache.h>
-#include <asm/unit/timex.h>
+#include <proc/cache.h>
+#include <unit/timex.h>
 #include "mn10300-serial.h"
 
 #define	SCxCTR	0x00
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 59b9c4b..2fd5966 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -41,7 +41,7 @@ static const char serial_revdate[] = "2007-11-06";
 #include <asm/irq.h>
 #include <asm/bitops.h>
 #include <asm/serial-regs.h>
-#include <asm/unit/timex.h>
+#include <unit/timex.h>
 #include "mn10300-serial.h"
 
 static inline __attribute__((format(printf, 1, 2)))
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index 2e370d8..f362d9d 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -25,7 +25,7 @@
 #include <asm/div64.h>
 #include <asm/smp.h>
 #include <asm/gdb-stub.h>
-#include <asm/proc/clock.h>
+#include <proc/clock.h>
 
 static DEFINE_SPINLOCK(watchdog_print_lock);
 static unsigned int watchdog;
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index e1d88ab..71414e1 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -30,7 +30,7 @@
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/proc/proc.h>
+#include <proc/proc.h>
 #include <asm/busctl-regs.h>
 #include <asm/fpu.h>
 #include <asm/sections.h>
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index fcb9a03..681ad8c 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -37,7 +37,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu-regs.h>
 #include <asm/busctl-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 #include <asm/fpu.h>
 #include <asm/gdb-stub.h>
 #include <asm/sections.h>
diff --git a/arch/mn10300/proc-mn103e010/include/proc/cache.h b/arch/mn10300/proc-mn103e010/include/proc/cache.h
new file mode 100644
index 0000000..bdc1f9a
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/cache.h
@@ -0,0 +1,33 @@
+/* MN103E010 Cache specification
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CACHE_H
+#define _ASM_PROC_CACHE_H
+
+/* L1 cache */
+
+#define L1_CACHE_NWAYS		4	/* number of ways in caches */
+#define L1_CACHE_NENTRIES	256	/* number of entries in each way */
+#define L1_CACHE_BYTES		16	/* bytes per entry */
+#define L1_CACHE_SHIFT		4	/* shift for bytes per entry */
+#define L1_CACHE_WAYDISP	0x1000	/* displacement of one way from the next */
+
+#define L1_CACHE_TAG_VALID	0x00000001	/* cache tag valid bit */
+#define L1_CACHE_TAG_DIRTY	0x00000008	/* data cache tag dirty bit */
+#define L1_CACHE_TAG_ENTRY	0x00000ff0	/* cache tag entry address mask */
+#define L1_CACHE_TAG_ADDRESS	0xfffff000	/* cache tag line address mask */
+
+/*
+ * specification of the interval between interrupt checking intervals whilst
+ * managing the cache with the interrupts disabled
+ */
+#define MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL	4
+
+#endif /* _ASM_PROC_CACHE_H */
diff --git a/arch/mn10300/proc-mn103e010/include/proc/clock.h b/arch/mn10300/proc-mn103e010/include/proc/clock.h
new file mode 100644
index 0000000..aa23e14
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/clock.h
@@ -0,0 +1,18 @@
+/* MN103E010-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CLOCK_H
+#define _ASM_PROC_CLOCK_H
+
+#include <unit/clock.h>
+
+#define MN10300_WDCLK		MN10300_IOCLK
+
+#endif /* _ASM_PROC_CLOCK_H */
diff --git a/arch/mn10300/proc-mn103e010/include/proc/irq.h b/arch/mn10300/proc-mn103e010/include/proc/irq.h
new file mode 100644
index 0000000..aa6ee8f
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/irq.h
@@ -0,0 +1,34 @@
+/* MN103E010 On-board interrupt controller numbers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_IRQ_H
+#define _ASM_PROC_IRQ_H
+
+#ifdef __KERNEL__
+
+#define GxICR_NUM_IRQS		42
+
+#define GxICR_NUM_XIRQS		8
+
+#define XIRQ0		34
+#define XIRQ1		35
+#define XIRQ2		36
+#define XIRQ3		37
+#define XIRQ4		38
+#define XIRQ5		39
+#define XIRQ6		40
+#define XIRQ7		41
+
+#define XIRQ2IRQ(num)	(XIRQ0 + num)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PROC_IRQ_H */
diff --git a/arch/mn10300/proc-mn103e010/include/proc/proc.h b/arch/mn10300/proc-mn103e010/include/proc/proc.h
new file mode 100644
index 0000000..22a2b93
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/proc.h
@@ -0,0 +1,18 @@
+/* MN103E010 Processor description
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_PROC_H
+#define _ASM_PROC_PROC_H
+
+#define PROCESSOR_VENDOR_NAME	"Matsushita"
+#define PROCESSOR_MODEL_NAME	"mn103e010"
+
+#endif /* _ASM_PROC_PROC_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/clock.h b/arch/mn10300/unit-asb2303/include/unit/clock.h
new file mode 100644
index 0000000..8b450e9
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/include/unit/clock.h
@@ -0,0 +1,45 @@
+/* ASB2303-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_CLOCK_H
+#define _ASM_UNIT_CLOCK_H
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MN10300_RTC
+
+extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
+extern unsigned long mn10300_iobclk;
+extern unsigned long mn10300_tsc_per_HZ;
+
+#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+/* If this processors has a another clock, uncomment the below. */
+/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+
+#else /* !CONFIG_MN10300_RTC */
+
+#define MN10300_IOCLK		33333333UL
+/* #define MN10300_IOBCLK	66666666UL */
+
+#endif /* !CONFIG_MN10300_RTC */
+
+#define MN10300_JCCLK		MN10300_IOCLK
+#define MN10300_TSCCLK		MN10300_IOCLK
+
+#ifdef CONFIG_MN10300_RTC
+#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#else /* !CONFIG_MN10300_RTC */
+#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
+#endif /* !CONFIG_MN10300_RTC */
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/leds.h b/arch/mn10300/unit-asb2303/include/unit/leds.h
new file mode 100644
index 0000000..3a7543e
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/include/unit/leds.h
@@ -0,0 +1,43 @@
+/* ASB2303-specific LEDs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_LEDS_H
+#define _ASM_UNIT_LEDS_H
+
+#include <asm/pio-regs.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#define ASB2303_GPIO0DEF	__SYSREG(0xDB000000, u32)
+#define ASB2303_7SEGLEDS	__SYSREG(0xDB000008, u32)
+
+/*
+ * use the 7-segment LEDs to indicate states
+ */
+
+/* flip the 7-segment LEDs between "G" and "-" */
+#define mn10300_set_gdbleds(ONOFF)			\
+do {							\
+	ASB2303_7SEGLEDS = (ONOFF) ? 0x85 : 0x7f;	\
+} while (0)
+
+/* indicate double-fault by displaying "d" on the LEDs */
+#define mn10300_set_dbfleds			\
+	mov	0x43,d0			;	\
+	movbu	d0,(ASB2303_7SEGLEDS)
+
+#ifndef __ASSEMBLY__
+extern void peripheral_leds_display_exception(enum exception_code code);
+extern void peripheral_leds_led_chase(void);
+extern void debug_to_serial(const char *p, int n);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_LEDS_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/serial.h b/arch/mn10300/unit-asb2303/include/unit/serial.h
new file mode 100644
index 0000000..047566c
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/include/unit/serial.h
@@ -0,0 +1,136 @@
+/* ASB2303-specific 8250 serial ports
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_SERIAL_H
+#define _ASM_UNIT_SERIAL_H
+
+#include <asm/cpu-regs.h>
+#include <proc/irq.h>
+#include <linux/serial_reg.h>
+
+#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
+#define SERIAL_PORT1_BASE_ADDRESS	0xA6FC0000
+
+#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
+
+/*
+ * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
+ */
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+
+#define SERIAL_PORT_DFNS						\
+	{								\
+	.baud_base		= BASE_BAUD,				\
+	.irq			= SERIAL_IRQ,				\
+	.flags			= STD_COM_FLAGS,			\
+	.iomem_base		= (u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
+	.iomem_reg_shift	= 2,					\
+	.io_type		= SERIAL_IO_MEM,			\
+	},								\
+	{								\
+	.baud_base		= BASE_BAUD,				\
+	.irq			= SERIAL_IRQ,				\
+	.flags			= STD_COM_FLAGS,			\
+	.iomem_base		= (u8 *) SERIAL_PORT1_BASE_ADDRESS,	\
+	.iomem_reg_shift	= 2,					\
+	.io_type		= SERIAL_IO_MEM,			\
+	},
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_PORT_DFNS /* both stolen by gdb-stub because they share an IRQ */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYS0)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+
+#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT1_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+#endif
+
+#ifndef __ASSEMBLY__
+
+#define LSR_WAIT_FOR(STATE)					\
+do {								\
+	while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE)) {}	\
+} while (0)
+#define FLOWCTL_WAIT_FOR(LINE)					\
+do {								\
+	while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE)) {}	\
+} while (0)
+#define FLOWCTL_CLEAR(LINE)			\
+do {						\
+	GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE;	\
+} while (0)
+#define FLOWCTL_SET(LINE)			\
+do {						\
+	GDBPORT_SERIAL_MCR |= UART_MCR_##LINE;	\
+} while (0)
+#define FLOWCTL_QUERY(LINE)	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+	char ch;
+
+	FLOWCTL_SET(DTR);
+
+	for (; n > 0; n--) {
+		LSR_WAIT_FOR(THRE);
+		FLOWCTL_WAIT_FOR(CTS);
+
+		ch = *p++;
+		if (ch == 0x0a) {
+			GDBPORT_SERIAL_TX = 0x0d;
+			LSR_WAIT_FOR(THRE);
+			FLOWCTL_WAIT_FOR(CTS);
+		}
+		GDBPORT_SERIAL_TX = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/smc91111.h b/arch/mn10300/unit-asb2303/include/unit/smc91111.h
new file mode 100644
index 0000000..dd456e9
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/include/unit/smc91111.h
@@ -0,0 +1,50 @@
+/* Support for the SMC91C111 NIC on an ASB2303
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_SMC91111_H
+#define _ASM_UNIT_SMC91111_H
+
+#include <asm/intctl-regs.h>
+
+#define SMC91111_BASE		0xAA000300UL
+#define SMC91111_BASE_END	0xAA000400UL
+#define SMC91111_IRQ		XIRQ3
+
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_NOWAIT		1
+#define SMC_IRQ_FLAGS		(0)
+
+#if SMC_CAN_USE_8BIT
+#define SMC_inb(a, r)		inb((unsigned long) ((a) + (r)))
+#define SMC_outb(v, a, r)	outb(v, (unsigned long) ((a) + (r)))
+#endif
+
+#if SMC_CAN_USE_16BIT
+#define SMC_inw(a, r)		inw((unsigned long) ((a) + (r)))
+#define SMC_outw(v, a, r)	outw(v, (unsigned long) ((a) + (r)))
+#define SMC_insw(a, r, p, l)	insw((unsigned long) ((a) + (r)), (p), (l))
+#define SMC_outsw(a, r, p, l)	outsw((unsigned long) ((a) + (r)), (p), (l))
+#endif
+
+#if SMC_CAN_USE_32BIT
+#define SMC_inl(a, r)		inl((unsigned long) ((a) + (r)))
+#define SMC_outl(v, a, r)	outl(v, (unsigned long) ((a) + (r)))
+#define SMC_insl(a, r, p, l)	insl((unsigned long) ((a) + (r)), (p), (l))
+#define SMC_outsl(a, r, p, l)	outsl((unsigned long) ((a) + (r)), (p), (l))
+#endif
+
+#define RPC_LSA_DEFAULT		RPC_LED_100_10
+#define RPC_LSB_DEFAULT		RPC_LED_TX_RX
+
+#define set_irq_type(irq, type)
+
+#endif /*  _ASM_UNIT_SMC91111_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/timex.h b/arch/mn10300/unit-asb2303/include/unit/timex.h
new file mode 100644
index 0000000..f206b63
--- /dev/null
+++ b/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -0,0 +1,135 @@
+/* ASB2303-specific timer specifcations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_TIMEX_H
+#define _ASM_UNIT_TIMEX_H
+
+#ifndef __ASSEMBLY__
+#include <linux/irq.h>
+#endif /* __ASSEMBLY__ */
+
+#include <asm/timer-regs.h>
+#include <unit/clock.h>
+
+/*
+ * jiffies counter specifications
+ */
+
+#define	TMJCBR_MAX		0xffff
+#define	TMJCBC			TM01BC
+
+#define	TMJCMD			TM01MD
+#define	TMJCBR			TM01BR
+#define	TMJCIRQ			TM1IRQ
+#define	TMJCICR			TM1ICR
+#define	TMJCICR_LEVEL		GxICR_LEVEL_5
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_jiffies_counter(void)
+{
+	unsigned rate;
+	u16 md, t16;
+
+	/* use as little prescaling as possible to avoid losing accuracy */
+	md = TM0MD_SRC_IOCLK;
+	rate = MN10300_JCCLK / HZ;
+
+	if (rate > TMJCBR_MAX) {
+		md = TM0MD_SRC_IOCLK_8;
+		rate = MN10300_JCCLK / 8 / HZ;
+
+		if (rate > TMJCBR_MAX) {
+			md = TM0MD_SRC_IOCLK_32;
+			rate = MN10300_JCCLK / 32 / HZ;
+
+			if (rate > TMJCBR_MAX)
+				BUG();
+		}
+	}
+
+	TMJCBR = rate - 1;
+	t16 = TMJCBR;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_INIT_COUNTER |
+		TM1MD_INIT_COUNTER << 8;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_COUNT_ENABLE |
+		TM1MD_COUNT_ENABLE << 8;
+
+	t16 = TMJCMD;
+
+	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	t16 = TMJCICR;
+}
+
+static inline void shutdown_jiffies_counter(void)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * timestamp counter specifications
+ */
+
+#define	TMTSCBR_MAX		0xffffffff
+#define	TMTSCBC			TM45BC
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_timestamp_counter(void)
+{
+	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
+	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
+	 */
+	TM45BR = TMTSCBR_MAX;
+
+	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD |= TM4MD_INIT_COUNTER;
+	TM4MD &= ~TM4MD_INIT_COUNTER;
+	TM4ICR = 0;
+
+	TM5MD = TM5MD_SRC_TM4CASCADE;
+	TM5MD |= TM5MD_INIT_COUNTER;
+	TM5MD &= ~TM5MD_INIT_COUNTER;
+	TM5ICR = 0;
+
+	TM5MD |= TM5MD_COUNT_ENABLE;
+	TM4MD |= TM4MD_COUNT_ENABLE;
+}
+
+static inline void shutdown_timestamp_counter(void)
+{
+	TM4MD = 0;
+	TM5MD = 0;
+}
+
+/*
+ * we use a cascaded pair of 16-bit down-counting timers to count I/O
+ * clock cycles for the purposes of time keeping
+ */
+typedef unsigned long cycles_t;
+
+static inline cycles_t read_timestamp_counter(void)
+{
+	return (cycles_t)TMTSCBC;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_TIMEX_H */
diff --git a/arch/mn10300/unit-asb2303/leds.c b/arch/mn10300/unit-asb2303/leds.c
index cd4bc78..c038393 100644
--- a/arch/mn10300/unit-asb2303/leds.c
+++ b/arch/mn10300/unit-asb2303/leds.c
@@ -16,7 +16,7 @@
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 
 #if 0
 static const u8 asb2303_led_hex_tbl[16] = {
diff --git a/arch/mn10300/unit-asb2303/smc91111.c b/arch/mn10300/unit-asb2303/smc91111.c
index 30875dd..43c2464 100644
--- a/arch/mn10300/unit-asb2303/smc91111.c
+++ b/arch/mn10300/unit-asb2303/smc91111.c
@@ -18,7 +18,7 @@
 #include <asm/timex.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
-#include <asm/unit/smc91111.h>
+#include <unit/smc91111.h>
 
 static struct resource smc91c111_resources[] = {
 	[0] = {
diff --git a/arch/mn10300/unit-asb2305/include/unit/clock.h b/arch/mn10300/unit-asb2305/include/unit/clock.h
new file mode 100644
index 0000000..7d51484
--- /dev/null
+++ b/arch/mn10300/unit-asb2305/include/unit/clock.h
@@ -0,0 +1,45 @@
+/* ASB2305-specific clocks
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_CLOCK_H
+#define _ASM_UNIT_CLOCK_H
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MN10300_RTC
+
+extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
+extern unsigned long mn10300_iobclk;
+extern unsigned long mn10300_tsc_per_HZ;
+
+#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+/* If this processors has a another clock, uncomment the below. */
+/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+
+#else /* !CONFIG_MN10300_RTC */
+
+#define MN10300_IOCLK		33333333UL
+/* #define MN10300_IOBCLK	66666666UL */
+
+#endif /* !CONFIG_MN10300_RTC */
+
+#define MN10300_JCCLK		MN10300_IOCLK
+#define MN10300_TSCCLK		MN10300_IOCLK
+
+#ifdef CONFIG_MN10300_RTC
+#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#else /* !CONFIG_MN10300_RTC */
+#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
+#endif /* !CONFIG_MN10300_RTC */
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/unit-asb2305/include/unit/leds.h b/arch/mn10300/unit-asb2305/include/unit/leds.h
new file mode 100644
index 0000000..bc471f6
--- /dev/null
+++ b/arch/mn10300/unit-asb2305/include/unit/leds.h
@@ -0,0 +1,51 @@
+/* ASB2305-specific LEDs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_LEDS_H
+#define _ASM_UNIT_LEDS_H
+
+#include <asm/pio-regs.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#define ASB2305_7SEGLEDS	__SYSREG(0xA6F90000, u32)
+
+/* perform a hard reset by driving PIO06 low */
+#define mn10300_unit_hard_reset()		\
+do {						\
+	P0OUT &= 0xbf;				\
+	P0MD = (P0MD & P0MD_6) | P0MD_6_OUT;	\
+} while (0)
+
+/*
+ * use the 7-segment LEDs to indicate states
+ */
+/* indicate double-fault by displaying "db-f" on the LEDs */
+#define mn10300_set_dbfleds			\
+	mov	0x43077f1d,d0		;	\
+	mov	d0,(ASB2305_7SEGLEDS)
+
+/* flip the 7-segment LEDs between "Gdb-" and "----" */
+#define mn10300_set_gdbleds(ONOFF)				\
+do {								\
+	ASB2305_7SEGLEDS = (ONOFF) ? 0x8543077f : 0x7f7f7f7f;	\
+} while (0)
+
+#ifndef __ASSEMBLY__
+extern void peripheral_leds_display_exception(enum exception_code);
+extern void peripheral_leds_led_chase(void);
+extern void peripheral_leds7x4_display_dec(unsigned int, unsigned int);
+extern void peripheral_leds7x4_display_hex(unsigned int, unsigned int);
+extern void peripheral_leds7x4_display_minssecs(unsigned int, unsigned int);
+extern void peripheral_leds7x4_display_rtc(void);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_LEDS_H */
diff --git a/arch/mn10300/unit-asb2305/include/unit/serial.h b/arch/mn10300/unit-asb2305/include/unit/serial.h
new file mode 100644
index 0000000..3bfc909
--- /dev/null
+++ b/arch/mn10300/unit-asb2305/include/unit/serial.h
@@ -0,0 +1,120 @@
+/* ASB2305-specific 8250 serial ports
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_SERIAL_H
+#define _ASM_UNIT_SERIAL_H
+
+#include <asm/cpu/cpu-regs.h>
+#include <proc/irq.h>
+#include <linux/serial_reg.h>
+
+#define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
+#define ASB2305_DEBUG_MCR	__SYSREG(0xA6FB0000 + UART_MCR * 2, u8)
+
+#define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
+
+/*
+ * dispose of the /dev/ttyS0 serial port
+ */
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+
+#define SERIAL_PORT_DFNS						\
+	{								\
+	.baud_base		= BASE_BAUD,				\
+	.irq			= SERIAL_IRQ,				\
+	.flags			= STD_COM_FLAGS,			\
+	.iomem_base		= (u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
+	.iomem_reg_shift	= 2,					\
+	.io_type		= SERIAL_IO_MEM,			\
+	},
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYS0)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+
+#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
+#error The ASB2305 doesnt have a /dev/ttyS1
+#endif
+
+#ifndef __ASSEMBLY__
+
+#define TTYS0_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define TTYS0_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define TTYS0_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define TTYS0_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+
+#define LSR_WAIT_FOR(STATE)				\
+do {							\
+	while (!(TTYS0_LSR & UART_LSR_##STATE)) {}	\
+} while (0)
+#define FLOWCTL_WAIT_FOR(LINE)				\
+do {							\
+	while (!(TTYS0_MSR & UART_MSR_##LINE)) {}	\
+} while (0)
+#define FLOWCTL_CLEAR(LINE)			\
+do {						\
+	TTYS0_MCR &= ~UART_MCR_##LINE;		\
+} while (0)
+#define FLOWCTL_SET(LINE)			\
+do {						\
+	TTYS0_MCR |= UART_MCR_##LINE;		\
+} while (0)
+#define FLOWCTL_QUERY(LINE)	({ TTYS0_MSR & UART_MSR_##LINE; })
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+	char ch;
+
+	FLOWCTL_SET(DTR);
+
+	for (; n > 0; n--) {
+		LSR_WAIT_FOR(THRE);
+		FLOWCTL_WAIT_FOR(CTS);
+
+		ch = *p++;
+		if (ch == 0x0a) {
+			TTYS0_TX = 0x0d;
+			LSR_WAIT_FOR(THRE);
+			FLOWCTL_WAIT_FOR(CTS);
+		}
+		TTYS0_TX = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2305/include/unit/timex.h b/arch/mn10300/unit-asb2305/include/unit/timex.h
new file mode 100644
index 0000000..a71c49a
--- /dev/null
+++ b/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -0,0 +1,135 @@
+/* ASB2305 timer specifcations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_TIMEX_H
+#define _ASM_UNIT_TIMEX_H
+
+#ifndef __ASSEMBLY__
+#include <linux/irq.h>
+#endif /* __ASSEMBLY__ */
+
+#include <asm/cpu/timer-regs.h>
+#include <unit/clock.h>
+
+/*
+ * jiffies counter specifications
+ */
+
+#define	TMJCBR_MAX		0xffff
+#define	TMJCBC			TM01BC
+
+#define	TMJCMD			TM01MD
+#define	TMJCBR			TM01BR
+#define	TMJCIRQ			TM1IRQ
+#define	TMJCICR			TM1ICR
+#define	TMJCICR_LEVEL		GxICR_LEVEL_5
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_jiffies_counter(void)
+{
+	unsigned rate;
+	u16 md, t16;
+
+	/* use as little prescaling as possible to avoid losing accuracy */
+	md = TM0MD_SRC_IOCLK;
+	rate = MN10300_JCCLK / HZ;
+
+	if (rate > TMJCBR_MAX) {
+		md = TM0MD_SRC_IOCLK_8;
+		rate = MN10300_JCCLK / 8 / HZ;
+
+		if (rate > TMJCBR_MAX) {
+			md = TM0MD_SRC_IOCLK_32;
+			rate = MN10300_JCCLK / 32 / HZ;
+
+			if (rate > TMJCBR_MAX)
+				BUG();
+		}
+	}
+
+	TMJCBR = rate - 1;
+	t16 = TMJCBR;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_INIT_COUNTER |
+		TM1MD_INIT_COUNTER << 8;
+
+	TMJCMD =
+		md |
+		TM1MD_SRC_TM0CASCADE << 8 |
+		TM0MD_COUNT_ENABLE |
+		TM1MD_COUNT_ENABLE << 8;
+
+	t16 = TMJCMD;
+
+	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	t16 = TMJCICR;
+}
+
+static inline void shutdown_jiffies_counter(void)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * timestamp counter specifications
+ */
+
+#define	TMTSCBR_MAX		0xffffffff
+#define	TMTSCBC			TM45BC
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_timestamp_counter(void)
+{
+	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
+	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
+	 */
+	TM45BR = TMTSCBR_MAX;
+
+	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD |= TM4MD_INIT_COUNTER;
+	TM4MD &= ~TM4MD_INIT_COUNTER;
+	TM4ICR = 0;
+
+	TM5MD = TM5MD_SRC_TM4CASCADE;
+	TM5MD |= TM5MD_INIT_COUNTER;
+	TM5MD &= ~TM5MD_INIT_COUNTER;
+	TM5ICR = 0;
+
+	TM5MD |= TM5MD_COUNT_ENABLE;
+	TM4MD |= TM4MD_COUNT_ENABLE;
+}
+
+static inline void shutdown_timestamp_counter(void)
+{
+	TM4MD = 0;
+	TM5MD = 0;
+}
+
+/*
+ * we use a cascaded pair of 16-bit down-counting timers to count I/O
+ * clock cycles for the purposes of time keeping
+ */
+typedef unsigned long cycles_t;
+
+static inline cycles_t read_timestamp_counter(void)
+{
+	return (cycles_t) TMTSCBC;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_TIMEX_H */
diff --git a/arch/mn10300/unit-asb2305/leds.c b/arch/mn10300/unit-asb2305/leds.c
index e99dcc9..d345ff9 100644
--- a/arch/mn10300/unit-asb2305/leds.c
+++ b/arch/mn10300/unit-asb2305/leds.c
@@ -15,7 +15,7 @@
 #include <asm/processor.h>
 #include <asm/cpu/intctl-regs.h>
 #include <asm/cpu/rtc-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 
 static const u8 asb2305_led_hex_tbl[16] = {
 	0x80, 0xf2, 0x48, 0x60, 0x32, 0x24, 0x04, 0xf0,
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index 72812a9..1c452cc 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -18,7 +18,7 @@
 #include <asm/cpu/intctl-regs.h>
 #include <asm/cpu/rtc-regs.h>
 #include <asm/cpu/serial-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 /*
  * initialise some of the unit hardware before gdbstub is set up
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 912308e..329f890 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -369,7 +369,7 @@ static inline void LPD7_SMC_outsw (unsigned char* a, int r,
  * MN10300/AM33 configuration
  */
 
-#include <asm/unit/smc91111.h>
+#include <unit/smc91111.h>
 
 #else
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbYCCRas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbYCCRas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYCCRQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbYCCRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:08 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 27/52] get rid of smp_32.c and smp_64.c
Date: Mon,  3 Mar 2008 14:12:55 -0300
Message-Id: <1204564400-17636-28-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-27-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the copyright notices, and valuable
comments that were left back on smp_{32,64}.c. With that,
files are empty, and are deleted

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/smp.c    |   91 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smp_32.c |  106 ----------------------------------------------
 arch/x86/kernel/smp_64.c |   10 ----
 4 files changed, 92 insertions(+), 117 deletions(-)
 delete mode 100644 arch/x86/kernel/smp_32.c
 delete mode 100644 arch/x86/kernel/smp_64.c

Index: linux-2.6-x86/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/Makefile	2008-03-03 11:58:38.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/Makefile	2008-03-03 11:59:55.000000000 -0800
@@ -46,10 +46,10 @@
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smp.o
+obj-$(CONFIG_X86_SMP)		+= smpboot_$(BITS).o smp.o
 obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
-obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o smpcommon.o
+obj-$(CONFIG_X86_64_SMP)	+= smpboot_64.o tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_$(BITS).o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
Index: linux-2.6-x86/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/smp.c	2008-03-03 11:58:38.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/smp.c	2008-03-03 11:58:38.000000000 -0800
@@ -1,3 +1,16 @@
+/*
+ *	Intel SMP support routines.
+ *
+ *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
+ *      (c) 2002,2003 Andi Kleen, SuSE Labs.
+ *
+ *	i386 and x86_64 integration by Glauber Costa <gcosta@redhat.com>
+ *
+ *	This code is released under the GNU General Public License version 2 or
+ *	later.
+ */
+
 #include <linux/init.h>
 
 #include <linux/mm.h>
@@ -19,6 +32,84 @@
 #else
 #include <asm/mach_apic.h>
 #endif
+/*
+ *	Some notes on x86 processor bugs affecting SMP operation:
+ *
+ *	Pentium, Pentium Pro, II, III (and all CPUs) have bugs.
+ *	The Linux implications for SMP are handled as follows:
+ *
+ *	Pentium III / [Xeon]
+ *		None of the E1AP-E3AP errata are visible to the user.
+ *
+ *	E1AP.	see PII A1AP
+ *	E2AP.	see PII A2AP
+ *	E3AP.	see PII A3AP
+ *
+ *	Pentium II / [Xeon]
+ *		None of the A1AP-A3AP errata are visible to the user.
+ *
+ *	A1AP.	see PPro 1AP
+ *	A2AP.	see PPro 2AP
+ *	A3AP.	see PPro 7AP
+ *
+ *	Pentium Pro
+ *		None of 1AP-9AP errata are visible to the normal user,
+ *	except occasional delivery of 'spurious interrupt' as trap #15.
+ *	This is very rare and a non-problem.
+ *
+ *	1AP.	Linux maps APIC as non-cacheable
+ *	2AP.	worked around in hardware
+ *	3AP.	fixed in C0 and above steppings microcode update.
+ *		Linux does not use excessive STARTUP_IPIs.
+ *	4AP.	worked around in hardware
+ *	5AP.	symmetric IO mode (normal Linux operation) not affected.
+ *		'noapic' mode has vector 0xf filled out properly.
+ *	6AP.	'noapic' mode might be affected - fixed in later steppings
+ *	7AP.	We do not assume writes to the LVT deassering IRQs
+ *	8AP.	We do not enable low power mode (deep sleep) during MP bootup
+ *	9AP.	We do not use mixed mode
+ *
+ *	Pentium
+ *		There is a marginal case where REP MOVS on 100MHz SMP
+ *	machines with B stepping processors can fail. XXX should provide
+ *	an L1cache=Writethrough or L1cache=off option.
+ *
+ *		B stepping CPUs may hang. There are hardware work arounds
+ *	for this. We warn about it in case your board doesn't have the work
+ *	arounds. Basically that's so I can tell anyone with a B stepping
+ *	CPU and SMP problems "tough".
+ *
+ *	Specific items [From Pentium Processor Specification Update]
+ *
+ *	1AP.	Linux doesn't use remote read
+ *	2AP.	Linux doesn't trust APIC errors
+ *	3AP.	We work around this
+ *	4AP.	Linux never generated 3 interrupts of the same priority
+ *		to cause a lost local interrupt.
+ *	5AP.	Remote read is never used
+ *	6AP.	not affected - worked around in hardware
+ *	7AP.	not affected - worked around in hardware
+ *	8AP.	worked around in hardware - we get explicit CS errors if not
+ *	9AP.	only 'noapic' mode affected. Might generate spurious
+ *		interrupts, we log only the first one and count the
+ *		rest silently.
+ *	10AP.	not affected - worked around in hardware
+ *	11AP.	Linux reads the APIC between writes to avoid this, as per
+ *		the documentation. Make sure you preserve this as it affects
+ *		the C stepping chips too.
+ *	12AP.	not affected - worked around in hardware
+ *	13AP.	not affected - worked around in hardware
+ *	14AP.	we always deassert INIT during bootup
+ *	15AP.	not affected - worked around in hardware
+ *	16AP.	not affected - worked around in hardware
+ *	17AP.	not affected - worked around in hardware
+ *	18AP.	not affected - worked around in hardware
+ *	19AP.	not affected - worked around in BIOS
+ *
+ *	If this sounds worrying believe me these bugs are either ___RARE___,
+ *	or are signal timing bugs worked around in hardware and there's
+ *	about nothing of note with C stepping upwards.
+ */
 
 /*
  * this function sends a 'reschedule' IPI to another CPU.
Index: linux-2.6-x86/arch/x86/kernel/smp_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/smp_32.c	2008-03-03 11:58:38.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,106 +0,0 @@
-/*
- *	Intel SMP support routines.
- *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
- *	(c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
- *
- *	This code is released under the GNU General Public License version 2 or
- *	later.
- */
-
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
-#include <linux/kernel_stat.h>
-#include <linux/mc146818rtc.h>
-#include <linux/cache.h>
-#include <linux/interrupt.h>
-#include <linux/cpu.h>
-#include <linux/module.h>
-
-#include <asm/mtrr.h>
-#include <asm/tlbflush.h>
-#include <asm/mmu_context.h>
-#include <mach_apic.h>
-#include <asm/proto.h>
-
-/*
- *	Some notes on x86 processor bugs affecting SMP operation:
- *
- *	Pentium, Pentium Pro, II, III (and all CPUs) have bugs.
- *	The Linux implications for SMP are handled as follows:
- *
- *	Pentium III / [Xeon]
- *		None of the E1AP-E3AP errata are visible to the user.
- *
- *	E1AP.	see PII A1AP
- *	E2AP.	see PII A2AP
- *	E3AP.	see PII A3AP
- *
- *	Pentium II / [Xeon]
- *		None of the A1AP-A3AP errata are visible to the user.
- *
- *	A1AP.	see PPro 1AP
- *	A2AP.	see PPro 2AP
- *	A3AP.	see PPro 7AP
- *
- *	Pentium Pro
- *		None of 1AP-9AP errata are visible to the normal user,
- *	except occasional delivery of 'spurious interrupt' as trap #15.
- *	This is very rare and a non-problem.
- *
- *	1AP.	Linux maps APIC as non-cacheable
- *	2AP.	worked around in hardware
- *	3AP.	fixed in C0 and above steppings microcode update.
- *		Linux does not use excessive STARTUP_IPIs.
- *	4AP.	worked around in hardware
- *	5AP.	symmetric IO mode (normal Linux operation) not affected.
- *		'noapic' mode has vector 0xf filled out properly.
- *	6AP.	'noapic' mode might be affected - fixed in later steppings
- *	7AP.	We do not assume writes to the LVT deassering IRQs
- *	8AP.	We do not enable low power mode (deep sleep) during MP bootup
- *	9AP.	We do not use mixed mode
- *
- *	Pentium
- *		There is a marginal case where REP MOVS on 100MHz SMP
- *	machines with B stepping processors can fail. XXX should provide
- *	an L1cache=Writethrough or L1cache=off option.
- *
- *		B stepping CPUs may hang. There are hardware work arounds
- *	for this. We warn about it in case your board doesn't have the work
- *	arounds. Basically that's so I can tell anyone with a B stepping
- *	CPU and SMP problems "tough".
- *
- *	Specific items [From Pentium Processor Specification Update]
- *
- *	1AP.	Linux doesn't use remote read
- *	2AP.	Linux doesn't trust APIC errors
- *	3AP.	We work around this
- *	4AP.	Linux never generated 3 interrupts of the same priority
- *		to cause a lost local interrupt.
- *	5AP.	Remote read is never used
- *	6AP.	not affected - worked around in hardware
- *	7AP.	not affected - worked around in hardware
- *	8AP.	worked around in hardware - we get explicit CS errors if not
- *	9AP.	only 'noapic' mode affected. Might generate spurious
- *		interrupts, we log only the first one and count the
- *		rest silently.
- *	10AP.	not affected - worked around in hardware
- *	11AP.	Linux reads the APIC between writes to avoid this, as per
- *		the documentation. Make sure you preserve this as it affects
- *		the C stepping chips too.
- *	12AP.	not affected - worked around in hardware
- *	13AP.	not affected - worked around in hardware
- *	14AP.	we always deassert INIT during bootup
- *	15AP.	not affected - worked around in hardware
- *	16AP.	not affected - worked around in hardware
- *	17AP.	not affected - worked around in hardware
- *	18AP.	not affected - worked around in hardware
- *	19AP.	not affected - worked around in BIOS
- *
- *	If this sounds worrying believe me these bugs are either ___RARE___,
- *	or are signal timing bugs worked around in hardware and there's
- *	about nothing of note with C stepping upwards.
- */
Index: linux-2.6-x86/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/smp_64.c	2008-03-03 11:58:38.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,10 +0,0 @@
-/*
- *	Intel SMP support routines.
- *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
- *	(c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
- *      (c) 2002,2003 Andi Kleen, SuSE Labs.
- *
- *	This code is released under the GNU General Public License version 2 or
- *	later.
- */

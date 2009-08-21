Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbZHUVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbZHUVdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbZHUVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:19 -0400
Received: from www.tglx.de ([62.245.132.106]:51882 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbZHUVdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:07 -0400
Message-Id: <20090821205602.914068745@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 23/32] x86: Prepare unification of time_32/64.c
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-prepare-unification-of-time-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the top comment and the includes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time_32.c |   43 ++++++++++++-------------------------------
 arch/x86/kernel/time_64.c |   12 ++++--------
 2 files changed, 16 insertions(+), 39 deletions(-)

Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -1,45 +1,26 @@
 /*
- *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
+ *  Copyright (c) 1991,1992,1995  Linus Torvalds
+ *  Copyright (c) 1994  Alan Modra
+ *  Copyright (c) 1995  Markus Kuhn
+ *  Copyright (c) 1996  Ingo Molnar
+ *  Copyright (c) 1998  Andrea Arcangeli
+ *  Copyright (c) 2002,2006  Vojtech Pavlik
+ *  Copyright (c) 2003  Andi Kleen
  *
- * This file contains the PC-specific time handling details:
- * reading the RTC at bootup, etc..
- * 1994-07-02    Alan Modra
- *	fixed set_rtc_mmss, fixed time.year for >= 2000, new mktime
- * 1995-03-26    Markus Kuhn
- *      fixed 500 ms bug at call to set_rtc_mmss, fixed DS12887
- *      precision CMOS clock update
- * 1996-05-03    Ingo Molnar
- *      fixed time warps in do_[slow|fast]_gettimeoffset()
- * 1997-09-10	Updated NTP code according to technical memorandum Jan '96
- *		"A Kernel Model for Precision Timekeeping" by Dave Mills
- * 1998-09-05    (Various)
- *	More robust do_fast_gettimeoffset() algorithm implemented
- *	(works with APM, Cyrix 6x86MX and Centaur C6),
- *	monotonic gettimeofday() with fast_get_timeoffset(),
- *	drift-proof precision TSC calibration on boot
- *	(C. Scott Ananian <cananian@alumni.princeton.edu>, Andrew D.
- *	Balsa <andrebalsa@altern.org>, Philip Gladstone <philip@raptor.com>;
- *	ported from 2.0.35 Jumbo-9 by Michael Krause <m.krause@tu-harburg.de>).
- * 1998-12-16    Andrea Arcangeli
- *	Fixed Jumbo-9 code in 2.1.131: do_gettimeofday was missing 1 jiffy
- *	because was not accounting lost_ticks.
- * 1998-12-24 Copyright (C) 1998  Andrea Arcangeli
- *	Fixed a xtime SMP race (we need the xtime_lock rw spinlock to
- *	serialize accesses to xtime/lost_ticks).
  */
 
 #include <linux/clockchips.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
 
-#include <asm/setup.h>
-#include <asm/hpet.h>
-#include <asm/time.h>
-#include <asm/timer.h>
+#include <asm/platform.h>
 #include <asm/i8259.h>
 #include <asm/i8253.h>
+#include <asm/timer.h>
+#include <asm/hpet.h>
+#include <asm/time.h>
+#include <asm/nmi.h>
 
 int timer_ack;
 
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -1,6 +1,4 @@
 /*
- *  "High Precision Event Timer" based timekeeping.
- *
  *  Copyright (c) 1991,1992,1995  Linus Torvalds
  *  Copyright (c) 1994  Alan Modra
  *  Copyright (c) 1995  Markus Kuhn
@@ -8,23 +6,21 @@
  *  Copyright (c) 1998  Andrea Arcangeli
  *  Copyright (c) 2002,2006  Vojtech Pavlik
  *  Copyright (c) 2003  Andi Kleen
- *  RTC support code taken from arch/i386/kernel/timers/time_hpet.c
+ *
  */
 
 #include <linux/clockchips.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mca.h>
-#include <linux/nmi.h>
 
 #include <asm/platform.h>
+#include <asm/i8259.h>
 #include <asm/i8253.h>
+#include <asm/timer.h>
 #include <asm/hpet.h>
-#include <asm/vgtod.h>
 #include <asm/time.h>
-#include <asm/timer.h>
+#include <asm/nmi.h>
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 



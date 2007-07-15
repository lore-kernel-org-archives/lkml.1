Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbXGOQMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbXGOQMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbXGOQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:20 -0400
Received: from www.osadl.org ([213.239.205.134]:42563 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762100AbXGOQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:07 -0400
Message-Id: <20070715155541.471134193@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 18/33] x86_64: use shared i8253.h
Content-Disposition: inline; filename=x86_64-use-i386-i8253-h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the i386 i8253.h include file for x86_64 as well to share the
exports and the PIT constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/time.c  |    4 ----
 include/asm-x86_64/i8253.h |    8 ++------
 2 files changed, 2 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc6-mm/include/asm-x86_64/i8253.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-x86_64/i8253.h	2007-07-15 17:26:45.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-x86_64/i8253.h	2007-07-15 17:39:28.000000000 +0200
@@ -1,6 +1,2 @@
-#ifndef __ASM_I8253_H__
-#define __ASM_I8253_H__
-
-extern spinlock_t i8253_lock;
-
-#endif	/* __ASM_I8253_H__ */
+#include <asm-i386/i8253.h>
+#include <asm/8253pit.h>
Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/time.c	2007-07-15 17:34:42.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/time.c	2007-07-15 17:48:54.000000000 +0200
@@ -32,7 +32,6 @@
 #include <acpi/achware.h>	/* for PM timer frequency */
 #include <acpi/acpi_bus.h>
 #endif
-#include <asm/8253pit.h>
 #include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
@@ -292,9 +291,6 @@ static unsigned int __init tsc_calibrate
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-#define PIT_MODE 0x43
-#define PIT_CH0  0x40
-
 static void __pit_init(int val, u8 mode)
 {
 	unsigned long flags;

-- 


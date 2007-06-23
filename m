Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbXFWN2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbXFWN2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbXFWNWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:23 -0400
Received: from www.osadl.org ([213.239.205.134]:59267 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756112AbXFWNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:11 -0400
Message-Id: <20070623124030.939120547@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 18/28] x86_64: untangle asm/hpet.h from asm/timex.h
Content-Disposition: inline; filename=x86-64-untangle-hpet-headers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Chris Wright <chrisw@sous-sol.org>

When making changes to x86_64 timers, I noticed that touching
hpet.h triggered an unreasonably large rebuild.  Untangling
it from timex.h quiets the extra rebuild quite a bit.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>

---
 drivers/char/rtc.c         |    2 +-
 include/asm-x86_64/apic.h  |    2 ++
 include/asm-x86_64/hpet.h  |    1 -
 include/asm-x86_64/timex.h |    1 -
 4 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm/drivers/char/rtc.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/char/rtc.c	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/char/rtc.c	2007-06-23 14:38:59.000000000 +0200
@@ -82,7 +82,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#if defined(__i386__)
+#ifdef CONFIG_X86
 #include <asm/hpet.h>
 #endif
 
Index: linux-2.6.22-rc4-mm/include/asm-x86_64/timex.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-x86_64/timex.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-x86_64/timex.h	2007-06-23 14:38:59.000000000 +0200
@@ -9,7 +9,6 @@
 #include <asm/8253pit.h>
 #include <asm/msr.h>
 #include <asm/vsyscall.h>
-#include <asm/hpet.h>
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/tsc.h>
Index: linux-2.6.22-rc4-mm/include/asm-x86_64/apic.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-x86_64/apic.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-x86_64/apic.h	2007-06-23 14:38:59.000000000 +0200
@@ -86,6 +86,8 @@ extern void setup_apic_routing(void);
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
 
+extern int apic_is_clustered_box(void);
+
 #define K8_APIC_EXT_LVT_BASE    0x500
 #define K8_APIC_EXT_INT_MSG_FIX 0x0
 #define K8_APIC_EXT_INT_MSG_SMI 0x2
Index: linux-2.6.22-rc4-mm/include/asm-x86_64/hpet.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-x86_64/hpet.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-x86_64/hpet.h	2007-06-23 14:38:59.000000000 +0200
@@ -55,7 +55,6 @@
 
 extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
-extern int apic_is_clustered_box(void);
 extern int hpet_arch_init(void);
 extern int hpet_timer_stop_set_go(unsigned long tick);
 extern int hpet_reenable(void);

-- 


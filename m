Return-Path: <linux-kernel-owner+w=401wt.eu-S936366AbXGSKIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366AbXGSKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbXGSJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:35373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbXGSJzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:15 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: chrisw@sous-sol.org, johnstul@us.ibm.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [24/58] x86_64: Untangle asm/hpet.h from asm/timex.h
Message-Id: <20070719095509.807A014E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chris Wright <chrisw@sous-sol.org>

When making changes to x86_64 timers, I noticed that touching hpet.h triggered
an unreasonably large rebuild.  Untangling it from timex.h quiets the extra
rebuild quite a bit.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>

---

 drivers/char/rtc.c         |    2 +-
 include/asm-x86_64/apic.h  |    2 ++
 include/asm-x86_64/hpet.h  |    1 -
 include/asm-x86_64/timex.h |    1 -
 4 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/char/rtc.c
===================================================================
--- linux.orig/drivers/char/rtc.c
+++ linux/drivers/char/rtc.c
@@ -82,7 +82,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#if defined(__i386__)
+#ifdef CONFIG_X86
 #include <asm/hpet.h>
 #endif
 
Index: linux/include/asm-x86_64/apic.h
===================================================================
--- linux.orig/include/asm-x86_64/apic.h
+++ linux/include/asm-x86_64/apic.h
@@ -86,6 +86,8 @@ extern void setup_apic_routing(void);
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
 
+extern int apic_is_clustered_box(void);
+
 #define K8_APIC_EXT_LVT_BASE    0x500
 #define K8_APIC_EXT_INT_MSG_FIX 0x0
 #define K8_APIC_EXT_INT_MSG_SMI 0x2
Index: linux/include/asm-x86_64/hpet.h
===================================================================
--- linux.orig/include/asm-x86_64/hpet.h
+++ linux/include/asm-x86_64/hpet.h
@@ -55,7 +55,6 @@
 
 extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
-extern int apic_is_clustered_box(void);
 extern int hpet_arch_init(void);
 extern int hpet_timer_stop_set_go(unsigned long tick);
 extern int hpet_reenable(void);
Index: linux/include/asm-x86_64/timex.h
===================================================================
--- linux.orig/include/asm-x86_64/timex.h
+++ linux/include/asm-x86_64/timex.h
@@ -9,7 +9,6 @@
 #include <asm/8253pit.h>
 #include <asm/msr.h>
 #include <asm/vsyscall.h>
-#include <asm/hpet.h>
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/tsc.h>

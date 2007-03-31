Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXCaIdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXCaIdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXCaIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:33:50 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35605 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXCaIdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:33:49 -0400
Message-Id: <20070331083318.996348000@sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/5] x86_64: untangle asm/hpet.h from asm/timex.h
Content-Disposition: inline; filename=x86_64-remove-hpet-from-timex.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When making changes to x86_64 timers, I noticed that touching
hpet.h triggered an unreasonably large rebuild.  Untangling
it from timex.h quiets the extra rebuild quite a bit.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
---
 drivers/char/rtc.c         |    2 +-
 include/asm-x86_64/apic.h  |    1 +
 include/asm-x86_64/hpet.h  |    1 -
 include/asm-x86_64/timex.h |    1 -
 4 files changed, 2 insertions(+), 3 deletions(-)

--- linus-2.6.orig/drivers/char/rtc.c
+++ linus-2.6/drivers/char/rtc.c
@@ -82,7 +82,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#if defined(__i386__)
+#if defined(__i386__) || defined(__x86_64__)
 #include <asm/hpet.h>
 #endif
 
--- linus-2.6.orig/include/asm-x86_64/timex.h
+++ linus-2.6/include/asm-x86_64/timex.h
@@ -9,7 +9,6 @@
 #include <asm/8253pit.h>
 #include <asm/msr.h>
 #include <asm/vsyscall.h>
-#include <asm/hpet.h>
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/tsc.h>
--- linus-2.6.orig/include/asm-x86_64/apic.h
+++ linus-2.6/include/asm-x86_64/apic.h
@@ -84,6 +84,7 @@ extern int APIC_init_uniprocessor (void)
 extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void clustered_apic_check(void);
+extern int apic_is_clustered_box(void);
 
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
--- linus-2.6.orig/include/asm-x86_64/hpet.h
+++ linus-2.6/include/asm-x86_64/hpet.h
@@ -55,7 +55,6 @@
 
 extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
-extern int apic_is_clustered_box(void);
 extern int hpet_arch_init(void);
 extern int hpet_timer_stop_set_go(unsigned long tick);
 extern int hpet_reenable(void);

--

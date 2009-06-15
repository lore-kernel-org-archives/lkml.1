Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZFOI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZFOI1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbZFOI1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:27:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53557 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbZFOI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:27:22 -0400
Message-ID: <4A3605E1.6040604@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:27:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/16] x86, mce: remove therm_throt.h
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all symbols in the header are static.  Remove the header.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/therm_throt.h        |    9 ---------
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    1 -
 arch/x86/kernel/cpu/mcheck/p4.c           |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |    5 ++---
 4 files changed, 2 insertions(+), 14 deletions(-)
 delete mode 100644 arch/x86/include/asm/therm_throt.h

diff --git a/arch/x86/include/asm/therm_throt.h b/arch/x86/include/asm/therm_throt.h
deleted file mode 100644
index c62349e..0000000
--- a/arch/x86/include/asm/therm_throt.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ASM_X86_THERM_THROT_H
-#define _ASM_X86_THERM_THROT_H
-
-#include <asm/atomic.h>
-
-extern atomic_t therm_throt_en;
-int therm_throt_process(int curr);
-
-#endif /* _ASM_X86_THERM_THROT_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 3b7a057..663a88e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -11,7 +11,6 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
-#include <asm/therm_throt.h>
 
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 76c5f03..4482aea 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -6,7 +6,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 
-#include <asm/therm_throt.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7c7944c..bff8dd1 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -24,7 +24,6 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
-#include <asm/therm_throt.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -38,7 +37,7 @@
 static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
 static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
 
-atomic_t therm_throt_en		= ATOMIC_INIT(0);
+static atomic_t therm_throt_en		= ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
@@ -93,7 +92,7 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-int therm_throt_process(int curr)
+static int therm_throt_process(int curr)
 {
 	unsigned int cpu = smp_processor_id();
 	__u64 tmp_jiffs = get_jiffies_64();
-- 
1.6.3



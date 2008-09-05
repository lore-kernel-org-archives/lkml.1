Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYIEDKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYIEDKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYIEDJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYIEDJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uSZdolyuHARR/08UdDNqT9CJZAsKHIrFU2/BSb1cEEjllQhl7b1XT5ybhF08nU+e5s
         cX41s1oDlzQ6I7GqWRPZEFmH0WyhA49folA+WZ3WNm3jDap4PFvRzLTR18F0AEsChnq8
         zD5ts+9dmXRjn3XN9o1Ha3+Woc9uwagFmK0zQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/16] x86: make header file the same in common_xx.c
Date: Thu,  4 Sep 2008 20:09:00 -0700
Message-Id: <1220584154-32497-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   22 +++++++++++++++++++---
 arch/x86/kernel/cpu/common_64.c |    2 +-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1f80ce0..6bbdbc2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,25 +1,41 @@
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
+#include <linux/bootmem.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kgdb.h>
+#include <linux/topology.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
-#include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
-#include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/linkage.h>
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
+#include <asm/numa.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
 #include <mach_apic.h>
+#include <asm/genapic.h>
 #endif
 
+#include <asm/pda.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/desc.h>
+#include <asm/atomic.h>
+#include <asm/proto.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
 #include "cpu.h"
 
 static struct cpu_dev *this_cpu __cpuinitdata;
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 8e63073..5daec69 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -24,6 +24,7 @@
 #include <asm/mpspec.h>
 #include <asm/apic.h>
 #include <mach_apic.h>
+#include <asm/genapic.h>
 #endif
 #include <asm/pda.h>
 #include <asm/pgtable.h>
@@ -33,7 +34,6 @@
 #include <asm/proto.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-#include <asm/genapic.h>
 
 #include "cpu.h"
 
-- 
1.5.4.5


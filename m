Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXAWWKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXAWWKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXAWWJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:09:37 -0500
Received: from www.osadl.org ([213.239.205.134]:35895 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965505AbXAWWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:11 -0500
Message-Id: <20070123211207.411593000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 29/46] ACPI: fix missing include for UP
Content-Disposition: inline; filename=acpi-include-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

apic.h does not get included on UP compiles.  That way the
APICTIMER_STOPS_ON_C3 is not there and UP boxen have no support for
timer broadcasting.  This was never noticed, because the lapic timer is
only used for profiling on UP.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_idle.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.20-rc4-mm1-bo/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/acpi/processor_idle.c
@@ -40,6 +40,16 @@
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/latency.h>
 
+/*
+ * Include the apic definitions for x86 to have the APIC timer related defines
+ * available also for UP (on SMP it gets magically included via linux/smp.h).
+ * asm/acpi.h is not an option, as it would require more include magic. Also
+ * creating an empty asm-ia64/apic.h would just trade pest vs. cholera.
+ */
+#ifdef CONFIG_X86
+#include <asm/apic.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 

--


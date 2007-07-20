Return-Path: <linux-kernel-owner+w=401wt.eu-S936161AbXGTPdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936161AbXGTPdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbXGTPcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:50679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765898AbXGTPct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:49 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: B.Steinbrink@gmx.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/11] i386: Reserve the right performance counter  for the Intel PerfMon NMI watchdog
Message-Id: <20070720153245.193DA14E79@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Björn Steinbrink <B.Steinbrink@gmx.de>

The Intel PerfMon NMI watchdog reserves the first performance counter,
but uses the second one. Make it correctly reserve the second one.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -599,8 +599,8 @@ static struct wd_ops intel_arch_wd_ops =
 	.setup = setup_intel_arch_watchdog,
 	.rearm = p6_rearm,
 	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR1,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
 static void probe_nmi_watchdog(void)

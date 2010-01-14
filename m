Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286Ab0ANAn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0ANAn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243Ab0ANAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:43:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:28366 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0ANAn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:43:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232502364"
Message-Id: <20100114002118.436172066@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 13 Jan 2010 16:19:10 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, ebiederm@xmission.com, yinghai@kernel.org, mingo@elte.hu,
       macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Alok N Kataria <akataria@vmware.com>, Zach Amsden <zach@vmware.com>
Subject: [patch 1/2] x86, vmi: Fix vmi_get_timer_vector() to use IRQ0_VECTOR
Content-Disposition: inline; filename=fix_vmi_vector.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIRST_DEVICE_VECTOR is going away and it looks like a bad hack to steal
FIRST_DEVICE_VECTOR / FIRST_EXTERNAL_VECTOR, when it looks like it needs
IRQ0_VECTOR.

Fix vmi_get_timer_vector() to use IRQ0_VECTOR.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alok N Kataria <akataria@vmware.com>
Cc: Zach Amsden <zach@vmware.com>
---
 arch/x86/kernel/vmiclock_32.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: tip/arch/x86/kernel/vmiclock_32.c
===================================================================
--- tip.orig/arch/x86/kernel/vmiclock_32.c
+++ tip/arch/x86/kernel/vmiclock_32.c
@@ -79,11 +79,7 @@ unsigned long vmi_tsc_khz(void)
 
 static inline unsigned int vmi_get_timer_vector(void)
 {
-#ifdef CONFIG_X86_IO_APIC
-	return FIRST_DEVICE_VECTOR;
-#else
-	return FIRST_EXTERNAL_VECTOR;
-#endif
+	return IRQ0_VECTOR;
 }
 
 /** vmi clockchip */
@@ -239,8 +235,6 @@ void __init vmi_time_init(void)
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
-	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC



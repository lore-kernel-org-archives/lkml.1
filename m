Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYJaS4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYJaS4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYJaS4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:56:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:39138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbYJaS4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:56:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,523,1220252400"; 
   d="scan'208";a="633946487"
Date: Fri, 31 Oct 2008 11:56:26 -0700
Message-Id: <200810311856.m9VIuQ0q009450@agluck-lia64.sc.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Mike Travis" <travis@sgi.com>
Subject: [PATCH-linux-next] ia64: fix build breakage in smp.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit:
 "cpumask: switch over to cpu_online/possible/active/present_mask"
provides a define for cpu_online_map but did not delete the
declaration in arch/ia64/include/asm/smp.h resulting in this
build error:

  CC      arch/ia64/kernel/asm-offsets.s
In file included from include/linux/smp.h:30,
                 from include/linux/sched.h:68,
                 from arch/ia64/kernel/asm-offsets.c:9:
arch/ia64/include/asm/smp.h:60: error: expected ')' before '*' token
arch/ia64/include/asm/smp.h:60: error: expected ')' before 'cpu_online_mask'

Fix: just delete the declaration, it is no longer needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Ingo: I think this belongs in the auto-cpus4096-next branch of the tip tree

diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
index 12d96e0..21c4023 100644
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -57,7 +57,6 @@ extern struct smp_boot_data {
 
 extern char no_int_routing __devinitdata;
 
-extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYGSBLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYGSBLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYGSBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58430 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.395716000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:29 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] NR_CPUS: Replace NR_CPUS in arch/x86/kernel/genx2apic_uv_x.c
Content-Disposition: inline; filename=repl-NR_CPUS-in-arch_x86_kernel_genx2apic_uv_x_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Replace NR_CPUS loop with for_each_possible_cpu().

  * nr_cpu_ids should be used to determine if a percpu area is
    available for a given cpu.

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -98,7 +98,7 @@ static void uv_send_IPI_mask(cpumask_t m
 {
 	unsigned int cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; ++cpu)
+	for_each_possible_cpu(cpu)
 		if (cpu_isset(cpu, mask))
 			uv_send_IPI_one(cpu, vector);
 }
@@ -132,7 +132,7 @@ static unsigned int uv_cpu_mask_to_apici
 	 * May as well be the first.
 	 */
 	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;

-- 

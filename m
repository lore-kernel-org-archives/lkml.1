Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYGSBMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYGSBMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYGSBLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.544581000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:30 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/8] NR_CPUS: Replace NR_CPUS in arch/x86/kernel/genapic_flat_64.c
Content-Disposition: inline; filename=repl-NR_CPUS-in-arch_x86_kernel_genapic_flat_64_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * nr_cpu_ids should be used to determine if a percpu area is
    available for a given cpu.

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/genapic_flat_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -168,7 +168,7 @@ static unsigned int physflat_cpu_mask_to
 	 * May as well be the first.
 	 */
 	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;

-- 

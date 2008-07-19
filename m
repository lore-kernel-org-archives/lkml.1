Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYGSBM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYGSBM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYGSBLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:31 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753588AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.682825000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:31 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] NR_CPUS: Replace per_cpu(..., smp_processor_id()) with __get_cpu_var
Content-Disposition: inline; filename=repl-NR_CPUS-in-include_asm-x86_processor_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Slight optimization when getting one's own cpu_info percpu data.

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/include/asm-x86/processor.h
+++ linux-2.6.tip/include/asm-x86/processor.h
@@ -135,7 +135,7 @@ extern __u32			cleared_cpu_caps[NCAPINTS
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
-#define current_cpu_data	cpu_data(smp_processor_id())
+#define current_cpu_data	__get_cpu_var(cpu_info)
 #else
 #define cpu_data(cpu)		boot_cpu_data
 #define current_cpu_data	boot_cpu_data

-- 

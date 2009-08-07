Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZHGNG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZHGNG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZHGNG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:06:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:2190 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZHGNG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:06:26 -0400
X-SpamScore: 5
X-BigFish: VPS5(z34a4jzzz1202hzzz32i6bh203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KO0CD9-01-2I6-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 15:05:13 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 7/8] x86, smpboot: use zalloc_cpumask_var instead of
	alloc/clear
Message-ID: <20090807130513.GZ6520@alberich.amd.com>
References: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090807125609.GH7198@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2009 13:05:14.0384 (UTC) FILETIME=[B4113900:01CA175F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f50af56..f797214 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1068,14 +1068,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 #endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
-		cpumask_clear(per_cpu(cpu_core_map, i));
-		cpumask_clear(per_cpu(cpu_node_map, i));
-		cpumask_clear(per_cpu(cpu_sibling_map, i));
-		cpumask_clear(cpu_data(i).llc_shared_map);
+		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.6.3.3




Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZHaNA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZHaNA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZHaNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:00:08 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36200 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZHaNAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:00:01 -0400
X-SpamScore: 0
X-BigFish: VPS0(z34a4jz936eMzz1202hzzz32i6bh203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KP8S3S-01-9Z1-02
X-M-MSG: 
Date: Mon, 31 Aug 2009 14:58:59 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86, smpboot: use zalloc_cpumask_var instead of
	alloc/clear
Message-ID: <20090831125859.GB21867@alberich.amd.com>
References: <20090831125349.GA21867@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090831125349.GA21867@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Aug 2009 12:58:59.0980 (UTC) FILETIME=[CED1B4C0:01CA2A3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b5a419..4701f90 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1059,12 +1059,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 #endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
-		cpumask_clear(per_cpu(cpu_core_map, i));
-		cpumask_clear(per_cpu(cpu_sibling_map, i));
-		cpumask_clear(cpu_data(i).llc_shared_map);
+		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.6.4




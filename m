Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbZFLNhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbZFLNhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZFLNa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:30:59 -0400
Received: from ozlabs.org ([203.10.76.45]:55269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764823AbZFLNa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:58 -0400
CC: linux-kernel@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 4/13] cpumask: Use accessors for cpu_*_mask: powerpc
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133059.78A1ADDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/powerpc/kernel/setup-common.c      |    4 ++--
 arch/powerpc/platforms/powermac/setup.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -434,7 +434,7 @@ void __init smp_setup_cpu_maps(void)
 			    j, cpu, intserv[j]);
 			cpu_set(cpu, cpu_present_map);
 			set_hard_smp_processor_id(cpu, intserv[j]);
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 			cpu++;
 		}
 	}
@@ -480,7 +480,7 @@ void __init smp_setup_cpu_maps(void)
 			       maxcpus);
 
 		for (cpu = 0; cpu < maxcpus; cpu++)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 	out:
 		of_node_put(dn);
 	}
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -363,7 +363,7 @@ static void __init pmac_setup_arch(void)
 		int cpu;
 
 		for (cpu = 1; cpu < 4 && cpu < NR_CPUS; ++cpu)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 		smp_ops = &psurge_smp_ops;
 	}
 #endif


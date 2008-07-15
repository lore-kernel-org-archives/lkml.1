Return-Path: <linux-kernel-owner+w=401wt.eu-S1761765AbYGOCzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761765AbYGOCzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYGOCz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:55:29 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38316 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYGOCz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:55:28 -0400
Date: Mon, 14 Jul 2008 20:55:27 -0600
From: Alex Chiang <achiang@hp.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       davem@davemloft.net
Subject: [PATCH 10/14] [SPARC] Populate cpu_enabled_map
Message-ID: <20080715025527.GB15452@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the cpu_enabled_map correctly.

Note that this patch does not actually make any decisions based
on the contents of the map.

However, as the map is presented via sysfs in:

	/sys/devices/system/cpu/

It should be populated correctly.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: David S. Miller <davem@davemloft.net>
---

 arch/sparc/kernel/smp.c     |    1 +
 arch/sparc64/kernel/mdesc.c |    1 +
 arch/sparc64/kernel/smp.c   |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
index 6724ab9..154f32c 100644
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -343,6 +343,7 @@ void __init smp_setup_cpu_possible_map(void)
 		if (mid < NR_CPUS) {
 			cpu_set(mid, phys_cpu_present_map);
 			cpu_set(mid, cpu_present_map);
+			cpu_set(mid, cpu_enabled_map);
 		}
 		instance++;
 	}
diff --git a/arch/sparc64/kernel/mdesc.c b/arch/sparc64/kernel/mdesc.c
index dde52bc..5a77dad 100644
--- a/arch/sparc64/kernel/mdesc.c
+++ b/arch/sparc64/kernel/mdesc.c
@@ -827,6 +827,7 @@ void __cpuinit mdesc_fill_in_cpu_data(cpumask_t mask)
 
 #ifdef CONFIG_SMP
 		cpu_set(cpuid, cpu_present_map);
+		cpu_set(cpuid, cpu_enabled_map);
 #endif
 
 		c->core_id = 0;
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index fa63c68..652992a 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -1414,6 +1414,7 @@ void __cpu_die(unsigned int cpu)
 			hv_err = sun4v_cpu_stop(cpu);
 			if (hv_err == HV_EOK) {
 				cpu_clear(cpu, cpu_present_map);
+				cpu_clear(cpu, cpu_enabled_map);
 				break;
 			}
 		} while (--limit > 0);


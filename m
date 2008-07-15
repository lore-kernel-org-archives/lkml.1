Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbYGOCeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbYGOCeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYGOCd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:33:57 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15313 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbYGOCdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:33:55 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 02/14] [M32R] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Date: Mon, 14 Jul 2008 20:33:54 -0600
Message-ID: <20080715023354.2528.8879.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Cc: Hirokazu Takata <takata@linux-m32r.org>
---

 arch/m32r/kernel/smpboot.c |    1 +
 include/asm-m32r/smp.h     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 2c03ac1..4f2bbde 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -184,6 +184,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		physid_set(phys_id, phys_cpu_present_map);
 #ifndef CONFIG_HOTPLUG_CPU
 	cpu_present_map = cpu_possible_map;
+	cpu_enabled_map = cpu_possible_map;
 #endif
 
 	show_mp_info(nr_cpu);
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index 078e1a5..4ea1845 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -65,6 +65,7 @@ extern volatile int cpu_2_physid[NR_CPUS];
 extern cpumask_t cpu_callout_map;
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_enabled_map;
 
 static __inline__ int hard_smp_processor_id(void)
 {


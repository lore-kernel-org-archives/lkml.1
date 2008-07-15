Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYGOCgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYGOCgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbYGOCeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:19 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30801 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761093AbYGOCeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:16 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 06/14] [PARISC] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Kyle McMartin <kyle@mcmartin.ca>
Date: Mon, 14 Jul 2008 20:34:15 -0600
Message-ID: <20080715023415.2528.97760.stgit@blender.achiang>
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
Cc: Kyle McMartin <kyle@mcmartin.ca>
---

 arch/parisc/kernel/processor.c |    1 +
 arch/parisc/kernel/smp.c       |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
index 370086f..fb81222 100644
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -201,6 +201,7 @@ static int __cpuinit processor_probe(struct parisc_device *dev)
 #ifdef CONFIG_SMP
 	if (cpuid) {
 		cpu_set(cpuid, cpu_present_map);
+		cpu_set(cpuid, cpu_enabled_map);
 		cpu_up(cpuid);
 	}
 #endif
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 85fc775..a31b0ad 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -535,6 +535,7 @@ void __devinit smp_prepare_boot_cpu(void)
 
 	cpu_set(bootstrap_processor, cpu_online_map);
 	cpu_set(bootstrap_processor, cpu_present_map);
+	cpu_set(bootstrap_processor, cpu_enabled_map);
 }
 
 
@@ -546,7 +547,9 @@ void __devinit smp_prepare_boot_cpu(void)
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	cpus_clear(cpu_present_map);
+	cpus_clear(cpu_enabled_map);
 	cpu_set(0, cpu_present_map);
+	cpu_set(0, cpu_enabled_map);
 
 	parisc_max_cpus = max_cpus;
 	if (!max_cpus)


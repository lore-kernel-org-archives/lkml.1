Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYGOCgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYGOCgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbYGOCeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:15 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:15963 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYGOCeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:12 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 05/14] [MIPS] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 14 Jul 2008 20:34:10 -0600
Message-ID: <20080715023410.2528.66597.stgit@blender.achiang>
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
Cc: Ralf Baechle <ralf@linux-mips.org>
---

 arch/mips/kernel/smp.c  |    1 +
 arch/mips/kernel/smtc.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index cdf87a9..8f7f742 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -304,6 +304,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
 	cpu_present_map = cpu_possible_map;
+	cpu_enabled_map = cpu_possible_map;
 #endif
 }
 
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 3e86318..b0c16e0 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -498,6 +498,7 @@ void mipsmt_prepare_cpus(void)
 	while (tc < (((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1)) {
 		cpu_clear(tc, phys_cpu_present_map);
 		cpu_clear(tc, cpu_present_map);
+		cpu_clear(tc, cpu_enabled_map);
 		tc++;
 	}
 


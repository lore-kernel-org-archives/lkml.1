Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbYGOCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbYGOCfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYGOCeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:08 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15366 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760782AbYGOCeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:06 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 04/14] [ARM] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Russell King <rmk@dyn-67.arm.linux.org.uk>
Date: Mon, 14 Jul 2008 20:34:05 -0600
Message-ID: <20080715023405.2528.34106.stgit@blender.achiang>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@dyn-67.arm.linux.org.uk>
---

 arch/arm/mach-realview/platsmp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 8e813ed..c33f298 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -241,8 +241,10 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
+	for (i = 0; i < max_cpus; i++) {
 		cpu_set(i, cpu_present_map);
+		cpu_set(i, cpu_enabled_map);
+	}
 
 	/*
 	 * Initialise the SCU if there are more than one CPU and let


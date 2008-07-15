Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYGOCin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYGOCin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761637AbYGOCex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:53 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15596 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761536AbYGOCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:51 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 13/14] [IA64] Avoid overflowing ia64_cpu_to_sapicid in
	acpi_map_lsapic()
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@intel.com>
Date: Mon, 14 Jul 2008 20:34:50 -0600
Message-ID: <20080715023450.2528.89675.stgit@blender.achiang>
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

acpi_map_lsapic tries to stuff a long into ia64_cpu_to_sapicid[],
which can only hold ints, so let's fix that.

We need to update the signature of acpi_map_cpu2node() too.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Tony Luck <tony.luck@intel.com>
---

 arch/ia64/kernel/acpi.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 1b4b338..a928b94 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -775,7 +775,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 static
-int acpi_map_cpu2node(acpi_handle handle, int cpu, long physid)
+int acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int pxm_id;
@@ -855,8 +855,7 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	union acpi_object *obj;
 	struct acpi_madt_local_sapic *lsapic;
 	cpumask_t tmp_map;
-	long physid;
-	int cpu;
+	int cpu, physid;
 
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
 		return -EINVAL;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYJKHmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYJKHmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYJKHhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:42 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32846 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466AbYJKHhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:37 -0400
Date: Sat, 11 Oct 2008 02:36:30 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 70/85] ACPI: remove unused have_arch_parse_srat
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Message-id: <fa89b6089b5f4c7a5244b642caaca3e72b06ebe4.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>

This was a workaround for 32bit numa SRAT processing, and we removed those
workarounds, making 32 bit more like 64 bit.  HAVE_ARCH_PARSE_SRAT is no
longer defined anywhere.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/acpi.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 702f79d..fd6a452 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -94,18 +94,10 @@ int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
 
 /* the following four functions are architecture-dependent */
-#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
-#define NR_NODE_MEMBLKS MAX_NUMNODES
-#define acpi_numa_slit_init(slit) do {} while (0)
-#define acpi_numa_processor_affinity_init(pa) do {} while (0)
-#define acpi_numa_memory_affinity_init(ma) do {} while (0)
-#define acpi_numa_arch_fixup() do {} while (0)
-#else
 void acpi_numa_slit_init (struct acpi_table_slit *slit);
 void acpi_numa_processor_affinity_init (struct acpi_srat_cpu_affinity *pa);
 void acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma);
 void acpi_numa_arch_fixup(void);
-#endif
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
-- 
1.5.5.1


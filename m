Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYIYCFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYIYCFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYIYCFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYIYCFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vev1/PvQaXbd0YorLaFcaFaAd9NL4tVXBis/Oj1rddiUEYdMVb7LQIPk+7iyWd7fUG
         xI21J9lhnJmembLqDGs7ZbGLtdjuSpnATaJ5OWidVV8pQ4NXqnrw8BP6np5sNNN+1HaO
         eOYlJ8s20hbUgYhiXHczjwUGK1bNatCufhnGg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/7] acpi: remove have_arch_parse_srat in acpi.h
Date: Wed, 24 Sep 2008 19:04:32 -0700
Message-Id: <1222308277-10984-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32bit don't need that anymore

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/linux/acpi.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4d5ec43..8eefaa9 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -95,18 +95,10 @@ int acpi_parse_mcfg (struct acpi_table_header *header);
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
1.5.6


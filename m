Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYGRXW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYGRXW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGRXWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:22:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:10136 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYGRXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=BtOeeTxHkJrOfKh+RLYmijyFuPVfU+EGNKPaIkJ6QKsw5qIn5pCMagWhdzj+PUK3Zm
         q/bkxNLcv0vkZ1bqViX93wN/KD9IF1nKHrH07AAvzc6I5rqNppPbFd935EEoTCw/Pccg
         BjV02pkjBJInAQEYdw2zD2l+x6khCCpgeI8Jw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "lenb@kernel.org" <lenb@kernel.org>
Subject: [PATCH] acpi: remove have_arch_parse_srat in acpi.h
Date: Fri, 18 Jul 2008 16:22:15 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181622.15595.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32bit don't need that anymore

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/acpi.h |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -94,18 +94,10 @@ int acpi_parse_mcfg (struct acpi_table_h
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

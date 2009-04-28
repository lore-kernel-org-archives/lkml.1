Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZD1NB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZD1NB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760495AbZD1NAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:00:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59732 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323AbZD1NAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:00:52 -0400
Subject: [PATCH 1/2] x86: move max_pfn_mapped and max_low_pfn_mapped to
 setup.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 16:00:49 +0300
Message-Id: <1240923649.1982.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch moves the max_pfn_mapped and max_low_pfn_mapped global
variables to kernel/setup.c where they're initialized.

[ Impact: cleanup ]
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/setup.c |    8 ++++++++
 arch/x86/mm/init_32.c   |    4 +---
 arch/x86/mm/init_64.c   |    8 --------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..0d77e56 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,6 +112,14 @@
 #define ARCH_SETUP
 #endif
 
+/*
+ * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
+ * The direct mapping extends to max_pfn_mapped, so that we can directly access
+ * apertures, ACPI and other tables without having to play with fixmaps.
+ */
+unsigned long max_low_pfn_mapped;
+unsigned long max_pfn_mapped;
+
 RESERVE_BRK(dmi_alloc, 65536);
 
 unsigned int boot_cpu_id __read_mostly;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..ce2ec31 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,11 +49,9 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
+#include <asm/page_types.h>
 #include <asm/init.h>
 
-unsigned long max_low_pfn_mapped;
-unsigned long max_pfn_mapped;
-
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..abb932f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,14 +50,6 @@
 #include <asm/cacheflush.h>
 #include <asm/init.h>
 
-/*
- * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
- * The direct mapping extends to max_pfn_mapped, so that we can directly access
- * apertures, ACPI and other tables without having to play with fixmaps.
- */
-unsigned long max_low_pfn_mapped;
-unsigned long max_pfn_mapped;
-
 static unsigned long dma_reserve __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-- 
1.5.6.3




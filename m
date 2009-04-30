Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZD3ITY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZD3ITY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZD3ITJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:19:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZD3ITH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:19:07 -0400
Date: Thu, 30 Apr 2009 08:18:31 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240923649.1982.21.camel@penberg-laptop>
References: <1240923649.1982.21.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: move max_pfn_mapped and max_low_pfn_mapped to setup.c
Message-ID: <tip-2b72394e4089643f11669d9610907a1442fe044a@git.kernel.org>
Git-Commit-ID: 2b72394e4089643f11669d9610907a1442fe044a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 08:18:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b72394e4089643f11669d9610907a1442fe044a
Gitweb:     http://git.kernel.org/tip/2b72394e4089643f11669d9610907a1442fe044a
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 28 Apr 2009 16:00:49 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 10:12:36 +0200

x86: move max_pfn_mapped and max_low_pfn_mapped to setup.c

This patch moves the max_pfn_mapped and max_low_pfn_mapped global
variables to kernel/setup.c where they're initialized.

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1240923649.1982.21.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 2b27120..a640a7f 100644
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
index a4e7846..1016ea0 100644
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

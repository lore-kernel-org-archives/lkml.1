Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbZD0UfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbZD0UfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbZD0Uea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:34:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55447 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731AbZD0Ue2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:34:28 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 02/14] sh: Use macros for .bss.page_aligned section.
Date: Mon, 27 Apr 2009 16:32:56 -0400
Message-Id: <1240864388-26315-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-2-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/irq.c            |    6 ++----
 arch/sh/kernel/vmlinux_32.lds.S |    2 +-
 arch/sh/kernel/vmlinux_64.lds.S |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 3f1372e..9853fde 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -157,11 +157,9 @@ asmlinkage int do_IRQ(unsigned int irq, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_IRQSTACKS
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index dd9b2ee..99a4124 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -131,7 +131,7 @@ SECTIONS
 	.bss : {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		PAGE_ALIGNED_BSS
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index 6966446..cb46577 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -140,7 +140,7 @@ SECTIONS
 	.bss : C_PHYS(.bss) {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		PAGE_ALIGNED_BSS
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
-- 
1.6.2.1


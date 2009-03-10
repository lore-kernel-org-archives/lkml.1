Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZCJFOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZCJFOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZCJFLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35665 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZCJFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B9MR3G3AtOMgcFGgNgQUrynmM7XtHBsQG5BuhcVzotALd+Gbv5X54ZnBM8mps57jxC
         H6ENhW4wsd5ROUoyJQyAmqDjyaSSH719PySRDFciNjjnrYKociwtaTKtE1D+nphOYLoC
         KUdBT5YH6quvFpUG3p/SzTSwnZTCfLQql4S2g=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, linux-am33-list@redhat.com
Subject: [PATCH 10/25] [mn10300] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:35 -0500
Message-Id: <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/mn10300/kernel/irq.c                |    3 +--
 arch/mn10300/mm/init.c                   |    3 +--
 arch/mn10300/mm/misalignment.c           |    3 +--
 include/asm-mn10300/unit-asb2303/timex.h |    3 +--
 include/asm-mn10300/unit-asb2305/timex.h |    3 +--
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 56c64cc..52b528e 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -159,8 +159,7 @@ asmlinkage void do_IRQ(void)
 	int irq;
 
 	sp = current_stack_pointer();
-	if (sp - (sp & ~(THREAD_SIZE - 1)) < STACK_WARN)
-		BUG();
+	BUG_ON(sp - (sp & ~(THREAD_SIZE - 1)) < STACK_WARN);
 
 	/* make sure local_irq_enable() doesn't muck up the interrupt priority
 	 * setting in EPSW */
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 8cee387..ea05781 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -84,8 +84,7 @@ void __init mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
-	if (!mem_map)
-		BUG();
+	BUG_ON(!mem_map);
 
 #define START_PFN	(contig_page_data.bdata->node_min_pfn)
 #define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index 94c4a43..eb1a290 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -450,8 +450,7 @@ found_opcode:
 	       regs->pc, opcode, pop->opcode, pop->params[0], pop->params[1]);
 
 	tmp = format_tbl[pop->format].opsz;
-	if (tmp > noc)
-		BUG(); /* match was less complete than it ought to have been */
+	BUG_ON(tmp > noc); /* match was less complete than it ought to have been */
 
 	if (tmp < noc) {
 		tmp = noc - tmp;
diff --git a/include/asm-mn10300/unit-asb2303/timex.h b/include/asm-mn10300/unit-asb2303/timex.h
index 7e54b0c..4bf620e 100644
--- a/include/asm-mn10300/unit-asb2303/timex.h
+++ b/include/asm-mn10300/unit-asb2303/timex.h
@@ -50,8 +50,7 @@ static inline void startup_jiffies_counter(void)
 			md = TM0MD_SRC_IOCLK_32;
 			rate = MN10300_JCCLK / 32 / HZ;
 
-			if (rate > TMJCBR_MAX)
-				BUG();
+			BUG_ON(rate > TMJCBR_MAX);
 		}
 	}
 
diff --git a/include/asm-mn10300/unit-asb2305/timex.h b/include/asm-mn10300/unit-asb2305/timex.h
index 10e1bfe..e51a9d1 100644
--- a/include/asm-mn10300/unit-asb2305/timex.h
+++ b/include/asm-mn10300/unit-asb2305/timex.h
@@ -50,8 +50,7 @@ static inline void startup_jiffies_counter(void)
 			md = TM0MD_SRC_IOCLK_32;
 			rate = MN10300_JCCLK / 32 / HZ;
 
-			if (rate > TMJCBR_MAX)
-				BUG();
+			BUG_ON(rate > TMJCBR_MAX);
 		}
 	}
 
-- 
1.6.1.3


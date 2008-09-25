Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYIYCGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYIYCGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYIYCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIYCFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GBUfYGAQLBIV/kKAWUi4saOllIgUM5FRsM4wGKANAie+z0W58FnRGWGFRf6kzn3aLF
         5iCTt3+FvZyR1npOSkSgHVT90+m/3iuiONcEtbma1G6lCwZzc63kdXL124IIiE+Uswxn
         VHCQ9jbyvjYlqHGHIhrQNV75EK6puToIKgvxI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/7] x86: fix typo in irq_desc array
Date: Wed, 24 Sep 2008 19:04:35 -0700
Message-Id: <1222308277-10984-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when SPARSE_IRQ is not used, should still use irq_desc->lock

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 kernel/irq/handle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 7f625fb..fb6bdb6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -253,7 +253,7 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
-		.lock = __SPIN_LOCK_UNLOCKED(sparse_irqs->lock),
+		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
 #ifdef CONFIG_SMP
 		.affinity = CPU_MASK_ALL
 #endif
-- 
1.5.6


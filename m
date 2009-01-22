Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbZAVNfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbZAVNfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZAVNdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZAVNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dj07fCAP1FCViQPB98JYD+71T2DL1uttWU3htttxxgEbGBwxjy0gzj/i7T5AW6pE8E
         v4FUfZrSDC3PQyws6WNW4xZVe6ViVZMfCVQS8HxT2eXlsQ3flBr8ByOrruy/uAnB057l
         b7lIEsLlkXlZTH94XUpVuh3Mc954/dyq+Q/Uw=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 5/5] x86: make irq_cpustat_t fields conditional.
Date: Thu, 22 Jan 2009 08:33:38 -0500
Message-Id: <1232631218-5092-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f4a95f2..176f058 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -7,14 +7,22 @@
 typedef struct {
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq0_irqs;
+#ifdef CONFIG_X86_LOCAL_APIC
+	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq_spurious_count;
+#endif
+#ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
 	unsigned int irq_tlb_count;
+#endif
+#ifdef CONFIG_X86_MCE
 	unsigned int irq_thermal_count;
-	unsigned int irq_spurious_count;
+# ifdef CONFIG_X86_64
 	unsigned int irq_threshold_count;
+# endif
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
-- 
1.6.1


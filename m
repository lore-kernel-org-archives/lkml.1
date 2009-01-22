Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZAVNdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZAVNdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZAVNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:34 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZAVNdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DidWJ3A62Srk7pdLBAw6OXrPj28z7dUJmo26q4sKYLyc0AU0PMS3EN3sxahswNIgtj
         eTzdv8EJLLBk/2qE4oRT4xmg9I46xRECKq73rG/q0l30hmakZvtqqQAEuvPJ7cLHRPux
         KpnafTNGLk/etx99LMVKWb57P4GsOSpDbOfTM=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/5] x86-32: Remove idle_timestamp
Date: Thu, 22 Jan 2009 08:33:34 -0500
Message-Id: <1232631218-5092-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idle_timestamp is left over from the removed irqbalance code.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq_32.h |    1 -
 arch/x86/kernel/process_32.c      |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index d4b5d73..a70ed05 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -6,7 +6,6 @@
 
 typedef struct {
 	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq0_irqs;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 2c00a57..1a1ae8e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -108,7 +108,6 @@ void cpu_idle(void)
 				play_dead();
 
 			local_irq_disable();
-			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 			pm_idle();
-- 
1.6.1


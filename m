Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYHRQtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYHRQtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYHRQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:25008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbYHRQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WrO/YDhHj1/Fmyq/PsQ0enWkc+1bwyzV1ndKY7Is4ZNeNGPbNvuDAkmvTW2VAyzyJr
         tNETZGA2QLA/H/X1bfqJI3CDAoGHKfMVX7rBv+wXbOv9nl6V7q6mv1ezm1tJQpKtu3Jo
         2i4qVL14uoJ2f8ZVRQPiomCYu92QJLSKzgBWI=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 11/15] x86: apic - unify local_apic_timer_interrupt
Date: Mon, 18 Aug 2008 20:45:59 +0400
Message-Id: <209413378855cb1d96ff649c9570fc391167383c.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    4 ++++
 arch/x86/kernel/apic_64.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index f188232..af227bc 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -685,7 +685,11 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
+#ifdef CONFIG_X86_64
+	add_pda(apic_timer_irqs, 1);
+#else
 	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+#endif
 
 	evt->event_handler(evt);
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index eec10b3..a9ad2cb 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -567,7 +567,11 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
+#ifdef CONFIG_X86_64
 	add_pda(apic_timer_irqs, 1);
+#else
+	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+#endif
 
 	evt->event_handler(evt);
 }
-- 
1.6.0.rc1.34.g0fe8c


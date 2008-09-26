Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYIZFW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYIZFW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIZFWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:22:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:28868 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYIZFWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HOSGTlDYwolU1WQ0xiYQvnzQy4MPYnoznXsfz1og8/vII8qm57sUVF68fi5zDNygS6
         Dwt/bZZ8o8LgFVk9XJy18wXGBzKVxWXiU8GRj1w35ggv958Zi3F9Hc5bbLpe0K6H+LRw
         F+eDfQfsBW6MaLxz8pt+Skiw22Y7xUim/xYxo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/1] x86: remove extra ifdef
Date: Thu, 25 Sep 2008 22:22:12 -0700
Message-Id: <1222406533-12650-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also change two func to static

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/irqinit_64.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 7df020b..d17fbc2 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -160,7 +160,7 @@ void __init init_ISA_irqs(void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-void __init smp_intr_init(void)
+static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
 	/*
@@ -191,11 +191,9 @@ void __init smp_intr_init(void)
 #endif
 }
 
-void __init apic_intr_init(void)
+static void __init apic_intr_init(void)
 {
-#ifdef CONFIG_SMP
 	smp_intr_init();
-#endif
 
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
-- 
1.5.6


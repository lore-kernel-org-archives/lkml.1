Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZALTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZALTzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZALTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:55:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:38659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZALTzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:55:01 -0500
Message-ID: <496B9FF3.3080909@kernel.org>
Date: Mon, 12 Jan 2009 11:54:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make 32bit MAX_HARDIRQSS_PER_CPU to be NR_VECTORS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up to be same as 64bit

32bit is use per-cpu vector too, so don't use default NR_IRQS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hardirq_32.h  |    3 +++
 arch/x86/include/asm/irq_vectors.h |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hardirq_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hardirq_32.h
+++ linux-2.6/arch/x86/include/asm/hardirq_32.h
@@ -20,6 +20,9 @@ typedef struct {
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 
+/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
+#define MAX_HARDIRQS_PER_CPU NR_VECTORS
+
 #define __ARCH_IRQ_STAT
 #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 

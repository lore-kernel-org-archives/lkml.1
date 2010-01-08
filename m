Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980Ab0AHLzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0AHLzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235Ab0AHLyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:54:50 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52882 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0AHLyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:54:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 08 Jan 2010 03:53:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/5] x86: update nr_irqs according cpu num
In-reply-to: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1262951595-1729-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that is max number on run time.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3840,16 +3840,14 @@ int __init arch_probe_nr_irqs(void)
 {
 	int nr;
 
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
-
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += nr_irqs_gsi * 64;
+	nr = NR_VECTORS - FIRST_DEVICE_VECTOR;
+#ifdef CONFIG_SMP
+	/* system vectors */
+	nr -= 0x10;
 #endif
+	nr *= nr_cpu_ids;
+	nr += FIRST_DEVICE_VECTOR - IRQ0_VECTOR;
+
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 

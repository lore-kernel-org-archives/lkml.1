Return-Path: <linux-kernel-owner+w=401wt.eu-S937320AbYEBXpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937320AbYEBXpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932782AbYEBXoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:44:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55014 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbYEBXoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:44:54 -0400
Message-ID: <481BA774.5090004@ct.jp.nec.com>
Date: Fri, 02 May 2008 16:44:52 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: nmi and irq counters are unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

__nmi_count, apic_timer_irqs and irq0_irqs are unsigned.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index 5a29ded..33cb8ec 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -79,7 +79,7 @@ static __init void nmi_cpu_busy(void *data)
 
 int __init check_nmi_watchdog(void)
 {
-	int *prev_nmi_count;
+	unsigned int *prev_nmi_count;
 	int cpu;
 
 	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED))
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
-	int sum;
+	unsigned int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
 	int rc = 0;
-- 
1.5.4.1


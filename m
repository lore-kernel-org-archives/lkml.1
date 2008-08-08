Return-Path: <linux-kernel-owner+w=401wt.eu-S1765051AbYHHWHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765051AbYHHWHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762118AbYHHVzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761777AbYHHVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZHcqqizSK8gzNRPTpb5q2zH6CFSg36V024PYtIZE37cZdtmeGq9sRmyjZUDOPyUnYY
         iTkaWqA09ZaqLYE5PKmPEhRYGV0UcYJLqFK9ockAj4ZCRbaXf6w/lrF8eKprL13g9UDz
         Q87B82qkbOgy57oZYVi4SjFctIRTbURHobgaA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 36/42] x86_64: introduce irq_cfg_with_new
Date: Fri,  8 Aug 2008 14:52:42 -0700
Message-Id: <1218232368-31228-37-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-36-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-33-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-34-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-35-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-36-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could only call that one time, when we call add_irq_2_pin

Singed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index fc1c6ba..1466e4b 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -135,7 +135,7 @@ static void __init init_work(void *data)
 static struct irq_cfg *irq_cfgx;
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
-static struct irq_cfg *irq_cfg_without_new(unsigned int irq)
+static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg;
 
@@ -155,7 +155,7 @@ static struct irq_cfg *irq_cfg_without_new(unsigned int irq)
 	return NULL;
 }
 
-static struct irq_cfg *irq_cfg(unsigned int irq)
+static struct irq_cfg *irq_cfg_with_new(unsigned int irq)
 {
 	struct irq_cfg *cfg, *cfg_pri;
 	int i;
@@ -545,7 +545,8 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	cfg = irq_cfg(irq);
+	/* first time to refer irq_cfg, so with new */
+	cfg = irq_cfg_with_new(irq);
 	entry = cfg->irq_2_pin;
 	if (!entry) {
 		entry = get_one_free_irq_2_pin();
@@ -1208,13 +1209,15 @@ static int setup_ioapic_entry(int apic, int irq,
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			      int trigger, int polarity)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	cfg = irq_cfg(irq);
+
 	mask = TARGET_CPUS;
 	if (assign_irq_vector(irq, mask))
 		return;
@@ -2490,8 +2493,11 @@ int create_irq(void)
 		if (platform_legacy_irq(new))
 			continue;
 		cfg_new = irq_cfg(new);
-		if (cfg_new->vector != 0)
+		if (cfg_new && cfg_new->vector != 0)
 			continue;
+		/* check if need to create one */
+		if (!cfg_new)
+			cfg_new = irq_cfg_with_new(new);
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYIYCHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYIYCHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYIYCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYIYCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jQOtEIqbTLXm4rjHbwGr9uHesGV4nVfCeLF27wuuOcLbvYE3iriH6wgYFKYolVmvV4
         8e8srMn4vY1OSuOoeqV/MtToLQKre4QdX7UaOhWLzrwNWw3+yDW5RYigRlXJ/qf0b40z
         JC8/aDsxiopH0a27TFSCZ/Z4aN44HR2j+34Ic=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 6/7] x86: irq no should not use hex in /proc/interrupts
Date: Wed, 24 Sep 2008 19:04:36 -0700
Message-Id: <1222308277-10984-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/irq_32.c |    2 +-
 arch/x86/kernel/irq_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index b2e1082..001772f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -307,7 +307,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
-		seq_printf(p, "%#x: ",i);
+		seq_printf(p, "%3d: ", i);
 #ifndef CONFIG_SMP
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index c2fca89..ec26610 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -112,7 +112,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		action = desc->action;
 		if (!action && !any_count)
 			goto skip;
-		seq_printf(p, "%#x: ",i);
+		seq_printf(p, "%3d: ", i);
 #ifndef CONFIG_SMP
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
-- 
1.5.6


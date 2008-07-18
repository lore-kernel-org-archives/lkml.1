Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbYGRR3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbYGRR3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYGRR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:28:55 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:2539 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYGRR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:28:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=W61ydiWjlyn3TJfgPa6OzozKBtJYvgq7aMjeCTww3ChB4hIY4rjEZ8KAF1Yttxxi55
         HsetVxyiEkd5ctE2QE0e/zldvM5t+4tdQs/Qjzi4xZd9NiCZ31hBDiyAliA0ZJtks2PL
         ZhmpxZNuszWUiTEMO8FAKWC8kbJGWcgxE2TGc=
Date: Fri, 18 Jul 2008 19:28:21 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: warn on apic error
Message-ID: <20080718172821.GA4149@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e89f2a9f33d01a2df7553b63cb1df525c6e75ad4 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 18 Jul 2008 19:14:06 +0200
Subject: [PATCH] x86: warn on apic error

There are certain APIC errors which are obviously programmer errors,
e.g. writing to illegal APIC registers, or sending invalid interrupt
vectors. Since the error interrupt happens spot on the erroneous code,
we might as well make a bit of noise about it and display the stack-
trace.

Cc: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/apic_32.c |    1 +
 arch/x86/kernel/apic_64.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index a437d02..b9289cb 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1317,6 +1317,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	*/
 	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
 		smp_processor_id(), v , v1);
+	WARN_ON(v1 & ((1 << 0) | (1 << 2) | (1 << 5) | (1 << 7)));
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 1e3d32e..2d959f2 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -997,6 +997,7 @@ asmlinkage void smp_error_interrupt(void)
 	*/
 	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
+	WARN_ON(v1 & ((1 << 0) | (1 << 2) | (1 << 5) | (1 << 7)));
 	irq_exit();
 }
 
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYHOCWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYHOCWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYHOCVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29630 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYHOCV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mgR49JDTE+xbs/GkppVtcPCHmvsLZrVEtWl7AcnyllloQOfe6p6touzw2psr+sM1Ta
         /eS0fCCf2SwLPgzPp7/06d0eqPpuqSb6GT3FF6SOFV+Z7OWQt+dARj9eTZ+rjx/TlWzA
         FhFREjfCED1lpG9OJE5MSIC7EF7xVA3PEwN+w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/7] x86_64: rename irq_desc/irq_desc_with_new - fix
Date: Thu, 14 Aug 2008 19:20:29 -0700
Message-Id: <1218766832-20476-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to check if desc is null in smp_irq_move_cleanup

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 4d1b02d..e4f03cc 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1950,6 +1950,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		irq = __get_cpu_var(vector_irq)[vector];
 
 		desc = irq_desc(irq);
+		if (!desc)
+			continue;
+
 		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
-- 
1.5.4.5


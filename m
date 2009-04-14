Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZDNP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZDNP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZDNPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46006 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbZDNPvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:51 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/14] [VOYAGER] x86/Voyager: add missing QIC call function single gate
Date: Tue, 14 Apr 2009 10:51:37 -0500
Message-Id: <1239724300-16371-12-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently this was never plugged into the QIC (it was plugged into
the VIC).  The lack was detected during testing of smp_call_function()
based flushing.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 98e3c2b..84d1d7f 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1266,6 +1266,8 @@ void __init voyager_smp_intr_init(void)
 	QIC_SET_GATE(QIC_RESCHEDULE_CPI, qic_reschedule_interrupt);
 	QIC_SET_GATE(QIC_ENABLE_IRQ_CPI, qic_enable_irq_interrupt);
 	QIC_SET_GATE(QIC_CALL_FUNCTION_CPI, qic_call_function_interrupt);
+	QIC_SET_GATE(QIC_CALL_FUNCTION_SINGLE_CPI,
+		     qic_call_function_single_interrupt);
 
 	/* now put the VIC descriptor into the first 48 IRQs
 	 *
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZCHQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZCHQwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZCHQsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37654 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbZCHQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:54 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/13] [VOYAGER] x86/Voyager: add missing QIC call function single gate
Date: Sun,  8 Mar 2009 11:48:24 -0500
Message-Id: <1236530906-7175-12-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-11-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-10-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-11-git-send-email-James.Bottomley@HansenPartnership.com>
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
1.6.1.3


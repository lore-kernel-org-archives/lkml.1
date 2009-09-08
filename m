Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZIHJ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZIHJ42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZIHJ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:56:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:6117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZIHJ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,352,1249282800"; 
   d="scan'208";a="724866372"
From: Sheng Yang <sheng@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in GENERIC_INTERRUPT_VECTOR handler
Date: Tue,  8 Sep 2009 17:52:26 +0800
Message-Id: <1252403546-12544-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise would cause trouble...

Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b0cdde6..78b23d0 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -257,7 +257,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	ack_APIC_irq();
+	if (!disable_apic)
+		ack_APIC_irq();
 
 	exit_idle();
 
-- 
1.5.4.5


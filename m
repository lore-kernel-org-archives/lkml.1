Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbZFPUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbZFPUS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbZFPUQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:16 -0400
Received: from claw.goop.org ([74.207.240.146]:40590 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbZFPUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/16] x86/ioapic.c: unify ioapic_retrigger_irq()
Date: Tue, 16 Jun 2009 13:15:55 -0700
Message-Id: <1245183355-25808-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The 32 and 64-bit versions of ioapic_retrigger_irq() are identical
except the 64-bit one takes vector_lock.  vector_lock is defined and
used on 32-bit too, so just use a common ioapic_retrigger_irq().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 377aac3..c6acce2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2176,7 +2176,6 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	return was_pending;
 }
 
-#ifdef CONFIG_X86_64
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 
@@ -2189,14 +2188,6 @@ static int ioapic_retrigger_irq(unsigned int irq)
 
 	return 1;
 }
-#else
-static int ioapic_retrigger_irq(unsigned int irq)
-{
-	apic->send_IPI_self(irq_cfg(irq)->vector);
-
-	return 1;
-}
-#endif
 
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
-- 
1.6.2.2


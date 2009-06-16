Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbZFPURy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbZFPURy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762008AbZFPUQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:14 -0400
Received: from claw.goop.org ([74.207.240.146]:40589 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021AbZFPUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/16] x86/ioapic.c: convert __target_IO_APIC_irq to conventional for() loop
Date: Tue, 16 Jun 2009 13:15:54 -0700
Message-Id: <1245183355-25808-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use a normal for() loop in __target_IO_APIC_irq().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f466a1e..377aac3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2234,13 +2234,9 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
 
-	entry = cfg->irq_2_pin;
-	for (;;) {
+	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		unsigned int reg;
 
-		if (!entry)
-			break;
-
 		apic = entry->apic;
 		pin = entry->pin;
 		/*
@@ -2253,9 +2249,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
 		io_apic_modify(apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 }
 
-- 
1.6.2.2


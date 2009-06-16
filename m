Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbZFPUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbZFPUSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbZFPUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:17 -0400
Received: from claw.goop.org ([74.207.240.146]:40588 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbZFPUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/16] x86/ioapic.c: convert replace_pin_at_irq_node to conventional for() loop
Date: Tue, 16 Jun 2009 13:15:52 -0700
Message-Id: <1245183355-25808-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use a conventional for() loop in replace_pin_at_irq_node().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 350d99b..b71d2a2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -512,10 +512,10 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_pin_list *entry = cfg->irq_2_pin;
+	struct irq_pin_list *entry;
 	int replaced = 0;
 
-	while (entry) {
+	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
@@ -523,7 +523,6 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 			/* every one is different, right? */
 			break;
 		}
-		entry = entry->next;
 	}
 
 	/* why? call replace before add? */
-- 
1.6.2.2


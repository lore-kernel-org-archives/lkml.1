Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbZFPUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbZFPUQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbZFPUQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:09 -0400
Received: from claw.goop.org ([74.207.240.146]:40571 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZFPUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/16] x86/ioapic.c: ioapic_modify_irq is too large to inline
Date: Tue, 16 Jun 2009 13:15:45 -0700
Message-Id: <1245183355-25808-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If ioapic_modify_irq() is marked inline, it gets inlined several times.
Un-inlining it saves around 200 bytes in .text for me.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1946fac..01aa429 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -553,9 +553,9 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 		add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
-static inline void io_apic_modify_irq(struct irq_cfg *cfg,
-				int mask_and, int mask_or,
-				void (*final)(struct irq_pin_list *entry))
+static void io_apic_modify_irq(struct irq_cfg *cfg,
+			       int mask_and, int mask_or,
+			       void (*final)(struct irq_pin_list *entry))
 {
 	int pin;
 	struct irq_pin_list *entry;
-- 
1.6.2.2


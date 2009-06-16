Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbZFPUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbZFPUTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZFPUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:20 -0400
Received: from claw.goop.org ([74.207.240.146]:40608 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760712AbZFPUQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/16] x86/ioapic.c: move lost comment to what seems like appropriate place
Date: Tue, 16 Jun 2009 13:15:49 -0700
Message-Id: <1245183355-25808-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The comment got separated from its subject, so move it to what
appears to be the right place, and update to describe the current
structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce5e888..089a4e4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -116,13 +116,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
-
 struct irq_pin_list {
 	int apic, pin;
 	struct irq_pin_list *next;
@@ -137,6 +130,11 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 	return pin;
 }
 
+/*
+ * This is performance-critical, we want to do it O(1)
+ *
+ * Most irqs are mapped 1:1 with pins.
+ */
 struct irq_cfg {
 	struct irq_pin_list *irq_2_pin;
 	cpumask_var_t domain;
-- 
1.6.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0BXCuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:50:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:34245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0BXCuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:50:17 -0500
Message-ID: <4B8493A0.6080501@kernel.org>
Date: Tue, 23 Feb 2010 18:49:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, alek.du@intel.com, jacob.jun.pan@intel.com,
       linux-tip-commits@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: fix compiling warning with legacy_pci_xxx
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org>
In-Reply-To: <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also remove duplicated cfg[i].vector assigning...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    2 --
 arch/x86/kernel/i8259.c        |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -161,8 +161,6 @@ int __init arch_early_irq_init(void)
 	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
-		if (i < legacy_pic->nr_legacy_irqs)
-			cfg[i].vector = IRQ0_VECTOR + i;
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c
+++ linux-2.6/arch/x86/kernel/i8259.c
@@ -371,9 +371,9 @@ static void init_8259A(int auto_eoi)
  * platforms, such as x86 MID.
  */
 
-static void __init legacy_pic_noop(void) { };
-static void __init legacy_pic_uint_noop(unsigned int unused) { };
-static void __init legacy_pic_int_noop(int unused) { };
+static void legacy_pic_noop(void) { };
+static void legacy_pic_uint_noop(unsigned int unused) { };
+static void legacy_pic_int_noop(int unused) { };
 
 static struct irq_chip dummy_pic_chip  = {
 	.name = "dummy pic",

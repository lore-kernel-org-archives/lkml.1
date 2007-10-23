Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbXJWWgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbXJWWgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXJWWgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:35 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58460 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXJWWge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:34 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, tglx@linutronix.de
Message-Id: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 1/12] X86: fix !CONFIG_SMP warning in processor.c
Date: Tue, 23 Oct 2007 18:36:33 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix !CONFIG_SMP warning:

arch/x86/kernel/acpi/processor.c: In function ‘arch_acpi_processor_init_pdc’:
arch/x86/kernel/acpi/processor.c:65: warning: unused variable ‘cpu’

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Ideally this warning should be hidden inside a wrapper or somesuch, to
camouflage the unneeded argument in !SMP case.

diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
index 2ed0a4c..45e262a 100644
--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -62,7 +62,9 @@ static void init_intel_pdc(struct acpi_processor *pr, struct cpuinfo_x86 *c)
 /* Initialize _PDC data based on the CPU vendor */
 void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 {
+#ifdef CONFIG_SMP
 	unsigned int cpu = pr->id;
+#endif
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	pr->pdc = NULL;

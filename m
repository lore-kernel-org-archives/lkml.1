Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZCVTlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZCVTlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZCVTkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:40:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:40817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbZCVTka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:40:30 -0400
Date: Sun, 22 Mar 2009 19:39:46 GMT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dmitri.vorobiev@movial.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dmitri.vorobiev@movial.com, mingo@elte.hu
In-Reply-To: <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
Subject: [tip:x86/cleanups] x86: Fix a couple of sparse warnings in arch/x86/kernel/apic/io_apic.c
Message-ID: <tip-1cc185211a9cb913f6adbe3354e5c256f456ebd2@git.kernel.org>
Git-Commit-ID: 1cc185211a9cb913f6adbe3354e5c256f456ebd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:39:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cc185211a9cb913f6adbe3354e5c256f456ebd2
Gitweb:     http://git.kernel.org/tip/1cc185211a9cb913f6adbe3354e5c256f456ebd2
Author:     Dmitri Vorobiev <dmitri.vorobiev@movial.com>
AuthorDate: Sun, 22 Mar 2009 19:11:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:15:14 +0100

x86: Fix a couple of sparse warnings in arch/x86/kernel/apic/io_apic.c

Impact: cleanup

This patch fixes the following sparse warnings:

 arch/x86/kernel/apic/io_apic.c:3602:17: warning: symbol 'hpet_msi_type'
 was not declared. Should it be static?

 arch/x86/kernel/apic/io_apic.c:3467:30: warning: Using plain integer as
 NULL pointer

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
LKML-Reference: <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 42cdc78..ea97e5e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3464,7 +3464,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int ret, sub_handle;
 	struct msi_desc *msidesc;
 	unsigned int irq_want;
-	struct intel_iommu *iommu = 0;
+	struct intel_iommu *iommu = NULL;
 	int index = 0;
 
 	irq_want = nr_irqs_gsi;
@@ -3599,7 +3599,7 @@ static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 #endif /* CONFIG_SMP */
 
-struct irq_chip hpet_msi_type = {
+static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.unmask = hpet_msi_unmask,
 	.mask = hpet_msi_mask,

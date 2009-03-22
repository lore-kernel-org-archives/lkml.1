Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZCVRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZCVRLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZCVRLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:11:24 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:53869 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZCVRLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:11:23 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/3] Fix a couple of sparse warnings in arch/x86/kernel/apic/io_apic.c
Date: Sun, 22 Mar 2009 19:11:09 +0200
Message-Id: <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup.

This patch fixes the following sparse warnings:

arch/x86/kernel/apic/io_apic.c:3602:17: warning: symbol 'hpet_msi_type'
was not declared. Should it be static?

arch/x86/kernel/apic/io_apic.c:3467:30: warning: Using plain integer as
NULL pointer

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d882c03..86827d8 100644
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
-- 
1.5.6.3


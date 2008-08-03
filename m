Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYHCDEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYHCDEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYHCDAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:28702 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYHCDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tA2iAac5htdtpBwDFtDkeGs7lCeoQaGY/Q2xYCtufySenrBXmul1RH/dEcIG9Qt4TO
         PeSNeMkzl+rESK0b85aAd875WxQMOcTkjWkMo1hxwTyGRaJ4J5lX8hX7UlS8p/TNPvZW
         BkbReR/14OwqIT3Kys47NWJVtDZpKifrB55kA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 11/25] drivers intr remapping to use nr_irqs
Date: Sat,  2 Aug 2008 19:59:11 -0700
Message-Id: <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/intr_remapping.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index bb642cc..980566e 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -22,7 +22,7 @@ static DEFINE_SPINLOCK(irq_2_ir_lock);
 
 int irq_remapped(int irq)
 {
-	if (irq > NR_IRQS)
+	if (irq > nr_irqs)
 		return 0;
 
 	if (!irq_2_iommu[irq].iommu)
@@ -35,7 +35,7 @@ int get_irte(int irq, struct irte *entry)
 {
 	int index;
 
-	if (!entry || irq > NR_IRQS)
+	if (!entry || irq > nr_irqs)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
@@ -126,7 +126,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	int index;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -140,7 +140,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -158,7 +158,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -180,7 +180,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -205,7 +205,7 @@ int flush_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -248,7 +248,7 @@ int free_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
-- 
1.5.4.5


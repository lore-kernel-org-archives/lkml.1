Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYHAJjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYHAJjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYHAJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYHAJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eoeWur/8haxvkUjM6wU0E1Vv3/qT5lO0buKuGrV/pm+oaCSGZkpMBpIrUwuwrBFu1v
         KU1ErFBLz3gnkaKxcv2up77sVvNs+85UE2dMRUQK7YtkTQX+QJYwMn3MUHIbvc4MK7DE
         rBe+Lt0GsKNBoJATwDsUNc7QlE1M+MdQevvZM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 05/16] make irq2_iommu to use dyn_array
Date: Fri,  1 Aug 2008 02:37:33 -0700
Message-Id: <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/intr_remapping.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -11,12 +11,14 @@ static struct ioapic_scope ir_ioapic[MAX
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
-static struct {
+static struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
 	u16 sub_handle;
 	u8  irte_mask;
-} irq_2_iommu[NR_IRQS];
+} *irq_2_iommu;
+
+DEFINE_DYN_ARRAY(irq_2_iommu, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 

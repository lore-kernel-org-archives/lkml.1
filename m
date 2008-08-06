Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbYHFIwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbYHFIwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbYHFIpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763572AbYHFIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QpVWioEXN8aCgn6GHMCnkPv4kqQ3T3kc0//QLtqbfgkL7gBC4PlhL9mS/ELjhb44wN
         X84mz7DYx7aooQMWZvYCw2l2av420G9EhuVZZ2xm2EBDN2FUY/yb+V3Dp0EtfXIXG0EJ
         Mc1sq3lC4ZCRWnI0UFF4CVseEWvRu8F1zpyMs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 19/33] make irq2_iommu to use dyn_array
Date: Wed,  6 Aug 2008 01:43:01 -0700
Message-Id: <1218012195-10429-20-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-14-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-15-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-16-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-17-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/intr_remapping.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 980566e..ced5ebc 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -11,12 +11,14 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
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
 
-- 
1.5.4.5


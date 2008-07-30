Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYG3VKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYG3VKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYG3VJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:09:41 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:3175 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbYG3VJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=k8Dm/XgWYpYWAHcL0p+unMpOTU30W//OGvl9D+J/sw9BB/wXDKxyjVhnYRVwqpgs7D
         27x/EbsrCKA+ndS+uLbBqPVpiaO2bD08Z0IDKA2kAVNazTiK+5UzR/sF6Rr3yePppIF6
         P2tVAK8HG/LS0P09iorluh/aHiShp8CZIYQjo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org
Subject: [PATCH 5/7] pci: make irq2_iommu to use dyn_array
Date: Wed, 30 Jul 2008 12:16:48 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com>
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301216.49350.yhlu.kernel@gmail.com>
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
 

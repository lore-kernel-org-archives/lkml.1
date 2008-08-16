Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYHPKJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYHPKJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYHPKI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYHPKIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LTFTJhzvEKuOYkCojzCAjbe8t2nQjVYt6Ed1lxrKPThl3fAaVePAWA/N+UL2fF2CzL
         MDOSFYCa5Wl496ez9dh5TjCwZJMqKh7p2LTvGTUhFm6auW8sojaO5RobH54eyN9LQsG+
         FHJicH+rdwRNf+8TOSVMcEEavPhBRT/TrxTDs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/5] pci: change msi-x vector to 32bit
Date: Sat, 16 Aug 2008 03:07:26 -0700
Message-Id: <1218881249-3028-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218881249-3028-2-git-send-email-yhlu.kernel@gmail.com>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/intr_remapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -99,7 +99,7 @@ static struct irq_2_iommu irq_2_iommuX[N
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
-	if (irq <= nr_irqs)
+	if (irq < nr_irqs)
 		return &irq_2_iommuX[irq];
 
 	return NULL;

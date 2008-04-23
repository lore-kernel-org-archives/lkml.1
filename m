Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYDWVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYDWVIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYDWVIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:08:06 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:58432 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYDWVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:08:05 -0400
Message-ID: <480FA529.2030800@tiscali.nl>
Date: Wed, 23 Apr 2008 23:07:53 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hnguyen@de.ibm.com, raisch@de.ibm.com
CC: general@lists.openfabrics.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ehca: ret is unsigned, ibmebus_request_irq() negative return
 ignored in hca_create_eq()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index b4ac617..9727235 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -59,6 +59,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 	u32 i;
 	void *vpage;
 	struct ib_device *ib_dev = &shca->ib_device;
+	int ret2;
 
 	spin_lock_init(&eq->spinlock);
 	spin_lock_init(&eq->irq_spinlock);
@@ -123,18 +124,18 @@ int ehca_create_eq(struct ehca_shca *shca,
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
+		ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
-		if (ret < 0)
+		if (ret2 < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
+		ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
-		if (ret < 0)
+		if (ret2 < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);

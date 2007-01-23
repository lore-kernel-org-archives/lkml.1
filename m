Return-Path: <linux-kernel-owner+w=401wt.eu-S965433AbXAWXQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433AbXAWXQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXAWXQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:16:14 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:25717 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965433AbXAWXQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:16:13 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org
Subject: [PATCH 2.6.21 2/4] ehca: fix mismatched use of spin_unlock in irq handler
Date: Wed, 24 Jan 2007 00:12:30 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240012.31621.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch for ehca_irq.c that fixes mismatched use of spin_unlock
in irq handler.
Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_irq.c	2007-01-19 19:40:32.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_irq.c	2007-01-23 22:38:02.000000000 +0100
@@ -440,7 +440,8 @@ void ehca_tasklet_eq(unsigned long data)
 					cq = idr_find(&ehca_cq_idr, token);
 
 					if (cq == NULL) {
-						spin_unlock(&ehca_cq_idr_lock);
+						spin_unlock_irqrestore(&ehca_cq_idr_lock,
+								       flags);
 						break;
 					}
 

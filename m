Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZDUPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZDUPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZDUPQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:16:48 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54815 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZDUPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:16:48 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
Date: Tue, 21 Apr 2009 17:16:44 +0200
User-Agent: KMail/1.9.9
Cc: fenkes@de.ibm.com, raisch@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@de.ibm.com, hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <antonb at au1.ibm.com>

To improve performance of driver ressource allocation,
replace the vmalloc() call with kmalloc().

Signed-off-by: Stefan Roscher <stefan.roscher at de.ibm.com>
---
 drivers/infiniband/hw/ehca/ipz_pt_fn.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index c3a3284..a260559 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -220,7 +220,7 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
 	queue->small_page = NULL;
 
 	/* allocate queue page pointers */
-	queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
+	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
 	if (!queue->queue_pages) {
 		ehca_gen_err("Couldn't allocate queue page list");
 		return 0;
@@ -240,7 +240,7 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
 ipz_queue_ctor_exit0:
 	ehca_gen_err("Couldn't alloc pages queue=%p "
 		 "nr_of_pages=%x",  queue, nr_of_pages);
-	vfree(queue->queue_pages);
+	kfree(queue->queue_pages);
 
 	return 0;
 }
@@ -262,7 +262,7 @@ int ipz_queue_dtor(struct ehca_pd *pd, struct ipz_queue *queue)
 			free_page((unsigned long)queue->queue_pages[i]);
 	}
 
-	vfree(queue->queue_pages);
+	kfree(queue->queue_pages);
 
 	return 1;
 }
-- 
1.5.5


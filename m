Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKUNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKUNu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYKUNuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:50:14 -0500
Received: from ozlabs.org ([203.10.76.45]:36388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYKUNuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:50:13 -0500
To: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 22 Nov 2008 00:20:07 +1030
Subject: [PATCH 1/3] cpumask: use for_each_online_cpu() in drivers/infiniband/hw/ehca/ehca_irq.c
Cc: linux-kernel@vger.kernel.org, Christoph Raisch <raisch@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811220020.07407.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In future, accessing cpu numbers beyond nr_cpu_ids (the runtime limit)
will be undefined.  We can avoid future problems by using
for_each_online_cpu() here.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -r 38b459d1e9c7 drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c	Fri Nov 07 22:33:08 2008 +1100
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c	Fri Nov 07 22:48:13 2008 +1100
@@ -922,10 +922,9 @@ void ehca_destroy_comp_pool(void)
 
 	unregister_hotcpu_notifier(&comp_pool_callback_nb);
 
-	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_online(i))
-			destroy_comp_task(pool, i);
-	}
+	for_each_online_cpu(i)
+		destroy_comp_task(pool, i);
+
 	free_percpu(pool->cpu_comp_tasks);
 	kfree(pool);
 }



Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbZFLNHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbZFLNHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764617AbZFLNEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:04:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761362AbZFLNEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:04:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] cpumask: use new-style cpumask ops in mm/quicklist.
Date: Fri, 12 Jun 2009 22:34:40 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122234.40860.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This slipped past the previous sweeps.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
---
 mm/quicklist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/quicklist.c b/mm/quicklist.c
--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -29,7 +29,6 @@ static unsigned long max_pages(unsigned 
 	int node = numa_node_id();
 	struct zone *zones = NODE_DATA(node)->node_zones;
 	int num_cpus_on_node;
-	const struct cpumask *cpumask_on_node = cpumask_of_node(node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
@@ -42,7 +41,7 @@ static unsigned long max_pages(unsigned 
 
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 
-	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
+	num_cpus_on_node = cpumask_weight(cpumask_of_node(node));
 	max /= num_cpus_on_node;
 
 	return max(max, min_pages);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYCZNG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYCZNG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYCZNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:06:50 -0400
Received: from usea-naimss3.unisys.com ([192.61.61.105]:3402 "EHLO
	usea-naimss3.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYCZNGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:06:49 -0400
Subject: [PATCH] CPUs on memoryless nodes not being reassigned
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Mar 2008 08:44:28 -0400
Message-Id: <1206535469.7468.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
X-OriginalArrivalTime: 26 Mar 2008 13:02:59.0748 (UTC) FILETIME=[B7B02640:01C88F41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot with memoryless nodes on the latest 2.6.25-rc kernels, the
CPUs aren't being reassigned to nodes with memory.  

Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

---
diff -Nuar linux-2.6.25-rc6/arch/x86/kernel/setup_64.c linux-2.6.25-rc6-new/arch/x86/kernel/setup_64.c
--- linux-2.6.25-rc6/arch/x86/kernel/setup_64.c	2008-03-16 19:32:14.000000000 -0400
+++ linux-2.6.25-rc6-new/arch/x86/kernel/setup_64.c	2008-03-25 09:52:15.000000000 -0400
@@ -801,7 +801,7 @@
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE)
+	if (node == NUMA_NO_NODE || !node_online(node))
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 


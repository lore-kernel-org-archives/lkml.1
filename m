Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbXHVCQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbXHVCQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXHVCQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:16:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:15745 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbXHVCQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:16:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,291,1183359600"; 
   d="scan'208";a="286157209"
Subject: [PATCH] get_nodes should ignore invalid node
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com
Content-Type: text/plain
Date: Wed, 22 Aug 2007 10:07:14 +0800
Message-Id: <1187748434.8474.20.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

get_nodes doesn't check if nodes in node mask are valid, cause a kernel
oops when an invalid node is used..

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/mm/mempolicy.c
===================================================================
--- linux.orig/mm/mempolicy.c	2007-07-25 09:14:33.000000000 +0800
+++ linux/mm/mempolicy.c	2007-08-21 13:15:41.000000000 +0800
@@ -850,6 +850,8 @@ static int get_nodes(nodemask_t *nodes, 
 	if (copy_from_user(nodes_addr(*nodes), nmask, nlongs*sizeof(unsigned long)))
 		return -EFAULT;
 	nodes_addr(*nodes)[nlongs-1] &= endmask;
+
+	nodes_and(*nodes, *nodes, node_online_map);
 	return 0;
 }
 

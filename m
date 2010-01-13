Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617Ab0AMBCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0AMBCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485Ab0AMBA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:60368 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0AMBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:55 -0500
Message-Id: <20100113004938.715904356@suse.com>
User-Agent: quilt/0.48-4.4
Date: Tue, 12 Jan 2010 19:48:57 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>
Subject: [patch 2/6] hugetlb: Fix section mismatches
References: <20100113004855.550486769@suse.com>
Content-Disposition: inline; filename=patches.rpmify/hugetlbfs-fix-section-mismatches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
 __init. Since hugetlb_register_node is only called by
 hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
 it's safe to mark both of them as __init.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1630,7 +1630,7 @@ void hugetlb_unregister_node(struct node
  * hugetlb module exit:  unregister hstate attributes from node sysdevs
  * that have them.
  */
-static void hugetlb_unregister_all_nodes(void)
+static void __init hugetlb_unregister_all_nodes(void)
 {
 	int nid;
 
@@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node sysdev.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+void __init hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->sysdev.id];



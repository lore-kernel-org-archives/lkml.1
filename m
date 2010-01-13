Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798Ab0AMPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0AMPET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711Ab0AMPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:04:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:55116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab0AMPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:04:16 -0500
Message-ID: <4B4DE0C1.7080709@suse.com>
Date: Wed, 13 Jan 2010 10:03:29 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch] hugetlb: Fix section mismatches #2
References: <20100113004855.550486769@suse.com> <20100113004938.715904356@suse.com> <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
@@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node sysdev.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+void __init hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
@@ -1683,7 +1683,7 @@ void hugetlb_register_node(struct node *
  * sysdevs of nodes that have memory.  All on-line nodes should have
  * registered their associated sysdev by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
-- 
Jeff Mahoney
SUSE Labs

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZKBVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZKBVum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZKBVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:50:41 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:15136 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZKBVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:50:41 -0500
Subject: [PATCH] hugetlb: offload per node attribute registrations fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <4AEE56A1.6010100@oracle.com>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	 <4AEE56A1.6010100@oracle.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 02 Nov 2009 16:50:15 -0500
Message-Id: <1257198615.7401.212.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Against:  2.6.32-rc5-mmotm-091101-1001

Fix build failure when MEMORY_HOTPLUG_SPARSE and !HUGETLBFS:

drivers/base/node.c:484: error: implicit declaration of function 'init_node_hugetlb_work'
drivers/base/node.c:582: error: 'node_memory_callback' undeclared (first use in this function)

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 drivers/base/node.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.32-rc5-mmotm-091101-1001/drivers/base/node.c
===================================================================
--- linux-2.6.32-rc5-mmotm-091101-1001.orig/drivers/base/node.c	2009-11-02 15:51:43.000000000 -0500
+++ linux-2.6.32-rc5-mmotm-091101-1001/drivers/base/node.c	2009-11-02 16:41:36.000000000 -0500
@@ -445,8 +445,12 @@ static int node_memory_callback(struct n
 }
 #endif	/* CONFIG_HUGETLBFS */
 #else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
+
 static int link_mem_sections(int nid) { return 0; }
+#endif	/* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+#if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
+    !defined(CONFIG_HUGETLBFS)
 static inline int node_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
@@ -455,7 +459,7 @@ static inline int node_memory_callback(s
 
 static void init_node_hugetlb_work(int nid) { }
 
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+#endif
 
 int register_one_node(int nid)
 {



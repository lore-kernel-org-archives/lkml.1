Return-Path: <linux-kernel-owner+w=401wt.eu-S965151AbXHaLXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151AbXHaLXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964911AbXHaLVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:21:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43362 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbXHaLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:21:00 -0400
Message-Id: <20070831112615.093123000@bull.net>
References: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:50 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 5/6] Introducing the ipcid_to_idx macro
Content-Disposition: inline; filename=ipcid_to_idx.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 05/06]


This is a trivial patch that changes all the (id % SEQ_MULTIPLIER) into a call
to the ipcid_to_idx(id) macro.
     
     
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |    4 ++--
 ipc/util.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc2/ipc/util.h
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.h	2007-08-31 12:26:31.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.h	2007-08-31 12:53:30.000000000 +0200
@@ -78,6 +78,8 @@ void __init ipc_init_proc_interface(cons
 #define IPC_MSG_IDS	1
 #define IPC_SHM_IDS	2
 
+#define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+
 /* must be called with ids->mutex acquired.*/
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 int ipc_get_maxid(struct ipc_ids *);
Index: linux-2.6.23-rc2/ipc/util.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.c	2007-08-31 12:29:32.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.c	2007-08-31 12:54:39.000000000 +0200
@@ -413,7 +413,7 @@ int ipcget_public(struct ipc_namespace *
  
 void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
-	int lid = ipcp->id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(ipcp->id);
 
 	idr_remove(&ids->ipcs_idr, lid);
 
@@ -672,7 +672,7 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
-	int lid = id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
 	out = idr_find(&ids->ipcs_idr, lid);

--

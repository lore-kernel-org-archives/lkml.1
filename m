Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbXHaLWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbXHaLWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964902AbXHaLVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:21:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43408 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbXHaLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:21:00 -0400
Message-Id: <20070831112615.480609000@bull.net>
References: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:51 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 6/6] Inlining ipc_buildid()
Content-Disposition: inline; filename=ipc_buildid.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 06/06]


This is a trivial patch that changes the ipc_buildid() routine into a static
inline.
     
     
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |    5 -----
 ipc/util.h |    6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc2/ipc/util.h
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.h	2007-08-31 12:53:30.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.h	2007-08-31 12:58:14.000000000 +0200
@@ -106,7 +106,6 @@ void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
-int ipc_buildid(struct ipc_ids* ids, int id, int seq);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -126,6 +125,11 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
+static inline int ipc_buildid(struct ipc_ids *ids, int id, int seq)
+{
+	return SEQ_MULTIPLIER * seq + id;
+}
+
 static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
 				int uid)
 {
Index: linux-2.6.23-rc2/ipc/util.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.c	2007-08-31 12:54:39.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.c	2007-08-31 12:58:40.000000000 +0200
@@ -695,11 +695,6 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	return out;
 }
 
-int ipc_buildid(struct ipc_ids* ids, int id, int seq)
-{
-	return SEQ_MULTIPLIER*seq + id;
-}
-
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 

--

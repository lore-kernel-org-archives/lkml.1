Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXGMBls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXGMBls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 21:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXGMBlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 21:41:39 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:36198 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXGMBli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 21:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=htcpEVu2ZuxFa4WATsl9Vy5QtgOlfZnhV1O4fwtKNF7rvqt3GiulIzOUYZY1qPEX41OkgxT3rhysGERTn1WPYX0AwKaagfQ/eyqWyY/Y18CiO0THFNpT/VJnvZr1Y2kG6XWnKAj7VluRpcLyF/1rwqhBfJeO0NBFBdoM9bMNKzc=
Subject: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to remove
	some following zero initializations.
From: Denis Cheng <crquan@gmail.com>
To: trivial@kernel.org, Denis <cr_quan@163.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: UIT
Date: Fri, 13 Jul 2007 09:41:45 +0800
Message-Id: <1184290905.5475.5.camel@tux.homenetwork>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d87e14b67890f06885a76b5792ca034de2e9d06 Mon Sep 17 00:00:00 2001
From: Denis Cheng <crquan@gmail.com>
Date: Thu, 12 Jul 2007 11:53:58 +0800
Subject: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to
remove some following zero initializations.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/dcache.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 0e73aa0..8c559b2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -898,7 +898,7 @@ struct dentry *d_alloc(struct dentry * parent, const
struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL); 
+	dentry = kmem_cache_zalloc(dentry_cache, GFP_KERNEL); 
 	if (!dentry)
 		return NULL;
 
@@ -921,15 +921,7 @@ struct dentry *d_alloc(struct dentry * parent,
const struct qstr *name)
 	atomic_set(&dentry->d_count, 1);
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
-	dentry->d_inode = NULL;
-	dentry->d_parent = NULL;
-	dentry->d_sb = NULL;
-	dentry->d_op = NULL;
-	dentry->d_fsdata = NULL;
-	dentry->d_mounted = 0;
-#ifdef CONFIG_PROFILING
-	dentry->d_cookie = NULL;
-#endif
+
 	INIT_HLIST_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-- 
1.5.2.2




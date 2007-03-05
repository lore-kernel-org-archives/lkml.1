Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXCEB4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXCEB4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXCEBzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:42 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38378 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXCEBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:24 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 06/13] fs/unionfs/: Remove alloc_filldir_node
Date: Sun,  4 Mar 2007 20:54:56 -0500
Message-Id: <11730597042034-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_filldir_node was used only once. Additionally, all the arguments
passed to it were ignored wasting stack space for no reason whatsoever.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/rdstate.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index e240285..b67a86a 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -225,12 +225,6 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 	return cursor;
 }
 
-static struct filldir_node *alloc_filldir_node(const char *name, int namelen,
-					       unsigned int hash, int bindex)
-{
-	return kmem_cache_alloc(unionfs_filldir_cachep, GFP_KERNEL);
-}
-
 int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 		     int namelen, int bindex, int whiteout)
 {
@@ -246,7 +240,7 @@ int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 	index = hash % rdstate->size;
 	head = &(rdstate->list[index]);
 
-	new = alloc_filldir_node(name, namelen, hash, bindex);
+	new = kmem_cache_alloc(unionfs_filldir_cachep, GFP_KERNEL);
 	if (!new) {
 		err = -ENOMEM;
 		goto out;
-- 
1.5.0.2.260.g2eb065


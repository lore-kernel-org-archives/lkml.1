Return-Path: <linux-kernel-owner+w=401wt.eu-S1761880AbXGaNL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761880AbXGaNL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761792AbXGaNJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:58 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761766AbXGaNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:56 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125448.190135000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:32 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, David Kleikamp <shaggy@austin.ibm.com>
Subject: [Patch 16/16] Remove unnecessary kmalloc casts in the jfs filesystem.
Content-Disposition: inline; filename=fs_jfs_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: David Kleikamp <shaggy@austin.ibm.com>

---
 fs/jfs/jfs_dtree.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: b/fs/jfs/jfs_dtree.c
===================================================================
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -592,9 +592,7 @@ int dtSearch(struct inode *ip, struct co
 	struct component_name ciKey;
 	struct super_block *sb = ip->i_sb;
 
-	ciKey.name =
-	    (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
-				GFP_NOFS);
+	ciKey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t), GFP_NOFS);
 	if (ciKey.name == 0) {
 		rc = -ENOMEM;
 		goto dtSearch_Exit2;
@@ -957,9 +955,7 @@ static int dtSplitUp(tid_t tid,
 	smp = split->mp;
 	sp = DT_PAGE(ip, smp);
 
-	key.name =
-	    (wchar_t *) kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t),
-				GFP_NOFS);
+	key.name = kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t), GFP_NOFS);
 	if (key.name == 0) {
 		DT_PUTPAGE(smp);
 		rc = -ENOMEM;

-- 

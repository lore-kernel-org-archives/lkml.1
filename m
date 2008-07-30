Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbYG3Ctf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYG3Ctf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYG3Cox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46313 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYG3Coq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:46 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 09/19] Unionfs: free lower paths array when destroying dentry's private data
Date: Tue, 29 Jul 2008 22:43:39 -0400
Message-Id: <12173858383225-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 37adf66..b5f64c9 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -450,6 +450,8 @@ void free_dentry_private_data(struct dentry *dentry)
 {
 	if (!dentry || !dentry->d_fsdata)
 		return;
+	kfree(UNIONFS_D(dentry)->lower_paths);
+	UNIONFS_D(dentry)->lower_paths = NULL;
 	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
 	dentry->d_fsdata = NULL;
 }
-- 
1.5.2.2


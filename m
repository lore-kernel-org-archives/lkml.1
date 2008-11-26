Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYKZNnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYKZNnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYKZNnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:43:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:16271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbYKZNnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:43:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,668,1220252400"; 
   d="scan'208";a="83174749"
Date: Wed, 26 Nov 2008 21:42:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] 9p: convert d_iname references to d_name.name
Message-ID: <20081126134254.GA1573@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_iname is rubbish for long file names.
Use d_name.name in printks instead.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 3031e32..2a983d4 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -45,7 +45,7 @@ int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
 	struct v9fs_dentry *dent;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "fid %d dentry %s\n",
-					fid->fid, dentry->d_iname);
+					fid->fid, dentry->d_name.name);
 
 	dent = dentry->d_fsdata;
 	if (!dent) {
@@ -79,7 +79,7 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, u32 uid, int any)
 	struct p9_fid *fid, *ret;
 
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p) uid %d any %d\n",
-		dentry->d_iname, dentry, uid, any);
+		dentry->d_name.name, dentry, uid, any);
 	dent = (struct v9fs_dentry *) dentry->d_fsdata;
 	ret = NULL;
 	if (dent) {
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index f9534f1..9fcfbaf 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -52,7 +52,7 @@
 
 static int v9fs_dentry_delete(struct dentry *dentry)
 {
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	return 1;
 }
@@ -69,7 +69,7 @@ static int v9fs_dentry_delete(struct dentry *dentry)
 static int v9fs_cached_dentry_delete(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	if(!inode)
 		return 1;
@@ -88,7 +88,7 @@ void v9fs_dentry_release(struct dentry *dentry)
 	struct v9fs_dentry *dent;
 	struct p9_fid *temp, *current_fid;
 
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 	dent = dentry->d_fsdata;
 	if (dent) {
 		list_for_each_entry_safe(current_fid, temp, &dent->fidlist,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8314d3f..e7f6838 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -963,7 +963,7 @@ static int v9fs_vfs_readlink(struct dentry *dentry, char __user * buffer,
 	if (buflen > PATH_MAX)
 		buflen = PATH_MAX;
 
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	retval = v9fs_readlink(dentry, link, buflen);
 

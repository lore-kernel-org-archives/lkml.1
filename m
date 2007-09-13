Return-Path: <linux-kernel-owner+w=401wt.eu-S1765549AbXIMFNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765549AbXIMFNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXIMFM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:12:59 -0400
Received: from 70-56-219-218.albq.qwest.net ([70.56.219.218]:60781 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755214AbXIMFM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:12:56 -0400
Date: Wed, 12 Sep 2007 22:47:18 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       ericvh@gmail.com
Subject: [PATCH] 9p: rename uid and gid parameters
Message-ID: <20070913044718.GB2675@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the names of 'uid' and 'gid' parameters to the more appropriate
'dfltuid' and 'dfltgid'.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 13bf527796712619df072c0963e3f6c8c00189b8
tree 7211a2899dcfd58c76b901334a8726c7e60115e1
parent 52f23404fd5bd77b619460e00930087463ec0cd9
author Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:37:33 -0600
committer Latchesar Ionkov <lucho@eregion.(none)> Wed, 12 Sep 2007 22:37:33 -0600

 Documentation/filesystems/9p.txt |    4 ++--
 fs/9p/v9fs.c                     |   16 +++++++++-------
 fs/9p/v9fs.h                     |    6 ++++--
 fs/9p/vfs_inode.c                |    4 ++--
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index 1a5f50d..e694cd1 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -78,9 +78,9 @@ OPTIONS
 
   noextend	force legacy mode (no 9p2000.u semantics)
 
-  uid		attempt to mount as a particular uid
+  dfltuid	attempt to mount as a particular uid
 
-  gid		attempt to mount with a particular gid
+  dfltgid	attempt to mount with a particular gid
 
   afid		security channel - used by Plan 9 authentication protocols
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 8ac2467..68f82be 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -84,7 +84,7 @@ static struct p9_trans_module *v9fs_match_trans(const substring_t *name)
 
 enum {
 	/* Options that take integer arguments */
-	Opt_debug, Opt_msize, Opt_uid, Opt_gid, Opt_afid,
+	Opt_debug, Opt_msize, Opt_dfltuid, Opt_dfltgid, Opt_afid,
 	/* String options */
 	Opt_uname, Opt_remotename, Opt_trans,
 	/* Options that take no arguments */
@@ -98,8 +98,8 @@ enum {
 static match_table_t tokens = {
 	{Opt_debug, "debug=%x"},
 	{Opt_msize, "msize=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_gid, "gid=%u"},
+	{Opt_dfltuid, "dfltuid=%u"},
+	{Opt_dfltgid, "dfltgid=%u"},
 	{Opt_afid, "afid=%u"},
 	{Opt_uname, "uname=%s"},
 	{Opt_remotename, "aname=%s"},
@@ -159,11 +159,11 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 		case Opt_msize:
 			v9ses->maxdata = option;
 			break;
-		case Opt_uid:
-			v9ses->uid = option;
+		case Opt_dfltuid:
+			v9ses->dfltuid = option;
 			break;
-		case Opt_gid:
-			v9ses->gid = option;
+		case Opt_dfltgid:
+			v9ses->dfltgid = option;
 			break;
 		case Opt_afid:
 			v9ses->afid = option;
@@ -219,6 +219,8 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 
 	strcpy(v9ses->name, V9FS_DEFUSER);
 	strcpy(v9ses->remotename, V9FS_DEFANAME);
+	v9ses->dfltuid = V9FS_DEFUID;
+	v9ses->dfltgid = V9FS_DEFGID;
 
 	v9ses->options = kstrdup(data, GFP_KERNEL);
 	v9fs_parse_options(v9ses);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 804b3ef..5d0280a 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -38,8 +38,8 @@ struct v9fs_session_info {
 	char *options;		/* copy of mount options */
 	char *name;		/* user name to mount as */
 	char *remotename;	/* name of remote hierarchy being mounted */
-	unsigned int uid;	/* default uid/muid for legacy support */
-	unsigned int gid;	/* default gid for legacy support */
+	unsigned int dfltuid;	/* default uid/muid for legacy support */
+	unsigned int dfltgid;	/* default gid for legacy support */
 	struct p9_trans_module *trans; /* 9p transport */
 	struct p9_client *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
@@ -70,6 +70,8 @@ void v9fs_session_cancel(struct v9fs_session_info *v9ses);
 #define V9FS_PORT		564
 #define V9FS_DEFUSER	"nobody"
 #define V9FS_DEFANAME	""
+#define V9FS_DEFUID	(0)
+#define V9FS_DEFGID	(0)
 
 static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 {
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 2270d06..f08a35d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -805,8 +805,8 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 	inode->i_mtime.tv_sec = stat->mtime;
 	inode->i_ctime.tv_sec = stat->mtime;
 
-	inode->i_uid = v9ses->uid;
-	inode->i_gid = v9ses->gid;
+	inode->i_uid = v9ses->dfltuid;
+	inode->i_gid = v9ses->dfltgid;
 
 	if (v9fs_extended(v9ses)) {
 		inode->i_uid = stat->n_uid;

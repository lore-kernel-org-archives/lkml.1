Return-Path: <linux-kernel-owner+w=401wt.eu-S939117AbXG3QSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939117AbXG3QSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938498AbXG3QOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937641AbXG3QON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:13 -0400
Message-Id: <20070730161324.531727780@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:38 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 15/26] union-mount: Add union-mount mount flag
Content-Disposition: inline; filename=um/union-mount-mount_flag.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce MNT_UNION and MS_UNION flags. You need additional patches for
util-linux for that to work.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namespace.c        |    6 +++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -437,6 +437,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_NOMNT, ",nomnt" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -1558,9 +1559,12 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_NOMNT)
 		mnt_flags |= MNT_NOMNT;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT |
+		   MS_UNION );
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -114,6 +114,7 @@ extern int dir_notify_enable;
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -36,6 +36,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;

-- 


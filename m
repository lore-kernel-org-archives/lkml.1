Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbYHFPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbYHFPvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbYHFPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:38:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759343AbYHFPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/24] CRED: Change current->fs[ug]id to current_fs[ug]id()
	[ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:45 +0100
Message-ID: <20080806153744.14351.87085.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change current->fs[ug]id to current_fs[ug]id() so that fsgid and fsuid can be
separated from the task_struct.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 arch/ia64/kernel/perfmon.c                |    4 ++--
 arch/powerpc/platforms/cell/spufs/inode.c |    4 ++--
 drivers/isdn/capi/capifs.c                |    4 ++--
 drivers/usb/core/inode.c                  |    4 ++--
 fs/9p/fid.c                               |    2 +-
 fs/9p/vfs_inode.c                         |    4 ++--
 fs/9p/vfs_super.c                         |    4 ++--
 fs/affs/inode.c                           |    4 ++--
 fs/anon_inodes.c                          |    4 ++--
 fs/attr.c                                 |    4 ++--
 fs/bfs/dir.c                              |    4 ++--
 fs/cifs/cifsproto.h                       |    2 +-
 fs/cifs/dir.c                             |   12 ++++++------
 fs/cifs/inode.c                           |    8 ++++----
 fs/cifs/misc.c                            |    4 ++--
 fs/coda/cache.c                           |    6 +++---
 fs/coda/upcall.c                          |    2 +-
 fs/devpts/inode.c                         |    4 ++--
 fs/dquot.c                                |    2 +-
 fs/exec.c                                 |    4 ++--
 fs/ext2/balloc.c                          |    2 +-
 fs/ext2/ialloc.c                          |    4 ++--
 fs/ext3/balloc.c                          |    2 +-
 fs/ext3/ialloc.c                          |    4 ++--
 fs/ext4/balloc.c                          |    3 +--
 fs/ext4/ialloc.c                          |    4 ++--
 fs/fat/file.c                             |    2 +-
 fs/fuse/dev.c                             |    4 ++--
 fs/gfs2/inode.c                           |   10 +++++-----
 fs/hfs/inode.c                            |    4 ++--
 fs/hfsplus/inode.c                        |    4 ++--
 fs/hpfs/namei.c                           |   24 ++++++++++++------------
 fs/hugetlbfs/inode.c                      |   16 ++++++++--------
 fs/jffs2/fs.c                             |    4 ++--
 fs/jfs/jfs_inode.c                        |    4 ++--
 fs/locks.c                                |    2 +-
 fs/minix/bitmap.c                         |    4 ++--
 fs/namei.c                                |   10 ++++++----
 fs/nfsd/vfs.c                             |    6 +++---
 fs/ocfs2/dlm/dlmfs.c                      |    8 ++++----
 fs/ocfs2/namei.c                          |    4 ++--
 fs/omfs/inode.c                           |    4 ++--
 fs/pipe.c                                 |    4 ++--
 fs/posix_acl.c                            |    4 ++--
 fs/ramfs/inode.c                          |    4 ++--
 fs/reiserfs/namei.c                       |    4 ++--
 fs/sysv/ialloc.c                          |    4 ++--
 fs/ubifs/budget.c                         |    2 +-
 fs/ubifs/dir.c                            |    4 ++--
 fs/udf/ialloc.c                           |    4 ++--
 fs/udf/namei.c                            |    2 +-
 fs/ufs/ialloc.c                           |    4 ++--
 fs/xfs/linux-2.6/xfs_linux.h              |    4 ++--
 fs/xfs/xfs_acl.c                          |    6 +++---
 fs/xfs/xfs_inode.c                        |    4 ++--
 fs/xfs/xfs_vnodeops.c                     |    8 ++++----
 include/linux/cred.h                      |   25 +++++++++++++++++++++++++
 include/linux/fs.h                        |    2 +-
 include/linux/sched.h                     |    1 +
 ipc/mqueue.c                              |    4 ++--
 kernel/cgroup.c                           |    4 ++--
 mm/shmem.c                                |    8 ++++----
 net/9p/client.c                           |    2 +-
 net/socket.c                              |    4 ++--
 net/sunrpc/auth.c                         |    4 ++--
 security/commoncap.c                      |    4 ++--
 security/keys/key.c                       |    2 +-
 security/keys/keyctl.c                    |    2 +-
 security/keys/request_key.c               |   10 +++++-----
 security/keys/request_key_auth.c          |    2 +-
 70 files changed, 187 insertions(+), 160 deletions(-)
 create mode 100644 include/linux/cred.h


diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index fc8f350..0cd24b2 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2224,8 +2224,8 @@ pfm_alloc_file(pfm_context_t *ctx)
 	DPRINT(("new inode ino=%ld @%p\n", inode->i_ino, inode));
 
 	inode->i_mode = S_IFCHR|S_IRUGO;
-	inode->i_uid  = current->fsuid;
-	inode->i_gid  = current->fsgid;
+	inode->i_uid  = current_fsuid();
+	inode->i_gid  = current_fsgid();
 
 	sprintf(name, "[%lu]", inode->i_ino);
 	this.name = name;
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 690ca7b..60bd5ed 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -95,8 +95,8 @@ spufs_new_inode(struct super_block *sb, int mode)
 		goto out;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_blocks = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 out:
diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 550e80f..0aa66ec 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -156,8 +156,8 @@ void capifs_new_ncci(unsigned int number, dev_t device)
 	if (!inode)
 		return;
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	inode->i_uid = config.setuid ? config.uid : current_fsuid();
+	inode->i_gid = config.setgid ? config.gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	//inode->i_op = &capifs_file_inode_operations;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index db410e9..0f82019 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -275,8 +275,8 @@ static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t de
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 3031e32..a43e4ab 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -120,7 +120,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	switch (access) {
 	case V9FS_ACCESS_SINGLE:
 	case V9FS_ACCESS_USER:
-		uid = current->fsuid;
+		uid = current_fsuid();
 		any = 0;
 		break;
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c95295c..517dd27 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -215,8 +215,8 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_rdev = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index bf59c39..f59ffcd 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -113,8 +113,8 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct v9fs_session_info *v9ses = NULL;
 	struct p9_stat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current_fsuid();
+	gid_t gid = current_fsgid();
 	struct p9_fid *fid;
 	int retval = 0;
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index a13b334..415d9c6 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -293,8 +293,8 @@ affs_new_inode(struct inode *dir)
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 
-	inode->i_uid     = current->fsuid;
-	inode->i_gid     = current->fsgid;
+	inode->i_uid     = current_fsuid();
+	inode->i_gid     = current_fsgid();
 	inode->i_ino     = block;
 	inode->i_nlink   = 1;
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 3662dd4..c16d9be 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -154,8 +154,8 @@ static struct inode *anon_inode_mkinode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	return inode;
 }
diff --git a/fs/attr.c b/fs/attr.c
index 26c71ba..faa433a 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -29,13 +29,13 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid() != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current->fsuid != inode->i_uid ||
+	    (current_fsuid() != inode->i_uid ||
 	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 87ee5cc..e892a71 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -105,8 +105,8 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	}
 	set_bit(ino, info->si_imap);
 	info->si_freei--;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
 	inode->i_op = &bfs_file_inops;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b9f5e93..8efbe47 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -39,7 +39,7 @@ extern int smb_send(struct socket *, struct smb_hdr *,
 			unsigned int /* length */ , struct sockaddr *);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current->fsuid));
+#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current_fsuid()));
 #define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fb69c1f..a2d4a2b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -228,8 +228,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		if ((pTcon->unix_ext) && (oplock & CIFS_CREATE_ACTION)) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path, mode,
-					(__u64)current->fsuid,
-					(__u64)current->fsgid,
+					(__u64)current_fsuid(),
+					(__u64)current_fsgid(),
 					0 /* dev */,
 					cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
@@ -266,8 +266,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 				if ((oplock & CIFS_CREATE_ACTION) &&
 				    (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID)) {
-					newinode->i_uid = current->fsuid;
-					newinode->i_gid = current->fsgid;
+					newinode->i_uid = current_fsuid();
+					newinode->i_gid = current_fsgid();
 				}
 			}
 		}
@@ -360,8 +360,8 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 		mode &= ~current->fs->umask;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			rc = CIFSSMBUnixSetPerms(xid, pTcon, full_path,
-				mode, (__u64)current->fsuid,
-				(__u64)current->fsgid,
+				mode, (__u64)current_fsuid(),
+				(__u64)current_fsgid(),
 				device_number, cifs_sb->local_nls,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 46e54d3..4857f15 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -989,8 +989,8 @@ mkdir_get_info:
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
 						    mode,
-						    (__u64)current->fsuid,
-						    (__u64)current->fsgid,
+						    (__u64)current_fsuid(),
+						    (__u64)current_fsgid(),
 						    0 /* dev_t */,
 						    cifs_sb->local_nls,
 						    cifs_sb->mnt_cifs_flags &
@@ -1023,9 +1023,9 @@ mkdir_get_info:
 				if (cifs_sb->mnt_cifs_flags &
 				     CIFS_MOUNT_SET_UID) {
 					direntry->d_inode->i_uid =
-						current->fsuid;
+						current_fsuid();
 					direntry->d_inode->i_gid =
-						current->fsgid;
+						current_fsgid();
 				}
 			}
 		}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4b17f8f..99f939e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -351,13 +351,13 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		/*  BB Add support for establishing new tCon and SMB Session  */
 		/*      with userid/password pairs found on the smb session   */
 		/*	for other target tcp/ip addresses 		BB    */
-				if (current->fsuid != treeCon->ses->linux_uid) {
+				if (current_fsuid() != treeCon->ses->linux_uid) {
 					cFYI(1, ("Multiuser mode and UID "
 						 "did not match tcon uid"));
 					read_lock(&GlobalSMBSeslock);
 					list_for_each(temp_item, &GlobalSMBSessionList) {
 						ses = list_entry(temp_item, struct cifsSesInfo, cifsSessionList);
-						if (ses->linux_uid == current->fsuid) {
+						if (ses->linux_uid == current_fsuid()) {
 							if (ses->server == treeCon->ses->server) {
 								cFYI(1, ("found matching uid substitute right smb_uid"));
 								buffer->Uid = ses->Suid;
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 8a23703..a5bf577 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -32,8 +32,8 @@ void coda_cache_enter(struct inode *inode, int mask)
 	struct coda_inode_info *cii = ITOC(inode);
 
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
-	if (cii->c_uid != current->fsuid) {
-                cii->c_uid = current->fsuid;
+	if (cii->c_uid != current_fsuid()) {
+		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
         } else
                 cii->c_cached_perm |= mask;
@@ -60,7 +60,7 @@ int coda_cache_check(struct inode *inode, int mask)
         int hit;
 	
         hit = (mask & cii->c_cached_perm) == mask &&
-		cii->c_uid == current->fsuid &&
+		cii->c_uid == current_fsuid() &&
 		cii->c_cached_epoch == atomic_read(&permission_epoch);
 
         return hit;
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index ce432bc..c274d94 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -52,7 +52,7 @@ static void *alloc_upcall(int opcode, int size)
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
 	inp->ih.pgid = task_pgrp_nr(current);
-	inp->ih.uid = current->fsuid;
+	inp->ih.uid = current_fsuid();
 
 	return (void*)inp;
 }
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 488eb42..7d3ad2d 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -228,8 +228,8 @@ int devpts_pty_new(struct tty_struct *tty)
 		return -ENOMEM;
 
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	inode->i_uid = config.setuid ? config.uid : current_fsuid();
+	inode->i_gid = config.setgid ? config.gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	inode->i_private = tty;
diff --git a/fs/dquot.c b/fs/dquot.c
index 8ec4d6c..7307324 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -876,7 +876,7 @@ static inline int need_print_warning(struct dquot *dquot)
 
 	switch (dquot->dq_type) {
 		case USRQUOTA:
-			return current->fsuid == dquot->dq_id;
+			return current_fsuid() == dquot->dq_id;
 		case GRPQUOTA:
 			return in_group_p(dquot->dq_id);
 	}
diff --git a/fs/exec.c b/fs/exec.c
index 32993be..3b3231b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1715,7 +1715,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct inode * inode;
 	struct file * file;
 	int retval = 0;
-	int fsuid = current->fsuid;
+	int fsuid = current_fsuid();
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
@@ -1821,7 +1821,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
 	 */
-	if (inode->i_uid != current->fsuid)
+	if (inode->i_uid != current_fsuid())
 		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 10bb02c..8c59a60 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1193,7 +1193,7 @@ static int ext2_has_free_blocks(struct ext2_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index f597413..8d0add6 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -550,7 +550,7 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -558,7 +558,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 92fd033..6f433f9 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1422,7 +1422,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 47b678d..490bd0e 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -539,7 +539,7 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -547,7 +547,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 495ab21..982042e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1615,7 +1615,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 #ifdef CONFIG_SMP
@@ -1628,7 +1628,6 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	return nblocks;
  }
 
-
 /**
  * ext4_should_retry_alloc()
  * @sb:			super block
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a92eb30..58b285f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -772,7 +772,7 @@ got:
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -780,7 +780,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 8707a8c..a72aa05 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -302,7 +302,7 @@ static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
 {
 	mode_t allow_utime = sbi->options.allow_utime;
 
-	if (current->fsuid != inode->i_uid) {
+	if (current_fsuid() != inode->i_uid) {
 		if (in_group_p(inode->i_gid))
 			allow_utime >>= 3;
 		if (allow_utime & MAY_WRITE)
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 87250b6..2d3ccbd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -87,8 +87,8 @@ static void __fuse_put_request(struct fuse_req *req)
 
 static void fuse_req_init_context(struct fuse_req *req)
 {
-	req->in.h.uid = current->fsuid;
-	req->in.h.gid = current->fsgid;
+	req->in.h.uid = current_fsuid();
+	req->in.h.gid = current_fsgid();
 	req->in.h.pid = current->pid;
 }
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8b0806a..c1c36f3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -701,18 +701,18 @@ static void munge_mode_uid_gid(struct gfs2_inode *dip, unsigned int *mode,
 	    (dip->i_inode.i_mode & S_ISUID) && dip->i_inode.i_uid) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISUID;
-		else if (dip->i_inode.i_uid != current->fsuid)
+		else if (dip->i_inode.i_uid != current_fsuid())
 			*mode &= ~07111;
 		*uid = dip->i_inode.i_uid;
 	} else
-		*uid = current->fsuid;
+		*uid = current_fsuid();
 
 	if (dip->i_inode.i_mode & S_ISGID) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISGID;
 		*gid = dip->i_inode.i_gid;
 	} else
-		*gid = current->fsgid;
+		*gid = current_fsgid();
 }
 
 static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
@@ -1122,8 +1122,8 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		return -EPERM;
 
 	if ((dip->i_inode.i_mode & S_ISVTX) &&
-	    dip->i_inode.i_uid != current->fsuid &&
-	    ip->i_inode.i_uid != current->fsuid && !capable(CAP_FOWNER))
+	    dip->i_inode.i_uid != current_fsuid() &&
+	    ip->i_inode.i_uid != current_fsuid() && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (IS_APPEND(&dip->i_inode))
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 7e19835..d668267 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -155,8 +155,8 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	HFS_I(inode)->flags = 0;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b085d64..7c711ca 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -307,8 +307,8 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 
 	inode->i_ino = HFSPLUS_SB(sb).next_cnid++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index d9c59a7..061db62 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -92,11 +92,11 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inc_nlink(dir);
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current_fsuid() ||
+	    result->i_gid != current_fsgid() ||
 	    result->i_mode != (mode | S_IFDIR)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current_fsuid();
+		result->i_gid = current_fsgid();
 		result->i_mode = mode | S_IFDIR;
 		hpfs_write_inode_nolock(result);
 	}
@@ -184,11 +184,11 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struc
 
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current_fsuid() ||
+	    result->i_gid != current_fsgid() ||
 	    result->i_mode != (mode | S_IFREG)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current_fsuid();
+		result->i_gid = current_fsgid();
 		result->i_mode = mode | S_IFREG;
 		hpfs_write_inode_nolock(result);
 	}
@@ -247,8 +247,8 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current_fsuid();
+	result->i_gid = current_fsgid();
 	result->i_nlink = 1;
 	result->i_size = 0;
 	result->i_blocks = 1;
@@ -325,8 +325,8 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
 	result->i_mode = S_IFLNK | 0777;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current_fsuid();
+	result->i_gid = current_fsgid();
 	result->i_blocks = 1;
 	result->i_nlink = 1;
 	result->i_size = strlen(symlink);
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f58923..4c428f5 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -551,9 +551,9 @@ static int hugetlbfs_mknod(struct inode *dir,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		gid = current->fsgid;
+		gid = current_fsgid();
 	}
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid, gid, mode, dev);
+	inode = hugetlbfs_get_inode(dir->i_sb, current_fsuid(), gid, mode, dev);
 	if (inode) {
 		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 		d_instantiate(dentry, inode);
@@ -586,9 +586,9 @@ static int hugetlbfs_symlink(struct inode *dir,
 	if (dir->i_mode & S_ISGID)
 		gid = dir->i_gid;
 	else
-		gid = current->fsgid;
+		gid = current_fsgid();
 
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid,
+	inode = hugetlbfs_get_inode(dir->i_sb, current_fsuid(),
 					gid, S_IFLNK|S_IRWXUGO, 0);
 	if (inode) {
 		int l = strlen(symname)+1;
@@ -854,8 +854,8 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
-	config.uid = current->fsuid;
-	config.gid = current->fsgid;
+	config.uid = current_fsuid();
+	config.gid = current_fsgid();
 	config.mode = 0755;
 	config.hstate = &default_hstate;
 	ret = hugetlbfs_parse_options(data, &config);
@@ -970,8 +970,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 		goto out_shm_unlock;
 
 	error = -ENOSPC;
-	inode = hugetlbfs_get_inode(root->d_sb, current->fsuid,
-				current->fsgid, S_IFREG | S_IRWXUGO, 0);
+	inode = hugetlbfs_get_inode(root->d_sb, current_fsuid(),
+				current_fsgid(), S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
 		goto out_dentry;
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 086c438..df0cbdf 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -440,14 +440,14 @@ struct inode *jffs2_new_inode (struct inode *dir_i, int mode, struct jffs2_raw_i
 
 	memset(ri, 0, sizeof(*ri));
 	/* Set OS-specific defaults for new inodes */
-	ri->uid = cpu_to_je16(current->fsuid);
+	ri->uid = cpu_to_je16(current_fsuid());
 
 	if (dir_i->i_mode & S_ISGID) {
 		ri->gid = cpu_to_je16(dir_i->i_gid);
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		ri->gid = cpu_to_je16(current->fsgid);
+		ri->gid = cpu_to_je16(current_fsgid());
 	}
 
 	/* POSIX ACLs have to be processed now, at least partly.
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index ed6574b..70022fd 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -93,13 +93,13 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 		return ERR_PTR(rc);
 	}
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (parent->i_mode & S_ISGID) {
 		inode->i_gid = parent->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 
 	/*
 	 * New inodes need to save sane values on disk when
diff --git a/fs/locks.c b/fs/locks.c
index 5eb259e..ba4ff5a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1349,7 +1349,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
 
-	if ((current->fsuid != inode->i_uid) && !capable(CAP_LEASE))
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 703cc35..3aebe32 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -262,8 +262,8 @@ struct inode * minix_new_inode(const struct inode * dir, int * error)
 		iput(inode);
 		return NULL;
 	}
-	inode->i_uid = current->fsuid;
-	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current_fsgid();
 	inode->i_ino = j;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/namei.c b/fs/namei.c
index 4ea63ed..6f95377 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -186,7 +186,7 @@ int generic_permission(struct inode *inode, int mask,
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -454,7 +454,7 @@ static int exec_permission_lite(struct inode *inode)
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current->fsuid == inode->i_uid)
+	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
@@ -1363,11 +1363,13 @@ static int user_path_parent(int dfd, const char __user *path,
  */
 static inline int check_sticky(struct inode *dir, struct inode *inode)
 {
+	uid_t fsuid = current_fsuid();
+
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == current->fsuid)
+	if (inode->i_uid == fsuid)
 		return 0;
-	if (dir->i_uid == current->fsuid)
+	if (dir->i_uid == fsuid)
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 18060be..a1b99c6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1166,7 +1166,7 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	 * send along the gid on create when it tries to implement
 	 * setgid directories via NFS:
 	 */
-	if (current->fsuid != 0)
+	if (current_fsuid() != 0)
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
 	if (iap->ia_valid)
 		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
@@ -1906,7 +1906,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 		IS_APPEND(inode)?	" append" : "",
 		__mnt_is_readonly(exp->ex_path.mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
-		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
+		inode->i_uid, inode->i_gid, current_fsuid(), current_fsgid());
 #endif
 
 	/* Normally we reject any write/sattr etc access on a read-only file
@@ -1949,7 +1949,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 * with NFSv3.
 	 */
 	if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
-	    inode->i_uid == current->fsuid)
+	    inode->i_uid == current_fsuid())
 		return 0;
 
 	/* This assumes  NFSD_MAY_{READ,WRITE,EXEC} == MAY_{READ,WRITE,EXEC} */
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 533a789..3516d8a 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -339,8 +339,8 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 		ip = DLMFS_I(inode);
 
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
@@ -365,8 +365,8 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
 		return NULL;
 
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_blocks = 0;
 	inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d5d808f..8dab41c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -425,13 +425,13 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_blkno = cpu_to_le64(fe_blkno);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
-	fe->i_uid = cpu_to_le32(current->fsuid);
+	fe->i_uid = cpu_to_le32(current_fsuid());
 	if (dir->i_mode & S_ISGID) {
 		fe->i_gid = cpu_to_le32(dir->i_gid);
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		fe->i_gid = cpu_to_le32(current->fsgid);
+		fe->i_gid = cpu_to_le32(current_fsgid());
 	fe->i_mode = cpu_to_le16(mode);
 	if (S_ISCHR(mode) || S_ISBLK(mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index d865f55..903f70f 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -37,8 +37,8 @@ struct inode *omfs_new_inode(struct inode *dir, int mode)
 
 	inode->i_ino = new_block;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &omfs_aops;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index fcba654..8b4e3ed 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -902,8 +902,8 @@ static struct inode * get_pipe_inode(void)
 	 */
 	inode->i_state = I_DIRTY;
 	inode->i_mode = S_IFIFO | S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
 	return inode;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index aec931e..39df95a 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -217,11 +217,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-                                if (inode->i_uid == current->fsuid)
+				if (inode->i_uid == current_fsuid())
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-                                if (pa->e_id == current->fsuid)
+				if (pa->e_id == current_fsuid())
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index b131234..08c755d 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -55,8 +55,8 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index c1add28..bd46f60 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -582,7 +582,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 	/* the quota init calls have to know who to charge the quota to, so
 	 ** we have to set uid and gid here
 	 */
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	inode->i_mode = mode;
 	/* Make inode invalid - just in case we are going to drop it before
 	 * the initialization happens */
@@ -593,7 +593,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, int mode)
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	}
 	DQUOT_INIT(inode);
 	return 0;
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index 115ab0d..241e976 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -165,9 +165,9 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	inode->i_ino = fs16_to_cpu(sbi, ino);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index d81fb9e..1df3534 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -375,7 +375,7 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
  */
 static int can_use_rp(struct ubifs_info *c)
 {
-	if (current->fsuid == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
+	if (current_fsuid() == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
 	    (c->rp_gid != 0 && in_group_p(c->rp_gid)))
 		return 1;
 	return 0;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index e90374b..cd36ed5 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -104,13 +104,13 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
 	 */
 	inode->i_flags |= (S_NOCMTIME);
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
 			 ubifs_current_time(inode);
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index eb9cfa2..acfc807 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -112,13 +112,13 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	}
 
 	iinfo->i_location.logicalBlockNum = block;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index d323194..09d5bfd 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -605,7 +605,7 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		goto out;
 
 	iinfo = UDF_I(inode);
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	init_special_inode(inode, mode, rdev);
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index ac181f6..6f5dcf0 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -304,13 +304,13 @@ cg_found:
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 
 	inode->i_blocks = 0;
 	inode->i_generation = 0;
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..bbc9b36 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -126,8 +126,8 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-#define current_fsuid(cred)	(current->fsuid)
-#define current_fsgid(cred)	(current->fsgid)
+#define this_fsuid(cred)	(current_fsuid())
+#define this_fsgid(cred)	(current_fsgid())
 #define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3e4648a..f94e5a8 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -372,7 +372,7 @@ xfs_acl_allow_set(
 		return ENOTDIR;
 	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
-	if (xfs_vtoi(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
+	if (xfs_vtoi(vp)->i_d.di_uid != current_fsuid() && !capable(CAP_FOWNER))
 		return EPERM;
 	return 0;
 }
@@ -419,13 +419,13 @@ xfs_acl_access(
 		switch (fap->acl_entry[i].ae_tag) {
 		case ACL_USER_OBJ:
 			seen_userobj = 1;
-			if (fuid != current->fsuid)
+			if (fuid != current_fsuid())
 				continue;
 			matched.ae_tag = ACL_USER_OBJ;
 			matched.ae_perm = allows;
 			break;
 		case ACL_USER:
-			if (fap->acl_entry[i].ae_id != current->fsuid)
+			if (fap->acl_entry[i].ae_id != current_fsuid())
 				continue;
 			matched.ae_tag = ACL_USER;
 			matched.ae_perm = allows;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..5e481ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1082,8 +1082,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid(cr);
-	ip->i_d.di_gid = current_fsgid(cr);
+	ip->i_d.di_uid = this_fsuid(cr);
+	ip->i_d.di_gid = this_fsgid(cr);
 	ip->i_d.di_projid = prid;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 76a1166..3dfe8a0 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -182,7 +182,7 @@ xfs_setattr(
 	xfs_ilock(ip, lock_flags);
 
 	/* boolean: are we the file owner? */
-	file_owner = (current_fsuid(credp) == ip->i_d.di_uid);
+	file_owner = (this_fsuid(credp) == ip->i_d.di_uid);
 
 	/*
 	 * Change various properties of a file.
@@ -1536,7 +1536,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL|XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2352,7 +2352,7 @@ xfs_mkdir(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2578,7 +2578,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..9d56fbd
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,25 @@
+/* Credentials management
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#define current_fsuid()		(current->fsuid)
+#define current_fsgid()		(current->fsgid)
+#define current_cap()		(current->cap_effective)
+
+#define current_fsuid_fsgid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->fsuid;		\
+	*(_gid) = current->fsgid;		\
+} while(0)
+
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..9a8397f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1149,7 +1149,7 @@ enum {
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
 #define is_owner_or_cap(inode)	\
-	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
+	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5270d44..9fd5694 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,6 +87,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/kobject.h>
 #include <linux/latencytop.h>
+#include <linux/cred.h>
 
 #include <asm/processor.h>
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 96fb36c..c652c21 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -109,8 +109,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mtime = inode->i_ctime = inode->i_atime =
 				CURRENT_TIME;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 13932ab..f483904 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -573,8 +573,8 @@ static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_mapping->backing_dev_info = &cgroup_backing_dev_info;
diff --git a/mm/shmem.c b/mm/shmem.c
index c1e5a3b..ba957d4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1510,8 +1510,8 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
@@ -2275,8 +2275,8 @@ static int shmem_fill_super(struct super_block *sb,
 	sbinfo->max_blocks = 0;
 	sbinfo->max_inodes = 0;
 	sbinfo->mode = S_IRWXUGO | S_ISVTX;
-	sbinfo->uid = current->fsuid;
-	sbinfo->gid = current->fsgid;
+	sbinfo->uid = current_fsuid();
+	sbinfo->gid = current_fsgid();
 	sbinfo->mpol = NULL;
 	sb->s_fs_info = sbinfo;
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 2ffe40c..a5dfc17 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1049,7 +1049,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	fid->rdir_fpos = 0;
 	fid->rdir_pos = 0;
 	fid->rdir_fcall = NULL;
-	fid->uid = current->fsuid;
+	fid->uid = current_fsuid();
 	fid->clnt = clnt;
 	fid->aux = NULL;
 
diff --git a/net/socket.c b/net/socket.c
index 8ef8ba8..1080f7a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -491,8 +491,8 @@ static struct socket *sock_alloc(void)
 	sock = SOCKET_I(inode);
 
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 
 	get_cpu_var(sockets_in_use)++;
 	put_cpu_var(sockets_in_use);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 6bfea9e..9dd8062 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -351,8 +351,8 @@ struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
 	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
+		.uid = current_fsuid(),
+		.gid = current_fsgid(),
 		.group_info = current->group_info,
 	};
 	struct rpc_cred *ret;
diff --git a/security/commoncap.c b/security/commoncap.c
index 40e8b83..708aa05 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -498,12 +498,12 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 			 */
 
 			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && current->fsuid != 0) {
+				if (old_fsuid == 0 && current_fsuid() != 0) {
 					current->cap_effective =
 						cap_drop_fs_set(
 						    current->cap_effective);
 				}
-				if (old_fsuid != 0 && current->fsuid == 0) {
+				if (old_fsuid != 0 && current_fsuid() == 0) {
 					current->cap_effective =
 						cap_raise_fs_set(
 						    current->cap_effective,
diff --git a/security/keys/key.c b/security/keys/key.c
index 14948cf..a6ca39e 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -802,7 +802,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
+	key = key_alloc(ktype, description, current_fsuid(), current_fsgid(),
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index a738114..fcce331 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -817,7 +817,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current->fsuid) {
+	if (capable(CAP_SYS_ADMIN) || key->uid == current_fsuid()) {
 		key->perm = perm;
 		ret = 0;
 	}
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 123edce..d7a4e25 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -79,7 +79,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current->fsuid, current->fsgid, current,
+	keyring = keyring_alloc(desc, current_fsuid(), current_fsgid(), current,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -92,8 +92,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current->fsuid);
-	sprintf(gid_str, "%d", current->fsgid);
+	sprintf(uid_str, "%d", current_fsuid());
+	sprintf(gid_str, "%d", current_fsgid());
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
@@ -302,7 +302,7 @@ static int construct_alloc_key(struct key_type *type,
 	mutex_lock(&user->cons_lock);
 
 	key = key_alloc(type, description,
-			current->fsuid, current->fsgid, current, KEY_POS_ALL,
+			current_fsuid(), current_fsgid(), current, KEY_POS_ALL,
 			flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
@@ -362,7 +362,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 	struct key *key;
 	int ret;
 
-	user = key_user_lookup(current->fsuid);
+	user = key_user_lookup(current_fsuid());
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index eccd2f2..1762d44 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -197,7 +197,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current->fsuid, current->fsgid, current,
+			    current_fsuid(), current_fsgid(), current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXFIIQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXFIIQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXFIIPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:15:47 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:57909
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbXFIIPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:15:45 -0400
Message-ID: <466A6195.5060902@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:15:17 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: [PATCH 5/7] Replace DPRINTK with pr_debug in ncpfs
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org>
In-Reply-To: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces DPRINTKs in ncpfs with a combination of pr_debug and
pr_err as appropriate.

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
Index: linux/fs/ncpfs/dir.c
===================================================================
--- linux.orig/fs/ncpfs/dir.c
+++ linux/fs/ncpfs/dir.c
@@ -296,7 +296,7 @@ __ncp_lookup_validate(struct dentry * de
 	if (val)
 		goto finished;

-	DDPRINTK("ncp_lookup_validate: %s/%s not valid, age=%ld, server lookup\n",
+	pr_debug("ncp_lookup_validate: %s/%s not valid, age=%ld, server lookup\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		NCP_GET_AGE(dentry));

@@ -313,7 +313,7 @@ __ncp_lookup_validate(struct dentry * de
 			res = ncp_obtain_info(server, dir, __name, &(finfo.i));
 	}
 	finfo.volume = finfo.i.volNumber;
-	DDPRINTK("ncp_lookup_validate: looked for %s/%s, res=%d\n",
+	pr_debug("ncp_lookup_validate: looked for %s/%s, res=%d\n",
 		dentry->d_parent->d_name.name, __name, res);
 	/*
 	 * If we didn't find it, or if it has a different dirEntNum to
@@ -324,13 +324,13 @@ __ncp_lookup_validate(struct dentry * de
 			ncp_new_dentry(dentry);
 			val=1;
 		} else
-			DDPRINTK("ncp_lookup_validate: found, but dirEntNum changed\n");
+			pr_debug("ncp_lookup_validate: found, but dirEntNum changed\n");

 		ncp_update_inode2(dentry->d_inode, &finfo);
 	}

 finished:
-	DDPRINTK("ncp_lookup_validate: result=%d\n", val);
+	pr_debug("ncp_lookup_validate: result=%d\n", val);
 	dput(parent);
 	return val;
 }
@@ -416,7 +416,7 @@ static int ncp_readdir(struct file *filp
 	ctl.page  = NULL;
 	ctl.cache = NULL;

-	DDPRINTK("ncp_readdir: reading %s/%s, pos=%d\n",
+	pr_debug("ncp_readdir: reading %s/%s, pos=%d\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		(int) filp->f_pos);

@@ -656,7 +656,7 @@ ncp_read_volume_list(struct file *filp,
 	struct ncp_entry_info entry;
 	int i;

-	DPRINTK("ncp_read_volume_list: pos=%ld\n",
+	pr_debug("ncp_read_volume_list: pos=%ld\n",
 			(unsigned long) filp->f_pos);

 	for (i = 0; i < NCP_NUMBER_OF_VOLUMES; i++) {
@@ -666,12 +666,12 @@ ncp_read_volume_list(struct file *filp,
 		if (!strlen(info.volume_name))
 			continue;

-		DPRINTK("ncp_read_volume_list: found vol: %s\n",
+		pr_debug("ncp_read_volume_list: found vol: %s\n",
 			info.volume_name);

 		if (ncp_lookup_volume(server, info.volume_name,
 					&entry.i)) {
-			DPRINTK("ncpfs: could not lookup vol %s\n",
+			pr_debug("ncpfs: could not lookup vol %s\n",
 				info.volume_name);
 			continue;
 		}
@@ -695,7 +695,7 @@ ncp_do_readdir(struct file *filp, void *
 	int more;
 	size_t bufsize;

-	DPRINTK("ncp_do_readdir: %s/%s, fpos=%ld\n",
+	pr_debug("ncp_do_readdir: %s/%s, fpos=%ld\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		(unsigned long) filp->f_pos);
 	PPRINTK("ncp_do_readdir: init %s, volnum=%d, dirent=%u\n",
@@ -704,7 +704,7 @@ ncp_do_readdir(struct file *filp, void *

 	err = ncp_initialize_search(server, dir, &seq);
 	if (err) {
-		DPRINTK("ncp_do_readdir: init failed, err=%d\n", err);
+		pr_debug("ncp_do_readdir: init failed, err=%d\n", err);
 		return;
 	}
 	/* We MUST NOT use server->buffer_size handshaked with server if we are
@@ -779,10 +779,10 @@ int ncp_conn_logged_in(struct super_bloc
 				NCP_FINFO(ino)->dirEntNum = dirEntNum;
 				NCP_FINFO(ino)->DosDirNum = DosDirNum;
 			} else {
-				DPRINTK("ncpfs: sb->s_root->d_inode == NULL!\n");
+				pr_debug("ncpfs: sb->s_root->d_inode == NULL!\n");
 			}
 		} else {
-			DPRINTK("ncpfs: sb->s_root == NULL!\n");
+			pr_debug("ncpfs: sb->s_root == NULL!\n");
 		}
 	}
 	result = 0;
@@ -917,7 +917,7 @@ int ncp_create_new(struct inode *dir, st
 		if (result) {
 			if (result == 0x87)
 				error = -ENAMETOOLONG;
-			DPRINTK("ncp_create: %s/%s failed\n",
+			pr_debug("ncp_create: %s/%s failed\n",
 				dentry->d_parent->d_name.name, dentry->d_name.name);
 			goto out;
 		}
@@ -952,7 +952,7 @@ static int ncp_mkdir(struct inode *dir,
 	int error, len;
 	__u8 __name[NCP_MAXPATHLEN + 1];

-	DPRINTK("ncp_mkdir: making %s/%s\n",
+	pr_debug("ncp_mkdir: making %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);

 	error = -EIO;
@@ -995,7 +995,7 @@ static int ncp_rmdir(struct inode *dir,
 	int error, result, len;
 	__u8 __name[NCP_MAXPATHLEN + 1];

-	DPRINTK("ncp_rmdir: removing %s/%s\n",
+	pr_debug("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);

 	error = -EIO;
@@ -1052,7 +1052,7 @@ static int ncp_unlink(struct inode *dir,

 	lock_kernel();
 	server = NCP_SERVER(dir);
-	DPRINTK("ncp_unlink: unlinking %s/%s\n",
+	pr_debug("ncp_unlink: unlinking %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	
 	error = -EIO;
@@ -1077,7 +1077,7 @@ static int ncp_unlink(struct inode *dir,
 #endif
 	switch (error) {
 		case 0x00:
-			DPRINTK("ncp: removed %s/%s\n",
+			pr_debug("ncp: removed %s/%s\n",
 				dentry->d_parent->d_name.name, dentry->d_name.name);
 			break;
 		case 0x85:
@@ -1114,7 +1114,7 @@ static int ncp_rename(struct inode *old_
 	int old_len, new_len;
 	__u8 __old_name[NCP_MAXPATHLEN + 1], __new_name[NCP_MAXPATHLEN + 1];

-	DPRINTK("ncp_rename: %s/%s to %s/%s\n",
+	pr_debug("ncp_rename: %s/%s to %s/%s\n",
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		new_dentry->d_parent->d_name.name, new_dentry->d_name.name);

@@ -1151,7 +1151,7 @@ static int ncp_rename(struct inode *old_
 #endif
 	switch (error) {
 		case 0x00:
-               	        DPRINTK("ncp renamed %s -> %s.\n",
+               	        pr_debug("ncp renamed %s -> %s.\n",

old_dentry->d_name.name,new_dentry->d_name.name);
 			break;
 		case 0x9E:
@@ -1175,7 +1175,7 @@ static int ncp_mknod(struct inode * dir,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 	if (ncp_is_nfs_extras(NCP_SERVER(dir), NCP_FINFO(dir)->volNumber)) {
-		DPRINTK(KERN_DEBUG "ncp_mknod: mode = 0%o\n", mode);
+		pr_debug(KERN_DEBUG "ncp_mknod: mode = 0%o\n", mode);
 		return ncp_create_new(dir, dentry, mode, rdev, 0);
 	}
 	return -EPERM; /* Strange, but true */
Index: linux/fs/ncpfs/file.c
===================================================================
--- linux.orig/fs/ncpfs/file.c
+++ linux/fs/ncpfs/file.c
@@ -41,7 +41,7 @@ int ncp_make_open(struct inode *inode, i
 		goto out;
 	}

-	DPRINTK("ncp_make_open: opened=%d, volume # %u, dir entry # %u\n",
+	pr_debug("ncp_make_open: opened=%d, volume # %u, dir entry # %u\n",
 		atomic_read(&NCP_FINFO(inode)->opened),
 		NCP_FINFO(inode)->volNumber,
 		NCP_FINFO(inode)->dirEntNum);
@@ -110,7 +110,7 @@ ncp_file_read(struct file *file, char __
 	void* freepage;
 	size_t freelen;

-	DPRINTK("ncp_file_read: enter %s/%s\n",
+	pr_debug("ncp_file_read: enter %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);

 	if (!ncp_conn_valid(NCP_SERVER(inode)))
@@ -131,7 +131,7 @@ ncp_file_read(struct file *file, char __

 	error = ncp_make_open(inode, O_RDONLY);
 	if (error) {
-		DPRINTK(KERN_ERR "ncp_file_read: open failed, error=%d\n", error);
+		pr_err("ncp_file_read: open failed, error=%d\n", error);
 		return error;
 	}

@@ -172,7 +172,7 @@ ncp_file_read(struct file *file, char __

 	file_accessed(file);

-	DPRINTK("ncp_file_read: exit %s/%s\n",
+	pr_debug("ncp_file_read: exit %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 outrel:
 	ncp_inode_close(inode);		
@@ -190,7 +190,7 @@ ncp_file_write(struct file *file, const
 	int errno;
 	void* bouncebuffer;

-	DPRINTK("ncp_file_write: enter %s/%s\n",
+	pr_debug("ncp_file_write: enter %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	if (!ncp_conn_valid(NCP_SERVER(inode)))
 		return -EIO;
@@ -224,7 +224,7 @@ ncp_file_write(struct file *file, const
 		return 0;
 	errno = ncp_make_open(inode, O_WRONLY);
 	if (errno) {
-		DPRINTK(KERN_ERR "ncp_file_write: open failed, error=%d\n", errno);
+		pr_err("ncp_file_write: open failed, error=%d\n", errno);
 		return errno;
 	}
 	bufsize = NCP_SERVER(inode)->buffer_size;
@@ -269,7 +269,7 @@ ncp_file_write(struct file *file, const
 	if (pos > inode->i_size) {
 		inode->i_size = pos;
 	}
-	DPRINTK("ncp_file_write: exit %s/%s\n",
+	pr_debug("ncp_file_write: exit %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 outrel:
 	ncp_inode_close(inode);		
@@ -278,7 +278,7 @@ outrel:

 static int ncp_release(struct inode *inode, struct file *file) {
 	if (ncp_make_closed(inode)) {
-		DPRINTK("ncp_release: failed to close\n");
+		pr_debug("ncp_release: failed to close\n");
 	}
 	return 0;
 }
Index: linux/fs/ncpfs/inode.c
===================================================================
--- linux.orig/fs/ncpfs/inode.c
+++ linux/fs/ncpfs/inode.c
@@ -121,7 +121,7 @@ void ncp_update_inode(struct inode *inod
 	NCP_FINFO(inode)->access = nwinfo->access;
 	memcpy(NCP_FINFO(inode)->file_handle, nwinfo->file_handle,
 			sizeof(nwinfo->file_handle));
-	DPRINTK("ncp_update_inode: updated %s, volnum=%d, dirent=%u\n",
+	pr_debug("ncp_update_inode: updated %s, volnum=%d, dirent=%u\n",
 		nwinfo->i.entryName, NCP_FINFO(inode)->volNumber,
 		NCP_FINFO(inode)->dirEntNum);
 }
@@ -129,7 +129,7 @@ void ncp_update_inode(struct inode *inod
 static void ncp_update_dates(struct inode *inode, struct nw_info_struct
*nwi)
 {
 	/* NFS namespace mode overrides others if it's set. */
-	DPRINTK(KERN_DEBUG "ncp_update_dates_and_mode: (%s) nfs.mode=0%o\n",
+	pr_debug("ncp_update_dates_and_mode: (%s) nfs.mode=0%o\n",
 		nwi->entryName, nwi->nfs.mode);
 	if (nwi->nfs.mode) {
 		/* XXX Security? */
@@ -215,7 +215,7 @@ static void ncp_set_attr(struct inode *i
 	
 	ncp_update_attrs(inode, nwinfo);

-	DDPRINTK("ncp_read_inode: inode->i_mode = %u\n", inode->i_mode);
+	pr_debug("ncp_read_inode: inode->i_mode = %u\n", inode->i_mode);

 	inode->i_nlink = 1;
 	inode->i_uid = server->m.uid;
@@ -284,7 +284,7 @@ ncp_delete_inode(struct inode *inode)
 	truncate_inode_pages(&inode->i_data, 0);

 	if (S_ISDIR(inode->i_mode)) {
-		DDPRINTK("ncp_delete_inode: put directory %ld\n", inode->i_ino);
+		pr_debug("ncp_delete_inode: put directory %ld\n", inode->i_ino);
 	}

 	if (ncp_make_closed(inode) != 0) {
@@ -601,7 +601,7 @@ static int ncp_fill_super(struct super_b
 	ncp_unlock_server(server);
 	if (error < 0)
 		goto out_rxbuf;
-	DPRINTK("ncp_fill_super: NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
+	pr_debug("ncp_fill_super: NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));

 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
@@ -627,7 +627,7 @@ static int ncp_fill_super(struct super_b
 	if (ncp_negotiate_buffersize(server, default_bufsize,
   				     &(server->buffer_size)) != 0)
 		goto out_disconnect;
-	DPRINTK("ncpfs: bufsize = %d\n", server->buffer_size);
+	pr_debug("ncpfs: bufsize = %d\n", server->buffer_size);

 	memset(&finfo, 0, sizeof(finfo));
 	finfo.i.attributes	= aDIR;
@@ -656,7 +656,7 @@ static int ncp_fill_super(struct super_b
         root_inode = ncp_iget(sb, &finfo);
         if (!root_inode)
 		goto out_disconnect;
-	DPRINTK("ncp_fill_super: root vol=%d\n",
NCP_FINFO(root_inode)->volNumber);
+	pr_debug("ncp_fill_super: root vol=%d\n",
NCP_FINFO(root_inode)->volNumber);
 	sb->s_root = d_alloc_root(root_inode);
         if (!sb->s_root)
 		goto out_no_root;
@@ -900,7 +900,7 @@ int ncp_notify_change(struct dentry *den
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		int written;

-		DPRINTK("ncpfs: trying to change size to %ld\n",
+		pr_debug("ncpfs: trying to change size to %ld\n",
 			attr->ia_size);

 		if ((result = ncp_make_open(inode, O_WRONLY)) < 0) {
@@ -987,7 +987,7 @@ static struct file_system_type ncp_fs_ty
 static int __init init_ncp_fs(void)
 {
 	int err;
-	DPRINTK("ncpfs: init_module called\n");
+	pr_debug("ncpfs: init_module called\n");

 	err = init_inodecache();
 	if (err)
@@ -1004,7 +1004,7 @@ out1:

 static void __exit exit_ncp_fs(void)
 {
-	DPRINTK("ncpfs: cleanup_module called\n");
+	pr_debug("ncpfs: cleanup_module called\n");
 	unregister_filesystem(&ncp_fs_type);
 	destroy_inodecache();
 }
Index: linux/fs/ncpfs/ioctl.c
===================================================================
--- linux.orig/fs/ncpfs/ioctl.c
+++ linux/fs/ncpfs/ioctl.c
@@ -18,6 +18,7 @@
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/kernel.h>

 #include <linux/ncp_fs.h>

@@ -47,7 +48,7 @@ ncp_get_fs_info(struct ncp_server * serv
 		return -EFAULT;

 	if (info.version != NCP_GET_FS_INFO_VERSION) {
-		DPRINTK("info.version invalid: %d\n", info.version);
+		pr_debug("info.version invalid: %d\n", info.version);
 		return -EINVAL;
 	}
 	/* TODO: info.addr = server->m.serv_addr; */
@@ -77,7 +78,7 @@ ncp_get_fs_info_v2(struct ncp_server * s
 		return -EFAULT;

 	if (info2.version != NCP_GET_FS_INFO_VERSION_V2) {
-		DPRINTK("info.version invalid: %d\n", info2.version);
+		pr_debug("info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
 	info2.mounted_uid   = server->m.mounted_uid;
@@ -148,7 +149,7 @@ ncp_get_compat_fs_info_v2(struct ncp_ser
 		return -EFAULT;

 	if (info2.version != NCP_GET_FS_INFO_VERSION_V2) {
-		DPRINTK("info.version invalid: %d\n", info2.version);
+		pr_debug("info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
 	info2.mounted_uid   = server->m.mounted_uid;
@@ -320,7 +321,7 @@ int ncp_ioctl(struct inode *inode, struc
 		else
 			result = server->reply_size;
 		ncp_unlock_server(server);
-		DPRINTK("ncp_ioctl: copy %d bytes\n",
+		pr_debug("ncp_ioctl: copy %d bytes\n",
 			result);
 		if (result >= 0)
 			if (copy_to_user(request.data, bouncebuffer, result))
@@ -395,9 +396,9 @@ int ncp_ioctl(struct inode *inode, struc
 						sr.dirEntNum = NCP_FINFO(inode)->dirEntNum;
 						sr.namespace = server->name_space[sr.volNumber];
 					} else
-						DPRINTK("ncpfs: s_root->d_inode==NULL\n");
+						pr_debug("ncpfs: s_root->d_inode==NULL\n");
 				} else
-					DPRINTK("ncpfs: s_root==NULL\n");
+					pr_debug("ncpfs: s_root==NULL\n");
 			} else {
 				sr.volNumber = -1;
 				sr.namespace = 0;
@@ -445,9 +446,9 @@ int ncp_ioctl(struct inode *inode, struc
 					NCP_FINFO(inode)->dirEntNum = de;
 					NCP_FINFO(inode)->DosDirNum = dosde;
 				} else
-					DPRINTK("ncpfs: s_root->d_inode==NULL\n");
+					pr_debug("ncpfs: s_root->d_inode==NULL\n");
 			} else
-				DPRINTK("ncpfs: s_root==NULL\n");
+				pr_debug("ncpfs: s_root==NULL\n");

 			return 0;
 		}
Index: linux/fs/ncpfs/mmap.c
===================================================================
--- linux.orig/fs/ncpfs/mmap.c
+++ linux/fs/ncpfs/mmap.c
@@ -108,7 +108,7 @@ int ncp_mmap(struct file *file, struct v
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	
-	DPRINTK("ncp_mmap: called\n");
+	pr_debug("ncp_mmap: called\n");

 	if (!ncp_conn_valid(NCP_SERVER(inode)))
 		return -EIO;
Index: linux/fs/ncpfs/ncplib_kernel.c
===================================================================
--- linux.orig/fs/ncpfs/ncplib_kernel.c
+++ linux/fs/ncpfs/ncplib_kernel.c
@@ -10,13 +10,13 @@
  */


-
+#include <linux/kernel.h>
 #include "ncplib_kernel.h"

 static inline void assert_server_locked(struct ncp_server *server)
 {
 	if (server->lock == 0) {
-		DPRINTK("ncpfs: server not locked!\n");
+		pr_debug("ncpfs: server not locked!\n");
 	}
 }

@@ -75,7 +75,7 @@ static void ncp_add_pstring(struct ncp_s
 	int len = strlen(s);
 	assert_server_locked(server);
 	if (len > 255) {
-		DPRINTK("ncpfs: string too long: %s\n", s);
+		pr_debug("ncpfs: string too long: %s\n", s);
 		len = 255;
 	}
 	ncp_add_byte(server, len);
@@ -226,7 +226,7 @@ int ncp_get_volume_info_with_number(stru
 	result = -EIO;
 	len = ncp_reply_byte(server, 29);
 	if (len > NCP_VOLNAME_LEN) {
-		DPRINTK("ncpfs: volume name too long: %d\n", len);
+		pr_debug("ncpfs: volume name too long: %d\n", len);
 		goto out;
 	}
 	memcpy(&(target->volume_name), ncp_reply_data(server, 30), len);
@@ -260,7 +260,7 @@ int ncp_get_directory_info(struct ncp_se
 	result = -EIO;
 	len = ncp_reply_byte(server, 21);
 	if (len > NCP_VOLNAME_LEN) {
-		DPRINTK("ncpfs: volume name too long: %d\n", len);
+		pr_debug("ncpfs: volume name too long: %d\n", len);
 		goto out;
 	}
 	memcpy(&(target->volume_name), ncp_reply_data(server, 22), len);
@@ -395,7 +395,7 @@ int ncp_obtain_nfs_info(struct ncp_serve

 		if ((result = ncp_request(server, 87)) == 0) {
 			ncp_extract_nfs_info(ncp_reply_data(server, 0), &target->nfs);
-			DPRINTK(KERN_DEBUG
+			pr_debug(
 				"ncp_obtain_nfs_info: (%s) mode=0%o, rdev=0x%x\n",
 				target->entryName, target->nfs.mode,
 				target->nfs.rdev);
@@ -499,7 +499,7 @@ ncp_get_known_namespace(struct ncp_serve
 	namespace = ncp_reply_data(server, 2);

 	while (no_namespaces > 0) {
-		DPRINTK("get_namespaces: found %d on %d\n", *namespace, volume);
+		pr_debug("get_namespaces: found %d on %d\n", *namespace, volume);

 #ifdef CONFIG_NCPFS_NFS_NS
 		if ((*namespace == NW_NS_NFS) && !(server->m.flags&NCP_MOUNT_NO_NFS))
@@ -582,7 +582,7 @@ ncp_get_volume_root(struct ncp_server *s
 	int result;
 	__u8 volnum;

-	DPRINTK("ncp_get_volume_root: looking up vol %s\n", volname);
+	pr_debug("ncp_get_volume_root: looking up vol %s\n", volname);

 	ncp_init_request(server);
 	ncp_add_byte(server, 22);	/* Subfunction: Generate dir handle */
@@ -608,7 +608,7 @@ ncp_get_volume_root(struct ncp_server *s

 	server->name_space[volnum] = ncp_get_known_namespace(server, volnum);

-	DPRINTK("lookup_vol: namespace[%d] = %d\n",
+	pr_debug("lookup_vol: namespace[%d] = %d\n",
 		volnum, server->name_space[volnum]);

 	return 0;
Index: linux/fs/ncpfs/sock.c
===================================================================
--- linux.orig/fs/ncpfs/sock.c
+++ linux/fs/ncpfs/sock.c
@@ -26,6 +26,7 @@
 #include <linux/ipx.h>
 #include <linux/poll.h>
 #include <linux/file.h>
+#include <linux/kernel.h>

 #include <linux/ncp_fs.h>

@@ -404,15 +405,15 @@ void ncpdgram_rcv_proc(struct work_struc
 				}
 				result = _recv(sock, buf, sizeof(buf), MSG_DONTWAIT);
 				if (result < 0) {
-					DPRINTK("recv failed with %d\n", result);
+					pr_debug("recv failed with %d\n", result);
 					continue;
 				}
 				if (result < 10) {
-					DPRINTK("too short (%u) watchdog packet\n", result);
+					pr_debug("too short (%u) watchdog packet\n", result);
 					continue;
 				}
 				if (buf[9] != '?') {
-					DPRINTK("bad signature (%02X) in watchdog packet\n", buf[9]);
+					pr_debug("bad signature (%02X) in watchdog packet\n", buf[9]);
 					continue;
 				}
 				buf[9] = 'Y';
@@ -553,7 +554,7 @@ static int __ncptcp_rcv_proc(struct ncp_
 				if (result < 0) {
 					printk(KERN_ERR "ncpfs: tcp: error in recvmsg: %d\n", result);
 				} else {
-					DPRINTK(KERN_ERR "ncpfs: tcp: EOF\n");
+					pr_err("ncpfs: tcp: EOF\n");
 				}
 				return -EIO;
 			}
@@ -603,7 +604,7 @@ cont:;				
 						server->rcv.len = datalen - 10;
 						break;
 					}					
-					DPRINTK("ncpfs: tcp: Unexpected NCP type %02X\n", type);
+					pr_debug("ncpfs: tcp: Unexpected NCP type %02X\n", type);
 skipdata2:;
 					server->rcv.state = 2;
 skipdata:;
@@ -613,7 +614,7 @@ skipdata:;
 				}
 				req = server->rcv.creq;
 				if (!req) {
-					DPRINTK(KERN_ERR "ncpfs: Reply without appropriate request\n");
+					pr_err("ncpfs: Reply without appropriate request\n");
 					goto skipdata2;
 				}
 				if (datalen > req->datalen + 8) {
@@ -781,7 +782,7 @@ static int ncp_do_request(struct ncp_ser
 		spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	}

-	DDPRINTK("do_ncp_rpc_call returned %d\n", result);
+	pr_debug("do_ncp_rpc_call returned %d\n", result);

 	return result;
 }
@@ -811,7 +812,7 @@ int ncp_request2(struct ncp_server *serv

 	result = ncp_do_request(server, server->current_size, reply, size);
 	if (result < 0) {
-		DPRINTK("ncp_request_error: %d\n", result);
+		pr_debug("ncp_request_error: %d\n", result);
 		goto out;
 	}
 	server->completion = reply->completion_code;
Index: linux/fs/ncpfs/symlink.c
===================================================================
--- linux.orig/fs/ncpfs/symlink.c
+++ linux/fs/ncpfs/symlink.c
@@ -29,6 +29,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/stat.h>
+#include <linux/kernel.h>
 #include "ncplib_kernel.h"


@@ -113,7 +114,7 @@ int ncp_symlink(struct inode *dir, struc
 	__le32 attr;
 	unsigned int hdr;

-	DPRINTK("ncp_symlink(dir=%p,dentry=%p,symname=%s)\n",dir,dentry,symname);
+	pr_debug("ncp_symlink(dir=%p,dentry=%p,symname=%s)\n",dir,dentry,symname);

 	if (ncp_is_nfs_extras(NCP_SERVER(dir), NCP_FINFO(dir)->volNumber))
 		kludge = 0;
Index: linux/include/linux/ncp_fs.h
===================================================================
--- linux.orig/include/linux/ncp_fs.h
+++ linux/include/linux/ncp_fs.h
@@ -160,20 +160,6 @@ struct ncp_nls_ioctl
 #define PPRINTK(format, args...)
 #endif

-#ifndef DEBUG_NCP
-#define DEBUG_NCP 0
-#endif
-#if DEBUG_NCP > 0
-#define DPRINTK(format, args...) PRINTK(format , ## args)
-#else
-#define DPRINTK(format, args...)
-#endif
-#if DEBUG_NCP > 1
-#define DDPRINTK(format, args...) PRINTK(format , ## args)
-#else
-#define DDPRINTK(format, args...)
-#endif
-
 #define NCP_MAX_RPC_TIMEOUT (6*HZ)





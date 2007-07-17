Return-Path: <linux-kernel-owner+w=401wt.eu-S935034AbXGQPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034AbXGQPpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759777AbXGQPlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934610AbXGQPlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:20 -0400
Message-Id: <20070717173759.047364000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 10/12] lockdep: fs: per file-system type lock_page class
Content-Disposition: inline; filename=lockdep-filesystem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

static struct file_system_type foo_fs_type {
	...
	FS_TYPE_INIT(foo_fs),
};

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/ia64/kernel/perfmon.c                |    1 +
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 arch/s390/hypfs/inode.c                   |    3 ++-
 drivers/infiniband/core/uverbs_main.c     |    3 ++-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    1 +
 drivers/isdn/capi/capifs.c                |    1 +
 drivers/kvm/kvm_main.c                    |    1 +
 drivers/misc/ibmasm/ibmasmfs.c            |    1 +
 drivers/oprofile/oprofilefs.c             |    1 +
 drivers/usb/core/inode.c                  |    1 +
 drivers/usb/gadget/inode.c                |    1 +
 fs/9p/vfs_super.c                         |    1 +
 fs/adfs/super.c                           |    1 +
 fs/affs/super.c                           |    1 +
 fs/afs/super.c                            |    1 +
 fs/anon_inodes.c                          |    1 +
 fs/autofs/init.c                          |    1 +
 fs/autofs4/init.c                         |    1 +
 fs/befs/linuxvfs.c                        |    1 +
 fs/bfs/inode.c                            |    1 +
 fs/binfmt_misc.c                          |    1 +
 fs/block_dev.c                            |    1 +
 fs/cifs/cifsfs.c                          |    1 +
 fs/coda/inode.c                           |    1 +
 fs/configfs/mount.c                       |    1 +
 fs/cramfs/inode.c                         |    1 +
 fs/debugfs/inode.c                        |    1 +
 fs/devpts/inode.c                         |    1 +
 fs/ecryptfs/main.c                        |    3 ++-
 fs/efs/super.c                            |    1 +
 fs/ext2/super.c                           |    1 +
 fs/ext3/super.c                           |    1 +
 fs/ext4/super.c                           |    1 +
 fs/freevxfs/vxfs_super.c                  |    1 +
 fs/fuse/control.c                         |    1 +
 fs/fuse/inode.c                           |    2 ++
 fs/gfs2/ops_fstype.c                      |    2 ++
 fs/hfs/super.c                            |    1 +
 fs/hfsplus/super.c                        |    1 +
 fs/hostfs/hostfs_kern.c                   |    1 +
 fs/hpfs/super.c                           |    1 +
 fs/hppfs/hppfs_kern.c                     |    1 +
 fs/hugetlbfs/inode.c                      |    1 +
 fs/inotify_user.c                         |    1 +
 fs/isofs/inode.c                          |    1 +
 fs/jffs2/super.c                          |    1 +
 fs/jfs/super.c                            |    1 +
 fs/minix/inode.c                          |    1 +
 fs/msdos/namei.c                          |    1 +
 fs/ncpfs/inode.c                          |    1 +
 fs/nfs/super.c                            |    5 +++++
 fs/nfsd/nfsctl.c                          |    1 +
 fs/ntfs/super.c                           |    1 +
 fs/ocfs2/dlm/dlmfs.c                      |    1 +
 fs/ocfs2/super.c                          |    3 ++-
 fs/openpromfs/inode.c                     |    1 +
 fs/pipe.c                                 |    1 +
 fs/proc/root.c                            |    1 +
 fs/qnx4/inode.c                           |    1 +
 fs/ramfs/inode.c                          |    2 ++
 fs/reiserfs/super.c                       |    1 +
 fs/romfs/inode.c                          |    1 +
 fs/smbfs/inode.c                          |    1 +
 fs/sysfs/mount.c                          |    1 +
 fs/sysv/super.c                           |    2 ++
 fs/udf/super.c                            |    1 +
 fs/ufs/super.c                            |    1 +
 fs/vfat/namei.c                           |    1 +
 fs/xfs/linux-2.6/xfs_super.c              |    1 +
 include/linux/fs.h                        |   15 +++++++++++++++
 ipc/mqueue.c                              |    1 +
 kernel/cpuset.c                           |    1 +
 kernel/futex.c                            |    1 +
 mm/shmem.c                                |    1 +
 mm/tiny-shmem.c                           |    1 +
 net/socket.c                              |    1 +
 net/sunrpc/rpc_pipe.c                     |    1 +
 security/inode.c                          |    1 +
 security/selinux/selinuxfs.c              |    1 +
 79 files changed, 105 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6/arch/ia64/kernel/perfmon.c
@@ -648,6 +648,7 @@ static struct file_system_type pfm_fs_ty
 	.name     = "pfmfs",
 	.get_sb   = pfmfs_get_sb,
 	.kill_sb  = kill_anon_super,
+	FS_TYPE_INIT(pfm_fs),
 };
 
 DEFINE_PER_CPU(unsigned long, pfm_syst_info);
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -645,6 +645,7 @@ static struct file_system_type spufs_typ
 	.name = "spufs",
 	.get_sb = spufs_get_sb,
 	.kill_sb = kill_litter_super,
+	FS_TYPE_INIT(spufs),
 };
 
 static int __init spufs_init(void)
Index: linux-2.6/arch/s390/hypfs/inode.c
===================================================================
--- linux-2.6.orig/arch/s390/hypfs/inode.c
+++ linux-2.6/arch/s390/hypfs/inode.c
@@ -453,7 +453,8 @@ static struct file_system_type hypfs_typ
 	.owner		= THIS_MODULE,
 	.name		= "s390_hypfs",
 	.get_sb		= hypfs_get_super,
-	.kill_sb	= hypfs_kill_super
+	.kill_sb	= hypfs_kill_super,
+	FS_TYPE_INIT(hypfs),
 };
 
 static struct super_operations hypfs_s_ops = {
Index: linux-2.6/drivers/infiniband/core/uverbs_main.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/core/uverbs_main.c
+++ linux-2.6/drivers/infiniband/core/uverbs_main.c
@@ -829,7 +829,8 @@ static struct file_system_type uverbs_ev
 	/* No owner field so module can be unloaded */
 	.name    = "infinibandeventfs",
 	.get_sb  = uverbs_event_get_sb,
-	.kill_sb = kill_litter_super
+	.kill_sb = kill_litter_super,
+	FS_TYPE_INIT(uverbs_event_fs),
 };
 
 static int __init ib_uverbs_init(void)
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -602,6 +602,7 @@ static struct file_system_type ipathfs_f
 	.name =		"ipathfs",
 	.get_sb =	ipathfs_get_sb,
 	.kill_sb =	ipathfs_kill_super,
+	FS_TYPE_INIT(ipathfs_fs),
 };
 
 int __init ipath_init_ipathfs(void)
Index: linux-2.6/drivers/isdn/capi/capifs.c
===================================================================
--- linux-2.6.orig/drivers/isdn/capi/capifs.c
+++ linux-2.6/drivers/isdn/capi/capifs.c
@@ -131,6 +131,7 @@ static struct file_system_type capifs_fs
 	.name		= "capifs",
 	.get_sb		= capifs_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(capifs_fs),
 };
 
 static struct dentry *get_node(int num)
Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -3017,6 +3017,7 @@ static struct file_system_type kvm_fs_ty
 	.name		= "kvmfs",
 	.get_sb		= kvmfs_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(kvm_fs),
 };
 
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
Index: linux-2.6/drivers/misc/ibmasm/ibmasmfs.c
===================================================================
--- linux-2.6.orig/drivers/misc/ibmasm/ibmasmfs.c
+++ linux-2.6/drivers/misc/ibmasm/ibmasmfs.c
@@ -109,6 +109,7 @@ static struct file_system_type ibmasmfs_
 	.name           = "ibmasmfs",
 	.get_sb         = ibmasmfs_get_super,
 	.kill_sb        = kill_litter_super,
+	FS_TYPE_INIT(ibmasmfs),
 };
 
 static int ibmasmfs_fill_super (struct super_block *sb, void *data, int silent)
Index: linux-2.6/drivers/oprofile/oprofilefs.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/oprofilefs.c
+++ linux-2.6/drivers/oprofile/oprofilefs.c
@@ -284,6 +284,7 @@ static struct file_system_type oprofilef
 	.name		= "oprofilefs",
 	.get_sb		= oprofilefs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(oprofilefs),
 };
 
 
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -552,6 +552,7 @@ static struct file_system_type usb_fs_ty
 	.name =		"usbfs",
 	.get_sb =	usb_get_sb,
 	.kill_sb =	kill_litter_super,
+	FS_TYPE_INIT(usb_fs),
 };
 
 /* --------------------------------------------------------------------- */
Index: linux-2.6/drivers/usb/gadget/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/inode.c
+++ linux-2.6/drivers/usb/gadget/inode.c
@@ -2132,6 +2132,7 @@ static struct file_system_type gadgetfs_
 	.name		= shortname,
 	.get_sb		= gadgetfs_get_sb,
 	.kill_sb	= gadgetfs_kill_sb,
+	FS_TYPE_INIT(gadgetfs),
 };
 
 /*----------------------------------------------------------------------*/
Index: linux-2.6/fs/9p/vfs_super.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_super.c
+++ linux-2.6/fs/9p/vfs_super.c
@@ -275,4 +275,5 @@ struct file_system_type v9fs_fs_type = {
 	.get_sb = v9fs_get_sb,
 	.kill_sb = v9fs_kill_super,
 	.owner = THIS_MODULE,
+	FS_TYPE_INIT(v9fs_fs),
 };
Index: linux-2.6/fs/adfs/super.c
===================================================================
--- linux-2.6.orig/fs/adfs/super.c
+++ linux-2.6/fs/adfs/super.c
@@ -479,6 +479,7 @@ static struct file_system_type adfs_fs_t
 	.get_sb		= adfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(adfs_fs),
 };
 
 static int __init init_adfs_fs(void)
Index: linux-2.6/fs/affs/super.c
===================================================================
--- linux-2.6.orig/fs/affs/super.c
+++ linux-2.6/fs/affs/super.c
@@ -538,6 +538,7 @@ static struct file_system_type affs_fs_t
 	.get_sb		= affs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(affs_fs),
 };
 
 static int __init init_affs_fs(void)
Index: linux-2.6/fs/afs/super.c
===================================================================
--- linux-2.6.orig/fs/afs/super.c
+++ linux-2.6/fs/afs/super.c
@@ -43,6 +43,7 @@ struct file_system_type afs_fs_type = {
 	.get_sb		= afs_get_sb,
 	.kill_sb	= kill_anon_super,
 	.fs_flags	= 0,
+	FS_TYPE_INIT(afs_fs),
 };
 
 static const struct super_operations afs_super_ops = {
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -47,6 +47,7 @@ static struct file_system_type anon_inod
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(anon_inode_fs),
 };
 static struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
Index: linux-2.6/fs/autofs/init.c
===================================================================
--- linux-2.6.orig/fs/autofs/init.c
+++ linux-2.6/fs/autofs/init.c
@@ -25,6 +25,7 @@ static struct file_system_type autofs_fs
 	.name		= "autofs",
 	.get_sb		= autofs_get_sb,
 	.kill_sb	= autofs_kill_sb,
+	FS_TYPE_INIT(autofs_fs),
 };
 
 static int __init init_autofs_fs(void)
Index: linux-2.6/fs/autofs4/init.c
===================================================================
--- linux-2.6.orig/fs/autofs4/init.c
+++ linux-2.6/fs/autofs4/init.c
@@ -25,6 +25,7 @@ static struct file_system_type autofs_fs
 	.name		= "autofs",
 	.get_sb		= autofs_get_sb,
 	.kill_sb	= autofs4_kill_sb,
+	FS_TYPE_INIT(autofs_fs),
 };
 
 static int __init init_autofs4_fs(void)
Index: linux-2.6/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6.orig/fs/befs/linuxvfs.c
+++ linux-2.6/fs/befs/linuxvfs.c
@@ -914,6 +914,7 @@ static struct file_system_type befs_fs_t
 	.get_sb		= befs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,	
+	FS_TYPE_INIT(befs_fs),
 };
 
 static int __init
Index: linux-2.6/fs/bfs/inode.c
===================================================================
--- linux-2.6.orig/fs/bfs/inode.c
+++ linux-2.6/fs/bfs/inode.c
@@ -417,6 +417,7 @@ static struct file_system_type bfs_fs_ty
 	.get_sb		= bfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(bfs_fs),
 };
 
 static int __init init_bfs_fs(void)
Index: linux-2.6/fs/binfmt_misc.c
===================================================================
--- linux-2.6.orig/fs/binfmt_misc.c
+++ linux-2.6/fs/binfmt_misc.c
@@ -742,6 +742,7 @@ static struct file_system_type bm_fs_typ
 	.name		= "binfmt_misc",
 	.get_sb		= bm_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(bm_fs),
 };
 
 static int __init init_misc_binfmt(void)
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -506,6 +506,7 @@ static struct file_system_type bd_type =
 	.name		= "bdev",
 	.get_sb		= bd_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(bd),
 };
 
 static struct vfsmount *bd_mnt __read_mostly;
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c
+++ linux-2.6/fs/cifs/cifsfs.c
@@ -552,6 +552,7 @@ static struct file_system_type cifs_fs_t
 	.get_sb = cifs_get_sb,
 	.kill_sb = kill_anon_super,
 	/*  .fs_flags */
+	FS_TYPE_INIT(cifs_fs),
 };
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
Index: linux-2.6/fs/coda/inode.c
===================================================================
--- linux-2.6.orig/fs/coda/inode.c
+++ linux-2.6/fs/coda/inode.c
@@ -316,5 +316,6 @@ struct file_system_type coda_fs_type = {
 	.get_sb		= coda_get_sb,
 	.kill_sb	= kill_anon_super,
 	.fs_flags	= FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(coda_fs),
 };
 
Index: linux-2.6/fs/configfs/mount.c
===================================================================
--- linux-2.6.orig/fs/configfs/mount.c
+++ linux-2.6/fs/configfs/mount.c
@@ -114,6 +114,7 @@ static struct file_system_type configfs_
 	.name		= "configfs",
 	.get_sb		= configfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(configfs_fs),
 };
 
 int configfs_pin_fs(void)
Index: linux-2.6/fs/cramfs/inode.c
===================================================================
--- linux-2.6.orig/fs/cramfs/inode.c
+++ linux-2.6/fs/cramfs/inode.c
@@ -542,6 +542,7 @@ static struct file_system_type cramfs_fs
 	.get_sb		= cramfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(cramfs_fs),
 };
 
 static int __init init_cramfs_fs(void)
Index: linux-2.6/fs/debugfs/inode.c
===================================================================
--- linux-2.6.orig/fs/debugfs/inode.c
+++ linux-2.6/fs/debugfs/inode.c
@@ -142,6 +142,7 @@ static struct file_system_type debug_fs_
 	.name =		"debugfs",
 	.get_sb =	debug_get_sb,
 	.kill_sb =	kill_litter_super,
+	FS_TYPE_INIT(debug_fs),
 };
 
 static int debugfs_create_by_name(const char *name, mode_t mode,
Index: linux-2.6/fs/devpts/inode.c
===================================================================
--- linux-2.6.orig/fs/devpts/inode.c
+++ linux-2.6/fs/devpts/inode.c
@@ -141,6 +141,7 @@ static struct file_system_type devpts_fs
 	.name		= "devpts",
 	.get_sb		= devpts_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(devpts_fs),
 };
 
 /*
Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c
+++ linux-2.6/fs/ecryptfs/main.c
@@ -570,7 +570,8 @@ static struct file_system_type ecryptfs_
 	.name = "ecryptfs",
 	.get_sb = ecryptfs_get_sb,
 	.kill_sb = ecryptfs_kill_block_super,
-	.fs_flags = 0
+	.fs_flags = 0,
+	FS_TYPE_INIT(ecryptfs_fs),
 };
 
 /**
Index: linux-2.6/fs/efs/super.c
===================================================================
--- linux-2.6.orig/fs/efs/super.c
+++ linux-2.6/fs/efs/super.c
@@ -30,6 +30,7 @@ static struct file_system_type efs_fs_ty
 	.get_sb		= efs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(efs_fs),
 };
 
 static struct pt_types sgi_pt_types[] = {
Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c
+++ linux-2.6/fs/ext2/super.c
@@ -1267,6 +1267,7 @@ static struct file_system_type ext2_fs_t
 	.get_sb		= ext2_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(ext2_fs),
 };
 
 static int __init init_ext2_fs(void)
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -2747,6 +2747,7 @@ static struct file_system_type ext3_fs_t
 	.get_sb		= ext3_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(ext3_fs),
 };
 
 static int __init init_ext3_fs(void)
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -2822,6 +2822,7 @@ static struct file_system_type ext4dev_f
 	.get_sb		= ext4_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(ext4dev_fs),
 };
 
 static int __init init_ext4_fs(void)
Index: linux-2.6/fs/freevxfs/vxfs_super.c
===================================================================
--- linux-2.6.orig/fs/freevxfs/vxfs_super.c
+++ linux-2.6/fs/freevxfs/vxfs_super.c
@@ -255,6 +255,7 @@ static struct file_system_type vxfs_fs_t
 	.get_sb		= vxfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(vxfs_fs),
 };
 
 static int __init
Index: linux-2.6/fs/fuse/control.c
===================================================================
--- linux-2.6.orig/fs/fuse/control.c
+++ linux-2.6/fs/fuse/control.c
@@ -209,6 +209,7 @@ static struct file_system_type fuse_ctl_
 	.name		= "fusectl",
 	.get_sb		= fuse_ctl_get_sb,
 	.kill_sb	= fuse_ctl_kill_sb,
+	FS_TYPE_INIT(fuse_ctl_fs),
 };
 
 int __init fuse_ctl_init(void)
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c
+++ linux-2.6/fs/fuse/inode.c
@@ -641,6 +641,7 @@ static struct file_system_type fuse_fs_t
 	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(fuse_fs),
 };
 
 #ifdef CONFIG_BLOCK
@@ -658,6 +659,7 @@ static struct file_system_type fuseblk_f
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	FS_TYPE_INIT(fuseblk_fs),
 };
 
 static inline int register_fuseblk(void)
Index: linux-2.6/fs/gfs2/ops_fstype.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_fstype.c
+++ linux-2.6/fs/gfs2/ops_fstype.c
@@ -917,6 +917,7 @@ struct file_system_type gfs2_fs_type = {
 	.get_sb = gfs2_get_sb,
 	.kill_sb = gfs2_kill_sb,
 	.owner = THIS_MODULE,
+	FS_TYPE_INIT(gfs2_fs),
 };
 
 struct file_system_type gfs2meta_fs_type = {
@@ -925,5 +926,6 @@ struct file_system_type gfs2meta_fs_type
 	.get_sb = gfs2_get_sb_meta,
 	.kill_sb = gfs2_kill_sb_meta,
 	.owner = THIS_MODULE,
+	FS_TYPE_INIT(gfs2meta_fs),
 };
 
Index: linux-2.6/fs/hfs/super.c
===================================================================
--- linux-2.6.orig/fs/hfs/super.c
+++ linux-2.6/fs/hfs/super.c
@@ -428,6 +428,7 @@ static struct file_system_type hfs_fs_ty
 	.get_sb		= hfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(hfs_fs),
 };
 
 static void hfs_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
Index: linux-2.6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/super.c
+++ linux-2.6/fs/hfsplus/super.c
@@ -464,6 +464,7 @@ static struct file_system_type hfsplus_f
 	.get_sb		= hfsplus_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(hfsplus_fs),
 };
 
 static void hfsplus_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c
+++ linux-2.6/fs/hostfs/hostfs_kern.c
@@ -1022,6 +1022,7 @@ static struct file_system_type hostfs_ty
 	.get_sb 	= hostfs_read_sb,
 	.kill_sb	= kill_anon_super,
 	.fs_flags 	= 0,
+	FS_TYPE_INIT(hostfs),
 };
 
 static int __init init_hostfs(void)
Index: linux-2.6/fs/hpfs/super.c
===================================================================
--- linux-2.6.orig/fs/hpfs/super.c
+++ linux-2.6/fs/hpfs/super.c
@@ -668,6 +668,7 @@ static struct file_system_type hpfs_fs_t
 	.get_sb		= hpfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(hpfs_fs),
 };
 
 static int __init init_hpfs_fs(void)
Index: linux-2.6/fs/hppfs/hppfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hppfs/hppfs_kern.c
+++ linux-2.6/fs/hppfs/hppfs_kern.c
@@ -781,6 +781,7 @@ static struct file_system_type hppfs_typ
 	.get_sb 	= hppfs_read_super,
 	.kill_sb	= kill_anon_super,
 	.fs_flags 	= 0,
+	FS_TYPE_INIT(hppfs),
 };
 
 static int __init init_hppfs(void)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -725,6 +725,7 @@ static struct file_system_type hugetlbfs
 	.name		= "hugetlbfs",
 	.get_sb		= hugetlbfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(hugetlbfs_fs),
 };
 
 static struct vfsmount *hugetlbfs_vfsmount;
Index: linux-2.6/fs/inotify_user.c
===================================================================
--- linux-2.6.orig/fs/inotify_user.c
+++ linux-2.6/fs/inotify_user.c
@@ -691,6 +691,7 @@ static struct file_system_type inotify_f
     .name           = "inotifyfs",
     .get_sb         = inotify_get_sb,
     .kill_sb        = kill_anon_super,
+    FS_TYPE_INIT(inotify_fs),
 };
 
 /*
Index: linux-2.6/fs/isofs/inode.c
===================================================================
--- linux-2.6.orig/fs/isofs/inode.c
+++ linux-2.6/fs/isofs/inode.c
@@ -1407,6 +1407,7 @@ static struct file_system_type iso9660_f
 	.get_sb		= isofs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(iso9660_fs),
 };
 
 static int __init init_iso9660_fs(void)
Index: linux-2.6/fs/jffs2/super.c
===================================================================
--- linux-2.6.orig/fs/jffs2/super.c
+++ linux-2.6/fs/jffs2/super.c
@@ -161,6 +161,7 @@ static struct file_system_type jffs2_fs_
 	.name =		"jffs2",
 	.get_sb =	jffs2_get_sb,
 	.kill_sb =	jffs2_kill_sb,
+	FS_TYPE_INIT(jffs2_fs),
 };
 
 static int __init init_jffs2_fs(void)
Index: linux-2.6/fs/jfs/super.c
===================================================================
--- linux-2.6.orig/fs/jfs/super.c
+++ linux-2.6/fs/jfs/super.c
@@ -746,6 +746,7 @@ static struct file_system_type jfs_fs_ty
 	.get_sb		= jfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(jfs_fs),
 };
 
 static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
Index: linux-2.6/fs/minix/inode.c
===================================================================
--- linux-2.6.orig/fs/minix/inode.c
+++ linux-2.6/fs/minix/inode.c
@@ -597,6 +597,7 @@ static struct file_system_type minix_fs_
 	.get_sb		= minix_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(minix_fs),
 };
 
 static int __init init_minix_fs(void)
Index: linux-2.6/fs/msdos/namei.c
===================================================================
--- linux-2.6.orig/fs/msdos/namei.c
+++ linux-2.6/fs/msdos/namei.c
@@ -684,6 +684,7 @@ static struct file_system_type msdos_fs_
 	.get_sb		= msdos_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(msdos_fs),
 };
 
 static int __init init_msdos_fs(void)
Index: linux-2.6/fs/ncpfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/inode.c
+++ linux-2.6/fs/ncpfs/inode.c
@@ -982,6 +982,7 @@ static struct file_system_type ncp_fs_ty
 	.name		= "ncpfs",
 	.get_sb		= ncp_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(ncp_fs),
 };
 
 static int __init init_ncp_fs(void)
Index: linux-2.6/fs/nfs/super.c
===================================================================
--- linux-2.6.orig/fs/nfs/super.c
+++ linux-2.6/fs/nfs/super.c
@@ -72,6 +72,7 @@ static struct file_system_type nfs_fs_ty
 	.get_sb		= nfs_get_sb,
 	.kill_sb	= nfs_kill_super,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(nfs_fs),
 };
 
 struct file_system_type nfs_xdev_fs_type = {
@@ -80,6 +81,7 @@ struct file_system_type nfs_xdev_fs_type
 	.get_sb		= nfs_xdev_get_sb,
 	.kill_sb	= nfs_kill_super,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(nfs_xdev_fs),
 };
 
 static const struct super_operations nfs_sops = {
@@ -108,6 +110,7 @@ static struct file_system_type nfs4_fs_t
 	.get_sb		= nfs4_get_sb,
 	.kill_sb	= nfs4_kill_super,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(nfs4_fs),
 };
 
 struct file_system_type nfs4_xdev_fs_type = {
@@ -116,6 +119,7 @@ struct file_system_type nfs4_xdev_fs_typ
 	.get_sb		= nfs4_xdev_get_sb,
 	.kill_sb	= nfs4_kill_super,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(nfs4_xdev_fs),
 };
 
 struct file_system_type nfs4_referral_fs_type = {
@@ -124,6 +128,7 @@ struct file_system_type nfs4_referral_fs
 	.get_sb		= nfs4_referral_get_sb,
 	.kill_sb	= nfs4_kill_super,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(nfs4_referral_fs),
 };
 
 static const struct super_operations nfs4_sops = {
Index: linux-2.6/fs/nfsd/nfsctl.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsctl.c
+++ linux-2.6/fs/nfsd/nfsctl.c
@@ -673,6 +673,7 @@ static struct file_system_type nfsd_fs_t
 	.name		= "nfsd",
 	.get_sb		= nfsd_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(nfsd_fs),
 };
 
 static int __init init_nfsd(void)
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c
+++ linux-2.6/fs/ntfs/super.c
@@ -3111,6 +3111,7 @@ static struct file_system_type ntfs_fs_t
 	.get_sb		= ntfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(ntfs_fs),
 };
 
 /* Stable names for the slab caches. */
Index: linux-2.6/fs/ocfs2/dlm/dlmfs.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlm/dlmfs.c
+++ linux-2.6/fs/ocfs2/dlm/dlmfs.c
@@ -579,6 +579,7 @@ static struct file_system_type dlmfs_fs_
 	.name		= "ocfs2_dlmfs",
 	.get_sb		= dlmfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(dlmfs_fs),
 };
 
 static int __init init_dlmfs_fs(void)
Index: linux-2.6/fs/ocfs2/super.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/super.c
+++ linux-2.6/fs/ocfs2/super.c
@@ -707,7 +707,8 @@ static struct file_system_type ocfs2_fs_
 					     * right now, but do we
 					     * need to change that? */
 	.fs_flags       = FS_REQUIRES_DEV|FS_RENAME_DOES_D_MOVE,
-	.next           = NULL
+	.next           = NULL,
+	FS_TYPE_INIT(ocfs2_fs),
 };
 
 static int ocfs2_parse_options(struct super_block *sb,
Index: linux-2.6/fs/openpromfs/inode.c
===================================================================
--- linux-2.6.orig/fs/openpromfs/inode.c
+++ linux-2.6/fs/openpromfs/inode.c
@@ -413,6 +413,7 @@ static struct file_system_type openprom_
 	.name		= "openpromfs",
 	.get_sb		= openprom_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(openprom_fs),
 };
 
 static void op_inode_init_once(void *data, struct kmem_cache * cachep, unsigned long flags)
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -1050,6 +1050,7 @@ static struct file_system_type pipe_fs_t
 	.name		= "pipefs",
 	.get_sb		= pipefs_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(pipe_fs),
 };
 
 static int __init init_pipe_fs(void)
Index: linux-2.6/fs/proc/root.c
===================================================================
--- linux-2.6.orig/fs/proc/root.c
+++ linux-2.6/fs/proc/root.c
@@ -44,6 +44,7 @@ static struct file_system_type proc_fs_t
 	.name		= "proc",
 	.get_sb		= proc_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(proc_fs),
 };
 
 void __init proc_root_init(void)
Index: linux-2.6/fs/qnx4/inode.c
===================================================================
--- linux-2.6.orig/fs/qnx4/inode.c
+++ linux-2.6/fs/qnx4/inode.c
@@ -569,6 +569,7 @@ static struct file_system_type qnx4_fs_t
 	.get_sb		= qnx4_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(qnx4_fs),
 };
 
 static int __init init_qnx4_fs(void)
Index: linux-2.6/fs/ramfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ramfs/inode.c
+++ linux-2.6/fs/ramfs/inode.c
@@ -200,11 +200,13 @@ static struct file_system_type ramfs_fs_
 	.name		= "ramfs",
 	.get_sb		= ramfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(ramfs_fs),
 };
 static struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
 	.get_sb		= rootfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(rootfs_fs),
 };
 
 static int __init init_ramfs_fs(void)
Index: linux-2.6/fs/reiserfs/super.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/super.c
+++ linux-2.6/fs/reiserfs/super.c
@@ -2165,6 +2165,7 @@ struct file_system_type reiserfs_fs_type
 	.get_sb = get_super_block,
 	.kill_sb = reiserfs_kill_sb,
 	.fs_flags = FS_REQUIRES_DEV,
+	FS_TYPE_INIT(reiserfs_fs),
 };
 
 MODULE_DESCRIPTION("ReiserFS journaled filesystem");
Index: linux-2.6/fs/romfs/inode.c
===================================================================
--- linux-2.6.orig/fs/romfs/inode.c
+++ linux-2.6/fs/romfs/inode.c
@@ -617,6 +617,7 @@ static struct file_system_type romfs_fs_
 	.get_sb		= romfs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(romfs_fs),
 };
 
 static int __init init_romfs_fs(void)
Index: linux-2.6/fs/smbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/smbfs/inode.c
+++ linux-2.6/fs/smbfs/inode.c
@@ -790,6 +790,7 @@ static struct file_system_type smb_fs_ty
 	.get_sb		= smb_get_sb,
 	.kill_sb	= kill_anon_super,
 	.fs_flags	= FS_BINARY_MOUNTDATA,
+	FS_TYPE_INIT(smb_fs),
 };
 
 static int __init init_smb_fs(void)
Index: linux-2.6/fs/sysfs/mount.c
===================================================================
--- linux-2.6.orig/fs/sysfs/mount.c
+++ linux-2.6/fs/sysfs/mount.c
@@ -86,6 +86,7 @@ static struct file_system_type sysfs_fs_
 	.name		= "sysfs",
 	.get_sb		= sysfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(sysfs_fs),
 };
 
 int __init sysfs_init(void)
Index: linux-2.6/fs/sysv/super.c
===================================================================
--- linux-2.6.orig/fs/sysv/super.c
+++ linux-2.6/fs/sysv/super.c
@@ -518,6 +518,7 @@ static struct file_system_type sysv_fs_t
 	.get_sb		= sysv_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(sysv_fs),
 };
 
 static struct file_system_type v7_fs_type = {
@@ -526,6 +527,7 @@ static struct file_system_type v7_fs_typ
 	.get_sb		= v7_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(v7_fs),
 };
 
 static int __init init_sysv_fs(void)
Index: linux-2.6/fs/udf/super.c
===================================================================
--- linux-2.6.orig/fs/udf/super.c
+++ linux-2.6/fs/udf/super.c
@@ -105,6 +105,7 @@ static struct file_system_type udf_fstyp
 	.get_sb		= udf_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(udf_fstype),
 };
 
 static struct kmem_cache * udf_inode_cachep;
Index: linux-2.6/fs/ufs/super.c
===================================================================
--- linux-2.6.orig/fs/ufs/super.c
+++ linux-2.6/fs/ufs/super.c
@@ -1382,6 +1382,7 @@ static struct file_system_type ufs_fs_ty
 	.get_sb		= ufs_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(ufs_fs),
 };
 
 static int __init init_ufs_fs(void)
Index: linux-2.6/fs/vfat/namei.c
===================================================================
--- linux-2.6.orig/fs/vfat/namei.c
+++ linux-2.6/fs/vfat/namei.c
@@ -1037,6 +1037,7 @@ static struct file_system_type vfat_fs_t
 	.get_sb		= vfat_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(vfat_fs),
 };
 
 static int __init init_vfat_fs(void)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c
@@ -904,6 +904,7 @@ static struct file_system_type xfs_fs_ty
 	.get_sb			= xfs_fs_get_sb,
 	.kill_sb		= kill_block_super,
 	.fs_flags		= FS_REQUIRES_DEV,
+	FS_TYPE_INIT(xfs_fs),
 };
 
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1441,8 +1441,23 @@ struct file_system_type {
 	struct list_head fs_supers;
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
+	struct lock_class_key s_mapping_key;
+	struct lockdep_map s_mapping_map;
 };
 
+#define __CONCAT(x, y)		__CONCAT_I(x, y)
+#define __CONCAT_I(x, y)	__CONCAT_II(x ## y)
+#define __CONCAT_II(res)	res
+
+#define __STRING(x)		__STRING_I(x)
+#define __STRING_I(x)		#x
+
+#define STR_CONCAT(x, y)	__STRING(__CONCAT(x, y))
+
+#define FS_TYPE_INIT(name) \
+	.s_mapping_map = STATIC_LOCKDEP_MAP_INIT(STR_CONCAT(name, _page), \
+			&__CONCAT(name, _type).s_mapping_key)
+
 extern int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -1192,6 +1192,7 @@ static struct file_system_type mqueue_fs
 	.name = "mqueue",
 	.get_sb = mqueue_get_sb,
 	.kill_sb = kill_litter_super,
+	FS_TYPE_INIT(mqueue_fs),
 };
 
 static int msg_max_limit_min = DFLT_MSGMAX;
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -401,6 +401,7 @@ static struct file_system_type cpuset_fs
 	.name = "cpuset",
 	.get_sb = cpuset_get_sb,
 	.kill_sb = kill_litter_super,
+	FS_TYPE_INIT(cpuset_fs),
 };
 
 /* struct cftype:
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -2081,6 +2081,7 @@ static struct file_system_type futex_fs_
 	.name		= "futexfs",
 	.get_sb		= futexfs_get_sb,
 	.kill_sb	= kill_anon_super,
+	FS_TYPE_INIT(futex_fs),
 };
 
 static int __init init(void)
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -2483,6 +2483,7 @@ static struct file_system_type tmpfs_fs_
 	.name		= "tmpfs",
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(tmpfs_fs),
 };
 static struct vfsmount *shm_mnt;
 
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c
+++ linux-2.6/mm/tiny-shmem.c
@@ -24,6 +24,7 @@ static struct file_system_type tmpfs_fs_
 	.name		= "tmpfs",
 	.get_sb		= ramfs_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(tmpfs_fs),
 };
 
 static struct vfsmount *shm_mnt;
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -299,6 +299,7 @@ static struct file_system_type sock_fs_t
 	.name =		"sockfs",
 	.get_sb =	sockfs_get_sb,
 	.kill_sb =	kill_anon_super,
+	FS_TYPE_INIT(sock_fs),
 };
 
 static int sockfs_delete_dentry(struct dentry *dentry)
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c
+++ linux-2.6/net/sunrpc/rpc_pipe.c
@@ -821,6 +821,7 @@ static struct file_system_type rpc_pipe_
 	.name		= "rpc_pipefs",
 	.get_sb		= rpc_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(rpc_pipe_fs),
 };
 
 static void
Index: linux-2.6/security/inode.c
===================================================================
--- linux-2.6.orig/security/inode.c
+++ linux-2.6/security/inode.c
@@ -145,6 +145,7 @@ static struct file_system_type fs_type =
 	.name =		"securityfs",
 	.get_sb =	get_sb,
 	.kill_sb =	kill_litter_super,
+	FS_TYPE_INIT(fs),
 };
 
 static int create_by_name(const char *name, mode_t mode,
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -1426,6 +1426,7 @@ static struct file_system_type sel_fs_ty
 	.name		= "selinuxfs",
 	.get_sb		= sel_get_sb,
 	.kill_sb	= kill_litter_super,
+	FS_TYPE_INIT(sel_fs),
 };
 
 struct vfsmount *selinuxfs_mount;

--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765011AbYJMKJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765011AbYJMKJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763671AbYJMJsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:48:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743AbYJMJsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:48:03 -0400
Subject: vfs: Use const for kernel parser table
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <aviro@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 13 Oct 2008 10:46:57 +0100
Message-Id: <1223891217.25004.41.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a much better version of a previous patch to make the parser
tables constant. Rather than changing the typedef, we put the "const" in
all the various places where its required, allowing the __initconst
exception for nfsroot which was the cause of the previous trouble. This
was posted for review some time ago and I believe its been in -mm since
then.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexander Viro <aviro@redhat.com>

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 690ca7b..2c8b809 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -659,7 +659,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_mode, Opt_debug, Opt_err,
 };
 
-static match_table_t spufs_tokens = {
+static const match_table_t spufs_tokens = {
 	{ Opt_uid,   "uid=%d" },
 	{ Opt_gid,   "gid=%d" },
 	{ Opt_mode,  "mode=%o" },
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 7383781..3631380 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -219,7 +219,7 @@ static int hypfs_release(struct inode *inode, struct file *filp)
 
 enum { opt_uid, opt_gid, opt_err };
 
-static match_table_t hypfs_tokens = {
+static const match_table_t hypfs_tokens = {
 	{opt_uid, "uid=%u"},
 	{opt_gid, "gid=%u"},
 	{opt_err, NULL}
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed7c5f7..5b8b533 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1683,7 +1683,7 @@ enum {
 				   SRP_OPT_SERVICE_ID),
 };
 
-static match_table_t srp_opt_tokens = {
+static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_ID_EXT,		"id_ext=%s" 		},
 	{ SRP_OPT_IOC_GUID,		"ioc_guid=%s" 		},
 	{ SRP_OPT_DGID,			"dgid=%s" 		},
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index db410e9..77fa7a0 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -97,7 +97,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_devuid, "devuid=%u"},
 	{Opt_devgid, "devgid=%u"},
 	{Opt_devmode, "devmode=%o"},
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 047c791..c061c3f 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -55,7 +55,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_debug, "debug=%x"},
 	{Opt_dfltuid, "dfltuid=%u"},
 	{Opt_dfltgid, "dfltgid=%u"},
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 26f3b43..7f83a46 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -157,7 +157,7 @@ static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
 
 enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_err};
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_ownmask, "ownmask=%o"},
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 3a89094..8989c93 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -135,7 +135,7 @@ enum {
 	Opt_verbose, Opt_volume, Opt_ignore, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bs, "bs=%u"},
 	{Opt_mode, "mode=%o"},
 	{Opt_mufs, "mufs"},
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 250d8c4..aee239a 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -64,7 +64,7 @@ enum {
 	afs_opt_vol,
 };
 
-static match_table_t afs_options_list = {
+static const match_table_t afs_options_list = {
 	{ afs_opt_cell,		"cell=%s"	},
 	{ afs_opt_rwpath,	"rwpath"	},
 	{ afs_opt_vol,		"vol=%s"	},
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index dda510d..b70eea1 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -59,7 +59,7 @@ static const struct super_operations autofs_sops = {
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
 
-static match_table_t autofs_tokens = {
+static const match_table_t autofs_tokens = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 7bb3e5b..45d5581 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -213,7 +213,7 @@ static const struct super_operations autofs4_sops = {
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
 	Opt_indirect, Opt_direct, Opt_offset};
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_fd, "fd=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 740f536..9286b2a 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -650,7 +650,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_charset, Opt_debug, Opt_err,
 };
 
-static match_table_t befs_tokens = {
+static const match_table_t befs_tokens = {
 	{Opt_uid, "uid=%d"},
 	{Opt_gid, "gid=%d"},
 	{Opt_charset, "iocharset=%s"},
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 488eb42..92c10ff 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -48,7 +48,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%o"},
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 448dfd5..8ebe9a5 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -211,7 +211,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
 	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
 	{ecryptfs_opt_cipher, "cipher=%s"},
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fd88c7b..647cd88 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -393,7 +393,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f38a5af..399a96a 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -760,7 +760,7 @@ enum {
 	Opt_grpquota
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb940c2..dea8f13 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -919,7 +919,7 @@ enum {
 	Opt_inode_readahead_blks
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_bsd_df, "bsddf"},
 	{Opt_minix_df, "minixdf"},
 	{Opt_grpid, "grpid"},
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 80ff338..d12cdf2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -855,7 +855,7 @@ enum {
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_err,
 };
 
-static match_table_t fat_tokens = {
+static const match_table_t fat_tokens = {
 	{Opt_check_r, "check=relaxed"},
 	{Opt_check_s, "check=strict"},
 	{Opt_check_n, "check=normal"},
@@ -890,14 +890,14 @@ static match_table_t fat_tokens = {
 	{Opt_tz_utc, "tz=UTC"},
 	{Opt_err, NULL},
 };
-static match_table_t msdos_tokens = {
+static const match_table_t msdos_tokens = {
 	{Opt_nodots, "nodots"},
 	{Opt_nodots, "dotsOK=no"},
 	{Opt_dots, "dots"},
 	{Opt_dots, "dotsOK=yes"},
 	{Opt_err, NULL}
 };
-static match_table_t vfat_tokens = {
+static const match_table_t vfat_tokens = {
 	{Opt_charset, "iocharset=%s"},
 	{Opt_shortname_lower, "shortname=lower"},
 	{Opt_shortname_win95, "shortname=win95"},
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d2249f1..6a84388 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -354,7 +354,7 @@ enum {
 	OPT_ERR
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{OPT_FD,			"fd=%u"},
 	{OPT_ROOTMODE,			"rootmode=%o"},
 	{OPT_USER_ID,			"user_id=%u"},
diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index df48333..f96eb90 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -46,7 +46,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_lockproto, "lockproto=%s"},
 	{Opt_locktable, "locktable=%s"},
 	{Opt_hostdata, "hostdata=%s"},
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4abb104..3c7c763 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -173,7 +173,7 @@ enum {
 	opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ opt_uid, "uid=%u" },
 	{ opt_gid, "gid=%u" },
 	{ opt_umask, "umask=%o" },
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 9997cbf..9699c56 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -25,7 +25,7 @@ enum {
 	opt_force, opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{ opt_creator, "creator=%s" },
 	{ opt_type, "type=%s" },
 	{ opt_umask, "umask=%o" },
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index b8ae9c9..29ad461 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -215,7 +215,7 @@ enum {
 	Opt_timeshift, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_help, "help"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f58923..61edc70 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -57,7 +57,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_size,	"size=%s"},
 	{Opt_nr_inodes,	"nr_inodes=%s"},
 	{Opt_mode,	"mode=%o"},
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 26948a6..3f8af0f 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -310,7 +310,7 @@ enum {
 	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_norock, "norock"},
 	{Opt_nojoliet, "nojoliet"},
 	{Opt_unhide, "unhide"},
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 3630718..0dae345 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -199,7 +199,7 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_uid, Opt_gid, Opt_umask
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_integrity, "integrity"},
 	{Opt_nointegrity, "nointegrity"},
 	{Opt_iocharset, "iocharset=%s"},
diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index 46763d1..8478fc2 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -127,7 +127,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t __initdata tokens = {
+static match_table_t __initconst tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rsize, "rsize=%u"},
 	{Opt_wsize, "wsize=%u"},
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e9b2017..ffb6974 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -98,7 +98,7 @@ enum {
 	Opt_err
 };
 
-static match_table_t nfs_mount_option_tokens = {
+static const match_table_t nfs_mount_option_tokens = {
 	{ Opt_userspace, "bg" },
 	{ Opt_userspace, "fg" },
 	{ Opt_userspace, "retry=%s" },
@@ -163,7 +163,7 @@ enum {
 	Opt_xprt_err
 };
 
-static match_table_t nfs_xprt_protocol_tokens = {
+static const match_table_t nfs_xprt_protocol_tokens = {
 	{ Opt_xprt_udp, "udp" },
 	{ Opt_xprt_tcp, "tcp" },
 	{ Opt_xprt_rdma, "rdma" },
@@ -180,7 +180,7 @@ enum {
 	Opt_sec_err
 };
 
-static match_table_t nfs_secflavor_tokens = {
+static const match_table_t nfs_secflavor_tokens = {
 	{ Opt_sec_none, "none" },
 	{ Opt_sec_none, "null" },
 	{ Opt_sec_sys, "sys" },
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 88255d3..70334d8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -157,7 +157,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_barrier, "barrier=%u"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index d29047b..cbf047a 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -346,7 +346,7 @@ enum {
 	Opt_uid, Opt_gid, Opt_umask, Opt_dmask, Opt_fmask
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_umask, "umask=%o"},
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3f49020..9a92203 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -848,7 +848,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_fast_unmount, "fast_unmount"},
 	{Opt_norm_unmount, "norm_unmount"},
 	{Opt_err, NULL},
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5698bbf..e25e701 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -369,7 +369,7 @@ enum {
 	Opt_err, Opt_uforget, Opt_uignore, Opt_gforget, Opt_gignore
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_novrs,	"novrs"},
 	{Opt_nostrict,	"nostrict"},
 	{Opt_bs,	"bs=%u"},
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3141969..e65212d 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -309,7 +309,7 @@ enum {
        Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_type_old, "ufstype=old"},
 	{Opt_type_sunx86, "ufstype=sunx86"},
 	{Opt_type_sun, "ufstype=sun"},
@@ -1233,7 +1233,7 @@ static int ufs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct ufs_sb_info *sbi = UFS_SB(vfs->mnt_sb);
 	unsigned mval = sbi->s_mount_opt & UFS_MOUNT_UFSTYPE;
-	struct match_token *tp = tokens;
+	const struct match_token *tp = tokens;
 
 	while (tp->token != Opt_onerror_panic && tp->token != mval)
 		++tp;
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 18d3c84..7227b2e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -158,7 +158,7 @@ enum {
 	Opt_barrier, Opt_nobarrier, Opt_err
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_err, NULL}
diff --git a/include/linux/parser.h b/include/linux/parser.h
index 7dcd050..ea2281e 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -25,7 +25,7 @@ typedef struct {
 	char *to;
 } substring_t;
 
-int match_token(char *, match_table_t table, substring_t args[]);
+int match_token(char *, const match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
diff --git a/lib/parser.c b/lib/parser.c
index 4f0cbc0..b00d020 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -100,7 +100,7 @@ static int match_one(char *s, const char *p, substring_t args[])
  * format identifiers which will be taken into account when matching the
  * tokens, and whose locations will be returned in the @args array.
  */
-int match_token(char *s, match_table_t table, substring_t args[])
+int match_token(char *s, const match_table_t table, substring_t args[])
 {
 	const struct match_token *p;
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 10e3203..e053e06 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -52,7 +52,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_msize, "msize=%u"},
 	{Opt_legacy, "noextend"},
 	{Opt_trans, "trans=%s"},
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index d652baf..6dabbdb 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -86,7 +86,7 @@ enum {
 	Opt_port, Opt_rfdno, Opt_wfdno, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rfdno, "rfdno=%u"},
 	{Opt_wfdno, "wfdno=%u"},
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4a7374c..1a97cac 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -324,7 +324,7 @@ enum {
 	Opt_rootcontext = 4,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_context, CONTEXT_STR "%s"},
 	{Opt_fscontext, FSCONTEXT_STR "%s"},
 	{Opt_defcontext, DEFCONTEXT_STR "%s"},



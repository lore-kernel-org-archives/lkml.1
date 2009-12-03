Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZLCCx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZLCCx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZLCCx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:53:58 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:60254 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZLCCx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:53:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ELd+iVK+7KNT/8t8Uuriq0QTL09QbQu6HprXLhVXST6D3h4wY01/jnsmuldgmDzBK4
         v7B0y8UgQn8F2bpXKvZCiz9N/ZGfgfudDF0P6jqb2+nXBplVuSmSbT+rRbhuclP0Vhq0
         NzP/u+IagDUAvL63gmMcmJiw2LjeQI54L1/1s=
From: John Daiker <daikerjohn@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Cc: aia21@cantab.net, linux-kernel@vger.kernel.org,
       John Daiker <daikerjohn@gmail.com>
Subject: [PATCH] NTFS: Change string pointers to string constants.
Date: Wed,  2 Dec 2009 18:53:26 -0800
Message-Id: <1259808806-27279-1-git-send-email-daikerjohn@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the KernelJanitors ToDo list, change the following:
char *foo = "bar";   =>   char foo[] = "bar";

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---
 fs/ntfs/attrib.c |    2 +-
 fs/ntfs/inode.c  |    6 ++--
 fs/ntfs/mft.c    |    4 +-
 fs/ntfs/super.c  |   60 +++++++++++++++++++++++++++---------------------------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 50d3b0c..a8aaa48 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -866,7 +866,7 @@ static int ntfs_external_attr_find(const ATTR_TYPE type,
 	ntfschar *al_name;
 	u32 al_name_len;
 	int err = 0;
-	static const char *es = " Unmount and run chkdsk.";
+	static const char es[] = " Unmount and run chkdsk.";
 
 	ni = ctx->ntfs_ino;
 	base_ni = ctx->base_ntfs_ino;
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 9938034..e22aa8c 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1867,7 +1867,7 @@ int ntfs_read_inode_mount(struct inode *vi)
 	} else /* if (!err) */ {
 		ATTR_LIST_ENTRY *al_entry, *next_al_entry;
 		u8 *al_end;
-		static const char *es = "  Not allowed.  $MFT is corrupt.  "
+		static const char es[] = "  Not allowed.  $MFT is corrupt.  "
 				"You should run chkdsk.";
 
 		ntfs_debug("Attribute list attribute found in $MFT.");
@@ -2328,7 +2328,7 @@ int ntfs_show_options(struct seq_file *sf, struct vfsmount *mnt)
 
 #ifdef NTFS_RW
 
-static const char *es = "  Leaving inconsistent metadata.  Unmount and run "
+static const char es[] = "  Leaving inconsistent metadata.  Unmount and run "
 		"chkdsk.";
 
 /**
@@ -2364,7 +2364,7 @@ int ntfs_truncate(struct inode *vi)
 	ntfs_attr_search_ctx *ctx;
 	MFT_RECORD *m;
 	ATTR_RECORD *a;
-	const char *te = "  Leaving file length out of sync with i_size.";
+	const char te[] = "  Leaving file length out of sync with i_size.";
 	int err, mp_size, size_change, alloc_change;
 	u32 attr_len;
 
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 1caa0ef..261a107 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -408,7 +408,7 @@ void __mark_mft_record_dirty(ntfs_inode *ni)
 	__mark_inode_dirty(VFS_I(base_ni), I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 }
 
-static const char *ntfs_please_email = "Please email "
+static const char ntfs_please_email[] = "Please email "
 		"linux-ntfs-dev@lists.sourceforge.net and say that you saw "
 		"this message.  Thank you.";
 
@@ -1105,7 +1105,7 @@ bool ntfs_may_write_mft_record(ntfs_volume *vol, const unsigned long mft_no,
 	return true;
 }
 
-static const char *es = "  Leaving inconsistent metadata.  Unmount and run "
+static const char es[] = "  Leaving inconsistent metadata.  Unmount and run "
 		"chkdsk.";
 
 /**
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 80b0477..e6dcd71 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -461,7 +461,7 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 	 * have occured.
 	 */
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
-		static const char *es = ".  Cannot remount read-write.";
+		static const char es[] = ".  Cannot remount read-write.";
 
 		/* Remounting read-write. */
 		if (NVolErrors(vol)) {
@@ -659,7 +659,7 @@ not_ntfs:
 static struct buffer_head *read_ntfs_boot_sector(struct super_block *sb,
 		const int silent)
 {
-	const char *read_err_str = "Unable to read %s boot sector.";
+	const char read_err_str[] = "Unable to read %s boot sector.";
 	struct buffer_head *bh_primary, *bh_backup;
 	sector_t nr_blocks = NTFS_SB(sb)->nr_blocks;
 
@@ -1768,9 +1768,9 @@ static bool load_system_files(ntfs_volume *vol)
 #ifdef NTFS_RW
 	/* Get mft mirror inode compare the contents of $MFT and $MFTMirr. */
 	if (!load_and_init_mft_mirror(vol) || !check_mft_mirror(vol)) {
-		static const char *es1 = "Failed to load $MFTMirr";
-		static const char *es2 = "$MFTMirr does not match $MFT";
-		static const char *es3 = ".  Run ntfsfix and/or chkdsk.";
+		static const char es1[] = "Failed to load $MFTMirr";
+		static const char es2[] = "$MFTMirr does not match $MFT";
+		static const char es3[] = ".  Run ntfsfix and/or chkdsk.";
 
 		/* If a read-write mount, convert it to a read-only mount. */
 		if (!(sb->s_flags & MS_RDONLY)) {
@@ -1892,11 +1892,11 @@ get_ctx_vol_failed:
 #ifdef NTFS_RW
 	/* Make sure that no unsupported volume flags are set. */
 	if (vol->vol_flags & VOLUME_MUST_MOUNT_RO_MASK) {
-		static const char *es1a = "Volume is dirty";
-		static const char *es1b = "Volume has been modified by chkdsk";
-		static const char *es1c = "Volume has unsupported flags set";
-		static const char *es2a = ".  Run chkdsk and mount in Windows.";
-		static const char *es2b = ".  Mount in Windows.";
+		static const char es1a[] = "Volume is dirty";
+		static const char es1b[] = "Volume has been modified by chkdsk";
+		static const char es1c[] = "Volume has unsupported flags set";
+		static const char es2a[] = ".  Run chkdsk and mount in Windows.";
+		static const char es2b[] = ".  Mount in Windows.";
 		const char *es1, *es2;
 
 		es2 = es2a;
@@ -1938,9 +1938,9 @@ get_ctx_vol_failed:
 	rp = NULL;
 	if (!load_and_check_logfile(vol, &rp) ||
 			!ntfs_is_logfile_clean(vol->logfile_ino, rp)) {
-		static const char *es1a = "Failed to load $LogFile";
-		static const char *es1b = "$LogFile is not clean";
-		static const char *es2 = ".  Mount in Windows.";
+		static const char es1a[] = "Failed to load $LogFile";
+		static const char es1b[] = "$LogFile is not clean";
+		static const char es2[] = ".  Mount in Windows.";
 		const char *es1;
 
 		es1 = !vol->logfile_ino ? es1a : es1b;
@@ -1986,10 +1986,10 @@ get_ctx_vol_failed:
 	 */
 	err = check_windows_hibernation_status(vol);
 	if (unlikely(err)) {
-		static const char *es1a = "Failed to determine if Windows is "
+		static const char es1a[] = "Failed to determine if Windows is "
 				"hibernated";
-		static const char *es1b = "Windows is hibernated";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1b[] = "Windows is hibernated";
+		static const char es2[] = ".  Run chkdsk.";
 		const char *es1;
 
 		es1 = err < 0 ? es1a : es1b;
@@ -2014,9 +2014,9 @@ get_ctx_vol_failed:
 	/* If (still) a read-write mount, mark the volume dirty. */
 	if (!(sb->s_flags & MS_RDONLY) &&
 			ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY)) {
-		static const char *es1 = "Failed to set dirty bit in volume "
+		static const char es1[] = "Failed to set dirty bit in volume "
 				"information flags";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* Convert to a read-only mount. */
 		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2042,8 +2042,8 @@ get_ctx_vol_failed:
 	 */
 	if (!(sb->s_flags & MS_RDONLY) && (vol->major_ver > 1) &&
 			ntfs_set_volume_flags(vol, VOLUME_MOUNTED_ON_NT4)) {
-		static const char *es1 = "Failed to set NT4 compatibility flag";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to set NT4 compatibility flag";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* Convert to a read-only mount. */
 		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2061,8 +2061,8 @@ get_ctx_vol_failed:
 	/* If (still) a read-write mount, empty the logfile. */
 	if (!(sb->s_flags & MS_RDONLY) &&
 			!ntfs_empty_logfile(vol->logfile_ino)) {
-		static const char *es1 = "Failed to empty $LogFile";
-		static const char *es2 = ".  Mount in Windows.";
+		static const char es1[] = "Failed to empty $LogFile";
+		static const char es2[] = ".  Mount in Windows.";
 
 		/* Convert to a read-only mount. */
 		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2101,8 +2101,8 @@ get_ctx_vol_failed:
 #ifdef NTFS_RW
 	/* Find the quota file, load it if present, and set it up. */
 	if (!load_and_init_quota(vol)) {
-		static const char *es1 = "Failed to load $Quota";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to load $Quota";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* If a read-write mount, convert it to a read-only mount. */
 		if (!(sb->s_flags & MS_RDONLY)) {
@@ -2125,8 +2125,8 @@ get_ctx_vol_failed:
 	/* If (still) a read-write mount, mark the quotas out of date. */
 	if (!(sb->s_flags & MS_RDONLY) &&
 			!ntfs_mark_quotas_out_of_date(vol)) {
-		static const char *es1 = "Failed to mark quotas out of date";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to mark quotas out of date";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* Convert to a read-only mount. */
 		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2145,8 +2145,8 @@ get_ctx_vol_failed:
 	 * it, and set it up.
 	 */
 	if (!load_and_init_usnjrnl(vol)) {
-		static const char *es1 = "Failed to load $UsnJrnl";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to load $UsnJrnl";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* If a read-write mount, convert it to a read-only mount. */
 		if (!(sb->s_flags & MS_RDONLY)) {
@@ -2168,9 +2168,9 @@ get_ctx_vol_failed:
 	}
 	/* If (still) a read-write mount, stamp the transaction log. */
 	if (!(sb->s_flags & MS_RDONLY) && !ntfs_stamp_usnjrnl(vol)) {
-		static const char *es1 = "Failed to stamp transaction log "
+		static const char es1[] = "Failed to stamp transaction log "
 				"($UsnJrnl)";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es2[] = ".  Run chkdsk.";
 
 		/* Convert to a read-only mount. */
 		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
-- 
1.6.3.3


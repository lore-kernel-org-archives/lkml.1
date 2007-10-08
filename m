Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXJHVz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXJHVz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXJHVzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:55:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:42587 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXJHVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Plxn8/rQrWTzLNqvE9cQAQa0gmk+uCB9/tCC50NryeFBac7nT9RrdJ14P/nHGqk0eetp/zhgZR/FCA5TI8eg/oFL85UPpvu+xuJ6KxFv2Od427vDuaSuoPA4mPTY5KOyC4MRtIKfMzXvIvmAgh42WTYIbHIOT8NgSPbszEPRPv8=
Message-ID: <470AA75E.7010508@gmail.com>
Date: Tue, 09 Oct 2007 01:55:42 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: aia21@cantab.net
CC: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] NTFS error messages: replace static char pointers by static
 char arrays
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch below contains a small code clean-up for the NTFS driver: all
static char pointers to error message strings have been replaced by 
static char arrays.

Please apply if you like it.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 1c08fef..b883537 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -869,7 +869,7 @@ static int ntfs_external_attr_find(const ATTR_TYPE type,
  	ntfschar *al_name;
  	u32 al_name_len;
  	int err = 0;
-	static const char *es = " Unmount and run chkdsk.";
+	static const char es[] = " Unmount and run chkdsk.";

  	ni = ctx->ntfs_ino;
  	base_ni = ctx->base_ntfs_ino;
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b532a73..82ac179 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1870,7 +1870,7 @@ int ntfs_read_inode_mount(struct inode *vi)
  	} else /* if (!err) */ {
  		ATTR_LIST_ENTRY *al_entry, *next_al_entry;
  		u8 *al_end;
-		static const char *es = "  Not allowed.  $MFT is corrupt.  "
+		static const char es[] = "  Not allowed.  $MFT is corrupt.  "
  				"You should run chkdsk.";

  		ntfs_debug("Attribute list attribute found in $MFT.");
@@ -2332,7 +2332,7 @@ int ntfs_show_options(struct seq_file *sf, struct 
vfsmount *mnt)

  #ifdef NTFS_RW

-static const char *es = "  Leaving inconsistent metadata.  Unmount and 
run "
+static const char es[] = "  Leaving inconsistent metadata.  Unmount and 
run "
  		"chkdsk.";

  /**
@@ -2368,7 +2368,7 @@ int ntfs_truncate(struct inode *vi)
  	ntfs_attr_search_ctx *ctx;
  	MFT_RECORD *m;
  	ATTR_RECORD *a;
-	const char *te = "  Leaving file length out of sync with i_size.";
+	const char te[] = "  Leaving file length out of sync with i_size.";
  	int err, mp_size, size_change, alloc_change;
  	u32 attr_len;

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 2ad5c8b..a560bb0 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -409,7 +409,7 @@ void __mark_mft_record_dirty(ntfs_inode *ni)
  	__mark_inode_dirty(VFS_I(base_ni), I_DIRTY_SYNC | I_DIRTY_DATASYNC);
  }

-static const char *ntfs_please_email = "Please email "
+static const char ntfs_please_email[] = "Please email "
  		"linux-ntfs-dev@lists.sourceforge.net and say that you saw "
  		"this message.  Thank you.";

@@ -1106,7 +1106,7 @@ bool ntfs_may_write_mft_record(ntfs_volume *vol, 
const unsigned long mft_no,
  	return true;
  }

-static const char *es = "  Leaving inconsistent metadata.  Unmount and 
run "
+static const char es[] = "  Leaving inconsistent metadata.  Unmount and 
run "
  		"chkdsk.";

  /**
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 90c4e3a..a03ca16 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -460,7 +460,7 @@ static int ntfs_remount(struct super_block *sb, int 
*flags, char *opt)
  	 * have occured.
  	 */
  	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
-		static const char *es = ".  Cannot remount read-write.";
+		static const char es[] = ".  Cannot remount read-write.";

  		/* Remounting read-write. */
  		if (NVolErrors(vol)) {
@@ -647,7 +647,7 @@ not_ntfs:
  static struct buffer_head *read_ntfs_boot_sector(struct super_block *sb,
  		const int silent)
  {
-	const char *read_err_str = "Unable to read %s boot sector.";
+	const char read_err_str[] = "Unable to read %s boot sector.";
  	struct buffer_head *bh_primary, *bh_backup;
  	sector_t nr_blocks = NTFS_SB(sb)->nr_blocks;

@@ -1756,9 +1756,9 @@ static bool load_system_files(ntfs_volume *vol)
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
@@ -1880,11 +1880,12 @@ get_ctx_vol_failed:
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
+		static const char es2a[] = ".  Run chkdsk and mount in "
+								"Windows.";
+		static const char es2b[] = ".  Mount in Windows.";
  		const char *es1, *es2;

  		es2 = es2a;
@@ -1926,9 +1927,9 @@ get_ctx_vol_failed:
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
@@ -1974,10 +1975,10 @@ get_ctx_vol_failed:
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
@@ -2002,9 +2003,9 @@ get_ctx_vol_failed:
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
@@ -2030,8 +2031,9 @@ get_ctx_vol_failed:
  	 */
  	if (!(sb->s_flags & MS_RDONLY) && (vol->major_ver > 1) &&
  			ntfs_set_volume_flags(vol, VOLUME_MOUNTED_ON_NT4)) {
-		static const char *es1 = "Failed to set NT4 compatibility flag";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to set NT4 compatibility "
+						"flag";
+		static const char es2[] = ".  Run chkdsk.";

  		/* Convert to a read-only mount. */
  		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2049,8 +2051,8 @@ get_ctx_vol_failed:
  	/* If (still) a read-write mount, empty the logfile. */
  	if (!(sb->s_flags & MS_RDONLY) &&
  			!ntfs_empty_logfile(vol->logfile_ino)) {
-		static const char *es1 = "Failed to empty $LogFile";
-		static const char *es2 = ".  Mount in Windows.";
+		static const char es1[] = "Failed to empty $LogFile";
+		static const char es2[] = ".  Mount in Windows.";

  		/* Convert to a read-only mount. */
  		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2089,8 +2091,8 @@ get_ctx_vol_failed:
  #ifdef NTFS_RW
  	/* Find the quota file, load it if present, and set it up. */
  	if (!load_and_init_quota(vol)) {
-		static const char *es1 = "Failed to load $Quota";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to load $Quota";
+		static const char es2[] = ".  Run chkdsk.";

  		/* If a read-write mount, convert it to a read-only mount. */
  		if (!(sb->s_flags & MS_RDONLY)) {
@@ -2113,8 +2115,8 @@ get_ctx_vol_failed:
  	/* If (still) a read-write mount, mark the quotas out of date. */
  	if (!(sb->s_flags & MS_RDONLY) &&
  			!ntfs_mark_quotas_out_of_date(vol)) {
-		static const char *es1 = "Failed to mark quotas out of date";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to mark quotas out of date";
+		static const char es2[] = ".  Run chkdsk.";

  		/* Convert to a read-only mount. */
  		if (!(vol->on_errors & (ON_ERRORS_REMOUNT_RO |
@@ -2133,8 +2135,8 @@ get_ctx_vol_failed:
  	 * it, and set it up.
  	 */
  	if (!load_and_init_usnjrnl(vol)) {
-		static const char *es1 = "Failed to load $UsnJrnl";
-		static const char *es2 = ".  Run chkdsk.";
+		static const char es1[] = "Failed to load $UsnJrnl";
+		static const char es2[] = ".  Run chkdsk.";

  		/* If a read-write mount, convert it to a read-only mount. */
  		if (!(sb->s_flags & MS_RDONLY)) {
@@ -2156,9 +2158,9 @@ get_ctx_vol_failed:
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
@@ -2389,13 +2391,13 @@ static void ntfs_put_super(struct super_block *sb)
  		mutex_unlock(&vol->mft_ino->i_mutex);
  		write_inode_now(vol->mft_ino, 1);
  		if (!list_empty(&sb->s_dirty)) {
-			static const char *_s1 = "inodes";
-			static const char *_s2 = "";
+			static const char _s1[] = "inodes";
+			static const char _s2[] = "";
  			s1 = _s1;
  			s2 = _s2;
  		} else {
-			static const char *_s1 = "mft pages";
-			static const char *_s2 = "They have been thrown "
+			static const char _s1[] = "mft pages";
+			static const char _s2[] = "They have been thrown "
  					"away.  ";
  			s1 = _s1;
  			s2 = _s2;


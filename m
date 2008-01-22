Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYAVDCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYAVDCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYAVDCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:02:34 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64522 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbYAVDCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:02:33 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Subject: ext4 merge plans for 2.6.25
Date: Mon, 21 Jan 2008 22:01:39 -0500
Message-Id: <1200970948-17903-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches have been in the -mm tree for a while, and I
plan to push them to Linus when the 2.6.25 merge window opens.  With
this patch series, it is expected that ext4 format should be settling
down.  We still have delayed allocation and online defrag which aren't
quite ready to merge, but those shouldn't affect the on-disk format.

I don't expect any other on-disk format changes to show up after this
point, but I've been wrong before....  any such changes would have to
have a Really Good Reason, though.  (No, Abhishek Rai's changes
wouldn't count as an on-disk change, since they change layout choices,
but not anything that e2fsck would actually care about.  We may try
merging those into ext4 and see how they play out in the -mm tree;
we'll see.)

						- Ted

P.S.  Yes, the currently released e2fsprogs won't support all of these
format changes yet; again ext4, shouldn't be deployed to production
systems yet, although we do salute those who are willing to be guinea
pigs and play with this code!  Never fear, I'll be working to get
e2fsprogs caught up Real Soon Now.

Adrian Bunk (1):
      ext4/super.c: fix #ifdef's (CONFIG_EXT4_* -> CONFIG_EXT4DEV_*)

Alex Tomas (2):
      ext4: Add new functions for searching extent tree
      ext4: Add multi block allocator for ext4

Aneesh Kumar K.V (23):
      ext4: Introduce ext4_lblk_t
      ext4: Introduce ext4_update_*_feature
      ext4:  Fix sparse warnings.
      ext4: Rename i_file_acl to i_file_acl_lo
      ext4: Rename i_dir_acl to i_size_high
      ext4: Add support for 48 bit inode i_blocks.
      ext4: Support large files
      ext2: Fix the max file size for ext2 file system.
      ext3: Fix the max file size for ext3 file system.
      ext4: Return after ext4_error in case of failures
      ext4: Change the default behaviour on error
      Add buffer head related helper functions
      ext4: add block bitmap validation
      ext4: Check for the correct error return from
      ext4: Make ext4_get_blocks_wrap take the truncate_mutex early.
      ext4: Convert truncate_mutex to read write semaphore.
      ext4: Take read lock during overwrite case.
      ext4: Add EXT4_IOC_MIGRATE ioctl
      ext4: Fix ext4_show_options to show the correct mount options.
      ext4: Add ext4_find_next_bit()
      ext4: Enable the multiblock allocator by default
      ext4: Check for return value from sb_set_blocksize
      ext4: Use the ext4_ext_actual_len() helper function

Avantika Mathur (2):
      ext4: add ext4_group_t, and change all group variables to this type.
      ext4: fixes block group number being set to a negative value

Chris Snook (1):
      jbd2: Remove printk from J_ASSERT to preserve registers during BUG

Coly Li (1):
      ext4: sync up block group descriptor with e2fsprogs.

Dmitry Monakhov (1):
      ext4: fix uniniatilized extent splitting error

Eric Sandeen (6):
      ext4 extents: remove unneeded casts
      ext4: different maxbytes functions for bitmap & extent	files
      ext4: export iov_shorten from kernel for ext4's use
      ext4: store maxbytes for bitmapped  files and return EFBIG as appropriate
      ext4: fix oops on corrupted ext4 mount
      ext4: fix up EXT4FS_DEBUG builds

Girish Shilamkar (1):
      ext4: Add the journal checksum feature

Jan Kara (2):
      ext4: Avoid rec_len overflow with 64KB block size
      jbd2: Fix assertion failure in fs/jbd2/checkpoint.c

Jean Noel Cordenner (2):
      vfs: Add 64 bit i_version support
      ext4: Add inode version support in ext4

Johann Lombardi (1):
      jbd2: jbd2 stats through procfs

Mariusz Kozlowski (1):
      ext4: remove unused code from ext4_find_entry()

Mingming Cao (4):
      jbd2: add lockdep support
      jbd2: Mark jbd2 slabs as SLAB_TEMPORARY
      jbd2: Use round-jiffies() function for the "5 second" ext4/jbd2 wakeup
      jbd2: sparse pointer use of zero as null

Takashi Sato (1):
      ext4:  Support large blocksize up to PAGESIZE



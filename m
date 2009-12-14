Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZLNSGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZLNSGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbZLNSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:06:09 -0500
Received: from kroah.org ([198.145.64.141]:44606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbZLNSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:06:08 -0500
Date: Mon, 14 Dec 2009 10:04:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.8
Message-ID: <20091214180407.GA23705@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.8 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.7 and 2.6.31.8

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4.txt   |   10 
 Makefile                             |    2 
 drivers/scsi/hosts.c                 |   13 
 drivers/scsi/lpfc/lpfc_init.c        |    2 
 drivers/scsi/megaraid/megaraid_sas.c |    8 
 drivers/scsi/qla2xxx/qla_attr.c      |    3 
 drivers/scsi/scsi_lib_dma.c          |    4 
 fs/ext4/balloc.c                     |    8 
 fs/ext4/block_validity.c             |    2 
 fs/ext4/ext4.h                       |  105 ++++-
 fs/ext4/ext4_extents.h               |    7 
 fs/ext4/ext4_jbd2.c                  |    9 
 fs/ext4/ext4_jbd2.h                  |   27 +
 fs/ext4/extents.c                    |  493 ++++++++++++++++++++++--
 fs/ext4/fsync.c                      |   54 +-
 fs/ext4/inode.c                      |  705 ++++++++++++++++++++++++++++++-----
 fs/ext4/ioctl.c                      |   32 -
 fs/ext4/mballoc.c                    |  322 ++++++++-------
 fs/ext4/migrate.c                    |   28 -
 fs/ext4/move_extent.c                |  572 ++++++++++++++++------------
 fs/ext4/namei.c                      |   47 +-
 fs/ext4/resize.c                     |    2 
 fs/ext4/super.c                      |  239 ++++++++---
 fs/ext4/xattr.c                      |   22 -
 fs/jbd2/commit.c                     |    4 
 fs/jbd2/journal.c                    |   11 
 fs/jbd2/transaction.c                |    7 
 include/linux/sched.h                |   13 
 include/scsi/osd_protocol.h          |    1 
 include/scsi/scsi_host.h             |   16 
 include/trace/events/ext4.h          |   60 ++
 31 files changed, 2083 insertions(+), 745 deletions(-)

Akira Fujita (14):
      ext4: Fix wrong comparisons in mext_check_arguments()
      ext4: Remove unneeded BUG_ON() in ext4_move_extents()
      ext4: Return exchanged blocks count to user space in failure
      ext4: Fix small typo for move_extent_per_page()
      ext4: Replace get_ext_path macro with an inline funciton
      ext4: Replace BUG_ON() with ext4_error() in move_extents.c
      ext4: Add null extent check to ext_get_path
      ext4: Fix different block exchange issue in EXT4_IOC_MOVE_EXT
      ext4: fix the returned block count if EXT4_IOC_MOVE_EXT fails
      ext4: fix lock order problem in ext4_move_extents()
      ext4: fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
      ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
      ext4: move_extent_per_page() cleanup
      ext4: Fix insufficient checks in EXT4_IOC_MOVE_EXT

Andreas Dilger (1):
      jbd2: round commit timer up to avoid uncommitted transaction

Andreas Schlick (1):
      ext4: Always set dx_node's fake_dirent explicitly.

Aneesh Kumar K.V (7):
      ext4: Fix memory leak fix when mounting an ext4 filesystem
      ext4: Add missing unlock_new_inode() call in extent migration code
      ext4: Allow rename to create more than EXT4_LINK_MAX subdirectories
      ext4: Take page lock before looking at attached buffer_heads flags
      ext4: move ext4_mb_init_group() function earlier in the mballoc.c
      ext4: check for need init flag in ext4_mb_load_buddy
      ext4: discard preallocation when restarting a transaction during truncate

Christoph Hellwig (1):
      ext4: fix cache flush in ext4_sync_file

Curt Wohlgemuth (3):
      ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
      ext4: Handle nested ext4_journal_start/stop calls without a journal
      ext4: remove blocks from inode prealloc list on failure

Dmitry Monakhov (3):
      ext4: ext4_get_reserved_space() must return bytes instead of blocks
      ext4: quota macros cleanup
      ext4: fix incorrect block reservation on quota transfer.

Eric Sandeen (7):
      ext4: reject too-large filesystems on 32-bit kernels
      ext4: Add feature set check helper for mount & remount paths
      ext4: limit block allocations for indirect-block files to < 2^32
      ext4: retry failed direct IO allocations
      ext4: journal all modifications in ext4_xattr_set_handle
      ext4: make trim/discard optional (and off by default)
      ext4: make "norecovery" an alias for "noload"

Frank Mayhar (2):
      ext4: Make non-journal fsync work properly
      ext4: Avoid updating the inode table bh twice in no journal mode

Greg Kroah-Hartman (1):
      Linux 2.6.31.8

James Bottomley (1):
      SCSI: scsi_lib_dma: fix bug with dma maps on nested scsi objects

Jan Kara (6):
      jbd2: Fail to load a journal if it is too short
      jbd2: Annotate transaction start also for jbd2_journal_restart()
      ext4: Fix possible deadlock between ext4_truncate() and ext4_get_blocks()
      ext4: fix error handling in ext4_ind_get_blocks()
      ext4: Avoid data / filesystem corruption when write fails to copy data
      ext4: Wait for proper transaction commit on fsync

Josef Bacik (1):
      ext4: wait for log to commit when umounting

Julia Lawall (1):
      ext4: fix i_flags access in ext4_da_writepages_trans_blocks()

Kazuya Mio (1):
      ext4: initialize moved_len before calling ext4_move_extents()

Martin Michlmayr (1):
      SCSI: osd_protocol.h: Add missing #include

Mingming (4):
      ext4: fix ext4_ext_direct_IO()'s return value after converting uninit extents
      ext4: skip conversion of uninit extents after direct IO if there isn't any
      ext4: code clean up for dio fallocate handling
      ext4: Fix return value of ext4_split_unwritten_extents() to fix direct I/O

Mingming Cao (4):
      ext4: release reserved quota when block reservation for delalloc retry
      ext4: Split uninitialized extents for direct I/O
      ext4: Use end_io callback to avoid direct I/O fallback to buffered I/O
      ext4: async direct IO for holes and fallocate support

Peng Tao (1):
      ext4: fix journal ref count in move_extent_par_page

Roel Kluin (1):
      ext4: Return the PTR_ERR of the correct pointer in setup_new_group_blocks()

Sebastian Andrzej Siewior (1):
      signal: Fix alternate signal stack check

Theodore Ts'o (28):
      ext4: Avoid null pointer dereference when decoding EROFS w/o a journal
      ext4: Fix bugs in mballoc's stream allocation mode
      ext4: Avoid group preallocation for closed files
      ext4: Limit number of links that can be created by ext4_link()
      ext4: Restore wbc->range_start in ext4_da_writepages()
      ext4: print more sysadmin-friendly message in check_block_validity()
      ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
      ext4: Assure that metadata blocks are written during fsync in no journal mode
      ext4: Don't update superblock write time when filesystem is read-only
      ext4: Fix initalization of s_flex_groups
      ext4: Fix include/trace/events/ext4.h to work with Systemtap
      ext4: store EXT4_EXT_MIGRATE in i_state instead of i_flags
      ext4: Fix the alloc on close after a truncate hueristic
      ext4: Fix hueristic which avoids group preallocation for closed files
      ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks
      ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
      ext4: Fix time encoding with extra epoch bits
      ext4: fix a BUG_ON crash by checking that page has buffers attached to it
      ext4: fix potential buffer head leak when add_dirent_to_buf() returns ENOSPC
      ext4: avoid divide by zero when trying to mount a corrupted file system
      ext4: plug a buffer_head leak in an error path of ext4_iget()
      ext4: make sure directory and symlink blocks are revoked
      ext4: don't update the superblock in ext4_statfs()
      ext4: fix uninit block bitmap initialization when s_meta_first_bg is non-zero
      ext4: fix block validity checks so they work correctly with meta_bg
      ext4: avoid issuing unnecessary barriers
      jbd2: Add ENOMEM checking in and for jbd2_journal_write_metadata_buffer()
      ext4: Fix potential fiemap deadlock (mmap_sem vs. i_data_sem)

Yang, Bo (1):
      SCSI: megaraid_sas: fix 64 bit sense pointer truncation


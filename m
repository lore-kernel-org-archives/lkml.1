Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZLNSG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZLNSG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbZLNSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:06:20 -0500
Received: from kroah.org ([198.145.64.141]:44615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059AbZLNSGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:06:10 -0500
Date: Mon, 14 Dec 2009 10:05:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.1
Message-ID: <20091214180537.GA23807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.1 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.32 and 2.6.32.1

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4.txt   |   10 +
 Makefile                             |    2 
 drivers/scsi/hosts.c                 |   13 +
 drivers/scsi/lpfc/lpfc_init.c        |    2 
 drivers/scsi/megaraid/megaraid_sas.c |    8 -
 drivers/scsi/qla2xxx/qla_attr.c      |    3 
 drivers/scsi/scsi_lib_dma.c          |    4 
 fs/ext4/balloc.c                     |    8 -
 fs/ext4/block_validity.c             |    2 
 fs/ext4/ext4.h                       |    8 +
 fs/ext4/ext4_jbd2.h                  |   21 ++
 fs/ext4/extents.c                    |   22 ++
 fs/ext4/fsync.c                      |   54 ++----
 fs/ext4/inode.c                      |   81 +++++++---
 fs/ext4/ioctl.c                      |   29 ++-
 fs/ext4/mballoc.c                    |   40 ++++-
 fs/ext4/migrate.c                    |    4 
 fs/ext4/move_extent.c                |  278 ++++++++++++++++-------------------
 fs/ext4/namei.c                      |   38 ++--
 fs/ext4/resize.c                     |    2 
 fs/ext4/super.c                      |   40 +++--
 fs/ext4/xattr.c                      |    7 
 fs/jbd2/commit.c                     |    4 
 fs/jbd2/journal.c                    |    5 
 include/linux/sched.h                |   13 +
 include/scsi/osd_protocol.h          |    1 
 include/scsi/scsi_host.h             |   16 +-
 27 files changed, 424 insertions(+), 291 deletions(-)

Akira Fujita (6):
      ext4: fix the returned block count if EXT4_IOC_MOVE_EXT fails
      ext4: fix lock order problem in ext4_move_extents()
      ext4: fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
      ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
      ext4: move_extent_per_page() cleanup
      ext4: Fix insufficient checks in EXT4_IOC_MOVE_EXT

Curt Wohlgemuth (1):
      ext4: remove blocks from inode prealloc list on failure

Dmitry Monakhov (3):
      ext4: ext4_get_reserved_space() must return bytes instead of blocks
      ext4: quota macros cleanup
      ext4: fix incorrect block reservation on quota transfer.

Eric Sandeen (3):
      ext4: journal all modifications in ext4_xattr_set_handle
      ext4: make trim/discard optional (and off by default)
      ext4: make "norecovery" an alias for "noload"

Greg Kroah-Hartman (1):
      Linux 2.6.32.1

James Bottomley (1):
      SCSI: scsi_lib_dma: fix bug with dma maps on nested scsi objects

Jan Kara (3):
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

Roel Kluin (1):
      ext4: Return the PTR_ERR of the correct pointer in setup_new_group_blocks()

Sebastian Andrzej Siewior (1):
      signal: Fix alternate signal stack check

Theodore Ts'o (10):
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZINQQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZINQQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZINQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:16:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:53162 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZINQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:16:25 -0400
Date: Mon, 14 Sep 2009 18:16:27 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] O_SYNC cleanup series
Message-ID: <20090914161627.GC25549@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git osync_cleanup

  to get a patch series that cleans up handling of O_SYNC open flag. After
this patch series, it uses the same code as standard fsync / fdatasync.
  The patch series contains:

Christoph Hellwig (2):
      vfs: Rename generic_file_aio_write_nolock
      fsync: wait for data writeout completion before calling ->fsync

Jan Kara (15):
      vfs: Introduce filemap_fdatawait_range
      vfs: Export __generic_file_aio_write() and add some comments
      vfs: Remove syncing from generic_file_direct_write() and generic_file_buffered_write()
      pohmelfs: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
      ocfs2: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
      vfs: Introduce new helpers for syncing after writing to O_SYNC file or IS_SYNC inode
      ext2: Update comment about generic_osync_inode
      ext3: Remove syncing logic from ext3_file_write
      ext4: Remove syncing logic from ext4_file_write
      ntfs: Use new syncing helpers and update comments
      ocfs2: Update syncing after splicing to match generic version
      xfs: Convert sync_page_range() to simple filemap_write_and_wait_range()
      pohmelfs: Use new syncing helper
      fat: Opencode sync_page_range_nolock()
      vfs: Remove generic_osync_inode() and sync_page_range{_nolock}()

The diffstat is

 drivers/char/raw.c               |    2 +-
 drivers/staging/pohmelfs/inode.c |    6 +-
 fs/block_dev.c                   |   29 ++++++-
 fs/ext2/inode.c                  |    2 +-
 fs/ext3/file.c                   |   61 +-------------
 fs/ext4/file.c                   |   53 +-----------
 fs/fat/file.c                    |   22 +++++-
 fs/fat/misc.c                    |    4 +-
 fs/fs-writeback.c                |   54 ------------
 fs/ntfs/file.c                   |   16 +---
 fs/ntfs/mft.c                    |   13 ++--
 fs/ocfs2/file.c                  |   49 ++++-------
 fs/splice.c                      |   22 ++----
 fs/sync.c                        |   56 +++++++++++--
 fs/xfs/linux-2.6/xfs_lrw.c       |    3 +-
 include/linux/fs.h               |   18 +++--
 include/linux/writeback.h        |    4 -
 mm/filemap.c                     |  170 ++++++++++++--------------------------
 18 files changed, 204 insertions(+), 380 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

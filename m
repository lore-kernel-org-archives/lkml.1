Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZIXOcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZIXOcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIXOck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:32:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZIXOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:32:39 -0400
Date: Thu, 24 Sep 2009 15:32:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] VFS pile 1 - misc bits
Message-ID: <20090924143242.GO14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted VFS patches for .32-rc1, all over the place.  This is *not* all;
there are several series waiting their turn.  That pile should take care
of all misc bits and pieces, provided that I have managed to dig everything
relevant out of the 35K+ mail mound after I'd got back to connectivity...

Please, pull from 
  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Andi Kleen (2):
      vfs: optimization for touch_atime()
      vfs: optimize touch_time() too
Boaz Harrosh (1):
      exofs: remove BKL from super operations
Christoph Hellwig (2):
      freeze_bdev: kill bd_mount_sem
      freeze_bdev: grab active reference to frozen superblocks
Jan Kara (1):
      vfs: split generic_forget_inode() so that hugetlbfs does not have to copy it
Jeff Layton (3):
      vfs: explicitly cast s_maxbytes in fiemap_check_ranges
      vfs: change sb->s_maxbytes to a loff_t
      vfs: remove redundant position check in do_sendfile
Julia Lawall (1):
      fs/romfs: correct error-handling code
Manish Katiyar (1):
      fs/inode.c: add dev-id and inode number for debugging in init_special_inode()
Miklos Szeredi (1):
      vfs: seq_file: add helpers for data filling
Nick Piggin (2):
      truncate: new helpers
      truncate: use new helpers
Steven Rostedt (1):
      libfs: make simple_read_from_buffer conventional
Tetsuo Handa (1):
      seq_file: return a negative error code when seq_path_root() fails.
Thomas Gleixner (1):
      fs: Make unload_nls() NULL pointer safe
Vegard Nossum (1):
      fs: fix overflow in sys_mount() for in-kernel calls
Wu Fengguang (1):
      libfs: return error code on failed attr set

Diffstat:
 Documentation/vm/locking |    2 +-
 fs/attr.c                |   46 ++++++++++++++-
 fs/befs/linuxvfs.c       |    7 +--
 fs/block_dev.c           |  140 ++++++++++++++++++++++++----------------------
 fs/buffer.c              |   10 +---
 fs/cifs/cifsfs.c         |    3 +-
 fs/cifs/inode.c          |   53 +++--------------
 fs/compat.c              |   24 ++++----
 fs/exofs/super.c         |    6 --
 fs/fat/inode.c           |   16 +----
 fs/fuse/dir.c            |   14 +---
 fs/fuse/fuse_i.h         |    2 -
 fs/fuse/inode.c          |   11 +---
 fs/hfs/mdb.c             |    6 +-
 fs/hfsplus/super.c       |    6 +-
 fs/hugetlbfs/inode.c     |   33 +----------
 fs/inode.c               |   89 ++++++++++++++++++-----------
 fs/internal.h            |    1 +
 fs/ioctl.c               |    9 ++-
 fs/isofs/inode.c         |    8 +--
 fs/jfs/super.c           |    9 +--
 fs/libfs.c               |   13 +++-
 fs/namespace.c           |   77 +++++++++++++++----------
 fs/ncpfs/inode.c         |   12 +---
 fs/ncpfs/ioctl.c         |    6 +-
 fs/nfs/inode.c           |   54 ++++-------------
 fs/nls/nls_base.c        |    3 +-
 fs/ntfs/super.c          |   10 +--
 fs/ramfs/file-nommu.c    |   18 ++----
 fs/read_write.c          |    3 -
 fs/romfs/super.c         |    2 +-
 fs/seq_file.c            |   74 +++++++++++++------------
 fs/smbfs/inode.c         |   10 +---
 fs/super.c               |   67 +++++++++++++++++++++-
 include/linux/fs.h       |    8 ++-
 include/linux/mm.h       |    5 +-
 include/linux/seq_file.h |   38 ++++++++++++
 mm/filemap.c             |    2 +-
 mm/memory.c              |   62 +-------------------
 mm/mremap.c              |    4 +-
 mm/nommu.c               |   40 -------------
 mm/truncate.c            |   64 +++++++++++++++++++++
 42 files changed, 533 insertions(+), 534 deletions(-)

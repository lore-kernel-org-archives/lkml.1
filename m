Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYEGL55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYEGL55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYEGL5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:57:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34265 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYEGL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:57:36 -0400
To: akpm@linux-foundation.org
CC: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080506091327.259950960@szeredi.hu> (message from Miklos
	Szeredi on Tue, 06 May 2008 11:13:27 +0200)
Subject: Re: [patch 00/24] vfs: fixes and cleanups + add helpers to check r/o bind mounts
References: <20080506091327.259950960@szeredi.hu>
Message-Id: <E1JtiGr-0004Ot-Dc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 May 2008 13:57:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here it is again as a single series (without the ecryptfs one already
> merged).
> 
> I've addressed Christoph's comments.

And here is the same (well, with some cosmetic fixes) as a git tree,
in case it's more convenient for somebody to review/test.

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups


 fs/attr.c                   |   26 +++++-
 fs/compat.c                 |    4 +-
 fs/ecryptfs/inode.c         |  137 +++++++++++++-------------
 fs/exec.c                   |    2 +-
 fs/fat/file.c               |    5 +-
 fs/hpfs/namei.c             |    3 +-
 fs/namei.c                  |  230 +++++++++++++++++++++++++++----------------
 fs/nfsd/nfs4recover.c       |   12 +--
 fs/nfsd/vfs.c               |  148 ++++++++++++----------------
 fs/open.c                   |  106 ++++++--------------
 fs/reiserfs/namei.c         |    2 +-
 fs/reiserfs/xattr.c         |   32 +++++-
 fs/splice.c                 |   29 +++---
 fs/sysfs/file.c             |    5 +-
 fs/utimes.c                 |  197 ++++++++++++++++++++++---------------
 fs/xattr.c                  |   85 ++++++++--------
 include/linux/fs.h          |   21 +++--
 include/linux/reiserfs_fs.h |    1 +
 include/linux/time.h        |    5 +-
 include/linux/xattr.h       |    5 +-
 ipc/mqueue.c                |   16 ++-
 kernel/cgroup.c             |    5 +-
 mm/filemap.c                |    2 +-
 mm/tiny-shmem.c             |    2 +-
 net/unix/af_unix.c          |    6 +-
 25 files changed, 587 insertions(+), 499 deletions(-)

Miklos Szeredi (25):
      ecryptfs: clean up (un)lock_parent
      nfsd: clean up mnt_want_write calls
      cgroup: don't call vfs_mkdir
      reiserfs: don't call vfs_rmdir
      reiserfs: don't call notify_change
      sysfs: don't call notify_change
      hpfs: don't call notify_change
      fat: don't call notify_change
      vfs: immutable inode checking cleanup
      vfs: truncate: don't check immutable twice
      vfs: truncate: append-only checking cleanup
      vfs: create file_truncate() helper
      vfs: utimes immutable fix
      vfs: utimes cleanup
      vfs: splice remove_suid() cleanup
      vfs: add path_create() and path_mknod()
      vfs: add path_mkdir()
      vfs: add path_rmdir()
      vfs: add path_unlink()
      vfs: add path_symlink()
      vfs: add path_link()
      vfs: add path_rename()
      vfs: add path_setattr()
      vfs: add path_setxattr()
      vfs: add path_removexattr()


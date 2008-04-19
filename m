Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYDSQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYDSQZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYDSQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:25:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42531 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYDSQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:25:44 -0400
Date: Sat, 19 Apr 2008 17:25:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] first part of VFS merges (ro-bind)
Message-ID: <20080419162542.GJ27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The first VFS series of this cycle: ro-bind patches.  FWIW,
I'm not particulary happy with the state of commit messages - practically
all changesets ended up with contributions from at least 2-3 people
(usually Dave/me/Christoph) and commit messages have too many [foo: fixed
bug in bar() noticed by baz] in them.  OTOH, it's bisectable and hopefully
each changeset makes sense, which is one hell of a good reason to fold
fixes into affected changesets, IMO...
	Anyway, please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ ro-bind.b6

Shortlog:
Christoph Hellwig (1):
      merge open_namei() and do_filp_open()

Dave Hansen (23):
      do namei_flags calculation inside open_namei()
      r/o bind mounts: stub functions
      r/o bind mounts: create helper to drop file write access
      r/o bind mounts: drop write during emergency remount
      r/o bind mounts: elevate write count for rmdir and unlink.
      r/o bind mounts: get callers of vfs_mknod/create/mkdir()
      r/o bind mounts: write counts for link/symlink
      r/o bind mounts: get write access for vfs_rename() callers
      r/o bind mounts: elevate write count for xattr_permission() callers
      r/o bind mounts: elevate write count for ncp_ioctl()
      r/o bind mounts: write counts for touch_atime()
      r/o bind mounts: elevate write count for do_utimes()
      r/o bind mounts: write count for file_update_time()
      r/o bind mounts: elevate write count for ioctls()
      r/o bind mounts: elevate write count for open()s
      r/o bind mounts: elevate write count for chmod/chown callers
      r/o bind mounts: write counts for truncate()
      r/o bind mounts: make access() use new r/o helper
      r/o bind mounts: elevate count for xfs timestamp updates
      r/o bind mounts: check mnt instead of superblock directly
      r/o bind mounts: track numbers of writers to mounts
      r/o bind mounts: honor mount writer counts at remount
      r/o bind mounts: debugging for missed calls

Diffstat:
 fs/ext2/ioctl.c              |   57 +++++---
 fs/ext3/ioctl.c              |  103 +++++++++-----
 fs/ext4/ioctl.c              |   86 +++++++-----
 fs/fat/file.c                |   12 +-
 fs/file_table.c              |   42 ++++++-
 fs/hfsplus/ioctl.c           |   38 +++--
 fs/inode.c                   |   51 ++++----
 fs/jfs/ioctl.c               |   33 +++--
 fs/namei.c                   |  275 ++++++++++++++++++++++++++++---------
 fs/namespace.c               |  316 +++++++++++++++++++++++++++++++++++++++++-
 fs/ncpfs/ioctl.c             |   54 +++++++-
 fs/nfs/dir.c                 |    3 +-
 fs/nfsd/nfs4proc.c           |    7 +-
 fs/nfsd/nfs4recover.c        |   16 ++-
 fs/nfsd/nfs4state.c          |    3 +-
 fs/nfsd/vfs.c                |   72 ++++++++--
 fs/ocfs2/ioctl.c             |   11 +-
 fs/open.c                    |  149 ++++++++++++--------
 fs/reiserfs/ioctl.c          |   63 ++++++---
 fs/super.c                   |   24 +++-
 fs/utimes.c                  |   18 ++-
 fs/xattr.c                   |   40 +++++-
 fs/xfs/linux-2.6/xfs_ioctl.c |   15 ++-
 fs/xfs/linux-2.6/xfs_iops.c  |    7 -
 fs/xfs/linux-2.6/xfs_lrw.c   |    9 +-
 include/linux/file.h         |    1 +
 include/linux/fs.h           |   52 +++++++-
 include/linux/mount.h        |   11 ++
 ipc/mqueue.c                 |   25 +++-
 lib/Kconfig.debug            |   10 ++
 net/unix/af_unix.c           |    4 +
 31 files changed, 1256 insertions(+), 351 deletions(-)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbZDCBmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbZDCBmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZDCBmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:42:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56961 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDCBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:42:08 -0400
Date: Fri, 3 Apr 2009 02:42:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] more VFS stuff
Message-ID: <20090403014205.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fs_struct fixes.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (12):
      Kill unsharing fs_struct in __set_personality()
      Get rid of bumping fs_struct refcount in pivot_root(2)
      Take fs_struct handling to new file (fs/fs_struct.c)
      New locking/refcounting for fs_struct
      check_unsafe_exec() doesn't care about signal handlers sharing
      New helper - current_umask()
      Get rid of indirect include of fs_struct.h
      Don't mess with descriptor table in load_elf_binary()
      Trim includes in binfmt_elf
      Don't crap into descriptor table in binfmt_som
      Trim includes of fdtable.h
      Cleanup after commit 585d3bc06f4ca57f975a5a1f698f65a45ea66225

Dmitri Vorobiev (1):
      Remove two unneeded exports and make two symbols static in fs/mpage.c

Diffstat:
 arch/cris/kernel/process.c                |    1 -
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 drivers/char/tty_audit.c                  |    2 -
 drivers/char/tty_ldisc.c                  |    1 -
 fs/Makefile                               |    2 +-
 fs/binfmt_elf.c                           |   22 +----
 fs/binfmt_som.c                           |    7 -
 fs/block_dev.c                            |    1 +
 fs/btrfs/acl.c                            |    2 +-
 fs/btrfs/ioctl.c                          |    2 +-
 fs/buffer.c                               |    1 -
 fs/cifs/dir.c                             |    4 +-
 fs/cifs/inode.c                           |    4 +-
 fs/compat.c                               |   16 +++-
 fs/dcache.c                               |    2 +-
 fs/exec.c                                 |   35 +++++--
 fs/ext2/acl.c                             |    2 +-
 fs/ext3/acl.c                             |    2 +-
 fs/ext4/acl.c                             |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/fs_struct.c                            |  177 +++++++++++++++++++++++++++++
 fs/generic_acl.c                          |    2 +-
 fs/gfs2/acl.c                             |    2 +-
 fs/hfsplus/options.c                      |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/internal.h                             |    8 +-
 fs/jffs2/acl.c                            |    2 +-
 fs/jfs/acl.c                              |    2 +-
 fs/mpage.c                                |   13 ++-
 fs/namei.c                                |   14 +--
 fs/namespace.c                            |   61 +----------
 fs/nfs/nfs3proc.c                         |    6 +-
 fs/nfs/nfs4proc.c                         |    2 +-
 fs/nfsd/nfssvc.c                          |    7 +-
 fs/ocfs2/acl.c                            |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/open.c                                 |    1 +
 fs/proc/base.c                            |    1 +
 fs/proc/task_nommu.c                      |    3 +-
 fs/reiserfs/xattr_acl.c                   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c               |    4 +-
 include/linux/buffer_head.h               |   12 --
 include/linux/fs.h                        |   14 +++
 include/linux/fs_struct.h                 |   10 +-
 include/linux/mnt_namespace.h             |    2 +
 include/linux/mpage.h                     |   10 --
 include/linux/nsproxy.h                   |    1 +
 include/linux/sched.h                     |    3 +-
 init/do_mounts.c                          |    1 +
 ipc/mqueue.c                              |    2 +-
 kernel/auditsc.c                          |    1 +
 kernel/exec_domain.c                      |   23 +----
 kernel/exit.c                             |   32 +-----
 kernel/fork.c                             |   63 +++++------
 kernel/sys.c                              |    1 +
 net/unix/af_unix.c                        |    2 +-
 security/tomoyo/realpath.c                |    1 +
 57 files changed, 337 insertions(+), 268 deletions(-)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYG2AtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYG2AtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYG2AtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:49:13 -0400
Received: from namei.org ([69.55.235.186]:56229 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752444AbYG2AtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:49:12 -0400
Date: Tue, 29 Jul 2008 10:48:08 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [GIT] New Credentials API (preliminary patches for 2.6.27) [updated]
In-Reply-To: <Xine.LNX.4.64.0807260543320.24288@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0807291043190.18657@us.intercode.com.au>
References: <Xine.LNX.4.64.0807260543320.24288@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, James Morris wrote:

> A new credentials framework has been developed by David Howells.  The code 
> has been through several iterations of posting and review, and is 
> considered by various folk to be ready to merge into linux-next.

These patches have been updated by David to resolve conflicts in current 
git, re-tested, and may be pulled cleanly per below.

Also note the original intro email included at the end of this email.

Please pull.

The following changes since commit 63add2f2072e69c1eb7a5f6ca8f415122da889b9:
  Linus Torvalds (1):
        Merge branch 'cpus4096-v2' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git for-linus

David Howells (7):
      Fix setting of PF_SUPERPRIV by __capable() [ver #3]
      KEYS: Disperse linux/key_ui.h [ver #3]
      KEYS: Alter use of key instantiation link-to-keyring argument [ver #3]
      CRED: Neuter sys_capset() [ver #3]
      CRED: Constify the kernel_cap_t arguments to the capset LSM hooks [ver #3]
      CRED: Change current->fs[ug]id to current_fs[ug]id() [ver #3]
      CRED: Wrap most current->e?[ug]id and some task->e?[ug]id [ver #3]

 arch/ia64/kernel/mca_drv.c                |    2 +-
 arch/ia64/kernel/perfmon.c                |   23 ++--
 arch/ia64/kernel/signal.c                 |    4 +-
 arch/mips/kernel/mips-mt-fpaff.c          |    5 +-
 arch/parisc/kernel/signal.c               |    2 +-
 arch/powerpc/mm/fault.c                   |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    4 +-
 arch/s390/hypfs/inode.c                   |    4 +-
 arch/x86/mm/fault.c                       |    2 +-
 drivers/block/loop.c                      |    6 +-
 drivers/char/tty_audit.c                  |    6 +-
 drivers/gpu/drm/drm_fops.c                |    2 +-
 drivers/isdn/capi/capifs.c                |    4 +-
 drivers/media/video/cpia.c                |    2 +-
 drivers/net/tun.c                         |    4 +-
 drivers/net/wan/sbni.c                    |    9 +-
 drivers/usb/core/devio.c                  |    8 +-
 drivers/usb/core/inode.c                  |    4 +-
 fs/9p/fid.c                               |    2 +-
 fs/9p/vfs_inode.c                         |    4 +-
 fs/9p/vfs_super.c                         |    4 +-
 fs/affs/inode.c                           |    4 +-
 fs/affs/super.c                           |    4 +-
 fs/anon_inodes.c                          |    4 +-
 fs/attr.c                                 |    4 +-
 fs/autofs/inode.c                         |    4 +-
 fs/autofs4/inode.c                        |    4 +-
 fs/autofs4/waitq.c                        |    4 +-
 fs/bfs/dir.c                              |    4 +-
 fs/binfmt_elf_fdpic.c                     |    8 +-
 fs/cifs/cifs_fs_sb.h                      |    2 +-
 fs/cifs/cifsproto.h                       |    2 +-
 fs/cifs/connect.c                         |    4 +-
 fs/cifs/dir.c                             |   12 +-
 fs/cifs/inode.c                           |    8 +-
 fs/cifs/ioctl.c                           |    2 +-
 fs/cifs/misc.c                            |    4 +-
 fs/coda/cache.c                           |    6 +-
 fs/coda/upcall.c                          |    2 +-
 fs/devpts/inode.c                         |    4 +-
 fs/dquot.c                                |    4 +-
 fs/ecryptfs/messaging.c                   |   18 ++-
 fs/ecryptfs/miscdev.c                     |   20 ++-
 fs/exec.c                                 |   18 +-
 fs/ext2/balloc.c                          |    2 +-
 fs/ext2/ialloc.c                          |    4 +-
 fs/ext3/balloc.c                          |    2 +-
 fs/ext3/ialloc.c                          |    4 +-
 fs/ext4/balloc.c                          |    3 +-
 fs/ext4/ialloc.c                          |    4 +-
 fs/fat/file.c                             |    2 +-
 fs/fat/inode.c                            |    4 +-
 fs/fcntl.c                                |    2 +-
 fs/fuse/dev.c                             |    4 +-
 fs/gfs2/inode.c                           |   10 +-
 fs/hfs/inode.c                            |    4 +-
 fs/hfs/super.c                            |    4 +-
 fs/hfsplus/inode.c                        |    4 +-
 fs/hfsplus/options.c                      |    4 +-
 fs/hpfs/namei.c                           |   24 ++--
 fs/hpfs/super.c                           |    4 +-
 fs/hugetlbfs/inode.c                      |   16 +-
 fs/inotify_user.c                         |    2 +-
 fs/ioprio.c                               |    4 +-
 fs/jffs2/fs.c                             |    4 +-
 fs/jfs/jfs_inode.c                        |    4 +-
 fs/locks.c                                |    2 +-
 fs/minix/bitmap.c                         |    4 +-
 fs/namei.c                                |   10 +-
 fs/namespace.c                            |    2 +-
 fs/ncpfs/ioctl.c                          |   91 ++++++------
 fs/nfsd/vfs.c                             |    6 +-
 fs/ocfs2/dlm/dlmfs.c                      |    8 +-
 fs/ocfs2/namei.c                          |    4 +-
 fs/omfs/inode.c                           |    8 +-
 fs/open.c                                 |   12 +--
 fs/pipe.c                                 |    4 +-
 fs/posix_acl.c                            |    4 +-
 fs/quota.c                                |    4 +-
 fs/ramfs/inode.c                          |    4 +-
 fs/reiserfs/namei.c                       |    4 +-
 fs/smbfs/dir.c                            |    4 +-
 fs/smbfs/inode.c                          |    2 +-
 fs/smbfs/proc.c                           |    2 +-
 fs/sysv/ialloc.c                          |    4 +-
 fs/ubifs/budget.c                         |    2 +-
 fs/ubifs/dir.c                            |    4 +-
 fs/udf/ialloc.c                           |    4 +-
 fs/udf/namei.c                            |    2 +-
 fs/ufs/ialloc.c                           |    4 +-
 fs/xfs/linux-2.6/xfs_cred.h               |    2 +-
 fs/xfs/linux-2.6/xfs_linux.h              |    4 +-
 fs/xfs/xfs_acl.c                          |    6 +-
 fs/xfs/xfs_attr.c                         |    2 +-
 fs/xfs/xfs_inode.c                        |    4 +-
 fs/xfs/xfs_vnodeops.c                     |    8 +-
 include/keys/keyring-type.h               |   31 ++++
 include/linux/capability.h                |   15 ++-
 include/linux/cred.h                      |   50 ++++++
 include/linux/fs.h                        |    2 +-
 include/linux/key-ui.h                    |   66 --------
 include/linux/key.h                       |   18 +-
 include/linux/keyctl.h                    |    4 +-
 include/linux/sched.h                     |    1 +
 include/linux/security.h                  |  107 +++++++-------
 include/net/scm.h                         |    4 +-
 ipc/mqueue.c                              |    6 +-
 ipc/shm.c                                 |    5 +-
 ipc/util.c                                |   18 ++-
 kernel/acct.c                             |    7 +-
 kernel/auditsc.c                          |    6 +-
 kernel/capability.c                       |  236 ++++-------------------------
 kernel/cgroup.c                           |    9 +-
 kernel/futex.c                            |    8 +-
 kernel/futex_compat.c                     |    3 +-
 kernel/kmod.c                             |    2 +-
 kernel/ptrace.c                           |   20 ++-
 kernel/sched.c                            |   11 +-
 kernel/signal.c                           |   15 +-
 kernel/sys.c                              |   16 +-
 kernel/sysctl.c                           |    2 +-
 kernel/timer.c                            |    8 +-
 kernel/user_namespace.c                   |    2 +-
 mm/mempolicy.c                            |    7 +-
 mm/migrate.c                              |    7 +-
 mm/oom_kill.c                             |    6 +-
 mm/shmem.c                                |    8 +-
 net/9p/client.c                           |    2 +-
 net/ax25/af_ax25.c                        |    2 +-
 net/ax25/ax25_route.c                     |    2 +-
 net/core/dev.c                            |    8 +-
 net/core/scm.c                            |    8 +-
 net/ipv6/ip6_flowlabel.c                  |    2 +-
 net/netrom/af_netrom.c                    |    4 +-
 net/rose/af_rose.c                        |    4 +-
 net/socket.c                              |    4 +-
 net/sunrpc/auth.c                         |    4 +-
 net/unix/af_unix.c                        |   11 +-
 security/capability.c                     |    3 +-
 security/commoncap.c                      |   90 ++++++-----
 security/keys/internal.h                  |   38 ++++-
 security/keys/key.c                       |    2 +-
 security/keys/keyctl.c                    |  120 +++++++++------
 security/keys/keyring.c                   |    1 +
 security/keys/process_keys.c              |   88 +++++++----
 security/keys/request_key.c               |   83 +++++++----
 security/keys/request_key_auth.c          |    7 +-
 security/root_plug.c                      |    3 +-
 security/security.c                       |   28 ++--
 security/selinux/hooks.c                  |   41 ++++--
 security/smack/smack_lsm.c                |   49 ++++--
 151 files changed, 958 insertions(+), 931 deletions(-)
 create mode 100644 include/keys/keyring-type.h
 create mode 100644 include/linux/cred.h
 delete mode 100644 include/linux/key-ui.h


----

Date: Tue, 29 Jul 2008 00:15:39 +0100
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk, casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Subject: [PATCH 0/7] Introduce credentials [ver #3]

Hi James, Andrew, Stephen,

Here are the patches I'd suggest at least considering to send upstream now:

 (1) The fix for PF_SUPERPRIV to prevent task->flags from being corrupted by
     __capable().

 (2) A patch to disperse linux/key_ui.h - it's unnecessary as keyfs went away.

 (3) A patch to alter key instantiation to not alter the keyring subscriptions
     of another process.

 (4) A patch to neuter sys_capset() so that it can't alter another process's
     capabilities.

     [Ver#2] I've added in Andrew Morgan's suggestions to remove the use of
     tasklist_lock to wrap the calls to the LSM capset hooks, and I've removed
     the target pointer from those hooks.  These are unnecessary as capset can
     only affect current from this patch on.

     [Ver#3] I've further replaced target with current entirely and discarded
     the tasklist_lock around the call to task_pid_vnr() as it doesn't seem to
     be necessary, based on ptrace_notify().

 (5) A patch to constify the kern_cap_t pointers in the capset security hooks.

 (6) A patch to wrap most refs to fs[ug]id in macros so that COW creds can be
     introduced later.

 (7) A patch to wrap most refs to e?[ug]id in macros so that COW creds can be
     introduced later.

These patches are against the head of Linus's tree.  A tarball is available
here:

	http://people.redhat.com/~dhowells/cred-for-linus-2.tar.bz2

David


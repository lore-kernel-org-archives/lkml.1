Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYJWQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYJWQtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbYJWQsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:48:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616AbYJWQsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:48:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, jmorris@namei.org, viro@ZenIV.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT Pull Request] Copy on write credentials for Linux [ver #4]
Date: Thu, 23 Oct 2008 17:48:18 +0100
Message-ID: <23256.1224780498@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

These patches form the rest of the copy-on-write credentials code.  You have
incorporated some of the patches, either directly or via other subsystem trees.

These patches are being used as the base for some other work - filesystem local
caching for instance - and a number of security projects are now using these as
a base too (TOMOYA for instance).

You might wish to incorporate these at the end of the window as the wrapper
patches may break other patches people have proposed.  There's no way around
that, though the fixups are usually straightforward.

In summary, these patches detach the security info from the task_struct and put
it into its own struct with COW semantics.  This allows execve() to be cleaned
up and allows cachefiles, nfsd, coredumping and faccessat() to override a
process's credentials without exposing the override to userspace.  Multiple
simultaneous security changes (eg: setresuid and execve) now happen
instantaneously, and no intermediate state will be seen.

Documentation is added in its own patch, and the patches have been tested by
LTP's SELinux and syscalls tests.

Thanks,
David
---
The following changes since commit 9779a8325a9bbf4ccd3853e0e4064984cf9da9c9:
  Linus Torvalds (1):
        Merge branch 'for-upstream' of git://git.kernel.org/.../dvrabel/uwb

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/cred-2.6.git creds-v4

David Howells (77):
      CRED: Wrap task credential accesses in the IA64 arch
      CRED: Wrap task credential accesses in the MIPS arch
      CRED: Wrap task credential accesses in the PA-RISC arch
      CRED: Wrap task credential accesses in the PowerPC arch
      CRED: Wrap task credential accesses in the S390 arch
      CRED: Wrap task credential accesses in the x86 arch
      CRED: Wrap task credential accesses in the block loopback driver
      CRED: Wrap task credential accesses in the tty driver
      CRED: Wrap task credential accesses in the ISDN drivers
      CRED: Wrap task credential accesses in the network device drivers
      CRED: Wrap task credential accesses in the USB driver
      CRED: Wrap task credential accesses in 9P2000 filesystem
      CRED: Wrap task credential accesses in the AFFS filesystem
      CRED: Wrap task credential accesses in the autofs filesystem
      CRED: Wrap task credential accesses in the autofs4 filesystem
      CRED: Wrap task credential accesses in the BFS filesystem
      CRED: Wrap task credential accesses in the CIFS filesystem
      CRED: Wrap task credential accesses in the Coda filesystem
      CRED: Wrap task credential accesses in the devpts filesystem
      CRED: Wrap task credential accesses in the eCryptFS filesystem
      CRED: Wrap task credential accesses in the Ext2 filesystem
      CRED: Wrap task credential accesses in the Ext3 filesystem
      CRED: Wrap task credential accesses in the Ext4 filesystem
      CRED: Wrap task credential accesses in the FAT filesystem
      CRED: Wrap task credential accesses in the FUSE filesystem
      CRED: Wrap task credential accesses in the GFS2 filesystem
      CRED: Wrap task credential accesses in the HFS filesystem
      CRED: Wrap task credential accesses in the HFSplus filesystem
      CRED: Wrap task credential accesses in the HPFS filesystem
      CRED: Wrap task credential accesses in the hugetlbfs filesystem
      CRED: Wrap task credential accesses in the JFS filesystem
      CRED: Wrap task credential accesses in the Minix filesystem
      CRED: Wrap task credential accesses in the NCPFS filesystem
      CRED: Wrap task credential accesses in the NFS daemon
      CRED: Wrap task credential accesses in the OCFS2 filesystem
      CRED: Wrap task credential accesses in the OMFS filesystem
      CRED: Wrap task credential accesses in the RAMFS filesystem
      CRED: Wrap task credential accesses in the ReiserFS filesystem
      CRED: Wrap task credential accesses in the SMBFS filesystem
      CRED: Wrap task credential accesses in the SYSV filesystem
      CRED: Wrap task credential accesses in the UBIFS filesystem
      CRED: Wrap task credential accesses in the UDF filesystem
      CRED: Wrap task credential accesses in the UFS filesystem
      CRED: Wrap task credential accesses in the XFS filesystem
      CRED: Wrap task credential accesses in the filesystem subsystem
      CRED: Wrap task credential accesses in the SYSV IPC subsystem
      CRED: Wrap task credential accesses in the AX25 protocol
      CRED: Wrap task credential accesses in the IPv6 protocol
      CRED: Wrap task credential accesses in the netrom protocol
      CRED: Wrap task credential accesses in the ROSE protocol
      CRED: Wrap task credential accesses in the SunRPC protocol
      CRED: Wrap task credential accesses in the UNIX socket protocol
      CRED: Wrap task credential accesses in the networking subsystem
      CRED: Wrap task credential accesses in the key management code
      CRED: Wrap task credential accesses in the capabilities code
      CRED: Wrap task credential accesses in the core kernel
      KEYS: Disperse linux/key_ui.h
      KEYS: Alter use of key instantiation link-to-keyring argument
      CRED: Neuter sys_capset()
      CRED: Constify the kernel_cap_t arguments to the capset LSM hooks
      CRED: Separate task security context from task_struct
      CRED: Detach the credentials from task_struct
      CRED: Wrap current->cred and a few other accessors
      CRED: Use RCU to access another task's creds and to release a task's own creds
      CRED: Wrap access to SELinux's task SID
      CRED: Separate per-task-group keyrings from signal_struct
      CRED: Rename is_single_threaded() to is_wq_single_threaded()
      CRED: Make inode_has_perm() and file_has_perm() take a cred pointer
      CRED: Pass credentials through dentry_open()
      CRED: Inaugurate COW credentials
      CRED: Make execve() take advantage of copy-on-write credentials
      CRED: Prettify commoncap.c
      CRED: Use creds in file structs
      CRED: Documentation
      CRED: Differentiate objective and effective subjective credentials on a task
      CRED: Add a kernel_service object class to SELinux
      CRED: Allow kernel services to override LSM settings for task actions

 Documentation/credentials.txt                |  582 +++++++++++++
 arch/alpha/kernel/asm-offsets.c              |   11 +-
 arch/alpha/kernel/entry.S                    |   10 +-
 arch/ia64/ia32/sys_ia32.c                    |    7 +-
 arch/ia64/kernel/mca_drv.c                   |    2 +-
 arch/ia64/kernel/perfmon.c                   |   43 +-
 arch/ia64/kernel/signal.c                    |    4 +-
 arch/mips/kernel/kspd.c                      |    4 +-
 arch/mips/kernel/mips-mt-fpaff.c             |    5 +-
 arch/mips/kernel/vpe.c                       |    4 +-
 arch/parisc/kernel/signal.c                  |    2 +-
 arch/powerpc/mm/fault.c                      |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c    |    8 +-
 arch/s390/hypfs/inode.c                      |    4 +-
 arch/s390/kernel/compat_linux.c              |   28 +-
 arch/um/drivers/mconsole_kern.c              |    3 +-
 arch/x86/ia32/ia32_aout.c                    |    2 +-
 arch/x86/mm/fault.c                          |    2 +-
 drivers/block/loop.c                         |    6 +-
 drivers/char/tty_audit.c                     |    6 +-
 drivers/connector/cn_proc.c                  |   16 +-
 drivers/isdn/capi/capifs.c                   |    4 +-
 drivers/isdn/hysdn/hysdn_procconf.c          |    6 +-
 drivers/net/tun.c                            |    8 +-
 drivers/usb/core/devio.c                     |   10 +-
 drivers/usb/core/inode.c                     |    4 +-
 fs/9p/fid.c                                  |    2 +-
 fs/9p/vfs_inode.c                            |    4 +-
 fs/9p/vfs_super.c                            |    4 +-
 fs/affs/inode.c                              |    4 +-
 fs/affs/super.c                              |    4 +-
 fs/anon_inodes.c                             |    4 +-
 fs/attr.c                                    |    4 +-
 fs/autofs/inode.c                            |    4 +-
 fs/autofs4/dev-ioctl.c                       |    3 +-
 fs/autofs4/inode.c                           |    4 +-
 fs/autofs4/waitq.c                           |    4 +-
 fs/bfs/dir.c                                 |    4 +-
 fs/binfmt_aout.c                             |    2 +-
 fs/binfmt_elf.c                              |   20 +-
 fs/binfmt_elf_fdpic.c                        |   19 +-
 fs/binfmt_flat.c                             |    2 +-
 fs/binfmt_som.c                              |    2 +-
 fs/cifs/cifs_fs_sb.h                         |    2 +-
 fs/cifs/cifsproto.h                          |    2 +-
 fs/cifs/connect.c                            |    4 +-
 fs/cifs/dir.c                                |   12 +-
 fs/cifs/inode.c                              |    8 +-
 fs/cifs/ioctl.c                              |    2 +-
 fs/cifs/misc.c                               |    4 +-
 fs/coda/cache.c                              |    6 +-
 fs/coda/file.c                               |    2 +-
 fs/coda/upcall.c                             |    2 +-
 fs/compat.c                                  |   42 +-
 fs/devpts/inode.c                            |    4 +-
 fs/dquot.c                                   |    4 +-
 fs/ecryptfs/ecryptfs_kernel.h                |    3 +-
 fs/ecryptfs/kthread.c                        |    9 +-
 fs/ecryptfs/main.c                           |    3 +-
 fs/ecryptfs/messaging.c                      |   18 +-
 fs/ecryptfs/miscdev.c                        |   20 +-
 fs/exec.c                                    |  183 +++--
 fs/exportfs/expfs.c                          |    4 +-
 fs/ext2/balloc.c                             |    2 +-
 fs/ext2/ialloc.c                             |    4 +-
 fs/ext3/balloc.c                             |    2 +-
 fs/ext3/ialloc.c                             |    4 +-
 fs/ext4/balloc.c                             |    5 +-
 fs/ext4/ialloc.c                             |    4 +-
 fs/fat/file.c                                |    2 +-
 fs/fat/inode.c                               |    4 +-
 fs/fcntl.c                                   |   18 +-
 fs/file_table.c                              |   10 +-
 fs/fuse/dev.c                                |    4 +-
 fs/fuse/dir.c                                |   25 +-
 fs/gfs2/inode.c                              |   10 +-
 fs/hfs/inode.c                               |    4 +-
 fs/hfs/super.c                               |    4 +-
 fs/hfsplus/inode.c                           |    4 +-
 fs/hfsplus/options.c                         |    4 +-
 fs/hpfs/namei.c                              |   24 +-
 fs/hpfs/super.c                              |    4 +-
 fs/hppfs/hppfs.c                             |    6 +-
 fs/hugetlbfs/inode.c                         |   21 +-
 fs/inotify_user.c                            |    2 +-
 fs/internal.h                                |    6 +
 fs/ioprio.c                                  |   18 +-
 fs/jfs/jfs_inode.c                           |    4 +-
 fs/locks.c                                   |    2 +-
 fs/minix/bitmap.c                            |    4 +-
 fs/namei.c                                   |   10 +-
 fs/namespace.c                               |    2 +-
 fs/ncpfs/ioctl.c                             |   91 +--
 fs/nfsctl.c                                  |    3 +-
 fs/nfsd/auth.c                               |   95 ++-
 fs/nfsd/nfs4recover.c                        |   71 +-
 fs/nfsd/nfsfh.c                              |   11 +-
 fs/nfsd/vfs.c                                |    9 +-
 fs/ocfs2/dlm/dlmfs.c                         |    8 +-
 fs/ocfs2/namei.c                             |    4 +-
 fs/omfs/inode.c                              |    8 +-
 fs/open.c                                    |   59 +-
 fs/pipe.c                                    |    4 +-
 fs/posix_acl.c                               |    4 +-
 fs/proc/array.c                              |   32 +-
 fs/proc/base.c                               |   32 +-
 fs/quota.c                                   |    4 +-
 fs/ramfs/inode.c                             |    4 +-
 fs/reiserfs/namei.c                          |    4 +-
 fs/smbfs/dir.c                               |    3 +-
 fs/smbfs/inode.c                             |    2 +-
 fs/smbfs/proc.c                              |    2 +-
 fs/sysv/ialloc.c                             |    4 +-
 fs/ubifs/budget.c                            |    2 +-
 fs/ubifs/dir.c                               |    4 +-
 fs/udf/ialloc.c                              |    4 +-
 fs/udf/namei.c                               |    2 +-
 fs/ufs/ialloc.c                              |    4 +-
 fs/xfs/linux-2.6/xfs_cred.h                  |    6 +-
 fs/xfs/linux-2.6/xfs_globals.h               |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    5 +-
 fs/xfs/xfs_acl.c                             |    6 +-
 fs/xfs/xfs_inode.h                           |    2 +-
 fs/xfs/xfs_vnodeops.h                        |   10 +-
 include/keys/keyring-type.h                  |   31 +
 include/linux/binfmts.h                      |   16 +-
 include/linux/capability.h                   |    2 -
 include/linux/cred.h                         |  340 +++++++-
 include/linux/fs.h                           |    8 +-
 include/linux/init_task.h                    |   13 +-
 include/linux/key-ui.h                       |   66 --
 include/linux/key.h                          |   32 +-
 include/linux/keyctl.h                       |    4 +-
 include/linux/sched.h                        |   64 +--
 include/linux/securebits.h                   |    2 +-
 include/linux/security.h                     |  326 ++++----
 include/net/scm.h                            |    4 +-
 init/main.c                                  |    1 +
 ipc/mqueue.c                                 |   19 +-
 ipc/shm.c                                    |    9 +-
 ipc/util.c                                   |   18 +-
 kernel/Makefile                              |    2 +-
 kernel/acct.c                                |    7 +-
 kernel/auditsc.c                             |   57 +-
 kernel/capability.c                          |  268 +------
 kernel/cgroup.c                              |   17 +-
 kernel/cred-internals.h                      |   21 +
 kernel/cred.c                                |  577 +++++++++++++
 kernel/exit.c                                |   23 +-
 kernel/fork.c                                |   44 +-
 kernel/futex.c                               |   20 +-
 kernel/futex_compat.c                        |    7 +-
 kernel/kmod.c                                |   30 +-
 kernel/ptrace.c                              |   29 +-
 kernel/sched.c                               |   26 +-
 kernel/signal.c                              |   60 +-
 kernel/sys.c                                 |  579 ++++++++------
 kernel/sysctl.c                              |    2 +-
 kernel/timer.c                               |    8 +-
 kernel/trace/trace.c                         |    2 +-
 kernel/tsacct.c                              |    6 +-
 kernel/uid16.c                               |   31 +-
 kernel/user.c                                |   37 +-
 kernel/user_namespace.c                      |   14 +-
 kernel/workqueue.c                           |    8 +-
 lib/Makefile                                 |    2 +-
 lib/is_single_threaded.c                     |   45 +
 mm/mempolicy.c                               |    9 +-
 mm/migrate.c                                 |    9 +-
 mm/oom_kill.c                                |    6 +-
 mm/shmem.c                                   |    8 +-
 net/9p/client.c                              |    2 +-
 net/ax25/af_ax25.c                           |    2 +-
 net/ax25/ax25_route.c                        |    2 +-
 net/core/dev.c                               |    8 +-
 net/core/scm.c                               |   10 +-
 net/ipv4/netfilter/ipt_LOG.c                 |    4 +-
 net/ipv6/ip6_flowlabel.c                     |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c                |    4 +-
 net/netfilter/nfnetlink_log.c                |    5 +-
 net/netfilter/xt_owner.c                     |   16 +-
 net/netrom/af_netrom.c                       |    4 +-
 net/rose/af_rose.c                           |    4 +-
 net/rxrpc/ar-key.c                           |    6 +-
 net/sched/cls_flow.c                         |    4 +-
 net/socket.c                                 |    4 +-
 net/sunrpc/auth.c                            |   14 +-
 net/unix/af_unix.c                           |   11 +-
 security/capability.c                        |   56 +-
 security/commoncap.c                         |  699 ++++++++++------
 security/keys/internal.h                     |   47 +-
 security/keys/key.c                          |   25 +-
 security/keys/keyctl.c                       |  210 +++--
 security/keys/keyring.c                      |   15 +-
 security/keys/permission.c                   |   29 +-
 security/keys/proc.c                         |    8 +-
 security/keys/process_keys.c                 |  469 +++++------
 security/keys/request_key.c                  |  133 ++--
 security/keys/request_key_auth.c             |   46 +-
 security/root_plug.c                         |   13 +-
 security/security.c                          |   96 +--
 security/selinux/exports.c                   |    8 +-
 security/selinux/hooks.c                     | 1151 ++++++++++++++------------
 security/selinux/include/av_perm_to_string.h |    2 +
 security/selinux/include/av_permissions.h    |    2 +
 security/selinux/include/class_to_string.h   |    5 +
 security/selinux/include/flask.h             |    1 +
 security/selinux/include/objsec.h            |   11 -
 security/selinux/selinuxfs.c                 |   13 +-
 security/selinux/xfrm.c                      |    6 +-
 security/smack/smack_access.c                |    4 +-
 security/smack/smack_lsm.c                   |  173 +++--
 security/smack/smackfs.c                     |    6 +-
 213 files changed, 5062 insertions(+), 3098 deletions(-)
 create mode 100644 Documentation/credentials.txt
 create mode 100644 include/keys/keyring-type.h
 delete mode 100644 include/linux/key-ui.h
 create mode 100644 kernel/cred-internals.h
 create mode 100644 kernel/cred.c
 create mode 100644 lib/is_single_threaded.c


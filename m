Return-Path: <linux-kernel-owner+w=401wt.eu-S1751595AbYLYBIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbYLYBIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 20:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLYBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 20:08:22 -0500
Received: from tundra.namei.org ([65.99.196.166]:1499 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYLYBIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 20:08:20 -0500
Date: Thu, 25 Dec 2008 12:07:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT] Security changes for 2.6.29
Message-ID: <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following security changes for 2.6.29.

The most significant changes here relate to the new credentials API from 
David Howells.  There will be conflicts with other trees, although these 
should have been encountered in linux-next, and resolvable with patches 
previously posted by sfr.

The following changes since commit 4a6908a3a050aacc9c3a2f36b276b46c0629ad91:
  Linus Torvalds (1):
        Linux 2.6.28

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Al Viro (1):
      Audit: Log TIOCSTI

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

Eric Paris (13):
      SELinux: check open perms in dentry_open not inode_permission
      SELinux: hold tasklist_lock and siglock while waking wait_chldexit
      SELinux: Use unknown perm handling to handle unknown netlink msg types
      Document the order of arguments for cap_issubset.  It's not instantly clear
      This patch add a generic cpu endian caps structure and externally available
      This patch will print cap_permitted and cap_inheritable data in the PATH
      Any time fcaps or a setuid app under SECURE_NOROOT is used to result in a
      When the capset syscall is used it is not possible for audit to record the
      Capabilities: BUG when an invalid capability is requested
      Add a new capable interface that will be used by systems that use audit to
      The oomkiller calculations make decisions based on capabilities.  Since
      Currently SELinux jumps through some ugly hoops to not audit a capbility
      capabilities: define get_vfs_caps_from_disk when file caps are not enabled

Hannes Eder (1):
      CRED: fix sparse warnings

James Morris (9):
      Merge branch 'master' into next
      security: remove broken and useless declarations
      Merge branch 'master' into next
      Merge branch 'master' into next
      Merge branch 'serge-next' into next
      Merge branch 'master' into next
      security: pass mount flags to security_sb_kern_mount()
      SELinux: don't check permissions for kernel mounts
      Merge branch 'next' into for-linus

Michal Schmidt (1):
      selinux: recognize netlink messages for 'ip addrlabel'

Randy Dunlap (2):
      coda: fix creds reference
      nfsctl: add headers for credentials

Serge E. Hallyn (4):
      file capabilities: add no_file_caps switch (v4)
      user namespaces: let user_ns be cloned with fairsched
      user namespaces: require cap_set{ug}id for CLONE_NEWUSER
      user namespaces: document CFS behavior

Serge Hallyn (2):
      User namespaces: set of cleanups (v2)
      User namespaces: use the current_user_ns() macro

Stephen Smalley (1):
      SELinux: correctly detect proc filesystems of the form "proc/foo"

 Documentation/credentials.txt                |  582 ++++++++++++
 Documentation/kernel-parameters.txt          |    4 +
 Documentation/scheduler/sched-design-CFS.txt |   21 +
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
 drivers/char/tty_audit.c                     |   76 ++-
 drivers/char/tty_io.c                        |    1 +
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
 fs/coda/file.c                               |    3 +-
 fs/coda/upcall.c                             |    2 +-
 fs/compat.c                                  |   42 +-
 fs/devpts/inode.c                            |    4 +-
 fs/dquot.c                                   |    4 +-
 fs/ecryptfs/ecryptfs_kernel.h                |    3 +-
 fs/ecryptfs/kthread.c                        |    9 +-
 fs/ecryptfs/main.c                           |    3 +-
 fs/ecryptfs/messaging.c                      |   27 +-
 fs/ecryptfs/miscdev.c                        |   27 +-
 fs/exec.c                                    |  183 +++--
 fs/exportfs/expfs.c                          |    4 +-
 fs/ext2/balloc.c                             |    2 +-
 fs/ext2/ialloc.c                             |    4 +-
 fs/ext3/balloc.c                             |    2 +-
 fs/ext3/ialloc.c                             |    4 +-
 fs/ext4/balloc.c                             |    2 +-
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
 fs/ncpfs/ioctl.c                             |   91 +-
 fs/nfsctl.c                                  |    5 +-
 fs/nfsd/auth.c                               |   95 ++-
 fs/nfsd/nfs4recover.c                        |   72 +-
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
 fs/super.c                                   |    2 +-
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
 include/linux/audit.h                        |   26 +
 include/linux/binfmts.h                      |   16 +-
 include/linux/capability.h                   |   25 +-
 include/linux/cred.h                         |  342 +++++++-
 include/linux/fs.h                           |    8 +-
 include/linux/init_task.h                    |   14 +-
 include/linux/key-ui.h                       |   66 --
 include/linux/key.h                          |   32 +-
 include/linux/keyctl.h                       |    4 +-
 include/linux/nsproxy.h                      |    1 -
 include/linux/sched.h                        |   65 +--
 include/linux/securebits.h                   |    2 +-
 include/linux/security.h                     |  344 ++++----
 include/linux/tty.h                          |    4 +
 include/linux/user_namespace.h               |   13 +-
 include/net/scm.h                            |    4 +-
 init/main.c                                  |    1 +
 ipc/mqueue.c                                 |   19 +-
 ipc/shm.c                                    |    9 +-
 ipc/util.c                                   |   18 +-
 kernel/Makefile                              |    2 +-
 kernel/acct.c                                |    7 +-
 kernel/auditsc.c                             |  255 +++++-
 kernel/capability.c                          |  288 +-----
 kernel/cgroup.c                              |   17 +-
 kernel/cred-internals.h                      |   21 +
 kernel/cred.c                                |  588 ++++++++++++
 kernel/exit.c                                |   23 +-
 kernel/fork.c                                |   62 +-
 kernel/futex.c                               |   20 +-
 kernel/futex_compat.c                        |    7 +-
 kernel/kmod.c                                |   30 +-
 kernel/nsproxy.c                             |   15 +-
 kernel/ptrace.c                              |   29 +-
 kernel/sched.c                               |   26 +-
 kernel/signal.c                              |   60 +-
 kernel/sys.c                                 |  586 +++++++------
 kernel/sysctl.c                              |    2 +-
 kernel/timer.c                               |    8 +-
 kernel/trace/trace.c                         |    2 +-
 kernel/tsacct.c                              |    6 +-
 kernel/uid16.c                               |   31 +-
 kernel/user.c                                |   96 +--
 kernel/user_namespace.c                      |   65 +-
 kernel/workqueue.c                           |    8 +-
 lib/Makefile                                 |    2 +-
 lib/is_single_threaded.c                     |   45 +
 mm/mempolicy.c                               |    9 +-
 mm/migrate.c                                 |    9 +-
 mm/oom_kill.c                                |   12 +-
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
 security/capability.c                        |   58 +-
 security/commoncap.c                         |  830 +++++++++++------
 security/keys/internal.h                     |   49 +-
 security/keys/key.c                          |   25 +-
 security/keys/keyctl.c                       |  210 +++--
 security/keys/keyring.c                      |   15 +-
 security/keys/permission.c                   |   29 +-
 security/keys/proc.c                         |    8 +-
 security/keys/process_keys.c                 |  469 +++++------
 security/keys/request_key.c                  |  135 ++--
 security/keys/request_key_auth.c             |   46 +-
 security/root_plug.c                         |   13 +-
 security/security.c                          |  103 +--
 security/selinux/exports.c                   |    8 +-
 security/selinux/hooks.c                     | 1254 ++++++++++++++------------
 security/selinux/include/av_perm_to_string.h |    2 +
 security/selinux/include/av_permissions.h    |    2 +
 security/selinux/include/class_to_string.h   |    5 +
 security/selinux/include/flask.h             |    1 +
 security/selinux/include/objsec.h            |   11 -
 security/selinux/nlmsgtab.c                  |    3 +
 security/selinux/selinuxfs.c                 |   13 +-
 security/selinux/xfrm.c                      |    6 +-
 security/smack/smack_access.c                |    4 +-
 security/smack/smack_lsm.c                   |  176 +++--
 security/smack/smackfs.c                     |    6 +-
 223 files changed, 5679 insertions(+), 3323 deletions(-)
 create mode 100644 Documentation/credentials.txt
 create mode 100644 include/keys/keyring-type.h
 delete mode 100644 include/linux/key-ui.h
 create mode 100644 kernel/cred-internals.h
 create mode 100644 kernel/cred.c
 create mode 100644 lib/is_single_threaded.c

-- 
James Morris
<jmorris@namei.org>

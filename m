Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYIXLX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYIXLX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYIXLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:23:19 -0400
Received: from aristoteles.cuci.nl ([212.125.128.18]:43204 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYIXLXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:23:18 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 07:23:17 EDT
Date: Wed, 24 Sep 2008 13:13:47 +0200
From: "Stephen R. van den Berg" <srb@cuci.nl>
To: linux-kernel@vger.kernel.org
Subject: Inclusion of (large parts of) the vserver extension into the core?
Message-ID: <20080924111347.GB9437@cuci.nl>
Mail-Followup-To: "Stephen R. van den Berg" <srb@cuci.nl>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pardon me if this has been discussed to death already, feel free to
point me to the proper archives.

However, I'm willing to do a bit of legwork to get the vserver patches
(most, if not all) into mainstream Linux.

The project exists since october 2001, and it has matured quite a bit
since then.
Is there any reason why some or all of the changes cannot be included
into mainstream Linux?
What would be the most painless method to get part of (or all) of the
vserver patches included into the kernel proper?

For reference, the project can be found at: http://linux-vserver.org/
The most recent patches can be found at:
				     http://vserver.13thfloor.at/Experimental/

Summarised, the most recent patch looks like (if so desired I could post
the whole patch here):

commit 5dc8f663e6cd481077cc1079297500779ec91916
Date:   Mon Sep 22 21:27:05 2008 +0200

    vserver 2.3.0.35.6pre

 Documentation/vserver/debug.txt                |  154 ++++
 Makefile                                       |    2 +-
 arch/alpha/Kconfig                             |    2 +
 arch/alpha/kernel/entry.S                      |   23 +-
 arch/alpha/kernel/osf_sys.c                    |    2 +-
 arch/alpha/kernel/ptrace.c                     |    1 +
 arch/alpha/kernel/systbls.S                    |    2 +-
 arch/alpha/kernel/traps.c                      |    3 +-
 arch/alpha/mm/fault.c                          |    4 +-
 arch/arm/Kconfig                               |    2 +
 arch/arm/kernel/calls.S                        |    2 +-
 arch/arm/kernel/process.c                      |    3 +-
 arch/arm/kernel/traps.c                        |    4 +-
 arch/arm/mm/fault.c                            |    3 +-
 arch/cris/Kconfig                              |    2 +
 arch/frv/kernel/kernel_thread.S                |    2 +-
 arch/h8300/Kconfig                             |    2 +
 arch/ia64/Kconfig                              |    2 +
 arch/ia64/ia32/ia32_entry.S                    |    2 +-
 arch/ia64/ia32/sys_ia32.c                      |    2 +-
 arch/ia64/kernel/entry.S                       |    2 +-
 arch/ia64/kernel/perfmon.c                     |    3 +-
 arch/ia64/kernel/process.c                     |    4 +-
 arch/ia64/kernel/ptrace.c                      |    1 +
 arch/ia64/kernel/traps.c                       |   10 +-
 arch/ia64/mm/fault.c                           |    1 +
 arch/m32r/kernel/traps.c                       |    5 +-
 arch/m68k/Kconfig                              |    2 +
 arch/m68k/kernel/ptrace.c                      |    3 +
 arch/m68k/kernel/traps.c                       |    4 +-
 arch/m68knommu/Kconfig                         |    2 +
 arch/m68knommu/kernel/traps.c                  |    5 +-
 arch/mips/Kconfig                              |    2 +
 arch/mips/kernel/linux32.c                     |    2 +-
 arch/mips/kernel/ptrace.c                      |    4 +
 arch/mips/kernel/scall32-o32.S                 |    2 +-
 arch/mips/kernel/scall64-64.S                  |    2 +-
 arch/mips/kernel/scall64-n32.S                 |    2 +-
 arch/mips/kernel/scall64-o32.S                 |    2 +-
 arch/mips/kernel/traps.c                       |    7 +-
 arch/mips/mm/fault.c                           |    3 +-
 arch/parisc/Kconfig                            |    2 +
 arch/parisc/kernel/sys_parisc32.c              |    4 +-
 arch/parisc/kernel/syscall_table.S             |    2 +-
 arch/parisc/kernel/traps.c                     |    9 +-
 arch/parisc/mm/fault.c                         |    8 +-
 arch/powerpc/Kconfig                           |    2 +
 arch/powerpc/kernel/irq.c                      |    1 +
 arch/powerpc/kernel/process.c                  |    5 +-
 arch/powerpc/kernel/sys_ppc32.c                |    2 +-
 arch/powerpc/kernel/traps.c                    |    5 +-
 arch/powerpc/kernel/vdso.c                     |    1 +
 arch/powerpc/mm/fault.c                        |    3 +-
 arch/s390/Kconfig                              |    2 +
 arch/s390/kernel/compat_linux.c                |    2 +-
 arch/s390/kernel/ptrace.c                      |    1 +
 arch/s390/kernel/syscalls.S                    |    2 +-
 arch/s390/mm/fault.c                           |    3 +-
 arch/sh/Kconfig                                |    2 +
 arch/sh/kernel/irq.c                           |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c             |    1 +
 arch/sparc/Kconfig                             |    2 +
 arch/sparc/kernel/ptrace.c                     |    1 +
 arch/sparc/kernel/systbls.S                    |    2 +-
 arch/sparc/kernel/traps.c                      |    3 +-
 arch/sparc/mm/fault.c                          |    3 +-
 arch/sparc64/Kconfig                           |    2 +
 arch/sparc64/kernel/ptrace.c                   |    1 +
 arch/sparc64/kernel/sys_sparc32.c              |    2 +-
 arch/sparc64/kernel/systbls.S                  |    4 +-
 arch/sparc64/kernel/traps.c                    |    3 +-
 arch/sparc64/mm/fault.c                        |    3 +-
 arch/um/Kconfig                                |    2 +
 arch/um/kernel/trap.c                          |    3 +-
 arch/x86/Kconfig                               |    2 +
 arch/x86/ia32/ia32entry.S                      |    2 +-
 arch/x86/kernel/syscall_table_32.S             |    2 +-
 drivers/block/Kconfig                          |    7 +
 drivers/block/Makefile                         |    1 +
 drivers/block/loop.c                           |   11 +-
 drivers/block/vroot.c                          |  283 ++++++
 drivers/char/sysrq.c                           |   24 +-
 drivers/char/tty_io.c                          |    2 +
 drivers/infiniband/hw/ipath/ipath_user_pages.c |   10 +-
 drivers/md/dm-ioctl.c                          |   23 +-
 drivers/md/dm.c                                |   25 +-
 drivers/md/dm.h                                |    2 +
 drivers/net/tun.c                              |   20 +-
 fs/attr.c                                      |   29 +-
 fs/binfmt_aout.c                               |    1 +
 fs/binfmt_elf.c                                |    1 +
 fs/binfmt_flat.c                               |    1 +
 fs/binfmt_som.c                                |    1 +
 fs/block_dev.c                                 |    9 +-
 fs/char_dev.c                                  |   11 +-
 fs/dcache.c                                    |   10 +
 fs/devpts/inode.c                              |   44 +-
 fs/exec.c                                      |    6 +-
 fs/ext2/balloc.c                               |   14 +-
 fs/ext2/ext2.h                                 |    1 +
 fs/ext2/file.c                                 |    1 +
 fs/ext2/ialloc.c                               |   14 +-
 fs/ext2/inode.c                                |   76 ++-
 fs/ext2/ioctl.c                                |   10 +-
 fs/ext2/namei.c                                |    4 +
 fs/ext2/super.c                                |   29 +-
 fs/ext2/symlink.c                              |    2 +
 fs/ext2/xattr.c                                |    7 +
 fs/ext3/balloc.c                               |   45 +-
 fs/ext3/file.c                                 |    1 +
 fs/ext3/ialloc.c                               |   15 +-
 fs/ext3/inode.c                                |  102 ++-
 fs/ext3/ioctl.c                                |   11 +-
 fs/ext3/namei.c                                |    4 +
 fs/ext3/super.c                                |   29 +-
 fs/ext3/symlink.c                              |    2 +
 fs/ext3/xattr.c                                |    9 +-
 fs/ext4/balloc.c                               |   12 +-
 fs/ext4/ext4.h                                 |    6 +
 fs/ext4/file.c                                 |    1 +
 fs/ext4/ialloc.c                               |   15 +-
 fs/ext4/inode.c                                |  103 ++-
 fs/ext4/ioctl.c                                |   11 +-
 fs/ext4/namei.c                                |    4 +
 fs/ext4/super.c                                |   28 +
 fs/ext4/symlink.c                              |    2 +
 fs/ext4/xattr.c                                |    9 +-
 fs/fcntl.c                                     |   10 +-
 fs/file.c                                      |    3 +
 fs/file_table.c                                |    8 +
 fs/hfsplus/ioctl.c                             |    1 +
 fs/inode.c                                     |    8 +
 fs/ioctl.c                                     |    3 +
 fs/ioprio.c                                    |    5 +
 fs/jfs/acl.c                                   |    3 +-
 fs/jfs/file.c                                  |    1 +
 fs/jfs/inode.c                                 |    2 +
 fs/jfs/ioctl.c                                 |   10 +-
 fs/jfs/jfs_dinode.h                            |    8 +-
 fs/jfs/jfs_dtree.c                             |   41 +-
 fs/jfs/jfs_extent.c                            |   19 +
 fs/jfs/jfs_filsys.h                            |    1 +
 fs/jfs/jfs_imap.c                              |   25 +-
 fs/jfs/jfs_inode.c                             |   51 +-
 fs/jfs/jfs_inode.h                             |    1 +
 fs/jfs/jfs_xtree.c                             |   26 +
 fs/jfs/namei.c                                 |    3 +
 fs/jfs/super.c                                 |   31 +-
 fs/jfs/xattr.c                                 |   24 +-
 fs/libfs.c                                     |   18 +-
 fs/locks.c                                     |   50 +-
 fs/namei.c                                     |  318 +++++++-
 fs/namespace.c                                 |  119 +++-
 fs/nfs/client.c                                |    7 +
 fs/nfs/dir.c                                   |    2 +
 fs/nfs/inode.c                                 |   38 +-
 fs/nfs/nfs3xdr.c                               |   28 +-
 fs/nfs/nfsroot.c                               |   21 +-
 fs/nfs/super.c                                 |    2 +
 fs/nfsd/auth.c                                 |   11 +-
 fs/nfsd/nfs3xdr.c                              |   18 +-
 fs/nfsd/nfs4xdr.c                              |    9 +-
 fs/nfsd/nfsxdr.c                               |   16 +-
 fs/ocfs2/dlm/dlmfs.c                           |    3 +
 fs/ocfs2/dlmglue.c                             |    2 +
 fs/ocfs2/dlmglue.h                             |    3 +-
 fs/ocfs2/file.c                                |    5 +-
 fs/ocfs2/inode.c                               |  104 ++-
 fs/ocfs2/inode.h                               |    1 +
 fs/ocfs2/ioctl.c                               |    7 +-
 fs/ocfs2/ioctl.h                               |    3 +
 fs/ocfs2/namei.c                               |   17 +-
 fs/ocfs2/ocfs2.h                               |    1 +
 fs/ocfs2/ocfs2_fs.h                            |   29 +-
 fs/ocfs2/super.c                               |   28 +
 fs/open.c                                      |   40 +-
 fs/proc/array.c                                |   75 ++-
 fs/proc/base.c                                 |   29 +-
 fs/proc/generic.c                              |   12 +-
 fs/proc/inode.c                                |    2 +
 fs/proc/internal.h                             |   11 +-
 fs/proc/proc_misc.c                            |   31 +-
 fs/proc/root.c                                 |    5 +
 fs/quota.c                                     |   65 ++-
 fs/reiserfs/bitmap.c                           |   42 +-
 fs/reiserfs/file.c                             |    1 +
 fs/reiserfs/inode.c                            |   91 ++-
 fs/reiserfs/ioctl.c                            |   12 +-
 fs/reiserfs/namei.c                            |    6 +
 fs/reiserfs/stree.c                            |   19 +-
 fs/reiserfs/super.c                            |   18 +
 fs/reiserfs/xattr.c                            |    1 +
 fs/stat.c                                      |    1 +
 fs/super.c                                     |   18 +-
 fs/sysfs/mount.c                               |    4 +-
 fs/utimes.c                                    |    2 +
 fs/xattr.c                                     |    1 +
 fs/xfs/linux-2.6/xfs_ioctl.c                   |   45 +-
 fs/xfs/linux-2.6/xfs_iops.c                    |   69 ++
 fs/xfs/linux-2.6/xfs_linux.h                   |    1 +
 fs/xfs/linux-2.6/xfs_super.c                   |   30 +
 fs/xfs/quota/xfs_qm_syscalls.c                 |    9 +-
 fs/xfs/xfs_clnt.h                              |    1 +
 fs/xfs/xfs_dinode.h                            |   17 +-
 fs/xfs/xfs_fs.h                                |    6 +-
 fs/xfs/xfs_ialloc.c                            |    2 +
 fs/xfs/xfs_inode.c                             |   60 +-
 fs/xfs/xfs_inode.h                             |    8 +-
 fs/xfs/xfs_itable.c                            |    1 +
 fs/xfs/xfs_log_recover.c                       |    3 +-
 fs/xfs/xfs_mount.h                             |    1 +
 fs/xfs/xfs_vnodeops.c                          |    7 +
 include/asm-generic/tlb.h                      |    1 +
 include/asm-x86/unistd_64.h                    |    2 +-
 include/linux/Kbuild                           |    3 +
 include/linux/capability.h                     |    9 +-
 include/linux/devpts_fs.h                      |    1 -
 include/linux/ext2_fs.h                        |    8 +-
 include/linux/ext3_fs.h                        |   13 +-
 include/linux/fs.h                             |   53 +-
 include/linux/if_tun.h                         |    1 +
 include/linux/init_task.h                      |    4 +
 include/linux/interrupt.h                      |    2 +-
 include/linux/ipc.h                            |    1 +
 include/linux/loop.h                           |    1 +
 include/linux/magic.h                          |    3 +-
 include/linux/major.h                          |    1 +
 include/linux/mm_types.h                       |    1 +
 include/linux/mount.h                          |    5 +
 include/linux/net.h                            |    1 +
 include/linux/nfs_mount.h                      |    3 +-
 include/linux/nsproxy.h                        |   24 +-
 include/linux/pid.h                            |    4 +-
 include/linux/proc_fs.h                        |    8 +
 include/linux/reiserfs_fs.h                    |    9 +
 include/linux/reiserfs_fs_sb.h                 |    1 +
 include/linux/sched.h                          |   41 +-
 include/linux/shmem_fs.h                       |    3 +
 include/linux/stat.h                           |    1 +
 include/linux/sunrpc/auth.h                    |    1 +
 include/linux/sunrpc/clnt.h                    |    3 +-
 include/linux/syscalls.h                       |    2 +
 include/linux/sysctl.h                         |    2 +
 include/linux/sysfs.h                          |    2 +
 include/linux/time.h                           |    3 +
 include/linux/types.h                          |    3 +
 include/linux/vroot.h                          |   51 ++
 include/linux/vs_base.h                        |   10 +
 include/linux/vs_context.h                     |  227 +++++
 include/linux/vs_cowbl.h                       |   47 +
 include/linux/vs_cvirt.h                       |   50 ++
 include/linux/vs_device.h                      |   45 +
 include/linux/vs_dlimit.h                      |  211 +++++
 include/linux/vs_inet.h                        |  342 ++++++++
 include/linux/vs_inet6.h                       |  229 +++++
 include/linux/vs_limit.h                       |  140 +++
 include/linux/vs_memory.h                      |  159 ++++
 include/linux/vs_network.h                     |  169 ++++
 include/linux/vs_pid.h                         |   95 ++
 include/linux/vs_sched.h                       |  110 +++
 include/linux/vs_socket.h                      |   67 ++
 include/linux/vs_tag.h                         |   43 +
 include/linux/vs_time.h                        |   19 +
 include/linux/vserver/Kbuild                   |    8 +
 include/linux/vserver/base.h                   |  157 ++++
 include/linux/vserver/cacct.h                  |   15 +
 include/linux/vserver/cacct_cmd.h              |   23 +
 include/linux/vserver/cacct_def.h              |   43 +
 include/linux/vserver/cacct_int.h              |   21 +
 include/linux/vserver/check.h                  |   89 ++
 include/linux/vserver/context.h                |  176 ++++
 include/linux/vserver/context_cmd.h            |  128 +++
 include/linux/vserver/cvirt.h                  |   20 +
 include/linux/vserver/cvirt_cmd.h              |   53 ++
 include/linux/vserver/cvirt_def.h              |   80 ++
 include/linux/vserver/debug.h                  |  127 +++
 include/linux/vserver/debug_cmd.h              |   58 ++
 include/linux/vserver/device.h                 |   15 +
 include/linux/vserver/device_cmd.h             |   44 +
 include/linux/vserver/device_def.h             |   17 +
 include/linux/vserver/dlimit.h                 |   54 ++
 include/linux/vserver/dlimit_cmd.h             |   74 ++
 include/linux/vserver/global.h                 |   20 +
 include/linux/vserver/history.h                |  197 +++++
 include/linux/vserver/inode.h                  |   38 +
 include/linux/vserver/inode_cmd.h              |   59 ++
 include/linux/vserver/limit.h                  |   70 ++
 include/linux/vserver/limit_cmd.h              |   69 ++
 include/linux/vserver/limit_def.h              |   47 +
 include/linux/vserver/limit_int.h              |  198 +++++
 include/linux/vserver/monitor.h                |   96 +++
 include/linux/vserver/network.h                |  146 ++++
 include/linux/vserver/network_cmd.h            |  150 ++++
 include/linux/vserver/percpu.h                 |   14 +
 include/linux/vserver/pid.h                    |   51 ++
 include/linux/vserver/sched.h                  |   26 +
 include/linux/vserver/sched_cmd.h              |  108 +++
 include/linux/vserver/sched_def.h              |   68 ++
 include/linux/vserver/signal.h                 |   14 +
 include/linux/vserver/signal_cmd.h             |   43 +
 include/linux/vserver/space.h                  |   13 +
 include/linux/vserver/space_cmd.h              |   29 +
 include/linux/vserver/switch.h                 |  100 +++
 include/linux/vserver/tag.h                    |  143 ++++
 include/linux/vserver/tag_cmd.h                |   22 +
 include/net/addrconf.h                         |    3 +-
 include/net/af_unix.h                          |    1 +
 include/net/inet_sock.h                        |    7 +-
 include/net/inet_timewait_sock.h               |    9 +-
 include/net/route.h                            |   28 +-
 include/net/sock.h                             |    8 +
 init/main.c                                    |    7 +-
 ipc/mqueue.c                                   |   15 +-
 ipc/msg.c                                      |    2 +
 ipc/namespace.c                                |    4 +
 ipc/sem.c                                      |    6 +
 ipc/shm.c                                      |   15 +-
 kernel/Makefile                                |    1 +
 kernel/capability.c                            |    8 +
 kernel/compat.c                                |    4 +-
 kernel/exit.c                                  |   12 +
 kernel/fork.c                                  |   55 ++-
 kernel/kthread.c                               |    3 +-
 kernel/nsproxy.c                               |   74 ++-
 kernel/pid.c                                   |   18 +-
 kernel/pid_namespace.c                         |    3 +
 kernel/posix-timers.c                          |   18 +-
 kernel/printk.c                                |   30 +-
 kernel/ptrace.c                                |   10 +
 kernel/sched.c                                 |   32 +-
 kernel/sched_fair.c                            |    5 +
 kernel/sched_hard.h                            |  324 +++++++
 kernel/sched_mon.h                             |  200 +++++
 kernel/signal.c                                |   35 +-
 kernel/softirq.c                               |    1 +
 kernel/sys.c                                   |   22 +-
 kernel/sysctl.c                                |   10 +
 kernel/sysctl_check.c                          |   18 +
 kernel/time.c                                  |    9 +-
 kernel/timer.c                                 |   27 +-
 kernel/user.c                                  |   22 +-
 kernel/user_namespace.c                        |    3 +
 kernel/utsname.c                               |    3 +
 kernel/vserver/Kconfig                         |  251 ++++++
 kernel/vserver/Makefile                        |   18 +
 kernel/vserver/cacct.c                         |   42 +
 kernel/vserver/cacct_init.h                    |   25 +
 kernel/vserver/cacct_proc.h                    |   53 ++
 kernel/vserver/context.c                       | 1010 ++++++++++++++++++++++
 kernel/vserver/cvirt.c                         |  301 +++++++
 kernel/vserver/cvirt_init.h                    |   69 ++
 kernel/vserver/cvirt_proc.h                    |  135 +++
 kernel/vserver/debug.c                         |   32 +
 kernel/vserver/device.c                        |  443 ++++++++++
 kernel/vserver/dlimit.c                        |  522 ++++++++++++
 kernel/vserver/helper.c                        |  199 +++++
 kernel/vserver/history.c                       |  258 ++++++
 kernel/vserver/inet.c                          |  225 +++++
 kernel/vserver/init.c                          |   45 +
 kernel/vserver/inode.c                         |  410 +++++++++
 kernel/vserver/limit.c                         |  319 +++++++
 kernel/vserver/limit_init.h                    |   31 +
 kernel/vserver/limit_proc.h                    |   57 ++
 kernel/vserver/monitor.c                       |  138 +++
 kernel/vserver/network.c                       |  864 +++++++++++++++++++
 kernel/vserver/proc.c                          | 1086 ++++++++++++++++++++++++
 kernel/vserver/sched.c                         |  413 +++++++++
 kernel/vserver/sched_init.h                    |   50 ++
 kernel/vserver/sched_proc.h                    |   57 ++
 kernel/vserver/signal.c                        |  132 +++
 kernel/vserver/space.c                         |  372 ++++++++
 kernel/vserver/switch.c                        |  537 ++++++++++++
 kernel/vserver/sysctl.c                        |  244 ++++++
 kernel/vserver/tag.c                           |   63 ++
 kernel/vserver/vci_config.h                    |   81 ++
 mm/filemap_xip.c                               |    1 +
 mm/fremap.c                                    |    1 +
 mm/hugetlb.c                                   |    1 +
 mm/memory.c                                    |   23 +-
 mm/mlock.c                                     |   14 +-
 mm/mmap.c                                      |   34 +-
 mm/mremap.c                                    |   12 +-
 mm/nommu.c                                     |    6 +-
 mm/oom_kill.c                                  |   19 +-
 mm/page_alloc.c                                |    8 +
 mm/rmap.c                                      |    1 +
 mm/shmem.c                                     |    5 +-
 mm/slab.c                                      |    5 +
 mm/slab_vs.h                                   |   27 +
 mm/swapfile.c                                  |    4 +
 net/core/dev.c                                 |    6 +
 net/core/rtnetlink.c                           |    5 +
 net/core/sock.c                                |   24 +
 net/ipv4/af_inet.c                             |   21 +-
 net/ipv4/devinet.c                             |   15 +-
 net/ipv4/fib_hash.c                            |    2 +-
 net/ipv4/inet_connection_sock.c                |   36 +-
 net/ipv4/inet_diag.c                           |   24 +-
 net/ipv4/inet_hashtables.c                     |   10 +-
 net/ipv4/netfilter.c                           |    2 +-
 net/ipv4/netfilter/nf_nat_helper.c             |    1 +
 net/ipv4/raw.c                                 |   38 +-
 net/ipv4/syncookies.c                          |    1 +
 net/ipv4/tcp.c                                 |    1 +
 net/ipv4/tcp_ipv4.c                            |   43 +-
 net/ipv4/tcp_minisocks.c                       |    9 +
 net/ipv4/udp.c                                 |   38 +-
 net/ipv6/Kconfig                               |    4 +-
 net/ipv6/addrconf.c                            |   49 +-
 net/ipv6/af_inet6.c                            |   27 +-
 net/ipv6/fib6_rules.c                          |    2 +-
 net/ipv6/inet6_hashtables.c                    |    4 +
 net/ipv6/ip6_output.c                          |    2 +-
 net/ipv6/ndisc.c                               |    2 +-
 net/ipv6/route.c                               |    3 +-
 net/ipv6/tcp_ipv6.c                            |   12 +-
 net/ipv6/udp.c                                 |    5 +
 net/ipv6/xfrm6_policy.c                        |    2 +-
 net/netlink/af_netlink.c                       |   11 +-
 net/sctp/ipv6.c                                |    3 +-
 net/socket.c                                   |   48 +-
 net/sunrpc/auth.c                              |    3 +
 net/sunrpc/auth_unix.c                         |   16 +-
 net/sunrpc/clnt.c                              |    4 +
 net/unix/af_unix.c                             |    9 +-
 net/x25/af_x25.c                               |    5 +-
 scripts/checksyscalls.sh                       |    1 -
 security/commoncap.c                           |   23 +-
 security/selinux/hooks.c                       |    1 -
 429 files changed, 18083 insertions(+), 641 deletions(-)
-- 
Sincerely,
           Stephen R. van den Berg.

"My name is Smith, the P is not pronounced."

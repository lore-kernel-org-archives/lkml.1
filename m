Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbZAOT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbZAOT6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZAOT5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:57:54 -0500
Received: from kroah.org ([198.145.64.141]:34208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753893AbZAOT5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:57:53 -0500
Date: Thu, 15 Jan 2009 11:55:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/94] 2.6.28.1 stable review
Message-ID: <20090115195520.GA14403@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.28.1 release.
There are 94 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, January 17, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                   |    2 +-
 arch/Kconfig                               |    3 +
 arch/alpha/kernel/entry.S                  |    8 +-
 arch/alpha/kernel/systbls.S                |    2 +-
 arch/arm/kernel/calls.S                    |    2 +-
 arch/cris/arch-v10/kernel/entry.S          |    2 +-
 arch/cris/arch-v32/kernel/entry.S          |    2 +-
 arch/h8300/kernel/syscalls.S               |    2 +-
 arch/ia64/ia32/ia32_entry.S                |    2 +-
 arch/ia64/include/asm/unistd.h             |    2 +-
 arch/ia64/kernel/entry.S                   |    2 +-
 arch/ia64/kernel/sys_ia64.c                |    2 +-
 arch/m68k/kernel/entry.S                   |    2 +-
 arch/m68knommu/kernel/syscalltable.S       |    2 +-
 arch/mips/kernel/scall32-o32.S             |    2 +-
 arch/mn10300/kernel/entry.S                |    2 +-
 arch/powerpc/Kconfig                       |    1 +
 arch/powerpc/include/asm/systbl.h          |    2 +-
 arch/powerpc/platforms/pseries/Kconfig     |    2 +-
 arch/s390/Kconfig                          |    1 +
 arch/s390/kernel/compat_wrapper.S          |    4 +-
 arch/s390/kernel/entry.h                   |   16 ++--
 arch/s390/kernel/process.c                 |    9 +-
 arch/s390/kernel/signal.c                  |   19 ++--
 arch/s390/kernel/sys_s390.c                |   35 ++++---
 arch/s390/kernel/syscalls.S                |   12 +-
 arch/sh/include/asm/syscalls_32.h          |    6 +-
 arch/sh/kernel/sys_sh32.c                  |    2 +-
 arch/sh/kernel/syscalls_32.S               |    4 +-
 arch/sh/kernel/syscalls_64.S               |    2 +-
 arch/sparc/kernel/entry.S                  |    4 +-
 arch/sparc/kernel/systbls.S                |    4 +-
 arch/sparc64/kernel/syscalls.S             |    2 +-
 arch/sparc64/kernel/systbls.S              |    4 +-
 arch/x86/Kconfig                           |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    8 ++
 arch/x86/kernel/cpu/intel.c                |    8 +-
 arch/x86/kernel/head64.c                   |    2 +-
 arch/x86/kernel/head_64.S                  |    2 +-
 arch/x86/kernel/syscall_table_32.S         |    2 +-
 arch/x86/kernel/tlb_uv.c                   |    9 --
 arch/x86/mm/fault.c                        |    2 +-
 drivers/dma/ioat_dma.c                     |   13 +-
 drivers/hid/hid-sony.c                     |    2 +-
 drivers/ide/tx4938ide.c                    |    4 +-
 drivers/ide/tx4939ide.c                    |   10 ++-
 drivers/md/bitmap.c                        |    8 +-
 drivers/md/dm-log.c                        |    5 +
 drivers/md/dm-raid1.c                      |    6 +-
 drivers/net/wireless/ath5k/phy.c           |    4 +-
 drivers/net/wireless/ath5k/reset.c         |    4 +-
 drivers/net/wireless/ath9k/recv.c          |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   12 +--
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   29 +++--
 drivers/pci/syscall.c                      |   12 +--
 drivers/scsi/eata.c                        |   15 ++-
 drivers/scsi/ibmvscsi/ibmvfc.c             |   25 +++--
 drivers/scsi/ibmvscsi/ibmvfc.h             |    6 +-
 drivers/scsi/mvsas.c                       |    2 +-
 drivers/scsi/pcmcia/aha152x_stub.c         |    2 +-
 drivers/usb/host/isp1760-if.c              |  113 +++++++++++--------
 drivers/usb/misc/emi26.c                   |    2 +-
 drivers/usb/storage/unusual_devs.h         |   23 ++++-
 fs/affs/file.c                             |    2 +-
 fs/afs/write.c                             |    2 +-
 fs/aio.c                                   |   22 ++--
 fs/buffer.c                                |    6 +-
 fs/cifs/cifs_dfs_ref.c                     |   48 ++++++--
 fs/cifs/file.c                             |    2 +-
 fs/compat.c                                |    6 +-
 fs/dcache.c                                |    7 +-
 fs/dcookies.c                              |   10 ++-
 fs/ecryptfs/inode.c                        |    3 +-
 fs/ecryptfs/mmap.c                         |    2 +-
 fs/eventfd.c                               |    5 +-
 fs/eventpoll.c                             |   18 ++--
 fs/exec.c                                  |    2 +-
 fs/ext3/inode.c                            |    2 +-
 fs/ext3/namei.c                            |    3 +-
 fs/ext4/inode.c                            |    4 +-
 fs/ext4/namei.c                            |    3 +-
 fs/fcntl.c                                 |   11 +-
 fs/filesystems.c                           |    2 +-
 fs/fuse/file.c                             |    4 +-
 fs/gfs2/ops_address.c                      |    2 +-
 fs/hostfs/hostfs_kern.c                    |    2 +-
 fs/inotify_user.c                          |    9 +-
 fs/ioctl.c                                 |    2 +-
 fs/ioprio.c                                |    5 +-
 fs/jffs2/file.c                            |    2 +-
 fs/libfs.c                                 |    2 +-
 fs/locks.c                                 |    2 +-
 fs/minix/dir.c                             |    2 +-
 fs/namei.c                                 |   48 ++++----
 fs/namespace.c                             |   13 +-
 fs/nfs/file.c                              |    2 +-
 fs/nfs/read.c                              |    6 -
 fs/nfsctl.c                                |    4 +-
 fs/open.c                                  |   82 ++++++++------
 fs/pipe.c                                  |    4 +-
 fs/quota.c                                 |    3 +-
 fs/read_write.c                            |   49 ++++++---
 fs/readdir.c                               |    9 +-
 fs/reiserfs/inode.c                        |    2 +-
 fs/select.c                                |   29 +++---
 fs/signalfd.c                              |    8 +-
 fs/smbfs/file.c                            |    2 +-
 fs/splice.c                                |   12 +-
 fs/stat.c                                  |   38 ++++---
 fs/super.c                                 |    2 +-
 fs/sync.c                                  |   32 ++++-
 fs/timerfd.c                               |   10 +-
 fs/ubifs/file.c                            |    9 +-
 fs/utimes.c                                |   11 +-
 fs/xattr.c                                 |   53 ++++-----
 include/linux/compat.h                     |   13 ++
 include/linux/fs.h                         |    5 +-
 include/linux/mm.h                         |    1 -
 include/linux/pagemap.h                    |    3 +-
 include/linux/radix-tree.h                 |    2 +-
 include/linux/syscalls.h                   |  171 +++++++++++++++++++---------
 include/linux/time.h                       |    1 +
 ipc/mqueue.c                               |   28 +++---
 ipc/msg.c                                  |   12 +-
 ipc/sem.c                                  |   18 ++-
 ipc/shm.c                                  |    8 +-
 kernel/acct.c                              |    2 +-
 kernel/capability.c                        |    4 +-
 kernel/cgroup.c                            |    6 +-
 kernel/exec_domain.c                       |    3 +-
 kernel/exit.c                              |   17 ++--
 kernel/fork.c                              |    4 +-
 kernel/futex.c                             |   17 ++--
 kernel/hrtimer.c                           |    4 +-
 kernel/itimer.c                            |    7 +-
 kernel/kexec.c                             |    5 +-
 kernel/module.c                            |   10 +-
 kernel/posix-timers.c                      |   43 +++----
 kernel/printk.c                            |    7 +-
 kernel/ptrace.c                            |    2 +-
 kernel/sched.c                             |   30 +++---
 kernel/sched_clock.c                       |    5 +-
 kernel/signal.c                            |   59 ++++------
 kernel/sys.c                               |   72 ++++++------
 kernel/sys_ni.c                            |    1 +
 kernel/sysctl.c                            |    4 +-
 kernel/time.c                              |   14 +-
 kernel/time/timekeeping.c                  |    7 +-
 kernel/timer.c                             |   18 ++--
 kernel/trace/ring_buffer.c                 |   19 +++-
 kernel/uid16.c                             |   39 ++++---
 mm/fadvise.c                               |   18 +++-
 mm/filemap.c                               |   22 +++-
 mm/fremap.c                                |    4 +-
 mm/madvise.c                               |    2 +-
 mm/mempolicy.c                             |   24 ++--
 mm/migrate.c                               |    8 +-
 mm/mincore.c                               |    4 +-
 mm/mlock.c                                 |    8 +-
 mm/mmap.c                                  |    4 +-
 mm/mprotect.c                              |    4 +-
 mm/mremap.c                                |    6 +-
 mm/msync.c                                 |    2 +-
 mm/nommu.c                                 |   10 +-
 mm/swapfile.c                              |    4 +-
 mm/vmalloc.c                               |    5 +-
 net/socket.c                               |   63 +++++-----
 security/device_cgroup.c                   |    3 +
 security/keys/keyctl.c                     |   22 ++--
 sound/pci/hda/patch_analog.c               |    5 +-
 sound/pci/hda/patch_sigmatel.c             |    2 +
 sound/usb/caiaq/caiaq-device.h             |    1 +
 sound/usb/caiaq/caiaq-midi.c               |   32 +++---
 173 files changed, 1167 insertions(+), 872 deletions(-)

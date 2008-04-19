Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbYDSSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbYDSSlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbYDSSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:41:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbYDSSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:41:07 -0400
Date: Sat, 19 Apr 2008 12:40:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: Pull request for semaphore include changes
Message-ID: <20080419184029.GO20637@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Thanks for pulling the generic semaphores.  This follow-on series
removes all in-tree references to asm/semaphore.h.  Many of the existing
references are in files which do not use semaphores, so they are simply
deleted.  The remainder are converted to use linux/semaphore.h.

As you can imagine, this has the potential to conflict with just about
any patch.  I've fixed it up for the latest git tree, but obviously
it's likely to cause conflicts whenever it goes in.  It was a pain to
keep up with breakage-of-the day when it was in linux-next, so I dropped
all of these temporarily from the earlier semaphore tree.  If it causes
problems when you try to pull it, just kick it back to me and I'll redo
it on top of your tree.  Or just tell me that you'll pull it right at
the end of the merge window if you like.

The following changes since commit 3925e6fc1f774048404fdd910b0345b06c699eb4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc semaphore

Matthew Wilcox (10):
      arch: Remove unnecessary inclusions of asm/semaphore.h
      net: Remove unnecessary inclusions of asm/semaphore.h
      drivers: Remove unnecessary inclusions of asm/semaphore.h
      fs: Remove unnecessary inclusions of asm/semaphore.h
      include: Remove unnecessary inclusions of asm/semaphore.h
      kernel: Remove unnecessary inclusions of asm/semaphore.h
      lib: Remove unnecessary inclusions of asm/semaphore.h
      security: Remove unnecessary inclusions of asm/semaphore.h
      Convert asm/semaphore.h users to linux/semaphore.h
      Deprecate the asm/semaphore.h files in feature-removal-schedule.

 Documentation/DocBook/kernel-locking.tmpl     |    6 +++---
 Documentation/feature-removal-schedule.txt    |    8 ++++++++
 arch/arm/common/rtctime.c                     |    1 -
 arch/arm/mach-aaec2000/clock.c                |    2 --
 arch/arm/mach-at91/clock.c                    |    1 -
 arch/arm/mach-integrator/clock.c              |    1 -
 arch/arm/mach-pnx4008/clock.c                 |    1 -
 arch/arm/mach-pnx4008/gpio.c                  |    1 -
 arch/arm/mach-realview/clock.c                |    1 -
 arch/arm/mach-versatile/clock.c               |    1 -
 arch/arm/plat-omap/clock.c                    |    1 -
 arch/ia64/kernel/salinfo.c                    |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c           |    1 -
 arch/m68k/atari/stram.c                       |    1 -
 arch/m68k/sun3/intersil.c                     |    1 -
 arch/mips/sgi-ip27/ip27-console.c             |    1 -
 arch/parisc/kernel/sys_parisc32.c             |    1 -
 arch/powerpc/kernel/rtas.c                    |    1 -
 arch/powerpc/kernel/sys_ppc32.c               |    1 -
 arch/powerpc/kernel/syscalls.c                |    1 -
 arch/powerpc/platforms/cell/spufs/file.c      |    1 -
 arch/powerpc/platforms/cell/spufs/inode.c     |    1 -
 arch/powerpc/platforms/powermac/pfunc_core.c  |    1 -
 arch/ppc/syslib/ocp.c                         |    1 -
 arch/s390/kernel/compat_linux.c               |    1 -
 arch/s390/kernel/debug.c                      |    1 -
 arch/sparc64/kernel/sys_sparc32.c             |    1 -
 arch/v850/kernel/syscalls.c                   |    1 -
 arch/x86/ia32/sys_ia32.c                      |    1 -
 arch/x86/kernel/cpu/common.c                  |    1 -
 arch/x86/kernel/cpu/proc.c                    |    1 -
 drivers/ata/libata-core.c                     |    1 -
 drivers/base/core.c                           |    2 +-
 drivers/block/cryptoloop.c                    |    1 -
 drivers/char/generic_serial.c                 |    1 -
 drivers/char/rio/rioboot.c                    |    1 -
 drivers/char/rio/riocmd.c                     |    1 -
 drivers/char/rio/rioctrl.c                    |    1 -
 drivers/char/rio/rioinit.c                    |    1 -
 drivers/char/rio/riointr.c                    |    1 -
 drivers/char/rio/rioparam.c                   |    1 -
 drivers/char/rio/rioroute.c                   |    1 -
 drivers/char/rio/riotable.c                   |    1 -
 drivers/char/rio/riotty.c                     |    1 -
 drivers/char/snsc.h                           |    2 +-
 drivers/firewire/fw-device.c                  |    3 ++-
 drivers/firewire/fw-transaction.c             |    1 -
 drivers/firmware/dcdbas.c                     |    1 -
 drivers/i2c/i2c-core.c                        |    2 +-
 drivers/ieee1394/nodemgr.c                    |    2 +-
 drivers/infiniband/core/user_mad.c            |    2 +-
 drivers/infiniband/hw/amso1100/c2.h           |    1 -
 drivers/infiniband/hw/mthca/mthca_dev.h       |    3 +--
 drivers/infiniband/hw/nes/nes.h               |    1 -
 drivers/input/serio/hp_sdc_mlc.c              |    2 +-
 drivers/lguest/lg.h                           |    1 -
 drivers/macintosh/adb.c                       |    2 +-
 drivers/macintosh/windfarm_smu_sat.c          |    2 +-
 drivers/media/radio/radio-aimslab.c           |    1 -
 drivers/media/video/ir-kbd-i2c.c              |    1 -
 drivers/media/video/ov511.c                   |    1 -
 drivers/media/video/pvrusb2/pvrusb2-context.c |    1 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c   |    1 -
 drivers/mfd/ucb1x00-ts.c                      |    1 -
 drivers/net/3c527.c                           |    2 +-
 drivers/net/cxgb3/adapter.h                   |    1 -
 drivers/net/cxgb3/t3cdev.h                    |    1 -
 drivers/net/hamradio/6pack.c                  |    2 +-
 drivers/net/ibmveth.c                         |    1 -
 drivers/net/netxen/netxen_nic_hdr.h           |    1 -
 drivers/net/usb/kaweth.c                      |    1 -
 drivers/s390/cio/ccwgroup.c                   |    1 -
 drivers/s390/cio/qdio.c                       |    2 +-
 drivers/scsi/aacraid/aachba.c                 |    1 -
 drivers/scsi/aacraid/commctrl.c               |    2 +-
 drivers/scsi/aacraid/comminit.c               |    1 -
 drivers/scsi/aacraid/commsup.c                |    2 +-
 drivers/scsi/aacraid/dpcsup.c                 |    2 +-
 drivers/scsi/aacraid/linit.c                  |    1 -
 drivers/scsi/aacraid/rx.c                     |    1 -
 drivers/scsi/aacraid/sa.c                     |    1 -
 drivers/scsi/dpt/dpti_i2o.h                   |    1 -
 drivers/scsi/megaraid/mega_common.h           |    1 -
 drivers/scsi/megaraid/megaraid_ioctl.h        |    2 +-
 drivers/scsi/qla2xxx/qla_def.h                |    2 +-
 drivers/serial/mcfserial.c                    |    1 -
 drivers/usb/atm/usbatm.h                      |    1 -
 drivers/usb/core/hub.c                        |    1 -
 drivers/usb/misc/appledisplay.c               |    1 -
 drivers/usb/serial/io_ti.c                    |    1 -
 drivers/usb/serial/ti_usb_3410_5052.c         |    1 -
 drivers/watchdog/sc1200wdt.c                  |    2 +-
 fs/9p/fid.c                                   |    1 -
 fs/cramfs/inode.c                             |    1 -
 fs/dlm/dlm_internal.h                         |    1 -
 fs/jffs2/jffs2_fs_i.h                         |    2 +-
 fs/jffs2/jffs2_fs_sb.h                        |    2 +-
 fs/locks.c                                    |    1 -
 fs/reiserfs/journal.c                         |    2 +-
 fs/reiserfs/xattr.c                           |    1 -
 fs/xfs/linux-2.6/sema.h                       |    2 +-
 include/asm-blackfin/dma.h                    |    1 -
 include/asm-ia64/sn/nodepda.h                 |    1 -
 include/asm-ppc/ocp.h                         |    1 -
 include/linux/cpu.h                           |    1 -
 include/linux/device.h                        |    2 +-
 include/linux/fs.h                            |    2 +-
 include/linux/hil_mlc.h                       |    2 +-
 include/linux/i2o.h                           |    2 +-
 include/linux/ide.h                           |    1 -
 include/linux/if_pppox.h                      |    1 -
 include/linux/jbd.h                           |    2 --
 include/linux/jbd2.h                          |    2 --
 include/linux/kernelcapi.h                    |    1 -
 include/linux/memory.h                        |    3 +--
 include/linux/parport.h                       |    2 +-
 include/linux/raid/md.h                       |    1 -
 include/linux/sched.h                         |    1 -
 include/linux/syscalls.h                      |    1 -
 include/scsi/libsas.h                         |    1 -
 kernel/kexec.c                                |    1 -
 kernel/kthread.c                              |    1 -
 kernel/module.c                               |    3 +--
 kernel/posix-timers.c                         |    1 -
 kernel/profile.c                              |    1 -
 kernel/stop_machine.c                         |    1 -
 lib/kernel_lock.c                             |    2 +-
 lib/reed_solomon/reed_solomon.c               |    1 -
 net/core/flow.c                               |    1 -
 net/dccp/proto.c                              |    1 -
 net/ipv4/ipcomp.c                             |    1 -
 net/ipv6/ipcomp6.c                            |    1 -
 security/selinux/selinuxfs.c                  |    1 -
 security/selinux/ss/conditional.c             |    1 -
 security/selinux/xfrm.c                       |    1 -
 136 files changed, 44 insertions(+), 143 deletions(-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

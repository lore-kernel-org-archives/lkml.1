Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZGKSIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZGKSIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZGKSIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:08:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:33558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZGKSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HrXsOrKKJB5HwCdLkBZxXPbIjBjOA8W//eD7ncug8rmtNgdnmkmg6qimPH9lUoCUlf
         nYmOrusv05neqEAblJL3GI32KIwTX6ZlYrRXjp7WXAG1xrT5MZyyffMJBy6OncseB01V
         YhGQloCGmA1LeD1/Zen5AgON1ffmRCBbGq8lo=
Date: Sat, 11 Jul 2009 22:08:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: smp_lock.h redux
Message-ID: <20090711180836.GA24798@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove smp_lock.h from files which don't need it (including some headers!)
* Add smp_lock.h to files which do need it
* Make smp_lock.h include conditional in hardirq.h
  It's needed only for one kernel_locked() usage which is under CONFIG_PREEMPT

  This will make hardirq.h inclusion cheaper for every PREEMPT=n config
  (which includes allmodconfig/allyesconfig, BTW)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/ptrace.c                      |    1 -
 arch/blackfin/kernel/ptrace.c                   |    1 -
 arch/blackfin/kernel/sys_bfin.c                 |    1 -
 arch/cris/kernel/sys_cris.c                     |    1 -
 arch/ia64/kernel/ptrace.c                       |    1 -
 arch/m32r/kernel/ptrace.c                       |    1 -
 arch/microblaze/kernel/ptrace.c                 |    1 -
 arch/microblaze/kernel/signal.c                 |    1 -
 arch/microblaze/kernel/sys_microblaze.c         |    1 -
 arch/mips/kernel/ptrace32.c                     |    1 -
 arch/mips/mm/hugetlbpage.c                      |    1 -
 arch/mn10300/kernel/ptrace.c                    |    1 -
 arch/mn10300/kernel/signal.c                    |    1 -
 arch/mn10300/kernel/sys_mn10300.c               |    1 -
 arch/mn10300/kernel/traps.c                     |    1 -
 arch/mn10300/mm/fault.c                         |    1 -
 arch/mn10300/mm/misalignment.c                  |    1 -
 arch/powerpc/kernel/ptrace32.c                  |    1 -
 arch/s390/kernel/dis.c                          |    1 -
 arch/s390/kernel/ptrace.c                       |    1 -
 arch/s390/mm/fault.c                            |    1 -
 arch/sh/mm/tlb-sh3.c                            |    1 -
 arch/sparc/kernel/ptrace_32.c                   |    1 -
 arch/sparc/kernel/ptrace_64.c                   |    1 -
 arch/sparc/kernel/time_64.c                     |    1 -
 arch/sparc/kernel/traps_32.c                    |    1 -
 drivers/block/DAC960.c                          |    1 +
 drivers/block/cciss.c                           |    1 +
 drivers/block/loop.c                            |    1 -
 drivers/bluetooth/hci_vhci.c                    |    1 -
 drivers/char/amiserial.c                        |    1 +
 drivers/char/cyclades.c                         |    1 +
 drivers/char/epca.c                             |    1 +
 drivers/char/isicom.c                           |    1 +
 drivers/char/istallion.c                        |    1 +
 drivers/char/moxa.c                             |    1 +
 drivers/char/mxser.c                            |    1 +
 drivers/char/n_hdlc.c                           |    1 +
 drivers/char/n_r3964.c                          |    1 +
 drivers/char/pty.c                              |    1 +
 drivers/char/rio/rio_linux.c                    |    1 +
 drivers/char/riscom8.c                          |    1 +
 drivers/char/rocket.c                           |    1 +
 drivers/char/serial167.c                        |    1 +
 drivers/char/specialix.c                        |    1 +
 drivers/char/sx.c                               |    1 +
 drivers/char/synclink.c                         |    1 +
 drivers/char/synclink_gt.c                      |    1 +
 drivers/char/synclinkmp.c                       |    1 +
 drivers/char/tpm/tpm.c                          |    1 -
 drivers/char/tty_ioctl.c                        |    1 -
 drivers/char/tty_ldisc.c                        |    1 -
 drivers/char/vt.c                               |    1 +
 drivers/char/vt_ioctl.c                         |    1 +
 drivers/gpio/vr41xx_giu.c                       |    1 -
 drivers/hid/usbhid/hid-core.c                   |    1 -
 drivers/isdn/hisax/hfc_usb.c                    |    1 -
 drivers/isdn/i4l/isdn_tty.c                     |    1 +
 drivers/isdn/mISDN/stack.c                      |    1 +
 drivers/media/dvb/bt8xx/dst_ca.c                |    1 +
 drivers/media/dvb/dvb-core/dvbdev.h             |    1 -
 drivers/media/dvb/ttpci/av7110.c                |    1 -
 drivers/media/radio/radio-mr800.c               |    1 +
 drivers/media/radio/radio-si470x.c              |    1 +
 drivers/media/video/bt8xx/bttv-driver.c         |    1 +
 drivers/media/video/cx23885/cx23885-417.c       |    1 +
 drivers/media/video/cx23885/cx23885-video.c     |    1 +
 drivers/media/video/cx88/cx88-blackbird.c       |    1 +
 drivers/media/video/cx88/cx88-video.c           |    1 +
 drivers/media/video/dabusb.c                    |    1 +
 drivers/media/video/pwc/pwc-if.c                |    1 +
 drivers/media/video/pwc/pwc.h                   |    1 -
 drivers/media/video/s2255drv.c                  |    1 +
 drivers/media/video/saa5246a.c                  |    1 -
 drivers/media/video/saa5249.c                   |    1 -
 drivers/media/video/saa7134/saa7134-empress.c   |    1 +
 drivers/media/video/se401.c                     |    1 +
 drivers/media/video/stk-webcam.c                |    1 +
 drivers/media/video/stradis.c                   |    1 +
 drivers/media/video/stv680.c                    |    1 +
 drivers/media/video/usbvideo/vicam.c            |    1 +
 drivers/media/video/usbvision/usbvision-video.c |    1 +
 drivers/media/video/v4l2-dev.c                  |    1 -
 drivers/media/video/zoran/zoran_driver.c        |    1 +
 drivers/misc/sgi-gru/grufile.c                  |    1 -
 drivers/misc/sgi-gru/grukservices.c             |    1 -
 drivers/net/irda/irtty-sir.c                    |    1 -
 drivers/pci/hotplug/cpci_hotplug_core.c         |    1 -
 drivers/pci/hotplug/cpqphp_ctrl.c               |    1 -
 drivers/pci/hotplug/cpqphp_sysfs.c              |    1 +
 drivers/pci/hotplug/pciehp_ctrl.c               |    1 -
 drivers/pci/syscall.c                           |    1 -
 drivers/s390/block/dasd_ioctl.c                 |    1 +
 drivers/scsi/qla2xxx/qla_mid.c                  |    1 -
 drivers/telephony/ixj.c                         |    1 +
 drivers/telephony/phonedev.c                    |    1 -
 drivers/usb/class/cdc-wdm.c                     |    1 -
 drivers/usb/gadget/amd5536udc.c                 |    1 -
 drivers/usb/gadget/langwell_udc.c               |    1 -
 drivers/usb/gadget/s3c2410_udc.c                |    1 -
 drivers/usb/host/r8a66597-hcd.c                 |    1 -
 drivers/usb/misc/iowarrior.c                    |    1 +
 drivers/usb/misc/rio500.c                       |    1 +
 drivers/usb/misc/usblcd.c                       |    1 +
 drivers/usb/musb/cppi_dma.h                     |    1 -
 drivers/usb/musb/musb_core.h                    |    1 -
 drivers/usb/serial/ftdi_sio.c                   |    1 +
 drivers/usb/serial/mos7840.c                    |    1 +
 drivers/usb/serial/usb-serial.c                 |    1 +
 drivers/video/fbmem.c                           |    1 -
 fs/adfs/super.c                                 |    1 +
 fs/afs/super.c                                  |    1 +
 fs/autofs4/dev-ioctl.c                          |    1 -
 fs/bfs/dir.c                                    |    1 -
 fs/bfs/file.c                                   |    1 -
 fs/btrfs/compression.c                          |    1 -
 fs/btrfs/file.c                                 |    1 -
 fs/btrfs/inode.c                                |    1 -
 fs/btrfs/ioctl.c                                |    1 -
 fs/btrfs/super.c                                |    1 -
 fs/char_dev.c                                   |    1 -
 fs/compat.c                                     |    1 -
 fs/compat_ioctl.c                               |    1 +
 fs/exofs/super.c                                |    1 +
 fs/ext2/ioctl.c                                 |    1 -
 fs/ext4/ioctl.c                                 |    1 -
 fs/fat/dir.c                                    |    1 -
 fs/fat/namei_msdos.c                            |    1 -
 fs/fat/namei_vfat.c                             |    1 -
 fs/fcntl.c                                      |    1 -
 fs/freevxfs/vxfs_super.c                        |    1 +
 fs/hfs/super.c                                  |    1 +
 fs/hfsplus/super.c                              |    1 +
 fs/hpfs/dir.c                                   |    1 +
 fs/hpfs/file.c                                  |    1 +
 fs/hpfs/hpfs_fn.h                               |    1 -
 fs/hpfs/inode.c                                 |    1 +
 fs/hpfs/namei.c                                 |    1 +
 fs/jffs2/super.c                                |    1 +
 fs/lockd/clntproc.c                             |    1 +
 fs/lockd/svc4proc.c                             |    1 +
 fs/lockd/svcproc.c                              |    1 +
 fs/nfs/delegation.c                             |    1 +
 fs/nfs/dir.c                                    |    1 -
 fs/nfs/file.c                                   |    1 -
 fs/nfs/inode.c                                  |    1 -
 fs/nfs/nfs4proc.c                               |    1 -
 fs/nfs/read.c                                   |    1 -
 fs/nfsd/nfsctl.c                                |    1 -
 fs/nfsd/nfssvc.c                                |    1 -
 fs/nilfs2/dir.c                                 |    1 -
 fs/ocfs2/ioctl.c                                |    1 -
 fs/reiserfs/xattr.c                             |    1 -
 fs/squashfs/super.c                             |    1 +
 fs/ubifs/ioctl.c                                |    1 -
 fs/xfs/linux-2.6/xfs_file.c                     |    1 -
 include/linux/crash_dump.h                      |    1 -
 include/linux/hardirq.h                         |    2 ++
 include/linux/quotaops.h                        |    1 -
 include/linux/sunrpc/xdr.h                      |    1 -
 kernel/power/user.c                             |    1 -
 kernel/trace/blktrace.c                         |    1 +
 kernel/trace/trace.c                            |    1 +
 net/appletalk/ddp.c                             |    1 +
 net/ipx/af_ipx.c                                |    1 +
 net/irda/af_irda.c                              |    1 +
 net/irda/irnet/irnet.h                          |    1 -
 net/irda/irnet/irnet_ppp.c                      |    1 +
 net/sunrpc/clnt.c                               |    1 -
 net/sunrpc/sched.c                              |    1 -
 net/sunrpc/svc_xprt.c                           |    1 +
 net/wanrouter/wanmain.c                         |    1 +
 net/x25/af_x25.c                                |    1 +
 173 files changed, 81 insertions(+), 93 deletions(-)

--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -8,7 +8,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -31,7 +31,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -29,7 +29,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/cris/kernel/sys_cris.c
+++ b/arch/cris/kernel/sys_cris.c
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
-#include <linux/smp_lock.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/audit.h>
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -19,7 +19,6 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -21,7 +21,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/mips/kernel/ptrace32.c
+++ b/arch/mips/kernel/ptrace32.c
@@ -22,7 +22,6 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/user.h>
 #include <linux/security.h>
 
--- a/arch/mips/mm/hugetlbpage.c
+++ b/arch/mips/mm/hugetlbpage.c
@@ -16,7 +16,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -13,7 +13,6 @@
 #include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -17,7 +17,6 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -20,7 +20,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -17,7 +17,6 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -21,7 +21,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -15,7 +15,6 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -22,7 +22,6 @@
 #include <linux/compat.h>
 #include <linux/smp.h>
 #include <linux/kdebug.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/module.h>
--- a/arch/sh/mm/tlb-sh3.c
+++ b/arch/sh/mm/tlb-sh3.c
@@ -18,7 +18,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 
 #include <asm/system.h>
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -16,7 +16,6 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/regset.h>
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -17,7 +17,6 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/security.h>
 #include <linux/seccomp.h>
 #include <linux/audit.h>
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -11,7 +11,6 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/param.h>
 #include <linux/string.h>
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kdebug.h>
 
 #include <asm/delay.h>
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -36,6 +36,7 @@
 #include <linux/ioport.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/proc_fs.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/major.h>
 #include <linux/fs.h>
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -61,7 +61,6 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/loop.h>
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -81,6 +81,7 @@ static char *serial_version = "4.30";
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -633,6 +633,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -36,6 +36,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -122,6 +122,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/serial.h>
+#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -34,6 +34,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/major.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -97,6 +97,7 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/errno.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>	/* used in new tty drivers */
 #include <linux/signal.h>	/* used in new tty drivers */
 #include <linux/if.h>
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -58,6 +58,7 @@
 #include <linux/ioport.h>
 #include <linux/in.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/errno.h>
 #include <linux/string.h>	/* used in new tty drivers */
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -22,6 +22,7 @@
 #include <linux/major.h>
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/device.h>
 #include <linux/uaccess.h>
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -44,6 +44,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
 
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -47,6 +47,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
+#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -73,6 +73,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -52,6 +52,7 @@
 #include <linux/interrupt.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -87,6 +87,7 @@
 #include <linux/tty_flip.h>
 #include <linux/mm.h>
 #include <linux/serial.h>
+#include <linux/smp_lock.h>
 #include <linux/fcntl.h>
 #include <linux/major.h>
 #include <linux/delay.h>
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -216,6 +216,7 @@
 #include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/bitops.h>
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -81,6 +81,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -62,6 +62,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -52,6 +52,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -26,7 +26,6 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 
 #include "tpm.h"
 
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -21,7 +21,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -89,6 +89,7 @@
 #include <linux/mutex.h>
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
+#include <linux/smp_lock.h>
 #include <linux/tiocl.h>
 #include <linux/kbd_kern.h>
 #include <linux/consolemap.h>
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -25,6 +25,7 @@
 #include <linux/console.h>
 #include <linux/consolemap.h>
 #include <linux/signal.h>
+#include <linux/smp_lock.h>
 #include <linux/timex.h>
 
 #include <asm/io.h>
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -37,7 +37,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/usb.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
 #include "hisax.h"
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -13,6 +13,7 @@
 
 #include <linux/isdn.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include "isdn_common.h"
 #include "isdn_tty.h"
 #ifdef CONFIG_ISDN_AUDIO
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -17,6 +17,7 @@
 
 #include <linux/mISDNif.h>
 #include <linux/kthread.h>
+#include <linux/smp_lock.h>
 #include "core.h"
 
 static u_int	*debug;
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/dvb/ca.h>
 #include "dvbdev.h"
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -27,7 +27,6 @@
 #include <linux/poll.h>
 #include <linux/fs.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 
 #define DVB_MAJOR 212
 
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -58,6 +58,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
--- a/drivers/media/radio/radio-si470x.c
+++ b/drivers/media/radio/radio-si470x.c
@@ -127,6 +127,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kdev_t.h>
 #include "bttvp.h"
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -26,6 +26,7 @@
 #include <linux/kmod.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/smp_lock.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -31,6 +31,7 @@
 #include <linux/kmod.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -32,6 +32,7 @@
 #include <linux/list.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -62,6 +62,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 #include <linux/usb/input.h>
 #endif
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -29,7 +29,6 @@
 #include <linux/usb.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>
 #include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -48,6 +48,7 @@
 #include <linux/videodev2.h>
 #include <linux/version.h>
 #include <linux/mm.h>
+#include <linux/smp_lock.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -43,7 +43,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -46,7 +46,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/videotext.h>
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 
 #include "saa7134-reg.h"
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -31,6 +31,7 @@ static const char version[] = "0.24";
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/usb.h>
 #include "se401.h"
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 
 #include <linux/usb.h>
 #include <linux/mm.h>
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/poll.h>
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -62,6 +62,7 @@
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
 #include <linux/videodev.h>
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -43,6 +43,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/firmware.h>
 #include <linux/ihex.h>
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -50,6 +50,7 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/highmem.h>
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/io.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -24,7 +24,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -31,7 +31,6 @@
 #include <linux/tty.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -32,7 +32,6 @@
 #include <linux/pci_hotplug.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <asm/atomic.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -34,7 +34,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/kthread.h>
--- a/drivers/pci/hotplug/cpqphp_sysfs.c
+++ b/drivers/pci/hotplug/cpqphp_sysfs.c
@@ -33,6 +33,7 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/smp_lock.h>
 #include <linux/debugfs.h>
 #include "cpqphp.h"
 
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 #include "../pci.h"
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -9,7 +9,6 @@
 
 #include <linux/errno.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include "pci.h"
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
+#include <linux/smp_lock.h>
 
 #include <asm/ccwdev.h>
 #include <asm/cmb.h>
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -9,7 +9,6 @@
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
 #include <linux/list.h>
 
 #include <scsi/scsi_tcq.h>
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -257,6 +257,7 @@
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -23,7 +23,6 @@
 #include <linux/errno.h>
 #include <linux/phonedev.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -48,7 +48,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -34,7 +34,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -28,7 +28,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/usb/iowarrior.h>
 
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/random.h>
 #include <linux/poll.h>
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
--- a/drivers/usb/musb/cppi_dma.h
+++ b/drivers/usb/musb/cppi_dma.h
@@ -5,7 +5,6 @@
 
 #include <linux/slab.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/dmapool.h>
 
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/clk.h>
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -33,6 +33,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -26,6 +26,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -16,7 +16,6 @@
 #include <linux/compat.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -13,6 +13,7 @@
 #include <linux/parser.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/statfs.h>
 #include "adfs.h"
 #include "dir_f.h"
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/parser.h>
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/compat.h>
 #include <linux/syscalls.h>
-#include <linux/smp_lock.h>
 #include <linux/magic.h>
 #include <linux/dcache.h>
 #include <linux/uaccess.h>
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -8,7 +8,6 @@
 #include <linux/time.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/sched.h>
 #include "bfs.h"
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -11,7 +11,6 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include "bfs.h"
 
 #undef DEBUG
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -26,7 +26,6 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
 #include <linux/swap.h>
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -22,7 +22,6 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
 #include <linux/swap.h>
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
 #include <linux/swap.h>
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -27,7 +27,6 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
 #include <linux/mpage.h>
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
 #include <linux/mpage.h>
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -13,7 +13,6 @@
 #include <linux/major.h>
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 
 #include <linux/kobject.h>
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -32,7 +32,6 @@
 #include <linux/smb_mount.h>
 #include <linux/ncp_mount.h>
 #include <linux/nfs4_mount.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
 #include <linux/module.h>
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/smp_lock.h>
 #include <linux/ioctl.h>
 #include <linux/if.h>
 #include <linux/if_bridge.h>
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -33,6 +33,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/vfs.h>
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
-#include <linux/smp_lock.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
 
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -12,7 +12,6 @@
 #include <linux/capability.h>
 #include <linux/time.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 #include <linux/mount.h>
 #include <linux/file.h>
 #include <asm/uaccess.h>
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
 #include <asm/uaccess.h>
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include "fat.h"
 
 /* Characters that are undesirable in an MS-DOS file name */
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -19,7 +19,6 @@
 #include <linux/jiffies.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
 #include "fat.h"
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,7 +19,6 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-#include <linux/smp_lock.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -38,6 +38,7 @@
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/stat.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -19,6 +19,7 @@
 #include <linux/nls.h>
 #include <linux/parser.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 
 #include "hfs_fs.h"
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -12,6 +12,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
 
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -6,6 +6,7 @@
  *  directory VFS functions
  */
 
+#include <linux/smp_lock.h>
 #include "hpfs_fn.h"
 
 static int hpfs_dir_release(struct inode *inode, struct file *filp)
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -6,6 +6,7 @@
  *  file VFS functions
  */
 
+#include <linux/smp_lock.h>
 #include "hpfs_fn.h"
 
 #define BLOCKS(size) (((size) + 511) >> 9)
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include "hpfs.h"
 
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -6,6 +6,7 @@
  *  inode VFS functions
  */
 
+#include <linux/smp_lock.h>
 #include "hpfs_fn.h"
 
 void hpfs_init_inode(struct inode *i)
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -6,6 +6,7 @@
  *  adding & removing files & directories
  */
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include "hpfs_fn.h"
 
 static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/fs.h>
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <linux/nfs4.h>
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -29,7 +29,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/aio.h>
 
 #include <asm/uaccess.h>
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -30,7 +30,6 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/nfs_idmap.h>
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -45,7 +45,6 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
-#include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/module.h>
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -18,7 +18,6 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
-#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/inet.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/ctype.h>
 
 #include <linux/nfs.h>
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -18,7 +18,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/freezer.h>
 #include <linux/fs_struct.h>
 #include <linux/kthread.h>
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -43,7 +43,6 @@
  */
 
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include "nilfs.h"
 #include "page.h"
 
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -7,7 +7,6 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
-#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -46,7 +46,6 @@
 #include <linux/reiserfs_acl.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
-#include <linux/smp_lock.h>
 #include <linux/stat.h>
 #include <linux/quotaops.h>
 
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -30,6 +30,7 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -25,7 +25,6 @@
 /* This file implements EXT2-compatible extended attribute ioctl() calls */
 
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 #include <linux/mount.h>
 #include "ubifs.h"
 
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -41,7 +41,6 @@
 #include "xfs_ioctl.h"
 
 #include <linux/dcache.h>
-#include <linux/smp_lock.h>
 
 static struct vm_operations_struct xfs_file_vm_ops;
 
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_CRASH_DUMP
 #include <linux/kexec.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
 
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -2,7 +2,9 @@
 #define LINUX_HARDIRQ_H
 
 #include <linux/preempt.h>
+#ifdef CONFIG_PREEMPT
 #include <linux/smp_lock.h>
+#endif
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
 #include <asm/hardirq.h>
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -7,7 +7,6 @@
 #ifndef _LINUX_QUOTAOPS_
 #define _LINUX_QUOTAOPS_
 
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 
 static inline struct quota_info *sb_dqopt(struct super_block *sb)
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -12,7 +12,6 @@
 #include <linux/uio.h>
 #include <asm/byteorder.h>
 #include <linux/scatterlist.h>
-#include <linux/smp_lock.h>
 
 /*
  * Buffer adjustment
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -23,7 +23,6 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
-#include <linux/smp_lock.h>
 #include <scsi/scsi_scan.h>
 
 #include <asm/uaccess.h>
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
+#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
 
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -17,6 +17,7 @@
 #include <linux/writeback.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
 #include <linux/debugfs.h>
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -54,6 +54,7 @@
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/if_arp.h>
+#include <linux/smp_lock.h>
 #include <linux/termios.h>	/* For TIOCOUTQ/INQ */
 #include <net/datalink.h>
 #include <net/psnap.h>
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -41,6 +41,7 @@
 #include <linux/netdevice.h>
 #include <linux/uio.h>
 #include <linux/skbuff.h>
+#include <linux/smp_lock.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/string.h>
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -45,6 +45,7 @@
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/smp_lock.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/init.h>
--- a/net/irda/irnet/irnet.h
+++ b/net/irda/irnet/irnet.h
@@ -241,7 +241,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/skbuff.h>
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -13,6 +13,7 @@
  *	2) as a control channel (write commands, read events)
  */
 
+#include <linux/smp_lock.h>
 #include "irnet_ppp.h"		/* Private header */
 /* Please put other headers in irnet.h - Thanks */
 
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -28,7 +28,6 @@
 #include <linux/kallsyms.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/utsname.h>
 #include <linux/workqueue.h>
 #include <linux/in6.h>
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/mempool.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -48,6 +48,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>	/* support for loadable modules */
 #include <linux/slab.h>		/* kmalloc(), kfree() */
+#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/string.h>	/* inline mem*, str* functions */
 
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -40,6 +40,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/net.h>

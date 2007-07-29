Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXG2Wg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXG2Wg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762902AbXG2WgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:36:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:28742 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXG2WgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=l60Z1FdsTwA2/rDJfaMAZV9dcpp06kwKqCvrPuDlqSB2Ms34SPDEm/Wa5CKDSSd6NMhT7YJe1zCLjJn1wXZF0jWaMkWh5G1yFjMcMrZweivnwD1xTbkWhLe3pz61OATXh+fZlXtENa3dBsaI3C+9YtfeS7GHL0pdmNP67eg4R6w=
Date: Mon, 30 Jul 2007 02:36:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: [PATCH] Remove fs.h from mm.h
Message-ID: <20070729223613.GA5916@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

0) Remove fs.h from mm.h. For this,
1) Uninline vma_wants_writenotify(). It's pretty huge anyway.
2) Add back fs.h or less bloated headers (err.h) to files that need it.

As result, on x86_64 allyesconfig, fs.h dependencies cut down from 3929 files
rebuilt down to 3444 (-12.3%).

Cross-compile tested without regressions on my two usual configs and (sigh):

alpha              arm-mx1ads        mips-bigsur          powerpc-ebony
alpha-allnoconfig  arm-neponset      mips-capcella        powerpc-g5
alpha-defconfig    arm-netwinder     mips-cobalt          powerpc-holly
alpha-up           arm-netx          mips-db1000          powerpc-iseries
arm                arm-ns9xxx        mips-db1100          powerpc-linkstation
arm-assabet        arm-omap_h2_1610  mips-db1200          powerpc-lite5200
arm-at91rm9200dk   arm-onearm        mips-db1500          powerpc-maple
arm-at91rm9200ek   arm-picotux200    mips-db1550          powerpc-mpc7448_hpc2
arm-at91sam9260ek  arm-pleb          mips-ddb5477         powerpc-mpc8272_ads
arm-at91sam9261ek  arm-pnx4008       mips-decstation      powerpc-mpc8313_rdb
arm-at91sam9263ek  arm-pxa255-idp    mips-e55             powerpc-mpc832x_mds
arm-at91sam9rlek   arm-realview      mips-emma2rh         powerpc-mpc832x_rdb
arm-ateb9200       arm-realview-smp  mips-excite          powerpc-mpc834x_itx
arm-badge4         arm-rpc           mips-fulong          powerpc-mpc834x_itxgp
arm-carmeva        arm-s3c2410       mips-ip22            powerpc-mpc834x_mds
arm-cerfcube       arm-shannon       mips-ip27            powerpc-mpc836x_mds
arm-clps7500       arm-shark         mips-ip32            powerpc-mpc8540_ads
arm-collie         arm-simpad        mips-jazz            powerpc-mpc8544_ds
arm-corgi          arm-spitz         mips-jmr3927         powerpc-mpc8560_ads
arm-csb337         arm-trizeps4      mips-malta           powerpc-mpc8568mds
arm-csb637         arm-versatile     mips-mipssim         powerpc-mpc85xx_cds
arm-ebsa110        i386              mips-mpc30x          powerpc-mpc8641_hpcn
arm-edb7211        i386-allnoconfig  mips-msp71xx         powerpc-mpc866_ads
arm-em_x270        i386-defconfig    mips-ocelot          powerpc-mpc885_ads
arm-ep93xx         i386-up           mips-pb1100          powerpc-pasemi
arm-footbridge     ia64              mips-pb1500          powerpc-pmac32
arm-fortunet       ia64-allnoconfig  mips-pb1550          powerpc-ppc64
arm-h3600          ia64-bigsur       mips-pnx8550-jbs     powerpc-prpmc2800
arm-h7201          ia64-defconfig    mips-pnx8550-stb810  powerpc-ps3
arm-h7202          ia64-gensparse    mips-qemu            powerpc-pseries
arm-hackkit        ia64-sim          mips-rbhma4200       powerpc-up
arm-integrator     ia64-sn2          mips-rbhma4500       s390
arm-iop13xx        ia64-tiger        mips-rm200           s390-allnoconfig
arm-iop32x         ia64-up           mips-sb1250-swarm    s390-defconfig
arm-iop33x         ia64-zx1          mips-sead            s390-up
arm-ixp2000        m68k              mips-tb0219          sparc
arm-ixp23xx        m68k-amiga        mips-tb0226          sparc-allnoconfig
arm-ixp4xx         m68k-apollo       mips-tb0287          sparc-defconfig
arm-jornada720     m68k-atari        mips-workpad         sparc-up
arm-kafa           m68k-bvme6000     mips-wrppmc          sparc64
arm-kb9202         m68k-hp300        mips-yosemite        sparc64-allnoconfig
arm-ks8695         m68k-mac          parisc               sparc64-defconfig
arm-lart           m68k-mvme147      parisc-allnoconfig   sparc64-up
arm-lpd270         m68k-mvme16x      parisc-defconfig     um-x86_64
arm-lpd7a400       m68k-q40          parisc-up            x86_64
arm-lpd7a404       m68k-sun3         powerpc              x86_64-allnoconfig
arm-lubbock        m68k-sun3x        powerpc-cell         x86_64-defconfig
arm-lusl7200       mips              powerpc-celleb       x86_64-up
arm-mainstone      mips-atlas        powerpc-chrp32

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/smp.c                    |    1 
 arch/arm/kernel/setup.c                    |    1 
 arch/arm/kernel/smp.c                      |    1 
 arch/frv/kernel/sys_frv.c                  |    1 
 arch/i386/kernel/microcode.c               |    1 
 arch/i386/kernel/sys_i386.c                |    1 
 arch/i386/kernel/sysenter.c                |    1 
 arch/ia64/kernel/init_task.c               |    1 
 arch/m68k/kernel/process.c                 |    1 
 arch/m68k/kernel/sys_m68k.c                |    1 
 arch/mips/kernel/smp.c                     |    1 
 arch/mips/kernel/syscall.c                 |    1 
 arch/parisc/hpux/fs.c                      |    1 
 arch/parisc/kernel/init_task.c             |    1 
 arch/parisc/kernel/process.c               |    1 
 arch/parisc/kernel/smp.c                   |    1 
 arch/powerpc/kernel/syscalls.c             |    1 
 arch/powerpc/lib/rheap.c                   |    1 
 arch/powerpc/oprofile/cell/spu_task_sync.c |    1 
 arch/s390/kernel/init_task.c               |    1 
 arch/s390/kernel/process.c                 |    1 
 arch/s390/kernel/smp.c                     |    1 
 arch/s390/kernel/sys_s390.c                |    1 
 arch/sparc/kernel/init_task.c              |    1 
 arch/sparc64/kernel/init_task.c            |    1 
 arch/sparc64/kernel/process.c              |    1 
 arch/um/drivers/mmapper_kern.c             |    1 
 arch/um/kernel/exec.c                      |    1 
 arch/um/kernel/init_task.c                 |    1 
 arch/um/kernel/syscall.c                   |    1 
 arch/x86_64/ia32/ptrace32.c                |    1 
 arch/x86_64/kernel/process.c               |    1 
 arch/x86_64/kernel/sys_x86_64.c            |    1 
 arch/x86_64/vdso/vma.c                     |    1 
 drivers/char/agp/compat_ioctl.c            |    1 
 drivers/char/agp/frontend.c                |    1 
 drivers/char/mmtimer.c                     |    1 
 drivers/char/mspec.c                       |    1 
 drivers/infiniband/hw/ipath/ipath_diag.c   |    1 
 fs/dcookies.c                              |    1 
 include/linux/hugetlb.h                    |    2 +
 include/linux/mm.h                         |   36 ++---------------------------
 mm/mmap.c                                  |   34 +++++++++++++++++++++++++++
 mm/oom_kill.c                              |    1 
 mm/vmstat.c                                |    1 
 45 files changed, 81 insertions(+), 33 deletions(-)

--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -23,6 +23,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/fs.h>
 
 #include <asm/cpu.h>
 #include <asm/elf.h>
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -17,6 +17,7 @@
 #include <linux/profile.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/seq_file.h>
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/i386/kernel/microcode.c
+++ b/arch/i386/kernel/microcode.c
@@ -82,6 +82,7 @@
 #include <linux/miscdevice.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/cpu.h>
 #include <linux/firmware.h>
--- a/arch/i386/kernel/sys_i386.c
+++ b/arch/i386/kernel/sys_i386.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/elf.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/module.h>
 
 #include <asm/cpufeature.h>
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -8,6 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/stddef.h>
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
+#include <linux/err.h>
 
 #include <asm/atomic.h>
 #include <asm/cpu.h>
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/mman.h>
 #include <linux/ptrace.h>
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/file.h>
 #include <linux/slab.h>
--- a/arch/parisc/kernel/init_task.c
+++ b/arch/parisc/kernel/init_task.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -38,6 +38,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/personality.h>
 #include <linux/ptrace.h>
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -28,6 +28,7 @@
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/powerpc/lib/rheap.c
+++ b/arch/powerpc/lib/rheap.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 
 #include <asm/rheap.h>
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ b/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -21,6 +21,7 @@
 #include <linux/dcookies.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/numa.h>
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/sparc/kernel/init_task.c
+++ b/arch/sparc/kernel/init_task.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
--- a/arch/sparc64/kernel/init_task.c
+++ b/arch/sparc64/kernel/init_task.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
 #include <linux/ptrace.h>
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -12,6 +12,7 @@
 #include <linux/init.h> 
 #include <linux/module.h>
 #include <linux/mm.h> 
+#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <asm/uaccess.h>
 #include "mem_user.h"
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -6,6 +6,7 @@
 #include "linux/slab.h"
 #include "linux/smp_lock.h"
 #include "linux/ptrace.h"
+#include "linux/fs.h"
 #include "asm/ptrace.h"
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -4,6 +4,7 @@
  */
 
 #include "linux/mm.h"
+#include "linux/fs.h"
 #include "linux/module.h"
 #include "linux/sched.h"
 #include "linux/init_task.h"
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -7,6 +7,7 @@
 #include "linux/file.h"
 #include "linux/smp_lock.h"
 #include "linux/mm.h"
+#include "linux/fs.h"
 #include "linux/utsname.h"
 #include "linux/msg.h"
 #include "linux/shm.h"
--- a/arch/x86_64/ia32/ptrace32.c
+++ b/arch/x86_64/ia32/ptrace32.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/ptrace.h>
 #include <asm/ptrace.h>
 #include <asm/compat.h>
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/elfcore.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
--- a/arch/x86_64/kernel/sys_x86_64.c
+++ b/arch/x86_64/kernel/sys_x86_64.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
--- a/arch/x86_64/vdso/vma.c
+++ b/arch/x86_64/vdso/vma.c
@@ -4,6 +4,7 @@
  * Subject to the GPL, v.2
  */
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/random.h>
--- a/drivers/char/agp/compat_ioctl.c
+++ b/drivers/char/agp/compat_ioctl.c
@@ -28,6 +28,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/fs.h>
 #include <linux/agpgart.h>
 #include <asm/uaccess.h>
 #include "agp.h"
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -37,6 +37,7 @@
 #include <linux/agpgart.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/mmtimer.h>
 #include <linux/miscdevice.h>
 #include <linux/posix-timers.h>
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -38,6 +38,7 @@
 #include <linux/miscdevice.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 #include <linux/slab.h>
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -44,6 +44,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 
 #include "ipath_kernel.h"
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -20,6 +20,7 @@
 #include <linux/capability.h>
 #include <linux/dcache.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/dcookies.h>
 #include <linux/mutex.h>
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_HUGETLB_H
 #define _LINUX_HUGETLB_H
 
+#include <linux/fs.h>
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -10,7 +10,6 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
-#include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/debug_locks.h>
 #include <linux/backing-dev.h>
@@ -18,7 +17,9 @@
 
 struct mempolicy;
 struct anon_vma;
+struct file_ra_state;
 struct user_struct;
+struct writeback_control;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -861,38 +862,7 @@ struct shrinker {
 extern void register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
 
-/*
- * Some shared mappigns will want the pages marked read-only
- * to track write events. If so, we'll downgrade vm_page_prot
- * to the private version (using protection_map[] without the
- * VM_SHARED bit).
- */
-static inline int vma_wants_writenotify(struct vm_area_struct *vma)
-{
-	unsigned int vm_flags = vma->vm_flags;
-
-	/* If it was private or non-writable, the write bit is already clear */
-	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
-		return 0;
-
-	/* The backer wishes to know when pages are first written to? */
-	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
-		return 1;
-
-	/* The open routine did something to the protections already? */
-	if (pgprot_val(vma->vm_page_prot) !=
-	    pgprot_val(protection_map[vm_flags &
-		    (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]))
-		return 0;
-
-	/* Specialty mapping? */
-	if (vm_flags & (VM_PFNMAP|VM_INSERTPAGE))
-		return 0;
-
-	/* Can the mapping track the dirty pages? */
-	return vma->vm_file && vma->vm_file->f_mapping &&
-		mapping_cap_account_dirty(vma->vm_file->f_mapping);
-}
+int vma_wants_writenotify(struct vm_area_struct *vma);
 
 extern pte_t *FASTCALL(get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl));
 
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1029,6 +1029,40 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
+/*
+ * Some shared mappigns will want the pages marked read-only
+ * to track write events. If so, we'll downgrade vm_page_prot
+ * to the private version (using protection_map[] without the
+ * VM_SHARED bit).
+ */
+int vma_wants_writenotify(struct vm_area_struct *vma)
+{
+	unsigned int vm_flags = vma->vm_flags;
+
+	/* If it was private or non-writable, the write bit is already clear */
+	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
+		return 0;
+
+	/* The backer wishes to know when pages are first written to? */
+	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
+		return 1;
+
+	/* The open routine did something to the protections already? */
+	if (pgprot_val(vma->vm_page_prot) !=
+	    pgprot_val(protection_map[vm_flags &
+		    (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]))
+		return 0;
+
+	/* Specialty mapping? */
+	if (vm_flags & (VM_PFNMAP|VM_INSERTPAGE))
+		return 0;
+
+	/* Can the mapping track the dirty pages? */
+	return vma->vm_file && vma->vm_file->f_mapping &&
+		mapping_cap_account_dirty(vma->vm_file->f_mapping);
+}
+
+
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
 			  unsigned int vm_flags, unsigned long pgoff,
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -17,6 +17,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
 #include <linux/timex.h>
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>


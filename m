Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYK3Xth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYK3Xth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 18:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYK3Xt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 18:49:29 -0500
Received: from ozlabs.org ([203.10.76.45]:57319 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYK3Xt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 18:49:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18739.9807.62269.140353@cargo.ozlabs.ibm.com>
Date: Mon, 1 Dec 2008 10:48:31 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a set of fixes for various powerpc regressions, build failures
and serious bugs that have accumulated since my last pull request,
plus some defconfig updates.

This includes commits pulled from the submaintainers for embedded
powerpc platforms.  In one case there was a fix that I thought was
marginal (making a printk print correct numbers rather than garbage)
but I let it through since it is in platform-specific code and
therefore can't hurt other platforms.  If you disagree, let me know
and I'll redo the branch.

Thanks,
Paul.

 arch/powerpc/boot/dts/mpc832x_rdb.dts          |    4 
 arch/powerpc/boot/dts/mpc8572ds.dts            |    2 
 arch/powerpc/configs/40x/virtex_defconfig      | 1176 ++++++++++++++++++++++++
 arch/powerpc/configs/44x/virtex5_defconfig     |  234 +++--
 arch/powerpc/configs/52xx/cm5200_defconfig     |  169 +++
 arch/powerpc/configs/52xx/lite5200b_defconfig  |  206 +++-
 arch/powerpc/configs/52xx/motionpro_defconfig  |  168 +++
 arch/powerpc/configs/52xx/pcm030_defconfig     |  182 +++-
 arch/powerpc/configs/52xx/tqm5200_defconfig    |  180 +++-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig |    2 
 arch/powerpc/configs/mpc5200_defconfig         |  573 +++++++++---
 arch/powerpc/configs/ppc40x_defconfig          |   92 ++
 arch/powerpc/configs/ppc44x_defconfig          |   92 ++
 arch/powerpc/kernel/cpu_setup_44x.S            |    7 
 arch/powerpc/kernel/entry_64.S                 |    8 
 arch/powerpc/kernel/prom_parse.c               |    7 
 arch/powerpc/mm/40x_mmu.c                      |   16 
 arch/powerpc/mm/numa.c                         |  122 ++
 arch/powerpc/platforms/cell/axon_msi.c         |   36 +
 arch/powerpc/platforms/cell/smp.c              |    9 
 arch/powerpc/platforms/cell/spufs/file.c       |    3 
 arch/powerpc/sysdev/bestcomm/Kconfig           |    9 
 arch/powerpc/sysdev/mpic.c                     |    9 
 arch/powerpc/sysdev/xilinx_intc.c              |    4 
 drivers/block/xsysace.c                        |   23 
 drivers/char/xilinx_hwicap/xilinx_hwicap.c     |    9 
 drivers/net/Kconfig                            |    3 
 drivers/serial/uartlite.c                      |    4 
 drivers/video/xilinxfb.c                       |    5 
 sound/soc/fsl/Kconfig                          |    3 
 30 files changed, 2776 insertions(+), 581 deletions(-)
 create mode 100644 arch/powerpc/configs/40x/virtex_defconfig

Adhemerval Zanella (1):
      powerpc: Fix IRQ assignment for some PCIe devices

Arnd Bergmann (3):
      powerpc/cell/axon-msi: Retry on missing interrupt
      powerpc/mpic: Don't reset affinity for secondary MPIC on boot
      powerpc/cell: Fix GDB watchpoints, again

Benjamin Herrenschmidt (1):
      powerpc/44x: Fix 460EX/460GT machine check handling

Dave Hansen (1):
      powerpc: Fix boot freeze on machine with empty memory node

Grant Erickson (1):
      powerpc/40x: Limit allocable DRAM during early mapping

Grant Likely (4):
      powerpc/mpc5200: fix bestcomm Kconfig dependencies
      powerpc/virtex: fix various format/casting printk mismatches
      powerpc/52xx: update defconfigs
      powerpc/virtex: Update defconfigs

Jeremy Kerr (1):
      powerpc/spufs: Fix spinning in spufs_ps_fault on signal

Martyn Welch (1):
      powerpc: Use generic PHY driver for Marvell 88E1111 PHY on GE Fanuc SBC610

Michael Barkowski (1):
      powerpc/mpc832x_rdb: fix swapped ethernet ids

Paul Mackerras (1):
      powerpc: Fix system calls on Cell entered with XER.SO=1

Trent Piepho (1):
      powerpc/85xx: L2 cache size wrong in 8572DS dts

Yuri Tikhonov (1):
      xsysace: Fix driver to use resource_size_t instead of unsigned long


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbYJaK7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbYJaK7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJaK7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:59:03 -0400
Received: from ozlabs.org ([203.10.76.45]:53127 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYJaK7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:59:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18698.58333.886594.707909@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 21:54:21 +1100
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

to get a collection of fixes for various regressions, compile failures
and oops-causing bugs on powerpc, plus some defconfig updates (which
form the bulk of the lines changed).

The 3 commits from Milton Miller partially revert some changes we did
since 2.6.27 to the way the kernel is invoked and the way it invokes a
kexec/kdump kernel, and subsequently decided was a bad idea.  I put
them in so that we didn't end up having one kernel release with odd
interface conventions.

I'm sending this pull request rather than Ben because Ben's wife just
had a baby and Ben is otherwise occupied. :)

Thanks,
Paul.

 arch/powerpc/boot/dts/mpc8313erdb.dts            |   39 -------
 arch/powerpc/boot/libfdt/fdt_ro.c                |    9 +-
 arch/powerpc/boot/main.c                         |    2 
 arch/powerpc/configs/40x/acadia_defconfig        |   59 +++++++---
 arch/powerpc/configs/40x/ep405_defconfig         |   83 ++++++++++-----
 arch/powerpc/configs/40x/hcu4_defconfig          |  125 ++++++++++++++++------
 arch/powerpc/configs/40x/kilauea_defconfig       |   69 ++++++++----
 arch/powerpc/configs/40x/makalu_defconfig        |   69 ++++++++----
 arch/powerpc/configs/40x/walnut_defconfig        |   77 ++++++++++----
 arch/powerpc/configs/44x/arches_defconfig        |   51 ++++++---
 arch/powerpc/configs/44x/bamboo_defconfig        |   77 ++++++++++----
 arch/powerpc/configs/44x/canyonlands_defconfig   |   61 +++++++----
 arch/powerpc/configs/44x/ebony_defconfig         |   77 ++++++++++----
 arch/powerpc/configs/44x/katmai_defconfig        |   77 ++++++++++----
 arch/powerpc/configs/44x/rainier_defconfig       |   73 +++++++++----
 arch/powerpc/configs/44x/sam440ep_defconfig      |  110 ++++++++++++++-----
 arch/powerpc/configs/44x/sequoia_defconfig       |   78 ++++++++++----
 arch/powerpc/configs/44x/taishan_defconfig       |   77 ++++++++++----
 arch/powerpc/configs/44x/warp_defconfig          |   82 ++++++++++----
 arch/powerpc/configs/linkstation_defconfig       |   11 +-
 arch/powerpc/configs/ppc40x_defconfig            |  106 +++++++++++++++----
 arch/powerpc/configs/ppc44x_defconfig            |  125 +++++++++++++++++-----
 arch/powerpc/include/asm/iommu.h                 |   15 +--
 arch/powerpc/include/asm/kdump.h                 |    8 -
 arch/powerpc/include/asm/mpic.h                  |    2 
 arch/powerpc/include/asm/pci.h                   |    2 
 arch/powerpc/kernel/dma-iommu.c                  |   34 +++---
 arch/powerpc/kernel/head_64.S                    |   30 +++--
 arch/powerpc/kernel/ibmebus.c                    |   27 ++---
 arch/powerpc/kernel/iommu.c                      |   25 ++--
 arch/powerpc/kernel/machine_kexec_64.c           |    9 --
 arch/powerpc/kernel/misc_64.S                    |    9 +-
 arch/powerpc/kernel/of_device.c                  |    1 
 arch/powerpc/kernel/pci-common.c                 |  110 ++++++++++---------
 arch/powerpc/kernel/pci_64.c                     |    2 
 arch/powerpc/kernel/setup_64.c                   |    6 +
 arch/powerpc/kernel/signal_32.c                  |   36 +++---
 arch/powerpc/kernel/signal_64.c                  |   33 +++---
 arch/powerpc/kernel/vio.c                        |   25 ++--
 arch/powerpc/kernel/vmlinux.lds.S                |    2 
 arch/powerpc/oprofile/op_model_cell.c            |   13 ++
 arch/powerpc/platforms/40x/Kconfig               |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    3 -
 arch/powerpc/platforms/86xx/pic.c                |    3 -
 arch/powerpc/platforms/cell/iommu.c              |   37 +++----
 arch/powerpc/platforms/cell/ras.c                |    6 +
 arch/powerpc/platforms/embedded6xx/linkstation.c |   14 ++
 arch/powerpc/platforms/iseries/iommu.c           |    7 +
 arch/powerpc/platforms/ps3/system-bus.c          |   36 +++---
 arch/powerpc/platforms/pseries/iommu.c           |    4 -
 arch/powerpc/platforms/pseries/pci_dlpar.c       |    2 
 arch/powerpc/sysdev/mpic.c                       |   59 ++++++++++
 arch/powerpc/xmon/xmon.c                         |    2 
 drivers/of/device.c                              |   11 ++
 54 files changed, 1392 insertions(+), 720 deletions(-)

Benjamin Herrenschmidt (1):
      powerpc/pci: Fix unmapping of IO space on 64-bit

Carl Love (1):
      powerpc/cell/OProfile: Fix on-stack array size in activate spu profiling function

David Gibson (1):
      powerpc: Fix bug in kernel copy of libfdt's fdt_subnode_offset_namelen()

Guennadi Liakhovetski (1):
      powerpc: fix i2c on PPC linkstation / kurobox machines

Jeremy Kerr (1):
      OF-device: Don't overwrite numa_node in device registration

Jon Smirl (1):
      powerpc: Fix format string warning in arch/powerpc/boot/main.c

Josh Boyer (3):
      powerpc/40x: Don't enable HCU4 board by default
      powerpc/40x: Update 40x defconfigs
      powerpc/44x: Update 44x defconfigs

Kumar Gala (1):
      powerpc/mpic: Fix regression caused by change of default IRQ affinity

Mark Nelson (1):
      powerpc: Update remaining dma_mapping_ops to use map/unmap_page

Michael Neuling (2):
      powerpc: Fix compiler warning for the relocatable kernel
      powerpc: Fix swapcontext system for VSX + old ucontext size

Mike Dyer (1):
      powerpc: Remove duplicate DMA entry from mpc8313erdb device tree

Milton Miller (3):
      powerpc: Kexec exit should not use magic numbers
      powerpc: Use is_kdump_kernel()
      powerpc/ppc64/kdump: Better flag for running relocatable

Nathan Fontenot (1):
      powerpc/pci: Properly allocate bus resources for hotplug PHBs

Paul Mackerras (2):
      powerpc: Work around ld bug in older binutils
      powerpc: Fix compile errors with CONFIG_BUG=n

Rogério Brito (2):
      powerpc: compile kernel for linkstations optimized for size
      powerpc: enable heap randomization for linkstations


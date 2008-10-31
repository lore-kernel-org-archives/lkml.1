Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbYJaLq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbYJaLq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYJaLqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:46:51 -0400
Received: from ozlabs.org ([203.10.76.45]:42476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYJaLqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:46:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18698.61456.146033.158975@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 22:46:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <18698.58333.886594.707909@cargo.ozlabs.ibm.com>
References: <18698.58333.886594.707909@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Since I sent the pull request, I have added one more commit to my
merge branch, which reverts the commit that Mel Gorman identified as
causing NVRAM corruption (plus another commit that depended on it).

So when you do this:

> Please pull from the 'merge' branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

you'll see this commit in addition:

Paul Mackerras (1):
      Revert "powerpc: Sync RPA note in zImage with kernel's RPA note"

I have included the overall diffstat below.

Thanks,
Paul.

 arch/powerpc/boot/addnote.c                      |  175 ++++++----------------
 arch/powerpc/boot/dts/mpc8313erdb.dts            |   39 -----
 arch/powerpc/boot/libfdt/fdt_ro.c                |    9 +
 arch/powerpc/boot/main.c                         |    2 
 arch/powerpc/boot/wrapper                        |    9 -
 arch/powerpc/configs/40x/acadia_defconfig        |   59 +++++--
 arch/powerpc/configs/40x/ep405_defconfig         |   83 +++++++---
 arch/powerpc/configs/40x/hcu4_defconfig          |  125 +++++++++++-----
 arch/powerpc/configs/40x/kilauea_defconfig       |   69 ++++++---
 arch/powerpc/configs/40x/makalu_defconfig        |   69 ++++++---
 arch/powerpc/configs/40x/walnut_defconfig        |   77 +++++++---
 arch/powerpc/configs/44x/arches_defconfig        |   51 ++++--
 arch/powerpc/configs/44x/bamboo_defconfig        |   77 +++++++---
 arch/powerpc/configs/44x/canyonlands_defconfig   |   61 +++++---
 arch/powerpc/configs/44x/ebony_defconfig         |   77 +++++++---
 arch/powerpc/configs/44x/katmai_defconfig        |   77 +++++++---
 arch/powerpc/configs/44x/rainier_defconfig       |   73 ++++++---
 arch/powerpc/configs/44x/sam440ep_defconfig      |  110 ++++++++++----
 arch/powerpc/configs/44x/sequoia_defconfig       |   78 +++++++---
 arch/powerpc/configs/44x/taishan_defconfig       |   77 +++++++---
 arch/powerpc/configs/44x/warp_defconfig          |   82 +++++++---
 arch/powerpc/configs/linkstation_defconfig       |   11 +
 arch/powerpc/configs/ppc40x_defconfig            |  106 +++++++++++--
 arch/powerpc/configs/ppc44x_defconfig            |  125 ++++++++++++----
 arch/powerpc/include/asm/iommu.h                 |   15 +-
 arch/powerpc/include/asm/kdump.h                 |    8 -
 arch/powerpc/include/asm/mpic.h                  |    2 
 arch/powerpc/include/asm/pci.h                   |    2 
 arch/powerpc/kernel/dma-iommu.c                  |   34 ++--
 arch/powerpc/kernel/head_64.S                    |   30 ++--
 arch/powerpc/kernel/ibmebus.c                    |   27 ++-
 arch/powerpc/kernel/iommu.c                      |   25 ++-
 arch/powerpc/kernel/machine_kexec_64.c           |    9 -
 arch/powerpc/kernel/misc_64.S                    |    9 -
 arch/powerpc/kernel/of_device.c                  |    1 
 arch/powerpc/kernel/pci-common.c                 |  110 +++++++-------
 arch/powerpc/kernel/pci_64.c                     |    2 
 arch/powerpc/kernel/prom_init.c                  |   10 +
 arch/powerpc/kernel/setup_64.c                   |    6 -
 arch/powerpc/kernel/signal_32.c                  |   36 ++---
 arch/powerpc/kernel/signal_64.c                  |   33 ++--
 arch/powerpc/kernel/vio.c                        |   25 ++-
 arch/powerpc/kernel/vmlinux.lds.S                |    5 -
 arch/powerpc/oprofile/op_model_cell.c            |   13 +-
 arch/powerpc/platforms/40x/Kconfig               |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    3 
 arch/powerpc/platforms/86xx/pic.c                |    3 
 arch/powerpc/platforms/cell/iommu.c              |   37 ++---
 arch/powerpc/platforms/cell/ras.c                |    6 -
 arch/powerpc/platforms/embedded6xx/linkstation.c |   14 ++
 arch/powerpc/platforms/iseries/iommu.c           |    7 +
 arch/powerpc/platforms/ps3/system-bus.c          |   36 ++---
 arch/powerpc/platforms/pseries/iommu.c           |    4 -
 arch/powerpc/platforms/pseries/pci_dlpar.c       |    2 
 arch/powerpc/sysdev/mpic.c                       |   59 +++++++
 arch/powerpc/xmon/xmon.c                         |    2 
 drivers/of/device.c                              |   11 +
 57 files changed, 1444 insertions(+), 865 deletions(-)

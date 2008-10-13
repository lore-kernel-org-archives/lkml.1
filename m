Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYJMQuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYJMQuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYJMQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:50:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbYJMQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:50:07 -0400
Subject: [GIT *] Misc fixes (statfs, a.out, DMI)
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Oct 2008 16:50:05 +0000
Message-Id: <1223916605.6770.646.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from
	git://git.infradead.org/users/dwmw2/random-2.6.git

This has miscellaneous fixes which don't really live anywhere else, and
which have all been posted to linux-kernel and/or linux-arch for review:

  - Fixing the automatic MODULE_ALIAS stuff for DMI so that people don't
    keep doing it manually and screwing it up.

  - Tidying up statfs.h for 64-bit compatibility, to remove a lot of
    duplication.

  - The non-bugfix parts of the a.out tidyup which we did before 2.6.26,
    but forgot to merge when the window for 2.6.27 opened.

  - Minor fix to EFS to avoid setting a bogus f_fsid in statfs()

  - Use PCI ident #defines for various Marvell CAFÉ drivers, and drop
    the support for the broken "everything has same PCI ident" case, 
    which was only ever true on the early FPGA prototypes.

This is the shortlog:

Adrian Bunk (1):
      Remove asm/a.out.h files for all architectures without a.out support.

David Woodhouse (17):
      EFS: Don't set f_fsid in statfs().
      Use PCI_DEVICE_ID_88ALP01 for CAFÉ chip, rather than PCI_DEVICE_ID_CAFE.
      [MTD] [NAND] Define and use PCI_DEVICE_ID_MARVELL_88ALP01_NAND for CAFÉ
      Define and use PCI_DEVICE_ID_MARVELL_88ALP01_CCIC for CAFÉ camera driver
      Make <asm-generic/statfs.h> suitable for 64-bit platforms.
      ARM: Use <asm-generic/statfs.h>
      IA64: Use <asm-generic/statfs.h>
      x86_64: Use <asm-generic/statfs.h>
      PARISC: Use <asm-generic/statfs.h>
      PowerPC: Use <asm-generic/statfs.h>
      SPARC: Use <asm-generic/statfs.h>
      S390: Update comments about why we don't use <asm-generic/statfs.h>
      Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
      Introduce HAVE_AOUT symbol to remove hard-coded arch list for BINFMT_AOUT
      Automatic MODULE_ALIAS() for DMI match tables.
      Fix autoloading of MacBook Pro backlight driver.
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6

 arch/alpha/Kconfig                      |    4 +-
 arch/alpha/include/asm/statfs.h         |    4 ++
 arch/arm/Kconfig                        |    4 +-
 arch/arm/include/asm/statfs.h           |   34 +---------------
 arch/avr32/include/asm/a.out.h          |   20 ---------
 arch/blackfin/include/asm/a.out.h       |   19 ---------
 arch/cris/arch-v10/boot/tools/build.c   |    1 -
 arch/h8300/Kconfig                      |    3 -
 arch/h8300/include/asm/a.out.h          |   20 ---------
 arch/h8300/kernel/process.c             |    1 -
 arch/ia64/include/asm/a.out.h           |   32 ---------------
 arch/ia64/include/asm/statfs.h          |   52 ++----------------------
 arch/ia64/mm/init.c                     |    1 -
 arch/m32r/Kconfig                       |    3 -
 arch/m68k/Kconfig                       |    4 +-
 arch/m68knommu/Kconfig                  |    3 -
 arch/m68knommu/include/asm/a.out.h      |    1 -
 arch/m68knommu/kernel/process.c         |    1 -
 arch/m68knommu/kernel/traps.c           |    1 -
 arch/mips/include/asm/a.out.h           |   35 ----------------
 arch/mips/kernel/process.c              |    1 -
 arch/mips/kernel/syscall.c              |    1 -
 arch/mn10300/Kconfig                    |    3 -
 arch/parisc/Kconfig                     |    3 -
 arch/powerpc/include/asm/a.out.h        |   20 ---------
 arch/powerpc/include/asm/statfs.h       |   54 -------------------------
 arch/powerpc/kernel/softemu8xx.c        |    1 -
 arch/powerpc/kernel/traps.c             |    1 -
 arch/powerpc/platforms/chrp/setup.c     |    1 -
 arch/powerpc/platforms/maple/setup.c    |    1 -
 arch/powerpc/platforms/powermac/setup.c |    1 -
 arch/powerpc/platforms/pseries/setup.c  |    1 -
 arch/s390/include/asm/statfs.h          |   11 ++---
 arch/sparc/include/asm/Kbuild           |    2 -
 arch/sparc/include/asm/statfs.h         |    8 +--
 arch/sparc/include/asm/statfs_32.h      |    6 ---
 arch/sparc/include/asm/statfs_64.h      |   54 -------------------------
 arch/um/Kconfig.i386                    |    8 +--
 arch/um/Kconfig.x86_64                  |    3 -
 arch/x86/Kconfig                        |    6 +--
 drivers/media/video/cafe_ccic.c         |   13 +-----
 drivers/mmc/host/sdhci-pci.c            |    2 +-
 drivers/mtd/nand/cafe_nand.c            |    6 ++-
 drivers/video/backlight/mbp_nvidia_bl.c |    4 +-
 fs/Kconfig.binfmt                       |    6 ++-
 fs/efs/super.c                          |    2 -
 include/asm-cris/a.out.h                |   26 ------------
 include/asm-generic/statfs.h            |   65 +++++++++++++++++++++++--------
 include/asm-m32r/a.out.h                |   20 ---------
 include/asm-parisc/a.out.h              |   20 ---------
 include/asm-parisc/statfs.h             |   55 +-------------------------
 include/asm-x86/statfs.h                |   61 ++--------------------------
 include/asm-xtensa/a.out.h              |   29 --------------
 include/linux/dmi.h                     |   41 +------------------
 include/linux/mod_devicetable.h         |   47 ++++++++++++++++++++++
 include/linux/pci_ids.h                 |    4 +-
 scripts/mod/file2alias.c                |   57 +++++++++++++++++++++++++++
 57 files changed, 204 insertions(+), 683 deletions(-)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


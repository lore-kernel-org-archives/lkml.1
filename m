Return-Path: <linux-kernel-owner+w=401wt.eu-S965931AbXIKDCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931AbXIKDCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 23:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXIKDCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 23:02:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965562AbXIKDCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 23:02:16 -0400
Date: Mon, 10 Sep 2007 20:02:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc6
Message-ID: <alpine.LFD.0.999.0709101954450.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So last week was a bust, with a lot of core people away for the kernel 
summit, and with -rc5 having two rather nasty (and silly) one-liner 
problems that bit a number of people - a missing NULL pointer check in 
TCP, and a missing list terminator in ata_piix.

So the fixes for those things were both pretty trivial, and they've been 
in the -git trees for the last few days, but I just pushed out an -rc6 
that also merges up some other updates that did come in during the week. 

Most of the diff is just some m32r reorg, but see the appended shortlog 
and diffstat for details.

		Linus
---
Alan Cox (1):
      [MIPS] tty: add the new ioctls and definitions.

Andi Kleen (1):
      x86_64: Remove CLFLUSH in text_poke()

Christian Ehrhardt (1):
      [x86 setup] Work around bug in Xen HVM

Christoph Hellwig (4):
      [XFS] Fix sparse NULL vs 0 warnings
      [XFS] Fix sparse warning in kmem_shake_allow
      [XFS] fix ASSERT and ASSERT_ALWAYS
      [XFS] fix sparse shadowed variable warnings

Chuck Lever (4):
      NFS: mount option parser chokes on proto=
      NFS: Return a real error code from mount(2)
      NFS: Off-by-one length error in string handling
      NFS: change NFS mount error return when hostname/pathname too long

Daniel Walker (1):
      i386: fix a hang on stuck nmi watchdog

David Brownell (2):
      i2c-gpio: Fix adapter number
      i2c-algo-bit: Read block data bugfix

David Chinner (1):
      [XFS] Set filestreams object timeout to something sane.

David Howells (1):
      [MTD] Initialise s_flags in get_sb_mtd_aux()

David S. Miller (1):
      [TCP]: 'dst' can be NULL in tcp_rto_min()

Eric Sandeen (1):
      [XFS] fix nasty quota hashtable allocation bug

Geert Uytterhoeven (1):
      [POWERPC] cell/PS3: Ignore storage devices that are still being probed

Herbert Xu (2):
      [CRYPTO] blkcipher: Fix handling of kmalloc page straddling
      [CRYPTO] blkcipher: Fix inverted test in blkcipher_get_spot

Hirokazu Takata (12):
      m32r: Move defconfig files to arch/m32r/configs/
      m32r: Update defconfig files for 2.6.23-rc1
      m32r: Add defconfig file for the usrv platform.
      m32r: Rearrange platform-dependent codes
      m32r: Move dot.gdbinit files
      m32r: Define symbols to unify platform-dependent ICU checks
      m32r: Simplify ei_handler code
      m32r: Exit ei_handler directly for no IRQ case or IPI operations
      m32r: Cosmetic updates of arch/m32r/kernel/entry.S
      m32r: Separate syscall table from entry.S
      m32r: build fix of entry.S
      m32r: Rename STI/CLI macros

Ingo Molnar (4):
      sched: fix niced_granularity() shift
      sched: debug: fix cfs_rq->wait_runtime accounting
      sched: debug: fix sum_exec_runtime clearing
      sched: fix xtensa build warning

Jason Lunz (1):
      [JFFS2] fix write deadlock regression

Jean Delvare (2):
      hwmon: End of I/O region off-by-one
      i2c-pxa: Fix adapter number

Jeff Dike (1):
      UML: Fix ELF_CORE_COPY_REGS build botch

Jeff Garzik (1):
      [libata] ata_piix: properly terminate DMI system list

Jeff Norden (1):
      pata_it821x: fix lost interrupt with atapi devices

Jeremy Kerr (1):
      [POWERPC] cell/PS3: Always set master run control bit in mfc_sr1_set

Jesper Juhl (1):
      [IA64] Remove unnecessary cast of allocation return value in sn_hwperf_enum_objects()

Joachim Fenkes (1):
      [POWERPC] ibmebus: Prevent bus_id collisions

John Keller (1):
      [IA64] SN: Add support for CPU disable

Joseph Chan (1):
      [libata, IDE] add new VIA bridge to VIA PATA drivers

Kenji Kaneshige (2):
      [IA64] Fix unexpected interrupt vector handling
      [IA64] Clear pending interrupts at CPU boot up time

Kyungmin Park (1):
      [MIPS] i8259: Add disable method.

Laurent Riffard (1):
      Fix broken pata_via cable detection

Linus Torvalds (1):
      Linux 2.6.23-rc6

Masato Noguchi (1):
      [POWERPC] cell/PS3: Fix a bug that causes the PS3 to hang on the SPU Class 0 interrupt.

Maxime Bizon (1):
      [MIPS] R10000: Fix wrong test in dma-default.c

Neil Brown (2):
      knfsd: Fixed problem with NFS exporting directories which are mounted on.
      knfsd: Validate filehandle type in fsid_source

Ondrej Zary (1):
      Fix sata_via write errors on PATA drive connected to VT6421

Peter Chubb (2):
      [IA64] Enable early console for Ski simulator
      [IA64] Cleanup HPSIM code (was: Re: Enable early console for Ski simulator)

Peter Zijlstra (3):
      sched: simplify __check_preempt_curr_fair()
      sched: improve prev_sum_exec_runtime setting
      sched: fix ideal_runtime calculations for reniced tasks

Prarit Bhargava (1):
      [IA64] Stop bogus NMI & softlockup warnings in ia64 show_mem

Ralf Baechle (5):
      [MIPS] BCM1480: Fix computation of interrupt mask address register.
      [MIPS] PCI: Set need_domain_info if controller domain index is non-zero.
      [MIPS] Kconfig: whitespace cleanup.
      [MIPS] Sibyte: Remove broken dependency on EXPERIMENTAL from SIBYTE_SB1xxx_SOC.
      [MIPS] Provide empty irq_enable_hazard definition for legacy and R1 cores.

Roland McGrath (1):
      Fix spurious syscall tracing after PTRACE_DETACH + PTRACE_ATTACH

Roman Zippel (1):
      kconfig: oldconfig shall not set symbols if it does not need to

Stefan Richter (1):
      firewire: fw-ohci: ignore failure of pci_set_power_state (fix suspend regression)

Stephane Eranian (1):
      i386: Fix perfctr watchdog on core duo

Suresh Siddha (1):
      sched: fix MC/HT scheduler optimization, without breaking the FUZZ logic.

Tejun Heo (1):
      libata clear horkage on ata_dev_init()

Thiemo Seufer (1):
      [MIPS] TLB: Fix instruction bitmasks

Trond Myklebust (4):
      NFS: Fix use of cancel_delayed_work_sync in nfs_release_automount_timer
      NFSv4: Fix a typo in _nfs4_do_open_reclaim
      NFSv4: Ensure that we pass the correct dentry to nfs4_intent_set_file
      NFS: Fix a write request leak in nfs_invalidate_page()

Yoichi Yuasa (1):
      [MIPS] Ocelot: remove remaining bits

---
 Makefile                                           |    2 +-
 arch/i386/boot/pm.c                                |    6 +-
 arch/i386/kernel/alternative.c                     |    6 +-
 arch/i386/kernel/cpu/perfctr-watchdog.c            |   28 +-
 arch/i386/kernel/nmi.c                             |    2 +-
 arch/i386/kernel/ptrace.c                          |    1 -
 arch/ia64/hp/sim/hpsim_console.c                   |   16 +-
 arch/ia64/hp/sim/hpsim_setup.c                     |    9 +-
 arch/ia64/hp/sim/simeth.c                          |   12 +-
 arch/ia64/hp/sim/simscsi.c                         |    3 +-
 arch/ia64/kernel/irq_ia64.c                        |   28 +-
 arch/ia64/kernel/ptrace.c                          |    1 -
 arch/ia64/kernel/setup.c                           |   13 +-
 arch/ia64/kernel/smpboot.c                         |    6 +
 arch/ia64/mm/contig.c                              |    3 +
 arch/ia64/mm/discontig.c                           |    3 +
 arch/ia64/sn/kernel/huberror.c                     |   14 +-
 arch/ia64/sn/kernel/irq.c                          |   15 +
 arch/ia64/sn/kernel/sn2/sn2_smp.c                  |   26 +
 arch/ia64/sn/kernel/sn2/sn_hwperf.c                |    3 +-
 arch/ia64/sn/pci/pcibr/pcibr_provider.c            |    1 +
 arch/ia64/sn/pci/tioca_provider.c                  |    2 +
 arch/ia64/sn/pci/tioce_provider.c                  |    1 +
 arch/m32r/Kconfig                                  |   20 +
 arch/m32r/Makefile                                 |    3 +-
 .../m32104ut_defconfig}                            |  363 ++++--------
 .../m32700ut.smp_defconfig}                        |  349 ++++--------
 .../m32700ut.up_defconfig}                         |  349 ++++--------
 .../mappi.nommu_defconfig}                         |  294 +++-------
 .../defconfig.smp => configs/mappi.smp_defconfig}  |  311 +++-------
 .../defconfig.up => configs/mappi.up_defconfig}    |  311 +++-------
 .../mappi2.opsp_defconfig}                         |  333 ++++--------
 .../mappi2.vdec2_defconfig}                        |  333 ++++--------
 .../defconfig.smp => configs/mappi3.smp_defconfig} |  310 +++-------
 .../defconfig.nommu => configs/oaks32r_defconfig}  |  290 +++-------
 .../defconfig.opsput => configs/opsput_defconfig}  |  321 ++++-------
 .../defconfig.smp => configs/usrv_defconfig}       |  608 ++++++++------------
 arch/m32r/defconfig                                |  349 ++++--------
 arch/m32r/kernel/Makefile                          |    8 -
 arch/m32r/kernel/entry.S                           |  569 ++----------------
 arch/m32r/kernel/syscall_table.S                   |  286 +++++++++
 arch/m32r/platforms/Makefile                       |    9 +
 arch/m32r/platforms/m32104ut/Makefile              |    1 +
 .../io_m32104ut.c => platforms/m32104ut/io.c}      |    2 +-
 .../m32104ut/setup.c}                              |    2 +-
 arch/m32r/platforms/m32700ut/Makefile              |    1 +
 .../m32700ut/dot.gdbinit_200MHz_16MB               |    0 
 .../m32700ut/dot.gdbinit_300MHz_32MB               |    0 
 .../m32700ut/dot.gdbinit_400MHz_32MB               |    0 
 .../io_m32700ut.c => platforms/m32700ut/io.c}      |    2 +-
 .../m32700ut/setup.c}                              |    2 +-
 arch/m32r/platforms/mappi/Makefile                 |    1 +
 arch/m32r/{ => platforms}/mappi/dot.gdbinit        |    0 
 arch/m32r/{ => platforms}/mappi/dot.gdbinit.nommu  |    0 
 arch/m32r/{ => platforms}/mappi/dot.gdbinit.smp    |    0 
 .../{kernel/io_mappi.c => platforms/mappi/io.c}    |    2 +-
 .../setup_mappi.c => platforms/mappi/setup.c}      |    2 +-
 arch/m32r/platforms/mappi2/Makefile                |    1 +
 arch/m32r/{ => platforms}/mappi2/dot.gdbinit.vdec2 |    0 
 .../{kernel/io_mappi2.c => platforms/mappi2/io.c}  |    2 +-
 .../setup_mappi2.c => platforms/mappi2/setup.c}    |    2 +-
 arch/m32r/platforms/mappi3/Makefile                |    1 +
 arch/m32r/{ => platforms}/mappi3/dot.gdbinit       |    0 
 .../{kernel/io_mappi3.c => platforms/mappi3/io.c}  |    2 +-
 .../setup_mappi3.c => platforms/mappi3/setup.c}    |    2 +-
 arch/m32r/platforms/oaks32r/Makefile               |    1 +
 .../m32r/{ => platforms}/oaks32r/dot.gdbinit.nommu |    0 
 .../io_oaks32r.c => platforms/oaks32r/io.c}        |    2 +-
 .../setup_oaks32r.c => platforms/oaks32r/setup.c}  |    2 +-
 arch/m32r/platforms/opsput/Makefile                |    1 +
 arch/m32r/{ => platforms}/opsput/dot.gdbinit       |    0 
 .../{kernel/io_opsput.c => platforms/opsput/io.c}  |    2 +-
 .../setup_opsput.c => platforms/opsput/setup.c}    |    2 +-
 arch/m32r/platforms/usrv/Makefile                  |    1 +
 .../m32r/{kernel/io_usrv.c => platforms/usrv/io.c} |    4 +-
 .../setup_usrv.c => platforms/usrv/setup.c}        |    5 +-
 arch/m68k/kernel/ptrace.c                          |    1 -
 arch/mips/Kconfig                                  |   22 +-
 arch/mips/kernel/i8259.c                           |    1 +
 arch/mips/mm/dma-default.c                         |    2 +-
 arch/mips/mm/tlbex.c                               |    4 +-
 arch/mips/pci/pci.c                                |    1 +
 arch/mips/sibyte/Kconfig                           |    1 -
 arch/mips/sibyte/bcm1480/irq.c                     |    8 +-
 arch/powerpc/kernel/ibmebus.c                      |   30 +-
 arch/powerpc/platforms/cell/spu_base.c             |   24 +-
 arch/powerpc/platforms/ps3/platform.h              |    1 +
 arch/powerpc/platforms/ps3/repository.c            |   29 +
 arch/powerpc/platforms/ps3/spu.c                   |    2 +
 crypto/blkcipher.c                                 |   11 +-
 drivers/ata/ata_piix.c                             |    5 +-
 drivers/ata/libata-core.c                          |    1 +
 drivers/ata/pata_it821x.c                          |    4 +
 drivers/ata/pata_via.c                             |   14 +-
 drivers/ata/sata_via.c                             |    2 +-
 drivers/firewire/fw-ohci.c                         |    6 +-
 drivers/hwmon/lm78.c                               |    2 +-
 drivers/hwmon/w83781d.c                            |    2 +-
 drivers/i2c/algos/i2c-algo-bit.c                   |   52 +-
 drivers/i2c/busses/i2c-gpio.c                      |    2 +-
 drivers/i2c/busses/i2c-pxa.c                       |    2 +-
 drivers/ide/pci/via82cxxx.c                        |    1 +
 drivers/mtd/mtdsuper.c                             |    2 +
 fs/jffs2/fs.c                                      |    2 +-
 fs/nfs/file.c                                      |    2 +-
 fs/nfs/namespace.c                                 |    2 +-
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/super.c                                     |   20 +-
 fs/nfs/write.c                                     |   44 ++
 fs/nfsd/nfsfh.c                                    |   20 +-
 fs/nfsd/vfs.c                                      |    3 +-
 fs/xfs/linux-2.6/kmem.h                            |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c                        |    8 +-
 fs/xfs/linux-2.6/xfs_globals.c                     |    2 +-
 fs/xfs/quota/xfs_qm.c                              |    3 +-
 fs/xfs/support/debug.h                             |   10 +-
 fs/xfs/xfs_da_btree.c                              |    1 -
 fs/xfs/xfs_log.c                                   |   12 +-
 fs/xfs/xfs_log_recover.c                           |   12 +-
 include/asm-ia64/hpsim.h                           |   16 +
 include/asm-ia64/sn/arch.h                         |    1 +
 include/asm-ia64/sn/intr.h                         |    1 +
 include/asm-ia64/sn/sn_feature_sets.h              |    1 +
 include/asm-m32r/assembler.h                       |   16 +-
 include/asm-m32r/m32r.h                            |   20 +
 include/asm-mips/hazards.h                         |    1 +
 include/asm-mips/ioctls.h                          |    4 +
 include/asm-mips/mach-ocelot/mach-gt64120.h        |   30 -
 include/asm-mips/termbits.h                        |    7 +-
 include/asm-mips/termios.h                         |    6 +-
 include/asm-powerpc/spu.h                          |    2 +-
 include/asm-um/elf-x86_64.h                        |   42 +-
 include/linux/nfs_fs.h                             |    1 +
 include/linux/pci_ids.h                            |    1 +
 kernel/ptrace.c                                    |    1 +
 kernel/sched.c                                     |   15 +-
 kernel/sched_debug.c                               |    1 +
 kernel/sched_fair.c                                |   59 +-
 net/ipv4/tcp_input.c                               |    2 +-
 scripts/kconfig/conf.c                             |   21 +-
 140 files changed, 2412 insertions(+), 3877 deletions(-)
 rename arch/m32r/{m32104ut/defconfig.m32104ut => configs/m32104ut_defconfig} (87%)
 rename arch/m32r/{m32700ut/defconfig.m32700ut.smp => configs/m32700ut.smp_defconfig} (85%)
 rename arch/m32r/{m32700ut/defconfig.m32700ut.up => configs/m32700ut.up_defconfig} (85%)
 rename arch/m32r/{mappi/defconfig.nommu => configs/mappi.nommu_defconfig} (86%)
 rename arch/m32r/{mappi/defconfig.smp => configs/mappi.smp_defconfig} (87%)
 rename arch/m32r/{mappi/defconfig.up => configs/mappi.up_defconfig} (87%)
 rename arch/m32r/{mappi2/defconfig.opsp => configs/mappi2.opsp_defconfig} (86%)
 rename arch/m32r/{mappi2/defconfig.vdec2 => configs/mappi2.vdec2_defconfig} (86%)
 copy arch/m32r/{mappi3/defconfig.smp => configs/mappi3.smp_defconfig} (87%)
 rename arch/m32r/{oaks32r/defconfig.nommu => configs/oaks32r_defconfig} (85%)
 rename arch/m32r/{opsput/defconfig.opsput => configs/opsput_defconfig} (85%)
 rename arch/m32r/{mappi3/defconfig.smp => configs/usrv_defconfig} (62%)
 create mode 100644 arch/m32r/kernel/syscall_table.S
 create mode 100644 arch/m32r/platforms/Makefile
 create mode 100644 arch/m32r/platforms/m32104ut/Makefile
 rename arch/m32r/{kernel/io_m32104ut.c => platforms/m32104ut/io.c} (99%)
 rename arch/m32r/{kernel/setup_m32104ut.c => platforms/m32104ut/setup.c} (98%)
 create mode 100644 arch/m32r/platforms/m32700ut/Makefile
 rename arch/m32r/{ => platforms}/m32700ut/dot.gdbinit_200MHz_16MB (100%)
 rename arch/m32r/{ => platforms}/m32700ut/dot.gdbinit_300MHz_32MB (100%)
 rename arch/m32r/{ => platforms}/m32700ut/dot.gdbinit_400MHz_32MB (100%)
 rename arch/m32r/{kernel/io_m32700ut.c => platforms/m32700ut/io.c} (99%)
 rename arch/m32r/{kernel/setup_m32700ut.c => platforms/m32700ut/setup.c} (99%)
 create mode 100644 arch/m32r/platforms/mappi/Makefile
 rename arch/m32r/{ => platforms}/mappi/dot.gdbinit (100%)
 rename arch/m32r/{ => platforms}/mappi/dot.gdbinit.nommu (100%)
 rename arch/m32r/{ => platforms}/mappi/dot.gdbinit.smp (100%)
 rename arch/m32r/{kernel/io_mappi.c => platforms/mappi/io.c} (99%)
 rename arch/m32r/{kernel/setup_mappi.c => platforms/mappi/setup.c} (99%)
 create mode 100644 arch/m32r/platforms/mappi2/Makefile
 rename arch/m32r/{ => platforms}/mappi2/dot.gdbinit.vdec2 (100%)
 rename arch/m32r/{kernel/io_mappi2.c => platforms/mappi2/io.c} (99%)
 rename arch/m32r/{kernel/setup_mappi2.c => platforms/mappi2/setup.c} (99%)
 create mode 100644 arch/m32r/platforms/mappi3/Makefile
 rename arch/m32r/{ => platforms}/mappi3/dot.gdbinit (100%)
 rename arch/m32r/{kernel/io_mappi3.c => platforms/mappi3/io.c} (99%)
 rename arch/m32r/{kernel/setup_mappi3.c => platforms/mappi3/setup.c} (99%)
 create mode 100644 arch/m32r/platforms/oaks32r/Makefile
 rename arch/m32r/{ => platforms}/oaks32r/dot.gdbinit.nommu (100%)
 rename arch/m32r/{kernel/io_oaks32r.c => platforms/oaks32r/io.c} (99%)
 rename arch/m32r/{kernel/setup_oaks32r.c => platforms/oaks32r/setup.c} (98%)
 create mode 100644 arch/m32r/platforms/opsput/Makefile
 rename arch/m32r/{ => platforms}/opsput/dot.gdbinit (100%)
 rename arch/m32r/{kernel/io_opsput.c => platforms/opsput/io.c} (99%)
 rename arch/m32r/{kernel/setup_opsput.c => platforms/opsput/setup.c} (99%)
 create mode 100644 arch/m32r/platforms/usrv/Makefile
 rename arch/m32r/{kernel/io_usrv.c => platforms/usrv/io.c} (98%)
 rename arch/m32r/{kernel/setup_usrv.c => platforms/usrv/setup.c} (98%)
 create mode 100644 include/asm-ia64/hpsim.h
 delete mode 100644 include/asm-mips/mach-ocelot/mach-gt64120.h

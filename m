Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXGTUbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXGTUbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbXGTUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:31:11 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48139 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686AbXGTUbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:31:08 -0400
From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuehrung: Herbert Kircher, Sitz der Gesellschaft: Boeblingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Please pull for-2.6.23 branch of cell-2.6.git
Date: Fri, 20 Jul 2007 21:55:43 +0200
User-Agent: KMail/1.9.6
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: paulus@samba.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, Philippe Elie <phil.el@wanadoo.fr>,
       Jeremy Kerr <jk@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202155.45002.arnd.bergmann@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

	master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git for-2.6.23

This is a number of changes that fell through the cracks because
it wasn't clear how we were going to merge it in the absence of paulus.
Mostly bug fixes, except a few features that should we should have
submitted all along:

* oprofile on Cell SPU
* SPU affinity
* Kdump saves SPU state
* drivers for I/O buffer memory and MSI on the Axon south bridge

	Arnd <><

shortlog

    [CELL] spufs: rework list management and associated locking
    [CELL] oprofile: add support to OProfile for profiling CELL BE SPUs
    [CELL] oprofile: enable SPU switch notification to detect currently active SPU tasks
    [CELL] spu_base: locking cleanup
    [CELL] cell: indexing of SPUs based on firmware vicinity properties
    [CELL] spufs: integration of SPE affinity with the scheduller
    [CELL] cell: add placement computation for scheduling of affinity contexts
    [CELL] spufs: extension of spu_create to support affinity definition
    [CELL] cell: add hardcoded spu vicinity information for QS20
    [CELL] cell: add vicinity information on spus
    [CELL] cell: add per BE structure with info about its SPUs
    [CELL] spufs: use find_first_bit() instead of sched_find_first_bit()
    [CELL] spufs: remove unused file argument from spufs_run_spu()
    [CELL] spufs: change decrementer restore timing
    [CELL] spufs: dont halt decrementer at restore step 47
    [CELL] spufs: limit saving MFC_CNTL bits
    [CELL] spufs: fix read and write for decr_status file
    [CELL] spufs: fix decr_status meanings
    [CELL] spufs: remove needless context save/restore code
    [CELL] spufs: fix array size of channel index
    [CELL] spufs: make sure context are scheduled again after spu_acquire_saved
    [CELL] spufs: add spu stats in sysfs and ctx stat file in spufs
    [CELL] spufs: Remove spurious WARN_ON for spu_deactivate for NOSCHED contexts
    [CELL] spufs: Make signal-notification files readonly for NOSCHED contexts
    [CELL] spufs: Avoid unexpectedly restaring MFC during context save
    [CELL] spufs: remove section mismatch warning
    [CELL] add support for MSI on Axon-based Cell systems
    [CELL] saving spus information for kexec crash
    [CELL] driver for DDR2 memory on AXON
    [CELL] allow linux to map Cell regs on legacy SLOF tree.
    [CELL] fix cbe_thermal for legacy SLOF tree.
    [CELL] fix cbe_cpufreq for legacy SLOF tree.
    [CELL] cbe_cpufreq: reorganize code
    [CELL] cbe_cpufreq: fix minor issues
    [CELL] cbe_cpufreq: fix initialization
    [CELL] cbe_cpufreq: fix latency measurement
    [CELL] pmi: remove support for mutiple devices.

diffstat

 arch/powerpc/configs/cell_defconfig                          |    3
 arch/powerpc/kernel/crash.c                                  |   67 +
 arch/powerpc/kernel/time.c                                   |    1
 arch/powerpc/oprofile/Kconfig                                |    7
 arch/powerpc/oprofile/Makefile                               |    4
 arch/powerpc/oprofile/cell/pr_util.h                         |   97 +
 arch/powerpc/oprofile/cell/spu_profiler.c                    |  221 ++++
 arch/powerpc/oprofile/cell/spu_task_sync.c                   |  484 ++++++++
 arch/powerpc/oprofile/cell/vma_map.c                         |  287 +++++
 arch/powerpc/oprofile/common.c                               |   51
 arch/powerpc/oprofile/op_model_7450.c                        |   14
 arch/powerpc/oprofile/op_model_cell.c                        |  607 +++++++++--
 arch/powerpc/oprofile/op_model_fsl_booke.c                   |   11
 arch/powerpc/oprofile/op_model_pa6t.c                        |   12
 arch/powerpc/oprofile/op_model_power4.c                      |   11
 arch/powerpc/oprofile/op_model_rs64.c                        |   10
 arch/powerpc/platforms/Kconfig                               |   10
 arch/powerpc/platforms/cell/Kconfig                          |   10
 arch/powerpc/platforms/cell/Makefile                         |    6
 arch/powerpc/platforms/cell/axon_msi.c                       |  445 ++++++++
 arch/powerpc/platforms/cell/cbe_cpufreq.c                    |  217 ---
 arch/powerpc/platforms/cell/cbe_cpufreq.h                    |   24
 arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c          |  115 ++
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c                |  148 ++
 arch/powerpc/platforms/cell/cbe_regs.c                       |    7
 arch/powerpc/platforms/cell/cbe_thermal.c                    |   25
 arch/powerpc/platforms/cell/spu_base.c                       |  295 +++--
 arch/powerpc/platforms/cell/spu_syscalls.c                   |   17
 arch/powerpc/platforms/cell/spufs/context.c                  |   42
 arch/powerpc/platforms/cell/spufs/coredump.c                 |    2
 arch/powerpc/platforms/cell/spufs/fault.c                    |    8
 arch/powerpc/platforms/cell/spufs/file.c                     |  104 +
 arch/powerpc/platforms/cell/spufs/gang.c                     |    6
 arch/powerpc/platforms/cell/spufs/inode.c                    |  132 ++
 arch/powerpc/platforms/cell/spufs/run.c                      |   36
 arch/powerpc/platforms/cell/spufs/sched.c                    |  377 ++++--
 arch/powerpc/platforms/cell/spufs/spu_restore.c              |    6
 arch/powerpc/platforms/cell/spufs/spu_restore_dump.h_shipped |  480 ++++----
 arch/powerpc/platforms/cell/spufs/spufs.h                    |   99 +
 arch/powerpc/platforms/cell/spufs/switch.c                   |   72 -
 arch/powerpc/platforms/cell/spufs/syscalls.c                 |   34
 arch/powerpc/sysdev/Makefile                                 |    1
 arch/powerpc/sysdev/axonram.c                                |  381 ++++++
 arch/powerpc/sysdev/pmi.c                                    |   51
 drivers/oprofile/buffer_sync.c                               |    3
 drivers/oprofile/event_buffer.h                              |   20
 drivers/oprofile/oprof.c                                     |   28
 include/asm-powerpc/oprofile_impl.h                          |   10
 include/asm-powerpc/pmi.h                                    |    8
 include/asm-powerpc/spu.h                                    |   62 -
 include/asm-powerpc/spu_csa.h                                |    8
 include/linux/dcookies.h                                     |    1
 include/linux/elf-em.h                                       |    3
 include/linux/oprofile.h                                     |   35
 include/linux/syscalls.h                                     |    2

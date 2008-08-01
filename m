Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYHAFUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYHAFUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYHAFUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:20:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34790 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYHAFUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:20:44 -0400
Date: Fri, 1 Aug 2008 15:20:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org
Subject: [PATCH v2] powerpc: move include files to arch/powerpc/include/asm
Message-Id: <20080801152030.ff10b6b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from include/asm-powerpc.  This is the result of a

mkdir arch/powerpc/include/asm
git mv include/asm-powerpc/* arch/powerpc/include/asm

Followed by a few documentation/comment fixups and a couple of places
where <asm-powepc/...> was being used explicitly.  Of the latter only
one was outside the arch code and it is a driver only built for powerpc.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

v2 don't change other arch files - the fixups are only in comments anyway.

This patch can be applied with "git am" - the full patch is way to bug
for our mailing lists.

This has been built for all the powerpc defconfigs including
all{no,mod,yes}config.  There was only one failure, but that is
expected anyway (I had to apply patches for the iommu and hfcmulti
breakages).

 Documentation/powerpc/booting-without-of.txt       |    4 ++--
 Documentation/powerpc/eeh-pci-error-recovery.txt   |    2 +-
 arch/powerpc/boot/io.h                             |    2 +-
 .../powerpc/include/asm}/8253pit.h                 |    0 
 .../powerpc/include/asm}/8xx_immap.h               |    0 
 .../powerpc/include/asm}/Kbuild                    |    0 
 .../powerpc/include/asm}/a.out.h                   |    0 
 .../powerpc/include/asm}/abs_addr.h                |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/agp.h |    0 
 .../powerpc/include/asm}/asm-compat.h              |    0 
 .../powerpc/include/asm}/atomic.h                  |    0 
 .../powerpc/include/asm}/auxvec.h                  |    0 
 .../powerpc/include/asm}/backlight.h               |    0 
 .../powerpc/include/asm}/bitops.h                  |    0 
 .../powerpc/include/asm}/bootx.h                   |    0 
 .../powerpc/include/asm}/btext.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/bug.h |    0 
 .../powerpc/include/asm}/bugs.h                    |    0 
 .../powerpc/include/asm}/byteorder.h               |    0 
 .../powerpc/include/asm}/cache.h                   |    0 
 .../powerpc/include/asm}/cacheflush.h              |    0 
 .../powerpc/include/asm}/cell-pmu.h                |    0 
 .../powerpc/include/asm}/cell-regs.h               |    0 
 .../powerpc/include/asm}/checksum.h                |    0 
 .../powerpc/include/asm}/clk_interface.h           |    0 
 .../powerpc/include/asm}/code-patching.h           |    0 
 .../powerpc/include/asm}/compat.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/cpm.h |    0 
 .../powerpc/include/asm}/cpm1.h                    |    0 
 .../powerpc/include/asm}/cpm2.h                    |    0 
 .../powerpc/include/asm}/cputable.h                |    0 
 .../powerpc/include/asm}/cputhreads.h              |    0 
 .../powerpc/include/asm}/cputime.h                 |    0 
 .../powerpc/include/asm}/current.h                 |    0 
 .../powerpc/include/asm}/dbdma.h                   |    0 
 .../powerpc/include/asm}/dcr-generic.h             |    0 
 .../powerpc/include/asm}/dcr-mmio.h                |    0 
 .../powerpc/include/asm}/dcr-native.h              |    0 
 .../powerpc/include/asm}/dcr-regs.h                |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/dcr.h |    0 
 .../powerpc/include/asm}/delay.h                   |    0 
 .../powerpc/include/asm}/device.h                  |    0 
 .../powerpc/include/asm}/div64.h                   |    0 
 .../powerpc/include/asm}/dma-mapping.h             |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/dma.h |    0 
 .../powerpc/include/asm}/edac.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/eeh.h |    0 
 .../powerpc/include/asm}/eeh_event.h               |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/elf.h |    0 
 .../powerpc/include/asm}/emergency-restart.h       |    0 
 .../powerpc/include/asm}/errno.h                   |    0 
 .../powerpc/include/asm}/exception.h               |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/fb.h  |    0 
 .../powerpc/include/asm}/fcntl.h                   |    0 
 .../powerpc/include/asm}/feature-fixups.h          |    0 
 .../powerpc/include/asm}/firmware.h                |    0 
 .../powerpc/include/asm}/fixmap.h                  |    0 
 .../powerpc/include/asm}/floppy.h                  |    0 
 .../powerpc/include/asm}/fs_pd.h                   |    0 
 .../powerpc/include/asm}/fsl_gtm.h                 |    0 
 .../powerpc/include/asm}/fsl_lbc.h                 |    0 
 .../powerpc/include/asm}/ftrace.h                  |    0 
 .../powerpc/include/asm}/futex.h                   |    0 
 .../powerpc/include/asm}/gpio.h                    |    0 
 .../powerpc/include/asm}/grackle.h                 |    0 
 .../powerpc/include/asm}/hardirq.h                 |    0 
 .../powerpc/include/asm}/heathrow.h                |    0 
 .../powerpc/include/asm}/highmem.h                 |    0 
 .../powerpc/include/asm}/hugetlb.h                 |    0 
 .../powerpc/include/asm}/hvcall.h                  |    0 
 .../powerpc/include/asm}/hvconsole.h               |    0 
 .../powerpc/include/asm}/hvcserver.h               |    0 
 .../powerpc/include/asm}/hw_irq.h                  |    0 
 .../powerpc/include/asm}/hydra.h                   |    0 
 .../powerpc/include/asm}/i8259.h                   |    0 
 .../powerpc/include/asm}/ibmebus.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ide.h |    0 
 .../powerpc/include/asm}/immap_86xx.h              |    0 
 .../powerpc/include/asm}/immap_cpm2.h              |    0 
 .../powerpc/include/asm}/immap_qe.h                |    2 --
 .../powerpc/include/asm}/io-defs.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/io.h  |    0 
 .../powerpc/include/asm}/ioctl.h                   |    0 
 .../powerpc/include/asm}/ioctls.h                  |    0 
 .../powerpc/include/asm}/iommu.h                   |    0 
 .../powerpc/include/asm}/ipcbuf.h                  |    0 
 .../powerpc/include/asm}/ipic.h                    |    2 --
 .../asm-powerpc => arch/powerpc/include/asm}/irq.h |    0 
 .../powerpc/include/asm}/irq_regs.h                |    0 
 .../powerpc/include/asm}/irqflags.h                |    4 +---
 .../powerpc/include/asm}/iseries/alpaca.h          |    0 
 .../powerpc/include/asm}/iseries/hv_call.h         |    0 
 .../powerpc/include/asm}/iseries/hv_call_event.h   |    0 
 .../powerpc/include/asm}/iseries/hv_call_sc.h      |    0 
 .../powerpc/include/asm}/iseries/hv_call_xm.h      |    0 
 .../powerpc/include/asm}/iseries/hv_lp_config.h    |    0 
 .../powerpc/include/asm}/iseries/hv_lp_event.h     |    0 
 .../powerpc/include/asm}/iseries/hv_types.h        |    0 
 .../powerpc/include/asm}/iseries/iommu.h           |    0 
 .../powerpc/include/asm}/iseries/it_lp_queue.h     |    0 
 .../powerpc/include/asm}/iseries/lpar_map.h        |    0 
 .../powerpc/include/asm}/iseries/mf.h              |    0 
 .../powerpc/include/asm}/iseries/vio.h             |    0 
 .../powerpc/include/asm}/kdebug.h                  |    0 
 .../powerpc/include/asm}/kdump.h                   |    0 
 .../powerpc/include/asm}/kexec.h                   |    0 
 .../powerpc/include/asm}/keylargo.h                |    0 
 .../powerpc/include/asm}/kgdb.h                    |    2 --
 .../powerpc/include/asm}/kmap_types.h              |    0 
 .../powerpc/include/asm}/kprobes.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/kvm.h |    0 
 .../powerpc/include/asm}/kvm_asm.h                 |    0 
 .../powerpc/include/asm}/kvm_host.h                |    0 
 .../powerpc/include/asm}/kvm_para.h                |    0 
 .../powerpc/include/asm}/kvm_ppc.h                 |    0 
 .../powerpc/include/asm}/libata-portmap.h          |    0 
 .../powerpc/include/asm}/linkage.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/lmb.h |    0 
 .../powerpc/include/asm}/local.h                   |    0 
 .../powerpc/include/asm}/lppaca.h                  |    0 
 .../powerpc/include/asm}/lv1call.h                 |    0 
 .../powerpc/include/asm}/machdep.h                 |    0 
 .../powerpc/include/asm}/macio.h                   |    0 
 .../powerpc/include/asm}/mc146818rtc.h             |    0 
 .../powerpc/include/asm}/mediabay.h                |    0 
 .../powerpc/include/asm}/mman.h                    |    0 
 .../powerpc/include/asm}/mmu-40x.h                 |    0 
 .../powerpc/include/asm}/mmu-44x.h                 |    0 
 .../powerpc/include/asm}/mmu-8xx.h                 |    0 
 .../powerpc/include/asm}/mmu-fsl-booke.h           |    0 
 .../powerpc/include/asm}/mmu-hash32.h              |    0 
 .../powerpc/include/asm}/mmu-hash64.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/mmu.h |    0 
 .../powerpc/include/asm}/mmu_context.h             |    0 
 .../powerpc/include/asm}/mmzone.h                  |    0 
 .../powerpc/include/asm}/module.h                  |    0 
 .../powerpc/include/asm}/mpc512x.h                 |    0 
 .../powerpc/include/asm}/mpc52xx.h                 |    0 
 .../powerpc/include/asm}/mpc52xx_psc.h             |    0 
 .../powerpc/include/asm}/mpc6xx.h                  |    0 
 .../powerpc/include/asm}/mpc8260.h                 |    0 
 .../powerpc/include/asm}/mpc86xx.h                 |    0 
 .../powerpc/include/asm}/mpc8xx.h                  |    0 
 .../powerpc/include/asm}/mpic.h                    |    0 
 .../powerpc/include/asm}/msgbuf.h                  |    0 
 .../powerpc/include/asm}/mutex.h                   |    0 
 .../powerpc/include/asm}/nvram.h                   |    0 
 .../powerpc/include/asm}/of_device.h               |    0 
 .../powerpc/include/asm}/of_platform.h             |    0 
 .../powerpc/include/asm}/ohare.h                   |    0 
 .../powerpc/include/asm}/oprofile_impl.h           |    0 
 .../powerpc/include/asm}/pSeries_reconfig.h        |    0 
 .../powerpc/include/asm}/paca.h                    |    2 --
 .../powerpc/include/asm}/page.h                    |    0 
 .../powerpc/include/asm}/page_32.h                 |    0 
 .../powerpc/include/asm}/page_64.h                 |    0 
 .../powerpc/include/asm}/param.h                   |    0 
 .../powerpc/include/asm}/parport.h                 |    0 
 .../powerpc/include/asm}/pasemi_dma.h              |    0 
 .../powerpc/include/asm}/pci-bridge.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pci.h |    0 
 .../powerpc/include/asm}/percpu.h                  |    0 
 .../powerpc/include/asm}/pgalloc-32.h              |    0 
 .../powerpc/include/asm}/pgalloc-64.h              |    0 
 .../powerpc/include/asm}/pgalloc.h                 |    0 
 .../powerpc/include/asm}/pgtable-4k.h              |    0 
 .../powerpc/include/asm}/pgtable-64k.h             |    0 
 .../powerpc/include/asm}/pgtable-ppc32.h           |    0 
 .../powerpc/include/asm}/pgtable-ppc64.h           |    2 +-
 .../powerpc/include/asm}/pgtable.h                 |    0 
 .../powerpc/include/asm}/phyp_dump.h               |    0 
 .../powerpc/include/asm}/pmac_feature.h            |    0 
 .../powerpc/include/asm}/pmac_low_i2c.h            |    0 
 .../powerpc/include/asm}/pmac_pfunc.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pmc.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pmi.h |    0 
 .../powerpc/include/asm}/poll.h                    |    0 
 .../powerpc/include/asm}/posix_types.h             |    0 
 .../powerpc/include/asm}/ppc-pci.h                 |    0 
 .../powerpc/include/asm}/ppc4xx.h                  |    0 
 .../powerpc/include/asm}/ppc_asm.h                 |    0 
 .../powerpc/include/asm}/processor.h               |    0 
 .../powerpc/include/asm}/prom.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ps3.h |    0 
 .../powerpc/include/asm}/ps3av.h                   |    0 
 .../powerpc/include/asm}/ps3fb.h                   |    0 
 .../powerpc/include/asm}/ps3stor.h                 |    0 
 .../powerpc/include/asm}/ptrace.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/qe.h  |    0 
 .../powerpc/include/asm}/qe_ic.h                   |    2 --
 .../asm-powerpc => arch/powerpc/include/asm}/reg.h |    0 
 .../powerpc/include/asm}/reg_8xx.h                 |    0 
 .../powerpc/include/asm}/reg_booke.h               |    0 
 .../powerpc/include/asm}/reg_fsl_emb.h             |    0 
 .../powerpc/include/asm}/resource.h                |    0 
 .../powerpc/include/asm}/rheap.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/rio.h |    0 
 .../powerpc/include/asm}/rtas.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/rtc.h |    0 
 .../powerpc/include/asm}/rwsem.h                   |    4 ++--
 .../powerpc/include/asm}/scatterlist.h             |    0 
 .../powerpc/include/asm}/seccomp.h                 |    0 
 .../powerpc/include/asm}/sections.h                |    0 
 .../powerpc/include/asm}/sembuf.h                  |    0 
 .../powerpc/include/asm}/serial.h                  |    0 
 .../powerpc/include/asm}/setjmp.h                  |    0 
 .../powerpc/include/asm}/setup.h                   |    0 
 .../powerpc/include/asm}/shmbuf.h                  |    0 
 .../powerpc/include/asm}/shmparam.h                |    0 
 .../powerpc/include/asm}/sigcontext.h              |    0 
 .../powerpc/include/asm}/siginfo.h                 |    0 
 .../powerpc/include/asm}/signal.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/smp.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/smu.h |    0 
 .../powerpc/include/asm}/socket.h                  |    0 
 .../powerpc/include/asm}/sockios.h                 |    0 
 .../powerpc/include/asm}/sparsemem.h               |    0 
 .../powerpc/include/asm}/spinlock.h                |    0 
 .../powerpc/include/asm}/spinlock_types.h          |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/spu.h |    0 
 .../powerpc/include/asm}/spu_csa.h                 |    0 
 .../powerpc/include/asm}/spu_info.h                |    0 
 .../powerpc/include/asm}/spu_priv1.h               |    0 
 .../powerpc/include/asm}/sstep.h                   |    0 
 .../powerpc/include/asm}/stat.h                    |    0 
 .../powerpc/include/asm}/statfs.h                  |    0 
 .../powerpc/include/asm}/string.h                  |    0 
 .../powerpc/include/asm}/suspend.h                 |    0 
 .../powerpc/include/asm}/synch.h                   |    0 
 .../powerpc/include/asm}/syscall.h                 |    0 
 .../powerpc/include/asm}/syscalls.h                |    0 
 .../powerpc/include/asm}/systbl.h                  |    0 
 .../powerpc/include/asm}/system.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/tce.h |    0 
 .../powerpc/include/asm}/termbits.h                |    0 
 .../powerpc/include/asm}/termios.h                 |    0 
 .../powerpc/include/asm}/thread_info.h             |    0 
 .../powerpc/include/asm}/time.h                    |    0 
 .../powerpc/include/asm}/timex.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/tlb.h |    0 
 .../powerpc/include/asm}/tlbflush.h                |    0 
 .../powerpc/include/asm}/topology.h                |    0 
 .../powerpc/include/asm}/tsi108.h                  |    0 
 .../powerpc/include/asm}/tsi108_irq.h              |    0 
 .../powerpc/include/asm}/tsi108_pci.h              |    0 
 .../powerpc/include/asm}/types.h                   |    0 
 .../powerpc/include/asm}/uaccess.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ucc.h |    0 
 .../powerpc/include/asm}/ucc_fast.h                |    2 --
 .../powerpc/include/asm}/ucc_slow.h                |    0 
 .../powerpc/include/asm}/ucontext.h                |    0 
 .../powerpc/include/asm}/udbg.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/uic.h |    2 --
 .../powerpc/include/asm}/unaligned.h               |    0 
 .../powerpc/include/asm}/uninorth.h                |    0 
 .../powerpc/include/asm}/unistd.h                  |    0 
 .../powerpc/include/asm}/user.h                    |    0 
 .../powerpc/include/asm}/vdso.h                    |    0 
 .../powerpc/include/asm}/vdso_datapage.h           |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/vga.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/vio.h |    0 
 .../powerpc/include/asm}/xilinx_intc.h             |    0 
 .../powerpc/include/asm}/xmon.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/xor.h |    0 
 arch/powerpc/mm/tlb_64.c                           |    2 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    2 +-
 drivers/char/hvc_console.h                         |    2 +-
 drivers/char/hvcs.c                                |    2 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    2 +-
 269 files changed, 13 insertions(+), 29 deletions(-)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/8253pit.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/8xx_immap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/Kbuild (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/a.out.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/abs_addr.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/agp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/asm-compat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/atomic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/auxvec.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/backlight.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bitops.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bootx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/btext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bug.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bugs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/byteorder.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cache.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cacheflush.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cell-pmu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cell-regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/checksum.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/clk_interface.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/code-patching.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/compat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm1.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm2.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputable.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputhreads.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputime.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/current.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dbdma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-generic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-mmio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-native.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/delay.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/device.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/div64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dma-mapping.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/edac.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/eeh.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/eeh_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/elf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/emergency-restart.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/errno.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/exception.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fcntl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/feature-fixups.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/firmware.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fixmap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/floppy.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fs_pd.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fsl_gtm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fsl_lbc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ftrace.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/futex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/gpio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/grackle.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hardirq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/heathrow.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/highmem.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hugetlb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvcall.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvconsole.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvcserver.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hw_irq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hydra.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/i8259.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ibmebus.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ide.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_86xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_cpm2.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_qe.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/io-defs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/io.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ioctl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ioctls.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iommu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ipcbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ipic.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/irq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/irq_regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/irqflags.h (93%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/alpaca.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_sc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_xm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_lp_config.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_lp_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/iommu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/it_lp_queue.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/lpar_map.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/mf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/vio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kdebug.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kdump.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kexec.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/keylargo.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kgdb.h (98%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kmap_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kprobes.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_asm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_host.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_para.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_ppc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/libata-portmap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/linkage.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lmb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/local.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lppaca.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lv1call.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/machdep.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/macio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mediabay.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mman.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-40x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-44x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-fsl-booke.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-hash32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-hash64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu_context.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmzone.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/module.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc512x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc52xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc52xx_psc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc6xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc8260.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc86xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/msgbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mutex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/nvram.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/of_device.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/of_platform.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ohare.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/oprofile_impl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pSeries_reconfig.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/paca.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page_32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page_64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/param.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/parport.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pasemi_dma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pci-bridge.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/percpu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc-32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc-64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-4k.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-64k.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-ppc32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-ppc64.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/phyp_dump.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_feature.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_low_i2c.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_pfunc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmi.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/poll.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/posix_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc-pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc4xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc_asm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/processor.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/prom.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3av.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3fb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3stor.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ptrace.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/qe.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/qe_ic.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_booke.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_fsl_emb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/resource.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rheap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rtas.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rtc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rwsem.h (96%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/scatterlist.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/seccomp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sections.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sembuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/serial.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/setjmp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/setup.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/shmbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/shmparam.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sigcontext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/siginfo.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/signal.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/smp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/smu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/socket.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sockios.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sparsemem.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spinlock.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spinlock_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_csa.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_info.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_priv1.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sstep.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/stat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/statfs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/string.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/suspend.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/synch.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/syscall.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/syscalls.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/systbl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/system.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tce.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/termbits.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/termios.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/thread_info.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/time.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/timex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tlb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tlbflush.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/topology.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108_irq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108_pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uaccess.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc_fast.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc_slow.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucontext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/udbg.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uic.h (95%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/unaligned.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uninorth.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/unistd.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/user.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vdso.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vdso_datapage.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vga.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xilinx_intc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xmon.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xor.h (100%)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 928a79c..de4063c 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -278,7 +278,7 @@ it with special cases.
         a 64-bit platform.
 
         d) request and get assigned a platform number (see PLATFORM_*
-        constants in include/asm-powerpc/processor.h
+        constants in arch/powerpc/include/asm/processor.h
 
 32-bit embedded kernels:
 
@@ -340,7 +340,7 @@ the block to RAM before passing it to the kernel.
 ---------
 
    The kernel is entered with r3 pointing to an area of memory that is
-   roughly described in include/asm-powerpc/prom.h by the structure
+   roughly described in arch/powerpc/include/asm/prom.h by the structure
    boot_param_header:
 
 struct boot_param_header {
diff --git a/Documentation/powerpc/eeh-pci-error-recovery.txt b/Documentation/powerpc/eeh-pci-error-recovery.txt
index df7afe4..9d4e33d 100644
--- a/Documentation/powerpc/eeh-pci-error-recovery.txt
+++ b/Documentation/powerpc/eeh-pci-error-recovery.txt
@@ -133,7 +133,7 @@ error.  Given an arbitrary address, the routine
 pci_get_device_by_addr() will find the pci device associated
 with that address (if any).
 
-The default include/asm-powerpc/io.h macros readb(), inb(), insb(),
+The default arch/powerpc/include/asm/io.h macros readb(), inb(), insb(),
 etc. include a check to see if the i/o read returned all-0xff's.
 If so, these make a call to eeh_dn_check_failure(), which in turn
 asks the firmware if the all-ff's value is the sign of a true EEH
diff --git a/arch/powerpc/boot/io.h b/arch/powerpc/boot/io.h
index ccaedae..7c09f48 100644
--- a/arch/powerpc/boot/io.h
+++ b/arch/powerpc/boot/io.h
@@ -6,7 +6,7 @@
 /*
  * Low-level I/O routines.
  *
- * Copied from <file:include/asm-powerpc/io.h> (which has no copyright)
+ * Copied from <file:arch/powerpc/include/asm/io.h> (which has no copyright)
  */
 static inline int in_8(const volatile unsigned char *addr)
 {
diff --git a/include/asm-powerpc/8253pit.h b/arch/powerpc/include/asm/8253pit.h
similarity index 100%
rename from include/asm-powerpc/8253pit.h
rename to arch/powerpc/include/asm/8253pit.h
diff --git a/include/asm-powerpc/8xx_immap.h b/arch/powerpc/include/asm/8xx_immap.h
similarity index 100%
rename from include/asm-powerpc/8xx_immap.h
rename to arch/powerpc/include/asm/8xx_immap.h
diff --git a/include/asm-powerpc/Kbuild b/arch/powerpc/include/asm/Kbuild
similarity index 100%
rename from include/asm-powerpc/Kbuild
rename to arch/powerpc/include/asm/Kbuild
diff --git a/include/asm-powerpc/a.out.h b/arch/powerpc/include/asm/a.out.h
similarity index 100%
rename from include/asm-powerpc/a.out.h
rename to arch/powerpc/include/asm/a.out.h
diff --git a/include/asm-powerpc/abs_addr.h b/arch/powerpc/include/asm/abs_addr.h
similarity index 100%
rename from include/asm-powerpc/abs_addr.h
rename to arch/powerpc/include/asm/abs_addr.h
diff --git a/include/asm-powerpc/agp.h b/arch/powerpc/include/asm/agp.h
similarity index 100%
rename from include/asm-powerpc/agp.h
rename to arch/powerpc/include/asm/agp.h
diff --git a/include/asm-powerpc/asm-compat.h b/arch/powerpc/include/asm/asm-compat.h
similarity index 100%
rename from include/asm-powerpc/asm-compat.h
rename to arch/powerpc/include/asm/asm-compat.h
diff --git a/include/asm-powerpc/atomic.h b/arch/powerpc/include/asm/atomic.h
similarity index 100%
rename from include/asm-powerpc/atomic.h
rename to arch/powerpc/include/asm/atomic.h
diff --git a/include/asm-powerpc/auxvec.h b/arch/powerpc/include/asm/auxvec.h
similarity index 100%
rename from include/asm-powerpc/auxvec.h
rename to arch/powerpc/include/asm/auxvec.h
diff --git a/include/asm-powerpc/backlight.h b/arch/powerpc/include/asm/backlight.h
similarity index 100%
rename from include/asm-powerpc/backlight.h
rename to arch/powerpc/include/asm/backlight.h
diff --git a/include/asm-powerpc/bitops.h b/arch/powerpc/include/asm/bitops.h
similarity index 100%
rename from include/asm-powerpc/bitops.h
rename to arch/powerpc/include/asm/bitops.h
diff --git a/include/asm-powerpc/bootx.h b/arch/powerpc/include/asm/bootx.h
similarity index 100%
rename from include/asm-powerpc/bootx.h
rename to arch/powerpc/include/asm/bootx.h
diff --git a/include/asm-powerpc/btext.h b/arch/powerpc/include/asm/btext.h
similarity index 100%
rename from include/asm-powerpc/btext.h
rename to arch/powerpc/include/asm/btext.h
diff --git a/include/asm-powerpc/bug.h b/arch/powerpc/include/asm/bug.h
similarity index 100%
rename from include/asm-powerpc/bug.h
rename to arch/powerpc/include/asm/bug.h
diff --git a/include/asm-powerpc/bugs.h b/arch/powerpc/include/asm/bugs.h
similarity index 100%
rename from include/asm-powerpc/bugs.h
rename to arch/powerpc/include/asm/bugs.h
diff --git a/include/asm-powerpc/byteorder.h b/arch/powerpc/include/asm/byteorder.h
similarity index 100%
rename from include/asm-powerpc/byteorder.h
rename to arch/powerpc/include/asm/byteorder.h
diff --git a/include/asm-powerpc/cache.h b/arch/powerpc/include/asm/cache.h
similarity index 100%
rename from include/asm-powerpc/cache.h
rename to arch/powerpc/include/asm/cache.h
diff --git a/include/asm-powerpc/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
similarity index 100%
rename from include/asm-powerpc/cacheflush.h
rename to arch/powerpc/include/asm/cacheflush.h
diff --git a/include/asm-powerpc/cell-pmu.h b/arch/powerpc/include/asm/cell-pmu.h
similarity index 100%
rename from include/asm-powerpc/cell-pmu.h
rename to arch/powerpc/include/asm/cell-pmu.h
diff --git a/include/asm-powerpc/cell-regs.h b/arch/powerpc/include/asm/cell-regs.h
similarity index 100%
rename from include/asm-powerpc/cell-regs.h
rename to arch/powerpc/include/asm/cell-regs.h
diff --git a/include/asm-powerpc/checksum.h b/arch/powerpc/include/asm/checksum.h
similarity index 100%
rename from include/asm-powerpc/checksum.h
rename to arch/powerpc/include/asm/checksum.h
diff --git a/include/asm-powerpc/clk_interface.h b/arch/powerpc/include/asm/clk_interface.h
similarity index 100%
rename from include/asm-powerpc/clk_interface.h
rename to arch/powerpc/include/asm/clk_interface.h
diff --git a/include/asm-powerpc/code-patching.h b/arch/powerpc/include/asm/code-patching.h
similarity index 100%
rename from include/asm-powerpc/code-patching.h
rename to arch/powerpc/include/asm/code-patching.h
diff --git a/include/asm-powerpc/compat.h b/arch/powerpc/include/asm/compat.h
similarity index 100%
rename from include/asm-powerpc/compat.h
rename to arch/powerpc/include/asm/compat.h
diff --git a/include/asm-powerpc/cpm.h b/arch/powerpc/include/asm/cpm.h
similarity index 100%
rename from include/asm-powerpc/cpm.h
rename to arch/powerpc/include/asm/cpm.h
diff --git a/include/asm-powerpc/cpm1.h b/arch/powerpc/include/asm/cpm1.h
similarity index 100%
rename from include/asm-powerpc/cpm1.h
rename to arch/powerpc/include/asm/cpm1.h
diff --git a/include/asm-powerpc/cpm2.h b/arch/powerpc/include/asm/cpm2.h
similarity index 100%
rename from include/asm-powerpc/cpm2.h
rename to arch/powerpc/include/asm/cpm2.h
diff --git a/include/asm-powerpc/cputable.h b/arch/powerpc/include/asm/cputable.h
similarity index 100%
rename from include/asm-powerpc/cputable.h
rename to arch/powerpc/include/asm/cputable.h
diff --git a/include/asm-powerpc/cputhreads.h b/arch/powerpc/include/asm/cputhreads.h
similarity index 100%
rename from include/asm-powerpc/cputhreads.h
rename to arch/powerpc/include/asm/cputhreads.h
diff --git a/include/asm-powerpc/cputime.h b/arch/powerpc/include/asm/cputime.h
similarity index 100%
rename from include/asm-powerpc/cputime.h
rename to arch/powerpc/include/asm/cputime.h
diff --git a/include/asm-powerpc/current.h b/arch/powerpc/include/asm/current.h
similarity index 100%
rename from include/asm-powerpc/current.h
rename to arch/powerpc/include/asm/current.h
diff --git a/include/asm-powerpc/dbdma.h b/arch/powerpc/include/asm/dbdma.h
similarity index 100%
rename from include/asm-powerpc/dbdma.h
rename to arch/powerpc/include/asm/dbdma.h
diff --git a/include/asm-powerpc/dcr-generic.h b/arch/powerpc/include/asm/dcr-generic.h
similarity index 100%
rename from include/asm-powerpc/dcr-generic.h
rename to arch/powerpc/include/asm/dcr-generic.h
diff --git a/include/asm-powerpc/dcr-mmio.h b/arch/powerpc/include/asm/dcr-mmio.h
similarity index 100%
rename from include/asm-powerpc/dcr-mmio.h
rename to arch/powerpc/include/asm/dcr-mmio.h
diff --git a/include/asm-powerpc/dcr-native.h b/arch/powerpc/include/asm/dcr-native.h
similarity index 100%
rename from include/asm-powerpc/dcr-native.h
rename to arch/powerpc/include/asm/dcr-native.h
diff --git a/include/asm-powerpc/dcr-regs.h b/arch/powerpc/include/asm/dcr-regs.h
similarity index 100%
rename from include/asm-powerpc/dcr-regs.h
rename to arch/powerpc/include/asm/dcr-regs.h
diff --git a/include/asm-powerpc/dcr.h b/arch/powerpc/include/asm/dcr.h
similarity index 100%
rename from include/asm-powerpc/dcr.h
rename to arch/powerpc/include/asm/dcr.h
diff --git a/include/asm-powerpc/delay.h b/arch/powerpc/include/asm/delay.h
similarity index 100%
rename from include/asm-powerpc/delay.h
rename to arch/powerpc/include/asm/delay.h
diff --git a/include/asm-powerpc/device.h b/arch/powerpc/include/asm/device.h
similarity index 100%
rename from include/asm-powerpc/device.h
rename to arch/powerpc/include/asm/device.h
diff --git a/include/asm-powerpc/div64.h b/arch/powerpc/include/asm/div64.h
similarity index 100%
rename from include/asm-powerpc/div64.h
rename to arch/powerpc/include/asm/div64.h
diff --git a/include/asm-powerpc/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
similarity index 100%
rename from include/asm-powerpc/dma-mapping.h
rename to arch/powerpc/include/asm/dma-mapping.h
diff --git a/include/asm-powerpc/dma.h b/arch/powerpc/include/asm/dma.h
similarity index 100%
rename from include/asm-powerpc/dma.h
rename to arch/powerpc/include/asm/dma.h
diff --git a/include/asm-powerpc/edac.h b/arch/powerpc/include/asm/edac.h
similarity index 100%
rename from include/asm-powerpc/edac.h
rename to arch/powerpc/include/asm/edac.h
diff --git a/include/asm-powerpc/eeh.h b/arch/powerpc/include/asm/eeh.h
similarity index 100%
rename from include/asm-powerpc/eeh.h
rename to arch/powerpc/include/asm/eeh.h
diff --git a/include/asm-powerpc/eeh_event.h b/arch/powerpc/include/asm/eeh_event.h
similarity index 100%
rename from include/asm-powerpc/eeh_event.h
rename to arch/powerpc/include/asm/eeh_event.h
diff --git a/include/asm-powerpc/elf.h b/arch/powerpc/include/asm/elf.h
similarity index 100%
rename from include/asm-powerpc/elf.h
rename to arch/powerpc/include/asm/elf.h
diff --git a/include/asm-powerpc/emergency-restart.h b/arch/powerpc/include/asm/emergency-restart.h
similarity index 100%
rename from include/asm-powerpc/emergency-restart.h
rename to arch/powerpc/include/asm/emergency-restart.h
diff --git a/include/asm-powerpc/errno.h b/arch/powerpc/include/asm/errno.h
similarity index 100%
rename from include/asm-powerpc/errno.h
rename to arch/powerpc/include/asm/errno.h
diff --git a/include/asm-powerpc/exception.h b/arch/powerpc/include/asm/exception.h
similarity index 100%
rename from include/asm-powerpc/exception.h
rename to arch/powerpc/include/asm/exception.h
diff --git a/include/asm-powerpc/fb.h b/arch/powerpc/include/asm/fb.h
similarity index 100%
rename from include/asm-powerpc/fb.h
rename to arch/powerpc/include/asm/fb.h
diff --git a/include/asm-powerpc/fcntl.h b/arch/powerpc/include/asm/fcntl.h
similarity index 100%
rename from include/asm-powerpc/fcntl.h
rename to arch/powerpc/include/asm/fcntl.h
diff --git a/include/asm-powerpc/feature-fixups.h b/arch/powerpc/include/asm/feature-fixups.h
similarity index 100%
rename from include/asm-powerpc/feature-fixups.h
rename to arch/powerpc/include/asm/feature-fixups.h
diff --git a/include/asm-powerpc/firmware.h b/arch/powerpc/include/asm/firmware.h
similarity index 100%
rename from include/asm-powerpc/firmware.h
rename to arch/powerpc/include/asm/firmware.h
diff --git a/include/asm-powerpc/fixmap.h b/arch/powerpc/include/asm/fixmap.h
similarity index 100%
rename from include/asm-powerpc/fixmap.h
rename to arch/powerpc/include/asm/fixmap.h
diff --git a/include/asm-powerpc/floppy.h b/arch/powerpc/include/asm/floppy.h
similarity index 100%
rename from include/asm-powerpc/floppy.h
rename to arch/powerpc/include/asm/floppy.h
diff --git a/include/asm-powerpc/fs_pd.h b/arch/powerpc/include/asm/fs_pd.h
similarity index 100%
rename from include/asm-powerpc/fs_pd.h
rename to arch/powerpc/include/asm/fs_pd.h
diff --git a/include/asm-powerpc/fsl_gtm.h b/arch/powerpc/include/asm/fsl_gtm.h
similarity index 100%
rename from include/asm-powerpc/fsl_gtm.h
rename to arch/powerpc/include/asm/fsl_gtm.h
diff --git a/include/asm-powerpc/fsl_lbc.h b/arch/powerpc/include/asm/fsl_lbc.h
similarity index 100%
rename from include/asm-powerpc/fsl_lbc.h
rename to arch/powerpc/include/asm/fsl_lbc.h
diff --git a/include/asm-powerpc/ftrace.h b/arch/powerpc/include/asm/ftrace.h
similarity index 100%
rename from include/asm-powerpc/ftrace.h
rename to arch/powerpc/include/asm/ftrace.h
diff --git a/include/asm-powerpc/futex.h b/arch/powerpc/include/asm/futex.h
similarity index 100%
rename from include/asm-powerpc/futex.h
rename to arch/powerpc/include/asm/futex.h
diff --git a/include/asm-powerpc/gpio.h b/arch/powerpc/include/asm/gpio.h
similarity index 100%
rename from include/asm-powerpc/gpio.h
rename to arch/powerpc/include/asm/gpio.h
diff --git a/include/asm-powerpc/grackle.h b/arch/powerpc/include/asm/grackle.h
similarity index 100%
rename from include/asm-powerpc/grackle.h
rename to arch/powerpc/include/asm/grackle.h
diff --git a/include/asm-powerpc/hardirq.h b/arch/powerpc/include/asm/hardirq.h
similarity index 100%
rename from include/asm-powerpc/hardirq.h
rename to arch/powerpc/include/asm/hardirq.h
diff --git a/include/asm-powerpc/heathrow.h b/arch/powerpc/include/asm/heathrow.h
similarity index 100%
rename from include/asm-powerpc/heathrow.h
rename to arch/powerpc/include/asm/heathrow.h
diff --git a/include/asm-powerpc/highmem.h b/arch/powerpc/include/asm/highmem.h
similarity index 100%
rename from include/asm-powerpc/highmem.h
rename to arch/powerpc/include/asm/highmem.h
diff --git a/include/asm-powerpc/hugetlb.h b/arch/powerpc/include/asm/hugetlb.h
similarity index 100%
rename from include/asm-powerpc/hugetlb.h
rename to arch/powerpc/include/asm/hugetlb.h
diff --git a/include/asm-powerpc/hvcall.h b/arch/powerpc/include/asm/hvcall.h
similarity index 100%
rename from include/asm-powerpc/hvcall.h
rename to arch/powerpc/include/asm/hvcall.h
diff --git a/include/asm-powerpc/hvconsole.h b/arch/powerpc/include/asm/hvconsole.h
similarity index 100%
rename from include/asm-powerpc/hvconsole.h
rename to arch/powerpc/include/asm/hvconsole.h
diff --git a/include/asm-powerpc/hvcserver.h b/arch/powerpc/include/asm/hvcserver.h
similarity index 100%
rename from include/asm-powerpc/hvcserver.h
rename to arch/powerpc/include/asm/hvcserver.h
diff --git a/include/asm-powerpc/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
similarity index 100%
rename from include/asm-powerpc/hw_irq.h
rename to arch/powerpc/include/asm/hw_irq.h
diff --git a/include/asm-powerpc/hydra.h b/arch/powerpc/include/asm/hydra.h
similarity index 100%
rename from include/asm-powerpc/hydra.h
rename to arch/powerpc/include/asm/hydra.h
diff --git a/include/asm-powerpc/i8259.h b/arch/powerpc/include/asm/i8259.h
similarity index 100%
rename from include/asm-powerpc/i8259.h
rename to arch/powerpc/include/asm/i8259.h
diff --git a/include/asm-powerpc/ibmebus.h b/arch/powerpc/include/asm/ibmebus.h
similarity index 100%
rename from include/asm-powerpc/ibmebus.h
rename to arch/powerpc/include/asm/ibmebus.h
diff --git a/include/asm-powerpc/ide.h b/arch/powerpc/include/asm/ide.h
similarity index 100%
rename from include/asm-powerpc/ide.h
rename to arch/powerpc/include/asm/ide.h
diff --git a/include/asm-powerpc/immap_86xx.h b/arch/powerpc/include/asm/immap_86xx.h
similarity index 100%
rename from include/asm-powerpc/immap_86xx.h
rename to arch/powerpc/include/asm/immap_86xx.h
diff --git a/include/asm-powerpc/immap_cpm2.h b/arch/powerpc/include/asm/immap_cpm2.h
similarity index 100%
rename from include/asm-powerpc/immap_cpm2.h
rename to arch/powerpc/include/asm/immap_cpm2.h
diff --git a/include/asm-powerpc/immap_qe.h b/arch/powerpc/include/asm/immap_qe.h
similarity index 99%
rename from include/asm-powerpc/immap_qe.h
rename to arch/powerpc/include/asm/immap_qe.h
index 7b6f411..3c2fced 100644
--- a/include/asm-powerpc/immap_qe.h
+++ b/arch/powerpc/include/asm/immap_qe.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/immap_qe.h
- *
  * QUICC Engine (QE) Internal Memory Map.
  * The Internal Memory Map for devices with QE on them. This
  * is the superset of all QE devices (8360, etc.).
diff --git a/include/asm-powerpc/io-defs.h b/arch/powerpc/include/asm/io-defs.h
similarity index 100%
rename from include/asm-powerpc/io-defs.h
rename to arch/powerpc/include/asm/io-defs.h
diff --git a/include/asm-powerpc/io.h b/arch/powerpc/include/asm/io.h
similarity index 100%
rename from include/asm-powerpc/io.h
rename to arch/powerpc/include/asm/io.h
diff --git a/include/asm-powerpc/ioctl.h b/arch/powerpc/include/asm/ioctl.h
similarity index 100%
rename from include/asm-powerpc/ioctl.h
rename to arch/powerpc/include/asm/ioctl.h
diff --git a/include/asm-powerpc/ioctls.h b/arch/powerpc/include/asm/ioctls.h
similarity index 100%
rename from include/asm-powerpc/ioctls.h
rename to arch/powerpc/include/asm/ioctls.h
diff --git a/include/asm-powerpc/iommu.h b/arch/powerpc/include/asm/iommu.h
similarity index 100%
rename from include/asm-powerpc/iommu.h
rename to arch/powerpc/include/asm/iommu.h
diff --git a/include/asm-powerpc/ipcbuf.h b/arch/powerpc/include/asm/ipcbuf.h
similarity index 100%
rename from include/asm-powerpc/ipcbuf.h
rename to arch/powerpc/include/asm/ipcbuf.h
diff --git a/include/asm-powerpc/ipic.h b/arch/powerpc/include/asm/ipic.h
similarity index 99%
rename from include/asm-powerpc/ipic.h
rename to arch/powerpc/include/asm/ipic.h
index 8ff08be..4cf3553 100644
--- a/include/asm-powerpc/ipic.h
+++ b/arch/powerpc/include/asm/ipic.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/ipic.h
- *
  * IPIC external definitions and structure.
  *
  * Maintainer: Kumar Gala <galak@kernel.crashing.org>
diff --git a/include/asm-powerpc/irq.h b/arch/powerpc/include/asm/irq.h
similarity index 100%
rename from include/asm-powerpc/irq.h
rename to arch/powerpc/include/asm/irq.h
diff --git a/include/asm-powerpc/irq_regs.h b/arch/powerpc/include/asm/irq_regs.h
similarity index 100%
rename from include/asm-powerpc/irq_regs.h
rename to arch/powerpc/include/asm/irq_regs.h
diff --git a/include/asm-powerpc/irqflags.h b/arch/powerpc/include/asm/irqflags.h
similarity index 93%
rename from include/asm-powerpc/irqflags.h
rename to arch/powerpc/include/asm/irqflags.h
index cc6fdba..17ba3a8 100644
--- a/include/asm-powerpc/irqflags.h
+++ b/arch/powerpc/include/asm/irqflags.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/irqflags.h
- *
  * IRQ flags handling
  */
 #ifndef _ASM_IRQFLAGS_H
@@ -10,7 +8,7 @@
 /*
  * Get definitions for raw_local_save_flags(x), etc.
  */
-#include <asm-powerpc/hw_irq.h>
+#include <asm/hw_irq.h>
 
 #else
 #ifdef CONFIG_TRACE_IRQFLAGS
diff --git a/include/asm-powerpc/iseries/alpaca.h b/arch/powerpc/include/asm/iseries/alpaca.h
similarity index 100%
rename from include/asm-powerpc/iseries/alpaca.h
rename to arch/powerpc/include/asm/iseries/alpaca.h
diff --git a/include/asm-powerpc/iseries/hv_call.h b/arch/powerpc/include/asm/iseries/hv_call.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_call.h
rename to arch/powerpc/include/asm/iseries/hv_call.h
diff --git a/include/asm-powerpc/iseries/hv_call_event.h b/arch/powerpc/include/asm/iseries/hv_call_event.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_call_event.h
rename to arch/powerpc/include/asm/iseries/hv_call_event.h
diff --git a/include/asm-powerpc/iseries/hv_call_sc.h b/arch/powerpc/include/asm/iseries/hv_call_sc.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_call_sc.h
rename to arch/powerpc/include/asm/iseries/hv_call_sc.h
diff --git a/include/asm-powerpc/iseries/hv_call_xm.h b/arch/powerpc/include/asm/iseries/hv_call_xm.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_call_xm.h
rename to arch/powerpc/include/asm/iseries/hv_call_xm.h
diff --git a/include/asm-powerpc/iseries/hv_lp_config.h b/arch/powerpc/include/asm/iseries/hv_lp_config.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_lp_config.h
rename to arch/powerpc/include/asm/iseries/hv_lp_config.h
diff --git a/include/asm-powerpc/iseries/hv_lp_event.h b/arch/powerpc/include/asm/iseries/hv_lp_event.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_lp_event.h
rename to arch/powerpc/include/asm/iseries/hv_lp_event.h
diff --git a/include/asm-powerpc/iseries/hv_types.h b/arch/powerpc/include/asm/iseries/hv_types.h
similarity index 100%
rename from include/asm-powerpc/iseries/hv_types.h
rename to arch/powerpc/include/asm/iseries/hv_types.h
diff --git a/include/asm-powerpc/iseries/iommu.h b/arch/powerpc/include/asm/iseries/iommu.h
similarity index 100%
rename from include/asm-powerpc/iseries/iommu.h
rename to arch/powerpc/include/asm/iseries/iommu.h
diff --git a/include/asm-powerpc/iseries/it_lp_queue.h b/arch/powerpc/include/asm/iseries/it_lp_queue.h
similarity index 100%
rename from include/asm-powerpc/iseries/it_lp_queue.h
rename to arch/powerpc/include/asm/iseries/it_lp_queue.h
diff --git a/include/asm-powerpc/iseries/lpar_map.h b/arch/powerpc/include/asm/iseries/lpar_map.h
similarity index 100%
rename from include/asm-powerpc/iseries/lpar_map.h
rename to arch/powerpc/include/asm/iseries/lpar_map.h
diff --git a/include/asm-powerpc/iseries/mf.h b/arch/powerpc/include/asm/iseries/mf.h
similarity index 100%
rename from include/asm-powerpc/iseries/mf.h
rename to arch/powerpc/include/asm/iseries/mf.h
diff --git a/include/asm-powerpc/iseries/vio.h b/arch/powerpc/include/asm/iseries/vio.h
similarity index 100%
rename from include/asm-powerpc/iseries/vio.h
rename to arch/powerpc/include/asm/iseries/vio.h
diff --git a/include/asm-powerpc/kdebug.h b/arch/powerpc/include/asm/kdebug.h
similarity index 100%
rename from include/asm-powerpc/kdebug.h
rename to arch/powerpc/include/asm/kdebug.h
diff --git a/include/asm-powerpc/kdump.h b/arch/powerpc/include/asm/kdump.h
similarity index 100%
rename from include/asm-powerpc/kdump.h
rename to arch/powerpc/include/asm/kdump.h
diff --git a/include/asm-powerpc/kexec.h b/arch/powerpc/include/asm/kexec.h
similarity index 100%
rename from include/asm-powerpc/kexec.h
rename to arch/powerpc/include/asm/kexec.h
diff --git a/include/asm-powerpc/keylargo.h b/arch/powerpc/include/asm/keylargo.h
similarity index 100%
rename from include/asm-powerpc/keylargo.h
rename to arch/powerpc/include/asm/keylargo.h
diff --git a/include/asm-powerpc/kgdb.h b/arch/powerpc/include/asm/kgdb.h
similarity index 98%
rename from include/asm-powerpc/kgdb.h
rename to arch/powerpc/include/asm/kgdb.h
index 1399caf..edd2170 100644
--- a/include/asm-powerpc/kgdb.h
+++ b/arch/powerpc/include/asm/kgdb.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/kgdb.h
- *
  * The PowerPC (32/64) specific defines / externs for KGDB.  Based on
  * the previous 32bit and 64bit specific files, which had the following
  * copyrights:
diff --git a/include/asm-powerpc/kmap_types.h b/arch/powerpc/include/asm/kmap_types.h
similarity index 100%
rename from include/asm-powerpc/kmap_types.h
rename to arch/powerpc/include/asm/kmap_types.h
diff --git a/include/asm-powerpc/kprobes.h b/arch/powerpc/include/asm/kprobes.h
similarity index 100%
rename from include/asm-powerpc/kprobes.h
rename to arch/powerpc/include/asm/kprobes.h
diff --git a/include/asm-powerpc/kvm.h b/arch/powerpc/include/asm/kvm.h
similarity index 100%
rename from include/asm-powerpc/kvm.h
rename to arch/powerpc/include/asm/kvm.h
diff --git a/include/asm-powerpc/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
similarity index 100%
rename from include/asm-powerpc/kvm_asm.h
rename to arch/powerpc/include/asm/kvm_asm.h
diff --git a/include/asm-powerpc/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
similarity index 100%
rename from include/asm-powerpc/kvm_host.h
rename to arch/powerpc/include/asm/kvm_host.h
diff --git a/include/asm-powerpc/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
similarity index 100%
rename from include/asm-powerpc/kvm_para.h
rename to arch/powerpc/include/asm/kvm_para.h
diff --git a/include/asm-powerpc/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
similarity index 100%
rename from include/asm-powerpc/kvm_ppc.h
rename to arch/powerpc/include/asm/kvm_ppc.h
diff --git a/include/asm-powerpc/libata-portmap.h b/arch/powerpc/include/asm/libata-portmap.h
similarity index 100%
rename from include/asm-powerpc/libata-portmap.h
rename to arch/powerpc/include/asm/libata-portmap.h
diff --git a/include/asm-powerpc/linkage.h b/arch/powerpc/include/asm/linkage.h
similarity index 100%
rename from include/asm-powerpc/linkage.h
rename to arch/powerpc/include/asm/linkage.h
diff --git a/include/asm-powerpc/lmb.h b/arch/powerpc/include/asm/lmb.h
similarity index 100%
rename from include/asm-powerpc/lmb.h
rename to arch/powerpc/include/asm/lmb.h
diff --git a/include/asm-powerpc/local.h b/arch/powerpc/include/asm/local.h
similarity index 100%
rename from include/asm-powerpc/local.h
rename to arch/powerpc/include/asm/local.h
diff --git a/include/asm-powerpc/lppaca.h b/arch/powerpc/include/asm/lppaca.h
similarity index 100%
rename from include/asm-powerpc/lppaca.h
rename to arch/powerpc/include/asm/lppaca.h
diff --git a/include/asm-powerpc/lv1call.h b/arch/powerpc/include/asm/lv1call.h
similarity index 100%
rename from include/asm-powerpc/lv1call.h
rename to arch/powerpc/include/asm/lv1call.h
diff --git a/include/asm-powerpc/machdep.h b/arch/powerpc/include/asm/machdep.h
similarity index 100%
rename from include/asm-powerpc/machdep.h
rename to arch/powerpc/include/asm/machdep.h
diff --git a/include/asm-powerpc/macio.h b/arch/powerpc/include/asm/macio.h
similarity index 100%
rename from include/asm-powerpc/macio.h
rename to arch/powerpc/include/asm/macio.h
diff --git a/include/asm-powerpc/mc146818rtc.h b/arch/powerpc/include/asm/mc146818rtc.h
similarity index 100%
rename from include/asm-powerpc/mc146818rtc.h
rename to arch/powerpc/include/asm/mc146818rtc.h
diff --git a/include/asm-powerpc/mediabay.h b/arch/powerpc/include/asm/mediabay.h
similarity index 100%
rename from include/asm-powerpc/mediabay.h
rename to arch/powerpc/include/asm/mediabay.h
diff --git a/include/asm-powerpc/mman.h b/arch/powerpc/include/asm/mman.h
similarity index 100%
rename from include/asm-powerpc/mman.h
rename to arch/powerpc/include/asm/mman.h
diff --git a/include/asm-powerpc/mmu-40x.h b/arch/powerpc/include/asm/mmu-40x.h
similarity index 100%
rename from include/asm-powerpc/mmu-40x.h
rename to arch/powerpc/include/asm/mmu-40x.h
diff --git a/include/asm-powerpc/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
similarity index 100%
rename from include/asm-powerpc/mmu-44x.h
rename to arch/powerpc/include/asm/mmu-44x.h
diff --git a/include/asm-powerpc/mmu-8xx.h b/arch/powerpc/include/asm/mmu-8xx.h
similarity index 100%
rename from include/asm-powerpc/mmu-8xx.h
rename to arch/powerpc/include/asm/mmu-8xx.h
diff --git a/include/asm-powerpc/mmu-fsl-booke.h b/arch/powerpc/include/asm/mmu-fsl-booke.h
similarity index 100%
rename from include/asm-powerpc/mmu-fsl-booke.h
rename to arch/powerpc/include/asm/mmu-fsl-booke.h
diff --git a/include/asm-powerpc/mmu-hash32.h b/arch/powerpc/include/asm/mmu-hash32.h
similarity index 100%
rename from include/asm-powerpc/mmu-hash32.h
rename to arch/powerpc/include/asm/mmu-hash32.h
diff --git a/include/asm-powerpc/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
similarity index 100%
rename from include/asm-powerpc/mmu-hash64.h
rename to arch/powerpc/include/asm/mmu-hash64.h
diff --git a/include/asm-powerpc/mmu.h b/arch/powerpc/include/asm/mmu.h
similarity index 100%
rename from include/asm-powerpc/mmu.h
rename to arch/powerpc/include/asm/mmu.h
diff --git a/include/asm-powerpc/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
similarity index 100%
rename from include/asm-powerpc/mmu_context.h
rename to arch/powerpc/include/asm/mmu_context.h
diff --git a/include/asm-powerpc/mmzone.h b/arch/powerpc/include/asm/mmzone.h
similarity index 100%
rename from include/asm-powerpc/mmzone.h
rename to arch/powerpc/include/asm/mmzone.h
diff --git a/include/asm-powerpc/module.h b/arch/powerpc/include/asm/module.h
similarity index 100%
rename from include/asm-powerpc/module.h
rename to arch/powerpc/include/asm/module.h
diff --git a/include/asm-powerpc/mpc512x.h b/arch/powerpc/include/asm/mpc512x.h
similarity index 100%
rename from include/asm-powerpc/mpc512x.h
rename to arch/powerpc/include/asm/mpc512x.h
diff --git a/include/asm-powerpc/mpc52xx.h b/arch/powerpc/include/asm/mpc52xx.h
similarity index 100%
rename from include/asm-powerpc/mpc52xx.h
rename to arch/powerpc/include/asm/mpc52xx.h
diff --git a/include/asm-powerpc/mpc52xx_psc.h b/arch/powerpc/include/asm/mpc52xx_psc.h
similarity index 100%
rename from include/asm-powerpc/mpc52xx_psc.h
rename to arch/powerpc/include/asm/mpc52xx_psc.h
diff --git a/include/asm-powerpc/mpc6xx.h b/arch/powerpc/include/asm/mpc6xx.h
similarity index 100%
rename from include/asm-powerpc/mpc6xx.h
rename to arch/powerpc/include/asm/mpc6xx.h
diff --git a/include/asm-powerpc/mpc8260.h b/arch/powerpc/include/asm/mpc8260.h
similarity index 100%
rename from include/asm-powerpc/mpc8260.h
rename to arch/powerpc/include/asm/mpc8260.h
diff --git a/include/asm-powerpc/mpc86xx.h b/arch/powerpc/include/asm/mpc86xx.h
similarity index 100%
rename from include/asm-powerpc/mpc86xx.h
rename to arch/powerpc/include/asm/mpc86xx.h
diff --git a/include/asm-powerpc/mpc8xx.h b/arch/powerpc/include/asm/mpc8xx.h
similarity index 100%
rename from include/asm-powerpc/mpc8xx.h
rename to arch/powerpc/include/asm/mpc8xx.h
diff --git a/include/asm-powerpc/mpic.h b/arch/powerpc/include/asm/mpic.h
similarity index 100%
rename from include/asm-powerpc/mpic.h
rename to arch/powerpc/include/asm/mpic.h
diff --git a/include/asm-powerpc/msgbuf.h b/arch/powerpc/include/asm/msgbuf.h
similarity index 100%
rename from include/asm-powerpc/msgbuf.h
rename to arch/powerpc/include/asm/msgbuf.h
diff --git a/include/asm-powerpc/mutex.h b/arch/powerpc/include/asm/mutex.h
similarity index 100%
rename from include/asm-powerpc/mutex.h
rename to arch/powerpc/include/asm/mutex.h
diff --git a/include/asm-powerpc/nvram.h b/arch/powerpc/include/asm/nvram.h
similarity index 100%
rename from include/asm-powerpc/nvram.h
rename to arch/powerpc/include/asm/nvram.h
diff --git a/include/asm-powerpc/of_device.h b/arch/powerpc/include/asm/of_device.h
similarity index 100%
rename from include/asm-powerpc/of_device.h
rename to arch/powerpc/include/asm/of_device.h
diff --git a/include/asm-powerpc/of_platform.h b/arch/powerpc/include/asm/of_platform.h
similarity index 100%
rename from include/asm-powerpc/of_platform.h
rename to arch/powerpc/include/asm/of_platform.h
diff --git a/include/asm-powerpc/ohare.h b/arch/powerpc/include/asm/ohare.h
similarity index 100%
rename from include/asm-powerpc/ohare.h
rename to arch/powerpc/include/asm/ohare.h
diff --git a/include/asm-powerpc/oprofile_impl.h b/arch/powerpc/include/asm/oprofile_impl.h
similarity index 100%
rename from include/asm-powerpc/oprofile_impl.h
rename to arch/powerpc/include/asm/oprofile_impl.h
diff --git a/include/asm-powerpc/pSeries_reconfig.h b/arch/powerpc/include/asm/pSeries_reconfig.h
similarity index 100%
rename from include/asm-powerpc/pSeries_reconfig.h
rename to arch/powerpc/include/asm/pSeries_reconfig.h
diff --git a/include/asm-powerpc/paca.h b/arch/powerpc/include/asm/paca.h
similarity index 99%
rename from include/asm-powerpc/paca.h
rename to arch/powerpc/include/asm/paca.h
index 7b56444..6493a39 100644
--- a/include/asm-powerpc/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/paca.h
- *
  * This control block defines the PACA which defines the processor
  * specific data for each logical processor on the system.
  * There are some pointers defined that are utilized by PLIC.
diff --git a/include/asm-powerpc/page.h b/arch/powerpc/include/asm/page.h
similarity index 100%
rename from include/asm-powerpc/page.h
rename to arch/powerpc/include/asm/page.h
diff --git a/include/asm-powerpc/page_32.h b/arch/powerpc/include/asm/page_32.h
similarity index 100%
rename from include/asm-powerpc/page_32.h
rename to arch/powerpc/include/asm/page_32.h
diff --git a/include/asm-powerpc/page_64.h b/arch/powerpc/include/asm/page_64.h
similarity index 100%
rename from include/asm-powerpc/page_64.h
rename to arch/powerpc/include/asm/page_64.h
diff --git a/include/asm-powerpc/param.h b/arch/powerpc/include/asm/param.h
similarity index 100%
rename from include/asm-powerpc/param.h
rename to arch/powerpc/include/asm/param.h
diff --git a/include/asm-powerpc/parport.h b/arch/powerpc/include/asm/parport.h
similarity index 100%
rename from include/asm-powerpc/parport.h
rename to arch/powerpc/include/asm/parport.h
diff --git a/include/asm-powerpc/pasemi_dma.h b/arch/powerpc/include/asm/pasemi_dma.h
similarity index 100%
rename from include/asm-powerpc/pasemi_dma.h
rename to arch/powerpc/include/asm/pasemi_dma.h
diff --git a/include/asm-powerpc/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
similarity index 100%
rename from include/asm-powerpc/pci-bridge.h
rename to arch/powerpc/include/asm/pci-bridge.h
diff --git a/include/asm-powerpc/pci.h b/arch/powerpc/include/asm/pci.h
similarity index 100%
rename from include/asm-powerpc/pci.h
rename to arch/powerpc/include/asm/pci.h
diff --git a/include/asm-powerpc/percpu.h b/arch/powerpc/include/asm/percpu.h
similarity index 100%
rename from include/asm-powerpc/percpu.h
rename to arch/powerpc/include/asm/percpu.h
diff --git a/include/asm-powerpc/pgalloc-32.h b/arch/powerpc/include/asm/pgalloc-32.h
similarity index 100%
rename from include/asm-powerpc/pgalloc-32.h
rename to arch/powerpc/include/asm/pgalloc-32.h
diff --git a/include/asm-powerpc/pgalloc-64.h b/arch/powerpc/include/asm/pgalloc-64.h
similarity index 100%
rename from include/asm-powerpc/pgalloc-64.h
rename to arch/powerpc/include/asm/pgalloc-64.h
diff --git a/include/asm-powerpc/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
similarity index 100%
rename from include/asm-powerpc/pgalloc.h
rename to arch/powerpc/include/asm/pgalloc.h
diff --git a/include/asm-powerpc/pgtable-4k.h b/arch/powerpc/include/asm/pgtable-4k.h
similarity index 100%
rename from include/asm-powerpc/pgtable-4k.h
rename to arch/powerpc/include/asm/pgtable-4k.h
diff --git a/include/asm-powerpc/pgtable-64k.h b/arch/powerpc/include/asm/pgtable-64k.h
similarity index 100%
rename from include/asm-powerpc/pgtable-64k.h
rename to arch/powerpc/include/asm/pgtable-64k.h
diff --git a/include/asm-powerpc/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
similarity index 100%
rename from include/asm-powerpc/pgtable-ppc32.h
rename to arch/powerpc/include/asm/pgtable-ppc32.h
diff --git a/include/asm-powerpc/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
similarity index 99%
rename from include/asm-powerpc/pgtable-ppc64.h
rename to arch/powerpc/include/asm/pgtable-ppc64.h
index 74c6f38..db0b8f3 100644
--- a/include/asm-powerpc/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -100,7 +100,7 @@
 
 #define _PAGE_WRENABLE	(_PAGE_RW | _PAGE_DIRTY)
 
-/* __pgprot defined in asm-powerpc/page.h */
+/* __pgprot defined in arch/powerpc/incliude/asm/page.h */
 #define PAGE_NONE	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED)
 
 #define PAGE_SHARED	__pgprot(_PAGE_BASE | _PAGE_RW | _PAGE_USER)
diff --git a/include/asm-powerpc/pgtable.h b/arch/powerpc/include/asm/pgtable.h
similarity index 100%
rename from include/asm-powerpc/pgtable.h
rename to arch/powerpc/include/asm/pgtable.h
diff --git a/include/asm-powerpc/phyp_dump.h b/arch/powerpc/include/asm/phyp_dump.h
similarity index 100%
rename from include/asm-powerpc/phyp_dump.h
rename to arch/powerpc/include/asm/phyp_dump.h
diff --git a/include/asm-powerpc/pmac_feature.h b/arch/powerpc/include/asm/pmac_feature.h
similarity index 100%
rename from include/asm-powerpc/pmac_feature.h
rename to arch/powerpc/include/asm/pmac_feature.h
diff --git a/include/asm-powerpc/pmac_low_i2c.h b/arch/powerpc/include/asm/pmac_low_i2c.h
similarity index 100%
rename from include/asm-powerpc/pmac_low_i2c.h
rename to arch/powerpc/include/asm/pmac_low_i2c.h
diff --git a/include/asm-powerpc/pmac_pfunc.h b/arch/powerpc/include/asm/pmac_pfunc.h
similarity index 100%
rename from include/asm-powerpc/pmac_pfunc.h
rename to arch/powerpc/include/asm/pmac_pfunc.h
diff --git a/include/asm-powerpc/pmc.h b/arch/powerpc/include/asm/pmc.h
similarity index 100%
rename from include/asm-powerpc/pmc.h
rename to arch/powerpc/include/asm/pmc.h
diff --git a/include/asm-powerpc/pmi.h b/arch/powerpc/include/asm/pmi.h
similarity index 100%
rename from include/asm-powerpc/pmi.h
rename to arch/powerpc/include/asm/pmi.h
diff --git a/include/asm-powerpc/poll.h b/arch/powerpc/include/asm/poll.h
similarity index 100%
rename from include/asm-powerpc/poll.h
rename to arch/powerpc/include/asm/poll.h
diff --git a/include/asm-powerpc/posix_types.h b/arch/powerpc/include/asm/posix_types.h
similarity index 100%
rename from include/asm-powerpc/posix_types.h
rename to arch/powerpc/include/asm/posix_types.h
diff --git a/include/asm-powerpc/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
similarity index 100%
rename from include/asm-powerpc/ppc-pci.h
rename to arch/powerpc/include/asm/ppc-pci.h
diff --git a/include/asm-powerpc/ppc4xx.h b/arch/powerpc/include/asm/ppc4xx.h
similarity index 100%
rename from include/asm-powerpc/ppc4xx.h
rename to arch/powerpc/include/asm/ppc4xx.h
diff --git a/include/asm-powerpc/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
similarity index 100%
rename from include/asm-powerpc/ppc_asm.h
rename to arch/powerpc/include/asm/ppc_asm.h
diff --git a/include/asm-powerpc/processor.h b/arch/powerpc/include/asm/processor.h
similarity index 100%
rename from include/asm-powerpc/processor.h
rename to arch/powerpc/include/asm/processor.h
diff --git a/include/asm-powerpc/prom.h b/arch/powerpc/include/asm/prom.h
similarity index 100%
rename from include/asm-powerpc/prom.h
rename to arch/powerpc/include/asm/prom.h
diff --git a/include/asm-powerpc/ps3.h b/arch/powerpc/include/asm/ps3.h
similarity index 100%
rename from include/asm-powerpc/ps3.h
rename to arch/powerpc/include/asm/ps3.h
diff --git a/include/asm-powerpc/ps3av.h b/arch/powerpc/include/asm/ps3av.h
similarity index 100%
rename from include/asm-powerpc/ps3av.h
rename to arch/powerpc/include/asm/ps3av.h
diff --git a/include/asm-powerpc/ps3fb.h b/arch/powerpc/include/asm/ps3fb.h
similarity index 100%
rename from include/asm-powerpc/ps3fb.h
rename to arch/powerpc/include/asm/ps3fb.h
diff --git a/include/asm-powerpc/ps3stor.h b/arch/powerpc/include/asm/ps3stor.h
similarity index 100%
rename from include/asm-powerpc/ps3stor.h
rename to arch/powerpc/include/asm/ps3stor.h
diff --git a/include/asm-powerpc/ptrace.h b/arch/powerpc/include/asm/ptrace.h
similarity index 100%
rename from include/asm-powerpc/ptrace.h
rename to arch/powerpc/include/asm/ptrace.h
diff --git a/include/asm-powerpc/qe.h b/arch/powerpc/include/asm/qe.h
similarity index 100%
rename from include/asm-powerpc/qe.h
rename to arch/powerpc/include/asm/qe.h
diff --git a/include/asm-powerpc/qe_ic.h b/arch/powerpc/include/asm/qe_ic.h
similarity index 99%
rename from include/asm-powerpc/qe_ic.h
rename to arch/powerpc/include/asm/qe_ic.h
index a779b2c..56a7745 100644
--- a/include/asm-powerpc/qe_ic.h
+++ b/arch/powerpc/include/asm/qe_ic.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/qe_ic.h
- *
  * Copyright (C) 2006 Freescale Semicondutor, Inc. All rights reserved.
  *
  * Authors: 	Shlomi Gridish <gridish@freescale.com>
diff --git a/include/asm-powerpc/reg.h b/arch/powerpc/include/asm/reg.h
similarity index 100%
rename from include/asm-powerpc/reg.h
rename to arch/powerpc/include/asm/reg.h
diff --git a/include/asm-powerpc/reg_8xx.h b/arch/powerpc/include/asm/reg_8xx.h
similarity index 100%
rename from include/asm-powerpc/reg_8xx.h
rename to arch/powerpc/include/asm/reg_8xx.h
diff --git a/include/asm-powerpc/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
similarity index 100%
rename from include/asm-powerpc/reg_booke.h
rename to arch/powerpc/include/asm/reg_booke.h
diff --git a/include/asm-powerpc/reg_fsl_emb.h b/arch/powerpc/include/asm/reg_fsl_emb.h
similarity index 100%
rename from include/asm-powerpc/reg_fsl_emb.h
rename to arch/powerpc/include/asm/reg_fsl_emb.h
diff --git a/include/asm-powerpc/resource.h b/arch/powerpc/include/asm/resource.h
similarity index 100%
rename from include/asm-powerpc/resource.h
rename to arch/powerpc/include/asm/resource.h
diff --git a/include/asm-powerpc/rheap.h b/arch/powerpc/include/asm/rheap.h
similarity index 100%
rename from include/asm-powerpc/rheap.h
rename to arch/powerpc/include/asm/rheap.h
diff --git a/include/asm-powerpc/rio.h b/arch/powerpc/include/asm/rio.h
similarity index 100%
rename from include/asm-powerpc/rio.h
rename to arch/powerpc/include/asm/rio.h
diff --git a/include/asm-powerpc/rtas.h b/arch/powerpc/include/asm/rtas.h
similarity index 100%
rename from include/asm-powerpc/rtas.h
rename to arch/powerpc/include/asm/rtas.h
diff --git a/include/asm-powerpc/rtc.h b/arch/powerpc/include/asm/rtc.h
similarity index 100%
rename from include/asm-powerpc/rtc.h
rename to arch/powerpc/include/asm/rtc.h
diff --git a/include/asm-powerpc/rwsem.h b/arch/powerpc/include/asm/rwsem.h
similarity index 96%
rename from include/asm-powerpc/rwsem.h
rename to arch/powerpc/include/asm/rwsem.h
index a6cc93b..24cd928 100644
--- a/include/asm-powerpc/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -8,8 +8,8 @@
 #ifdef __KERNEL__
 
 /*
- * include/asm-powerpc/rwsem.h: R/W semaphores for PPC using the stuff
- * in lib/rwsem.c.  Adapted largely from include/asm-i386/rwsem.h
+ * R/W semaphores for PPC using the stuff in lib/rwsem.c.
+ * Adapted largely from include/asm-i386/rwsem.h
  * by Paul Mackerras <paulus@samba.org>.
  */
 
diff --git a/include/asm-powerpc/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
similarity index 100%
rename from include/asm-powerpc/scatterlist.h
rename to arch/powerpc/include/asm/scatterlist.h
diff --git a/include/asm-powerpc/seccomp.h b/arch/powerpc/include/asm/seccomp.h
similarity index 100%
rename from include/asm-powerpc/seccomp.h
rename to arch/powerpc/include/asm/seccomp.h
diff --git a/include/asm-powerpc/sections.h b/arch/powerpc/include/asm/sections.h
similarity index 100%
rename from include/asm-powerpc/sections.h
rename to arch/powerpc/include/asm/sections.h
diff --git a/include/asm-powerpc/sembuf.h b/arch/powerpc/include/asm/sembuf.h
similarity index 100%
rename from include/asm-powerpc/sembuf.h
rename to arch/powerpc/include/asm/sembuf.h
diff --git a/include/asm-powerpc/serial.h b/arch/powerpc/include/asm/serial.h
similarity index 100%
rename from include/asm-powerpc/serial.h
rename to arch/powerpc/include/asm/serial.h
diff --git a/include/asm-powerpc/setjmp.h b/arch/powerpc/include/asm/setjmp.h
similarity index 100%
rename from include/asm-powerpc/setjmp.h
rename to arch/powerpc/include/asm/setjmp.h
diff --git a/include/asm-powerpc/setup.h b/arch/powerpc/include/asm/setup.h
similarity index 100%
rename from include/asm-powerpc/setup.h
rename to arch/powerpc/include/asm/setup.h
diff --git a/include/asm-powerpc/shmbuf.h b/arch/powerpc/include/asm/shmbuf.h
similarity index 100%
rename from include/asm-powerpc/shmbuf.h
rename to arch/powerpc/include/asm/shmbuf.h
diff --git a/include/asm-powerpc/shmparam.h b/arch/powerpc/include/asm/shmparam.h
similarity index 100%
rename from include/asm-powerpc/shmparam.h
rename to arch/powerpc/include/asm/shmparam.h
diff --git a/include/asm-powerpc/sigcontext.h b/arch/powerpc/include/asm/sigcontext.h
similarity index 100%
rename from include/asm-powerpc/sigcontext.h
rename to arch/powerpc/include/asm/sigcontext.h
diff --git a/include/asm-powerpc/siginfo.h b/arch/powerpc/include/asm/siginfo.h
similarity index 100%
rename from include/asm-powerpc/siginfo.h
rename to arch/powerpc/include/asm/siginfo.h
diff --git a/include/asm-powerpc/signal.h b/arch/powerpc/include/asm/signal.h
similarity index 100%
rename from include/asm-powerpc/signal.h
rename to arch/powerpc/include/asm/signal.h
diff --git a/include/asm-powerpc/smp.h b/arch/powerpc/include/asm/smp.h
similarity index 100%
rename from include/asm-powerpc/smp.h
rename to arch/powerpc/include/asm/smp.h
diff --git a/include/asm-powerpc/smu.h b/arch/powerpc/include/asm/smu.h
similarity index 100%
rename from include/asm-powerpc/smu.h
rename to arch/powerpc/include/asm/smu.h
diff --git a/include/asm-powerpc/socket.h b/arch/powerpc/include/asm/socket.h
similarity index 100%
rename from include/asm-powerpc/socket.h
rename to arch/powerpc/include/asm/socket.h
diff --git a/include/asm-powerpc/sockios.h b/arch/powerpc/include/asm/sockios.h
similarity index 100%
rename from include/asm-powerpc/sockios.h
rename to arch/powerpc/include/asm/sockios.h
diff --git a/include/asm-powerpc/sparsemem.h b/arch/powerpc/include/asm/sparsemem.h
similarity index 100%
rename from include/asm-powerpc/sparsemem.h
rename to arch/powerpc/include/asm/sparsemem.h
diff --git a/include/asm-powerpc/spinlock.h b/arch/powerpc/include/asm/spinlock.h
similarity index 100%
rename from include/asm-powerpc/spinlock.h
rename to arch/powerpc/include/asm/spinlock.h
diff --git a/include/asm-powerpc/spinlock_types.h b/arch/powerpc/include/asm/spinlock_types.h
similarity index 100%
rename from include/asm-powerpc/spinlock_types.h
rename to arch/powerpc/include/asm/spinlock_types.h
diff --git a/include/asm-powerpc/spu.h b/arch/powerpc/include/asm/spu.h
similarity index 100%
rename from include/asm-powerpc/spu.h
rename to arch/powerpc/include/asm/spu.h
diff --git a/include/asm-powerpc/spu_csa.h b/arch/powerpc/include/asm/spu_csa.h
similarity index 100%
rename from include/asm-powerpc/spu_csa.h
rename to arch/powerpc/include/asm/spu_csa.h
diff --git a/include/asm-powerpc/spu_info.h b/arch/powerpc/include/asm/spu_info.h
similarity index 100%
rename from include/asm-powerpc/spu_info.h
rename to arch/powerpc/include/asm/spu_info.h
diff --git a/include/asm-powerpc/spu_priv1.h b/arch/powerpc/include/asm/spu_priv1.h
similarity index 100%
rename from include/asm-powerpc/spu_priv1.h
rename to arch/powerpc/include/asm/spu_priv1.h
diff --git a/include/asm-powerpc/sstep.h b/arch/powerpc/include/asm/sstep.h
similarity index 100%
rename from include/asm-powerpc/sstep.h
rename to arch/powerpc/include/asm/sstep.h
diff --git a/include/asm-powerpc/stat.h b/arch/powerpc/include/asm/stat.h
similarity index 100%
rename from include/asm-powerpc/stat.h
rename to arch/powerpc/include/asm/stat.h
diff --git a/include/asm-powerpc/statfs.h b/arch/powerpc/include/asm/statfs.h
similarity index 100%
rename from include/asm-powerpc/statfs.h
rename to arch/powerpc/include/asm/statfs.h
diff --git a/include/asm-powerpc/string.h b/arch/powerpc/include/asm/string.h
similarity index 100%
rename from include/asm-powerpc/string.h
rename to arch/powerpc/include/asm/string.h
diff --git a/include/asm-powerpc/suspend.h b/arch/powerpc/include/asm/suspend.h
similarity index 100%
rename from include/asm-powerpc/suspend.h
rename to arch/powerpc/include/asm/suspend.h
diff --git a/include/asm-powerpc/synch.h b/arch/powerpc/include/asm/synch.h
similarity index 100%
rename from include/asm-powerpc/synch.h
rename to arch/powerpc/include/asm/synch.h
diff --git a/include/asm-powerpc/syscall.h b/arch/powerpc/include/asm/syscall.h
similarity index 100%
rename from include/asm-powerpc/syscall.h
rename to arch/powerpc/include/asm/syscall.h
diff --git a/include/asm-powerpc/syscalls.h b/arch/powerpc/include/asm/syscalls.h
similarity index 100%
rename from include/asm-powerpc/syscalls.h
rename to arch/powerpc/include/asm/syscalls.h
diff --git a/include/asm-powerpc/systbl.h b/arch/powerpc/include/asm/systbl.h
similarity index 100%
rename from include/asm-powerpc/systbl.h
rename to arch/powerpc/include/asm/systbl.h
diff --git a/include/asm-powerpc/system.h b/arch/powerpc/include/asm/system.h
similarity index 100%
rename from include/asm-powerpc/system.h
rename to arch/powerpc/include/asm/system.h
diff --git a/include/asm-powerpc/tce.h b/arch/powerpc/include/asm/tce.h
similarity index 100%
rename from include/asm-powerpc/tce.h
rename to arch/powerpc/include/asm/tce.h
diff --git a/include/asm-powerpc/termbits.h b/arch/powerpc/include/asm/termbits.h
similarity index 100%
rename from include/asm-powerpc/termbits.h
rename to arch/powerpc/include/asm/termbits.h
diff --git a/include/asm-powerpc/termios.h b/arch/powerpc/include/asm/termios.h
similarity index 100%
rename from include/asm-powerpc/termios.h
rename to arch/powerpc/include/asm/termios.h
diff --git a/include/asm-powerpc/thread_info.h b/arch/powerpc/include/asm/thread_info.h
similarity index 100%
rename from include/asm-powerpc/thread_info.h
rename to arch/powerpc/include/asm/thread_info.h
diff --git a/include/asm-powerpc/time.h b/arch/powerpc/include/asm/time.h
similarity index 100%
rename from include/asm-powerpc/time.h
rename to arch/powerpc/include/asm/time.h
diff --git a/include/asm-powerpc/timex.h b/arch/powerpc/include/asm/timex.h
similarity index 100%
rename from include/asm-powerpc/timex.h
rename to arch/powerpc/include/asm/timex.h
diff --git a/include/asm-powerpc/tlb.h b/arch/powerpc/include/asm/tlb.h
similarity index 100%
rename from include/asm-powerpc/tlb.h
rename to arch/powerpc/include/asm/tlb.h
diff --git a/include/asm-powerpc/tlbflush.h b/arch/powerpc/include/asm/tlbflush.h
similarity index 100%
rename from include/asm-powerpc/tlbflush.h
rename to arch/powerpc/include/asm/tlbflush.h
diff --git a/include/asm-powerpc/topology.h b/arch/powerpc/include/asm/topology.h
similarity index 100%
rename from include/asm-powerpc/topology.h
rename to arch/powerpc/include/asm/topology.h
diff --git a/include/asm-powerpc/tsi108.h b/arch/powerpc/include/asm/tsi108.h
similarity index 100%
rename from include/asm-powerpc/tsi108.h
rename to arch/powerpc/include/asm/tsi108.h
diff --git a/include/asm-powerpc/tsi108_irq.h b/arch/powerpc/include/asm/tsi108_irq.h
similarity index 100%
rename from include/asm-powerpc/tsi108_irq.h
rename to arch/powerpc/include/asm/tsi108_irq.h
diff --git a/include/asm-powerpc/tsi108_pci.h b/arch/powerpc/include/asm/tsi108_pci.h
similarity index 100%
rename from include/asm-powerpc/tsi108_pci.h
rename to arch/powerpc/include/asm/tsi108_pci.h
diff --git a/include/asm-powerpc/types.h b/arch/powerpc/include/asm/types.h
similarity index 100%
rename from include/asm-powerpc/types.h
rename to arch/powerpc/include/asm/types.h
diff --git a/include/asm-powerpc/uaccess.h b/arch/powerpc/include/asm/uaccess.h
similarity index 100%
rename from include/asm-powerpc/uaccess.h
rename to arch/powerpc/include/asm/uaccess.h
diff --git a/include/asm-powerpc/ucc.h b/arch/powerpc/include/asm/ucc.h
similarity index 100%
rename from include/asm-powerpc/ucc.h
rename to arch/powerpc/include/asm/ucc.h
diff --git a/include/asm-powerpc/ucc_fast.h b/arch/powerpc/include/asm/ucc_fast.h
similarity index 99%
rename from include/asm-powerpc/ucc_fast.h
rename to arch/powerpc/include/asm/ucc_fast.h
index fce16ab..839aab8 100644
--- a/include/asm-powerpc/ucc_fast.h
+++ b/arch/powerpc/include/asm/ucc_fast.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/ucc_fast.h
- *
  * Internal header file for UCC FAST unit routines.
  *
  * Copyright (C) 2006 Freescale Semicondutor, Inc. All rights reserved.
diff --git a/include/asm-powerpc/ucc_slow.h b/arch/powerpc/include/asm/ucc_slow.h
similarity index 100%
rename from include/asm-powerpc/ucc_slow.h
rename to arch/powerpc/include/asm/ucc_slow.h
diff --git a/include/asm-powerpc/ucontext.h b/arch/powerpc/include/asm/ucontext.h
similarity index 100%
rename from include/asm-powerpc/ucontext.h
rename to arch/powerpc/include/asm/ucontext.h
diff --git a/include/asm-powerpc/udbg.h b/arch/powerpc/include/asm/udbg.h
similarity index 100%
rename from include/asm-powerpc/udbg.h
rename to arch/powerpc/include/asm/udbg.h
diff --git a/include/asm-powerpc/uic.h b/arch/powerpc/include/asm/uic.h
similarity index 95%
rename from include/asm-powerpc/uic.h
rename to arch/powerpc/include/asm/uic.h
index 970eb7e..597edfc 100644
--- a/include/asm-powerpc/uic.h
+++ b/arch/powerpc/include/asm/uic.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-powerpc/uic.h
- *
  * IBM PPC4xx UIC external definitions and structure.
  *
  * Maintainer: David Gibson <dwg@au1.ibm.com>
diff --git a/include/asm-powerpc/unaligned.h b/arch/powerpc/include/asm/unaligned.h
similarity index 100%
rename from include/asm-powerpc/unaligned.h
rename to arch/powerpc/include/asm/unaligned.h
diff --git a/include/asm-powerpc/uninorth.h b/arch/powerpc/include/asm/uninorth.h
similarity index 100%
rename from include/asm-powerpc/uninorth.h
rename to arch/powerpc/include/asm/uninorth.h
diff --git a/include/asm-powerpc/unistd.h b/arch/powerpc/include/asm/unistd.h
similarity index 100%
rename from include/asm-powerpc/unistd.h
rename to arch/powerpc/include/asm/unistd.h
diff --git a/include/asm-powerpc/user.h b/arch/powerpc/include/asm/user.h
similarity index 100%
rename from include/asm-powerpc/user.h
rename to arch/powerpc/include/asm/user.h
diff --git a/include/asm-powerpc/vdso.h b/arch/powerpc/include/asm/vdso.h
similarity index 100%
rename from include/asm-powerpc/vdso.h
rename to arch/powerpc/include/asm/vdso.h
diff --git a/include/asm-powerpc/vdso_datapage.h b/arch/powerpc/include/asm/vdso_datapage.h
similarity index 100%
rename from include/asm-powerpc/vdso_datapage.h
rename to arch/powerpc/include/asm/vdso_datapage.h
diff --git a/include/asm-powerpc/vga.h b/arch/powerpc/include/asm/vga.h
similarity index 100%
rename from include/asm-powerpc/vga.h
rename to arch/powerpc/include/asm/vga.h
diff --git a/include/asm-powerpc/vio.h b/arch/powerpc/include/asm/vio.h
similarity index 100%
rename from include/asm-powerpc/vio.h
rename to arch/powerpc/include/asm/vio.h
diff --git a/include/asm-powerpc/xilinx_intc.h b/arch/powerpc/include/asm/xilinx_intc.h
similarity index 100%
rename from include/asm-powerpc/xilinx_intc.h
rename to arch/powerpc/include/asm/xilinx_intc.h
diff --git a/include/asm-powerpc/xmon.h b/arch/powerpc/include/asm/xmon.h
similarity index 100%
rename from include/asm-powerpc/xmon.h
rename to arch/powerpc/include/asm/xmon.h
diff --git a/include/asm-powerpc/xor.h b/arch/powerpc/include/asm/xor.h
similarity index 100%
rename from include/asm-powerpc/xor.h
rename to arch/powerpc/include/asm/xor.h
diff --git a/arch/powerpc/mm/tlb_64.c b/arch/powerpc/mm/tlb_64.c
index 409fcc7..be7dd42 100644
--- a/arch/powerpc/mm/tlb_64.c
+++ b/arch/powerpc/mm/tlb_64.c
@@ -34,7 +34,7 @@
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
 
 /* This is declared as we are using the more or less generic
- * include/asm-powerpc/tlb.h file -- tgall
+ * arch/powerpc/include/asm/tlb.h file -- tgall
  */
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_smp.c b/arch/powerpc/platforms/86xx/mpc86xx_smp.c
index 835f2dc..014e26c 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_smp.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_smp.c
@@ -19,7 +19,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pci-bridge.h>
-#include <asm-powerpc/mpic.h>
+#include <asm/mpic.h>
 #include <asm/mpc86xx.h>
 #include <asm/cacheflush.h>
 
diff --git a/drivers/char/hvc_console.h b/drivers/char/hvc_console.h
index d9ce109..9790201 100644
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -6,7 +6,7 @@
  * 	Ryan S. Arnold <rsa@us.ibm.com>
  *
  * hvc_console header information:
- *      moved here from include/asm-powerpc/hvconsole.h
+ *      moved here from arch/powerpc/include/asm/hvconsole.h
  *      and drivers/char/hvc_console.c
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 786d518..473d9b1 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -114,7 +114,7 @@
  * the hvcs_final_close() function in order to get it out of the spinlock.
  * Rearranged hvcs_close().  Cleaned up some printks and did some housekeeping
  * on the changelog.  Removed local CLC_LENGTH and used HVCS_CLC_LENGTH from
- * include/asm-powerpc/hvcserver.h 
+ * arch/powerepc/include/asm/hvcserver.h
  *
  * 1.3.2 -> 1.3.3 Replaced yield() in hvcs_close() with tty_wait_until_sent() to
  * prevent possible lockup with realtime scheduling as similarily pointed out by
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index dd9bc68..898c8b5 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -42,7 +42,7 @@
  */
 
 
-#include <asm-powerpc/system.h>
+#include <asm/system.h>
 #include "ehca_classes.h"
 #include "ehca_tools.h"
 #include "ehca_qes.h"
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

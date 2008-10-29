Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYJ2Reh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYJ2Reh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYJ2Re3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:34:29 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:48927 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYJ2ReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:34:25 -0400
Date: Wed, 29 Oct 2008 18:34:20 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Subject: [PATCH] [CRIS] Move header files from include to arch/cris/include.
Message-ID: <20081029173420.GM4608@axis.com>
References: <20081021164211.GG24715@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021164211.GG24715@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 06:42:11PM +0200, Jesper Nilsson wrote:
> Hi,
> 
> I'm looking for some feedback on the changes in the branch include_move
> at the git-tree:
> 
>         git://repo.or.cz/cris-mirror.git include_move
> 
> I've performed the move of the CRIS headers using the ARM and Blackfin
> ports as a pattern.
> 
> That means that the machine dependent header files are moved to
> arch/cris/mach-{fs,a3}/include, while the common and architecture
> dependent files are moved to arch/cris/include.
> 
> It is mainly this I'd like some input on, since most other ports
> that have moved their header files have put all headers in arch/*/include.

After some soul-searching I've changed this, and moved all header
files into arch/cris/include. The most telling argument was that
the CRIS port wouldn't have anything other than include files in
the arch/cris/mach-* directories.

If that changes some time in the future, it is a simple operation
moving the machine dependent header files there.

Since the complete patch is too large to post, I'm not including
the diff of the files moved, only the files changed.

The commit-diff is also available at:
http://repo.or.cz/w/cris-mirror.git?a=commit;h=556dcee7b829e5c350c3ffdbdb87a8b15aa3c5d3


Change all users of header files to correct path.
Remove some unneeded headers for arch-v32.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Makefile                                 |   26 +-
 arch/cris/arch-v10/boot/.gitignore                 |    2 +
 arch/cris/arch-v10/boot/compressed/head.S          |    2 +-
 arch/cris/arch-v10/boot/compressed/misc.c          |    2 +-
 arch/cris/arch-v10/boot/rescue/head.S              |    2 +-
 arch/cris/arch-v10/boot/rescue/kimagerescue.S      |    2 +-
 arch/cris/arch-v10/boot/rescue/testrescue.S        |    2 +-
 arch/cris/arch-v10/drivers/axisflashmap.c          |    2 +-
 arch/cris/arch-v10/drivers/ds1302.c                |    4 +-
 arch/cris/arch-v10/drivers/gpio.c                  |    4 +-
 arch/cris/arch-v10/drivers/i2c.c                   |    4 +-
 arch/cris/arch-v10/drivers/sync_serial.c           |    4 +-
 arch/cris/arch-v10/kernel/crisksyms.c              |    2 +-
 arch/cris/arch-v10/kernel/debugport.c              |    2 +-
 arch/cris/arch-v10/kernel/dma.c                    |    2 +-
 arch/cris/arch-v10/kernel/entry.S                  |    2 +-
 arch/cris/arch-v10/kernel/fasttimer.c              |    2 +-
 arch/cris/arch-v10/kernel/head.S                   |    2 +-
 arch/cris/arch-v10/kernel/io_interface_mux.c       |    4 +-
 arch/cris/arch-v10/kernel/kgdb.c                   |    2 +-
 arch/cris/arch-v10/kernel/process.c                |    2 +-
 arch/cris/arch-v10/kernel/time.c                   |    2 +-
 arch/cris/arch-v10/kernel/traps.c                  |    2 +-
 arch/cris/arch-v10/mm/fault.c                      |    2 +-
 arch/cris/arch-v10/mm/init.c                       |    2 +-
 arch/cris/arch-v10/mm/tlb.c                        |    2 +-
 arch/cris/arch-v32/boot/compressed/head.S          |    4 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |    2 +-
 arch/cris/arch-v32/drivers/mach-a3/nandflash.c     |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/nandflash.c     |    2 +-
 arch/cris/arch-v32/drivers/pci/bios.c              |    2 +-
 arch/cris/arch-v32/kernel/cache.c                  |    4 +-
 arch/cris/arch-v32/kernel/crisksyms.c              |    8 +-
 arch/cris/arch-v32/kernel/debugport.c              |    2 +-
 arch/cris/arch-v32/kernel/entry.S                  |    4 +-
 arch/cris/arch-v32/kernel/head.S                   |    4 +-
 arch/cris/arch-v32/kernel/kgdb.c                   |    8 +-
 arch/cris/arch-v32/kernel/kgdb_asm.S               |    2 +-
 arch/cris/arch-v32/kernel/pinmux.c                 |    8 +-
 arch/cris/arch-v32/kernel/ptrace.c                 |    2 +-
 arch/cris/arch-v32/kernel/signal.c                 |    4 +-
 arch/cris/arch-v32/lib/nand_init.S                 |   10 +-
 arch/cris/arch-v32/mach-a3/dma.c                   |    2 +-
 arch/cris/arch-v32/mach-a3/io.c                    |    2 +-
 arch/cris/arch-v32/mach-fs/cpufreq.c               |    6 +-
 arch/cris/arch-v32/mach-fs/dma.c                   |    2 +-
 arch/cris/arch-v32/mach-fs/io.c                    |    4 +-
 arch/cris/arch-v32/mach-fs/vcs_hook.c              |    4 +-
 arch/cris/arch-v32/mm/init.c                       |    4 +-
 arch/cris/arch-v32/mm/tlb.c                        |    4 +-
 arch/cris/include/arch-v10/arch/Kbuild             |    4 +
 arch/cris/include/arch-v10/arch/atomic.h           |    7 +
 arch/cris/include/arch-v10/arch/bitops.h           |   73 +
 arch/cris/include/arch-v10/arch/bug.h              |   66 +
 arch/cris/include/arch-v10/arch/byteorder.h        |   26 +
 arch/cris/include/arch-v10/arch/cache.h            |    8 +
 arch/cris/include/arch-v10/arch/checksum.h         |   29 +
 arch/cris/include/arch-v10/arch/delay.h            |   20 +
 arch/cris/include/arch-v10/arch/dma.h              |   74 +
 arch/cris/include/arch-v10/arch/elf.h              |   81 +
 arch/cris/include/arch-v10/arch/io.h               |  199 +
 arch/cris/include/arch-v10/arch/io_interface_mux.h |   75 +
 arch/cris/include/arch-v10/arch/irq.h              |  160 +
 arch/cris/include/arch-v10/arch/memmap.h           |   22 +
 arch/cris/include/arch-v10/arch/mmu.h              |  109 +
 arch/cris/include/arch-v10/arch/offset.h           |   33 +
 arch/cris/include/arch-v10/arch/page.h             |   30 +
 arch/cris/include/arch-v10/arch/pgtable.h          |   17 +
 arch/cris/include/arch-v10/arch/processor.h        |   70 +
 arch/cris/include/arch-v10/arch/ptrace.h           |  119 +
 arch/cris/include/arch-v10/arch/sv_addr.agh        | 7306 ++++++++++++++++++++
 arch/cris/include/arch-v10/arch/sv_addr_ag.h       |  139 +
 arch/cris/include/arch-v10/arch/svinto.h           |   64 +
 arch/cris/include/arch-v10/arch/system.h           |   63 +
 arch/cris/include/arch-v10/arch/thread_info.h      |   12 +
 arch/cris/include/arch-v10/arch/timex.h            |   30 +
 arch/cris/include/arch-v10/arch/tlb.h              |   13 +
 arch/cris/include/arch-v10/arch/uaccess.h          |  660 ++
 arch/cris/include/arch-v10/arch/unistd.h           |  148 +
 arch/cris/include/arch-v10/arch/user.h             |   46 +
 arch/cris/include/arch-v32/arch/Kbuild             |    2 +
 arch/cris/include/arch-v32/arch/atomic.h           |   36 +
 arch/cris/include/arch-v32/arch/bitops.h           |   64 +
 arch/cris/include/arch-v32/arch/bug.h              |   33 +
 arch/cris/include/arch-v32/arch/byteorder.h        |   20 +
 arch/cris/include/arch-v32/arch/cache.h            |   19 +
 arch/cris/include/arch-v32/arch/checksum.h         |   29 +
 arch/cris/include/arch-v32/arch/cryptocop.h        |  272 +
 arch/cris/include/arch-v32/arch/delay.h            |   28 +
 arch/cris/include/arch-v32/arch/dma.h              |   79 +
 arch/cris/include/arch-v32/arch/elf.h              |   73 +
 arch/cris/include/arch-v32/arch/hwregs/Makefile    |  186 +
 .../arch-v32/arch/hwregs/asm/ata_defs_asm.h        |  222 +
 .../arch-v32/arch/hwregs/asm/bif_core_defs_asm.h   |  319 +
 .../arch-v32/arch/hwregs/asm/bif_dma_defs_asm.h    |  495 ++
 .../arch-v32/arch/hwregs/asm/bif_slave_defs_asm.h  |  249 +
 .../arch-v32/arch/hwregs/asm/config_defs_asm.h     |  131 +
 .../include/arch-v32/arch/hwregs/asm/cpu_vect.h    |   41 +
 .../arch-v32/arch/hwregs/asm/cris_defs_asm.h       |  114 +
 .../arch-v32/arch/hwregs/asm/cris_supp_reg.h       |   10 +
 .../arch-v32/arch/hwregs/asm/dma_defs_asm.h        |  368 +
 .../arch-v32/arch/hwregs/asm/eth_defs_asm.h        |  498 ++
 .../arch-v32/arch/hwregs/asm/gio_defs_asm.h        |  276 +
 .../include/arch-v32/arch/hwregs/asm/intr_vect.h   |   38 +
 .../arch-v32/arch/hwregs/asm/intr_vect_defs_asm.h  |  355 +
 .../arch-v32/arch/hwregs/asm/irq_nmi_defs_asm.h    |   69 +
 .../arch-v32/arch/hwregs/asm/marb_defs_asm.h       |  579 ++
 .../arch-v32/arch/hwregs/asm/mmu_defs_asm.h        |  212 +
 .../arch-v32/arch/hwregs/asm/mmu_supp_reg.h        |    7 +
 .../arch-v32/arch/hwregs/asm/rt_trace_defs_asm.h   |  142 +
 .../arch-v32/arch/hwregs/asm/ser_defs_asm.h        |  359 +
 .../arch-v32/arch/hwregs/asm/sser_defs_asm.h       |  462 ++
 .../arch-v32/arch/hwregs/asm/strcop_defs_asm.h     |   84 +
 .../arch-v32/arch/hwregs/asm/strmux_defs_asm.h     |  100 +
 .../arch-v32/arch/hwregs/asm/timer_defs_asm.h      |  229 +
 arch/cris/include/arch-v32/arch/hwregs/ata_defs.h  |  222 +
 .../include/arch-v32/arch/hwregs/bif_core_defs.h   |  284 +
 .../include/arch-v32/arch/hwregs/bif_dma_defs.h    |  473 ++
 .../include/arch-v32/arch/hwregs/bif_slave_defs.h  |  249 +
 .../include/arch-v32/arch/hwregs/config_defs.h     |  142 +
 arch/cris/include/arch-v32/arch/hwregs/cpu_vect.h  |   41 +
 arch/cris/include/arch-v32/arch/hwregs/dma.h       |  127 +
 arch/cris/include/arch-v32/arch/hwregs/dma_defs.h  |  436 ++
 arch/cris/include/arch-v32/arch/hwregs/eth_defs.h  |  378 +
 .../include/arch-v32/arch/hwregs/extmem_defs.h     |  369 +
 .../cris/include/arch-v32/arch/hwregs/iop/Makefile |  146 +
 .../arch/hwregs/iop/asm/iop_crc_par_defs_asm.h     |  171 +
 .../arch/hwregs/iop/asm/iop_dmc_in_defs_asm.h      |  321 +
 .../arch/hwregs/iop/asm/iop_dmc_out_defs_asm.h     |  349 +
 .../arch/hwregs/iop/asm/iop_fifo_in_defs_asm.h     |  234 +
 .../hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h    |  155 +
 .../arch/hwregs/iop/asm/iop_fifo_out_defs_asm.h    |  254 +
 .../hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h   |  158 +
 .../arch/hwregs/iop/asm/iop_mpu_defs_asm.h         |  177 +
 .../arch/hwregs/iop/asm/iop_reg_space_asm.h        |   44 +
 .../arch/hwregs/iop/asm/iop_sap_in_defs_asm.h      |  182 +
 .../arch/hwregs/iop/asm/iop_sap_out_defs_asm.h     |  346 +
 .../arch/hwregs/iop/asm/iop_scrc_in_defs_asm.h     |  111 +
 .../arch/hwregs/iop/asm/iop_scrc_out_defs_asm.h    |  105 +
 .../arch/hwregs/iop/asm/iop_spu_defs_asm.h         |  573 ++
 .../arch/hwregs/iop/asm/iop_sw_cfg_defs_asm.h      | 1052 +++
 .../arch/hwregs/iop/asm/iop_sw_cpu_defs_asm.h      | 1758 +++++
 .../arch/hwregs/iop/asm/iop_sw_mpu_defs_asm.h      | 1776 +++++
 .../arch/hwregs/iop/asm/iop_sw_spu_defs_asm.h      |  691 ++
 .../arch/hwregs/iop/asm/iop_timer_grp_defs_asm.h   |  237 +
 .../arch/hwregs/iop/asm/iop_trigger_grp_defs_asm.h |  157 +
 .../arch/hwregs/iop/asm/iop_version_defs_asm.h     |   64 +
 .../arch-v32/arch/hwregs/iop/iop_crc_par_defs.h    |  232 +
 .../arch-v32/arch/hwregs/iop/iop_dmc_in_defs.h     |  325 +
 .../arch-v32/arch/hwregs/iop/iop_dmc_out_defs.h    |  326 +
 .../arch-v32/arch/hwregs/iop/iop_fifo_in_defs.h    |  255 +
 .../arch/hwregs/iop/iop_fifo_in_extra_defs.h       |  164 +
 .../arch-v32/arch/hwregs/iop/iop_fifo_out_defs.h   |  278 +
 .../arch/hwregs/iop/iop_fifo_out_extra_defs.h      |  164 +
 .../arch-v32/arch/hwregs/iop/iop_mpu_defs.h        |  190 +
 .../arch-v32/arch/hwregs/iop/iop_mpu_macros.h      |  764 ++
 .../arch-v32/arch/hwregs/iop/iop_reg_space.h       |   44 +
 .../arch-v32/arch/hwregs/iop/iop_sap_in_defs.h     |  179 +
 .../arch-v32/arch/hwregs/iop/iop_sap_out_defs.h    |  306 +
 .../arch-v32/arch/hwregs/iop/iop_scrc_in_defs.h    |  160 +
 .../arch-v32/arch/hwregs/iop/iop_scrc_out_defs.h   |  146 +
 .../arch-v32/arch/hwregs/iop/iop_spu_defs.h        |  453 ++
 .../arch-v32/arch/hwregs/iop/iop_sw_cfg_defs.h     | 1042 +++
 .../arch-v32/arch/hwregs/iop/iop_sw_cpu_defs.h     |  853 +++
 .../arch-v32/arch/hwregs/iop/iop_sw_mpu_defs.h     |  893 +++
 .../arch-v32/arch/hwregs/iop/iop_sw_spu_defs.h     |  552 ++
 .../arch-v32/arch/hwregs/iop/iop_timer_grp_defs.h  |  249 +
 .../arch/hwregs/iop/iop_trigger_grp_defs.h         |  170 +
 .../arch-v32/arch/hwregs/iop/iop_version_defs.h    |   99 +
 .../include/arch-v32/arch/hwregs/irq_nmi_defs.h    |  104 +
 .../include/arch-v32/arch/hwregs/marb_bp_defs.h    |  205 +
 arch/cris/include/arch-v32/arch/hwregs/marb_defs.h |  475 ++
 arch/cris/include/arch-v32/arch/hwregs/reg_rdwr.h  |   17 +
 .../include/arch-v32/arch/hwregs/rt_trace_defs.h   |  173 +
 arch/cris/include/arch-v32/arch/hwregs/ser_defs.h  |  308 +
 arch/cris/include/arch-v32/arch/hwregs/sser_defs.h |  331 +
 arch/cris/include/arch-v32/arch/hwregs/strcop.h    |   57 +
 .../include/arch-v32/arch/hwregs/strcop_defs.h     |  109 +
 arch/cris/include/arch-v32/arch/hwregs/supp_reg.h  |   78 +
 arch/cris/include/arch-v32/arch/intmem.h           |    9 +
 arch/cris/include/arch-v32/arch/io.h               |  136 +
 arch/cris/include/arch-v32/arch/irq.h              |  124 +
 arch/cris/include/arch-v32/arch/memmap.h           |   24 +
 arch/cris/include/arch-v32/arch/mmu.h              |  111 +
 arch/cris/include/arch-v32/arch/offset.h           |   35 +
 arch/cris/include/arch-v32/arch/page.h             |   27 +
 arch/cris/include/arch-v32/arch/pgtable.h          |    9 +
 arch/cris/include/arch-v32/arch/processor.h        |   59 +
 arch/cris/include/arch-v32/arch/ptrace.h           |  118 +
 arch/cris/include/arch-v32/arch/spinlock.h         |  129 +
 arch/cris/include/arch-v32/arch/system.h           |   69 +
 arch/cris/include/arch-v32/arch/thread_info.h      |   13 +
 arch/cris/include/arch-v32/arch/timex.h            |   31 +
 arch/cris/include/arch-v32/arch/tlb.h              |   14 +
 arch/cris/include/arch-v32/arch/uaccess.h          |  748 ++
 arch/cris/include/arch-v32/arch/unistd.h           |  155 +
 arch/cris/include/arch-v32/arch/user.h             |   41 +
 arch/cris/include/arch-v32/mach-a3/mach/arbiter.h  |   34 +
 arch/cris/include/arch-v32/mach-a3/mach/dma.h      |   31 +
 .../mach-a3/mach/hwregs/asm/clkgen_defs_asm.h      |  164 +
 .../mach-a3/mach/hwregs/asm/ddr2_defs_asm.h        |  266 +
 .../mach-a3/mach/hwregs/asm/gio_defs_asm.h         |  849 +++
 .../mach-a3/mach/hwregs/asm/pinmux_defs_asm.h      |  572 ++
 .../mach-a3/mach/hwregs/asm/pio_defs_asm.h         |  337 +
 .../arch-v32/mach-a3/mach/hwregs/asm/reg_map_asm.h |   99 +
 .../mach-a3/mach/hwregs/asm/timer_defs_asm.h       |  228 +
 .../arch-v32/mach-a3/mach/hwregs/clkgen_defs.h     |  159 +
 .../arch-v32/mach-a3/mach/hwregs/ddr2_defs.h       |  281 +
 .../arch-v32/mach-a3/mach/hwregs/gio_defs.h        |  837 +++
 .../arch-v32/mach-a3/mach/hwregs/intr_vect.h       |   46 +
 .../arch-v32/mach-a3/mach/hwregs/intr_vect_defs.h  |  341 +
 .../mach/hwregs/iop/asm/iop_reg_space_asm.h        |   31 +
 .../mach/hwregs/iop/asm/iop_sap_in_defs_asm.h      |  109 +
 .../mach/hwregs/iop/asm/iop_sap_out_defs_asm.h     |  276 +
 .../mach/hwregs/iop/asm/iop_sw_cfg_defs_asm.h      |  739 ++
 .../mach/hwregs/iop/asm/iop_sw_cpu_defs_asm.h      |  950 +++
 .../mach/hwregs/iop/asm/iop_sw_mpu_defs_asm.h      | 1086 +++
 .../mach/hwregs/iop/asm/iop_sw_spu_defs_asm.h      |  523 ++
 .../mach/hwregs/iop/asm/iop_version_defs_asm.h     |   61 +
 .../mach-a3/mach/hwregs/iop/iop_reg_space.h        |   31 +
 .../mach-a3/mach/hwregs/iop/iop_sap_in_defs.h      |  141 +
 .../mach-a3/mach/hwregs/iop/iop_sap_out_defs.h     |  231 +
 .../mach-a3/mach/hwregs/iop/iop_sw_cfg_defs.h      |  725 ++
 .../mach-a3/mach/hwregs/iop/iop_sw_cpu_defs.h      |  522 ++
 .../mach-a3/mach/hwregs/iop/iop_sw_mpu_defs.h      |  648 ++
 .../mach-a3/mach/hwregs/iop/iop_sw_spu_defs.h      |  441 ++
 .../mach-a3/mach/hwregs/iop/iop_version_defs.h     |   96 +
 .../arch-v32/mach-a3/mach/hwregs/l2cache_defs.h    |  142 +
 .../arch-v32/mach-a3/mach/hwregs/marb_bar_defs.h   |  482 ++
 .../arch-v32/mach-a3/mach/hwregs/marb_foo_defs.h   |  626 ++
 .../arch-v32/mach-a3/mach/hwregs/pinmux_defs.h     |  312 +
 .../arch-v32/mach-a3/mach/hwregs/pio_defs.h        |  371 +
 .../include/arch-v32/mach-a3/mach/hwregs/reg_map.h |  103 +
 .../arch-v32/mach-a3/mach/hwregs/strmux_defs.h     |  120 +
 .../arch-v32/mach-a3/mach/hwregs/timer_defs.h      |  265 +
 arch/cris/include/arch-v32/mach-a3/mach/memmap.h   |   10 +
 arch/cris/include/arch-v32/mach-a3/mach/pinmux.h   |   45 +
 .../cris/include/arch-v32/mach-a3/mach/startup.inc |   60 +
 arch/cris/include/arch-v32/mach-fs/mach/arbiter.h  |   28 +
 .../mach-fs/mach/hwregs/asm/bif_core_defs_asm.h    |  319 +
 .../mach-fs/mach/hwregs/asm/config_defs_asm.h      |  131 +
 .../mach-fs/mach/hwregs/asm/gio_defs_asm.h         |  276 +
 .../mach-fs/mach/hwregs/asm/pinmux_defs_asm.h      |  632 ++
 .../arch-v32/mach-fs/mach/hwregs/asm/reg_map_asm.h |   96 +
 .../mach-fs/mach/hwregs/asm/timer_defs_asm.h       |  229 +
 .../arch-v32/mach-fs/mach/hwregs/bif_core_defs.h   |  284 +
 .../arch-v32/mach-fs/mach/hwregs/bif_dma_defs.h    |  473 ++
 .../arch-v32/mach-fs/mach/hwregs/bif_slave_defs.h  |  249 +
 .../arch-v32/mach-fs/mach/hwregs/config_defs.h     |  142 +
 .../arch-v32/mach-fs/mach/hwregs/gio_defs.h        |  295 +
 .../arch-v32/mach-fs/mach/hwregs/intr_vect.h       |   41 +
 .../arch-v32/mach-fs/mach/hwregs/intr_vect_defs.h  |  228 +
 .../arch-v32/mach-fs/mach/hwregs/marb_bp_defs.h    |  205 +
 .../arch-v32/mach-fs/mach/hwregs/marb_defs.h       |  475 ++
 .../arch-v32/mach-fs/mach/hwregs/pinmux_defs.h     |  357 +
 .../include/arch-v32/mach-fs/mach/hwregs/reg_map.h |  104 +
 .../arch-v32/mach-fs/mach/hwregs/strmux_defs.h     |  127 +
 .../arch-v32/mach-fs/mach/hwregs/timer_defs.h      |  266 +
 arch/cris/include/arch-v32/mach-fs/mach/pinmux.h   |   38 +
 .../cris/include/arch-v32/mach-fs/mach/startup.inc |   77 +
 arch/cris/include/asm/Kbuild                       |   11 +
 arch/cris/include/asm/atomic.h                     |  164 +
 arch/cris/include/asm/auxvec.h                     |    4 +
 arch/cris/include/asm/axisflashmap.h               |   61 +
 arch/cris/include/asm/bitops.h                     |  166 +
 arch/cris/include/asm/bug.h                        |    4 +
 arch/cris/include/asm/bugs.h                       |   21 +
 arch/cris/include/asm/byteorder.h                  |   27 +
 arch/cris/include/asm/cache.h                      |    6 +
 arch/cris/include/asm/cacheflush.h                 |   31 +
 arch/cris/include/asm/checksum.h                   |   83 +
 arch/cris/include/asm/cputime.h                    |    6 +
 arch/cris/include/asm/current.h                    |   15 +
 arch/cris/include/asm/delay.h                      |   27 +
 arch/cris/include/asm/device.h                     |    7 +
 arch/cris/include/asm/div64.h                      |    1 +
 arch/cris/include/asm/dma-mapping.h                |  170 +
 arch/cris/include/asm/dma.h                        |   21 +
 arch/cris/include/asm/elf.h                        |   93 +
 arch/cris/include/asm/emergency-restart.h          |    6 +
 arch/cris/include/asm/errno.h                      |    6 +
 arch/cris/include/asm/eshlibld.h                   |  113 +
 arch/cris/include/asm/ethernet.h                   |   21 +
 arch/cris/include/asm/etraxgpio.h                  |  179 +
 arch/cris/include/asm/etraxi2c.h                   |   36 +
 arch/cris/include/asm/fasttimer.h                  |   47 +
 arch/cris/include/asm/fb.h                         |   12 +
 arch/cris/include/asm/fcntl.h                      |    1 +
 arch/cris/include/asm/futex.h                      |    6 +
 arch/cris/include/asm/hardirq.h                    |   27 +
 arch/cris/include/asm/hw_irq.h                     |    5 +
 arch/cris/include/asm/io.h                         |  154 +
 arch/cris/include/asm/ioctl.h                      |    1 +
 arch/cris/include/asm/ioctls.h                     |   91 +
 arch/cris/include/asm/ipcbuf.h                     |   29 +
 arch/cris/include/asm/irq.h                        |   13 +
 arch/cris/include/asm/irq_regs.h                   |    1 +
 arch/cris/include/asm/kdebug.h                     |    1 +
 arch/cris/include/asm/kmap_types.h                 |   25 +
 arch/cris/include/asm/linkage.h                    |    6 +
 arch/cris/include/asm/local.h                      |    1 +
 arch/cris/include/asm/mman.h                       |   19 +
 arch/cris/include/asm/mmu.h                        |   10 +
 arch/cris/include/asm/mmu_context.h                |   26 +
 arch/cris/include/asm/module.h                     |    9 +
 arch/cris/include/asm/msgbuf.h                     |   33 +
 arch/cris/include/asm/mutex.h                      |    9 +
 arch/cris/include/asm/page.h                       |   74 +
 arch/cris/include/asm/param.h                      |   23 +
 arch/cris/include/asm/pci.h                        |   68 +
 arch/cris/include/asm/percpu.h                     |    6 +
 arch/cris/include/asm/pgalloc.h                    |   58 +
 arch/cris/include/asm/pgtable.h                    |  299 +
 arch/cris/include/asm/poll.h                       |    1 +
 arch/cris/include/asm/posix_types.h                |   66 +
 arch/cris/include/asm/processor.h                  |   75 +
 arch/cris/include/asm/ptrace.h                     |   16 +
 arch/cris/include/asm/resource.h                   |    6 +
 arch/cris/include/asm/rs485.h                      |   20 +
 arch/cris/include/asm/rtc.h                        |  107 +
 arch/cris/include/asm/scatterlist.h                |   23 +
 arch/cris/include/asm/sections.h                   |    7 +
 arch/cris/include/asm/segment.h                    |    8 +
 arch/cris/include/asm/sembuf.h                     |   25 +
 arch/cris/include/asm/setup.h                      |    6 +
 arch/cris/include/asm/shmbuf.h                     |   42 +
 arch/cris/include/asm/shmparam.h                   |    8 +
 arch/cris/include/asm/sigcontext.h                 |   24 +
 arch/cris/include/asm/siginfo.h                    |    6 +
 arch/cris/include/asm/signal.h                     |  163 +
 arch/cris/include/asm/smp.h                        |   11 +
 arch/cris/include/asm/socket.h                     |   61 +
 arch/cris/include/asm/sockios.h                    |   13 +
 arch/cris/include/asm/spinlock.h                   |    1 +
 arch/cris/include/asm/stat.h                       |   81 +
 arch/cris/include/asm/statfs.h                     |    6 +
 arch/cris/include/asm/string.h                     |   14 +
 arch/cris/include/asm/sync_serial.h                |  107 +
 arch/cris/include/asm/system.h                     |   88 +
 arch/cris/include/asm/termbits.h                   |  234 +
 arch/cris/include/asm/termios.h                    |   91 +
 arch/cris/include/asm/thread_info.h                |  106 +
 arch/cris/include/asm/timex.h                      |   24 +
 arch/cris/include/asm/tlb.h                        |   19 +
 arch/cris/include/asm/tlbflush.h                   |   48 +
 arch/cris/include/asm/topology.h                   |    6 +
 arch/cris/include/asm/types.h                      |   30 +
 arch/cris/include/asm/uaccess.h                    |  404 ++
 arch/cris/include/asm/ucontext.h                   |   12 +
 arch/cris/include/asm/unaligned.h                  |   13 +
 arch/cris/include/asm/unistd.h                     |  374 +
 arch/cris/include/asm/user.h                       |   52 +
 arch/cris/mm/ioremap.c                             |    2 +-
 drivers/net/cris/eth_v10.c                         |    4 +-
 drivers/serial/crisv10.c                           |    4 +-
 drivers/serial/crisv10.h                           |    2 +-
 include/asm-cris/Kbuild                            |   11 -
 include/asm-cris/arch-v10/Kbuild                   |    4 -
 include/asm-cris/arch-v10/atomic.h                 |    7 -
 include/asm-cris/arch-v10/bitops.h                 |   73 -
 include/asm-cris/arch-v10/bug.h                    |   66 -
 include/asm-cris/arch-v10/byteorder.h              |   26 -
 include/asm-cris/arch-v10/cache.h                  |    8 -
 include/asm-cris/arch-v10/checksum.h               |   29 -
 include/asm-cris/arch-v10/delay.h                  |   20 -
 include/asm-cris/arch-v10/dma.h                    |   74 -
 include/asm-cris/arch-v10/elf.h                    |   81 -
 include/asm-cris/arch-v10/io.h                     |  199 -
 include/asm-cris/arch-v10/io_interface_mux.h       |   75 -
 include/asm-cris/arch-v10/irq.h                    |  160 -
 include/asm-cris/arch-v10/memmap.h                 |   22 -
 include/asm-cris/arch-v10/mmu.h                    |  109 -
 include/asm-cris/arch-v10/offset.h                 |   33 -
 include/asm-cris/arch-v10/page.h                   |   30 -
 include/asm-cris/arch-v10/pgtable.h                |   17 -
 include/asm-cris/arch-v10/processor.h              |   70 -
 include/asm-cris/arch-v10/ptrace.h                 |  119 -
 include/asm-cris/arch-v10/sv_addr.agh              | 7306 --------------------
 include/asm-cris/arch-v10/sv_addr_ag.h             |  139 -
 include/asm-cris/arch-v10/svinto.h                 |   64 -
 include/asm-cris/arch-v10/system.h                 |   63 -
 include/asm-cris/arch-v10/thread_info.h            |   12 -
 include/asm-cris/arch-v10/timex.h                  |   30 -
 include/asm-cris/arch-v10/tlb.h                    |   13 -
 include/asm-cris/arch-v10/uaccess.h                |  660 --
 include/asm-cris/arch-v10/unistd.h                 |  148 -
 include/asm-cris/arch-v10/user.h                   |   46 -
 include/asm-cris/arch-v32/Kbuild                   |    2 -
 include/asm-cris/arch-v32/arbiter.h                |   30 -
 include/asm-cris/arch-v32/atomic.h                 |   36 -
 include/asm-cris/arch-v32/bitops.h                 |   64 -
 include/asm-cris/arch-v32/bug.h                    |   33 -
 include/asm-cris/arch-v32/byteorder.h              |   20 -
 include/asm-cris/arch-v32/cache.h                  |   19 -
 include/asm-cris/arch-v32/checksum.h               |   29 -
 include/asm-cris/arch-v32/cryptocop.h              |  272 -
 include/asm-cris/arch-v32/delay.h                  |   28 -
 include/asm-cris/arch-v32/dma.h                    |   79 -
 include/asm-cris/arch-v32/elf.h                    |   73 -
 include/asm-cris/arch-v32/hwregs/Makefile          |  186 -
 .../asm-cris/arch-v32/hwregs/asm/ata_defs_asm.h    |  222 -
 .../arch-v32/hwregs/asm/bif_core_defs_asm.h        |  319 -
 .../arch-v32/hwregs/asm/bif_dma_defs_asm.h         |  495 --
 .../arch-v32/hwregs/asm/bif_slave_defs_asm.h       |  249 -
 .../asm-cris/arch-v32/hwregs/asm/config_defs_asm.h |  131 -
 include/asm-cris/arch-v32/hwregs/asm/cpu_vect.h    |   41 -
 .../asm-cris/arch-v32/hwregs/asm/cris_defs_asm.h   |  114 -
 .../asm-cris/arch-v32/hwregs/asm/cris_supp_reg.h   |   10 -
 .../asm-cris/arch-v32/hwregs/asm/dma_defs_asm.h    |  368 -
 .../asm-cris/arch-v32/hwregs/asm/eth_defs_asm.h    |  498 --
 .../asm-cris/arch-v32/hwregs/asm/gio_defs_asm.h    |  276 -
 include/asm-cris/arch-v32/hwregs/asm/intr_vect.h   |   38 -
 .../arch-v32/hwregs/asm/intr_vect_defs_asm.h       |  355 -
 .../arch-v32/hwregs/asm/irq_nmi_defs_asm.h         |   69 -
 .../asm-cris/arch-v32/hwregs/asm/marb_defs_asm.h   |  579 --
 .../asm-cris/arch-v32/hwregs/asm/mmu_defs_asm.h    |  212 -
 .../asm-cris/arch-v32/hwregs/asm/mmu_supp_reg.h    |    7 -
 .../asm-cris/arch-v32/hwregs/asm/pinmux_defs_asm.h |  632 --
 include/asm-cris/arch-v32/hwregs/asm/reg_map_asm.h |   96 -
 .../arch-v32/hwregs/asm/rt_trace_defs_asm.h        |  142 -
 .../asm-cris/arch-v32/hwregs/asm/ser_defs_asm.h    |  359 -
 .../asm-cris/arch-v32/hwregs/asm/sser_defs_asm.h   |  462 --
 .../asm-cris/arch-v32/hwregs/asm/strcop_defs_asm.h |   84 -
 .../asm-cris/arch-v32/hwregs/asm/strmux_defs_asm.h |  100 -
 .../asm-cris/arch-v32/hwregs/asm/timer_defs_asm.h  |  229 -
 include/asm-cris/arch-v32/hwregs/ata_defs.h        |  222 -
 include/asm-cris/arch-v32/hwregs/bif_core_defs.h   |  284 -
 include/asm-cris/arch-v32/hwregs/bif_dma_defs.h    |  473 --
 include/asm-cris/arch-v32/hwregs/bif_slave_defs.h  |  249 -
 include/asm-cris/arch-v32/hwregs/config_defs.h     |  142 -
 include/asm-cris/arch-v32/hwregs/cpu_vect.h        |   41 -
 include/asm-cris/arch-v32/hwregs/dma.h             |  127 -
 include/asm-cris/arch-v32/hwregs/dma_defs.h        |  436 --
 include/asm-cris/arch-v32/hwregs/eth_defs.h        |  378 -
 include/asm-cris/arch-v32/hwregs/extmem_defs.h     |  369 -
 include/asm-cris/arch-v32/hwregs/gio_defs.h        |  295 -
 include/asm-cris/arch-v32/hwregs/intr_vect.h       |   39 -
 include/asm-cris/arch-v32/hwregs/iop/Makefile      |  146 -
 .../arch-v32/hwregs/iop/asm/iop_crc_par_defs_asm.h |  171 -
 .../arch-v32/hwregs/iop/asm/iop_dmc_in_defs_asm.h  |  321 -
 .../arch-v32/hwregs/iop/asm/iop_dmc_out_defs_asm.h |  349 -
 .../arch-v32/hwregs/iop/asm/iop_fifo_in_defs_asm.h |  234 -
 .../hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h    |  155 -
 .../hwregs/iop/asm/iop_fifo_out_defs_asm.h         |  254 -
 .../hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h   |  158 -
 .../arch-v32/hwregs/iop/asm/iop_mpu_defs_asm.h     |  177 -
 .../arch-v32/hwregs/iop/asm/iop_reg_space_asm.h    |   44 -
 .../arch-v32/hwregs/iop/asm/iop_sap_in_defs_asm.h  |  182 -
 .../arch-v32/hwregs/iop/asm/iop_sap_out_defs_asm.h |  346 -
 .../arch-v32/hwregs/iop/asm/iop_scrc_in_defs_asm.h |  111 -
 .../hwregs/iop/asm/iop_scrc_out_defs_asm.h         |  105 -
 .../arch-v32/hwregs/iop/asm/iop_spu_defs_asm.h     |  573 --
 .../arch-v32/hwregs/iop/asm/iop_sw_cfg_defs_asm.h  | 1052 ---
 .../arch-v32/hwregs/iop/asm/iop_sw_cpu_defs_asm.h  | 1758 -----
 .../arch-v32/hwregs/iop/asm/iop_sw_mpu_defs_asm.h  | 1776 -----
 .../arch-v32/hwregs/iop/asm/iop_sw_spu_defs_asm.h  |  691 --
 .../hwregs/iop/asm/iop_timer_grp_defs_asm.h        |  237 -
 .../hwregs/iop/asm/iop_trigger_grp_defs_asm.h      |  157 -
 .../arch-v32/hwregs/iop/asm/iop_version_defs_asm.h |   64 -
 .../arch-v32/hwregs/iop/iop_crc_par_defs.h         |  232 -
 .../asm-cris/arch-v32/hwregs/iop/iop_dmc_in_defs.h |  325 -
 .../arch-v32/hwregs/iop/iop_dmc_out_defs.h         |  326 -
 .../arch-v32/hwregs/iop/iop_fifo_in_defs.h         |  255 -
 .../arch-v32/hwregs/iop/iop_fifo_in_extra_defs.h   |  164 -
 .../arch-v32/hwregs/iop/iop_fifo_out_defs.h        |  278 -
 .../arch-v32/hwregs/iop/iop_fifo_out_extra_defs.h  |  164 -
 .../asm-cris/arch-v32/hwregs/iop/iop_mpu_defs.h    |  190 -
 .../asm-cris/arch-v32/hwregs/iop/iop_mpu_macros.h  |  764 --
 .../asm-cris/arch-v32/hwregs/iop/iop_reg_space.h   |   44 -
 .../asm-cris/arch-v32/hwregs/iop/iop_sap_in_defs.h |  179 -
 .../arch-v32/hwregs/iop/iop_sap_out_defs.h         |  306 -
 .../arch-v32/hwregs/iop/iop_scrc_in_defs.h         |  160 -
 .../arch-v32/hwregs/iop/iop_scrc_out_defs.h        |  146 -
 .../asm-cris/arch-v32/hwregs/iop/iop_spu_defs.h    |  453 --
 .../asm-cris/arch-v32/hwregs/iop/iop_sw_cfg_defs.h | 1042 ---
 .../asm-cris/arch-v32/hwregs/iop/iop_sw_cpu_defs.h |  853 ---
 .../asm-cris/arch-v32/hwregs/iop/iop_sw_mpu_defs.h |  893 ---
 .../asm-cris/arch-v32/hwregs/iop/iop_sw_spu_defs.h |  552 --
 .../arch-v32/hwregs/iop/iop_timer_grp_defs.h       |  249 -
 .../arch-v32/hwregs/iop/iop_trigger_grp_defs.h     |  170 -
 .../arch-v32/hwregs/iop/iop_version_defs.h         |   99 -
 include/asm-cris/arch-v32/hwregs/irq_nmi_defs.h    |  104 -
 include/asm-cris/arch-v32/hwregs/marb_bp_defs.h    |  205 -
 include/asm-cris/arch-v32/hwregs/marb_defs.h       |  475 --
 include/asm-cris/arch-v32/hwregs/pinmux_defs.h     |  357 -
 include/asm-cris/arch-v32/hwregs/reg_rdwr.h        |   17 -
 include/asm-cris/arch-v32/hwregs/rt_trace_defs.h   |  173 -
 include/asm-cris/arch-v32/hwregs/ser_defs.h        |  308 -
 include/asm-cris/arch-v32/hwregs/sser_defs.h       |  331 -
 include/asm-cris/arch-v32/hwregs/strcop.h          |   57 -
 include/asm-cris/arch-v32/hwregs/strcop_defs.h     |  109 -
 include/asm-cris/arch-v32/hwregs/strmux_defs.h     |  127 -
 include/asm-cris/arch-v32/hwregs/supp_reg.h        |   78 -
 include/asm-cris/arch-v32/intmem.h                 |    9 -
 include/asm-cris/arch-v32/io.h                     |  136 -
 include/asm-cris/arch-v32/irq.h                    |  124 -
 include/asm-cris/arch-v32/mach-a3/arbiter.h        |   34 -
 include/asm-cris/arch-v32/mach-a3/dma.h            |   31 -
 .../arch-v32/mach-a3/hwregs/asm/clkgen_defs_asm.h  |  164 -
 .../arch-v32/mach-a3/hwregs/asm/ddr2_defs_asm.h    |  266 -
 .../arch-v32/mach-a3/hwregs/asm/gio_defs_asm.h     |  849 ---
 .../arch-v32/mach-a3/hwregs/asm/pinmux_defs_asm.h  |  572 --
 .../arch-v32/mach-a3/hwregs/asm/pio_defs_asm.h     |  337 -
 .../arch-v32/mach-a3/hwregs/asm/reg_map_asm.h      |   99 -
 .../arch-v32/mach-a3/hwregs/asm/timer_defs_asm.h   |  228 -
 .../asm-cris/arch-v32/mach-a3/hwregs/clkgen_defs.h |  159 -
 .../asm-cris/arch-v32/mach-a3/hwregs/ddr2_defs.h   |  281 -
 .../asm-cris/arch-v32/mach-a3/hwregs/gio_defs.h    |  837 ---
 .../asm-cris/arch-v32/mach-a3/hwregs/intr_vect.h   |   46 -
 .../arch-v32/mach-a3/hwregs/intr_vect_defs.h       |  341 -
 .../mach-a3/hwregs/iop/asm/iop_reg_space_asm.h     |   31 -
 .../mach-a3/hwregs/iop/asm/iop_sap_in_defs_asm.h   |  109 -
 .../mach-a3/hwregs/iop/asm/iop_sap_out_defs_asm.h  |  276 -
 .../mach-a3/hwregs/iop/asm/iop_sw_cfg_defs_asm.h   |  739 --
 .../mach-a3/hwregs/iop/asm/iop_sw_cpu_defs_asm.h   |  950 ---
 .../mach-a3/hwregs/iop/asm/iop_sw_mpu_defs_asm.h   | 1086 ---
 .../mach-a3/hwregs/iop/asm/iop_sw_spu_defs_asm.h   |  523 --
 .../mach-a3/hwregs/iop/asm/iop_version_defs_asm.h  |   61 -
 .../arch-v32/mach-a3/hwregs/iop/iop_reg_space.h    |   31 -
 .../arch-v32/mach-a3/hwregs/iop/iop_sap_in_defs.h  |  141 -
 .../arch-v32/mach-a3/hwregs/iop/iop_sap_out_defs.h |  231 -
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_cfg_defs.h  |  725 --
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_cpu_defs.h  |  522 --
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_mpu_defs.h  |  648 --
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_spu_defs.h  |  441 --
 .../arch-v32/mach-a3/hwregs/iop/iop_version_defs.h |   96 -
 .../arch-v32/mach-a3/hwregs/l2cache_defs.h         |  142 -
 .../arch-v32/mach-a3/hwregs/marb_bar_defs.h        |  482 --
 .../arch-v32/mach-a3/hwregs/marb_foo_defs.h        |  626 --
 .../asm-cris/arch-v32/mach-a3/hwregs/pinmux_defs.h |  312 -
 .../asm-cris/arch-v32/mach-a3/hwregs/pio_defs.h    |  371 -
 include/asm-cris/arch-v32/mach-a3/hwregs/reg_map.h |  103 -
 .../asm-cris/arch-v32/mach-a3/hwregs/strmux_defs.h |  120 -
 .../asm-cris/arch-v32/mach-a3/hwregs/timer_defs.h  |  265 -
 include/asm-cris/arch-v32/mach-a3/memmap.h         |   10 -
 include/asm-cris/arch-v32/mach-a3/pinmux.h         |   45 -
 include/asm-cris/arch-v32/mach-a3/startup.inc      |   60 -
 include/asm-cris/arch-v32/mach-fs/arbiter.h        |   28 -
 .../mach-fs/hwregs/asm/bif_core_defs_asm.h         |  319 -
 .../arch-v32/mach-fs/hwregs/asm/config_defs_asm.h  |  131 -
 .../arch-v32/mach-fs/hwregs/asm/gio_defs_asm.h     |  276 -
 .../arch-v32/mach-fs/hwregs/asm/pinmux_defs_asm.h  |  632 --
 .../arch-v32/mach-fs/hwregs/asm/reg_map_asm.h      |   96 -
 .../arch-v32/mach-fs/hwregs/asm/timer_defs_asm.h   |  229 -
 .../arch-v32/mach-fs/hwregs/bif_core_defs.h        |  284 -
 .../arch-v32/mach-fs/hwregs/bif_dma_defs.h         |  473 --
 .../arch-v32/mach-fs/hwregs/bif_slave_defs.h       |  249 -
 .../asm-cris/arch-v32/mach-fs/hwregs/config_defs.h |  142 -
 .../asm-cris/arch-v32/mach-fs/hwregs/gio_defs.h    |  295 -
 .../asm-cris/arch-v32/mach-fs/hwregs/intr_vect.h   |   41 -
 .../arch-v32/mach-fs/hwregs/intr_vect_defs.h       |  228 -
 .../arch-v32/mach-fs/hwregs/marb_bp_defs.h         |  205 -
 .../asm-cris/arch-v32/mach-fs/hwregs/marb_defs.h   |  475 --
 .../asm-cris/arch-v32/mach-fs/hwregs/pinmux_defs.h |  357 -
 include/asm-cris/arch-v32/mach-fs/hwregs/reg_map.h |  104 -
 .../asm-cris/arch-v32/mach-fs/hwregs/strmux_defs.h |  127 -
 .../asm-cris/arch-v32/mach-fs/hwregs/timer_defs.h  |  266 -
 include/asm-cris/arch-v32/mach-fs/pinmux.h         |   38 -
 include/asm-cris/arch-v32/mach-fs/startup.inc      |   77 -
 include/asm-cris/arch-v32/memmap.h                 |   24 -
 include/asm-cris/arch-v32/mmu.h                    |  111 -
 include/asm-cris/arch-v32/offset.h                 |   35 -
 include/asm-cris/arch-v32/page.h                   |   27 -
 include/asm-cris/arch-v32/pgtable.h                |    9 -
 include/asm-cris/arch-v32/pinmux.h                 |   40 -
 include/asm-cris/arch-v32/processor.h              |   59 -
 include/asm-cris/arch-v32/ptrace.h                 |  118 -
 include/asm-cris/arch-v32/spinlock.h               |  129 -
 include/asm-cris/arch-v32/system.h                 |   69 -
 include/asm-cris/arch-v32/thread_info.h            |   13 -
 include/asm-cris/arch-v32/timex.h                  |   31 -
 include/asm-cris/arch-v32/tlb.h                    |   14 -
 include/asm-cris/arch-v32/uaccess.h                |  748 --
 include/asm-cris/arch-v32/unistd.h                 |  155 -
 include/asm-cris/arch-v32/user.h                   |   41 -
 include/asm-cris/atomic.h                          |  164 -
 include/asm-cris/auxvec.h                          |    4 -
 include/asm-cris/axisflashmap.h                    |   61 -
 include/asm-cris/bitops.h                          |  166 -
 include/asm-cris/bug.h                             |    4 -
 include/asm-cris/bugs.h                            |   21 -
 include/asm-cris/byteorder.h                       |   27 -
 include/asm-cris/cache.h                           |    6 -
 include/asm-cris/cacheflush.h                      |   31 -
 include/asm-cris/checksum.h                        |   83 -
 include/asm-cris/cputime.h                         |    6 -
 include/asm-cris/current.h                         |   15 -
 include/asm-cris/delay.h                           |   27 -
 include/asm-cris/device.h                          |    7 -
 include/asm-cris/div64.h                           |    1 -
 include/asm-cris/dma-mapping.h                     |  170 -
 include/asm-cris/dma.h                             |   21 -
 include/asm-cris/elf.h                             |   93 -
 include/asm-cris/emergency-restart.h               |    6 -
 include/asm-cris/errno.h                           |    6 -
 include/asm-cris/eshlibld.h                        |  113 -
 include/asm-cris/ethernet.h                        |   21 -
 include/asm-cris/etraxgpio.h                       |  179 -
 include/asm-cris/etraxi2c.h                        |   36 -
 include/asm-cris/fasttimer.h                       |   47 -
 include/asm-cris/fb.h                              |   12 -
 include/asm-cris/fcntl.h                           |    1 -
 include/asm-cris/futex.h                           |    6 -
 include/asm-cris/hardirq.h                         |   27 -
 include/asm-cris/hw_irq.h                          |    5 -
 include/asm-cris/io.h                              |  154 -
 include/asm-cris/ioctl.h                           |    1 -
 include/asm-cris/ioctls.h                          |   91 -
 include/asm-cris/ipcbuf.h                          |   29 -
 include/asm-cris/irq.h                             |   13 -
 include/asm-cris/irq_regs.h                        |    1 -
 include/asm-cris/kdebug.h                          |    1 -
 include/asm-cris/kmap_types.h                      |   25 -
 include/asm-cris/linkage.h                         |    6 -
 include/asm-cris/local.h                           |    1 -
 include/asm-cris/mman.h                            |   19 -
 include/asm-cris/mmu.h                             |   10 -
 include/asm-cris/mmu_context.h                     |   26 -
 include/asm-cris/module.h                          |    9 -
 include/asm-cris/msgbuf.h                          |   33 -
 include/asm-cris/mutex.h                           |    9 -
 include/asm-cris/page.h                            |   74 -
 include/asm-cris/param.h                           |   23 -
 include/asm-cris/pci.h                             |   68 -
 include/asm-cris/percpu.h                          |    6 -
 include/asm-cris/pgalloc.h                         |   58 -
 include/asm-cris/pgtable.h                         |  299 -
 include/asm-cris/poll.h                            |    1 -
 include/asm-cris/posix_types.h                     |   66 -
 include/asm-cris/processor.h                       |   75 -
 include/asm-cris/ptrace.h                          |   16 -
 include/asm-cris/resource.h                        |    6 -
 include/asm-cris/rs485.h                           |   20 -
 include/asm-cris/rtc.h                             |  107 -
 include/asm-cris/scatterlist.h                     |   23 -
 include/asm-cris/sections.h                        |    7 -
 include/asm-cris/segment.h                         |    8 -
 include/asm-cris/sembuf.h                          |   25 -
 include/asm-cris/setup.h                           |    6 -
 include/asm-cris/shmbuf.h                          |   42 -
 include/asm-cris/shmparam.h                        |    8 -
 include/asm-cris/sigcontext.h                      |   24 -
 include/asm-cris/siginfo.h                         |    6 -
 include/asm-cris/signal.h                          |  163 -
 include/asm-cris/smp.h                             |   11 -
 include/asm-cris/socket.h                          |   61 -
 include/asm-cris/sockios.h                         |   13 -
 include/asm-cris/spinlock.h                        |    1 -
 include/asm-cris/stat.h                            |   81 -
 include/asm-cris/statfs.h                          |    6 -
 include/asm-cris/string.h                          |   14 -
 include/asm-cris/sync_serial.h                     |  107 -
 include/asm-cris/system.h                          |   88 -
 include/asm-cris/termbits.h                        |  234 -
 include/asm-cris/termios.h                         |   91 -
 include/asm-cris/thread_info.h                     |  106 -
 include/asm-cris/timex.h                           |   24 -
 include/asm-cris/tlb.h                             |   19 -
 include/asm-cris/tlbflush.h                        |   48 -
 include/asm-cris/topology.h                        |    6 -
 include/asm-cris/types.h                           |   30 -
 include/asm-cris/uaccess.h                         |  404 --
 include/asm-cris/ucontext.h                        |   12 -
 include/asm-cris/unaligned.h                       |   13 -
 include/asm-cris/unistd.h                          |  374 -
 include/asm-cris/user.h                            |   52 -
 666 files changed, 62525 insertions(+), 64147 deletions(-)
 create mode 100644 arch/cris/arch-v10/boot/.gitignore
 create mode 100644 arch/cris/include/arch-v10/arch/Kbuild
 create mode 100644 arch/cris/include/arch-v10/arch/atomic.h
 create mode 100644 arch/cris/include/arch-v10/arch/bitops.h
 create mode 100644 arch/cris/include/arch-v10/arch/bug.h
 create mode 100644 arch/cris/include/arch-v10/arch/byteorder.h
 create mode 100644 arch/cris/include/arch-v10/arch/cache.h
 create mode 100644 arch/cris/include/arch-v10/arch/checksum.h
 create mode 100644 arch/cris/include/arch-v10/arch/delay.h
 create mode 100644 arch/cris/include/arch-v10/arch/dma.h
 create mode 100644 arch/cris/include/arch-v10/arch/elf.h
 create mode 100644 arch/cris/include/arch-v10/arch/io.h
 create mode 100644 arch/cris/include/arch-v10/arch/io_interface_mux.h
 create mode 100644 arch/cris/include/arch-v10/arch/irq.h
 create mode 100644 arch/cris/include/arch-v10/arch/memmap.h
 create mode 100644 arch/cris/include/arch-v10/arch/mmu.h
 create mode 100644 arch/cris/include/arch-v10/arch/offset.h
 create mode 100644 arch/cris/include/arch-v10/arch/page.h
 create mode 100644 arch/cris/include/arch-v10/arch/pgtable.h
 create mode 100644 arch/cris/include/arch-v10/arch/processor.h
 create mode 100644 arch/cris/include/arch-v10/arch/ptrace.h
 create mode 100644 arch/cris/include/arch-v10/arch/sv_addr.agh
 create mode 100644 arch/cris/include/arch-v10/arch/sv_addr_ag.h
 create mode 100644 arch/cris/include/arch-v10/arch/svinto.h
 create mode 100644 arch/cris/include/arch-v10/arch/system.h
 create mode 100644 arch/cris/include/arch-v10/arch/thread_info.h
 create mode 100644 arch/cris/include/arch-v10/arch/timex.h
 create mode 100644 arch/cris/include/arch-v10/arch/tlb.h
 create mode 100644 arch/cris/include/arch-v10/arch/uaccess.h
 create mode 100644 arch/cris/include/arch-v10/arch/unistd.h
 create mode 100644 arch/cris/include/arch-v10/arch/user.h
 create mode 100644 arch/cris/include/arch-v32/arch/Kbuild
 create mode 100644 arch/cris/include/arch-v32/arch/atomic.h
 create mode 100644 arch/cris/include/arch-v32/arch/bitops.h
 create mode 100644 arch/cris/include/arch-v32/arch/bug.h
 create mode 100644 arch/cris/include/arch-v32/arch/byteorder.h
 create mode 100644 arch/cris/include/arch-v32/arch/cache.h
 create mode 100644 arch/cris/include/arch-v32/arch/checksum.h
 create mode 100644 arch/cris/include/arch-v32/arch/cryptocop.h
 create mode 100644 arch/cris/include/arch-v32/arch/delay.h
 create mode 100644 arch/cris/include/arch-v32/arch/dma.h
 create mode 100644 arch/cris/include/arch-v32/arch/elf.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/Makefile
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/ata_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/bif_core_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/bif_dma_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/bif_slave_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/config_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/cpu_vect.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/cris_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/cris_supp_reg.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/dma_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/eth_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/gio_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/intr_vect.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/intr_vect_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/irq_nmi_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/marb_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/mmu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/mmu_supp_reg.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/rt_trace_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/ser_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/sser_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/strcop_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/strmux_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/asm/timer_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/ata_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/bif_core_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/bif_dma_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/bif_slave_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/config_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/cpu_vect.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/dma.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/dma_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/eth_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/extmem_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/Makefile
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_crc_par_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_dmc_in_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_dmc_out_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_fifo_in_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_fifo_out_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_mpu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_reg_space_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sap_in_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sap_out_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_scrc_in_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_scrc_out_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_spu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sw_cfg_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sw_cpu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sw_mpu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_sw_spu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_timer_grp_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_trigger_grp_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/asm/iop_version_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_crc_par_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_dmc_in_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_dmc_out_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_fifo_in_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_fifo_in_extra_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_fifo_out_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_fifo_out_extra_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_mpu_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_mpu_macros.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_reg_space.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sap_in_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sap_out_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_scrc_in_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_scrc_out_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_spu_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sw_cfg_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sw_cpu_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sw_mpu_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_sw_spu_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_timer_grp_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_trigger_grp_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/iop/iop_version_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/irq_nmi_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/marb_bp_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/marb_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/reg_rdwr.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/rt_trace_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/ser_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/sser_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/strcop.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/strcop_defs.h
 create mode 100644 arch/cris/include/arch-v32/arch/hwregs/supp_reg.h
 create mode 100644 arch/cris/include/arch-v32/arch/intmem.h
 create mode 100644 arch/cris/include/arch-v32/arch/io.h
 create mode 100644 arch/cris/include/arch-v32/arch/irq.h
 create mode 100644 arch/cris/include/arch-v32/arch/memmap.h
 create mode 100644 arch/cris/include/arch-v32/arch/mmu.h
 create mode 100644 arch/cris/include/arch-v32/arch/offset.h
 create mode 100644 arch/cris/include/arch-v32/arch/page.h
 create mode 100644 arch/cris/include/arch-v32/arch/pgtable.h
 create mode 100644 arch/cris/include/arch-v32/arch/processor.h
 create mode 100644 arch/cris/include/arch-v32/arch/ptrace.h
 create mode 100644 arch/cris/include/arch-v32/arch/spinlock.h
 create mode 100644 arch/cris/include/arch-v32/arch/system.h
 create mode 100644 arch/cris/include/arch-v32/arch/thread_info.h
 create mode 100644 arch/cris/include/arch-v32/arch/timex.h
 create mode 100644 arch/cris/include/arch-v32/arch/tlb.h
 create mode 100644 arch/cris/include/arch-v32/arch/uaccess.h
 create mode 100644 arch/cris/include/arch-v32/arch/unistd.h
 create mode 100644 arch/cris/include/arch-v32/arch/user.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/arbiter.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/dma.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/clkgen_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/ddr2_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/gio_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/pinmux_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/pio_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/reg_map_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/asm/timer_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/clkgen_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/ddr2_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/gio_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/intr_vect.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/intr_vect_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_reg_space_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sap_in_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sap_out_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sw_cfg_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sw_cpu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sw_mpu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_sw_spu_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/asm/iop_version_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_reg_space.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sap_in_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sap_out_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sw_cfg_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sw_cpu_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sw_mpu_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_sw_spu_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/iop/iop_version_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/l2cache_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/marb_bar_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/marb_foo_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/pinmux_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/pio_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/reg_map.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/strmux_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/hwregs/timer_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/memmap.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/pinmux.h
 create mode 100644 arch/cris/include/arch-v32/mach-a3/mach/startup.inc
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/arbiter.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/bif_core_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/config_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/gio_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/pinmux_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/reg_map_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/asm/timer_defs_asm.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/bif_core_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/bif_dma_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/bif_slave_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/config_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/gio_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/intr_vect.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/intr_vect_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/marb_bp_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/marb_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/pinmux_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/reg_map.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/strmux_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/hwregs/timer_defs.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/pinmux.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/startup.inc
 create mode 100644 arch/cris/include/asm/Kbuild
 create mode 100644 arch/cris/include/asm/atomic.h
 create mode 100644 arch/cris/include/asm/auxvec.h
 create mode 100644 arch/cris/include/asm/axisflashmap.h
 create mode 100644 arch/cris/include/asm/bitops.h
 create mode 100644 arch/cris/include/asm/bug.h
 create mode 100644 arch/cris/include/asm/bugs.h
 create mode 100644 arch/cris/include/asm/byteorder.h
 create mode 100644 arch/cris/include/asm/cache.h
 create mode 100644 arch/cris/include/asm/cacheflush.h
 create mode 100644 arch/cris/include/asm/checksum.h
 create mode 100644 arch/cris/include/asm/cputime.h
 create mode 100644 arch/cris/include/asm/current.h
 create mode 100644 arch/cris/include/asm/delay.h
 create mode 100644 arch/cris/include/asm/device.h
 create mode 100644 arch/cris/include/asm/div64.h
 create mode 100644 arch/cris/include/asm/dma-mapping.h
 create mode 100644 arch/cris/include/asm/dma.h
 create mode 100644 arch/cris/include/asm/elf.h
 create mode 100644 arch/cris/include/asm/emergency-restart.h
 create mode 100644 arch/cris/include/asm/errno.h
 create mode 100644 arch/cris/include/asm/eshlibld.h
 create mode 100644 arch/cris/include/asm/ethernet.h
 create mode 100644 arch/cris/include/asm/etraxgpio.h
 create mode 100644 arch/cris/include/asm/etraxi2c.h
 create mode 100644 arch/cris/include/asm/fasttimer.h
 create mode 100644 arch/cris/include/asm/fb.h
 create mode 100644 arch/cris/include/asm/fcntl.h
 create mode 100644 arch/cris/include/asm/futex.h
 create mode 100644 arch/cris/include/asm/hardirq.h
 create mode 100644 arch/cris/include/asm/hw_irq.h
 create mode 100644 arch/cris/include/asm/io.h
 create mode 100644 arch/cris/include/asm/ioctl.h
 create mode 100644 arch/cris/include/asm/ioctls.h
 create mode 100644 arch/cris/include/asm/ipcbuf.h
 create mode 100644 arch/cris/include/asm/irq.h
 create mode 100644 arch/cris/include/asm/irq_regs.h
 create mode 100644 arch/cris/include/asm/kdebug.h
 create mode 100644 arch/cris/include/asm/kmap_types.h
 create mode 100644 arch/cris/include/asm/linkage.h
 create mode 100644 arch/cris/include/asm/local.h
 create mode 100644 arch/cris/include/asm/mman.h
 create mode 100644 arch/cris/include/asm/mmu.h
 create mode 100644 arch/cris/include/asm/mmu_context.h
 create mode 100644 arch/cris/include/asm/module.h
 create mode 100644 arch/cris/include/asm/msgbuf.h
 create mode 100644 arch/cris/include/asm/mutex.h
 create mode 100644 arch/cris/include/asm/page.h
 create mode 100644 arch/cris/include/asm/param.h
 create mode 100644 arch/cris/include/asm/pci.h
 create mode 100644 arch/cris/include/asm/percpu.h
 create mode 100644 arch/cris/include/asm/pgalloc.h
 create mode 100644 arch/cris/include/asm/pgtable.h
 create mode 100644 arch/cris/include/asm/poll.h
 create mode 100644 arch/cris/include/asm/posix_types.h
 create mode 100644 arch/cris/include/asm/processor.h
 create mode 100644 arch/cris/include/asm/ptrace.h
 create mode 100644 arch/cris/include/asm/resource.h
 create mode 100644 arch/cris/include/asm/rs485.h
 create mode 100644 arch/cris/include/asm/rtc.h
 create mode 100644 arch/cris/include/asm/scatterlist.h
 create mode 100644 arch/cris/include/asm/sections.h
 create mode 100644 arch/cris/include/asm/segment.h
 create mode 100644 arch/cris/include/asm/sembuf.h
 create mode 100644 arch/cris/include/asm/setup.h
 create mode 100644 arch/cris/include/asm/shmbuf.h
 create mode 100644 arch/cris/include/asm/shmparam.h
 create mode 100644 arch/cris/include/asm/sigcontext.h
 create mode 100644 arch/cris/include/asm/siginfo.h
 create mode 100644 arch/cris/include/asm/signal.h
 create mode 100644 arch/cris/include/asm/smp.h
 create mode 100644 arch/cris/include/asm/socket.h
 create mode 100644 arch/cris/include/asm/sockios.h
 create mode 100644 arch/cris/include/asm/spinlock.h
 create mode 100644 arch/cris/include/asm/stat.h
 create mode 100644 arch/cris/include/asm/statfs.h
 create mode 100644 arch/cris/include/asm/string.h
 create mode 100644 arch/cris/include/asm/sync_serial.h
 create mode 100644 arch/cris/include/asm/system.h
 create mode 100644 arch/cris/include/asm/termbits.h
 create mode 100644 arch/cris/include/asm/termios.h
 create mode 100644 arch/cris/include/asm/thread_info.h
 create mode 100644 arch/cris/include/asm/timex.h
 create mode 100644 arch/cris/include/asm/tlb.h
 create mode 100644 arch/cris/include/asm/tlbflush.h
 create mode 100644 arch/cris/include/asm/topology.h
 create mode 100644 arch/cris/include/asm/types.h
 create mode 100644 arch/cris/include/asm/uaccess.h
 create mode 100644 arch/cris/include/asm/ucontext.h
 create mode 100644 arch/cris/include/asm/unaligned.h
 create mode 100644 arch/cris/include/asm/unistd.h
 create mode 100644 arch/cris/include/asm/user.h
 delete mode 100644 include/asm-cris/Kbuild
 delete mode 100644 include/asm-cris/arch-v10/Kbuild
 delete mode 100644 include/asm-cris/arch-v10/atomic.h
 delete mode 100644 include/asm-cris/arch-v10/bitops.h
 delete mode 100644 include/asm-cris/arch-v10/bug.h
 delete mode 100644 include/asm-cris/arch-v10/byteorder.h
 delete mode 100644 include/asm-cris/arch-v10/cache.h
 delete mode 100644 include/asm-cris/arch-v10/checksum.h
 delete mode 100644 include/asm-cris/arch-v10/delay.h
 delete mode 100644 include/asm-cris/arch-v10/dma.h
 delete mode 100644 include/asm-cris/arch-v10/elf.h
 delete mode 100644 include/asm-cris/arch-v10/io.h
 delete mode 100644 include/asm-cris/arch-v10/io_interface_mux.h
 delete mode 100644 include/asm-cris/arch-v10/irq.h
 delete mode 100644 include/asm-cris/arch-v10/memmap.h
 delete mode 100644 include/asm-cris/arch-v10/mmu.h
 delete mode 100644 include/asm-cris/arch-v10/offset.h
 delete mode 100644 include/asm-cris/arch-v10/page.h
 delete mode 100644 include/asm-cris/arch-v10/pgtable.h
 delete mode 100644 include/asm-cris/arch-v10/processor.h
 delete mode 100644 include/asm-cris/arch-v10/ptrace.h
 delete mode 100644 include/asm-cris/arch-v10/sv_addr.agh
 delete mode 100644 include/asm-cris/arch-v10/sv_addr_ag.h
 delete mode 100644 include/asm-cris/arch-v10/svinto.h
 delete mode 100644 include/asm-cris/arch-v10/system.h
 delete mode 100644 include/asm-cris/arch-v10/thread_info.h
 delete mode 100644 include/asm-cris/arch-v10/timex.h
 delete mode 100644 include/asm-cris/arch-v10/tlb.h
 delete mode 100644 include/asm-cris/arch-v10/uaccess.h
 delete mode 100644 include/asm-cris/arch-v10/unistd.h
 delete mode 100644 include/asm-cris/arch-v10/user.h
 delete mode 100644 include/asm-cris/arch-v32/Kbuild
 delete mode 100644 include/asm-cris/arch-v32/arbiter.h
 delete mode 100644 include/asm-cris/arch-v32/atomic.h
 delete mode 100644 include/asm-cris/arch-v32/bitops.h
 delete mode 100644 include/asm-cris/arch-v32/bug.h
 delete mode 100644 include/asm-cris/arch-v32/byteorder.h
 delete mode 100644 include/asm-cris/arch-v32/cache.h
 delete mode 100644 include/asm-cris/arch-v32/checksum.h
 delete mode 100644 include/asm-cris/arch-v32/cryptocop.h
 delete mode 100644 include/asm-cris/arch-v32/delay.h
 delete mode 100644 include/asm-cris/arch-v32/dma.h
 delete mode 100644 include/asm-cris/arch-v32/elf.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/Makefile
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/ata_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/bif_core_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/bif_dma_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/bif_slave_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/config_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/cpu_vect.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/cris_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/cris_supp_reg.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/dma_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/eth_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/gio_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/intr_vect.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/intr_vect_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/irq_nmi_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/marb_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/mmu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/mmu_supp_reg.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/pinmux_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/reg_map_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/rt_trace_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/ser_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/sser_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/strcop_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/strmux_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/timer_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/ata_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/bif_core_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/bif_dma_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/bif_slave_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/config_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/cpu_vect.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/dma.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/dma_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/eth_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/extmem_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/gio_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/intr_vect.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/Makefile
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_crc_par_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_dmc_in_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_dmc_out_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_fifo_in_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_fifo_out_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_mpu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_reg_space_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sap_in_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sap_out_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_scrc_in_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_scrc_out_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_spu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sw_cfg_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sw_cpu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sw_mpu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_sw_spu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_timer_grp_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_trigger_grp_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/asm/iop_version_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_crc_par_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_dmc_in_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_dmc_out_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_fifo_in_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_fifo_in_extra_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_fifo_out_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_fifo_out_extra_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_mpu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_mpu_macros.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_reg_space.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sap_in_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sap_out_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_scrc_in_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_scrc_out_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_spu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sw_cfg_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sw_cpu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sw_mpu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_sw_spu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_timer_grp_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_trigger_grp_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/iop/iop_version_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/irq_nmi_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/marb_bp_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/marb_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/pinmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/reg_rdwr.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/rt_trace_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/ser_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/sser_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/strcop.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/strcop_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/strmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/supp_reg.h
 delete mode 100644 include/asm-cris/arch-v32/intmem.h
 delete mode 100644 include/asm-cris/arch-v32/io.h
 delete mode 100644 include/asm-cris/arch-v32/irq.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/arbiter.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/dma.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/clkgen_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/ddr2_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/gio_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/pinmux_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/pio_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/reg_map_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/timer_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/clkgen_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/ddr2_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/gio_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/intr_vect.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/intr_vect_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_reg_space_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sap_in_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sap_out_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_cfg_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_cpu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_mpu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_spu_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_version_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_reg_space.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sap_in_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sap_out_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_cfg_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_cpu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_mpu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_spu_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_version_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/l2cache_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/marb_bar_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/marb_foo_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/pinmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/pio_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/reg_map.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/strmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/timer_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/memmap.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/pinmux.h
 delete mode 100644 include/asm-cris/arch-v32/mach-a3/startup.inc
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/arbiter.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/bif_core_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/config_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/gio_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/pinmux_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/reg_map_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/timer_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_core_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_dma_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_slave_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/config_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/gio_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/intr_vect.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/intr_vect_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/marb_bp_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/marb_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/pinmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/reg_map.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/strmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/timer_defs.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/pinmux.h
 delete mode 100644 include/asm-cris/arch-v32/mach-fs/startup.inc
 delete mode 100644 include/asm-cris/arch-v32/memmap.h
 delete mode 100644 include/asm-cris/arch-v32/mmu.h
 delete mode 100644 include/asm-cris/arch-v32/offset.h
 delete mode 100644 include/asm-cris/arch-v32/page.h
 delete mode 100644 include/asm-cris/arch-v32/pgtable.h
 delete mode 100644 include/asm-cris/arch-v32/pinmux.h
 delete mode 100644 include/asm-cris/arch-v32/processor.h
 delete mode 100644 include/asm-cris/arch-v32/ptrace.h
 delete mode 100644 include/asm-cris/arch-v32/spinlock.h
 delete mode 100644 include/asm-cris/arch-v32/system.h
 delete mode 100644 include/asm-cris/arch-v32/thread_info.h
 delete mode 100644 include/asm-cris/arch-v32/timex.h
 delete mode 100644 include/asm-cris/arch-v32/tlb.h
 delete mode 100644 include/asm-cris/arch-v32/uaccess.h
 delete mode 100644 include/asm-cris/arch-v32/unistd.h
 delete mode 100644 include/asm-cris/arch-v32/user.h
 delete mode 100644 include/asm-cris/atomic.h
 delete mode 100644 include/asm-cris/auxvec.h
 delete mode 100644 include/asm-cris/axisflashmap.h
 delete mode 100644 include/asm-cris/bitops.h
 delete mode 100644 include/asm-cris/bug.h
 delete mode 100644 include/asm-cris/bugs.h
 delete mode 100644 include/asm-cris/byteorder.h
 delete mode 100644 include/asm-cris/cache.h
 delete mode 100644 include/asm-cris/cacheflush.h
 delete mode 100644 include/asm-cris/checksum.h
 delete mode 100644 include/asm-cris/cputime.h
 delete mode 100644 include/asm-cris/current.h
 delete mode 100644 include/asm-cris/delay.h
 delete mode 100644 include/asm-cris/device.h
 delete mode 100644 include/asm-cris/div64.h
 delete mode 100644 include/asm-cris/dma-mapping.h
 delete mode 100644 include/asm-cris/dma.h
 delete mode 100644 include/asm-cris/elf.h
 delete mode 100644 include/asm-cris/emergency-restart.h
 delete mode 100644 include/asm-cris/errno.h
 delete mode 100644 include/asm-cris/eshlibld.h
 delete mode 100644 include/asm-cris/ethernet.h
 delete mode 100644 include/asm-cris/etraxgpio.h
 delete mode 100644 include/asm-cris/etraxi2c.h
 delete mode 100644 include/asm-cris/fasttimer.h
 delete mode 100644 include/asm-cris/fb.h
 delete mode 100644 include/asm-cris/fcntl.h
 delete mode 100644 include/asm-cris/futex.h
 delete mode 100644 include/asm-cris/hardirq.h
 delete mode 100644 include/asm-cris/hw_irq.h
 delete mode 100644 include/asm-cris/io.h
 delete mode 100644 include/asm-cris/ioctl.h
 delete mode 100644 include/asm-cris/ioctls.h
 delete mode 100644 include/asm-cris/ipcbuf.h
 delete mode 100644 include/asm-cris/irq.h
 delete mode 100644 include/asm-cris/irq_regs.h
 delete mode 100644 include/asm-cris/kdebug.h
 delete mode 100644 include/asm-cris/kmap_types.h
 delete mode 100644 include/asm-cris/linkage.h
 delete mode 100644 include/asm-cris/local.h
 delete mode 100644 include/asm-cris/mman.h
 delete mode 100644 include/asm-cris/mmu.h
 delete mode 100644 include/asm-cris/mmu_context.h
 delete mode 100644 include/asm-cris/module.h
 delete mode 100644 include/asm-cris/msgbuf.h
 delete mode 100644 include/asm-cris/mutex.h
 delete mode 100644 include/asm-cris/page.h
 delete mode 100644 include/asm-cris/param.h
 delete mode 100644 include/asm-cris/pci.h
 delete mode 100644 include/asm-cris/percpu.h
 delete mode 100644 include/asm-cris/pgalloc.h
 delete mode 100644 include/asm-cris/pgtable.h
 delete mode 100644 include/asm-cris/poll.h
 delete mode 100644 include/asm-cris/posix_types.h
 delete mode 100644 include/asm-cris/processor.h
 delete mode 100644 include/asm-cris/ptrace.h
 delete mode 100644 include/asm-cris/resource.h
 delete mode 100644 include/asm-cris/rs485.h
 delete mode 100644 include/asm-cris/rtc.h
 delete mode 100644 include/asm-cris/scatterlist.h
 delete mode 100644 include/asm-cris/sections.h
 delete mode 100644 include/asm-cris/segment.h
 delete mode 100644 include/asm-cris/sembuf.h
 delete mode 100644 include/asm-cris/setup.h
 delete mode 100644 include/asm-cris/shmbuf.h
 delete mode 100644 include/asm-cris/shmparam.h
 delete mode 100644 include/asm-cris/sigcontext.h
 delete mode 100644 include/asm-cris/siginfo.h
 delete mode 100644 include/asm-cris/signal.h
 delete mode 100644 include/asm-cris/smp.h
 delete mode 100644 include/asm-cris/socket.h
 delete mode 100644 include/asm-cris/sockios.h
 delete mode 100644 include/asm-cris/spinlock.h
 delete mode 100644 include/asm-cris/stat.h
 delete mode 100644 include/asm-cris/statfs.h
 delete mode 100644 include/asm-cris/string.h
 delete mode 100644 include/asm-cris/sync_serial.h
 delete mode 100644 include/asm-cris/system.h
 delete mode 100644 include/asm-cris/termbits.h
 delete mode 100644 include/asm-cris/termios.h
 delete mode 100644 include/asm-cris/thread_info.h
 delete mode 100644 include/asm-cris/timex.h
 delete mode 100644 include/asm-cris/tlb.h
 delete mode 100644 include/asm-cris/tlbflush.h
 delete mode 100644 include/asm-cris/topology.h
 delete mode 100644 include/asm-cris/types.h
 delete mode 100644 include/asm-cris/uaccess.h
 delete mode 100644 include/asm-cris/ucontext.h
 delete mode 100644 include/asm-cris/unaligned.h
 delete mode 100644 include/asm-cris/unistd.h
 delete mode 100644 include/asm-cris/user.h

diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index c6f5f5a..22825a7 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -23,12 +23,16 @@ mach-$(CONFIG_ETRAXFS) := fs
 
 ifneq ($(arch-y),)
 SARCH := arch-$(arch-y)
+inc := -Iarch/cris/include/arch-$(arch-y) -Iarch/cris/include/arch-$(arch-y)/arch
 else
 SARCH :=
+inc :=
 endif
 
 ifneq ($(mach-y),)
 MACH := mach-$(mach-y)
+inc += -Iarch/cris/include/$(SARCH)/$(MACH)/
+inc += -Iarch/cris/include/$(SARCH)/$(MACH)/mach
 else
 MACH :=
 endif
@@ -39,9 +43,9 @@ OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
 CPPFLAGS_vmlinux.lds = -DDRAM_VIRTUAL_BASE=0x$(CONFIG_ETRAX_DRAM_VIRTUAL_BASE)
 
-KBUILD_AFLAGS += -mlinux -march=$(arch-y) -Iinclude/asm/arch/mach -Iinclude/asm/arch
-
-KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe -Iinclude/asm/arch/mach -Iinclude/asm/arch
+KBUILD_AFLAGS += -mlinux -march=$(arch-y) $(inc)
+KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe $(inc)
+KBUILD_CPPFLAGS += $(inc)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS)) -g
@@ -73,7 +77,7 @@ all: zImage
 zImage Image: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-archprepare: $(SRC_ARCH)/.links $(srctree)/include/asm-$(ARCH)/.arch FORCE
+archprepare: $(SRC_ARCH)/.links FORCE
 
 # Create some links to make all tools happy
 $(SRC_ARCH)/.links:
@@ -95,17 +99,6 @@ endif
 	@ln -sfn ../$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
 	@touch $@
 
-# Create link to sub arch includes
-$(srctree)/include/asm-$(ARCH)/.arch: $(wildcard include/config/arch/*.h)
-	@echo '  SYMLINK include/asm-$(ARCH)/arch -> include/asm-$(ARCH)/$(SARCH)'
-	@rm -f $(srctree)/include/asm-$(ARCH)/arch/mach
-	@rm -f $(srctree)/include/asm-$(ARCH)/arch
-	@ln -sf $(SARCH) $(srctree)/include/asm-$(ARCH)/arch
-ifdef CONFIG_ETRAX_ARCH_V32
-	@ln -sf $(MACH) $(srctree)/include/asm-$(ARCH)/arch/mach
-endif
-	@touch $@
-
 archclean:
 	$(Q)if [ -e arch/$(ARCH)/boot ]; then \
 		$(MAKE) $(clean)=arch/$(ARCH)/boot; \
@@ -116,8 +109,7 @@ CLEAN_FILES += \
 	$(MACHINE)/boot/compressed/decompress.bin \
 	$(MACHINE)/boot/compressed/piggy.gz \
 	$(MACHINE)/boot/rescue/rescue.bin \
-	$(SRC_ARCH)/.links \
-	$(srctree)/include/asm-$(ARCH)/.arch
+	$(SRC_ARCH)/.links
 
 MRPROPER_FILES += \
 	$(SRC_ARCH)/drivers \
diff --git a/arch/cris/arch-v10/boot/.gitignore b/arch/cris/arch-v10/boot/.gitignore
new file mode 100644
index 0000000..171a085
--- /dev/null
+++ b/arch/cris/arch-v10/boot/.gitignore
@@ -0,0 +1,2 @@
+Image
+zImage
diff --git a/arch/cris/arch-v10/boot/compressed/head.S b/arch/cris/arch-v10/boot/compressed/head.S
index 981fbae..0bb4dcc 100644
--- a/arch/cris/arch-v10/boot/compressed/head.S
+++ b/arch/cris/arch-v10/boot/compressed/head.S
@@ -9,7 +9,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
diff --git a/arch/cris/arch-v10/boot/compressed/misc.c b/arch/cris/arch-v10/boot/compressed/misc.c
index d933c89..a4db150 100644
--- a/arch/cris/arch-v10/boot/compressed/misc.c
+++ b/arch/cris/arch-v10/boot/compressed/misc.c
@@ -20,7 +20,7 @@
 
 
 #include <linux/types.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /*
  * gzip declarations
diff --git a/arch/cris/arch-v10/boot/rescue/head.S b/arch/cris/arch-v10/boot/rescue/head.S
index 6ba7be8..fb503d1 100644
--- a/arch/cris/arch-v10/boot/rescue/head.S
+++ b/arch/cris/arch-v10/boot/rescue/head.S
@@ -65,7 +65,7 @@
 #ifdef CONFIG_ETRAX_AXISFLASHMAP
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 	;; The partitiontable is looked for at the first sector after the boot
 	;; sector. Sector size is 65536 bytes in all flashes we use.
diff --git a/arch/cris/arch-v10/boot/rescue/kimagerescue.S b/arch/cris/arch-v10/boot/rescue/kimagerescue.S
index 55eeff8..6f7b3e6 100644
--- a/arch/cris/arch-v10/boot/rescue/kimagerescue.S
+++ b/arch/cris/arch-v10/boot/rescue/kimagerescue.S
@@ -6,7 +6,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define CODE_START 0x40004000
 #define CODE_LENGTH 784
diff --git a/arch/cris/arch-v10/boot/rescue/testrescue.S b/arch/cris/arch-v10/boot/rescue/testrescue.S
index 2d937f9..fc7ec67 100644
--- a/arch/cris/arch-v10/boot/rescue/testrescue.S
+++ b/arch/cris/arch-v10/boot/rescue/testrescue.S
@@ -6,7 +6,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 	.text
 
diff --git a/arch/cris/arch-v10/drivers/axisflashmap.c b/arch/cris/arch-v10/drivers/axisflashmap.c
index b3bdda9..b207970 100644
--- a/arch/cris/arch-v10/drivers/axisflashmap.c
+++ b/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -26,7 +26,7 @@
 
 #include <asm/axisflashmap.h>
 #include <asm/mmu.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #ifdef CONFIG_CRIS_LOW_MAP
 #define FLASH_UNCACHED_ADDR  KSEG_8
diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 3bdfaf4..77630df 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -24,10 +24,10 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #include "i2c.h"
 
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 86048e6..4b0f65f 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -23,11 +23,11 @@
 #include <linux/interrupt.h>
 
 #include <asm/etraxgpio.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #define GPIO_MAJOR 120  /* experimental MAJOR number */
 
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index 2797e67..7f656ae 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -25,10 +25,10 @@
 #include <asm/etraxi2c.h>
 
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/delay.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #include "i2c.h"
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 91fea62..6cc1a03 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -26,11 +26,11 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/sync_serial.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 /* The receiver is a bit tricky beacuse of the continuous stream of data.*/
 /*                                                                       */
diff --git a/arch/cris/arch-v10/kernel/crisksyms.c b/arch/cris/arch-v10/kernel/crisksyms.c
index e6b8013..1ca6fc2 100644
--- a/arch/cris/arch-v10/kernel/crisksyms.c
+++ b/arch/cris/arch-v10/kernel/crisksyms.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* Export shadow registers for the CPU I/O pins */
 EXPORT_SYMBOL(genconfig_shadow);
diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 3dc6e91..99851ba 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -19,7 +19,7 @@
 #include <linux/delay.h>
 #include <linux/tty.h>
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>             /* Get SIMCOUT. */
 
 extern void reset_watchdog(void);
diff --git a/arch/cris/arch-v10/kernel/dma.c b/arch/cris/arch-v10/kernel/dma.c
index eb1fa0d..929e686 100644
--- a/arch/cris/arch-v10/kernel/dma.c
+++ b/arch/cris/arch-v10/kernel/dma.c
@@ -7,7 +7,7 @@
 #include <linux/errno.h>
 
 #include <asm/dma.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* Macro to access ETRAX 100 registers */
 #define SETS(var, reg, field, val) var = (var & ~IO_MASK_(reg##_, field##_)) | \
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 3a65f32..ed171d3 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -23,7 +23,7 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <asm/unistd.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 #include <asm/errno.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 31ff35c..5ff08a8 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -24,7 +24,7 @@
 #include <asm/rtc.h>
 
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/fasttimer.h>
 #include <linux/proc_fs.h>
 
diff --git a/arch/cris/arch-v10/kernel/head.S b/arch/cris/arch-v10/kernel/head.S
index 96344af..fc45771 100644
--- a/arch/cris/arch-v10/kernel/head.S
+++ b/arch/cris/arch-v10/kernel/head.S
@@ -10,7 +10,7 @@
 #define ASSEMBLER_MACROS_ONLY
 /* The IO_* macros use the ## token concatenation operator, so
    -traditional must not be used when assembling this file.  */
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define CRAMFS_MAGIC 0x28cd3d45
 #define RAM_INIT_MAGIC 0x56902387
diff --git a/arch/cris/arch-v10/kernel/io_interface_mux.c b/arch/cris/arch-v10/kernel/io_interface_mux.c
index add98e0..29f97e9 100644
--- a/arch/cris/arch-v10/kernel/io_interface_mux.c
+++ b/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -11,9 +11,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 
 #define DBG(s)
diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 6fea45f..b9f9c8c 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -176,7 +176,7 @@
 #include <asm/setup.h>
 #include <asm/ptrace.h>
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/irq.h>
 
 static int kgdb_started = 0;
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index 53117f0..bd9b3ff 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -14,7 +14,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <linux/init.h>
 
 #ifdef CONFIG_ETRAX_GPIO
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 525483f..c685ba4 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
 #include <asm/io.h>
diff --git a/arch/cris/arch-v10/kernel/traps.c b/arch/cris/arch-v10/kernel/traps.c
index 9eada5d..8bebb96 100644
--- a/arch/cris/arch-v10/kernel/traps.c
+++ b/arch/cris/arch-v10/kernel/traps.c
@@ -10,7 +10,7 @@
 
 #include <linux/ptrace.h>
 #include <asm/uaccess.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 void
 show_registers(struct pt_regs *regs)
diff --git a/arch/cris/arch-v10/mm/fault.c b/arch/cris/arch-v10/mm/fault.c
index 65504fd..087a209 100644
--- a/arch/cris/arch-v10/mm/fault.c
+++ b/arch/cris/arch-v10/mm/fault.c
@@ -13,7 +13,7 @@
 #include <linux/mm.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/mmu_context.h>
 
 /* debug of low-level TLB reload */
diff --git a/arch/cris/arch-v10/mm/init.c b/arch/cris/arch-v10/mm/init.c
index 742fd19..baa746c 100644
--- a/arch/cris/arch-v10/mm/init.c
+++ b/arch/cris/arch-v10/mm/init.c
@@ -12,7 +12,7 @@
 #include <asm/mmu.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 extern void tlb_init(void);
 
diff --git a/arch/cris/arch-v10/mm/tlb.c b/arch/cris/arch-v10/mm/tlb.c
index 6baf5bd..4a496e4 100644
--- a/arch/cris/arch-v10/mm/tlb.c
+++ b/arch/cris/arch-v10/mm/tlb.c
@@ -12,7 +12,7 @@
 
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 #define D(x)
 
diff --git a/arch/cris/arch-v32/boot/compressed/head.S b/arch/cris/arch-v32/boot/compressed/head.S
index f86208c..ea30129 100644
--- a/arch/cris/arch-v32/boot/compressed/head.S
+++ b/arch/cris/arch-v32/boot/compressed/head.S
@@ -7,7 +7,7 @@
 
 #define ASSEMBLER_MACROS_ONLY
 #include <hwregs/asm/reg_map_asm.h>
-#include <asm/arch/mach/startup.inc>
+#include <mach/startup.inc>
 
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
@@ -17,7 +17,7 @@
 	.globl	input_data
 
 	.text
-start:
+_start:
 	di
 
 	;; Start clocks for used blocks.
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index ef98608..7a87bc0 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -33,7 +33,7 @@
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
 #include "../i2c.h"
diff --git a/arch/cris/arch-v32/drivers/mach-a3/nandflash.c b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
index 01ed0be..25d6f2b 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
@@ -18,7 +18,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/pio_defs.h>
diff --git a/arch/cris/arch-v32/drivers/mach-fs/nandflash.c b/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
index aa01b13..c5a0f54 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
@@ -18,7 +18,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/gio_defs.h>
diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index 5b79a7a..77ee319 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -1,6 +1,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <asm/arch/hwregs/intr_vect.h>
+#include <arch/hwregs/intr_vect.h>
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
diff --git a/arch/cris/arch-v32/kernel/cache.c b/arch/cris/arch-v32/kernel/cache.c
index 80da7b8..f38433b 100644
--- a/arch/cris/arch-v32/kernel/cache.c
+++ b/arch/cris/arch-v32/kernel/cache.c
@@ -1,7 +1,7 @@
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/cache.h>
-#include <asm/arch/hwregs/dma.h>
+#include <arch/cache.h>
+#include <arch/hwregs/dma.h>
 
 /* This file is used to workaround a cache bug, Guinness TR 106. */
 
diff --git a/arch/cris/arch-v32/kernel/crisksyms.c b/arch/cris/arch-v32/kernel/crisksyms.c
index 77d02c1..64933e2 100644
--- a/arch/cris/arch-v32/kernel/crisksyms.c
+++ b/arch/cris/arch-v32/kernel/crisksyms.c
@@ -1,9 +1,9 @@
 #include <linux/module.h>
 #include <linux/irq.h>
-#include <asm/arch/dma.h>
-#include <asm/arch/intmem.h>
-#include <asm/arch/mach/pinmux.h>
-#include <asm/arch/io.h>
+#include <arch/dma.h>
+#include <arch/intmem.h>
+#include <mach/pinmux.h>
+#include <arch/io.h>
 
 /* Functions for allocating DMA channels */
 EXPORT_SYMBOL(crisv32_request_dma);
diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index 15af4c2..794b364 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -9,7 +9,7 @@
 #include <hwregs/reg_map.h>
 #include <hwregs/ser_defs.h>
 #include <hwregs/dma_defs.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 
 struct dbg_port
 {
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index eebbaba..7f6f93e 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -24,8 +24,8 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/intr_vect_defs_asm.h>
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/intr_vect_defs_asm.h>
 
 	;; Exported functions.
 	.globl system_call
diff --git a/arch/cris/arch-v32/kernel/head.S b/arch/cris/arch-v32/kernel/head.S
index 2d66a7c..f902d87 100644
--- a/arch/cris/arch-v32/kernel/head.S
+++ b/arch/cris/arch-v32/kernel/head.S
@@ -11,11 +11,11 @@
  * -traditional must not be used when assembling this file.
  */
 #include <hwregs/reg_rdwr.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/intr_vect.h>
 #include <hwregs/asm/mmu_defs_asm.h>
 #include <hwregs/asm/reg_map_asm.h>
-#include <asm/arch/mach/startup.inc>
+#include <mach/startup.inc>
 
 #define CRAMFS_MAGIC 0x28cd3d45
 #define JHEAD_MAGIC 0x1FF528A6
diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
index 8bd5a5b..c981fd6 100644
--- a/arch/cris/arch-v32/kernel/kgdb.c
+++ b/arch/cris/arch-v32/kernel/kgdb.c
@@ -174,10 +174,10 @@
 #include <asm/ptrace.h>
 
 #include <asm/irq.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
-#include <asm/arch/hwregs/ser_defs.h>
+#include <arch/hwregs/reg_map.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/hwregs/intr_vect_defs.h>
+#include <arch/hwregs/ser_defs.h>
 
 /* From entry.S. */
 extern void gdb_handle_exception(void);
diff --git a/arch/cris/arch-v32/kernel/kgdb_asm.S b/arch/cris/arch-v32/kernel/kgdb_asm.S
index 3e7fa9e..eba93e7 100644
--- a/arch/cris/arch-v32/kernel/kgdb_asm.S
+++ b/arch/cris/arch-v32/kernel/kgdb_asm.S
@@ -5,7 +5,7 @@
  * port exceptions for kernel debugging purposes.
  */
 
-#include <asm/arch/hwregs/intr_vect.h>
+#include <arch/hwregs/intr_vect.h>
 
 	;; Exported functions.
 	.globl kgdb_handle_exception
diff --git a/arch/cris/arch-v32/kernel/pinmux.c b/arch/cris/arch-v32/kernel/pinmux.c
index a2b8aa3..6eb54ea 100644
--- a/arch/cris/arch-v32/kernel/pinmux.c
+++ b/arch/cris/arch-v32/kernel/pinmux.c
@@ -11,10 +11,10 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/pinmux_defs.h>
+#include <arch/hwregs/reg_map.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/pinmux.h>
+#include <arch/hwregs/pinmux_defs.h>
 
 #undef DEBUG
 
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index e27f467..dd40147 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/processor.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/supp_reg.h>
 
 /*
  * Determines which bits in CCS the user has access to.
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index 58c1866..da7d2be 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -18,8 +18,8 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
-#include <asm/arch/ptrace.h>
-#include <asm/arch/hwregs/cpu_vect.h>
+#include <arch/ptrace.h>
+#include <arch/hwregs/cpu_vect.h>
 
 extern unsigned long cris_signal_return_page;
 
diff --git a/arch/cris/arch-v32/lib/nand_init.S b/arch/cris/arch-v32/lib/nand_init.S
index e019816..e705f5c 100644
--- a/arch/cris/arch-v32/lib/nand_init.S
+++ b/arch/cris/arch-v32/lib/nand_init.S
@@ -22,11 +22,11 @@
 ##
 ##=============================================================================
 
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/gio_defs_asm.h>
-#include <asm/arch/hwregs/asm/pinmux_defs_asm.h>
-#include <asm/arch/hwregs/asm/bif_core_defs_asm.h>
-#include <asm/arch/hwregs/asm/config_defs_asm.h>
+#include <arch/hwregs/asm/reg_map_asm.h>
+#include <arch/hwregs/asm/gio_defs_asm.h>
+#include <arch/hwregs/asm/pinmux_defs_asm.h>
+#include <arch/hwregs/asm/bif_core_defs_asm.h>
+#include <arch/hwregs/asm/config_defs_asm.h>
 
 ;; There are 8-bit NAND flashes and 16-bit NAND flashes.
 ;; We need to treat them slightly different.
diff --git a/arch/cris/arch-v32/mach-a3/dma.c b/arch/cris/arch-v32/mach-a3/dma.c
index 25f236e..f35e4f6 100644
--- a/arch/cris/arch-v32/mach-a3/dma.c
+++ b/arch/cris/arch-v32/mach-a3/dma.c
@@ -2,7 +2,7 @@
 
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <asm/arch/mach/dma.h>
+#include <mach/dma.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/marb_defs.h>
diff --git a/arch/cris/arch-v32/mach-a3/io.c b/arch/cris/arch-v32/mach-a3/io.c
index 9eeaf3e..c22f67e 100644
--- a/arch/cris/arch-v32/mach-a3/io.c
+++ b/arch/cris/arch-v32/mach-a3/io.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 #include <hwregs/gio_defs.h>
 
 struct crisv32_ioport crisv32_ioports[] = {
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/arch/cris/arch-v32/mach-fs/cpufreq.c
index 58bd71e..d92cf70 100644
--- a/arch/cris/arch-v32/mach-fs/cpufreq.c
+++ b/arch/cris/arch-v32/mach-fs/cpufreq.c
@@ -2,9 +2,9 @@
 #include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/config_defs.h>
-#include <asm/arch/hwregs/bif_core_defs.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/hwregs/config_defs.h>
+#include <arch/hwregs/bif_core_defs.h>
 
 static int
 cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
diff --git a/arch/cris/arch-v32/mach-fs/dma.c b/arch/cris/arch-v32/mach-fs/dma.c
index a6acf4e..2d970d7 100644
--- a/arch/cris/arch-v32/mach-fs/dma.c
+++ b/arch/cris/arch-v32/mach-fs/dma.c
@@ -10,7 +10,7 @@
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
 #include <asm/system.h>
-#include <asm/arch/mach/arbiter.h>
+#include <mach/arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
 static const char *used_dma_channels_users[MAX_DMA_CHANNELS];
diff --git a/arch/cris/arch-v32/mach-fs/io.c b/arch/cris/arch-v32/mach-fs/io.c
index a03a3ad..cb6327b 100644
--- a/arch/cris/arch-v32/mach-fs/io.c
+++ b/arch/cris/arch-v32/mach-fs/io.c
@@ -12,8 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/gio_defs.h>
+#include <mach/pinmux.h>
+#include <hwregs/gio_defs.h>
 
 #ifndef DEBUG
 #define DEBUG(x)
diff --git a/arch/cris/arch-v32/mach-fs/vcs_hook.c b/arch/cris/arch-v32/mach-fs/vcs_hook.c
index 593b10f..b11594a 100644
--- a/arch/cris/arch-v32/mach-fs/vcs_hook.c
+++ b/arch/cris/arch-v32/mach-fs/vcs_hook.c
@@ -5,8 +5,8 @@
 
 #include "vcs_hook.h"
 #include <stdarg.h>
-#include <asm/arch-v32/hwregs/reg_map.h>
-#include <asm/arch-v32/hwregs/intr_vect_defs.h>
+#include <arch-v32/hwregs/reg_map.h>
+#include <arch-v32/hwregs/intr_vect_defs.h>
 
 #define HOOK_TRIG_ADDR     0xb7000000	/* hook cvlog model reg address */
 #define HOOK_MEM_BASE_ADDR 0xa0000000	/* csp4 (shared mem) base addr */
diff --git a/arch/cris/arch-v32/mm/init.c b/arch/cris/arch-v32/mm/init.c
index 8a34b8b..caeb921 100644
--- a/arch/cris/arch-v32/mm/init.c
+++ b/arch/cris/arch-v32/mm/init.c
@@ -16,8 +16,8 @@
 #include <asm/mmu.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/hwregs/asm/mmu_defs_asm.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/asm/mmu_defs_asm.h>
+#include <arch/hwregs/supp_reg.h>
 
 extern void tlb_init(void);
 
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index eda5ebc..55ade36 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -9,8 +9,8 @@
 
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/hwregs/asm/mmu_defs_asm.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/asm/mmu_defs_asm.h>
+#include <arch/hwregs/supp_reg.h>
 
 #define UPDATE_TLB_SEL_IDX(val)					\
 do {								\

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com

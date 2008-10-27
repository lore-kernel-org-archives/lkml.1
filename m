Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYJ0X71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYJ0X71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYJ0X7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:59:17 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3607 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYJ0X7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:59:16 -0400
Message-ID: <490655B6.4030406@caviumnetworks.com>
Date: Mon, 27 Oct 2008 16:58:46 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips <linux-mips@linux-mips.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH 00/36] Add Cavium OCTEON processor support (v2).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2008 23:58:46.0712 (UTC) FILETIME=[F31EA380:01C9388F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces preliminary support for Cavium Networks'
OCTEON processor family.  More information about these processors may
be obtained here:

http://www.caviumnetworks.com/OCTEON_MIPS64.html

This initial patch set adds support for booting an initramfs to a
serial console.  Follow-on patch sets will add support for the on-chip
ethernet, USB, PCI, PCIe, I2c and other peripherals.

With this second version of the patches I think we have fixed or
removed the parts flagged as objectionable in the first round of
reviews.  In addition to more general cleanups I fixed the following
issues:

* externs declared in mm/fault.c moved to fpu_emulator.h

* Corrected spelling of hazard in patch commentary.

* Useless checking in pmd_none removed.

* ebase calculation generalized.

* ST0_KX setting for 32bit kernel removed (there is now no 32bit
  kernel support)

Without further ado, I will reply with the following 36 patches (5 of
which will also go to linux-serial):

  01 - Add Cavium OCTEON processor support files to arch/mips/cavium-octeon.
  02 - Add Cavium OCTEON files to arch/mips/include/asm/mach-cavium-octeon
  03 - Add Cavium OCTEON processor support files to arch/mips/kernel.
  04 - Add Cavium OCTEON processor support files to arch/mips/mm.
  05 - Add Cavium OCTEON processor support files to and
    arch/mips/cavium-octeon/executive
  06 - Add Cavium OCTEON processor CSR definitions
  07 - Don't assume boot CPU is CPU0 if MIPS_DISABLE_BOOT_CPU_ZERO set.
  08 - For Cavium OCTEON handle hazards as per the R10000 handling.
  09 - Enable mips32 style bitops for Cavium OCTEON.
  10 - Cavium OCTEON: Set hwrena and lazily restore CP2 state.
  11 - MIPSR2 ebase isn't just CAC_BASE
  12 - Add Cavium OCTEON to arch/mips/Kconfig
  13 - Add Cavium OCTEON processor constants.
  14 - Rewrite cpu_to_name so it has one statement per line.
  15 - Probe for Cavium OCTEON CPUs.
  16 - MIPS: Hook Cavium OCTEON cache init into cache.c
  17 - cavium: Hook Cavium specifics into main arch/mips dir
  18 - Cavium OCTEON modify core io.h macros to account for the Octeon
    Errata Core-301.
  19 - Cavium OCTEON: increase MAX_DMA address.
  20 - Cavium OCTEON: add in icache and dcache error functions.
  21 - Cavium OCTEON: Add cop2/cvmseg state entries to processor.h.
  22 - Add Cavium OCTEON specific registers to ptrace.h and asm-offsets.c
  23 - Add SMP_ICACHE_FLUSH for the Cavium CPU family.
  24 - Cavium OCTEON: PT vs MFC0 reorder, multiplier state preservation.
  25 - Add Cavium OCTEON irq hazard in asmmacro.h.
  26 - Compute branch returns for Cavium OCTEON specific branch
    instructions.
  27 - Add Cavium OCTEON slot into proper tlb category.
  28 - MIPS: move FPU emulator externs to fpu_emulator.h
  29 - Cavium OCTEON FPU EMU exception as TLB exception

These five to linux-serial, linux-kernel, and akpm as well:
  30 - Don't clobber spinlocks in 8250.
  31 - Generic 8250 serial driver changes to support future OCTEON serial
    patches.
  32 - Allow port type to be specified when calling
    serial8250_register_port.
  33 - Allow port type to specify bugs that are not probed for.
  34 - 8250 serial driver changes for Cavium OCTEON.


  35 - Adjust the dma-common.c platform hooks.
  36 - Add defconfig for Cavium OCTEON.

 arch/mips/Kconfig                                  |   74 +-
 arch/mips/Makefile                                 |   13 +
 arch/mips/cavium-octeon/Kconfig                    |   85 +
 arch/mips/cavium-octeon/Makefile                   |   21 +
 arch/mips/cavium-octeon/console.c                  |   34 +
 arch/mips/cavium-octeon/dma-octeon.c               |  324 +
 arch/mips/cavium-octeon/executive/Makefile         |   26 +
 arch/mips/cavium-octeon/executive/cvmx-asm.h       |  427 +
 arch/mips/cavium-octeon/executive/cvmx-bootinfo.h  |  238 +
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  897 +
 arch/mips/cavium-octeon/executive/cvmx-bootmem.h   |  403 +
 .../cavium-octeon/executive/cvmx-csr-addresses.h   | 8391 ++++++
 arch/mips/cavium-octeon/executive/cvmx-csr-enums.h |   86 +
 .../cavium-octeon/executive/cvmx-csr-typedefs.h    |27517 ++++++++++++++++++++
 arch/mips/cavium-octeon/executive/cvmx-csr.h       |  199 +
 arch/mips/cavium-octeon/executive/cvmx-interrupt.h |  255 +
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |  711 +
 arch/mips/cavium-octeon/executive/cvmx-l2c.h       |  328 +
 .../executive/cvmx-linux-kernel-exports.c          |   30 +
 arch/mips/cavium-octeon/executive/cvmx-packet.h    |   64 +
 arch/mips/cavium-octeon/executive/cvmx-platform.h  |   56 +
 arch/mips/cavium-octeon/executive/cvmx-spinlock.h  |  376 +
 arch/mips/cavium-octeon/executive/cvmx-sysinfo.c   |  113 +
 arch/mips/cavium-octeon/executive/cvmx-sysinfo.h   |  144 +
 arch/mips/cavium-octeon/executive/cvmx-warn.c      |   44 +
 arch/mips/cavium-octeon/executive/cvmx-warn.h      |   46 +
 arch/mips/cavium-octeon/executive/cvmx.h           |  772 +
 arch/mips/cavium-octeon/executive/octeon-feature.h |  120 +
 arch/mips/cavium-octeon/executive/octeon-model.c   |  328 +
 arch/mips/cavium-octeon/executive/octeon-model.h   |  225 +
 arch/mips/cavium-octeon/flash_setup.c              |   76 +
 arch/mips/cavium-octeon/hal.c                      |  496 +
 arch/mips/cavium-octeon/hal.h                      |  190 +
 arch/mips/cavium-octeon/i8259.c                    |  180 +
 arch/mips/cavium-octeon/irq.c                      |   61 +
 arch/mips/cavium-octeon/octeon-memcpy.S            |  521 +
 arch/mips/cavium-octeon/serial.c                   |  187 +
 arch/mips/cavium-octeon/setup.c                    |  387 +
 arch/mips/cavium-octeon/smp.c                      |  231 +
 arch/mips/cavium-octeon/userio.c                   |  156 +
 arch/mips/configs/cavium-octeon_defconfig          | 1160 +
 arch/mips/include/asm/asmmacro.h                   |   10 +
 arch/mips/include/asm/bitops.h                     |    3 +-
 arch/mips/include/asm/cpu-features.h               |    7 +
 arch/mips/include/asm/cpu.h                        |   14 +
 arch/mips/include/asm/dma.h                        |    7 +
 arch/mips/include/asm/fpu_emulator.h               |    5 +
 arch/mips/include/asm/hazards.h                    |    4 +-
 arch/mips/include/asm/io.h                         |   14 +
 .../asm/mach-cavium-octeon/cpu-feature-overrides.h |   63 +
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   64 +
 arch/mips/include/asm/mach-cavium-octeon/irq.h     |  253 +
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |  140 +
 .../asm/mach-cavium-octeon/octeon-hal-read-write.h |   38 +
 arch/mips/include/asm/mach-cavium-octeon/war.h     |   26 +
 arch/mips/include/asm/mach-generic/dma-coherence.h |   26 +-
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |   26 +-
 arch/mips/include/asm/mipsregs.h                   |    5 +
 arch/mips/include/asm/module.h                     |    2 +
 arch/mips/include/asm/processor.h                  |   69 +
 arch/mips/include/asm/ptrace.h                     |    4 +
 arch/mips/include/asm/smp.h                        |    3 +
 arch/mips/include/asm/stackframe.h                 |   46 +
 arch/mips/kernel/Makefile                          |    9 +
 arch/mips/kernel/asm-offsets.c                     |   31 +
 arch/mips/kernel/branch.c                          |   33 +
 arch/mips/kernel/cpu-probe.c                       |  182 +-
 arch/mips/kernel/irq-octeon.c                      |  464 +
 arch/mips/kernel/octeon_switch.S                   |  506 +
 arch/mips/kernel/smp.c                             |    2 +
 arch/mips/kernel/traps.c                           |   34 +-
 arch/mips/kernel/unaligned.c                       |    2 +-
 arch/mips/lib/Makefile                             |    1 +
 arch/mips/math-emu/dsemul.h                        |    1 -
 arch/mips/mm/Makefile                              |    5 +
 arch/mips/mm/c-octeon.c                            |  309 +
 arch/mips/mm/cache.c                               |    6 +
 arch/mips/mm/cex-oct.S                             |   70 +
 arch/mips/mm/dma-default.c                         |   24 +-
 arch/mips/mm/fault.c                               |   16 +
 arch/mips/mm/tlbex.c                               |    1 +
 drivers/serial/8250.c                              |  233 +-
 drivers/serial/8250.h                              |    3 +
 drivers/serial/serial_core.c                       |    7 +-
 include/linux/serial_8250.h                        |    2 +
 include/linux/serial_core.h                        |    7 +-
 include/linux/serial_reg.h                         |    6 +
 90 files changed, 48682 insertions(+), 171 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/Kconfig
 create mode 100644 arch/mips/cavium-octeon/Makefile
 create mode 100644 arch/mips/cavium-octeon/console.c
 create mode 100644 arch/mips/cavium-octeon/dma-octeon.c
 create mode 100644 arch/mips/cavium-octeon/executive/Makefile
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-asm.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-bootinfo.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-bootmem.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-bootmem.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-csr-addresses.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-csr-enums.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-csr-typedefs.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-csr.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-interrupt.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-l2c.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-l2c.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-linux-kernel-exports.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-packet.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-platform.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-spinlock.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-sysinfo.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-sysinfo.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-warn.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-warn.h
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx.h
 create mode 100644 arch/mips/cavium-octeon/executive/octeon-feature.h
 create mode 100644 arch/mips/cavium-octeon/executive/octeon-model.c
 create mode 100644 arch/mips/cavium-octeon/executive/octeon-model.h
 create mode 100644 arch/mips/cavium-octeon/flash_setup.c
 create mode 100644 arch/mips/cavium-octeon/hal.c
 create mode 100644 arch/mips/cavium-octeon/hal.h
 create mode 100644 arch/mips/cavium-octeon/i8259.c
 create mode 100644 arch/mips/cavium-octeon/irq.c
 create mode 100644 arch/mips/cavium-octeon/octeon-memcpy.S
 create mode 100644 arch/mips/cavium-octeon/serial.c
 create mode 100644 arch/mips/cavium-octeon/setup.c
 create mode 100644 arch/mips/cavium-octeon/smp.c
 create mode 100644 arch/mips/cavium-octeon/userio.c
 create mode 100644 arch/mips/configs/cavium-octeon_defconfig
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/irq.h
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/octeon-hal-read-write.h
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/war.h
 create mode 100644 arch/mips/kernel/irq-octeon.c
 create mode 100644 arch/mips/kernel/octeon_switch.S
 create mode 100644 arch/mips/mm/c-octeon.c
 create mode 100644 arch/mips/mm/cex-oct.S


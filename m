Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYKFUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYKFUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYKFUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:52:19 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:38456 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYKFUwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:52:18 -0500
Message-ID: <491358F5.7040002@caviumnetworks.com>
Date: Thu, 06 Nov 2008 12:52:05 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips <linux-mips@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/29] Add Cavium OCTEON processor support (v3).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2008 20:52:06.0262 (UTC) FILETIME=[87431960:01C94051]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces preliminary support for Cavium Networks'
OCTEON processor family.  More (but not detailed) information about
these processors may be obtained here:

http://www.caviumnetworks.com/OCTEON_MIPS64.html

This initial patch set adds support for booting an initramfs to a
serial console.  Follow-on patch sets will add support for the on-chip
ethernet, USB, PCI, PCIe, I2c and other peripherals.

With this third version of the patches I think we have fixed or
removed most of the parts flagged as objectionable in the first two
rounds of reviews.  There was extensive rearrangement of some of the
chip and board support files as well as cleanup of cache, dma, and
interrupt code.  Ralf already merged or made equivalent changes for
six of the patches so the set is getting smaller.

I am sending 23 - 27 to linux-serial and linux-kernel and akpm in
hopes that these non-MIPS patches might be reviewed thus enabling the
entire set to eventually be merged.

29 patches to follow as replies (I hope).

David Daney (29):
  01 - MIPS: Add Cavium OCTEON processor support files to
    arch/mips/cavium-octeon.
  02 - MIPS: Add Cavium OCTEON files to
    arch/mips/include/asm/mach-cavium-octeon
  03 - MIPS: Add Cavium OCTEON processor support files to arch/mips/kernel.
  04 - MIPS: Add Cavium OCTEON processor support files to arch/mips/mm.
  05 - MIPS: Add Cavium OCTEON processor support files to
    arch/mips/cavium-octeon/executive and asm/octeon.
  06 - MIPS: For Cavium OCTEON handle hazards as per the R10000 handling.
  07 - MIPS: For Cavium OCTEON set hwrena and lazily restore CP2 state.
  08 - MIPS: Add Cavium OCTEON to arch/mips/Kconfig
  09 - MIPS: Add Cavium OCTEON processor constants.
  10 - MIPS: Add Cavium OCTEON specific register definitions to mipsregs.h
  11 - MIPS: Override assembler target architecture for octeon.
  12 - MIPS: Probe for Cavium OCTEON CPUs.
  13 - MIPS: Hook Cavium OCTEON cache init into cache.c
  14 - MIPS: Hook up Cavium OCTEON in arch/mips.
  15 - MIPS: Modify core io.h macros to account for the Octeon Errata
    Core-301.
  16 - MIPS: Add Cavium OCTEON cop2/cvmseg state entries to processor.h.
  17 - MIPS: Add Cavium OCTEON specific registers to ptrace.h and
    asm-offsets.c
  18 - MIPS: Add SMP_ICACHE_FLUSH for the Cavium CPU family.
  19 - MIPS: Cavium OCTEON: PT vs MFC0 reorder, multiplier state
    preservation.
  20 - MIPS: Add Cavium OCTEON irq hazard in asmmacro.h.
  21 - MIPS:  Compute branch returns for Cavium OCTEON specific branch
    instructions.
  22 - MIPS: Add Cavium OCTEON slot into proper tlb category.
  23 - 8250: Don't clobber spinlocks.
  24 - 8250: Serial driver changes to support future Cavium OCTEON serial
    patches.
  25 - Serial: Allow port type to be specified when calling
    serial8250_register_port.
  26 - 8250: Allow port type to specify bugs that are not probed for.
  27 - Serial: UART driver changes for Cavium OCTEON.
  28 - MIPS:  Adjust the dma-common.c platform hooks.
  29 - MIPS: Add defconfig for Cavium OCTEON.

 arch/mips/Kconfig                                  |   65 +-
 arch/mips/Makefile                                 |   16 +
 arch/mips/cavium-octeon/Kconfig                    |   85 +
 arch/mips/cavium-octeon/Makefile                   |   20 +
 arch/mips/cavium-octeon/dma-octeon.c               |   31 +
 arch/mips/cavium-octeon/executive/Makefile         |   24 +
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  929 +++++++++
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |  736 +++++++
 arch/mips/cavium-octeon/executive/cvmx-sysinfo.c   |  117 ++
 arch/mips/cavium-octeon/executive/octeon-model.c   |  346 ++++
 arch/mips/cavium-octeon/flash_setup.c              |   77 +
 arch/mips/cavium-octeon/octeon-irq.c               |  498 +++++
 arch/mips/cavium-octeon/octeon-memcpy.S            |  521 +++++
 arch/mips/cavium-octeon/serial.c                   |  187 ++
 arch/mips/cavium-octeon/setup.c                    |  710 +++++++
 arch/mips/cavium-octeon/smp.c                      |  225 +++
 arch/mips/cavium-octeon/userio.c                   |  155 ++
 arch/mips/configs/cavium-octeon_defconfig          | 1146 +++++++++++
 arch/mips/include/asm/asmmacro.h                   |   10 +
 arch/mips/include/asm/cpu-features.h               |    3 +
 arch/mips/include/asm/cpu.h                        |   14 +
 arch/mips/include/asm/hazards.h                    |    4 +-
 arch/mips/include/asm/io.h                         |   14 +
 .../asm/mach-cavium-octeon/cpu-feature-overrides.h |   62 +
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   64 +
 arch/mips/include/asm/mach-cavium-octeon/irq.h     |  244 +++
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |  140 ++
 arch/mips/include/asm/mach-cavium-octeon/war.h     |   26 +
 arch/mips/include/asm/mach-generic/dma-coherence.h |   26 +-
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |   26 +-
 arch/mips/include/asm/mipsregs.h                   |   22 +
 arch/mips/include/asm/module.h                     |    2 +
 arch/mips/include/asm/octeon/cvmx-asm.h            |  446 +++++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  238 +++
 arch/mips/include/asm/octeon/cvmx-bootmem.h        |  403 ++++
 arch/mips/include/asm/octeon/cvmx-ciu-defs.h       | 1615 ++++++++++++++++
 arch/mips/include/asm/octeon/cvmx-gpio-defs.h      |  218 +++
 arch/mips/include/asm/octeon/cvmx-iob-defs.h       |  529 +++++
 arch/mips/include/asm/octeon/cvmx-ipd-defs.h       |  861 +++++++++
 arch/mips/include/asm/octeon/cvmx-l2c-defs.h       |  958 +++++++++
 arch/mips/include/asm/octeon/cvmx-l2c.h            |  328 ++++
 arch/mips/include/asm/octeon/cvmx-l2d-defs.h       |  368 ++++
 arch/mips/include/asm/octeon/cvmx-l2t-defs.h       |  140 ++
 arch/mips/include/asm/octeon/cvmx-led-defs.h       |  239 +++
 arch/mips/include/asm/octeon/cvmx-mio-defs.h       | 2028 ++++++++++++++++++++
 arch/mips/include/asm/octeon/cvmx-packet.h         |   64 +
 arch/mips/include/asm/octeon/cvmx-platform.h       |   56 +
 arch/mips/include/asm/octeon/cvmx-pow-defs.h       |  697 +++++++
 arch/mips/include/asm/octeon/cvmx-spinlock.h       |  376 ++++
 arch/mips/include/asm/octeon/cvmx-sysinfo.h        |  144 ++
 arch/mips/include/asm/octeon/cvmx-warn.h           |   40 +
 arch/mips/include/asm/octeon/cvmx.h                |  776 ++++++++
 arch/mips/include/asm/octeon/octeon-feature.h      |  120 ++
 arch/mips/include/asm/octeon/octeon-model.h        |  225 +++
 arch/mips/include/asm/octeon/octeon.h              |  238 +++
 arch/mips/include/asm/processor.h                  |   69 +
 arch/mips/include/asm/ptrace.h                     |    4 +
 arch/mips/include/asm/smp.h                        |    3 +
 arch/mips/include/asm/stackframe.h                 |   46 +
 arch/mips/kernel/Makefile                          |    1 +
 arch/mips/kernel/asm-offsets.c                     |   31 +
 arch/mips/kernel/branch.c                          |   33 +
 arch/mips/kernel/cpu-probe.c                       |   25 +
 arch/mips/kernel/genex.S                           |    4 +
 arch/mips/kernel/octeon_switch.S                   |  506 +++++
 arch/mips/kernel/traps.c                           |   21 +
 arch/mips/lib/Makefile                             |    1 +
 arch/mips/mm/Makefile                              |    1 +
 arch/mips/mm/c-octeon.c                            |  307 +++
 arch/mips/mm/cache.c                               |    6 +
 arch/mips/mm/cex-oct.S                             |   70 +
 arch/mips/mm/dma-default.c                         |   24 +-
 arch/mips/mm/tlbex.c                               |    1 +
 drivers/serial/8250.c                              |  233 ++-
 drivers/serial/8250.h                              |    3 +
 drivers/serial/serial_core.c                       |    7 +-
 include/linux/serial_8250.h                        |    2 +
 include/linux/serial_core.h                        |    7 +-
 include/linux/serial_reg.h                         |    6 +
 82 files changed, 19055 insertions(+), 86 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/Kconfig
 create mode 100644 arch/mips/cavium-octeon/Makefile
 create mode 100644 arch/mips/cavium-octeon/dma-octeon.c
 create mode 100644 arch/mips/cavium-octeon/executive/Makefile
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-bootmem.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-l2c.c
 create mode 100644 arch/mips/cavium-octeon/executive/cvmx-sysinfo.c
 create mode 100644 arch/mips/cavium-octeon/executive/octeon-model.c
 create mode 100644 arch/mips/cavium-octeon/flash_setup.c
 create mode 100644 arch/mips/cavium-octeon/octeon-irq.c
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
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/war.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-asm.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-bootinfo.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-bootmem.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-ciu-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-gpio-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-iob-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-ipd-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-l2c-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-l2c.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-l2d-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-l2t-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-led-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-mio-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-packet.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-platform.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-pow-defs.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-spinlock.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-sysinfo.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx-warn.h
 create mode 100644 arch/mips/include/asm/octeon/cvmx.h
 create mode 100644 arch/mips/include/asm/octeon/octeon-feature.h
 create mode 100644 arch/mips/include/asm/octeon/octeon-model.h
 create mode 100644 arch/mips/include/asm/octeon/octeon.h
 create mode 100644 arch/mips/kernel/octeon_switch.S
 create mode 100644 arch/mips/mm/c-octeon.c
 create mode 100644 arch/mips/mm/cex-oct.S


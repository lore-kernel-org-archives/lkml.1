Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYKRWWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYKRWWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYKRWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:21:51 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10969 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYKRWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:21:50 -0500
Message-ID: <49233FDE.3010404@caviumnetworks.com>
Date: Tue, 18 Nov 2008 14:21:18 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 00/26] Add Cavium OCTEON processor support (v4).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2008 22:21:18.0527 (UTC) FILETIME=[FA6AECF0:01C949CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces preliminary support for Cavium Networks'
OCTEON processor family.  More (but not detailed) information about
these processors may be obtained here:

http://www.caviumnetworks.com/OCTEON_MIPS64.html

Patches 19 - 23 I am sending to akpm, linux-serial and linux-kernel.
So far I have been underwhelmed by the review of these serial patches
which are a necessary part of the processor support, so I am hoping
that Andrew or a similarly authoritative person will review them.

This initial patch set adds support for booting an initramfs to a
serial console.  Follow-on patch sets will add support for the on-chip
Compact Flash, ethernet, USB, PCI, PCIe, I2c and other peripherals.

With this forth version of the patches I think we have fixed or
removed most of the parts flagged as objectionable in the first three
rounds of reviews.  There has been more rearrangement of some of the
chip and board support files.  Perhaps most notable is adding the
serial ports as platform devices, which gives the proper
initialization order for KGDB to be able to work.  I have also moved
the main Kconfig patch to the end, so that it is no longer possible to
build with only a subset of the patches applied.


26 patches to follow as replies (I hope).

David Daney (26):
  MIPS: Add Cavium OCTEON processor support files to
    arch/mips/cavium-octeon/executive and asm/octeon.
  MIPS: Add Cavium OCTEON processor CSR definitions
  MIPS: Add Cavium OCTEON processor support files to
    arch/mips/cavium-octeon.
  MIPS: For Cavium OCTEON handle hazards as per the R10000 handling.
  MIPS: For Cavium OCTEON set hwrena and lazily restore CP2 state.
  MIPS: Add Cavium OCTEON specific register definitions to mipsregs.h
  MIPS: Override assembler target architecture for octeon.
  MIPS: Add Cavium OCTEON processor constants and CPU probe.
  MIPS: Hook Cavium OCTEON cache init into cache.c
  MIPS: Hook up Cavium OCTEON in arch/mips.
  MIPS: Modify core io.h macros to account for the Octeon Errata
    Core-301.
  MIPS: Add Cavium OCTEON cop2/cvmseg state entries to processor.h.
  MIPS: Add Cavium OCTEON specific registers to ptrace.h and
    asm-offsets.c
  MIPS: Add SMP_ICACHE_FLUSH for the Cavium CPU family.
  MIPS: Cavium OCTEON: PT vs MFC0 reorder, multiplier state
    preservation.
  MIPS: Add Cavium OCTEON irq hazard in asmmacro.h.
  MIPS:  Compute branch returns for Cavium OCTEON specific branch
    instructions.
  MIPS: Add Cavium OCTEON slot into proper tlb category.
  8250: Don't clobber spinlocks.
  8250: Serial driver changes to support future Cavium OCTEON serial
    patches.
  Serial: Allow port type to be specified when calling
    serial8250_register_port.
  8250: Allow port type to specify bugs that are not probed for.
  Serial: UART driver changes for Cavium OCTEON.
  MIPS: Adjust the dma-common.c platform hooks.
  MIPS: Add defconfig for Cavium OCTEON.
  MIPS: Add Cavium OCTEON to arch/mips/Kconfig

 arch/mips/Kconfig                                  |   65 +-
 arch/mips/Makefile                                 |   16 +
 arch/mips/cavium-octeon/Kconfig                    |   85 +
 arch/mips/cavium-octeon/Makefile                   |   20 +
 arch/mips/cavium-octeon/dma-octeon.c               |   32 +
 arch/mips/cavium-octeon/executive/Makefile         |   24 +
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  929 +++++++++
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |  736 +++++++
 arch/mips/cavium-octeon/executive/cvmx-sysinfo.c   |  117 ++
 arch/mips/cavium-octeon/executive/octeon-model.c   |  346 ++++
 arch/mips/cavium-octeon/flash_setup.c              |   83 +
 arch/mips/cavium-octeon/octeon-irq.c               |  498 +++++
 arch/mips/cavium-octeon/octeon-memcpy.S            |  521 +++++
 arch/mips/cavium-octeon/serial.c                   |  134 ++
 arch/mips/cavium-octeon/setup.c                    |  919 +++++++++
 arch/mips/cavium-octeon/smp.c                      |  216 ++
 arch/mips/configs/cavium-octeon_defconfig          | 1143 +++++++++++
 arch/mips/include/asm/asmmacro.h                   |   10 +
 arch/mips/include/asm/cpu-features.h               |    3 +
 arch/mips/include/asm/cpu.h                        |   14 +
 arch/mips/include/asm/hazards.h                    |    4 +-
 arch/mips/include/asm/io.h                         |   14 +
 .../asm/mach-cavium-octeon/cpu-feature-overrides.h |   62 +
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   64 +
 arch/mips/include/asm/mach-cavium-octeon/irq.h     |  244 +++
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |  137 ++
 arch/mips/include/asm/mach-cavium-octeon/war.h     |   26 +
 arch/mips/include/asm/mach-generic/dma-coherence.h |   26 +-
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |   26 +-
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |   26 +-
 arch/mips/include/asm/mipsregs.h                   |   22 +
 arch/mips/include/asm/module.h                     |    2 +
 arch/mips/include/asm/octeon/cvmx-asm.h            |  446 ++++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  238 +++
 arch/mips/include/asm/octeon/cvmx-bootmem.h        |  403 ++++
 arch/mips/include/asm/octeon/cvmx-ciu-defs.h       | 1650 +++++++++++++++
 arch/mips/include/asm/octeon/cvmx-gpio-defs.h      |  227 +++
 arch/mips/include/asm/octeon/cvmx-iob-defs.h       |  551 +++++
 arch/mips/include/asm/octeon/cvmx-ipd-defs.h       |  910 +++++++++
 arch/mips/include/asm/octeon/cvmx-l2c-defs.h       |  990 +++++++++
 arch/mips/include/asm/octeon/cvmx-l2c.h            |  328 +++
 arch/mips/include/asm/octeon/cvmx-l2d-defs.h       |  380 ++++
 arch/mips/include/asm/octeon/cvmx-l2t-defs.h       |  141 ++
 arch/mips/include/asm/octeon/cvmx-led-defs.h       |  252 +++
 arch/mips/include/asm/octeon/cvmx-mio-defs.h       | 2117 ++++++++++++++++++++
 arch/mips/include/asm/octeon/cvmx-packet.h         |   64 +
 arch/mips/include/asm/octeon/cvmx-platform.h       |   56 +
 arch/mips/include/asm/octeon/cvmx-pow-defs.h       |  720 +++++++
 arch/mips/include/asm/octeon/cvmx-spinlock.h       |  376 ++++
 arch/mips/include/asm/octeon/cvmx-sysinfo.h        |  144 ++
 arch/mips/include/asm/octeon/cvmx-warn.h           |   40 +
 arch/mips/include/asm/octeon/cvmx.h                |  776 +++++++
 arch/mips/include/asm/octeon/octeon-feature.h      |  120 ++
 arch/mips/include/asm/octeon/octeon-model.h        |  225 +++
 arch/mips/include/asm/octeon/octeon.h              |  245 +++
 arch/mips/include/asm/processor.h                  |   69 +
 arch/mips/include/asm/ptrace.h                     |    4 +
 arch/mips/include/asm/smp.h                        |    3 +
 arch/mips/include/asm/stackframe.h                 |   17 +
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
 drivers/serial/8250.c                              |  236 ++-
 drivers/serial/8250.h                              |    3 +
 drivers/serial/serial_core.c                       |    7 +-
 include/linux/serial_8250.h                        |    3 +
 include/linux/serial_core.h                        |    7 +-
 include/linux/serial_reg.h                         |    6 +
 81 files changed, 19315 insertions(+), 86 deletions(-)
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


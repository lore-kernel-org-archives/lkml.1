Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbZLUXZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbZLUXZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZLUXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:25:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:48976 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZLUXZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:25:17 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 10:25:02 +1100
Message-ID: <1261437902.2173.140.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some powerpc leftovers from the merge window. Mostly fixes,
plus a few embedded things that I didn't pull from Kumar in time.

Cheers,
Ben.

The following changes since commit 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f:
  Linus Torvalds (1):
        Linux 2.6.33-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Albert Herranz (3):
      powerpc/gamecube/wii: Fix off-by-one error in ugecon/usbgecko_udbg
      powerpc/gc/wii: hlwd-pic: convert irq_desc.lock to raw_spinlock
      powerpc/gc/wii: Remove get_irq_desc()

Alexey Dobriyan (1):
      powerpc/iseries: Convert to proc_fops

Anatolij Gustschin (1):
      powerpc/44x: Extend Katmai dts for ADMA and RAID56 support

Anton Blanchard (3):
      powerpc/defconfigs: Reduce 64bit vmlinux by making acenic and cramfs modules
      powerpc/defconfigs: Disable token ring in powerpc defconfigs
      powerpc/defconfigs: Set HZ=100 on pseries and ppc64 defconfigs

Anton Vorontsov (4):
      powerpc/fsl_pci: Fix P2P bridge handling for MPC83xx PCIe controllers
      powerpc/83xx/suspend: Clear deep_sleeping after devices resume
      powerpc/83xx/suspend: Save and restore SICRL, SICRH and SCCR
      powerpc/83xx: Add power management support for MPC8315E-RDB boards

Benjamin Herrenschmidt (4):
      powerpc/mm: Fix a WARN_ON() with CONFIG_DEBUG_PAGEALLOC and CONFIG_DEBUG_VM
      powerpc: Fix MSI support on U4 bridge PCIe slot
      Merge commit 'kumar/next' into merge
      Merge commit 'jwb/next' into merge

David Daney (1):
      powerpc: Convert BUG() to use unreachable()

David Gibson (1):
      powerpc/mm: Fix stupid bug in subpge protection handling

Dmitry Eremin-Solenikov (4):
      powerpc/83xx: mpc8349emitx - add gpio controller declarations
      powerpc/83xx: mpc8349emitx - populate I2C busses in device tree
      powerpc/83xx: mpc8349emitx - add OF descriptions of LocalBus devices
      powerpc/83xx: mpc8349emitx - add leds-gpio binding

Felix Radensky (1):
      powerpc/85xx: Workaround MPC8572/MPC8536 GPIO 1 errata.

Gautham R Shenoy (2):
      powerpc/pseries: Don't panic when H_PROD fails during cpu-online.
      powerpc/pseries: Make declarations of cpu_hotplug_driver_lock() ANSI compatible.

Mark Ware (1):
      powerpc/cpm2_pic: Allow correct flow_types for port C interrupts

Mel Gorman (1):
      powerpc/pseries: Select XICS and PCI_MSI PSERIES

Neil Campbell (1):
      powerpc: Handle VSX alignment faults correctly in little-endian mode

Peter Korsgaard (1):
      powerpc/gpio: support gpio_to_irq()

Robert Jennings (2):
      mm: Add notifier in pageblock isolation for balloon drivers
      powerpc: Make the CMM memory hotplug aware

Roel Kluin (1):
      powerpc/85xx: Wrong variable returned on error

Sachin P. Sant (1):
      powerpc/mm: Fix hash_utils_64.c compile errors with DEBUG enabled.

Sean MacLennan (1):
      powerpc/44x: Increase warp SD buffer

Sebastian Andrzej Siewior (1):
      powerpc/fsl: try to explain why the interrupt numbers are off by 16

Yang Li (2):
      powerpc/mm: Fix typo of cpumask_clear_cpu()
      powerpc/mpic: Fix problem that affinity is not updated

Yong Zhang (1):
      powerpc/iseries: use DECLARE_COMPLETION_ONSTACK for non-constant completion

 Documentation/powerpc/dts-bindings/fsl/mpic.txt    |   42 ++++
 arch/powerpc/boot/dts/katmai.dts                   |   52 ++++-
 arch/powerpc/boot/dts/mpc8315erdb.dts              |   27 ++
 arch/powerpc/boot/dts/mpc8349emitx.dts             |   82 +++++++-
 arch/powerpc/boot/dts/warp.dts                     |    2 +-
 arch/powerpc/boot/ugecon.c                         |    2 +-
 arch/powerpc/configs/g5_defconfig                  |    6 +-
 arch/powerpc/configs/iseries_defconfig             |    4 +-
 arch/powerpc/configs/ppc64_defconfig               |   14 +-
 arch/powerpc/configs/ppc64e_defconfig              |    4 +-
 arch/powerpc/configs/pseries_defconfig             |   14 +-
 arch/powerpc/include/asm/bug.h                     |    2 +-
 arch/powerpc/include/asm/gpio.h                    |    5 +-
 arch/powerpc/kernel/align.c                        |   63 ++++--
 arch/powerpc/mm/hash_utils_64.c                    |   12 +-
 arch/powerpc/mm/mmu_context_nohash.c               |    2 +-
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/powerpc/platforms/83xx/suspend.c              |   52 ++++-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    2 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c   |    2 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   10 +-
 arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c |    2 +-
 arch/powerpc/platforms/iseries/mf.c                |  147 +++++++-----
 arch/powerpc/platforms/iseries/viopath.c           |    2 +-
 arch/powerpc/platforms/pseries/Kconfig             |    2 +
 arch/powerpc/platforms/pseries/cmm.c               |  254 +++++++++++++++++++-
 arch/powerpc/platforms/pseries/dlpar.c             |    6 +-
 arch/powerpc/platforms/pseries/smp.c               |    4 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   28 ++-
 arch/powerpc/sysdev/fsl_pci.c                      |    8 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c                 |   21 ++-
 arch/powerpc/sysdev/mpic.c                         |   19 +-
 arch/powerpc/sysdev/mpic_msi.c                     |   11 +-
 arch/powerpc/sysdev/mpic_u3msi.c                   |   46 +++-
 drivers/base/memory.c                              |   19 ++
 include/linux/memory.h                             |   27 ++
 mm/page_alloc.c                                    |   57 ++++-
 37 files changed, 876 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpic.txt



Return-Path: <linux-kernel-owner+w=401wt.eu-S1767314AbXECCL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767314AbXECCL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767306AbXECCL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:11:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767314AbXECCLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:11:55 -0400
Date: Wed, 2 May 2007 19:09:16 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.21
Message-ID: <20070503020916.GA21316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of PCI patches against your 2.6.21 git tree.

They contain:
	- pci hotplug driver updates
	- MSI reworks and cleanups to try to get the PPC MSI code merged
	  eventually
	- removal of unneeded pci.h inclusion (the majority of all of
	  the different files this series touches).
	- other bugfixes and minor features.

All of these have been in the -mm tree for a month or so.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h

 Documentation/feature-removal-schedule.txt   |    7 -
 Documentation/pci.txt                        |   12 +-
 Documentation/power/pci.txt                  |    2 +-
 arch/alpha/kernel/err_common.c               |    1 -
 arch/alpha/kernel/err_ev6.c                  |    1 -
 arch/alpha/kernel/err_ev7.c                  |    1 -
 arch/arm/Kconfig                             |    1 +
 arch/i386/Kconfig                            |    1 +
 arch/i386/kernel/cpu/cpufreq/speedstep-lib.c |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-smi.c |    2 +-
 arch/i386/kernel/io_apic.c                   |    4 +-
 arch/i386/pci/fixup.c                        |    2 +-
 arch/i386/pci/i386.c                         |    4 +-
 arch/ia64/Kconfig                            |    1 +
 arch/ia64/sn/kernel/huberror.c               |    1 -
 arch/ia64/sn/kernel/msi_sn.c                 |    4 +-
 arch/ia64/sn/kernel/xpnet.c                  |    1 -
 arch/m68knommu/kernel/dma.c                  |    1 -
 arch/mips/lib/iomap.c                        |    1 -
 arch/powerpc/kernel/pci_64.c                 |    2 +-
 arch/powerpc/platforms/pseries/ras.c         |    1 -
 arch/ppc/8260_io/enet.c                      |    1 -
 arch/ppc/8260_io/fcc_enet.c                  |    1 -
 arch/ppc/8xx_io/enet.c                       |    1 -
 arch/ppc/syslib/ppc4xx_sgdma.c               |    1 -
 arch/sh64/mach-cayman/iomap.c                |    1 -
 arch/sparc64/Kconfig                         |    1 +
 arch/sparc64/kernel/pci.c                    |    4 +-
 arch/sparc64/kernel/pci_sun4v.c              |    4 +-
 arch/x86_64/Kconfig                          |    1 +
 arch/x86_64/kernel/io_apic.c                 |    4 +-
 arch/xtensa/kernel/xtensa_ksyms.c            |    1 -
 arch/xtensa/platform-iss/setup.c             |    1 -
 drivers/atm/adummy.c                         |    1 -
 drivers/base/dd.c                            |   41 +--
 drivers/char/agp/alpha-agp.c                 |    2 +-
 drivers/char/agp/parisc-agp.c                |    2 +-
 drivers/char/hw_random/via-rng.c             |    1 -
 drivers/char/pcmcia/synclink_cs.c            |    1 -
 drivers/char/tpm/tpm.h                       |    1 -
 drivers/char/watchdog/sc1200wdt.c            |    1 -
 drivers/char/watchdog/scx200_wdt.c           |    2 +-
 drivers/i2c/busses/i2c-at91.c                |    1 -
 drivers/i2c/busses/i2c-mpc.c                 |    1 -
 drivers/i2c/busses/i2c-pca-isa.c             |    1 -
 drivers/ieee1394/hosts.c                     |    1 -
 drivers/infiniband/core/cm.c                 |    1 -
 drivers/infiniband/core/iwcm.c               |    1 -
 drivers/infiniband/core/mad_priv.h           |    1 -
 drivers/infiniband/core/multicast.c          |    1 -
 drivers/infiniband/core/sa_query.c           |    1 -
 drivers/infiniband/core/user_mad.c           |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c       |    1 -
 drivers/infiniband/hw/ipath/ipath_layer.c    |    1 -
 drivers/infiniband/hw/ipath/ipath_stats.c    |    2 -
 drivers/infiniband/hw/ipath/ipath_sysfs.c    |    1 -
 drivers/infiniband/hw/mthca/mthca_memfree.h  |    1 -
 drivers/infiniband/ulp/ipoib/ipoib.h         |    1 -
 drivers/isdn/hisax/netjet.c                  |    1 -
 drivers/isdn/hysdn/hysdn_proclog.c           |    1 -
 drivers/media/dvb/cinergyT2/cinergyT2.c      |    2 +-
 drivers/media/video/adv7170.c                |    1 -
 drivers/media/video/adv7175.c                |    1 -
 drivers/media/video/bt819.c                  |    1 -
 drivers/media/video/bt856.c                  |    1 -
 drivers/media/video/bt866.c                  |    1 -
 drivers/media/video/cx88/cx88-tvaudio.c      |    1 -
 drivers/media/video/em28xx/em28xx-cards.c    |    1 -
 drivers/media/video/saa7111.c                |    1 -
 drivers/media/video/saa7114.c                |    1 -
 drivers/media/video/saa711x.c                |    1 -
 drivers/media/video/saa7185.c                |    1 -
 drivers/misc/hdpuftrs/hdpu_cpustate.c        |    1 -
 drivers/misc/hdpuftrs/hdpu_nexus.c           |    1 -
 drivers/mtd/devices/doc2000.c                |    1 -
 drivers/mtd/devices/doc2001.c                |    1 -
 drivers/mtd/devices/doc2001plus.c            |    1 -
 drivers/mtd/devices/docecc.c                 |    1 -
 drivers/mtd/inftlmount.c                     |    1 -
 drivers/mtd/nand/cs553x_nand.c               |    1 -
 drivers/mtd/nftlcore.c                       |    1 -
 drivers/net/atl1/atl1_param.c                |    1 -
 drivers/net/au1000_eth.c                     |    1 -
 drivers/net/fec_8xx/fec_main.c               |    1 -
 drivers/net/fec_8xx/fec_mii.c                |    1 -
 drivers/net/fs_enet/fs_enet-main.c           |    1 -
 drivers/net/fs_enet/mac-fcc.c                |    1 -
 drivers/net/fs_enet/mac-fec.c                |    1 -
 drivers/net/fs_enet/mac-scc.c                |    1 -
 drivers/net/fs_enet/mii-bitbang.c            |    1 -
 drivers/net/fs_enet/mii-fec.c                |    1 -
 drivers/net/ibm_emac/ibm_emac_core.c         |    1 -
 drivers/net/ixgb/ixgb_osdep.h                |    1 -
 drivers/net/lasi_82596.c                     |    1 -
 drivers/net/tokenring/madgemc.c              |    1 -
 drivers/net/tokenring/smctr.c                |    1 -
 drivers/net/tulip/21142.c                    |    1 -
 drivers/net/tulip/pnic.c                     |    1 -
 drivers/net/tulip/pnic2.c                    |    1 -
 drivers/net/tulip/timer.c                    |    1 -
 drivers/net/tulip/tulip.h                    |    1 +
 drivers/net/wan/lmc/lmc_media.c              |    1 -
 drivers/net/wan/lmc/lmc_proto.c              |    1 -
 drivers/net/wan/pc300_tty.c                  |    1 -
 drivers/parisc/hppb.c                        |    2 -
 drivers/pci/Kconfig                          |   31 +--
 drivers/pci/bus.c                            |    4 +-
 drivers/pci/hotplug/Kconfig                  |   25 +-
 drivers/pci/hotplug/cpcihp_zt5550.c          |    6 +-
 drivers/pci/hotplug/fakephp.c                |    2 +-
 drivers/pci/hotplug/pciehp.h                 |   19 +-
 drivers/pci/hotplug/pciehp_core.c            |   82 +---
 drivers/pci/hotplug/pciehp_ctrl.c            |  616 ++++++++++++--------------
 drivers/pci/hotplug/pciehp_hpc.c             |   34 +-
 drivers/pci/hotplug/rpadlpar_core.c          |   27 +-
 drivers/pci/hotplug/rpaphp.h                 |    8 +-
 drivers/pci/hotplug/rpaphp_core.c            |  200 ++++-----
 drivers/pci/hotplug/rpaphp_pci.c             |  167 +++-----
 drivers/pci/hotplug/rpaphp_slot.c            |   49 +--
 drivers/pci/hotplug/shpchp.h                 |    2 +-
 drivers/pci/hotplug/shpchp_core.c            |    2 +-
 drivers/pci/hotplug/shpchp_ctrl.c            |    2 +-
 drivers/pci/msi.c                            |  398 ++++++++---------
 drivers/pci/pci-driver.c                     |   19 +-
 drivers/pci/pci-sysfs.c                      |    9 +-
 drivers/pci/pci.c                            |   34 ++-
 drivers/pci/pci.h                            |    2 +
 drivers/pci/probe.c                          |   42 ++-
 drivers/pci/quirks.c                         |    2 +
 drivers/pci/search.c                         |    3 +-
 drivers/pci/setup-bus.c                      |   21 +-
 drivers/pci/setup-res.c                      |    6 +-
 drivers/pcmcia/cs.c                          |    1 -
 drivers/pcmcia/socket_sysfs.c                |    1 -
 drivers/sbus/sbus.c                          |    1 -
 drivers/scsi/aacraid/dpcsup.c                |    1 -
 drivers/scsi/aacraid/sa.c                    |    1 -
 drivers/scsi/aha1542.c                       |    1 -
 drivers/scsi/aic94xx/aic94xx_scb.c           |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c            |    1 -
 drivers/scsi/libsas/sas_expander.c           |    1 -
 drivers/scsi/libsrp.c                        |    1 -
 drivers/scsi/megaraid.c                      |    2 +-
 drivers/usb/net/kaweth.c                     |    1 -
 drivers/video/aty/radeon_i2c.c               |    1 -
 drivers/video/g364fb.c                       |    1 -
 drivers/video/platinumfb.c                   |    1 -
 drivers/video/stifb.c                        |    1 -
 drivers/video/valkyriefb.c                   |    1 -
 include/asm-alpha/scatterlist.h              |    1 +
 include/asm-arm/arch-ixp4xx/dma.h            |    1 -
 include/asm-avr32/scatterlist.h              |    2 +
 include/asm-frv/scatterlist.h                |    2 +
 include/asm-h8300/scatterlist.h              |    2 +
 include/asm-i386/scatterlist.h               |    2 +
 include/asm-ia64/scatterlist.h               |    2 +
 include/asm-m32r/scatterlist.h               |    2 +
 include/asm-m68knommu/scatterlist.h          |    1 +
 include/asm-mips/scatterlist.h               |    2 +
 include/asm-parisc/scatterlist.h             |    1 +
 include/asm-sh/scatterlist.h                 |    2 +
 include/asm-sh64/scatterlist.h               |    2 +
 include/asm-sparc64/scatterlist.h            |    1 +
 include/asm-v850/scatterlist.h               |    2 +
 include/asm-x86_64/scatterlist.h             |    2 +
 include/asm-xtensa/scatterlist.h             |    2 +
 include/linux/device.h                       |    1 -
 include/linux/msi.h                          |   11 +-
 include/linux/pci.h                          |   27 +-
 include/rdma/ib_mad.h                        |    2 -
 kernel/irq/chip.c                            |    3 +
 sound/core/init.c                            |    1 -
 sound/oss/au1550_ac97.c                      |    1 -
 sound/oss/soundcard.c                        |    1 +
 sound/pci/ca0106/ca0106_mixer.c              |    2 +-
 sound/pci/ca0106/ca0106_proc.c               |    2 +-
 sound/pci/cs46xx/dsp_spos.c                  |    1 -
 sound/pci/cs46xx/dsp_spos_scb_lib.c          |    1 -
 sound/pci/hda/hda_generic.c                  |    1 -
 sound/pci/hda/hda_proc.c                     |    1 -
 sound/pci/hda/patch_atihdmi.c                |    1 -
 sound/pci/hda/patch_si3054.c                 |    1 -
 sound/pci/hda/patch_via.c                    |    1 -
 183 files changed, 881 insertions(+), 1226 deletions(-)

---------------

Adrian Bunk (2):
      PCI: remove the broken PCI_MULTITHREAD_PROBE option
      PCI: the overdue removal of pci_module_init()

Brian King (1):
      pci: New PCI-E reset API

Chuck Ebbert (1):
      PCI: add debug information to resource collision message

Dan Williams (1):
      msi: introduce ARCH_SUPPORTS_MSI Kconfig option (rev2)

Jan Engelhardt (1):
      PCI hotplug: Use menuconfig objects

Jean Delvare (3):
      PCI: scatterlist.h needs types.h
      PCI: Cleanup the includes of <linux/pci.h>
      PCI: Require vendor and device for new_id

Jesse Barnes (1):
      PCI: fix sysfs rom file creation for BIOS ROM shadows

Kenji Kaneshige (2):
      pciehp: Event handling rework
      pciehp: Adapt to device driver model

Kristen Carlson Accardi (1):
      PCI: fix multiple definition of `queue_pushbutton_work'

Linas Vepstas (19):
      PCI: rpaphp: Cleanup flow of control for rpaphp_add_slot
      PCI: rpaphp: Remove global num_slots variable
      PCI: rpaphp: match up alloc and free in same routine
      PCI: rpaphp: Fix a memleak; slot->location string was never freed
      PCI: rpaphp: Remove un-needed goto
      PCI: rpaphp: remove a function that does nothing but wrap debug printks
      PCI: rpaphp: Remve another call that is a wrapper
      PCI: rpaphp: Remove another wrappered function
      PCI: rpaphp: remove a call that does nothing but a pointer lookup
      PCI: rpaphp: Remove setup_pci_slot()
      PCI: rpaphp: remove print_slot_pci_funcs()
      PCI: rpaphp: remove rpaphp_set_attention_status()
      PCI: rpaphp: refactor tail call to rpaphp_register_slot()
      PCI: rpaphp: Rename rpaphp_register_pci_slot() to rpaphp_enable_slot()
      PCI: rpaphp: Document find_php_slot()
      PCI: rpaphp: Document is_php_dn()
      PCI: rpaphp: Use pcibios_remove_pci_devices() symmetrically
      PCI: rpaphp: Ensure more pcibios_add/pcibios_remove symmetry
      PCI: rpaphp: Remove semaphores

Michael Ellerman (20):
      MSI: Simplify BUG() handling in pci_disable_msi()
      MSI: Simplify BUG() handling in pci_disable_msix()
      MSI: Simplify BUG() handling in msi_remove_pci_irq_vectors() part 1
      MSI: Simplify BUG() handling in msi_remove_pci_irq_vectors() part 2
      MSI: Consolidate MSI-X irq freeing code
      MSI: Consolidate BUG_ON()s.
      MSI: Move EXPORT_SYMBOL()s near their definition
      MSI: Remove msi_cache
      MSI: Expand pci_msi_supported()
      MSI: Consolidate precondition checks
      MSI: Rename pci_msi_supported() to pci_msi_check_device()
      MSI: Add an arch_msi_check_device()
      PCI: Create alloc_pci_dev(), the one true way to create a struct pci_dev
      PCI: Convert to alloc_pci_dev()
      MSI: Use a list instead of the custom link structure
      MSI: Remove dev->first_msi_irq
      MSI: arch must connect the irq and the msi_desc
      MSI: Give archs the option to allocate all MSI/Xs at once.
      MSI: Give archs the option to free all MSI/Xs at once.
      PCI: Free resource files in error path of pci_create_sysfs_dev_files()

Mitch Williams (1):
      PCI: Flush MSI-X table writes

Randy Dunlap (2):
      PCI: kernel-doc fix
      PCI Documentation: power/pci.txt fix copy/paste error

Sam Ravnborg (1):
      pci: do not mark exported functions as __devinit

Scott Murray (1):
      PCI: ZT5550 CPCI Hotplug driver fix

Sergei Shtylyov (1):
      PCI: define pci_request/release_regions() for CONFIG_PCI=n

Tejun Heo (1):
      pci-quirks: disable MSI on RS400-200 and RS480


Return-Path: <linux-kernel-owner+w=401wt.eu-S934913AbXGKXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913AbXGKXbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbXGKXbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:31:18 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49795 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbXGKXbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:31:16 -0400
Date: Wed, 11 Jul 2007 16:30:37 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.22
Message-ID: <20070711233037.GB5253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of PCI and PCI hotplug patches against your 2.6.22 git
tree.

They contain:
	- pci hotplug driver updates
	- pci api cleanups and additions
	- other bugfixes and minor features.

All of these have been in the -mm tree for a month or so.

Overall this patch series removes 600+ lines of code, which is always
nice to see :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h

 Documentation/DMA-mapping.txt                  |  103 ------------
 Documentation/pci.txt                          |    8 +-
 Documentation/power/pci.txt                    |   37 -----
 MAINTAINERS                                    |    5 -
 arch/alpha/Kconfig                             |    3 +
 arch/alpha/kernel/pci_iommu.c                  |   32 +----
 arch/arm/Kconfig                               |    3 +
 arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c |    6 +-
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c      |    4 +-
 arch/i386/kernel/cpu/cpufreq/speedstep-ich.c   |    4 +-
 arch/i386/mach-visws/traps.c                   |    4 +-
 arch/i386/pci/fixup.c                          |    9 +-
 arch/ia64/Kconfig                              |    6 +-
 arch/mips/pci/Makefile                         |    2 +-
 arch/mips/pci/fixup-cobalt.c                   |   10 +-
 arch/mips/pci/pci-dac.c                        |   79 ----------
 arch/powerpc/Kconfig                           |    6 +-
 arch/powerpc/kernel/pci_32.c                   |    4 +-
 arch/powerpc/kernel/pci_64.c                   |    6 +-
 arch/ppc/Kconfig                               |    6 +-
 arch/ppc/kernel/pci.c                          |    6 -
 arch/sparc/Kconfig                             |    3 +
 arch/sparc64/Kconfig                           |    6 +-
 arch/sparc64/kernel/pci.c                      |    1 +
 arch/x86_64/kernel/pci-dma.c                   |    3 +-
 drivers/acpi/processor_core.c                  |    7 +-
 drivers/ata/ata_piix.c                         |    6 +-
 drivers/ata/pata_ali.c                         |   34 ++---
 drivers/ata/pata_amd.c                         |    4 +-
 drivers/ata/pata_cs5530.c                      |    2 +-
 drivers/ata/pata_it821x.c                      |    3 +-
 drivers/ata/pata_serverworks.c                 |    5 +-
 drivers/ata/pata_sis.c                         |    8 +-
 drivers/ata/pata_sl82c105.c                    |    5 +-
 drivers/ata/pata_via.c                         |    6 +-
 drivers/ata/sata_mv.c                          |   20 +--
 drivers/atm/eni.c                              |    9 +-
 drivers/atm/idt77252.c                         |   13 +--
 drivers/atm/iphase.c                           |   11 +-
 drivers/atm/lanai.c                            |   27 +---
 drivers/atm/zatm.c                             |    6 +-
 drivers/char/agp/amd-k7-agp.c                  |    4 +-
 drivers/char/agp/amd64-agp.c                   |    6 +-
 drivers/clocksource/acpi_pm.c                  |    5 +-
 drivers/i2c/busses/i2c-viapro.c                |    3 +-
 drivers/ide/pci/alim15x3.c                     |    2 +-
 drivers/ide/pci/amd74xx.c                      |    8 +-
 drivers/ide/pci/cmd64x.c                       |    9 +-
 drivers/ide/pci/cs5530.c                       |    2 +-
 drivers/ide/pci/hpt366.c                       |   20 +--
 drivers/ide/pci/piix.c                         |    6 +-
 drivers/ide/pci/serverworks.c                  |   13 +--
 drivers/ide/pci/sis5513.c                      |    8 +-
 drivers/ide/pci/sl82c105.c                     |    4 +-
 drivers/ide/pci/via82cxxx.c                    |    9 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |    9 +-
 drivers/isdn/hisax/bkm_a8.c                    |    4 +-
 drivers/media/radio/radio-gemtek-pci.c         |    4 +-
 drivers/media/video/meye.c                     |    4 +-
 drivers/net/8139cp.c                           |    7 +-
 drivers/net/8139too.c                          |    7 +-
 drivers/net/atl1/atl1.h                        |    1 -
 drivers/net/atl1/atl1_main.c                   |    4 -
 drivers/net/bnx2.c                             |    5 +-
 drivers/net/cassini.c                          |   12 +-
 drivers/net/dl2k.c                             |    3 +-
 drivers/net/dl2k.h                             |    1 -
 drivers/net/e100.c                             |    8 +-
 drivers/net/e1000/e1000_main.c                 |    3 +-
 drivers/net/forcedeth.c                        |    4 +-
 drivers/net/netxen/netxen_nic_main.c           |    7 +-
 drivers/net/s2io.c                             |   25 +---
 drivers/net/s2io.h                             |    1 -
 drivers/net/starfire.c                         |    2 +-
 drivers/net/sundance.c                         |    7 +-
 drivers/net/sunhme.c                           |    8 +-
 drivers/net/tg3.c                              |    6 +-
 drivers/net/tlan.c                             |    5 +-
 drivers/net/tulip/de4x5.c                      |    8 +-
 drivers/net/tulip/dmfe.c                       |   26 ++--
 drivers/net/tulip/tulip_core.c                 |   15 +--
 drivers/net/tulip/xircom_cb.c                  |    5 +-
 drivers/net/tulip/xircom_tulip_cb.c            |    4 +-
 drivers/net/typhoon.c                          |    7 -
 drivers/net/via-rhine.c                        |   13 +-
 drivers/net/via-velocity.c                     |    3 +-
 drivers/net/wan/pc300_drv.c                    |    4 +-
 drivers/net/wan/pc300too.c                     |    2 -
 drivers/net/wan/pci200syn.c                    |    2 -
 drivers/net/wireless/bcm43xx/bcm43xx_main.c    |    6 +-
 drivers/net/wireless/hostap/hostap_pci.c       |    2 -
 drivers/net/wireless/hostap/hostap_plx.c       |    3 -
 drivers/net/wireless/prism54/islpci_hotplug.c  |    4 +-
 drivers/pci/Makefile                           |    4 +-
 drivers/pci/hotplug/acpiphp.h                  |    1 +
 drivers/pci/hotplug/acpiphp_core.c             |    6 +-
 drivers/pci/hotplug/acpiphp_glue.c             |   53 ++++++-
 drivers/pci/hotplug/cpci_hotplug_core.c        |   66 +++------
 drivers/pci/hotplug/cpci_hotplug_pci.c         |    2 -
 drivers/pci/hotplug/cpqphp_core.c              |   12 +-
 drivers/pci/hotplug/pciehp.h                   |    1 +
 drivers/pci/hotplug/pciehp_ctrl.c              |   12 ++
 drivers/pci/hotplug/pciehp_hpc.c               |  191 ++++++++++++-----------
 drivers/pci/pci-acpi.c                         |    8 +-
 drivers/pci/pci-sysfs.c                        |   11 ++-
 drivers/pci/pci.c                              |  200 ++++++++++++++++++++++--
 drivers/pci/pcie/aer/Kconfig                   |    2 +-
 drivers/pci/pcie/aer/Makefile                  |    3 +-
 drivers/pci/pcie/aer/aerdrv.c                  |    2 +-
 drivers/pci/pcie/aer/aerdrv.h                  |   14 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c             |   36 ++--
 drivers/pci/pcie/aer/aerdrv_core.c             |   34 ++--
 drivers/pci/probe.c                            |    3 +-
 drivers/pci/proc.c                             |    1 -
 drivers/pci/quirks.c                           |   30 +++--
 drivers/pci/search.c                           |    7 +-
 drivers/pci/setup-bus.c                        |    8 +-
 drivers/pci/syscall.c                          |   20 ++-
 drivers/scsi/aic94xx/aic94xx_init.c            |    9 +-
 drivers/scsi/ipr.c                             |   22 +--
 drivers/scsi/ips.c                             |    9 +-
 drivers/scsi/lpfc/lpfc_init.c                  |    5 +-
 drivers/scsi/nsp32.c                           |   10 --
 drivers/scsi/qla2xxx/qla_init.c                |    2 +-
 drivers/serial/jsm/jsm_driver.c                |    2 +-
 drivers/usb/gadget/net2280.c                   |    2 +-
 drivers/usb/host/ehci-pci.c                    |    3 +-
 drivers/video/kyro/STG4000InitDevice.c         |    5 +-
 drivers/video/matrox/matroxfb_base.c           |    4 +-
 drivers/video/sis/sis_main.c                   |    2 +-
 drivers/video/sstfb.c                          |    2 +-
 drivers/video/tgafb.c                          |    3 +-
 include/asm-alpha/pci.h                        |   29 ----
 include/asm-arm/pci.h                          |    9 -
 include/asm-cris/pci.h                         |   36 -----
 include/asm-frv/pci.h                          |    7 -
 include/asm-h8300/pci.h                        |    4 -
 include/asm-i386/pci.h                         |   37 -----
 include/asm-ia64/pci.h                         |   12 --
 include/asm-m68k/pci.h                         |    4 -
 include/asm-m68knommu/pci.h                    |   10 --
 include/asm-mips/pci.h                         |   18 --
 include/asm-parisc/pci.h                       |    7 -
 include/asm-powerpc/dma-mapping.h              |    1 -
 include/asm-powerpc/pci.h                      |   20 ---
 include/asm-ppc/pci.h                          |    8 -
 include/asm-sh/pci.h                           |    9 -
 include/asm-sh64/pci.h                         |    9 -
 include/asm-sparc/pci.h                        |    6 -
 include/asm-sparc64/pci.h                      |   47 ------
 include/asm-v850/pci.h                         |    4 -
 include/asm-v850/rte_cb.h                      |    1 -
 include/asm-x86_64/pci.h                       |   44 -----
 include/asm-xtensa/pci.h                       |    7 -
 include/linux/aer.h                            |   10 +-
 include/linux/pci.h                            |   16 ++-
 include/linux/pci_ids.h                        |   74 ++-------
 sound/oss/emu10k1/main.c                       |    2 +-
 sound/oss/es1371.c                             |    2 +-
 sound/pci/ali5451/ali5451.c                    |    2 +-
 sound/pci/atiixp.c                             |    6 +-
 sound/pci/atiixp_modem.c                       |    5 +-
 sound/pci/au88x0/au88x0.c                      |    6 +-
 sound/pci/ca0106/ca0106.h                      |    1 -
 sound/pci/ca0106/ca0106_main.c                 |    5 +-
 sound/pci/emu10k1/emu10k1_main.c               |    4 +-
 sound/pci/emu10k1/emu10k1x.c                   |    2 +-
 sound/pci/ens1370.c                            |    4 +-
 sound/pci/fm801.c                              |    4 +-
 sound/pci/via82xx.c                            |   14 +-
 sound/pci/via82xx_modem.c                      |    4 +-
 sound/pci/ymfpci/ymfpci_main.c                 |    2 +-
 172 files changed, 760 insertions(+), 1401 deletions(-)
 delete mode 100644 arch/mips/pci/pci-dac.c

---------------

Adrian Bunk (1):
      PCI: unexport pci_proc_attach_device

Alan Cox (2):
      pci syscall.c: Switch to refcounting API
      + pci_find_slot-mark-deprecated.patch added to -mm tree

Andrew Lunn (1):
      PCI: pci_set_power_state(): check for PM capabilities earlier

Andrew Morton (1):
      PCI: pci-x-pci-express-read-control-interfaces cleanups

Auke Kok (2):
      PCI: read revision ID by default
      PCI: Change all drivers to use pci_device->revision

David Brownell (1):
      PCI: remove useless pci driver method

Gary Hade (3):
      PCI: hotplug: acpiphp: fix slot poweroff problem on systems without _PS3
      PCI: hotplug: acpiphp: remove hot plug parameter write to PCI host bridge
      PCI: hotplug: acpiphp: avoid acpiphp "cannot get bridge info" PCI hotplug failure

Greg Kroah-Hartman (2):
      PCI: remove cpqphp driver maintainer
      PCI: point people to Bernhard instead of the linux-kernel list

Jan Beulich (1):
      PCI: remove pci_dac_dma_... APIs

Jiri Slaby (5):
      PCI: ATM: lanai, change VENDOR to DEVICE
      PCI: i386: traps, change VENDOR to DEVICE
      PCI: pci_ids, reorder some entries
      PCI: pci_ids, add atheros and 3com_2 vendors
      PCI: pci_ids, remove double or more empty lines

Kenji Kaneshige (2):
      PCI: hotplug: pciehp: Fix possible race condition in writing slot
      PCI: hotplug: pciehp: wait for 1 second after power off slot

Matthew Wilcox (1):
      PCI: Only build PCI syscalls on architectures that want them

Michael Ellerman (2):
      PCI: Use a weak symbol for the empty version of pcibios_add_platform_entries()
      PCI: Make pcibios_add_platform_entries() return errors

Milind Arun Choudhary (2):
      PCI: ROUND_UP macro cleanup in drivers/pci
      PCI: pcie: remove SPIN_LOCK_UNLOCKED

Peter Oruba (1):
      PCI: add PCI-X/PCI-Express read control interfaces

Randy Dunlap (2):
      PCI: add pci_try_set_mwi
      PCI: limit pci_get_bus_and_slot to domain 0

Rolf Eike Beer (1):
      PCI: Fix typo in include/linux/pci.h

Scott Murray (1):
      PCI: cpci_hotplug: Convert to use the kthread API

Stephen Hemminger (2):
      PCI aer: fix stub return values
      PCI aer: add pci_cleanup_aer_correct_aer_status

Zhang, Yanmin (1):
      PCI: fix AER driver error information


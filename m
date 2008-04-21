Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYDUGQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYDUGQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYDUGQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:16:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:58555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYDUGQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:16:14 -0400
Date: Sun, 20 Apr 2008 23:21:39 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.25-git
Message-ID: <20080421062139.GA4901@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI and PCI hotplug patches against your 2.6.25 git tree.

They contain:
	- documentation movement into a new directory
	- pci section warning fixes
	- more generic PCI code for some arches
	- removal of the duplicated list of all PCI devices in the system
	- second go-around for the PCI ASPM code
	- various bugs and other minor stuff
	- change the PCI maintainer

All of these have been in the linux-next and -mm tree for quite a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 Documentation/00-INDEX                         |   10 -
 Documentation/ABI/testing/sysfs-bus-pci        |   11 +
 Documentation/PCI/00-INDEX                     |   12 +
 Documentation/{ => PCI}/PCIEBUS-HOWTO.txt      |   12 +-
 Documentation/{ => PCI}/pci-error-recovery.txt |    0 
 Documentation/{ => PCI}/pci.txt                |    2 +-
 Documentation/{ => PCI}/pcieaer-howto.txt      |    2 +-
 Documentation/kernel-parameters.txt            |    8 +-
 Documentation/memory-barriers.txt              |    4 +-
 MAINTAINERS                                    |    5 +-
 arch/alpha/kernel/pci.c                        |   23 +-
 arch/frv/mb93090-mb00/pci-frv.h                |    2 -
 arch/frv/mb93090-mb00/pci-vdk.c                |   53 --
 arch/ia64/pci/pci.c                            |   44 +--
 arch/mn10300/unit-asb2305/pci-asb2305.h        |    2 -
 arch/parisc/kernel/pci.c                       |   30 +-
 arch/powerpc/kernel/pci-common.c               |   34 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c     |    7 +-
 arch/ppc/kernel/pci.c                          |   59 +--
 arch/sh/drivers/pci/pci-sh4.h                  |    2 -
 arch/x86/kernel/pci-calgary_64.c               |    3 +-
 arch/x86/pci/acpi.c                            |   11 +-
 arch/x86/pci/common.c                          |   63 +--
 arch/x86/pci/i386.c                            |   38 --
 arch/x86/pci/pcbios.c                          |   72 ---
 arch/x86/pci/pci.h                             |    4 -
 drivers/parisc/dino.c                          |    1 -
 drivers/pci/access.c                           |  166 +++++
 drivers/pci/bus.c                              |   15 +-
 drivers/pci/hotplug/Kconfig                    |    4 +-
 drivers/pci/hotplug/acpi_pcihp.c               |   24 +-
 drivers/pci/hotplug/acpiphp_core.c             |   18 +-
 drivers/pci/hotplug/acpiphp_glue.c             |   38 +-
 drivers/pci/hotplug/acpiphp_ibm.c              |   36 +-
 drivers/pci/hotplug/cpci_hotplug_core.c        |   60 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c         |   10 +-
 drivers/pci/hotplug/cpcihp_generic.c           |    8 +-
 drivers/pci/hotplug/cpqphp.h                   |    6 +-
 drivers/pci/hotplug/cpqphp_core.c              |   38 +-
 drivers/pci/hotplug/cpqphp_ctrl.c              |   64 +-
 drivers/pci/hotplug/cpqphp_nvram.c             |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c               |    8 +-
 drivers/pci/hotplug/fakephp.c                  |    4 +-
 drivers/pci/hotplug/ibmphp_core.c              |   30 +-
 drivers/pci/hotplug/ibmphp_ebda.c              |   92 ++--
 drivers/pci/hotplug/ibmphp_hpc.c               |   68 +-
 drivers/pci/hotplug/ibmphp_pci.c               |   18 +-
 drivers/pci/hotplug/ibmphp_res.c               |   12 +-
 drivers/pci/hotplug/pci_hotplug_core.c         |    2 +-
 drivers/pci/hotplug/pciehp.h                   |    2 +-
 drivers/pci/hotplug/pciehp_core.c              |   32 +-
 drivers/pci/hotplug/pciehp_ctrl.c              |   34 +-
 drivers/pci/hotplug/pciehp_hpc.c               |  144 +++---
 drivers/pci/hotplug/pciehp_pci.c               |    8 +-
 drivers/pci/hotplug/pcihp_skeleton.c           |   18 +-
 drivers/pci/hotplug/rpadlpar_core.c            |   20 +-
 drivers/pci/hotplug/rpaphp_core.c              |    6 +-
 drivers/pci/hotplug/rpaphp_pci.c               |   14 +-
 drivers/pci/hotplug/rpaphp_slot.c              |    6 +-
 drivers/pci/hotplug/sgi_hotplug.c              |    8 +-
 drivers/pci/hotplug/shpchp.h                   |    6 +-
 drivers/pci/hotplug/shpchp_core.c              |   26 +-
 drivers/pci/hotplug/shpchp_ctrl.c              |   46 +-
 drivers/pci/hotplug/shpchp_hpc.c               |   64 +-
 drivers/pci/hotplug/shpchp_pci.c               |    4 +-
 drivers/pci/intel-iommu.c                      |  151 ++++-
 drivers/pci/iova.c                             |   50 +-
 drivers/pci/pci-sysfs.c                        |  114 +++-
 drivers/pci/pci.c                              |    6 +-
 drivers/pci/pci.h                              |   19 +
 drivers/pci/pcie/Kconfig                       |   20 +
 drivers/pci/pcie/Makefile                      |    3 +
 drivers/pci/pcie/aer/aerdrv.c                  |    4 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c             |    5 +-
 drivers/pci/pcie/aer/aerdrv_core.c             |    5 +-
 drivers/pci/pcie/aspm.c                        |  811 ++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c                |    4 +-
 drivers/pci/pcie/portdrv_pci.c                 |    2 +-
 drivers/pci/probe.c                            |   80 +--
 drivers/pci/quirks.c                           |   17 +-
 drivers/pci/remove.c                           |   14 +-
 drivers/pci/search.c                           |  313 ++++------
 drivers/pci/setup-bus.c                        |    9 +-
 drivers/pci/setup-res.c                        |   87 ++-
 include/asm-sh/mpc1211/pci.h                   |    2 -
 include/linux/aer.h                            |    5 -
 include/linux/ioport.h                         |    5 +-
 include/linux/pci-aspm.h                       |   56 ++
 include/linux/pci.h                            |   30 +-
 include/linux/pci_regs.h                       |    8 +
 kernel/resource.c                              |   18 +
 91 files changed, 2213 insertions(+), 1300 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci
 create mode 100644 Documentation/PCI/00-INDEX
 rename Documentation/{ => PCI}/PCIEBUS-HOWTO.txt (98%)
 rename Documentation/{ => PCI}/pci-error-recovery.txt (100%)
 rename Documentation/{ => PCI}/pci.txt (99%)
 rename Documentation/{ => PCI}/pcieaer-howto.txt (99%)
 create mode 100644 drivers/pci/pcie/aspm.c
 create mode 100644 include/linux/pci-aspm.h

---------------

Adrian Bunk (7):
      PCI: #if 0 pci_assign_resource_fixed()
      PCI: #if 0 pci_cleanup_aer_correct_error_status()
      PCI: aerdrv_acpi.c: remove unneeded NULL check
      PCI: pci_alloc_child_bus() mustn't be __devinit
      PCI: pci_scan_device() mustn't be __devinit
      PCI: pci_bus_size_cardbus() mustn't be __devinit
      PCI: pci_setup_bridge() mustn't be __devinit

Ben Hutchings (1):
      PCI: Expose PCI VPD through sysfs

Bjorn Helgaas (9):
      PCI: remove "pci=routeirq" noise from dmesg
      PCI: add generic pci_enable_resources()
      PCI: x86: use generic pci_enable_resources()
      PCI: alpha: use generic pci_enable_resources()
      PCI: ia64: use generic pci_enable_resources()
      PCI: powerpc: use generic pci_enable_resources()
      PCI: ppc: use generic pci_enable_resources()
      PCI: parisc: use generic pci_enable_resources()
      PCI: simplify quirk debug output

Gary Hade (1):
      PCI: Include PCI domain in PCI bus names on x86/x86_64

Greg Kroah-Hartman (12):
      PCI: remove pci_find_present
      PCI: remove pci_get_device_reverse from calgary driver
      PCI: remove pci_get_device_reverse
      PCI: clean up search.c a lot
      PCI Hotplug: make cpcihp driver use modern apis
      PCI Hotplug: the ibm driver is not dependant on PCI_LEGACY
      PCI: remove initial bios sort of PCI devices on x86
      PCI: make no_pci_devices() use the pci_bus_type list
      PCI: add is_added flag to struct pci_dev
      PCI: remove pcibios_fixup_ghosts()
      PCI: remove global list of PCI devices
      PCI: Change PCI subsystem MAINTAINER

Harvey Harrison (1):
      PCI: replace remaining __FUNCTION__ occurrences

Ivan Kokshaysky (1):
      PCI: clean up resource alignment management

James Bottomley (1):
      PCI: remove parisc consumer of the pci global_list

Jesper Juhl (1):
      PCI: Hotplug: Fix leaks in IBM Hot Plug Controller Driver - ibmphp_init_devno()

Randy Dunlap (1):
      PCI: doc/pci: create Documentation/PCI/ and move files into it

Shaohua Li (1):
      PCI: add PCI Express ASPM support

Tim Yamin (1):
      PCI: Update VIA CX700 quirk

Trent Piepho (1):
      PCI: Hotplug: fakephp: Return success, not ENODEV, when bus rescan is triggered

Yinghai Lu (1):
      PCI: pcie AER: don't check _OSC when acpi is disabled

mark gross (3):
      PCI: iova RB tree setup tweak
      PCI: iommu: iotlb flushing
      PCI: pci-iommu-iotlb-flushing-speedup


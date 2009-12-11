Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZLKTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZLKTCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761019AbZLKTCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:02:34 -0500
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:40222 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760499AbZLKTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:02:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=h8TF7qwdd5V6tWgrAPnvM27EpQCh5fs3WDMPPGAJzbP4Q3gA7J1suYkGxAzLjY60TddBWWb65KDeLQFiU4dWsPZtuE48X1zZXmq84dTf0JlW4FEJ0q1UnE3WnTsOqsrq;
Date: Fri, 11 Dec 2009 11:02:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes for 2.6.33
Message-ID: <20091211110222.0ae1d897@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

I've got a section mismatch in here, but the fix will be part of the next
pull req (updated patch just came in recently).

Probably the biggest change here (at least my change count) is Bjorn's
MMCONFIG rework.  It sets the stage for hot plugging of host bridges and
_CBA and includes some nice cleanups besides.

Aside from that we have the usual set of PCI hotplug changes (Kenji-san is
slowly making the PCIe hotplug and port driver code sane) and a bunch of
bug fixes (some too invasive to make 2.6.32 and some that just came in too
late).

There will be one more pull req. with a small feature addition to allow for
per-device PCI reset functionality, needed for some USB and virtual devices.
It's had review though (it's a fairly old patchset), just didn't make it into
linux-next in time for this pull request due to timing of comment feedback
and slowness on my part.

Alex Chiang (2):
      PCI Hotplug: acpiphp: clean up list traversals
      x86/PCI: remove early PCI pr_debug statements

Alex Williamson (1):
      PCI: Always set prefetchable base/limit upper32 registers

Allen Kay (2):
      PCI: acs p2p upsteram forwarding enabling
      PCI: add xen dom0 checking before ACS initialization

Andreas Herrmann (1):
      PCI: derive nearby CPUs from device's instead of bus' NUMA information

Andrew Patterson (6):
      PCI: add pci_get_domain_bus_and_slot function
      PCI: add support for PCI domains to aer_inject
      PCI: use better error return values in aer_inject
      PCI: fix memory leak in aer_inject
      PCI: unconditionally clear AER uncorr status register during cleanup
      PCI: remove ifdefed pci_cleanup_aer_correct_error_status

Bjorn Helgaas (37):
      vsprintf: fix io/mem resource width
      vsprintf: add %pR support for IRQ and DMA resources
      vsprintf: add %pRt, %pRf to print struct resource details
      PCI: print resources consistently with %pRt
      x86/PCI: print resources consistently with %pRt
      ia64/PCI: print resources consistently with %pRt
      PNP: print resources consistently with %pRt
      x86/PCI: allow MMCONFIG above 4GB
      x86/PCI: use -DDEBUG when CONFIG_PCI_DEBUG set
      PCI hotplug: move IOAPIC support from acpiphp to ioapic driver
      vsprintf: use %pR, %pr instead of %pRt, %pRf
      PCI: make PME# messages KERN_DEBUG
      x86/PCI: print domain:bus in conventional format
      PCI: replace pr_debug with dev_dbg
      PCI: improve discovery/configuration messages
      x86/PCI: for debuggability, show host bridge windows even when ignoring _CRS
      x86/PCI: fix bogus host bridge window start/end alignment from _CRS
      resources: when allocate_resource() fails, leave resource untouched
      x86/PCI: remove 64-bit division
      x86/PCI: MMCONFIG: remove unused definitions
      x86/PCI: MMCONFIG: count MCFG structures with local variable
      x86/PCI: MMCONFIG: step through MCFG table, not pci_mmcfg_config[]
      x86/PCI: MMCONFIG: centralize MCFG structure management
      x86/PCI: MMCONFIG: simplify tests for empty pci_mmcfg_config table
      x86/PCI: MMCONFIG: reject MMCONFIG apertures at address zero
      x86/PCI: MMCONFIG: add PCI_MMCFG_BUS_OFFSET() to factor common expression
      x86/PCI: MMCONFIG: use a private structure rather than the ACPI MCFG one
      x86/PCI: MMCONFIG: rename pci_mmcfg_region structure members
      x86/PCI: MMCONFIG: use pointer to simplify pci_mmcfg_config[] structure access
      x86/PCI: MMCONFIG: add resource to struct pci_mmcfg_region
      x86/PCI: MMCONFIG: trivial is_mmconf_reserved() interface simplification
      x86/PCI: MMCONFIG: add virtual address to struct pci_mmcfg_region
      x86/PCI: MMCONFIG: remove typeof so we can use a list
      x86/PCI: MMCONFIG: manage pci_mmcfg_region as a list, not a table
      x86/PCI: MMCONFIG: add pci_mmconfig_remove() to remove MMCONFIG region
      x86/PCI: MMCONFIG: clean up printks
      x86/PCI: MMCONFIG: add lookup function

Chris Wright (1):
      PCI: add pci_request_acs

Dave Jones (1):
      x86/PCI: Use generic cacheline sizing instead of per-vendor tests.

Gabe Black (1):
      PCI: populate subsystem vendor and device IDs for PCI bridges

Isaku Yamahata (1):
      ia64/xen: compilation fix

Jeremy Fitzhardinge (1):
      xen: move Xen-testing predicates to common header

Jesse Barnes (2):
      PCI: determine CLS more intelligently
      PCI: ibmphp_hpc: don't release hw sem twice if kthread stops

Jiri Kosina (1):
      PCI: fix comment typo in bus_numa.h

Kenji Kaneshige (33):
      PCI: pciehp: disable DLL state changed event notification
      PCI: pciehp: remove wrong workaround for bad DLLP
      PCI: pciehp: create files only for existing capabilities
      PCI: pciehp: return error on read/write failure
      PCI: pciehp: fix typo in pciehp_probe
      PCI: pciehp: prevent unnecessary power off
      PCI: cache PCIe capability offset
      PCI hotplug: fix oshp evaluation
      PCI: introduce pci_pcie_cap()
      PCI: use pci_pcie_cap() in pci core
      PCIe AER: use pci_pcie_cap()
      PCIe port bus: use pci_pcie_cap()
      PCIe ASPM: use pci_pcie_cap()
      PCI hotplug: use pci_pcie_cap()
      pciehp: use pci_pcie_cap()
      PCI: introduce pci_is_pcie()
      PCI: use pci_is_pcie() in pci core
      PCIe ASPM: use pci_is_pcie()
      PCIe AER: use pci_is_pcie()
      PCI hotplug: use pci_is_pcie()
      PCI pciehp: fix power fault interrupt storm problem
      PCI: portdrv: remove redundant pcie_port_device_probe
      PCI: portdrv: cleanup pcie_device registration
      PCI: portdrv: remove redundant pcie type calculation
      PCI: portdrv: move PME capability check
      PCI: portdrv: check capabilities first
      PCI: portdrv: cleanup service irqs initialization
      PCI: portdrv: enable device before irq initialization
      PCI: portdrv: add missing irq cleanup
      PCI: portdrv: minor cleanup for pcie_port_device_register
      PCI: portdrv: remove unnecessary struct pcie_port_data
      PCI: portdrv: remove redundant definitions
      PCI: fix BUG_ON triggered by logical PCIe root port removal

Kleber Sacilotto de Souza (1):
      PCI: fix coding style issue in pci_save_state()

Linus Torvalds (1):
      PCI: allow matching of prefetchable resources to non-prefetchable windows

Matt Domsch (1):
      PCI: PCIe AER: honor ACPI HEST FIRMWARE FIRST mode

Matthew Garrett (1):
      PCI hotplug: acpiphp should be linked after vendor drivers

Michael S. Tsirkin (1):
      PCI: fix nit in ROM BAR size probing

Shmulik Ravid (1):
      PCI: read-modify-write the pcie device control register when initiating pcie flr

Stefan Assmann (2):
      PCI hotplug: change PCI nomenclature
      PCI: avoid boot interrupt quirk for AMD 813x B1 devices

Suresh Siddha (1):
      x86/PCI/PAT: return EINVAL for pci mmap WC request for !pat_enabled

Tejun Heo (3):
      sparc64/PCI: drop PCI_CACHE_LINE_BYTES
      pccard: configure CLS on attach
      PCI: pci_dfl_cache_line_size is __devinitdata

Thadeu Lima de Souza Cascardo (1):
      PCI: remove pci_find_slot from PCI_LEGACY config description

Thomas Gleixner (1):
      PCI: Replace old style lock initializer

Yinghai Lu (5):
      x86/PCI: read root resources from IOH on Intel
      x86/pci: seperate x86_pci_rootbus_res_quirks from amd_bus.c
      PCI: add debug output for DMA mask info
      PCI: show dma_mask bits in /sys
      x86/PCI: claim SR-IOV BARs in pcibios_allocate_resource

 arch/ia64/include/asm/xen/hypervisor.h |   28 +---
 arch/ia64/pci/pci.c                    |   33 ++-
 arch/sparc/include/asm/pci_64.h        |    2 -
 arch/sparc/kernel/pci.c                |    7 +
 arch/x86/include/asm/pci_x86.h         |   20 ++-
 arch/x86/include/asm/xen/hypervisor.h  |   27 ---
 arch/x86/kernel/amd_iommu_init.c       |    2 +
 arch/x86/pci/Makefile                  |    5 +
 arch/x86/pci/acpi.c                    |   74 ++++++--
 arch/x86/pci/amd_bus.c                 |  120 +----------
 arch/x86/pci/bus_numa.c                |  101 +++++++++
 arch/x86/pci/bus_numa.h                |   27 +++
 arch/x86/pci/common.c                  |   20 +-
 arch/x86/pci/early.c                   |    7 -
 arch/x86/pci/i386.c                    |   42 +++-
 arch/x86/pci/intel_bus.c               |   90 ++++++++
 arch/x86/pci/mmconfig-shared.c         |  356 ++++++++++++++++----------------
 arch/x86/pci/mmconfig_32.c             |   16 +-
 arch/x86/pci/mmconfig_64.c             |   88 ++------
 arch/x86/xen/enlighten.c               |    6 +
 drivers/acpi/Makefile                  |    1 +
 drivers/acpi/hest.c                    |  135 ++++++++++++
 drivers/block/xen-blkfront.c           |    1 +
 drivers/char/hvc_xen.c                 |    2 +
 drivers/input/xen-kbdfront.c           |    3 +
 drivers/net/xen-netfront.c             |    1 +
 drivers/pci/Kconfig                    |   15 +-
 drivers/pci/Makefile                   |    2 +
 drivers/pci/dmar.c                     |    7 +-
 drivers/pci/hotplug/Makefile           |   12 +-
 drivers/pci/hotplug/acpi_pcihp.c       |    5 +-
 drivers/pci/hotplug/acpiphp.h          |    6 -
 drivers/pci/hotplug/acpiphp_glue.c     |  248 ++---------------------
 drivers/pci/hotplug/ibmphp_hpc.c       |    3 +-
 drivers/pci/hotplug/pci_hotplug_core.c |   22 +-
 drivers/pci/hotplug/pciehp.h           |    1 -
 drivers/pci/hotplug/pciehp_acpi.c      |    3 +-
 drivers/pci/hotplug/pciehp_core.c      |  119 ++++-------
 drivers/pci/hotplug/pciehp_ctrl.c      |   57 +-----
 drivers/pci/hotplug/pciehp_hpc.c       |  155 +++++---------
 drivers/pci/hotplug/pcihp_slot.c       |    4 +-
 drivers/pci/intel-iommu.c              |   10 +-
 drivers/pci/intr_remapping.c           |    4 +-
 drivers/pci/ioapic.c                   |  127 ++++++++++++
 drivers/pci/iov.c                      |    2 +-
 drivers/pci/pci-acpi.c                 |    4 +-
 drivers/pci/pci-sysfs.c                |   25 +++
 drivers/pci/pci.c                      |  154 ++++++++++-----
 drivers/pci/pci.h                      |    2 +
 drivers/pci/pcie/aer/aer_inject.c      |   58 ++++--
 drivers/pci/pcie/aer/aerdrv.c          |    4 +-
 drivers/pci/pcie/aer/aerdrv_core.c     |   70 +++----
 drivers/pci/pcie/aer/ecrc.c            |    4 +-
 drivers/pci/pcie/aspm.c                |   47 +++--
 drivers/pci/pcie/portdrv.h             |   21 +--
 drivers/pci/pcie/portdrv_bus.c         |    7 +-
 drivers/pci/pcie/portdrv_core.c        |  239 ++++++++--------------
 drivers/pci/pcie/portdrv_pci.c         |   14 +-
 drivers/pci/probe.c                    |   83 +++++---
 drivers/pci/quirks.c                   |   40 ++++-
 drivers/pci/search.c                   |   38 ++--
 drivers/pci/setup-bus.c                |  112 +++++------
 drivers/pci/setup-res.c                |   68 +++---
 drivers/pcmcia/cardbus.c               |   23 ++-
 drivers/pnp/quirks.c                   |   13 +-
 drivers/pnp/resource.c                 |   10 +-
 drivers/pnp/support.c                  |   43 +----
 drivers/pnp/system.c                   |   14 +-
 drivers/video/xen-fbfront.c            |    3 +
 drivers/xen/balloon.c                  |    2 +
 drivers/xen/cpu_hotplug.c              |    1 +
 drivers/xen/evtchn.c                   |    2 +
 drivers/xen/grant-table.c              |    1 +
 drivers/xen/sys-hypervisor.c           |    1 +
 drivers/xen/xenbus/xenbus_probe.c      |    2 +
 drivers/xen/xenfs/super.c              |    2 +
 include/acpi/acpi_hest.h               |   12 +
 include/linux/pci.h                    |   42 ++++-
 include/linux/pci_regs.h               |   18 ++
 include/linux/pcieport_if.h            |   16 +--
 include/xen/xen.h                      |   32 +++
 kernel/resource.c                      |   26 ++-
 lib/vsprintf.c                         |   87 +++++++--
 83 files changed, 1790 insertions(+), 1566 deletions(-)
 create mode 100644 arch/x86/pci/bus_numa.c
 create mode 100644 arch/x86/pci/bus_numa.h
 create mode 100644 arch/x86/pci/intel_bus.c
 create mode 100644 drivers/acpi/hest.c
 create mode 100644 drivers/pci/ioapic.c
 create mode 100644 include/acpi/acpi_hest.h
 create mode 100644 include/xen/xen.h


-- 
Jesse Barnes, Intel Open Source Technology Center

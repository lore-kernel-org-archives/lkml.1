Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbZFVQVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbZFVQVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZFVQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:21:32 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:50596 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752087AbZFVQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:21:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qeSpxAsY0g/HOKlfo9X9Z/xV2K1X1El+RTqdOHtWIT6A9wKlJTKDdZNiGbqA3O6AonZ/tNdL88V0+ZPMacvYAv2Xeov6NYYkY6Wq/Lb5SU5tvyrExgNcaGldJlkIBwv+;
Date: Mon, 22 Jun 2009 09:21:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes for 2.6.31
Message-ID: <20090622092128.1845d598@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
07a2039b8eb0af4ff464efd3dfd95de5c02648c6: Linus Torvalds (1):
        Linux 2.6.30

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

This set of changes should be much less aggressive than the ones we
pushed for 2.6.30; no huge changes to the way hotplug or resource
management is done, and not a lot that affects generic stuff like MSI
(though we do have some fixes there).  That said, there are some good
bits in here, like the AER improvements (making it much more useful on
upcoming chipsets and when multiple errors occur), and Alex's removal
of pci_find_slot (finally!).

I think there's still one warning in the PPC64 build, but Ben has
promised to fix up the way ppc describes its I/O space, which is the
correct fix (in the meantime it doesn't adversely affect functionality;
it's just a cleanliness issue in the way ppc does resource setup).

Alex Chiang (17):
      PCI Hotplug: cpqphp: stray whitespace cleanups
      PCI Hotplug: cpqphp: fix comment style
      PCI Hotplug: cpqphp: obey 80 column convention in cpqphp.h
      PCI Hotplug: cpqphp: remove useless prototypes in cpqphp_core.c
      PCI Hotplug: cpqphp: eliminate stray braces
      PCI Hotplug: cpqphp: refactor cpqhp_probe
      PCI Hotplug: cpqphp: clean up cpqphp_ctrl.c
      PCI Hotplug: cpqphp: refactor cpqphp_save_slot_config
      PCI Hotplug: cpqphp: style cleanups
      PCI Hotplug: cpqphp: refactor cpqhp_save_config
      PCI Hotplug: cpqphp: clean up accesses to pcibios_get_irq_routing_table()
      PCI Hotplug: cpqphp: eliminate dead code - PCI_ScanBusNonBridge
      PCI Hotplug: cpqphp: constify slot_name()
      PCI Hotplug: cpqphp: don't use pci_find_slot()
      PCI: remove deprecated pci_find_slot() interface
      PCI: eliminate redundant pci_stop_dev() call from pci_destroy_dev()
      PCI: drivers/pci/slot.c should depend on CONFIG_SYSFS

Andreas Herrmann (1):
      x86/PCI: add description for check_enable_amd_mmconf boot parameter

Andrew Patterson (1):
      PCI: Add support for turning PCIe ECRC on or off

Frans Pop (1):
      PCI PM: consistently use type bool for wake enable variable

Gary Hade (1):
      x86/ACPI: Correct maximum allowed _CRS returned resources and warn if exceeded

Greg Kroah-Hartman (1):
      PCIE: remove driver_data direct access of struct device

Hidetoshi Seto (4):
      PCI MSI: Remove unused/obsolete macros and definitions
      PCI MSI: Define PCI_MSI_MASK_32/64
      PCI: Fix the NIU MSI-X problem in a better way
      PCI: make msi_free_irqs() to use msix_mask_irq() instead of open coded write

Huang Ying (4):
      PCI: Add pci_bus_set_ops
      PCI: PCIE AER: export aer_irq
      PCI: PCIE AER: Document for PCIE AER software error injection
      PCI AER: software error injection

Jesse Barnes (1):
      PCI: use ACPI _CRS data by default

Kenji Kaneshige (25):
      PCI: use pci_is_root_bus() in acpi_pci_get_bridge_handle()
      PCI: use pci_is_root_bus() in acpi_find_root_bridge_handle()
      PCI: use pci_is_root_bus() in pci_find_upstream_pcie_bridge()
      PCI: use pci_is_root_bus() in pci_read_bridge_bases()
      PCI: use pci_is_root_bus() in pci_get_interrupt_pin()
      PCI: use pci_is_root_bus() in pci_common_swizzle()
      PCI: Remove untested Electromechanical Interlock (EMI) support in pciehp.
      PCI hotplug: fix return value of has_foo() functions
      PCI hotplug: create symlink to hotplug driver module
      PCI hotplug: remove redundant .owner initializations
      PCI: remove invalid comment of msi_mask_irq()
      PCI ASPM: fix typo in struct pcie_link_state
      PCI ASPM: cleanup aspm state field in struct pcie_link_state
      PCI ASPM: cleanup latency field in struct pcie_link_state
      PCI ASPM: cleanup clkpm state in struct pcie_link_state
      PCI ASPM: cleanup misc in struct pcie_link_state
      PCI ASPM: cleanup change input argument of aspm functions
      PCI ASPM: cleanup initialization
      PCI ASPM: cleanup __pcie_aspm_check_state_one
      PCI ASPM: cleanup clkpm checks
      PCI ASPM: cleanup pcie_aspm_get_cap_device
      PCI ASPM: cleanup calc_Lx_latency
      PCI ASPM: remove has_switch field
      PCI ASPM: cleanup pcie_aspm_sanity_check
      PCI ASPM: remove get_root_port_link

Mats Erik Andersson (1):
      PCI: expose SMBus on Asus notebook A6L

Matthew Wilcox (1):
      PCI: remove redundant __msi_set_enable()

Michael S. Tsirkin (1):
      PCI MSI: let drivers retry when not enough vectors

Michal Miroslaw (2):
      PCI quirk: unhide 'Overflow' device on i828{6,7}5P/PE chipsets
      PCI quirk: HP hides SMBus controller in Compaq nx9500 laptops

Rafael J. Wysocki (2):
      PCI PM: Follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3
      PCI PM: Fix handling of devices without PM support by pci_target_state()

Shaohua Li (1):
      PCI: disable ASPM on VIA root-port-under-bridge configurations

Yinghai Lu (2):
      PCI/x86: don't assume prefetchable ranges are 64bit
      PCI: improve resource allocation under transparent bridges

Yu Zhao (4):
      PCI: fix SR-IOV function dependency link problem
      PCI: cleanup Function Level Reset
      PCI: support PM D0hot->D3 transition reset
      PCI: support Secondary Bus Reset

Zhang, Yanmin (3):
      PCI AER: support Multiple Error Received and no error source id
      PCI AER: support invalid error source IDs
      PCI AER: multiple error support

akpm@linux-foundation.org (1):
      PCI: ibmphp_core.c: fix warning due to missing module_exit()

 Documentation/ABI/testing/sysfs-bus-pci     |    7 +
 Documentation/PCI/pcieaer-howto.txt         |   25 +
 Documentation/kernel-parameters.txt         |   11 +-
 arch/powerpc/platforms/pseries/eeh_driver.c |   38 +-
 arch/x86/include/asm/pci.h                  |    1 +
 arch/x86/include/asm/pci_x86.h              |    2 +-
 arch/x86/pci/acpi.c                         |   35 +-
 arch/x86/pci/amd_bus.c                      |    2 +-
 arch/x86/pci/common.c                       |    4 +-
 drivers/acpi/Kconfig                        |    1 +
 drivers/pci/Makefile                        |    3 +-
 drivers/pci/access.c                        |   19 +
 drivers/pci/bus.c                           |   18 +-
 drivers/pci/hotplug/Kconfig                 |    4 +-
 drivers/pci/hotplug/acpiphp_core.c          |    1 -
 drivers/pci/hotplug/cpci_hotplug_core.c     |    1 -
 drivers/pci/hotplug/cpqphp.h                |  167 +++--
 drivers/pci/hotplug/cpqphp_core.c           | 1100 +++++++++++++--------------
 drivers/pci/hotplug/cpqphp_ctrl.c           |  371 +++++-----
 drivers/pci/hotplug/cpqphp_nvram.c          |   97 ++--
 drivers/pci/hotplug/cpqphp_pci.c            |  599 ++++++++--------
 drivers/pci/hotplug/ibmphp_core.c           |    2 +-
 drivers/pci/hotplug/pci_hotplug_core.c      |  155 ++--
 drivers/pci/hotplug/pciehp.h                |    3 -
 drivers/pci/hotplug/pciehp_core.c           |  112 +---
 drivers/pci/hotplug/pciehp_hpc.c            |   31 -
 drivers/pci/hotplug/pcihp_skeleton.c        |    1 -
 drivers/pci/hotplug/rpaphp_core.c           |    1 -
 drivers/pci/hotplug/sgi_hotplug.c           |    1 -
 drivers/pci/hotplug/shpchp_core.c           |    1 -
 drivers/pci/iov.c                           |    6 +-
 drivers/pci/msi.c                           |  100 ++--
 drivers/pci/msi.h                           |   14 +-
 drivers/pci/pci.c                           |  246 ++++---
 drivers/pci/pcie/aer/Kconfig                |   15 +
 drivers/pci/pcie/aer/Kconfig.debug          |   18 +
 drivers/pci/pcie/aer/Makefile               |    3 +
 drivers/pci/pcie/aer/aer_inject.c           |  473 ++++++++++++
 drivers/pci/pcie/aer/aerdrv.c               |    3 +-
 drivers/pci/pcie/aer/aerdrv.h               |    6 +
 drivers/pci/pcie/aer/aerdrv_core.c          |  278 +++++---
 drivers/pci/pcie/aer/ecrc.c                 |  131 ++++
 drivers/pci/pcie/aspm.c                     |  787 +++++++++----------
 drivers/pci/pcie/portdrv_core.c             |    2 +-
 drivers/pci/probe.c                         |   11 +-
 drivers/pci/quirks.c                        |   24 +
 drivers/pci/remove.c                        |    2 -
 drivers/pci/search.c                        |   32 +-
 drivers/pci/setup-bus.c                     |   53 +-
 drivers/pci/setup-res.c                     |   49 +-
 drivers/pci/slot.c                          |   39 +
 include/linux/ioport.h                      |    2 +
 include/linux/pci-acpi.h                    |    4 +-
 include/linux/pci.h                         |   35 +-
 include/linux/pci_hotplug.h                 |   23 +-
 include/linux/pci_regs.h                    |    4 +-
 56 files changed, 3005 insertions(+), 2168 deletions(-)
 create mode 100644 drivers/pci/pcie/aer/Kconfig.debug
 create mode 100644 drivers/pci/pcie/aer/aer_inject.c
 create mode 100644 drivers/pci/pcie/aer/ecrc.c

-- 
Jesse Barnes, Intel Open Source Technology Center

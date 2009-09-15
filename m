Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZIOUVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZIOUVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZIOUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:21:10 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:40393 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751054AbZIOUVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:21:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZiFda7/5Lvqihj7nR/RQ+7EqfKRvJME435OXtcPdkog31K0kNoQ3eYhZcb+pKSfo3qfeE/KiREHt8puFZnwj+vE5NceNcozYHebyXpJJbrd23M48CIqkxYtiaXG6KhZI;
Date: Tue, 15 Sep 2009 13:21:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090915132105.2fdd1d45@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 332a3392188e0ad966543c87b8da2b9d246f301d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../herbert/crypto-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

There are a few important changes in here:
  - VGA arbitration from Ben, Dave and Tiago (finally the kernel can handle
    multi-seat graphics configurations properly)
  - support for PCIe fundamental reset from Mike (needed for error recovery on
    some devices)
  - some ASPM cleanups and functional improvements from Kenji-san
  - a number of MSI and AER cleanups from Hidetoshi-san
  - a collection of fixes
  - the obligatory set of hotplug related cleanups (more of these coming)
  - usual set of PM improvements from Rafael

I hope to have one more merge window patchset ready by the end of the week,
including the hardware resource probing stuff we talked about and some more
cleanups and fixes for hotplug and PM.

Thanks,
Jesse

Alex Chiang (5):
      PCI: remove pcibios_scan_all_fns()
      ACPI: export acpi_pci_root and friends
      PCI Hotplug: acpiphp: get pci_bus from acpi handle correctly
      PCI Hotplug: acpiphp: find bridges the easy way
      PCI Hotplug: convert acpi_pci_detect_ejectable() to take an acpi_handle

Alex Williamson (1):
      PCI iommu: iommu=pt is a valid early param

Alexander Duyck (1):
      PCI quirk: update 82576 device ids in SR-IOV quirks list

Andi Kleen (1):
      PCI: disable pci_find_device warnings when deprecated pci functions are enabled

Benjamin Herrenschmidt (1):
      PCI/GPU: implement VGA arbitration on Linux

Bjorn Helgaas (9):
      PCI: use dev_printk in quirk messages
      PCI hotplug: acpiphp: remove superfluous _HPP/_HPX evaluation
      PCI hotplug: acpiphp: don't cache hotplug_params in acpiphp_bridge
      PCI hotplug: clean up acpi_get_hp_params_from_firmware() interface
      PCI hotplug: add pci_configure_slot()
      PCI hotplug: pciehp: use generic pci_configure_slot()
      PCI hotplug: shpchp: use generic pci_configure_slot()
      PCI hotplug: acpiphp: use generic pci_configure_slot()
      PCI hotplug: clean up acpi_run_hpp()

Dave Airlie (1):
      PCI/vgaarb: cleanup some warnings + cleanup some comments.

Dave Jones (1):
      PCI: Document pci_ids.h addition policy.

Eric W. Biederman (2):
      PCI: Simplify hotplug mch quirk.
      PCI: pcie: Ensure hotplug ports have a minimum number of resources

Hidetoshi Seto (20):
      PCI MSI: Remove attribute check from pci_disable_msi()
      PCI MSI: Use list_first_entry()
      PCI MSI: Unify msi_free_irqs() and msix_free_all_irqs()
      PCI MSI: Relocate error path in init_msix_capability()
      PCI MSI: MSI-X cleanup, msix_map_region()
      PCI MSI: MSI-X cleanup, msix_program_entries()
      PCI MSI: MSI-X cleanup, msix_setup_entries()
      PCI MSI: Style cleanups
      PCI: pcie, aer: checkpatch style cleanup in pcie/aer/*
      PCI: pcie, aer: AER_PR for printing in aerdrv_errprint.c
      PCI: pcie, aer: rework MASK macros in aerdrv_errprint.c
      PCI: pcie, aer: init struct aer_err_info for reuse
      PCI: pcie, aer: fix report of multiple errors
      PCI: pcie, aer: remove spinlock in aerdrv_errprint.c
      PCI: pcie, aer: refer mask state in mask register properly
      PCI: pcie, aer: report multiple/first error on a device
      PCI: pcie, aer: remove unused macros
      PCI: pcie, aer: flags to bits
      PCI: pcie, aer: change error print format
      PCI: pcie, aer: report all error before recovery

Jean Delvare (1):
      PCI: Unhide the SMBus on the Compaq Evo D510 USDT

Jesse Barnes (3):
      PCI: export pci_claim_resource for driver use
      x86/PCI: initialize PCI bus node numbers early
      PCI: pcie portdrv: remove unused variable

Jiri Slaby (1):
      x86/PCI: pci quirks, fix pci refcounting

Kenji Kaneshige (9):
      PCI ASPM: do not clear enabled field by support field
      PCI ASPM: remove redundant list check
      PCI ASPM: fix possible null pointer dereference
      PCI ASPM: introduce disable flag
      PCI ASPM: introduce capable flag
      PCI ASPM: support partial aspm enablement
      PCI ASPM: support per direction l0s management
      PCI hotplug: fix typo in pcie link speed info
      PCI hotplug: add support for 5.0G link speed

Matthew Wilcox (2):
      frv/PCI: Use pci_claim_resource
      yenta: Use pci_claim_resource

Michael S. Tsirkin (1):
      PCI: expose function reset capability in sysfs

Mike Mason (3):
      PCI: support for PCI Express fundamental reset
      PCI: document PCIe fundamental reset interfaces
      PCI/powerpc: support PCIe fundamental reset

Rafael J. Wysocki (8):
      PCI PM: Simplify PCI wake-up code
      PCI / ACPI PM: Rework some debug messages
      PCI PM: Introduce device flag wakeup_prepared
      ACPI PM: Replace wakeup.prepared with reference counter
      PCI / ACPI PM: Propagate wake-up enable for devices w/o ACPI support
      PCI / PCIe portdrv: Fix pcie_portdrv_slot_reset()
      PCI PM: Return error codes from pci_pm_resume()
      PCI: Clear saved_state after the state has been restored

Tejun Heo (3):
      PCI: apply nv_msi_ht_cap_quirk on resume too
      PCI: separate out pci_add_dynid()
      PCI: pci-stub: add pci_stub.ids parameter

Tiago Vignatti (1):
      PCI/VGA: add VGA arbitration documentation

Yinghai Lu (1):
      PCI: print out pref if mmio is prefetchable

 Documentation/ABI/testing/sysfs-bus-pci  |   10 +
 Documentation/PCI/pci-error-recovery.txt |  119 ++-
 Documentation/vgaarbiter.txt             |  194 +++++
 arch/alpha/include/asm/pci.h             |    1 -
 arch/arm/include/asm/pci.h               |    2 -
 arch/frv/mb93090-mb00/pci-frv.c          |   10 +-
 arch/h8300/include/asm/pci.h             |    1 -
 arch/ia64/include/asm/pci.h              |   14 +-
 arch/mips/include/asm/pci.h              |    2 -
 arch/mn10300/include/asm/pci.h           |   13 +-
 arch/parisc/include/asm/pci.h            |    1 -
 arch/powerpc/include/asm/pci.h           |    1 -
 arch/powerpc/kernel/pci_64.c             |    1 +
 arch/powerpc/platforms/pseries/eeh.c     |   10 +-
 arch/sh/include/asm/pci.h                |    1 -
 arch/sparc/include/asm/pci_32.h          |    1 -
 arch/sparc/include/asm/pci_64.h          |    1 -
 arch/um/include/asm/pci.h                |    1 -
 arch/x86/include/asm/pci.h               |    1 -
 arch/x86/kernel/pci-dma.c                |    4 +-
 arch/x86/kernel/quirks.c                 |    2 +-
 arch/x86/pci/amd_bus.c                   |   64 +--
 arch/x86/pci/common.c                    |   69 ++
 drivers/acpi/pci_root.c                  |   17 +-
 drivers/acpi/power.c                     |   58 +-
 drivers/acpi/scan.c                      |    1 +
 drivers/acpi/sleep.c                     |   12 +-
 drivers/acpi/wakeup.c                    |    4 +-
 drivers/gpu/Makefile                     |    2 +-
 drivers/gpu/vga/Kconfig                  |   10 +
 drivers/gpu/vga/Makefile                 |    1 +
 drivers/gpu/vga/vgaarb.c                 | 1205 ++++++++++++++++++++++++++++++
 drivers/pci/Makefile                     |    3 +
 drivers/pci/hotplug/Makefile             |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c         |  117 +--
 drivers/pci/hotplug/acpiphp.h            |    3 -
 drivers/pci/hotplug/acpiphp_glue.c       |  187 +----
 drivers/pci/hotplug/pci_hotplug_core.c   |    3 +-
 drivers/pci/hotplug/pciehp.h             |    9 -
 drivers/pci/hotplug/pciehp_acpi.c        |    7 +-
 drivers/pci/hotplug/pciehp_ctrl.c        |    5 -
 drivers/pci/hotplug/pciehp_hpc.c         |   10 +-
 drivers/pci/hotplug/pciehp_pci.c         |  137 +----
 drivers/pci/hotplug/pcihp_slot.c         |  187 +++++
 drivers/pci/hotplug/shpchp.h             |    9 -
 drivers/pci/hotplug/shpchp_pci.c         |   62 +--
 drivers/pci/legacy.c                     |   34 +
 drivers/pci/msi.c                        |  283 ++++----
 drivers/pci/pci-acpi.c                   |   29 +-
 drivers/pci/pci-driver.c                 |  132 ++--
 drivers/pci/pci-stub.c                   |   45 ++-
 drivers/pci/pci-sysfs.c                  |   37 +
 drivers/pci/pci.c                        |  106 +++-
 drivers/pci/pci.h                        |    2 +-
 drivers/pci/pcie/aer/aer_inject.c        |   25 +-
 drivers/pci/pcie/aer/aerdrv.c            |   22 +-
 drivers/pci/pcie/aer/aerdrv.h            |   34 +-
 drivers/pci/pcie/aer/aerdrv_core.c       |  107 ++--
 drivers/pci/pcie/aer/aerdrv_errprint.c   |  190 +++---
 drivers/pci/pcie/aspm.c                  |  495 ++++++-------
 drivers/pci/pcie/portdrv_core.c          |    6 -
 drivers/pci/pcie/portdrv_pci.c           |    1 +
 drivers/pci/probe.c                      |   33 +-
 drivers/pci/quirks.c                     |   36 +-
 drivers/pci/search.c                     |   31 -
 drivers/pci/setup-bus.c                  |   22 +-
 drivers/pci/setup-res.c                  |    1 +
 drivers/pcmcia/yenta_socket.c            |   16 +-
 drivers/video/Kconfig                    |    2 +
 include/acpi/acpi_bus.h                  |   18 +-
 include/asm-generic/pci.h                |   13 +-
 include/linux/pci.h                      |   14 +
 include/linux/pci_hotplug.h              |   16 +-
 include/linux/pci_ids.h                  |    3 +
 include/linux/vgaarb.h                   |  200 +++++
 75 files changed, 3146 insertions(+), 1381 deletions(-)
 create mode 100644 Documentation/vgaarbiter.txt
 create mode 100644 drivers/gpu/vga/Kconfig
 create mode 100644 drivers/gpu/vga/Makefile
 create mode 100644 drivers/gpu/vga/vgaarb.c
 create mode 100644 drivers/pci/hotplug/pcihp_slot.c
 create mode 100644 drivers/pci/legacy.c
 create mode 100644 include/linux/vgaarb.h


-- 
Jesse Barnes, Intel Open Source Technology Center

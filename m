Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbYBAXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbYBAXNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYBAXNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:13:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:45358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYBAXNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:13:35 -0500
Date: Fri, 1 Feb 2008 15:11:47 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.24
Message-ID: <20080201231147.GA18174@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of PCI patches against your 2.6.24 git tree.

Some general cleanups, minor tweaks, and a bit of PCI hotplug updates,
and some PCI Express updates for new features, if your hardware happens
to support it.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

All of these have been in the -mm releases for a while.

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h

-------------

 Documentation/pci.txt                  |   37 +--
 arch/alpha/Kconfig                     |    5 -
 arch/arm/Kconfig                       |    5 -
 arch/frv/Kconfig                       |    5 -
 arch/m32r/Kconfig                      |    5 -
 arch/m68k/Kconfig                      |    5 -
 arch/mips/Kconfig                      |    5 -
 arch/sh/drivers/pci/Kconfig            |    5 -
 arch/sparc64/Kconfig                   |    5 -
 arch/x86/Kconfig                       |    5 -
 arch/x86/kernel/quirks.c               |   43 +-
 arch/x86/pci/fixup.c                   |   22 +-
 arch/xtensa/Kconfig                    |    5 -
 drivers/ata/pata_cs5520.c              |    2 +-
 drivers/i2c/busses/scx200_acb.c        |    2 +-
 drivers/ide/pci/cs5520.c               |   10 +-
 drivers/ide/setup-pci.c                |    6 +-
 drivers/pci/bus.c                      |   18 +-
 drivers/pci/dmar.c                     |   20 +-
 drivers/pci/hotplug/Kconfig            |    4 +-
 drivers/pci/hotplug/Makefile           |    4 +-
 drivers/pci/hotplug/acpiphp.h          |    1 -
 drivers/pci/hotplug/acpiphp_glue.c     |    5 +-
 drivers/pci/hotplug/fakephp.c          |   39 ++-
 drivers/pci/hotplug/ibmphp_core.c      |   11 +-
 drivers/pci/hotplug/pci_hotplug_core.c |    4 +-
 drivers/pci/hotplug/pciehp.h           |    9 +-
 drivers/pci/hotplug/pciehp_core.c      |   33 +-
 drivers/pci/hotplug/pciehp_ctrl.c      |   27 +-
 drivers/pci/hotplug/pciehp_hpc.c       |  314 ++++++++-----
 drivers/pci/hotplug/pciehp_pci.c       |   43 +-
 drivers/pci/hotplug/rpaphp.h           |    1 -
 drivers/pci/hotplug/rpaphp_pci.c       |   14 -
 drivers/pci/hotplug/rpaphp_slot.c      |   47 +-
 drivers/pci/hotplug/shpchp_hpc.c       |    2 +-
 drivers/pci/intel-iommu.c              |    2 +-
 drivers/pci/msi.c                      |   94 ++--
 drivers/pci/pci-acpi.c                 |    7 +-
 drivers/pci/pci-driver.c               |    4 +-
 drivers/pci/pci-sysfs.c                |   11 +-
 drivers/pci/pci.c                      |   93 +++-
 drivers/pci/pci.h                      |   16 +-
 drivers/pci/pcie/Kconfig               |   20 +
 drivers/pci/pcie/Makefile              |    3 +
 drivers/pci/pcie/aer/aerdrv_acpi.c     |   24 +-
 drivers/pci/pcie/aspm.c                |  802 ++++++++++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c        |    5 +-
 drivers/pci/probe.c                    |   80 ++--
 drivers/pci/proc.c                     |   17 +-
 drivers/pci/quirks.c                   |  483 +++++++++++--------
 drivers/pci/remove.c                   |   10 +-
 drivers/pci/rom.c                      |    6 +-
 drivers/pci/setup-bus.c                |   64 ++-
 drivers/pci/setup-res.c                |    7 +-
 drivers/pci/syscall.c                  |    5 -
 drivers/scsi/lpfc/lpfc_init.c          |    3 +-
 drivers/scsi/qla2xxx/qla_def.h         |    1 +
 drivers/scsi/qla2xxx/qla_os.c          |   21 +-
 drivers/usb/host/pci-quirks.c          |   22 +-
 include/linux/aspm.h                   |   44 ++
 include/linux/pci-acpi.h               |   11 +-
 include/linux/pci.h                    |  367 ++++++++++-----
 include/linux/pci_regs.h               |    8 +
 63 files changed, 2101 insertions(+), 897 deletions(-)
 create mode 100644 drivers/pci/pcie/aspm.c
 create mode 100644 include/linux/aspm.h

---------------

Adrian Bunk (7):
      PCI: make pci_restore_bars() static
      PCI: drivers/pci/rom.c: #if 0 two functions
      PCI: drivers/pci/: remove unused exports
      PCI: always export pci_scan_single_device
      PCI: remove additional pci_scan_child_bus() prototype
      PCI: drivers/pci/msi.c: move arch hooks to the top
      PCI: Kconfig help: don't refer to the PCI-HOWTO

Alex Chiang (3):
      PCI: hotplug: acpiphp: Remove unused variable from acpiphp
      PCI: hotplug: pci_hotplug_core whitespace fix
      PCI: hotplug: Link fakephp last

Andrew Morton (1):
      PCI: drivers/pci/quirks.c: coding-style cleanup

Andrew Patterson (3):
      PCI ACPI: Added a function to register _OSC with only PCIe devices.
      PCI ACPI: AER driver should only register PCIe devices with _OSC
      PCI: Run ACPI _OSC method on root bridges only

Auke Kok (1):
      PCI: quirk_vialatency: Omit reading pci revision ID

Benjamin Herrenschmidt (5):
      PCI: Fix bus resource assignment on 32 bits with 64b resources
      PCI: Fix warning in setup-res.c on 32-bit platforms with 64-bit resources
      PCI: Add pci_enable_device_{io,mem} intefaces
      PCI: Remove users of pci_enable_device_bars()
      PCI: Remove pci_enable_device_bars()

Diego Woitasen (1):
      PCI: remove unneeded lock_kernel() in drivers/pci/syscall.c.

Fenghua Yu (1):
      PCI: More Sanity checks for DMAR

Grant Grundler (1):
      PCI: Remove pci_enable_device_bars() from documentation

Greg Kroah-Hartman (3):
      PCI: fix codingstyle issues in drivers/pci/pci.h
      PCI: fix codingstyle issues in include/linux/pci.h
      PCI: make pci_bus a struct device

Ian Abbott (1):
      PCI: Fix fakephp deadlock

Ivan Kokshaysky (1):
      PCI: fix for quirk_e100_interrupt()

Jan Engelhardt (1):
      PCI: constify function pointer tables

Jean Delvare (1):
      PCI: Unhide the SMBus on the HP xw4100

Joe Perches (2):
      PCI: Add missing "space" in printk messages
      PCI: Spelling fixes

Joonwoo Park (1):
      PCI: hotplug: Switch to pci_get_bus_and_slot

Kenji Kaneshige (6):
      PCI Hotplug: pciehp: remove needless members from struct controller
      PCI Hotplug: pciehp: remove needless hp_slot calculation
      PCI Hotplug: pciehp: use generic function to find ext capability
      pciehp: wait for 1000ms before LED operation after power off
      pciehp: workaround against Bad DLLP during power off
      pciehp: block new requests from the device before power off

Kristen Carlson Accardi (1):
      PCI: hotplug: remove Experimental

Lee Schermerhorn (1):
      PCI: Mem Policy: fix mempolicy usage in pci driver

Lennert Buytenhek (1):
      PCI: get rid of pci_dev::{vendor,device}_compatible fields

Linas Vepstas (2):
      pci hotplug: fix rpaphp directory naming
      PCI: export pci_restore_msi_state()

MUNEDA Takahiro (2):
      PCI Hotplug: acpiphp: fix trivial typos
      PCI Hotplug: acpiphp: remove unneeded acpi_get_name function call

Mark Lord (4):
      PCIE: fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks (and others?) in conjunction with modparam of pciehp_force=1.
      PCI: more fixes for PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks (and others?) in conjunction with modparam of pciehp_force=1
      PCIE: Make use of the previously split out pcie_init_enable_events() function
      PCIe: fix double initialization bug

Mathieu Segaud (1):
      PCI: Convert drivers/pci/proc.c to use unlocked_ioctl

Rolf Eike Beer (1):
      PCI Hotplug: PCIeHP: Fix some whitespace damage

Sebastien Dugue (1):
      PCI: quirk: enable MSI Mapping on HT1000

Shane Huang (1):
      PCI: modify SB700 SATA MSI quirk

Shaohua Li (6):
      pcie port driver: correctly detect native PME feature
      pcie: utilize pcie transaction pending bit
      PCI: fix typo in pci_save_pcix_state
      PCI: correctly initialize a structure for pcie_save_pcix_state()
      PCI: avoid save the same type of cap multiple times
      PCI: PCIE ASPM support

Tim Yamin (1):
      PCI: VIA CX700 quirk to disable PCI Bus Parking

bjorn.helgaas@hp.com (3):
      PCI: print quirk name in debug messages
      PCI: use dev_printk in quirk messages
      PCI: use dev_printk in x86 quirk messages


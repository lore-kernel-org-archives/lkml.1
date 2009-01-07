Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbZAGWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbZAGWev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbZAGWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:30:59 -0500
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:39328 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762455AbZAGWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:30:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=cH9EwHl6f8uNS/wrLRlSTZ0lOWdk1gbj2gJKM2CNVYsxoulw+grMjo4I3WAe7hXGhKm09t8XE8rwcGevlr7oNaTtQ58rg26WfeoC80pw3shmBBpIOMkfDBSwSaCSx+eI;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI pull request for 2.6.29
Date: Wed, 7 Jan 2009 14:30:55 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071430.55580.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my linux-next branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git linux-next

Here it is, a bit later than I was hoping but well coordinated with Greg &
Rafael.  Shortlog & diffstat below.

Perhaps the most visible change is Rafael's suspend/resume stuff; it doesn't
appear to introduce any problems that your tree doesn't already have, so I'm
hopeful that things will go smoothly.  Aside from that there's the usual
hotplug related churn (things really are improving here, honest), and several
consolidation patches from Bjorn.

If things go well we might have a couple of more SR-IOV support patches soon
(all of the preparatory patches are already in), but those should have a
fairly limited impact since they mainly add a few new APIs for drivers to use
on SR-IOV capable hardware.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

Adam Jackson (1):
      PCI quirks: piix3: warn softer about enabling passive release

Alan Stern (1):
      PCI: fix incorrect error return in pci_enable_wake

Alex Chiang (1):
      PCI hotplug: acpiphp whitespace cleanup

Andrew Morton (1):
      PCI: uninline pci_ioremap_bar()

Andrew Patterson (8):
      ACPI/PCI: include missing acpi.h file in pci-acpi.h.
      ACPI/PCI: call _OSC support during root bridge discovery
      ACPI/PCI: PCI extended config _OSC support called when root bridge added
      ACPI/PCI: PCIe ASPM _OSC support capabilities called when root bridge added
      ACPI/PCI: PCIe AER _OSC support capabilities called when root bridge added
      ACPI/PCI: PCI MSI _OSC support capabilities called when root bridge added
      ACPI/PCI: remove obsolete _OSC capability support functions
      PCI: Use msleep instead of cpu_relax during ASPM link retraining

Arjan van de Ven (1):
      resource: allow MMIO exclusivity for device drivers

Ben Hutchings (2):
      PCI: Add pci_clear_master() as opposite of pci_set_master()
      net: sfc: Use pci_clear_master() to disable bus mastering

Benjamin Herrenschmidt (1):
      PCI: Add legacy_io/mem to all busses

Bjorn Helgaas (23):
      PCI: make PCI bus resource messages more meaningful
      x86/PCI: make PCI bus locality messages more meaningful
      PCI: pcie port driver: remove extra printks
      PCI hotplug: cpqphp: use config space PCI interrupt pin encoding
      PCI: use config space encoding in pci_get_interrupt_pin()
      x86/PCI: use config space encoding for interrupt pins
      x86/PCI: minor logic simplications
      PCI: add pci_swizzle_interrupt_pin()
      PCI: arm: use generic pci_swizzle_interrupt_pin()
      PCI: sh: use generic pci_swizzle_interrupt_pin()
      PCI: powerpc: use generic pci_swizzle_interrupt_pin()
      PCI: alpha: use generic pci_swizzle_interrupt_pin()
      PCI: x86: use generic pci_swizzle_interrupt_pin()
      PCI: mips: use generic pci_swizzle_interrupt_pin()
      PCI: parisc: use generic pci_swizzle_interrupt_pin()
      PCI: add pci_common_swizzle() for INTx swizzling
      PCI: alpha: use generic INTx swizzle from PCI core
      PCI: arm: use generic INTx swizzle from PCI core
      PCI: mips: use generic INTx swizzle from PCI core
      PCI: sh: use generic INTx swizzle from PCI core
      PCI: x86/visws: use generic INTx swizzle from PCI core
      PCI: use dev_printk for PCI bus resource mssages
      x86/PCI: use dev_printk for PCI bus locality messages

Chris Wright (2):
      PCI: allow pci driver to support only dynids
      PCI: pci-stub module to reserve pci device

Hidetoshi Seto (1):
      PCI hotplug: aerdrv: fix a typo in error message

Ingo Molnar (1):
      PCI: Don't carp about BAR allocation failures in quiet boot

Jacob Pan (1):
      PCI: avoid early PCI mmconfig init if pci=noearly is given in cmdline

Jesse Barnes (3):
      PCI: check mmap range of /proc/bus/pci files too
      PCI: fixup whitespace in quirks.c
      PCI: set device wakeup capable flag if platform support is present

Julia Lawall (2):
      drivers/pci/hotplug: Add missing pci_dev_get
      PCI hotplug: remove redundant test in cpq hotplug

Kay Sievers (1):
      PCI: struct device - replace bus_id with dev_name(), dev_set_name()

Kenji Kaneshige (6):
      PCI hotplug: pciehp: remove unnecessary wait after turning power off
      PCI: pciehp: add ACPI based slot detection
      PCI: pciehp: add auto option to pciehp_detect_mode
      PCI hotplug: introduce functions for ACPI slot detection
      PCI: pciehp: ignore undefined bit in link status register
      PCI: pciehp: cleanup register and field definitions

Linus Torvalds (1):
      PCI: extend on the ICH motherboard IO decode quirk list

Matthew Garrett (1):
      PCI/ACPI:  acpiphp: Identify more removable slots

Rafael J. Wysocki (19):
      PCI: Suspend and resume PCI Express ports with interrupts disabled
      PCI: handle PCI state saving with interrupts disabled
      PCI PM: Fix pci_update_current_state
      PCI PM: Split PCI Express port suspend-resume
      x86/PCI: Do not use interrupt links for devices using MSI-X
      PCI: PCIe portdrv: Add kerneldoc comments to some core functions
      PCI: PCIe portdrv: Fix suspend and resume of PCI Express port services
      PCI: PCIe portdrv: Rearrange code so that related things are together
      PCI: PCIe portdrv: Add kerneldoc comments to remining core funtions
      PCI PM: Fix poweroff and restore callbacks
      PCI PM: Add suspend counterpart of pci_reenable_device
      PCI PM: Power-manage devices without drivers during suspend-resume
      PCI PM: Move pci_has_legacy_pm_support
      PCI PM: Avoid touching devices behind bridges in unknown state
      PCI PM: Rearrange code in pci-driver.c
      PCI PM: Call pci_fixup_device from legacy routines
      PCI PM: Register power state of devices during initialization
      PCI PM: Run default PM callbacks for all devices using new framework
      PCI PM: Put PM callbacks in the order of execution

Rusty Russell (1):
      PCI: work_on_cpu: use in drivers/pci/pci-driver.c

Shaohua Li (1):
      PCI: keep ASPM link state consistent throughout PCIe hierarchy

Sheng Yang (3):
      PCI: Refactor pci_reset_function()
      PCI: add PCI Advanced Feature Capability defines
      PCI: Extend pci_reset_function() to support PCI Advanced Features

Stephen Hemminger (3):
      PCI: handle long delays in VPD access
      PCI: revise VPD access interface
      PCI: add interface to set visible size of VPD

Taku Izumi (3):
      PCI: revert additional _OSC evaluation
      PCI/ACPI: Remove unnecessary _OSC evaluation for control request
      pci-acpi: Cleanup _OSC evaluation code

Trent Piepho (1):
      PCI: Make settable sysfs attributes more consistent

Yu Zhao (9):
      PCI: enhance pci_ari_enabled()
      PCI: remove unnecessary arg of pci_update_resource()
      PCI: define PCI resource names in an 'enum'
      PCI: remove unnecessary condition check in pci_restore_bars()
      PCI: export __pci_read_base()
      PCI: allow pci_alloc_child_bus() to handle a NULL bridge
      PCI: add a new function to map BAR offsets
      PCI: cleanup pci_bus_add_devices()
      PCI: factor pci_bus_add_child() from pci_bus_add_devices()

 Documentation/PCI/pci.txt              |    3 +-
 Documentation/kernel-parameters.txt    |    4 +
 arch/alpha/kernel/pci.c                |   18 --
 arch/alpha/kernel/pci_impl.h           |   13 +-
 arch/alpha/kernel/sys_dp264.c          |    2 +-
 arch/alpha/kernel/sys_eiger.c          |    2 +-
 arch/alpha/kernel/sys_miata.c          |    2 +-
 arch/alpha/kernel/sys_noritake.c       |    2 +-
 arch/alpha/kernel/sys_ruffian.c        |    2 +-
 arch/alpha/kernel/sys_sable.c          |    2 +-
 arch/arm/include/asm/mach/pci.h        |    2 +-
 arch/arm/kernel/bios32.c               |   27 --
 arch/arm/mach-integrator/pci.c         |   11 +-
 arch/mips/pci/pci-ip27.c               |    6 -
 arch/mips/pci/pci.c                    |   24 +--
 arch/powerpc/kernel/prom_parse.c       |    7 +-
 arch/sh/drivers/pci/ops-cayman.c       |    9 +-
 arch/sh/drivers/pci/pci.c              |   22 +--
 arch/x86/kernel/pci-dma.c              |    2 +-
 arch/x86/mm/init_32.c                  |    2 +
 arch/x86/mm/init_64.c                  |    2 +
 arch/x86/pci/acpi.c                    |    7 +-
 arch/x86/pci/common.c                  |   12 +-
 arch/x86/pci/i386.c                    |    4 +-
 arch/x86/pci/init.c                    |    3 +-
 arch/x86/pci/irq.c                     |   54 ++--
 arch/x86/pci/visws.c                   |   20 +--
 drivers/acpi/pci_root.c                |   20 ++
 drivers/net/e1000e/netdev.c            |    2 +-
 drivers/net/sfc/falcon.c               |    4 +-
 drivers/parisc/dino.c                  |    4 +-
 drivers/parisc/iosapic.c               |    3 +-
 drivers/pci/Kconfig                    |    9 +
 drivers/pci/Makefile                   |    2 +
 drivers/pci/access.c                   |  226 ++++++++++-----
 drivers/pci/bus.c                      |   87 ++++---
 drivers/pci/hotplug/Makefile           |    3 +
 drivers/pci/hotplug/acpi_pcihp.c       |   69 +++++
 drivers/pci/hotplug/acpiphp.h          |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |  117 ++------
 drivers/pci/hotplug/acpiphp_ibm.c      |    2 +-
 drivers/pci/hotplug/cpqphp_ctrl.c      |    6 +-
 drivers/pci/hotplug/cpqphp_pci.c       |    2 +-
 drivers/pci/hotplug/fakephp.c          |    1 +
 drivers/pci/hotplug/pciehp.h           |   15 +-
 drivers/pci/hotplug/pciehp_acpi.c      |  141 +++++++++
 drivers/pci/hotplug/pciehp_core.c      |    1 +
 drivers/pci/hotplug/pciehp_ctrl.c      |   26 +-
 drivers/pci/hotplug/pciehp_hpc.c       |  329 ++++++--------------
 drivers/pci/irq.c                      |    2 +-
 drivers/pci/msi.c                      |   31 +--
 drivers/pci/pci-acpi.c                 |   82 +++---
 drivers/pci/pci-driver.c               |  420 ++++++++++++++++----------
 drivers/pci/pci-stub.c                 |   47 +++
 drivers/pci/pci-sysfs.c                |   95 +++----
 drivers/pci/pci.c                      |  513 +++++++++++++++++++++++++-------
 drivers/pci/pci.h                      |   34 ++-
 drivers/pci/pcie/aer/aerdrv_acpi.c     |    1 -
 drivers/pci/pcie/aer/aerdrv_errprint.c |    2 +-
 drivers/pci/pcie/aspm.c                |  165 ++++++++---
 drivers/pci/pcie/portdrv_bus.c         |   32 +--
 drivers/pci/pcie/portdrv_core.c        |  240 +++++++++------
 drivers/pci/pcie/portdrv_pci.c         |   21 +-
 drivers/pci/probe.c                    |   40 ++-
 drivers/pci/proc.c                     |   18 +-
 drivers/pci/quirks.c                   |  112 ++++++--
 drivers/pci/setup-bus.c                |    5 +-
 drivers/pci/setup-res.c                |   24 +-
 include/linux/ioport.h                 |   11 +-
 include/linux/pci-acpi.h               |   23 +-
 include/linux/pci.h                    |   90 ++++--
 include/linux/pci_hotplug.h            |    2 +
 include/linux/pci_regs.h               |   76 +++++-
 kernel/resource.c                      |   61 ++++-
 74 files changed, 2150 insertions(+), 1332 deletions(-)
 create mode 100644 drivers/pci/hotplug/pciehp_acpi.c
 create mode 100644 drivers/pci/pci-stub.c

Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbXJLXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbXJLXBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760799AbXJLWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:23:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58918 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbXJLWXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:23:04 -0400
Date: Fri, 12 Oct 2007 15:12:59 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.23
Message-ID: <20071012221259.GC4559@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI patches against your 2.6.23 git tree.

Nothing major here, just a number of bugfixes and updates and new
quirks.  See the shortlog below for details.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h


 Documentation/DMA-API.txt           |    3 +
 Documentation/MSI-HOWTO.txt         |   69 +-----------
 Documentation/kernel-parameters.txt |    8 ++
 arch/i386/Kconfig                   |    5 +
 arch/x86/kernel/pci-dma_32.c        |    3 +-
 arch/x86/kernel/pci-dma_64.c        |    1 +
 arch/x86/kernel/reboot_fixups_32.c  |    6 +
 arch/x86/pci/acpi.c                 |  194 ++++++++++++++++++++++++++++++++-
 arch/x86/pci/common.c               |   19 +++-
 arch/x86/pci/fixup.c                |   47 ++++++++
 arch/x86/pci/i386.c                 |   13 +++
 arch/x86/pci/irq.c                  |   39 +++++++
 arch/x86/pci/pci.h                  |    2 +
 arch/x86_64/Kconfig                 |    5 +
 drivers/pci/hotplug/cpqphp_core.c   |    2 +-
 drivers/pci/hotplug/cpqphp_ctrl.c   |   74 ++++---------
 drivers/pci/hotplug/ibmphp_hpc.c    |   57 ++--------
 drivers/pci/hotplug/pciehp_core.c   |   24 ++---
 drivers/pci/hotplug/pciehp_ctrl.c   |   20 ++--
 drivers/pci/hotplug/pciehp_hpc.c    |  203 +++++++++-------------------------
 drivers/pci/hotplug/pciehp_pci.c    |   24 +++--
 drivers/pci/msi.c                   |    2 +-
 drivers/pci/pci-driver.c            |    3 +-
 drivers/pci/pci.c                   |   20 +++-
 drivers/pci/pci.h                   |    6 +
 drivers/pci/pcie/Kconfig            |    9 --
 drivers/pci/pcie/aer/aerdrv.c       |    9 ++
 drivers/pci/probe.c                 |   53 +++++++---
 drivers/pci/proc.c                  |    7 +-
 drivers/pci/quirks.c                |   43 +-------
 drivers/pci/setup-bus.c             |    5 +
 include/asm-x86/pci.h               |   90 +++++++++++++++
 include/asm-x86/pci_32.h            |   58 ----------
 include/asm-x86/pci_64.h            |   56 ----------
 include/linux/pci.h                 |    7 +-
 include/linux/pci_ids.h             |    3 +
 include/linux/pci_regs.h            |    8 +-
 lib/swiotlb.c                       |    1 +
 38 files changed, 654 insertions(+), 544 deletions(-)

---------------

Alex Chiang (1):
      PCI: Add missing PCI capability IDs

Auke Kok (3):
      cpqphp: Use PCI_CLASS_REVISION instead of PCI_REVISION_ID for read
      PCI: quirk amd_8131_mmrbc: Omit reading pci revision ID
      PCI: quirk_vt82c586_acpi: Omit reading PCI revision ID

Christoph Hellwig (1):
      pci: hotplug: cpqphp: convert to kthread infrastructure

David Brownell (1):
      dma_free_coherent() needs irqs enabled (sigh)

David Rientjes (2):
      pci: use size stored in proc_dir_entry for proc bus files
      pci: write file size to inode on proc bus file write

Denis V. Lunev (1):
      PCI: pci_get_device call from interrupt in reboot fixups

Gary Hade (5):
      PCI: remove transparent bridge sizing
      PCI: skip ISA ioresource alignment on some systems
      PCI: avoid P2P prefetch window for expansion ROMs
      PCI: use _CRS for PCI resource allocation
      PCI: modify PCI bridge control ISA flag for clarity

Greg Kroah-Hartman (1):
      PCI: merge almost all of pci_32.h and pci_64.h together

Jeff Garzik (2):
      PCI: Add 'nodomains' boot option, and pci_domains_supported global
      PCI: X86: Introduce and enable PCI domain support

Johannes Goecke (1):
      PCI: re-enable onboard sound on "MSI K8T Neo2-FIR"

Juha Laiho (1):
      PCI: i386: Compaq EVO N800c needs PCI bus renumbering

Kenji Kaneshige (7):
      pciehp: remove CONFIG_HOTPLUG_PCI_PCIE_POLL_EVENT_MODE
      pciehp: remove DBG_XXX_ROUTINE
      pciehp: remove trailing whitespace from pciehp_hpc.c
      pciehp: remove trailing whitespace from pciehp_core.c
      pciehp: remove trailing whitespace from pciehp_ctrl.c
      pciehp: remove trailing whitespace form pciehp_pci.c
      pciehp: minor cleanups for pciehp_hpc.c

Kristen Carlson Accardi (3):
      PCI Hotplug: pciehp: Dont check bridge control on remove
      PCI Hotplug: pciehp: Request control over PCI Express Capability as well as Native hotplug
      pci: hotplug: ibmphp: convert to kthread

Mariusz Kozlowski (1):
      PCI Hotplug: cpqphp_ctrl.c: kmalloc + memset conversion to kzalloc

Michael Ellerman (2):
      PCI: Remove no longer correct documentation regarding MSI vector assignment
      PCI: Fix incorrect argument order to list_add_tail() in PCI dynamic ID code

Randy Dunlap (1):
      pci: implement "pci=noaer"

Roland Dreier (1):
      MSI: Use correct data offset for 32-bit MSI in read_msi_msg()

Thomas Backlund (1):
      i386: add support for picopower irq router

Yoichi Yuasa (1):
      PCI: fix IDE legacy mode resources

vignesh babu (1):
      PCI: is_power_of_2 in drivers/pci/pci.c


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422839AbXBHAbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422839AbXBHAbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:31:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422849AbXBHAaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:30:46 -0500
Received: from mail.suse.de ([195.135.220.2]:56305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422844AbXBHAal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:30:41 -0500
Date: Wed, 7 Feb 2007 16:29:32 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.20
Message-ID: <20070208002932.GC4796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of PCI patches against 2.6.20-git

They have a lot of PCI hotplug driver fixes and reworks, MSI cleanups
and fixes, and a number of other things.  See the full log below for
details.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 arch/alpha/kernel/pci.c           |    4 +
 arch/i386/kernel/io_apic.c        |   17 +-
 arch/ia64/kernel/msi_ia64.c       |   19 +-
 arch/ia64/sn/kernel/msi_sn.c      |   20 +-
 arch/powerpc/kernel/pci_64.c      |    2 -
 arch/x86_64/kernel/io_apic.c      |   17 +-
 drivers/net/bnx2.c                |    3 +-
 drivers/net/e1000/e1000_main.c    |    2 +-
 drivers/net/ixgb/ixgb_main.c      |    2 +-
 drivers/pci/hotplug/Kconfig       |    9 -
 drivers/pci/hotplug/pciehp.h      |  194 +++------
 drivers/pci/hotplug/pciehp_core.c |  292 +++++++-------
 drivers/pci/hotplug/pciehp_ctrl.c |  223 +++--------
 drivers/pci/hotplug/pciehp_hpc.c  |  827 ++++++++++++++-----------------------
 drivers/pci/hotplug/shpchp.h      |    4 +-
 drivers/pci/hotplug/shpchp_core.c |    4 -
 drivers/pci/hotplug/shpchp_ctrl.c |   20 +-
 drivers/pci/hotplug/shpchp_hpc.c  |  185 ++-------
 drivers/pci/msi.c                 |  325 ++++++----------
 drivers/pci/pci-driver.c          |    3 +-
 drivers/pci/pci.c                 |  171 +++++---
 drivers/pci/pci.h                 |   14 +-
 drivers/pci/probe.c               |   70 +++-
 drivers/pci/quirks.c              |  113 +++---
 drivers/pci/search.c              |   38 --
 drivers/scsi/ipr.c                |    3 -
 include/asm-alpha/pci.h           |    2 +
 include/asm-ia64/machvec.h        |    3 +-
 include/linux/irq.h               |    4 +
 include/linux/msi.h               |    5 +-
 include/linux/pci.h               |   22 +-
 kernel/irq/chip.c                 |   28 ++
 32 files changed, 1073 insertions(+), 1572 deletions(-)

---------------

Adrian Bunk (5):
      PCI: quirks.c: cleanup
      PCI: remove pci_find_device_reverse()
      PCI: mark pci_find_device() as __deprecated
      PCI: remove quirk_sis_96x_compatible()
      PCI: make isa_bridge Alpha-only

Daniel Yeisley (1):
      PCI Quirk: 1k I/O space IOBL_ADR fix on P64H2

Eric W. Biederman (6):
      msi: Kill msi_lookup_irq
      msi: Remove msi_lock.
      msi: Fix msi_remove_pci_irq_vectors.
      msi: Remove attach_msi_entry.
      msi: Kill the msi_desc array.
      msi: Make MSI useable more architectures

Greg Kroah-Hartman (3):
      PCI: remove duplicate device id from ata_piix
      PCI: remove duplicate device id from ipr
      Revert "PCI: remove duplicate device id from ata_piix"

Hidetoshi Seto (4):
      PCI : remove too specialized __pci_enable_device for default resume
      PCI : Move pci_fixup_device and is_enabled (originally intended change)
      PCI : add extremely specialized __pci_reenable_device for default resume
      PCI : Add selected_regions funcs

Jean Delvare (1):
      PCI: Speed up the Intel SMBus unhiding quirk

Kenji Kaneshige (12):
      pciehp: cleanup init_slot()
      pciehp: cleanup slot list
      pciehp: remove unnecessary php_ctlr
      pciehp: remove unused pci_bus from struct controller
      pciehp: cleanup register access
      pciehp: cleanup pciehp.h
      pciehp: remove unused pcie_cap_base
      pciehp: cleanup wait command completion
      pciehp: fix wait command completion
      shpchp: remove CONFIG_HOTPLUG_PCI_SHPC_POLL_EVENT_MODE
      shpchp: remove DBG_XXX_ROUTINE
      shpchp: delete trailing whitespace

Kristen Carlson Accardi (1):
      PCIEHP: Add Electro Mechanical Interlock (EMI) support to the PCIE hotplug driver.

Linas Vepstas (2):
      PCI: define inline for test of channel error state
      PCI: Use newly defined PCI channel offline routine

Michael Ellerman (3):
      MSI: Replace pci_msi_quirk with calls to pci_no_msi()
      MSI: Remove pci_scan_msi_device()
      MSI: Combine pci_(save|restore)_msi/msix_state

Pavel Machek (1):
      PCI: power management: remove noise on non-manageable hw

Satoru Takeuchi (1):
      PCI: cleanup MSI code

Yinghai Lu (1):
      PCI: check szhi when sz is 0 when 64 bit iomem bigger than 4G


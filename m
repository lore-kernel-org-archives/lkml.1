Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbZFPV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbZFPV0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZFPVZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:25:55 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:35181 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751078AbZFPVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:25:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ntGO4uaRIoBmY9Lcje0NjpbZFCTCmSroQHypwzJGhUN2OPG60NZbFjAbqUl5BWbrEz34Y7u753zHW+oD+3c46gUvvT+A71yFY8KohaTFD75ubO3MRFSeyokHTXu1ZYIj;
Date: Tue, 16 Jun 2009 14:25:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in pci-2.6.git
Message-ID: <20090616142554.7bce02f6@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the queue together for my next pull request.  See below for
the shortlog.

On a high level there are a few important, new features & highlights:
  - improved AER support
    Thanks to Yanmin the AER code can now handle multiple errors and
    chips that don't correctly set the source ID.  It does this by
    scanning the bus when such a condition is detected, looking for the
    errors.  Huang contributed some code to help test this feature as
    well; driver developers are encouraged to use it.
  - PCI resource allocation fixes
    Yinghai sent some fixes for resource allocation for transparent
    brdiges & prefetchable regions.  We also try to use _CRS data by
    default now.
  - no more pci_find_slot!  (Kudos again to Alex for his work this
    cycle.)
  - and the usual collection of misc cleanups & fixes

In looking at the shortlog I just realized the authorship info for the
check_enable_amd_mmconf and overflow quirk patches are wrong, so we're
still at least one rebase away from having a tree that's ready to pull.

I think the only other patchset left outstanding is Kenji-san's ASPM
cleanups; I'm waiting on some more review for those.  I think we'll be
able to squeeze them in this cycle assuming that happens soon.  Oh and
there's my Moorestown platform support code.  I got some good review on
that, so I'll be cleaning it up and sending out another patch this
week, with an eye towards merging it this week as well (though I'm not
sure if some of the other bits will be ready; I'll talk with the
Moorestown folks about that, maybe there's no hurry).

If all goes well I'll be sending Linus a pull request later this week,
so please test & report issues as soon as possible!

Thanks,
Jesse

Alex Chiang (16):
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

Andrew Patterson (1):
      PCI: Add support for turning PCIe ECRC on or off

Greg Kroah-Hartman (1):
      PCIE: remove driver_data direct access of struct device

Hidetoshi Seto (2):
      PCI MSI: Remove unused/obsolete macros and definitions
      PCI MSI: Define PCI_MSI_MASK_32/64

Huang Ying (4):
      PCI: Add pci_bus_set_ops
      PCI: PCIE AER: export aer_irq
      PCI: PCIE AER: Document for PCIE AER software error injection
      PCI AER: software error injection

Ingo Molnar (1):
      x86/PCI: add description for check_enable_amd_mmconf boot parameter

Jesse Barnes (1):
      PCI: use ACPI _CRS data by default

Kenji Kaneshige (11):
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

Mats Erik Andersson (1):
      PCI: expose SMBus on Asus notebook A6L

Michael S. Tsirkin (1):
      PCI MSI: let drivers retry when not enough vectors

Michal Miroslaw (1):
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

akpm@linux-foundation.org (2):
      PCI: ibmphp_core.c: fix warning due to missing module_exit()
      PCI quirk: unhide 'Overflow' device on i828{6,7}5P/PE chipsets


-- 
Jesse Barnes, Intel Open Source Technology Center

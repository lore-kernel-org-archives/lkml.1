Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZIXQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZIXQAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZIXQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:00:14 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:46996 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752005AbZIXQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:00:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jcj5VqqP6ZeWcsg1vimEwXSfumAhWjysyDp3UxEq0VOSXsOpX1opX60HIBsDBkMBSSuDtO02rmqjwfL5nK6SVLxKxDLh4UQnG4OboyWwkW1AAYhtgc2/A5qOdgVIBbxe;
Date: Thu, 24 Sep 2009 09:00:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] more PCI for 2.6.32
Message-ID: <20090924090014.70ccccd3@jbarnes-x200>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 72.254.60.164 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
ab86e5765d41a5eb4239a1c04d613db87bea5ed8: Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/driver-core-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

A few bug fixes for the NUMA node init change and a big set of cleanups for
the PCIe hotplug driver from Kenji-san.

Things should be fairly settled down now.

Andi Kleen (1):
      PCI: Disable AER with pci=nomsi

David Rientjes (1):
      x86/PCI: default pcibus cpumask to all cpus if it lacks affinity

Jesse Barnes (3):
      PCI: fix VGA arbiter header file
      MAINTAINTERS: remove hotplug driver entries
      x86/PCI: make 32 bit NUMA node array int, not unsigned char

Kenji Kaneshige (16):
      PCI ASPM: support L1 only
      PCI: pciehp: remove slot_list field
      PCI: pciehp: remove num_slots field
      PCI: pciehp: remove slot_num_inc field
      PCI: pciehp: remove bus field
      PCI: pciehp: remove device field
      PCI: pciehp: remove hp_slot field
      PCI: pciehp: remove slot_device_offset field
      PCI: pciehp: remove first_slot field
      PCI: pciehp: remove slot_bus field
      PCI: pciehp: remove crit_sect mutex
      PCI: pciehp: remove pci_dev field
      PCI: pciehp: remove hpc_ops
      PCI: pciehp: remove number field
      PCI: pciehp: remove error message definitions
      PCI: pciehp: remove slot capabilities definitions

 MAINTAINERS                       |   18 +----
 arch/x86/include/asm/pci.h        |    6 ++-
 arch/x86/pci/common.c             |    2 +-
 drivers/pci/hotplug/pciehp.h      |  107 ++++++++---------------------
 drivers/pci/hotplug/pciehp_acpi.c |   17 +++--
 drivers/pci/hotplug/pciehp_core.c |  136 +++++++++++++++++--------------------
 drivers/pci/hotplug/pciehp_ctrl.c |  109 ++++++++++++------------------
 drivers/pci/hotplug/pciehp_hpc.c  |  109 +++++++++---------------------
 drivers/pci/hotplug/pciehp_pci.c  |   23 +++---
 drivers/pci/pcie/aer/aerdrv.c     |    2 +
 drivers/pci/pcie/aspm.c           |    3 -
 include/linux/vgaarb.h            |    3 +-
 12 files changed, 203 insertions(+), 332 deletions(-)

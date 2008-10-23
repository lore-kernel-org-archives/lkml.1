Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYJWAOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYJWAOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJWAOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:14:23 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:47518 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751868AbYJWAOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:14:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ovH6fGyZFPTxmn48v1mJVk/MjH6KqxUUbUPaGDlv9T82zhpH2an6ugWTu7fgSCgZqcxvBiCNbEFbvsB3sEL53jPeYMA2FXLQcA/xsXcsTBN+5NP/uUMFnLsw/tY2UbVE;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI pull request #2 for 2.6.28
Date: Wed, 22 Oct 2008 17:14:18 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221714.18723.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my linux-next branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git linux-next

A few more bits for 2.6.28, mainly hotplug related stuff so the risk should be
pretty low.  There are a few good fixes in here though too: a build fix for
some architectures due to the new ioremap_nocache usage in pci.h and a fix for
a refcounting bug.

Thanks,
Jesse

Alex Chiang (16):
      PCI Hotplug core: add 'name' param pci_hp_register interface
      PCI: rename pci_update_slot_number to pci_renumber_slot
      PCI: update pci_create_slot() to take a 'hotplug' param
      PCI: prevent duplicate slot names
      PCI: acpiphp: remove 'name' parameter
      PCI: cpci_hotplug: stop managing hotplug_slot->name
      PCI: cpqphp: stop managing hotplug_slot->name
      PCI, PCI Hotplug: introduce slot_name helpers
      PCI: fakephp: remove 'name' parameter
      PCI: ibmphp: stop managing hotplug_slot->name
      PCI: pciehp: remove 'name' parameter
      PCI: rpaphp: kmalloc/kfree slot->name directly
      PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
      PCI: shcphp: remove 'name' parameter
      PCI: Hotplug core: remove 'name'
      PCI Hotplug: fakephp: add duplicate slot name debugging

Benjamin Herrenschmidt (1):
      PCI: Workaround invalid P2P bridge bus numbers

Geert Uytterhoeven (1):
      PCI: PCI_QUIRKS depends on PCI

Jesse Barnes (2):
      PCI: include io.h in pci.h so that ioremap_nocache is defined
      Remove PCI hotplug core MAINTAINERS entry

Julia Lawall (1):
      PCI hotplug: fix logic in Compaq hotplug controller bus speed setup

Kenji Kaneshige (3):
      PCI Hotplug: serialize pci_hp_register and pci_hp_deregister
      PCI hotplug: pciehp: fix possible memory leak in pcie_init
      PCI hotplug: pciehp: poll data link layer link active

Matthew Wilcox (1):
      PCI: Fix reference counting bug

Sheng Yang (1):
      PCI: add support for function level reset

Stephen Rothwell (1):
      PCI: don't export linux/io.h from pci.h

Taku Izumi (5):
      ACPI/PCI: Fix possible race condition on _OSC evaluation
      ACPI/PCI: Change pci_osc_control_set() to query control bits first
      ACPI/PCI: Always query _OSC control field in pci_osc_control_set()
      ACPI/PCI: Fix return value of acpi_cuery_osc()
      ACPI/PCI: Set support bit for MSI in support field of _OSC

 MAINTAINERS                             |    5 -
 drivers/acpi/pci_slot.c                 |    2 +-
 drivers/pci/hotplug/acpiphp.h           |    9 +-
 drivers/pci/hotplug/acpiphp_core.c      |   32 ++++---
 drivers/pci/hotplug/cpci_hotplug.h      |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c |   75 ++++++---------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 +-
 drivers/pci/hotplug/cpqphp.h            |   13 +--
 drivers/pci/hotplug/cpqphp_core.c       |   43 ++++-----
 drivers/pci/hotplug/cpqphp_ctrl.c       |    2 +-
 drivers/pci/hotplug/fakephp.c           |   26 ++++--
 drivers/pci/hotplug/ibmphp.h            |    5 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 ++---
 drivers/pci/hotplug/pci_hotplug_core.c  |   64 +++++--------
 drivers/pci/hotplug/pciehp.h            |   10 ++-
 drivers/pci/hotplug/pciehp_core.c       |   49 ++++------
 drivers/pci/hotplug/pciehp_ctrl.c       |   56 ++++++-----
 drivers/pci/hotplug/pciehp_hpc.c        |   60 +++++++++++-
 drivers/pci/hotplug/rpaphp_slot.c       |   10 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   18 +---
 drivers/pci/hotplug/shpchp.h            |    9 +-
 drivers/pci/hotplug/shpchp_core.c       |   52 ++++-------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 +++++-----
 drivers/pci/msi.c                       |   21 ++++
 drivers/pci/pci-acpi.c                  |   85 ++++++++++------
 drivers/pci/pci.c                       |  101 +++++++++++++++++++
 drivers/pci/pci.h                       |    2 +
 drivers/pci/probe.c                     |   12 ++-
 drivers/pci/search.c                    |    9 +-
 drivers/pci/slot.c                      |  160 +++++++++++++++++++++++--------
 include/linux/pci.h                     |   13 ++-
 include/linux/pci_hotplug.h             |   11 ++-
 include/linux/pci_regs.h                |    2 +
 init/Kconfig                            |    3 +-
 34 files changed, 637 insertions(+), 399 deletions(-)


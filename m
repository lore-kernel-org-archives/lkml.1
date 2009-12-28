Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZL1QKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZL1QKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZL1QKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:10:10 -0500
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:44404 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751349AbZL1QKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:10:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JCA8WkD2k3HptIqqCui6eytWSFR/MHyP/GtapNGLo034KrY/3P2fPGlFD6d/2uMT4Tj5rNY8Ef/UnrY7tn3FnM5DNibrDqAYQ+yBhlJcISAwecZWIo+zcL0TZt7QW2jH;
Date: Mon, 28 Dec 2009 08:10:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20091228081002.71f0e3b9@jbarnes-x200>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.118.45.122 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
  Stephen Rothwell (1):
        mfd: compile fix for twl4030 renaming

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

A few misc fixes.  A few people have run into the CLS bug so far, which Csaba
kindly provided a fix for (detection of PCI cache line size is a good
improvement, but it will fail in some cases due to a virtualized or buggy
platform).

This set also adds the device specific reset quirk code from Dexuan;
needed for some devices especially in virtualized environments.

Benjamin Herrenschmidt (1):
      PCI/cardbus: Add a fixup hook and fix powerpc

Csaba Henk (1):
      PCI: Handle case when no pci device can provide cache line size hint

Detlef Riekenberg (1):
      vgaarbiter: fix a typo in the vgaarbiter Documentation

Dexuan Cui (3):
      PCI: support device-specific reset methods
      PCI: add Intel USB specific reset method
      PCI: add Intel 82599 Virtual Function specific reset method

Jiri Slaby (1):
      PCI: fix section mismatch on update_res()

Rafael J. Wysocki (1):
      PCI/PM: Propagate wake-up enable for PCIe devices too

Stefan Assmann (2):
      PCI: change PCI nomenclature in drivers/pci/ (comment changes)
      PCI: change PCI nomenclature in drivers/pci/ (non-comment changes)

 Documentation/vgaarbiter.txt           |    2 +-
 arch/powerpc/kernel/pci-common.c       |   13 +++++++
 arch/x86/pci/bus_numa.c                |    2 +-
 drivers/pci/hotplug/shpchp.h           |    2 +-
 drivers/pci/intel-iommu.c              |    6 ++--
 drivers/pci/intr_remapping.c           |    2 +-
 drivers/pci/pci-acpi.c                 |   10 +----
 drivers/pci/pci.c                      |   30 +++++++++++++++--
 drivers/pci/pci.h                      |    8 ++++
 drivers/pci/pcie/aer/Kconfig.debug     |    4 +-
 drivers/pci/pcie/aer/aer_inject.c      |    6 ++--
 drivers/pci/pcie/aer/aerdrv.c          |    2 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c     |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c     |    6 ++--
 drivers/pci/pcie/aer/aerdrv_errprint.c |    4 +-
 drivers/pci/pcie/aspm.c                |    4 +-
 drivers/pci/pcie/portdrv_pci.c         |    2 +-
 drivers/pci/quirks.c                   |   57 +++++++++++++++++++++++++++++++-
 drivers/pci/search.c                   |    6 ++--
 drivers/pcmcia/cardbus.c               |    2 +-
 include/linux/pci.h                    |    3 ++
 21 files changed, 135 insertions(+), 38 deletions(-)

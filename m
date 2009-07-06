Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZGFSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZGFSBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZGFSBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:01:06 -0400
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:50348 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752126AbZGFSBF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:01:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qZWOdseh14bhJWoQenAp1Z7KOedPvKgwFlrSqXwAvNk1DKe1myG4EtDZl2pJ0bJq/ZI24MuSdZbp0GXp6JuvYdyVIpJAacgpkiQg4uwUj92h1GrACjv52GxhqWil4Cwb;
Date: Mon, 6 Jul 2009 11:00:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090706110059.619cc802@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2bfdd79eaa0043346e773ba5f6cfd811ea31b73d:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Nothing too exciting here (as one would hope).  A few fixes for the
_CRS case (which is no longer the default), along with misc MSI fixes
and quirks.

Shortlog & diffstat below.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

Alan Cox (1):
      PCI: More PATA quirks for not entering D3

Alexey Zaytsev (1):
      PCI: make pci_name() take const argument

Fernando Luis Vázquez Cao (1):
      PCI: remove pci_dac_dma_... APIs on mn10300

Hidetoshi Seto (4):
      PCI MSI: Return if alloc_msi_entry for MSI-X failed
      PCI MSI: shorten PCI_MSIX_ENTRY_* symbol names
      PCI MSI: Unmask MSI if setup failed
      PCI MSI: Fix restoration of MSI/MSI-X mask states in suspend/resume

Ingo Molnar (1):
      ia64/PCI: adjust section annotation for pcibios_setup()

Joe Perches (1):
      PCI ECRC: Remove unnecessary semicolons

Matthew Wilcox (1):
      PCI: Fix IRQ swizzling for ARI-enabled devices

Randy Dunlap (1):
      PCI: fix kernel-doc warnings

Yinghai Lu (2):
      x86/PCI: fix boundary checking when using root CRS
      x86/PCI: get root CRS before scanning children

Yu Zhao (1):
      PCI: check if bus has a proper bridge device before triggering SBR

 arch/ia64/pci/pci.c                    |    2 +-
 arch/mn10300/include/asm/pci.h         |    4 --
 arch/x86/pci/acpi.c                    |   59 ++++++++++++-----------------
 arch/x86/pci/amd_bus.c                 |    8 +++-
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +
 drivers/pci/msi.c                      |   64 ++++++++++++++++++++++---------
 drivers/pci/msi.h                      |   10 ++--
 drivers/pci/pci.c                      |   15 ++++++-
 drivers/pci/pcie/aer/ecrc.c            |    2 +-
 drivers/pci/quirks.c                   |    5 ++
 drivers/pci/slot.c                     |    4 +-
 include/linux/pci.h                    |    2 +-
 12 files changed, 104 insertions(+), 73 deletions(-)

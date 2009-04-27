Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbZD0SzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbZD0SzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZD0Syx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:54:53 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:55362 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751638AbZD0Syw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:54:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hQtuVFMBJMOBYbaYuHCAOG7bgGF8xkPsOAgxex+DkPVKhavEpuMa6j982ojvUPP+2D0MoHkkRxKlr/FYFXTv6YQCMPXLGL0suRrNP2v8LdA8yoWDVploHXf9o9m54ReE;
Date: Mon, 27 Apr 2009 11:54:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090427115447.027b5a80@hobbes>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
091069740304c979f957ceacec39c461d0192158: Linus Torvalds (1):
        Linux 2.6.30-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Nothing major here; a few fixes from Yinghai (with attendant cleanups,
hope that's ok; rather than rolling them into the original patch they
came in piecemeal), and one suspend/resume fix from Yu (which hasn't
actually bitten anyone afaik).

Thanks,
Jesse

Matthew Wilcox (1):
      x86/PCI: Move set_pci_bus_resources_arch_default into arch/x86

Randy Dunlap (1):
      docbooks: add/fix PCI kernel-doc

Thomas Renninger (1):
      PCI quirk: disable MSI on VIA VT3364 chipsets

Yinghai Lu (4):
      x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case
      x86/PCI: set_pci_bus_resources_arch_default cleanups
      PCI: cleanup debug output resources
      x86/PCI: don't bother with root quirks if _CRS is used

Yu Zhao (1):
      PCI: only save/restore existent registers in the PCIe capability

 Documentation/DocBook/kernel-api.tmpl |    6 ++-
 arch/x86/include/asm/topology.h       |    2 +-
 arch/x86/pci/amd_bus.c                |    6 ++-
 arch/x86/pci/common.c                 |    5 ++-
 arch/x86/pci/i386.c                   |    4 ++
 arch/x86/pci/mmconfig-shared.c        |    6 +-
 drivers/pci/access.c                  |    4 +-
 drivers/pci/htirq.c                   |    1 +
 drivers/pci/pci-sysfs.c               |   12 ++++--
 drivers/pci/pci.c                     |   70 ++++++++++++++++++++++++++-------
 drivers/pci/probe.c                   |    6 ---
 drivers/pci/quirks.c                  |    1 +
 drivers/pci/setup-bus.c               |    6 ++-
 drivers/pci/slot.c                    |    4 +-
 include/linux/pci_regs.h              |    1 +
 15 files changed, 97 insertions(+), 37 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbZJFVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbZJFVeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbZJFVeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:03 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17811 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbZJFVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:01 -0400
Subject: [PATCH 0/7] PCI, PNP: print resources consistently
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:24 -0600
Message-ID: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These enhance %pR so we can print resource types and flags more easily.
This doesn't really add anything (other than a couple new messages
about host bridge apertures), but hopefully it will make things more
consistent and a bit easier to debug.  Sample change (with "pci=use_crs"):

    -pci 0000:00:03.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
    -pci 0000:00:03.0: reg 14 io port: [0x2400-0x24ff]
    -pci 0000:00:03.0: reg 18 32bit mmio: [0xf5ff0000-0xf5ff0fff]
    -pci 0000:00:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
    +pci_root PNP0A03:00: host bridge window: [io  0x0000-0x0cff]
    +pci_root PNP0A03:00: host bridge window: [io  0x0000-0x2cfe]
    +pci_root PNP0A03:00: host bridge window: [io  0x03b0-0x03bb]
    +pci_root PNP0A03:00: host bridge window: [io  0x03c0-0x03df]
    +pci_root PNP0A03:00: host bridge window: [mem 0xf5d00000-0xf6ffffff]
    +pci_root PNP0A03:00: host bridge window: [mem 0x000a0000-0x000bffff]
    +pci 0000:00:03.0: reg 10: [mem 0xf6000000-0xf6ffffff]
    +pci 0000:00:03.0: reg 14: [io  0x2400-0x24ff]
    +pci 0000:00:03.0: reg 18: [mem 0xf5ff0000-0xf5ff0fff]
    +pci 0000:00:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]

---

Bjorn Helgaas (7):
      vsprintf: fix io/mem resource width
      vsprintf: add %pR support for IRQ and DMA resources
      vsprintf: add %pRt, %pRf to print struct resource details
      PCI: print resources consistently with %pRt
      x86/PCI: print resources consistently with %pRt
      ia64/PCI: print resources consistently with %pRt
      PNP: print resources consistently with %pRt


 arch/ia64/pci/pci.c     |   21 +++++++++---
 arch/x86/pci/acpi.c     |   14 ++++++--
 arch/x86/pci/i386.c     |   12 +++----
 drivers/pci/pci.c       |    4 +-
 drivers/pci/probe.c     |   26 +++++----------
 drivers/pci/setup-bus.c |    9 ++---
 drivers/pci/setup-res.c |   28 +++++++---------
 drivers/pnp/quirks.c    |   12 ++-----
 drivers/pnp/resource.c  |   10 ++----
 drivers/pnp/support.c   |   43 +++----------------------
 drivers/pnp/system.c    |   14 ++++----
 lib/vsprintf.c          |   80 ++++++++++++++++++++++++++++++++++++++---------
 12 files changed, 138 insertions(+), 135 deletions(-)

-- 
Bjorn

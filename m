Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZGJTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZGJTmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZGJTmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:42:35 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:23700 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbZGJTme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:42:34 -0400
Subject: [PATCH 0/3] ACPI/PCI Hotplug: acpiphp cleanup
To: jbarnes@virtuousgeek.org, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Fri, 10 Jul 2009 13:42:33 -0600
Message-ID: <20090710193601.30165.62311.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len, Jesse,

I'd like to have this patch series considered for the current release
because it clarifies some usage of the new interface acpi_get_pci_dev()
that was also introduced in this release cycle.

The short story is, acpi_get_pci_dev() doesn't always return a struct
pci_dev, because a PCI root bridge may not have an associated pci_dev on
platforms with non-materialized root bridges.

See this patch for more:

	http://patchwork.kernel.org/patch/32613/

I had to export acpi_pci_root to accomplish my goal, but it did result
in a nice net cleanup in acpiphp.

It should probably go through Jesse's tree, but needs Len's ACK for
the acpi_pci_root bit.

Thanks.

/ac

---

Alex Chiang (3):
      ACPI: export acpi_pci_root and friends
      PCI Hotplug: acpiphp: find bridges the easy way
      PCI Hotplug: convert acpi_pci_detect_ejectable() to take an acpi_handle


 drivers/acpi/pci_root.c            |   17 +------
 drivers/pci/hotplug/acpi_pcihp.c   |    9 +---
 drivers/pci/hotplug/acpiphp_glue.c |   92 +++++++++---------------------------
 drivers/pci/hotplug/pciehp_acpi.c  |    5 +-
 include/acpi/acpi_bus.h            |   14 +++++
 include/linux/pci_hotplug.h        |    2 -
 6 files changed, 47 insertions(+), 92 deletions(-)


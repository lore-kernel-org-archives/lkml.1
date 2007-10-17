Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXJQBxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXJQBxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbXJQBx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:53:26 -0400
Received: from rtr.ca ([76.10.145.34]:3399 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760560AbXJQBx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:53:26 -0400
Message-ID: <47156B14.2080608@rtr.ca>
Date: Tue, 16 Oct 2007 21:53:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 0/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca>
In-Reply-To: <471533AF.60100@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Original single patch is now broken out into tiny pieces for easier review.

Also, valuable feedback from Ted has been incorporated,
to avoid any possible side effects on regular use of
the PCIe hotplug stuff (when used without pciehp_force=1 mod parm).

* * *

Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
in conjunction with the modparam of pciehp_force=1.

The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
which lack ACPI BIOS support for PCIe hotplug:

1. The driver does not recognise cards that were inserted prior
to the driver being modprobe'd.

2. The driver stops functioning after a suspend/resume (RAM) cycle,
and needs to be rmmod'd and modprobe'd to get it working again.

This patch series addresses those issues, resulting in a completely
functional PCIe Hotplug driver for Dell notebooks, and probably others
as well, which may lack ACPI BIOS support for this.

There are four patches in this series:

	01_pciehp_cosmetic_fixes.patch
		-- cosmetic fixes, mostly to keep checkpatch.pl happy

	02_pciehp_handle_preinserted_card.patch
		-- fixes problem number 1 (above).

	03_pciehp_split_pcie_init.patch
		-- preparation for the resume patch.

	04_pciehp_resume.patch
		-- fixes problem number 2 (above).

diffstat summary for 01_pciehp_cosmetic_fixes.patch only:
 drivers/pci/hotplug/pciehp_core.c |    6 -
 drivers/pci/hotplug/pciehp_ctrl.c |    2
 drivers/pci/hotplug/pciehp_hpc.c  |  119 ++++++++++++++--------------
 3 files changed, 65 insertions(+), 62 deletions(-)

diffstat summary for the other three patches combined:
 drivers/pci/hotplug/pciehp.h      |    3
 drivers/pci/hotplug/pciehp_core.c |   21 ++-
 drivers/pci/hotplug/pciehp_ctrl.c |    2
 drivers/pci/hotplug/pciehp_hpc.c  |  194 ++++++++++++++++------------
 4 files changed, 134 insertions(+), 86 deletions(-)

Cheers
--
Mark Lord <mlord@pobox.com>

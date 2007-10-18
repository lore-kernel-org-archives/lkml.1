Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbXJRC57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbXJRC57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764255AbXJRC5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:57:36 -0400
Received: from rtr.ca ([76.10.145.34]:2173 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764221AbXJRC5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:57:35 -0400
Message-ID: <4716CB9D.6080503@rtr.ca>
Date: Wed, 17 Oct 2007 22:57:33 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: [PATCH 0/3] Fix two PEIe hotplug issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
(and others?) in conjunction with the modparam of pciehp_force=1.

The PCIe Hotplug driver has two issues when used on Dell notebooks
which lack ACPI BIOS support for PCIe hotplug:

1. The driver does not recognise cards that were inserted 
   prior to the driver being modprobe'd.

2. The driver stops functioning after a suspend/resume (RAM) cycle,
   and needs to be rmmod'd and modprobe'd to get it working again.

This patch series addresses those issues, resulting in a completely
functional PCIe Hotplug driver for Dell notebooks, and possibly others
as well which may lack ACPI BIOS support for this.
Note that pciehp_force=1 is (still) required.

There are three patches in this series:

	01_pciehp_handle_preinserted_card.patch
		-- fixes problem number 1 (above).

	02_pciehp_split_pcie_init.patch
		-- preparation for the resume patch.

	03_pciehp_resume_reinit_hardware.patch
		-- fixes problem number 2 (above).

diffstat summary for the three patches combined:
 drivers/pci/hotplug/pciehp.h      |    3
 drivers/pci/hotplug/pciehp_core.c |   23 +++
 drivers/pci/hotplug/pciehp_ctrl.c |    2
 drivers/pci/hotplug/pciehp_hpc.c  |  185 +++++++++++++++-------------
 4 files changed, 130 insertions(+), 83 deletions(-)

Cheers
--
Mark Lord <mlord@pobox.com>

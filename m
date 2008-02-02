Return-Path: <linux-kernel-owner+w=401wt.eu-S934813AbYBBXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbYBBXqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764596AbYBBXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:46:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760888AbYBBXqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:46:05 -0500
Date: Sat, 2 Feb 2008 15:44:12 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.24-git
Message-ID: <20080202234412.GB21721@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some PCI patches against your 2.6.24 git tree.

They rip out the PCIE ASPM patch, as it was causing both build errors,
and run-time oopses, fixes a build error in the scsi tree caused by a
clueless kernel developer who forgot to check in his fix on his
machine[1], and 2 patches to fix some of the section warnings in the PCI
code that are now showing up.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/


The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h

[1] yeah, that was me, ugh...

-------------

 drivers/pci/Makefile          |    3 +
 drivers/pci/hotplug-pci.c     |   20 +
 drivers/pci/pci-sysfs.c       |    5 -
 drivers/pci/pci.c             |    4 -
 drivers/pci/pcie/Kconfig      |   20 -
 drivers/pci/pcie/Makefile     |    3 -
 drivers/pci/pcie/aspm.c       |  802 -----------------------------------------
 drivers/pci/probe.c           |   24 +--
 drivers/pci/remove.c          |    4 -
 drivers/pci/setup-bus.c       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 include/linux/aspm.h          |   44 ---
 include/linux/pci.h           |    5 -
 include/linux/pci_regs.h      |    8 -
 14 files changed, 28 insertions(+), 920 deletions(-)
 create mode 100644 drivers/pci/hotplug-pci.c
 delete mode 100644 drivers/pci/pcie/aspm.c
 delete mode 100644 include/linux/aspm.h

---------------

Greg Kroah-Hartman (2):
      Revert "PCI: PCIE ASPM support"
      pci: pci_enable_device_bars() fix for lpfc driver

Sam Ravnborg (2):
      PCI: fix section mismatch warnings referring to pci_do_scan_bus
      PCI: fix 4x section mismatch warnings


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbXIZVF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbXIZVF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761835AbXIZVF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:05:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56812 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762070AbXIZVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:05:24 -0400
Date: Wed, 26 Sep 2007 14:00:10 -0700
From: Greg KH <gregkh@suse.de>
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net
Subject: State of the Linux PCI Subsystem for 2.6.23-rc8
Message-ID: <20070926210010.GC1734@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a summary of the current state of the Linux PCI subsystem, as of
2.6.23-rc8.

If the information in here is incorrect, or anyone knows of any
outstanding issues not listed here, please let me know.

List of outstanding regressions from 2.6.22:
	- none known.

List of outstanding regressions from older kernel versions:
	- none known.


If interested, the list of all currently open PCI bugs can be seen at:
    http://bugzilla.kernel.org/showdependencytree.cgi?id=5829&hide_resolved=1


Future patches that are currently in my quilt tree (as found at
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
) for the PCI subsystem are as follows.  All of these will be submitted
for inclusion into 2.6.24, except as noted.  The diffstat of these
patches is included at the bottom of this message for those that are
interested.

	- various pci quirks for different devices
	- pci hotplug driver kthread conversion
	- pci hotplug bugfixes
	- pci express hotplug tweaks and fixes
	- minor bugfixes and cleanups
	- MSI documentation update

	- pci bridge device rework.  Note, this was reported to break
	  Andrew's x86-64 box, but he lost the picture he took of the
	  oops.  Others reported that it worked just fine on their
	  boxes.  I'm still a little hesitant of sending this to 2.6.24
	  until I can track down what happened here.

There are no PCI api changes scheduled for 2.6.24.


thanks,

greg k-h

----------------------------

Diffstat of the current pci-2.6 quilt queue:

 Documentation/DMA-API.txt         |    3 
 Documentation/MSI-HOWTO.txt       |   69 ------------
 arch/i386/kernel/pci-dma.c        |    3 
 arch/i386/kernel/reboot_fixups.c  |    6 +
 arch/i386/pci/common.c            |   10 +
 arch/i386/pci/fixup.c             |   47 ++++++++
 arch/i386/pci/irq.c               |   39 +++++++
 arch/x86_64/kernel/pci-dma.c      |    1 
 drivers/pci/bus.c                 |   17 ++-
 drivers/pci/hotplug/cpqphp_core.c |    2 
 drivers/pci/hotplug/cpqphp_ctrl.c |   74 ++++---------
 drivers/pci/hotplug/ibmphp_hpc.c  |   57 ++--------
 drivers/pci/hotplug/pciehp_core.c |   24 +---
 drivers/pci/hotplug/pciehp_ctrl.c |   20 +--
 drivers/pci/hotplug/pciehp_hpc.c  |  209 ++++++++++----------------------------
 drivers/pci/hotplug/pciehp_pci.c  |   24 ++--
 drivers/pci/pci-driver.c          |    3 
 drivers/pci/pci.c                 |    5 
 drivers/pci/pci.h                 |    2 
 drivers/pci/pcie/Kconfig          |    9 -
 drivers/pci/probe.c               |   82 +++++++-------
 drivers/pci/quirks.c              |   43 -------
 drivers/pci/remove.c              |    6 -
 include/linux/pci.h               |    4 
 include/linux/pci_ids.h           |    3 
 include/linux/pci_regs.h          |    6 -
 lib/swiotlb.c                     |    1 
 27 files changed, 316 insertions(+), 453 deletions(-)

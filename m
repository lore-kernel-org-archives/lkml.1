Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYBOAnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYBOAnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbYBOAmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYBOAmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:16 -0500
Date: Thu, 14 Feb 2008 16:39:09 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [RFC] PCI: remove the "shadow" device list
Message-ID: <20080215003909.GA27981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a series of 12 patches that I've added to my quilt tree for
2.6.26 that delete the "shadow" PCI device tree.  There is no real need
to keep two lists of all PCI devices in the kernel, the driver core
should be able to properly handle all of this.

We do keep the bus list of devices, as that is still useful for a lot of
things, and I don't see any obviously easy way to clean that up at the
moment.

Overall, the patch ends up deleting a lot of code, which is always a
good thing.

Comments are appreciated.

thanks,

greg k-h

----------------------

 Documentation/kernel-parameters.txt        |    4 -
 arch/frv/mb93090-mb00/pci-frv.h            |    2 -
 arch/frv/mb93090-mb00/pci-vdk.c            |   53 -----
 arch/mn10300/unit-asb2305/pci-asb2305.h    |    2 -
 arch/powerpc/platforms/pseries/pci_dlpar.c |    7 +-
 arch/sh/drivers/pci/pci-sh4.h              |    2 -
 arch/x86/kernel/pci-calgary_64.c           |    3 +-
 arch/x86/pci/common.c                      |   61 ------
 arch/x86/pci/pcbios.c                      |   72 -------
 arch/x86/pci/pci.h                         |    3 -
 drivers/ide/ide-scan-pci.c                 |    9 +-
 drivers/ide/ide.c                          |   12 -
 drivers/pci/bus.c                          |   15 +-
 drivers/pci/hotplug/Kconfig                |    4 +-
 drivers/pci/hotplug/cpcihp_generic.c       |    8 +-
 drivers/pci/probe.c                        |   56 ++----
 drivers/pci/remove.c                       |   10 +-
 drivers/pci/search.c                       |  313 +++++++++++-----------------
 include/asm-sh/mpc1211/pci.h               |    2 -
 include/linux/ide.h                        |    1 -
 include/linux/pci.h                        |   20 +--
 21 files changed, 159 insertions(+), 500 deletions(-)

---------------

Greg Kroah-Hartman (12):
      PCI: remove pci_find_present
      PCI: remove pci_get_device_reverse from calgary driver
      IDE: remove ide=reverse IDE core
      PCI: remove pci_get_device_reverse
      PCI: clean up search.c a lot
      PCI Hotplug: make cpcihp driver use modern apis
      PCI Hotplug: the ibm driver is not dependant on PCI_LEGACY
      PCI: remove initial bios sort of PCI devices on x86
      PCI: make no_pci_devices() use the pci_bus_type list
      PCI: add is_added flag to struct pci_dev
      PCI: remove pcibious_fixup_ghosts()
      PCI: remove global list of PCI devices


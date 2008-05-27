Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYE0Wz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYE0Wz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbYE0WzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:55:19 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:35278 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757602AbYE0WzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:55:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Tue, 27 May 2008 15:55:07 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271555.07912.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the PCI fixes:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Hopefully this'll be the last set of important fixes needed for 2.6.26.
Kenji-san tracked down and fixed several PCI hotplug problems, and Shaohua
fixed an interesting ASPM bug caused by a PCIe multifunction device that had
at least one non-PCIe sub-function.  One of the hotplug problems ended up
being a structural problem, so we'll probably have to rework the fix again
a bit more properly in 2.6.27 (once we figure out how we want to do it).

Thanks,
Jesse

Kenji Kaneshige (7):
      shpchp: add message about shpchp_slot_with_bus option
      pciehp: fix NULL dereference in interrupt handler
      pciehp: fix slow probing
      pciehp: poll cmd completion if hotplug interrupt is disabled
      pciehp: move msleep after power off
      pci hotplug core: add check of duplicate slot name
      pciehp: add message about pciehp_slot_with_bus option

Shaohua Li (1):
      PCI: don't enable ASPM on devices with mixed PCIe/PCI functions

 hotplug/pci_hotplug_core.c |    7 ++
 hotplug/pciehp.h           |   11 ++-
 hotplug/pciehp_core.c      |    6 +-
 hotplug/pciehp_ctrl.c      |   36 ++++++------
 hotplug/pciehp_hpc.c       |  129 ++++++++++++++++++++++++++++++++++-----------
 hotplug/shpchp_core.c      |    4 +
 pcie/aspm.c                |   20 ++++++
 7 files changed, 159 insertions(+), 54 deletions(-)

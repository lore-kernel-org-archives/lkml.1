Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbZBMUTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbZBMUTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZBMUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:18:55 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20501 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBMUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:18:54 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 00/12] PCI core learns hotplug
To: jbarnes@virtuousgeek.org
Cc: xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Feb 2009 13:18:53 -0700
Message-ID: <20090213201135.19262.67924.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Jesse asked me to send out some updated bits on this series to get
more early review. He notes that there is at least one patch out there
(Yuji Shimada's memory resource alignment) that would really like this.

Original discussion here:

	http://thread.gmane.org/gmane.linux.kernel.pci/2914

This is still a work-in-progress.

Known to work:
	- remove any device in PCI tree once, rescan to get it back
	- device seems to be functional. :)
	- can repeat above multiple times on non PCIe machines

Known to not work:
	- can't remove/rescan multiple times when PCIe port driver is loaded
	- hotplug drivers using pci_do_scan_bus may blow up

TODO:
	- fix known PCIe port driver bug
	- clean up hotplug drivers using pci_do_scan_bus
	- incorporate one more of Trent's patches, will probably replace
	  "Introduce /sys/bus/pci/rescan" since his implementation was nicer
	- remove ASPM patch once jbarnes's linux-next tree gets rebased ;)

Comments welcom.

Thanks.

/ac

v1 -> v2:	
	- incorporated lots of Trent Piepho's work
	- beefed up pci_do_scan_bus as heavy lifter for rescanning
	- small bugfixes folded into earlier patches to get everything working
---

Alex Chiang (8):
      PCI: more whitespace cleanups
      PCI Hotplug: schedule fakephp for feature removal
      PCI Hotplug: rename legacy_fakephp to fakephp
      PCI: Introduce /sys/bus/pci/devices/.../rescan
      PCI: Introduce /sys/bus/pci/rescan
      PCI: beef up pci_do_scan_bus()
      PCI: properly clean up ASPM link state on device remove
      PCI: always scan child buses

Trent Piepho (4):
      PCI Hotplug: restore fakephp interface with complete reimplementation
      PCI: Introduce /sys/bus/pci/devices/.../remove
      PCI: pci_scan_slot() returns newly found devices
      PCI: don't scan existing devices


 Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
 Documentation/feature-removal-schedule.txt |   32 ++
 Documentation/filesystems/sysfs-pci.txt    |    9 +
 drivers/pci/hotplug-pci.c                  |   16 +
 drivers/pci/hotplug/fakephp.c              |  443 +++++++---------------------
 drivers/pci/pci-sysfs.c                    |   96 +++++-
 drivers/pci/pcie/aspm.c                    |    4 
 drivers/pci/probe.c                        |   90 +++---
 drivers/pci/remove.c                       |    4 
 9 files changed, 323 insertions(+), 398 deletions(-)


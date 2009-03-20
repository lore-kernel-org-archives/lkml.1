Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZCTDYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZCTDYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZCTDYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:15421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZCTDYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042852"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 0/8] PCI: Linux kernel SR-IOV support
Date: Fri, 20 Mar 2009 11:25:10 +0800
Message-Id: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Following patches are intended to support SR-IOV capability in the
Linux kernel. With these patches, people can turn a PCI device with
the capability into multiple ones from software perspective, which
will benefit KVM and achieve other purposes such as QoS, security,
and etc.

SR-IOV specification can be found at:
  http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf
(it requires membership.)

Devices that support SR-IOV are available from following vendors:
  http://download.intel.com/design/network/ProdBrf/320025.pdf
  http://www.myri.com/vlsi/Lanai_Z8ES_Datasheet.pdf
  http://www.neterion.com/products/pdfs/X3100ProductBrief.pdf

The patches to enable the SR-IOV capability of Intel 82576 NIC are
available at (a.k.a Physical Function driver):
  http://patchwork.kernel.org/patch/8063/
  http://patchwork.kernel.org/patch/8064/
  http://patchwork.kernel.org/patch/8065/
  http://patchwork.kernel.org/patch/8066/
And the driver for Intel 82576 Virtual Function are available at:
  http://patchwork.kernel.org/patch/11029/
  http://patchwork.kernel.org/patch/11028/


Major changes from v11 to v12:
  1, fix using garbage entry pointer after the list_for_each (Matthew Wilcox)
  2, use #ifdef around SR-IOV structure in the pci_dev (Matthew Wilcox)
  3, enhance the Kconfig help text for the SR-IOV (Matthew Wilcox)

  v10 to v11:
  1, use pci_setup_device() to setup Virtual Function (Matthew Wilcox)
  2, various coding style fixes (Matthew Wilcox)
  3, wording and grammar fixes (Randy Dunlap)

  v9 -> v10:
  1, minor fix in pci_restore_iov_state().
  2, respin against the latest tree.

  v8 -> v9:
  1, put a might_sleep() into SR-IOV API which sleeps (Andi Kleen)
  2, block user config accesses before clearing VF Enable bit (Matthew Wilcox)

Yu Zhao (8):
  PCI: initialize and release SR-IOV capability
  PCI: restore saved SR-IOV state
  PCI: reserve bus range for SR-IOV device
  PCI: centralize device setup code
  PCI: add SR-IOV API for Physical Function driver
  PCI: handle SR-IOV Virtual Function Migration
  PCI: document SR-IOV sysfs entries
  PCI: manual for SR-IOV user and driver developer

 Documentation/ABI/testing/sysfs-bus-pci |   27 ++
 Documentation/DocBook/kernel-api.tmpl   |    1 +
 Documentation/PCI/pci-iov-howto.txt     |   99 +++++
 drivers/pci/Kconfig                     |   10 +
 drivers/pci/Makefile                    |    2 +
 drivers/pci/iov.c                       |  680 +++++++++++++++++++++++++++++++
 drivers/pci/pci.c                       |    8 +
 drivers/pci/pci.h                       |   53 +++
 drivers/pci/probe.c                     |   86 +++--
 include/linux/pci.h                     |   34 ++
 include/linux/pci_regs.h                |   33 ++
 11 files changed, 994 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt
 create mode 100644 drivers/pci/iov.c


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZBJJED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZBJJED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBJJD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:03:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:4649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZBJJDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:03:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,185,1233561600"; 
   d="scan'208";a="488749243"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v8 0/7] PCI: Linux kernel SR-IOV support
Date: Tue, 10 Feb 2009 16:59:08 +0800
Message-Id: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
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
http://www.neterion.com/products/x3100.html

Physical Function driver for Intel 82576 NIC (based on drivers/net/igb/)
will come in few weeks.

Major changes from v7 to v8:
1, simplified the API for the PF driver
2, split the code and respin them against the latest tree

Yu Zhao (7):
  PCI: initialize and release SR-IOV capability
  PCI: restore saved SR-IOV state
  PCI: reserve bus range for SR-IOV device
  PCI: add SR-IOV API for Physical Function driver
  PCI: handle SR-IOV Virtual Function Migration
  PCI: document SR-IOV sysfs entries
  PCI: manual for SR-IOV user and driver developer

 Documentation/ABI/testing/sysfs-bus-pci |   27 ++
 Documentation/DocBook/kernel-api.tmpl   |    1 +
 Documentation/PCI/pci-iov-howto.txt     |  106 +++++
 drivers/pci/Kconfig                     |   13 +
 drivers/pci/Makefile                    |    3 +
 drivers/pci/iov.c                       |  692 +++++++++++++++++++++++++++++++
 drivers/pci/pci.c                       |    8 +
 drivers/pci/pci.h                       |   53 +++
 drivers/pci/probe.c                     |    7 +
 include/linux/pci.h                     |   28 ++
 include/linux/pci_regs.h                |   33 ++
 11 files changed, 971 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt
 create mode 100644 drivers/pci/iov.c


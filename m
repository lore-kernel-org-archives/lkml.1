Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYJUMgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYJUMgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYJUMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:35:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:18226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYJUMf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:35:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453859013"
Date: Tue, 21 Oct 2008 19:40:56 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       rdreier@cisco.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/15 v5] PCI: Linux kernel SR-IOV support
Message-ID: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Following patches are intended to support SR-IOV capability in the
Linux kernel. With these patches, people can turn a PCI device with
the capability into multiple ones from software perspective, which
will benefit KVM and achieve other purposes such as QoS, security,
and etc.

Major changes between v4 -> v5:
1, remove interfaces for PF driver to create sysfs entries (Matthew Wilcox)
2, get ride of 'struct kobject' used in 'struct pci_iov' (Greg KH)
3, split big chunk of code into more patches
4, add boot options to reassign resources under a bus
5, add boot option to align MMIO resources of a device

---

[PATCH 1/15 v5] PCI: remove unnecessary arg of pci_update_resource()
[PATCH 2/15 v5] PCI: define PCI resource names in an 'enum'
[PATCH 3/15 v5] PCI: export __pci_read_base
[PATCH 4/15 v5] PCI: make pci_alloc_child_bus() be able to handle bridge device
[PATCH 5/15 v5] PCI: add a wrapper for resource_alignment()
[PATCH 6/15 v5] PCI: add a new function to map BAR offset
[PATCH 7/15 v5] PCI: cleanup pcibios_allocate_resources()
[PATCH 8/15 v5] PCI: add boot option to reassign resources
[PATCH 9/15 v5] PCI: add boot option to align MMIO resource
[PATCH 10/15 v5] PCI: cleanup pci_bus_add_devices()
[PATCH 11/15 v5] PCI: split a new function from pci_bus_add_devices()
[PATCH 12/15 v5] PCI: support the SR-IOV capability
[PATCH 13/15 v5] PCI: reserve bus range for the SR-IOV device
[PATCH 14/15 v5] PCI: document the changes
[PATCH 15/15 v5] PCI: document the new PCI boot parameters

---

Single Root I/O Virtualization (SR-IOV) capability defined by PCI-SIG
is intended to enable multiple system software to share PCI hardware
resources.  PCI device that supports this capability can be extended
to one Physical Functions plus multiple Virtual Functions. Physical
Function, which could be considered as the "real" PCI device, reflects
the hardware instance and manages all physical resources. Virtual
Functions are associated with a Physical Function and shares physical
resources with the Physical Function.Software can control allocation of
Virtual Functions via registers encapsulated in the capability structure.

SR-IOV specification can be found at
http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Devices that support SR-IOV are available from following vendors:
http://download.intel.com/design/network/ProdBrf/320025.pdf
http://www.netxen.com/products/chipsolutions/NX3031.html
http://www.neterion.com/products/x3100.html

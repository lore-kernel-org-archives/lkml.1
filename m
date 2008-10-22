Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYJVJdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYJVJdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYJVJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:33:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:59636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYJVJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="454253967"
Date: Wed, 22 Oct 2008 16:38:09 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: linux-pci@vger.kernel.org
Cc: achiang@hp.com, grundler@parisc-linux.org, greg@kroah.com, mingo@elte.hu,
       jbarnes@virtuousgeek.org, matthew@wil.cx, randy.dunlap@oracle.com,
       rdreier@cisco.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
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

Changes from v5 to v6:
1, update ABI document to include SR-IOV sysfs entries (Greg KH)
2, fix two coding style problems (Ingo Molnar)

---

[PATCH 1/16 v6] PCI: remove unnecessary arg of pci_update_resource()
[PATCH 2/16 v6] PCI: define PCI resource names in an 'enum'
[PATCH 3/16 v6] PCI: export __pci_read_base
[PATCH 4/16 v6] PCI: make pci_alloc_child_bus() be able to handle NULL bridge
[PATCH 5/16 v6] PCI: add a wrapper for resource_alignment()
[PATCH 6/16 v6] PCI: add a new function to map BAR offset
[PATCH 7/16 v6] PCI: cleanup pcibios_allocate_resources()
[PATCH 8/16 v6] PCI: add boot options to reassign resources
[PATCH 9/16 v6] PCI: add boot option to align MMIO resources
[PATCH 10/16 v6] PCI: cleanup pci_bus_add_devices()
[PATCH 11/16 v6] PCI: split a new function from pci_bus_add_devices()
[PATCH 12/16 v6] PCI: support the SR-IOV capability
[PATCH 13/16 v6] PCI: reserve bus range for SR-IOV device
[PATCH 14/16 v6] PCI: document for SR-IOV user and developer
[PATCH 15/16 v6] PCI: document the SR-IOV sysfs entries
[PATCH 16/16 v6] PCI: document the new PCI boot parameters

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

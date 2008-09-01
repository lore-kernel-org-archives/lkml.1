Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbYIALWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbYIALWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbYIALVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:21:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:9651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759008AbYIALVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,307,1217833200"; 
   d="scan'208";a="40044610"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 4/4 v2] PCI: document the change
Date: Mon, 1 Sep 2008 19:21:06 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177EB70@pdsmsx414.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4 v2] PCI: document the change
Thread-Index: AckMJNNs4wGff54MSr+UTWjd37C7Zw==
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 01 Sep 2008 11:21:08.0848 (UTC) FILETIME=[D4FD0F00:01C90C24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete the hotplug ABI document, and add SR-IOV HOWTO.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Signed-off-by: Eddie Dong <eddie.dong@intel.com>

---
 Documentation/ABI/testing/sysfs-bus-pci |   67 ++++++++++++
 Documentation/DocBook/kernel-api.tmpl   |    3 +
 Documentation/PCI/pci-iov-howto.txt     |  177 +++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/PCI/pci-iov-howto.txt

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..374e87b 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -9,3 +9,70 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
+
+What:		/sys/bus/pci/slots/.../power
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates power status of a slot, and could be written
+		to enable or disable the slot.
+
+What:		/sys/bus/pci/slots/.../attention
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates attention LED status of a slot, and could
+		be written to set the LED status.
+
+What:		/sys/bus/pci/slots/.../latch
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates latch status of a slot.
+
+What:		/sys/bus/pci/slots/.../adapter
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates presence of the adapter.
+
+What:		/sys/bus/pci/slots/.../max_bus_speed
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates max bus speed of a slot.
+
+What:		/sys/bus/pci/slots/.../cur_bus_speed
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It indicates current bus speed of a slot.
+
+What:		/sys/bus/pci/slots/.../test
+Date:		Unknown
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It triggers adapter hardware test upon writing.
+
+What:		/sys/bus/pci/slots/.../param
+Date:		August 2008
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This file will appear when PCI hotplug is enabled and
+		the hotplug driver supports this operation.
+		It holds device specific parameters, and could be written
+		to configure the adapter in a slot.
diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index b7b1482..36273af 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -239,6 +239,7 @@ X!Ekernel/module.c
      </sect1>
 
      <sect1><title>PCI Support Library</title>
+!Iinclude/linux/pci.h
 !Edrivers/pci/pci.c
 !Edrivers/pci/pci-driver.c
 !Edrivers/pci/remove.c
@@ -251,6 +252,8 @@ X!Edrivers/pci/hotplug.c
 -->
 !Edrivers/pci/probe.c
 !Edrivers/pci/rom.c
+!Edrivers/pci/ari.c
+!Edrivers/pci/iov.c
      </sect1>
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
new file mode 100644
index 0000000..147e80f
--- /dev/null
+++ b/Documentation/PCI/pci-iov-howto.txt
@@ -0,0 +1,177 @@
+		PCI Express Single Root I/O Virtualization HOWTO
+			Copyright (C) 2008 Intel Corporation
+			    Yu Zhao <yu.zhao@intel.com>
+
+
+1. Overview
+
+1.1 What is SR-IOV
+
+Single Root I/O Virtualization (SR-IOV) is a PCI Express Extended
+capability which makes one physical device appear as multiple virtual
+devices. The physical device is referred to as Physical Function while
+the virtual devices are referred to as Virtual Functions. Allocation
+of Virtual Functions can be dynamically controlled by Physical Function
+via registers encapsulated in the capability. By default, this feature
+is not enabled and the Physical Function behaves as traditional PCIe
+device. Once it's turned on, each Virtual Function's PCI configuration
+space can be accessed by its own Bus, Device and Function Number (Routing
+ID). And each Virtual Function also has PCI Memory Space, which is used
+to map its register set. Virtual Function device driver operates on the
+register set so it can be functional and appear as a real existing PCI
+device.
+
+1.2 What is ARI
+
+Alternative Routing-ID Interpretation (ARI) allows a PCI Express Endpoint
+to use its device number field as part of function number. Traditionally,
+an Endpoint can only have 8 functions, and the device number of all
+Endpoints is zero. With ARI enabled, an Endpoint can have up to 256
+functions by using device number in conjunction with function number to
+indicate a function in the device. This is almost transparent to the Linux
+kernel because the Linux kernel still can use 8-bit bus number field plus
+8-bit devfn number field to locate a function. ARI is managed via the ARI
+Forwarding bit in the Device Capabilities 2 register of the PCI Express
+Capability on the Root Port or the Downstream Port and a new ARI Capability
+on the Endpoint.
+
+
+2. User Guide
+
+2.1 How can I manage SR-IOV
+
+If a device supports SR-IOV, then there should be some entires under
+/sys/bus/pci/slots/. The names of the entires are XXXX:BB:DD.F-iov-NNNN,
+where the first part (XXXX:BB:DD.F) is the domain, bus, device and function
+number of the device, and the third part (NNNN) is the index of a Virtual
+Function. There are three files under the entry: power, param and address.
+	- Writing 1 to the "power" will enable the Virtual Function,
+	and 0 will disable the Virtual Function; Reading it will get
+	status of the Virtual Function.
+	- Reading the "address" will get the bus, device and function
+	number of the Virtual Function.
+	- The "param" is the device specific parameters which may be
+	used by the Physical or Virtual Functions drivers.
+
+2.2 How can I use Virtual Functions
+
+Virtual Functions is treated as hot-plugged PCI devices in the kernel,
+so they should be able to work in the same way as real PCI devices.
+NOTE: Virtual Function device driver must be loaded to make it work.
+
+
+3. Developer Guide
+
+3.1 SR-IOV APIs
+
+To enable SR-IOV, Physical Function device driver needs to call:
+	int pci_iov_enable(struct pci_dev *dev, 
+			   int (*cb)(struct pci_dev *, int, int, char *))
+The pointer to the callback function could be NULL if Physical Function
+wants to ignore the events.
+
+To disable SR-IOV, Physical Function device driver needs to call:
+	void pci_iov_disable(struct pci_dev *dev)
+
+NOTE: these two functions sleeps 1 second waiting on hardware transaction
+completion according to SR-IOV specification.
+
+3.2 Usage example
+
+Following piece of code illustrates the usage of APIs above.
+
+static int callback(struct pci_dev *dev, int event, int arg, char *param)
+{
+	int err;
+
+	switch (event) {
+	case PCI_IOV_VF_ENABLE:
+		/*
+		 * request to enable a Virtual Function, setup hardware
+		 * resource to this Virtual Function if needed.
+		 */
+		break;
+	case PCI_IOV_VF_DISABLE:
+		/*
+		 * a Virtual Function has been disabled, reclaim hardware
+		 * resource if needed.
+		 */
+		break;
+	case PCI_IOV_VF_SETPARAM:
+		/*
+		 * parameter of a Virtual Function has been changed, take
+		 * corresponding actions if needed.
+		 */
+		break;
+	case PCI_IOV_VF_GETPARAM:
+		/*
+		 * return the parameters of a Virtual Function if any.
+		 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return err;
+}
+
+static int __devinit dev_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	int err;
+
+	...
+
+	err = pci_iov_enable(dev, callback);
+	if (err)
+		return err;
+
+	...
+}
+
+static void __devexit dev_remove(struct pci_dev *dev)
+{
+	...
+
+	pci_iov_disable(dev);
+
+	...
+}
+
+#ifdef CONFIG_PM
+/*
+ * If the device supports the power management, then the SR-IOV
+ * may be disabled before the adapter goes to sleep, because
+ * Virtual Functions may not work when the adapter is in the\
+ * power-saving mode.
+ * The SR-IOV can be enabled again after the adapter wakes up.
+ */
+static int dev_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	...
+
+	pci_iov_disable(dev);
+
+	...
+}
+
+static int dev_resume(struct pci_dev *dev)
+{
+	...
+
+	pci_iov_enable(dev, nvfs, callback);
+
+	...
+}
+#endif
+
+static struct pci_driver dev_driver = {
+	.name =		"SR-IOV PF driver",
+	.id_table =	dev_id_table,
+	.probe =	dev_probe,
+	.remove =	__devexit_p(dev_remove),
+#ifdef CONFIG_PM
+	.suspend =	dev_suspend,
+	.resume =	dev_resume,
+#endif
+};
-- 
1.5.6.4


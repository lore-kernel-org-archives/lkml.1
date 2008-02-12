Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbYBLArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbYBLArW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYBLArN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:47:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:51940 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYBLArL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,335,1199692800"; 
   d="scan'208";a="516894475"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2.6.25-rc1] i2c-i801: SMBus patch for Intel ICH10 DeviceID's
Date: Mon, 11 Feb 2008 16:45:17 -0800
Message-ID: <39B20DF628532344BC7A2692CB6AEE07024DFA4C@orsmsx420.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.25-rc1] i2c-i801: SMBus patch for Intel ICH10 DeviceID's
Thread-Index: AchtEIlswgrAuJ1bRsWcwCsmgxnjZQ==
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: <khali@linux-fr.org>, <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
       "Gaston, Jason D" <jason.d.gaston@intel.com>, <i2c@lm-sensors.org>
X-OriginalArrivalTime: 12 Feb 2008 00:45:21.0343 (UTC) FILETIME=[8BDC3CF0:01C86D10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 SMBus Controller DeviceID's and updates
Tolapai support.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>


--- linux-2.6.25-rc1/Documentation/i2c/busses/i2c-i801.orig
2008-02-11 15:17:33.000000000 -0800
+++ linux-2.6.25-rc1/Documentation/i2c/busses/i2c-i801	2008-02-11
15:18:13.000000000 -0800
@@ -12,8 +12,9 @@
   * Intel 82801G (ICH7)
   * Intel 631xESB/632xESB (ESB2)
   * Intel 82801H (ICH8)
-  * Intel ICH9
+  * Intel 82801I (ICH9)
   * Intel Tolapai
+  * Intel ICH10
    Datasheets: Publicly available at the Intel website
 
 Authors: 
--- linux-2.6.25-rc1/drivers/i2c/busses/i2c-i801.c.orig	2008-02-11
15:10:52.000000000 -0800
+++ linux-2.6.25-rc1/drivers/i2c/busses/i2c-i801.c	2008-02-11
16:30:11.000000000 -0800
@@ -40,7 +40,9 @@
   82801G   (ICH7)       0x27da     32     hard     yes     yes     yes
   82801H   (ICH8)       0x283e     32     hard     yes     yes     yes
   82801I   (ICH9)       0x2930     32     hard     yes     yes     yes
-  Tolapai               0x5032     32     hard     yes     ?       ?
+  Tolapai               0x5032     32     hard     yes     yes     yes
+  ICH10                 0x3a30     32     hard     yes     yes     yes
+  ICH10                 0x3a60     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -588,6 +590,8 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1)
},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4)
},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5)
},
 	{ 0, }
 };
 
@@ -608,10 +612,12 @@
 	case PCI_DEVICE_ID_INTEL_ESB2_17:
 	case PCI_DEVICE_ID_INTEL_ICH8_5:
 	case PCI_DEVICE_ID_INTEL_ICH9_6:
+	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
+	case PCI_DEVICE_ID_INTEL_ICH10_4:
+	case PCI_DEVICE_ID_INTEL_ICH10_5:
 		i801_features |= FEATURE_I2C_BLOCK_READ;
 		/* fall through */
 	case PCI_DEVICE_ID_INTEL_82801DB_3:
-	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
 		i801_features |= FEATURE_SMBUS_PEC;
 		i801_features |= FEATURE_BLOCK_BUFFER;
 		break;
--- linux-2.6.25-rc1/drivers/i2c/busses/Kconfig.orig	2008-02-11
15:10:18.000000000 -0800
+++ linux-2.6.25-rc1/drivers/i2c/busses/Kconfig	2008-02-11
16:32:10.000000000 -0800
@@ -177,6 +177,8 @@
 	    ESB2
 	    ICH8
 	    ICH9
+	    Tolapai
+	    ICH10
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- linux-2.6.25-rc1/include/linux/pci_ids.h.orig	2008-02-11
15:18:58.000000000 -0800
+++ linux-2.6.25-rc1/include/linux/pci_ids.h	2008-02-11
15:20:45.000000000 -0800
@@ -2373,6 +2373,12 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
+#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
+#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
+#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
+#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
+#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025Ab0AMBD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0AMBD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154Ab0AMBDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:03:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:64670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0AMBDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:03:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232068311"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org, khali@linux-fr.org, i2c@lm-sensors.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.32.3] i2c-i801: SMBus patch for Intel Cougar Point DeviceIDs
Date: Tue, 12 Jan 2010 16:58:53 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001121658.54044.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Cougar Point (PCH) SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c	2010-01-07 13:10:28.000000000 -0800
@@ -41,7 +41,8 @@
   Tolapai               0x5032     32     hard     yes     yes     yes
   ICH10                 0x3a30     32     hard     yes     yes     yes
   ICH10                 0x3a60     32     hard     yes     yes     yes
-  PCH                   0x3b30     32     hard     yes     yes     yes
+  3400/5 Series (PCH)   0x3b30     32     hard     yes     yes     yes
+  CPT                   0x1c22     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -578,6 +579,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CPT_SMBUS) },
 	{ 0, }
 };
 
@@ -707,6 +709,7 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_4:
 	case PCI_DEVICE_ID_INTEL_ICH10_5:
 	case PCI_DEVICE_ID_INTEL_PCH_SMBUS:
+	case PCI_DEVICE_ID_INTEL_CPT_SMBUS:
 		i801_features |= FEATURE_I2C_BLOCK_READ;
 		/* fall through */
 	case PCI_DEVICE_ID_INTEL_82801DB_3:
--- linux-2.6.32.3/drivers/i2c/busses/Kconfig.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/drivers/i2c/busses/Kconfig	2010-01-07 13:10:28.000000000 -0800
@@ -98,6 +98,7 @@
 	    Tolapai
 	    ICH10
 	    PCH
+	    CPT
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.

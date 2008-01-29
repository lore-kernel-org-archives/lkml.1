Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbYA2A0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbYA2A0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYA2A0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:26:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYA2A0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:26:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331190587"
From: Jason Gaston <jason.d.gaston@intel.com>
To: khali@linux-fr.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jason.d.gaston@intel.com, i2c@lm-sensors.org
Subject: [PATCH 2.6.24] i2c-i801: SMBus patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:28:13 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281728.13627.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 SMBus Controller DeviceID's

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/Documentation/i2c/busses/i2c-i801.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/Documentation/i2c/busses/i2c-i801	2008-01-28 15:29:26.000000000 -0800
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
--- linux-2.6.24/drivers/i2c/busses/Kconfig.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/drivers/i2c/busses/Kconfig	2008-01-28 14:58:22.000000000 -0800
@@ -177,6 +177,8 @@
 	    ESB2
 	    ICH8
 	    ICH9
+	    Tolapai
+	    ICH10
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- linux-2.6.24/drivers/i2c/busses/i2c-i801.c.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/drivers/i2c/busses/i2c-i801.c	2008-01-28 14:58:22.000000000 -0800
@@ -35,6 +35,8 @@
     ICH8		283E
     ICH9		2930
     Tolapai		5032
+    ICH10		3A30
+    ICH10		3A60
     This driver supports several versions of Intel's I/O Controller Hubs (ICH).
     For SMBus support, they are similar to the PIIX4 and are part
     of Intel's '810' and other chipsets.
@@ -545,6 +547,8 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
 	{ 0, }
 };
 

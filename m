Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYHHW5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYHHW5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYHHW5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:57:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:58689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbYHHW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:57:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="324552748"
From: Seth Heasley <seth.heasley@intel.com>
To: khali@linux-fr.org, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: [PATCH 2.6.26.2] i2c-i801: SMBus patch for Intel Ibex Peak DeviceIDs
Date: Fri, 8 Aug 2008 16:02:28 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081602.28479.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) SMBus Controller DeviceIDs.

Signed-off by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c.orig   2008-08-08 11:28:08.000000000 -0700
+++ linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c        2008-08-08 11:32:18.000000000 -0700
@@ -43,6 +43,7 @@
   Tolapai               0x5032     32     hard     yes     yes     yes
   ICH10                 0x3a30     32     hard     yes     yes     yes
   ICH10                 0x3a60     32     hard     yes     yes     yes
+  PCH                   0x3b30     32     hard     yes     yes     yes

   Features supported by this driver:
   Software PEC                     no
@@ -592,6 +593,7 @@
        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
+       { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_2) },
        { 0, }
 };

@@ -615,6 +617,7 @@
        case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
        case PCI_DEVICE_ID_INTEL_ICH10_4:
        case PCI_DEVICE_ID_INTEL_ICH10_5:
+       case PCI_DEVICE_ID_INTEL_PCH_2:
                i801_features |= FEATURE_I2C_BLOCK_READ;
                /* fall through */
        case PCI_DEVICE_ID_INTEL_82801DB_3:
--- linux-2.6.26.2/drivers/i2c/busses/Kconfig.orig      2008-08-08 11:27:52.000000000 -0700
+++ linux-2.6.26.2/drivers/i2c/busses/Kconfig   2008-08-08 11:30:42.000000000 -0700
@@ -182,6 +182,7 @@
            ICH9
            Tolapai
            ICH10
+           PCH

          This driver can also be built as a module.  If so, the module
          will be called i2c-i801.

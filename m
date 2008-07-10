Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYGJGkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYGJGkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYGJGkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:40:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:26083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbYGJGkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,336,1212390000"; 
   d="scan'208,223";a="351318181"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Add Bridge Configuration Retry bit in PCIE Control
Date: Thu, 10 Jul 2008 14:41:25 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200807101145.43839.sheng.yang@intel.com>
In-Reply-To: <200807101145.43839.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_V8adIUoECD+Q+P8"
Message-Id: <200807101441.25611.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_V8adIUoECD+Q+P8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Updated patch with FLR capability indicated bit...

=46rom a6478de8d190a0343580023aa93c968e6b369c51 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Thu, 10 Jul 2008 14:39:13 +0800
Subject: [PATCH] PCI: Add Function Level Reset related bits

The bit 28 in PCI-E Capability Register indicated Function Level Reset
capability.

The bit 15 in PCI-E Control Register is Bridge Configuration Retry=20
Reset and
Initiate Function Level Reset bit.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 include/linux/pci_regs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index c0c1223..b656d22 100644
=2D-- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -375,6 +375,7 @@
 #define  PCI_EXP_DEVCAP_PWR_IND	0x4000	/* Power Indicator Present */
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x3fc0000 /* Slot Power Limit Value=20
*/
 #define  PCI_EXP_DEVCAP_PWR_SCL	0xc000000 /* Slot Power Limit Scale=20
*/
+#define  PCI_EXP_DEVCAP_FLR     0x10000000 /* Function Level Reset */
 #define PCI_EXP_DEVCTL		8	/* Device Control */
 #define  PCI_EXP_DEVCTL_CERE	0x0001	/* Correctable Error Reporting=20
En. */
 #define  PCI_EXP_DEVCTL_NFERE	0x0002	/* Non-Fatal Error Reporting=20
Enable */
@@ -387,6 +388,7 @@
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable=20
*/
 #define  PCI_EXP_DEVCTL_NOSNOOP_EN 0x0800  /* Enable No Snoop */
 #define  PCI_EXP_DEVCTL_READRQ	0x7000	/* Max_Read_Request_Size */
+#define  PCI_EXP_DEVCTL_BCR_FLR 0x8000  /* Bridge Configuration=20
Retry / FLR */
 #define PCI_EXP_DEVSTA		10	/* Device Status */
 #define  PCI_EXP_DEVSTA_CED	0x01	/* Correctable Error Detected */
 #define  PCI_EXP_DEVSTA_NFED	0x02	/* Non-Fatal Error Detected */
=2D-
1.5.6


--Boundary-00=_V8adIUoECD+Q+P8
Content-Type: text/x-diff;
  charset="utf-8";
  name="0001-PCI-Add-Function-Level-Reset-related-bits.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-PCI-Add-Function-Level-Reset-related-bits.patch"

=46rom a6478de8d190a0343580023aa93c968e6b369c51 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Thu, 10 Jul 2008 14:39:13 +0800
Subject: [PATCH] PCI: Add Function Level Reset related bits

The bit 28 in PCI-E Capability Register indicated Function Level Reset
capability.

The bit 15 in PCI-E Control Register is Bridge Configuration Retry Reset and
Initiate Function Level Reset bit.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 include/linux/pci_regs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index c0c1223..b656d22 100644
=2D-- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -375,6 +375,7 @@
 #define  PCI_EXP_DEVCAP_PWR_IND	0x4000	/* Power Indicator Present */
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x3fc0000 /* Slot Power Limit Value */
 #define  PCI_EXP_DEVCAP_PWR_SCL	0xc000000 /* Slot Power Limit Scale */
+#define  PCI_EXP_DEVCAP_FLR     0x10000000 /* Function Level Reset */
 #define PCI_EXP_DEVCTL		8	/* Device Control */
 #define  PCI_EXP_DEVCTL_CERE	0x0001	/* Correctable Error Reporting En. */
 #define  PCI_EXP_DEVCTL_NFERE	0x0002	/* Non-Fatal Error Reporting Enable */
@@ -387,6 +388,7 @@
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable */
 #define  PCI_EXP_DEVCTL_NOSNOOP_EN 0x0800  /* Enable No Snoop */
 #define  PCI_EXP_DEVCTL_READRQ	0x7000	/* Max_Read_Request_Size */
+#define  PCI_EXP_DEVCTL_BCR_FLR 0x8000  /* Bridge Configuration Retry / FL=
R */
 #define PCI_EXP_DEVSTA		10	/* Device Status */
 #define  PCI_EXP_DEVSTA_CED	0x01	/* Correctable Error Detected */
 #define  PCI_EXP_DEVSTA_NFED	0x02	/* Non-Fatal Error Detected */
=2D-=20
1.5.6


--Boundary-00=_V8adIUoECD+Q+P8--

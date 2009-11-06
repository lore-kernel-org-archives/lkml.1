Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbZKFWeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbZKFWeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbZKFWeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:34:11 -0500
Received: from kroah.org ([198.145.64.141]:56932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbZKFWXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:46 2009
Message-Id: <20091106221546.733836681@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Fabian Henze <hoacha@quantentunnel.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [58/99] agp/intel: Add B43 chipset support
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=agp-intel-add-b43-chipset-support.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Fabian Henze <hoacha@quantentunnel.de>

commit 38d8a95621b20ed7868e232a35a26ee61bdcae6f upstream.

Signed-off-by: Fabian Henze <hoacha@quantentunnel.de>
[Fix reversed HB & IG ids for B43]
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -36,6 +36,8 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
+#define PCI_DEVICE_ID_INTEL_B43_HB          0x2E40
+#define PCI_DEVICE_ID_INTEL_B43_IG          0x2E42
 #define PCI_DEVICE_ID_INTEL_GM45_HB         0x2A40
 #define PCI_DEVICE_ID_INTEL_GM45_IG         0x2A42
 #define PCI_DEVICE_ID_INTEL_IGD_E_HB        0x2E00
@@ -81,6 +83,7 @@
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G41_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_D_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_M_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_MA_HB)
@@ -1232,6 +1235,7 @@ static void intel_i965_get_gtt_range(int
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
 	case PCI_DEVICE_ID_INTEL_G41_HB:
+	case PCI_DEVICE_ID_INTEL_B43_HB:
 	case PCI_DEVICE_ID_INTEL_IGDNG_D_HB:
 	case PCI_DEVICE_ID_INTEL_IGDNG_M_HB:
 	case PCI_DEVICE_ID_INTEL_IGDNG_MA_HB:
@@ -2208,6 +2212,8 @@ static const struct intel_driver_descrip
 	    "Q45/Q43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G45_HB, PCI_DEVICE_ID_INTEL_G45_IG, 0,
 	    "G45/G43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_B43_HB, PCI_DEVICE_ID_INTEL_B43_IG, 0,
+	    "B43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G41_HB, PCI_DEVICE_ID_INTEL_G41_IG, 0,
 	    "G41", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IGDNG_D_HB, PCI_DEVICE_ID_INTEL_IGDNG_D_IG, 0,
@@ -2408,6 +2414,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G41_HB),
+	ID(PCI_DEVICE_ID_INTEL_B43_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_D_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_MA_HB),



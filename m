Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZLGARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZLGARw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZLGARq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:17:46 -0500
Received: from kroah.org ([198.145.64.141]:34738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614AbZLGAN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:58 2009
Message-Id: <20091207000658.451137393@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [101/119] agp/intel: new host bridge support
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=agp-intel-new-host-bridge-support.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 9cf1e35cb025eaa52dde37df38e2750b6adb1620 upstream.

Add new CPU host bridge id, needed for support Ironlake graphics
device with it. No change for graphics device itself, so no need to
update drm/i915.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -52,6 +52,7 @@
 #define PCI_DEVICE_ID_INTEL_IGDNG_D_IG	    0x0042
 #define PCI_DEVICE_ID_INTEL_IGDNG_M_HB	    0x0044
 #define PCI_DEVICE_ID_INTEL_IGDNG_MA_HB	    0x0062
+#define PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB    0x006a
 #define PCI_DEVICE_ID_INTEL_IGDNG_M_IG	    0x0046
 
 /* cover 915 and 945 variants */
@@ -86,7 +87,8 @@
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_D_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_M_HB || \
-		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_MA_HB)
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_MA_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB)
 
 extern int agp_memory_reserved;
 
@@ -1239,6 +1241,7 @@ static void intel_i965_get_gtt_range(int
 	case PCI_DEVICE_ID_INTEL_IGDNG_D_HB:
 	case PCI_DEVICE_ID_INTEL_IGDNG_M_HB:
 	case PCI_DEVICE_ID_INTEL_IGDNG_MA_HB:
+	case PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB:
 		*gtt_offset = *gtt_size = MB(2);
 		break;
 	default:
@@ -2222,6 +2225,8 @@ static const struct intel_driver_descrip
 	    "IGDNG/M", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IGDNG_MA_HB, PCI_DEVICE_ID_INTEL_IGDNG_M_IG, 0,
 	    "IGDNG/MA", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB, PCI_DEVICE_ID_INTEL_IGDNG_M_IG, 0,
+	    "IGDNG/MC2", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -2418,6 +2423,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_D_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGDNG_MA_HB),
+	ID(PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB),
 	{ }
 };
 



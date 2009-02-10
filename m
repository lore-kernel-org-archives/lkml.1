Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZBJTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZBJTMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbZBJTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:52 -0500
Received: from kroah.org ([198.145.64.141]:53858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbZBJTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:51 -0500
Date: Tue, 10 Feb 2009 11:00:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: [patch 24/53] agp/intel: add support for G41 chipset
Message-ID: <20090210190031.GY14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="agp-intel-add-support-for-g41-chipset.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Zhenyu Wang <zhenyu.z.wang@intel.com>

commit a50ccc6c6623ab0e64f2109881e07c176b2d876f upstream.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -40,6 +40,8 @@
 #define PCI_DEVICE_ID_INTEL_Q45_IG          0x2E12
 #define PCI_DEVICE_ID_INTEL_G45_HB          0x2E20
 #define PCI_DEVICE_ID_INTEL_G45_IG          0x2E22
+#define PCI_DEVICE_ID_INTEL_G41_HB          0x2E30
+#define PCI_DEVICE_ID_INTEL_G41_IG          0x2E32
 
 /* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
@@ -63,7 +65,8 @@
 #define IS_G4X (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_E_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q45_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB || \
-		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB)
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G41_HB)
 
 extern int agp_memory_reserved;
 
@@ -1196,6 +1199,7 @@ static void intel_i965_get_gtt_range(int
 	case PCI_DEVICE_ID_INTEL_IGD_E_HB:
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
+	case PCI_DEVICE_ID_INTEL_G41_HB:
 		*gtt_offset = *gtt_size = MB(2);
 		break;
 	default:
@@ -2163,6 +2167,8 @@ static const struct intel_driver_descrip
 	    "Q45/Q43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G45_HB, PCI_DEVICE_ID_INTEL_G45_IG, 0,
 	    "G45/G43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_G41_HB, PCI_DEVICE_ID_INTEL_G41_IG, 0,
+	    "G41", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -2360,6 +2366,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_IGD_E_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
+	ID(PCI_DEVICE_ID_INTEL_G41_HB),
 	{ }
 };
 


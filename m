Return-Path: <linux-kernel-owner+w=401wt.eu-S935204AbYBVVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbYBVVsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbYBVVnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:46505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbYBVVn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:28 -0500
Date: Fri, 22 Feb 2008 13:40:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Dave Airlie <airlied@redhat.com>,
       Takashi Iwai <tiwai@suse.de>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 10/23] Intel_agp: really fix 945/965GME
Message-ID: <20080222214030.GK8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="intel_agp-really-fix-945-965gme.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Wang Zhenyu <zhenyu.z.wang@intel.com>

mainline: dde4787642ee3cb85aef80bdade04b6f8ddc3df8

Fix some missing places to check with device id info, which
should probe the device gart correctly.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -20,7 +20,9 @@
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
 #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
+#define PCI_DEVICE_ID_INTEL_82965GME_HB     0x2A10
 #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
+#define PCI_DEVICE_ID_INTEL_82945GME_HB     0x27AC
 #define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
 #define PCI_DEVICE_ID_INTEL_G33_HB          0x29C0
 #define PCI_DEVICE_ID_INTEL_G33_IG          0x29C2
@@ -33,7 +35,8 @@
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB)
 
 #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -527,6 +530,7 @@ static void intel_i830_init_gtt_entries(
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
 			    IS_I965 || IS_G33)
 				gtt_entries = MB(48) - KB(size);
 			else
@@ -538,6 +542,7 @@ static void intel_i830_init_gtt_entries(
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
 			    IS_I965 || IS_G33)
 				gtt_entries = MB(64) - KB(size);
 			else
@@ -1848,9 +1853,9 @@ static const struct intel_driver_descrip
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
 		NULL, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1, "945GM",
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 0, "945GM",
 		NULL, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
+	{ PCI_DEVICE_ID_INTEL_82945GME_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
 		NULL, &intel_i965_driver },
@@ -1860,9 +1865,9 @@ static const struct intel_driver_descrip
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
 		NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 0, "965GM",
 		NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
+	{ PCI_DEVICE_ID_INTEL_82965GME_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
@@ -2051,11 +2056,13 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_82915GM_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_82945GME_HB),
 	ID(PCI_DEVICE_ID_INTEL_82946GZ_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_82965GME_HB),
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),

-- 

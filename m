Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXGTCwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXGTCwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXGTCwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:52:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:28201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXGTCwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,559,1175497200"; 
   d="scan'208";a="270572934"
Date: Fri, 20 Jul 2007 10:52:44 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>
Subject: [AGPGART] intel_agp: fix ids for 945GME, 965GME
Message-ID: <20070720025244.GA8518@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] [AGPGART] intel_agp: fix ids for 945GME and 965GME

These chipsets actually have new host bridge ids. This should fix the gart
init problem on them. Please apply, thanks.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a124060..86a7e11 100644
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
@@ -1848,9 +1850,9 @@ static const struct intel_driver_description {
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
@@ -1860,9 +1862,9 @@ static const struct intel_driver_description {
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
-- 
1.5.2.3

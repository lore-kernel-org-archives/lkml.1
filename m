Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXIEHNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXIEHNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbXIEHMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:12:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:19883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXIEHMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:12:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,210,1186383600"; 
   d="scan'208";a="293557111"
Date: Wed, 5 Sep 2007 15:11:52 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
Message-ID: <20070905071152.GA5817@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33

G33 GTT stolen memory is below graphics data
stolen memory and be seperate, so don't subtract
it in stolen mem counting.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 2c9ca2c..20d50d0 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		}
 	} else {
+		/* G33's GTT stolen memory is seperate from gfx data
+		 * stolen memory.
+		 */
+	        if (IS_G33)
+		    size = 0;
 		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
-- 
1.5.2.3

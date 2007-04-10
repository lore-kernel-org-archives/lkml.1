Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXDJBos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXDJBos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXDJBor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:44:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:36731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030297AbXDJBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="227417440:sNHT17352818"
Date: Tue, 10 Apr 2007 09:42:48 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>
Subject: [PATCH] intel_agp: fix G965 GTT size detect
Message-ID: <20070410014248.GA17932@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
	Keith Packard <keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave, 

On G965, I810_PGETBL_CTL is a mmio offset, but we wrongly take it
as pci config space offset in detecting GTT size. This one line patch
fixs this. 

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>

---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a9fdbf9..4c05c71 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -431,9 +431,8 @@ static void intel_i830_init_gtt_entries(
 
 	if (IS_I965) {
 		u32 pgetbl_ctl;
-
-		pci_read_config_dword(agp_bridge->dev, I810_PGETBL_CTL,
-				      &pgetbl_ctl);
+		pgetbl_ctl = readl(intel_i830_private.registers+I810_PGETBL_CTL);
+		    	
 		/* The 965 has a field telling us the size of the GTT,
 		 * which may be larger than what is necessary to map the
 		 * aperture.
---

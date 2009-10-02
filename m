Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZJBBvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZJBBvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbZJBBvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:51:44 -0400
Received: from kroah.org ([198.145.64.141]:33195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZJBBdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.634855529@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [061/136] drm/i915: Fix SSC frequence for IGDNG
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-ssc-frequence-for-igdng.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 339e5a4c78041cd7b473ddf0a81eb06a131127bb upstream.

IGDNG LVDS SSC uses 120Mhz freq. This fixes one
1600x900 LVDS panel black issue on IGDNG with SSC enabled.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_bios.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -217,6 +217,9 @@ parse_general_features(struct drm_i915_p
 			if (IS_I85X(dev_priv->dev))
 				dev_priv->lvds_ssc_freq =
 					general->ssc_freq ? 66 : 48;
+			else if (IS_IGDNG(dev_priv->dev))
+				dev_priv->lvds_ssc_freq =
+					general->ssc_freq ? 100 : 120;
 			else
 				dev_priv->lvds_ssc_freq =
 					general->ssc_freq ? 100 : 96;



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZHMUM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZHMUM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZHMT71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:27 -0400
Received: from kroah.org ([198.145.64.141]:41691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZHMT70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195127.465882440@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ma Ling <ling.ma@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [patch 20/74] drm/i915: Set SSC frequency for 8xx chips correctly
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0007-drm-i915-Set-SSC-frequency-for-8xx-chips-correctly.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ma Ling <ling.ma@intel.com>

(cherry picked from commit 6ff4fd05676bc5b5c930bef25901e489f7843660)

All 8xx class chips have the 66/48 split, not just 855.

Signed-off-by: Ma Ling <ling.ma@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_bios.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -185,10 +185,12 @@ parse_general_features(struct drm_i915_p
 		dev_priv->lvds_use_ssc = general->enable_ssc;
 
 		if (dev_priv->lvds_use_ssc) {
-		  if (IS_I855(dev_priv->dev))
-		    dev_priv->lvds_ssc_freq = general->ssc_freq ? 66 : 48;
-		  else
-		    dev_priv->lvds_ssc_freq = general->ssc_freq ? 100 : 96;
+			if (IS_I85X(dev_priv->dev))
+				dev_priv->lvds_ssc_freq =
+					general->ssc_freq ? 66 : 48;
+			else
+				dev_priv->lvds_ssc_freq =
+					general->ssc_freq ? 100 : 96;
 		}
 	}
 }



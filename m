Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZDNPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZDNPKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZDNPKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:10:44 -0400
Received: from mail.southpole.se ([193.12.106.18]:37253 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbZDNPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:10:44 -0400
From: Jonas Bonn <jonas@southpole.se>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [drm] Remove duplicated code
Date: Tue, 14 Apr 2009 16:50:20 +0200
Message-Id: <1239720620-6082-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239720620-6082-1-git-send-email-jonas@southpole.se>
References: <1239720620-6082-1-git-send-email-jonas@southpole.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In apparent haste to generalize, the old version got left behind.  This patch
removes the old version and cleans up the generalization in the new one.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/gpu/drm/i915/intel_display.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 64773ce..3148cda 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1836,12 +1836,6 @@ static void intel_setup_outputs(struct drm_device *dev)
 		int found;
 		u32 reg;
 
-		if (I915_READ(SDVOB) & SDVO_DETECTED) {
-			found = intel_sdvo_init(dev, SDVOB);
-			if (!found && SUPPORTS_INTEGRATED_HDMI(dev))
-				intel_hdmi_init(dev, SDVOB);
-		}
-
 		/* Before G4X SDVOC doesn't have its own detect register */
 		if (IS_G4X(dev))
 			reg = SDVOC;
@@ -1849,9 +1843,9 @@ static void intel_setup_outputs(struct drm_device *dev)
 			reg = SDVOB;
 
 		if (I915_READ(reg) & SDVO_DETECTED) {
-			found = intel_sdvo_init(dev, SDVOC);
+			found = intel_sdvo_init(dev, reg);
 			if (!found && SUPPORTS_INTEGRATED_HDMI(dev))
-				intel_hdmi_init(dev, SDVOC);
+				intel_hdmi_init(dev, reg);
 		}
 	} else
 		intel_dvo_init(dev);
-- 
1.6.0.4



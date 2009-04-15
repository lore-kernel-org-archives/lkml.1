Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZDOQuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZDOQuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZDOQtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:49:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38468 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZDOQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:49:52 -0400
Date: Wed, 15 Apr 2009 17:49:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness with hotkeys (BISECTED)
Message-ID: <20090415164939.GA27807@srcf.ucam.org>
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5234E.5070303@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this help?

diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 6942772..8dc1fd3 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -370,11 +370,8 @@ int intel_opregion_init(struct drm_device *dev, int resume)
 	if (mboxes & MBOX_ACPI) {
 		DRM_DEBUG("Public ACPI methods supported\n");
 		opregion->acpi = base + OPREGION_ACPI_OFFSET;
-		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		if (drm_core_check_feature(dev, DRIVER_MODESET))
 			intel_didl_outputs(dev);
-			if (!resume)
-				acpi_video_register();
-		}
 	} else {
 		DRM_DEBUG("Public ACPI methods not supported\n");
 		err = -ENOTSUPP;
@@ -391,6 +388,10 @@ int intel_opregion_init(struct drm_device *dev, int resume)
 		opregion->asle = base + OPREGION_ASLE_OFFSET;
 	}
 
+	if (!resume)
+		acpi_video_register();
+
+
 	/* Notify BIOS we are ready to handle ACPI video ext notifs.
 	 * Right now, all the events are handled by the ACPI video module.
 	 * We don't actually need to do anything with them. */

-- 
Matthew Garrett | mjg59@srcf.ucam.org

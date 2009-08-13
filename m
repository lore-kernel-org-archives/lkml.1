Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZHMT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZHMT72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZHMT70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:26 -0400
Received: from kroah.org ([198.145.64.141]:41684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZHMT7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195127.189458281@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: [patch 18/74] drm/i915: Hook connector to encoder during load detection (fixes tv/vga detect)
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0005-drm-i915-Hook-connector-to-encoder-during-load-detec.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

(cherry picked from commit 03d6069912babc07a3da20e715dd6a5dc8f0f867)

With the DRM-driven DPMS code, encoders are considered idle unless a
connector is hooked to them, so mode setting is skipped. This makes load
detection fail as none of the hardware is enabled.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_display.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1590,6 +1590,7 @@ struct drm_crtc *intel_get_load_detect_p
 	}
 
 	encoder->crtc = crtc;
+	intel_output->base.encoder = encoder;
 	intel_output->load_detect_temp = true;
 
 	intel_crtc = to_intel_crtc(crtc);
@@ -1625,6 +1626,7 @@ void intel_release_load_detect_pipe(stru
 
 	if (intel_output->load_detect_temp) {
 		encoder->crtc = NULL;
+		intel_output->base.encoder = NULL;
 		intel_output->load_detect_temp = false;
 		crtc->enabled = drm_helper_crtc_in_use(crtc);
 		drm_helper_disable_unused_functions(dev);



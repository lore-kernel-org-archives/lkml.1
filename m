Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbZKFWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbZKFWeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbZKFWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:34:12 -0500
Received: from kroah.org ([198.145.64.141]:56925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760203AbZKFWXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:46 2009
Message-Id: <20091106221546.595113397@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [57/99] drm/i915: fix panel fitting filter coefficient select for Ironlake
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-panel-fitting-filter-coefficient-select-for-ironlake.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit b1f60b7029989da71fd8ea1b1176480fac9e846c upstream.

Must set filter selection as hardcoded coefficients for medium 3x3
filtering, which matches vbios setting for Ironlake.

This fixes display corrupt issue on HP arrandale with new vbios.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    5 +++++
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1871,6 +1871,11 @@
 #define PFA_CTL_1               0x68080
 #define PFB_CTL_1               0x68880
 #define  PF_ENABLE              (1<<31)
+#define  PF_FILTER_MASK		(3<<23)
+#define  PF_FILTER_PROGRAMMED	(0<<23)
+#define  PF_FILTER_MED_3x3	(1<<23)
+#define  PF_FILTER_EDGE_ENHANCE	(2<<23)
+#define  PF_FILTER_EDGE_SOFTEN	(3<<23)
 #define PFA_WIN_SZ		0x68074
 #define PFB_WIN_SZ		0x68874
 #define PFA_WIN_POS		0x68070
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1213,7 +1213,7 @@ static void igdng_crtc_dpms(struct drm_c
 		/* Enable panel fitting for LVDS */
 		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
 			temp = I915_READ(pf_ctl_reg);
-			I915_WRITE(pf_ctl_reg, temp | PF_ENABLE);
+			I915_WRITE(pf_ctl_reg, temp | PF_ENABLE | PF_FILTER_MED_3x3);
 
 			/* currently full aspect */
 			I915_WRITE(pf_win_pos, 0);



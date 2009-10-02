Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZJBBu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZJBBu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZJBBdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:21 -0400
Received: from kroah.org ([198.145.64.141]:33200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZJBBdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.786651207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [062/136] drm/i915: Remove DAC disable in CRT force detect on IGDNG
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-remove-dac-disable-in-crt-force-detect-on-igdng.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 730915d65f9e763de9dc26c5f1b8abaae775b243 upstream.

This is not required on newer stepping hardware to get
reliable force detect status. Removing this fixes screen
blank flicker in CRT detect on IGDNG.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_crt.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -151,13 +151,10 @@ static bool intel_igdng_crt_detect_hotpl
 {
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 adpa, temp;
+	u32 adpa;
 	bool ret;
 
-	temp = adpa = I915_READ(PCH_ADPA);
-
-	adpa &= ~ADPA_DAC_ENABLE;
-	I915_WRITE(PCH_ADPA, adpa);
+	adpa = I915_READ(PCH_ADPA);
 
 	adpa &= ~ADPA_CRT_HOTPLUG_MASK;
 
@@ -184,8 +181,6 @@ static bool intel_igdng_crt_detect_hotpl
 	else
 		ret = false;
 
-	/* restore origin register */
-	I915_WRITE(PCH_ADPA, temp);
 	return ret;
 }
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0BSRTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:19:10 -0500
Received: from kroah.org ([198.145.64.141]:57369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0BSRAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:32 2010
Message-Id: <20100219163232.379550796@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [10/93] drm/i915: disable hotplug detect before Ironlake CRT detect
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit eceb784cec4dc0fcc2993d9ee4a7c0d111ada80a upstream.

This tries to fix CRT detect loop hang seen on some Ironlake form
factor, to clear up hotplug detect state before taking CRT detect
to make sure next hotplug detect cycle is consistent.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_crt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -185,6 +185,9 @@ static bool intel_igdng_crt_detect_hotpl
 	adpa = I915_READ(PCH_ADPA);
 
 	adpa &= ~ADPA_CRT_HOTPLUG_MASK;
+	/* disable HPD first */
+	I915_WRITE(PCH_ADPA, adpa);
+	(void)I915_READ(PCH_ADPA);
 
 	adpa |= (ADPA_CRT_HOTPLUG_PERIOD_128 |
 			ADPA_CRT_HOTPLUG_WARMUP_10MS |



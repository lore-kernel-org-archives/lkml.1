Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZGAOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZGAOVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZGAOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:21:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38649 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZGAOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:21:33 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andy Whitcroft <apw@canonical.com>, Dave Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] i915: fix up a raw 64bit divide
Date: Wed,  1 Jul 2009 15:20:59 +0100
Message-Id: <1246458059-15965-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.rc3.199.g24398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing compilation failures on i386 in some environments due
to an undefined reference as below:

    ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!

This is generated due to a raw 64 bit divide in the i915 driver.  Fix up
this raw divide.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 73e7b9c..9f79de3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1574,7 +1574,7 @@ igdng_compute_m_n(int bytes_per_pixel, int nlanes,
 
 	temp = (u64) DATA_N * pixel_clock;
 	temp = div_u64(temp, link_clock);
-	m_n->gmch_m = (temp * bytes_per_pixel) / nlanes;
+	m_n->gmch_m = div_u64(temp * bytes_per_pixel, nlanes);
 	m_n->gmch_n = DATA_N;
 	fdi_reduce_ratio(&m_n->gmch_m, &m_n->gmch_n);
 
-- 
1.6.3.rc3.199.g24398


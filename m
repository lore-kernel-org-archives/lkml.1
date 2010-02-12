Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab0BLWlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:41:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:44587 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab0BLWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:50 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 4/7] i915: when kgdb is active display compression should be off
Date: Fri, 12 Feb 2010 16:36:25 -0600
Message-Id: <1266014188-29505-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:26.0643 (UTC) FILETIME=[3B498030:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the HW compression is left on, the call backs from the HW will
crash the kernel.  The only time this code is called is when kernel
mode setting is in use with kgdb and the kdb shell.

The atomic display pipe handler callback will reset everything when
kgdb restores kernel to the run state.

CC: David Airlie <airlied@linux.ie>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 088b8bd..21e9597 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1210,6 +1210,10 @@ static void intel_update_fbc(struct drm_crtc *crtc,
 		goto out_disable;
 	}
 
+	/* If the kernel debugger is active, always disable compression */
+	if (in_dbg_master())
+		goto out_disable;
+
 	if (dev_priv->display.fbc_enabled(crtc)) {
 		/* We can re-enable it in this case, but need to update pitch */
 		if (fb->pitch > dev_priv->cfb_pitch)
-- 
1.6.4.rc1


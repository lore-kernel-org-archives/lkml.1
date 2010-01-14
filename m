Return-Path: <linux-kernel-owner+w=401wt.eu-S932244Ab0ANPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0ANPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217Ab0ANPBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:01:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:47839 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab0ANPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 34/40] i915: when kgdb is active display compression should be off
Date: Thu, 14 Jan 2010 08:59:30 -0600
Message-Id: <1263481176-1897-35-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:15.0819 (UTC) FILETIME=[6B7FE7B0:01CA952A]
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
index d54df76..11beb0f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1146,6 +1146,10 @@ static void intel_update_fbc(struct drm_crtc *crtc,
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
1.6.3.1.9.g95405b


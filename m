Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZLGAY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZLGAY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbZLGAYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:24:47 -0500
Received: from kroah.org ([198.145.64.141]:34536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbZLGAN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:52 2009
Message-Id: <20091207000652.647886780@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>
Subject: [070/119] drm: work around EDIDs with bad htotal/vtotal values
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=drm-work-around-edids-with-bad-htotal-vtotal-values.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 7064fef56369c9e2c6e35ff6d6b4b63d42a859ce upstream.

We did this on the userspace side, but we need a similar fix for the
kernel.

Fixes LP #460664.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -333,6 +333,12 @@ static struct drm_display_mode *drm_mode
 	mode->vsync_end = mode->vsync_start + vsync_pulse_width;
 	mode->vtotal = mode->vdisplay + vblank;
 
+	/* Some EDIDs have bogus h/vtotal values */
+	if (mode->hsync_end > mode->htotal)
+		mode->htotal = mode->hsync_end + 1;
+	if (mode->vsync_end > mode->vtotal)
+		mode->vtotal = mode->vsync_end + 1;
+
 	drm_mode_set_name(mode);
 
 	if (pt->misc & DRM_EDID_PT_INTERLACED)



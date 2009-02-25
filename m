Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZBYBce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZBYBce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbZBYBcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:32:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZBYBb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:31:57 -0500
Date: Tue, 24 Feb 2009 20:31:53 -0500
From: Kyle McMartin <kyle@infradead.org>
To: airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       jbarnes@virtuousgeek.org, marko.ristola@kolumbus.fi
Subject: [PATCH] drm: edid revision 0 is valid
Message-ID: <20090225013153.GC6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

edid->revision == 0 should be valid (at least, so the error message
indicates. :) and wikipedia seems to indicate that EDID 1.0 existed.

We can dump the entire check, since edid->revision is a u8, so
it can't ever be less than 0.

Marko reports in RH bz#476735 that his monitor claims to be
EDID 1.0, and therefore hits the check and is stuck at 800x600 because
of it.

Reported-by: Marko Ristola <marko.ristola@kolumbus.fi>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 5a4d324..ec14dd8 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -125,7 +125,7 @@ static bool edid_is_valid(struct edid *edid)
 		DRM_ERROR("EDID has major version %d, instead of 1\n", edid->version);
 		goto bad;
 	}
-	if (edid->revision <= 0 || edid->revision > 3) {
+	if (edid->revision > 3) {
 		DRM_ERROR("EDID has minor version %d, which is not between 0-3\n", edid->revision);
 		goto bad;
 	}

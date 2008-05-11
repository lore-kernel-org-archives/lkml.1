Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYEKTtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYEKTtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYEKTtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:49:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:39797 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYEKTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=BWVqkC0oLQ1kSpMH/EqEyeqF8stfV2HctE47zVBrxD6gdPzwbOFPrbpLgXp5CD9aC/u7K77948Pb5OX2UlX1eJAavpvhkmCwrrHx3xlRNzZvI7b4sM/snoRFjObaac7iGGHJbgj+HETzT67gKwmS6djecfUktYYE9ah/fzVSjF0=
Date: Sun, 11 May 2008 21:49:10 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm/radeon: radeon_enable_vblank should return negative
	error
Message-ID: <20080511194906.GA19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_enable_vblank <- drm_vblank_get <- drm_wait_vblank 
and drm_wait_vblank returns negative values on error

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
compile tested only
---
 drivers/char/drm/radeon_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/radeon_irq.c b/drivers/char/drm/radeon_irq.c
--- a/drivers/char/drm/radeon_irq.c
+++ b/drivers/char/drm/radeon_irq.c
@@ -59,7 +59,7 @@ int radeon_enable_vblank(struct drm_device *dev, int crtc)
 	default:
 		DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
 			  crtc);
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	return 0;
-- 
